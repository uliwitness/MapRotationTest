//
//  MapRotationTestView.m
//  MapRotationTest
//
//  Created by Uli Kusterer on 2014-12-12.
//  Copyright (c) 2014 Uli Kusterer. All rights reserved.
//

#import "MapRotationTestView.h"


#define STEP_SIZE			10.0	// Each up/down arrow keypress moves you by 10 points. Same for sidestep with shift key.
#define NUM_ROTATION_STEPS	36.0	// 36 steps in 360 degrees means each left/right arrow press turns you by 10 degrees.


@implementation MapRotationTestView

-(id)	initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder: coder];
	if( self )
	{
		currPos = (NSPoint){ 200, 200 };
		currAngle = 0;
	}
	return self;
}


-(NSPoint)	rotatePoint: (NSPoint)originalPoint byAngle: (CGFloat)inAngle aroundPoint: (NSPoint)rotationCenter
{
	originalPoint.x -= rotationCenter.x;
	originalPoint.y -= rotationCenter.y;
	NSPoint	rotatedPoint;
	rotatedPoint.x = originalPoint.x * cosf(inAngle) - originalPoint.y * sinf(inAngle);
	rotatedPoint.y = originalPoint.y * cosf(inAngle) + originalPoint.x * sinf(inAngle);
	rotatedPoint.x += rotationCenter.x;
	rotatedPoint.y += rotationCenter.y;
	return rotatedPoint;
}


- (void)drawRect:(NSRect)dirtyRect
{
    NSPoint		topLeft = {100, 100}, topRight = { 300, 100 }, bottomRight = { 300, 200 }, bottomLeft = { 100, 200 };
	NSPoint		viewCenter = { self.bounds.size.width / 2, self.bounds.size.height / 2 };
	
	topLeft = [self rotatePoint: topLeft byAngle: currAngle aroundPoint: currPos];
	topRight = [self rotatePoint: topRight byAngle: currAngle aroundPoint: currPos];
	bottomRight = [self rotatePoint: bottomRight byAngle: currAngle aroundPoint: currPos];
	bottomLeft = [self rotatePoint: bottomLeft byAngle: currAngle aroundPoint: currPos];
	
	topLeft.x -= currPos.x -viewCenter.x;
	topLeft.y -= currPos.y -viewCenter.y;
	topRight.x -= currPos.x -viewCenter.x;
	topRight.y -= currPos.y -viewCenter.y;
	bottomRight.x -= currPos.x -viewCenter.x;
	bottomRight.y -= currPos.y -viewCenter.y;
	bottomLeft.x -= currPos.x -viewCenter.x;
	bottomLeft.y -= currPos.y -viewCenter.y;
	
	// Draw!
	[NSColor.grayColor set];
	NSBezierPath	*	thePath = [NSBezierPath bezierPath];
	[thePath moveToPoint: topLeft];
	[thePath lineToPoint: topRight];
	[thePath lineToPoint: bottomRight];
	[thePath lineToPoint: bottomLeft];
	[thePath lineToPoint: topLeft];
	[thePath fill];
	
	[NSColor.redColor set];
	NSPoint	indicatorPos = viewCenter;
//	NSPoint triA = [self rotatePoint: NSMakePoint(indicatorPos.x -10, indicatorPos.y +10) byAngle: (2 * M_PI) -currAngle aroundPoint: indicatorPos];
//	NSPoint triB = [self rotatePoint: NSMakePoint(indicatorPos.x +10, indicatorPos.y +10) byAngle: (2 * M_PI) -currAngle aroundPoint: indicatorPos];
//	NSPoint triC = [self rotatePoint: NSMakePoint(indicatorPos.x, indicatorPos.y -10) byAngle: (2 * M_PI) -currAngle aroundPoint: indicatorPos];
	NSPoint triA = NSMakePoint(indicatorPos.x -10, indicatorPos.y +10);
	NSPoint triB = NSMakePoint(indicatorPos.x +10, indicatorPos.y +10);
	NSPoint triC = NSMakePoint(indicatorPos.x, indicatorPos.y -10);
	NSBezierPath	*	playerPath = [NSBezierPath bezierPath];
	[playerPath moveToPoint: triA];
	[playerPath lineToPoint: triB];
	[playerPath lineToPoint: triC];
	[playerPath lineToPoint: triA];
	[playerPath fill];
}


-(BOOL)	isFlipped
{
	return YES;
}


-(BOOL)	acceptsFirstResponder
{
	return YES;
}


-(BOOL)	becomeFirstResponder
{
	return YES;
}


-(NSPoint)	translatePoint: (NSPoint)inPos byAngle: (CGFloat)inAngle distance: (CGFloat)inDistance
{
	NSPoint		newPos;
	newPos.x = inPos.x +(inDistance *sinf(inAngle));
	newPos.y = inPos.y +(inDistance *cosf(inAngle));
	return newPos;
}


-(void)	moveLeft: (id)sender
{
	if( [NSApplication.sharedApplication currentEvent].modifierFlags & NSShiftKeyMask )
	{
		currPos = [self translatePoint: currPos byAngle: currAngle +(M_PI / 2.0) distance: -STEP_SIZE];
	}
	else
	{
		currAngle += (M_PI * 2) / NUM_ROTATION_STEPS;
	}
	[self setNeedsDisplay: YES];
}


-(void)	moveRight: (id)sender
{
	if( [NSApplication.sharedApplication currentEvent].modifierFlags & NSShiftKeyMask )
	{
		currPos = [self translatePoint: currPos byAngle: currAngle +(M_PI / 2.0) distance: STEP_SIZE];
	}
	else
	{
		currAngle -= (M_PI * 2) / NUM_ROTATION_STEPS;
	}
	[self setNeedsDisplay: YES];
}


-(void)	moveUp: (id)sender
{
	currPos = [self translatePoint: currPos byAngle: currAngle distance: -STEP_SIZE];
	[self setNeedsDisplay: YES];
}


-(void)	moveDown: (id)sender
{
	currPos = [self translatePoint: currPos byAngle: currAngle distance: STEP_SIZE];
	[self setNeedsDisplay: YES];
}


@end
