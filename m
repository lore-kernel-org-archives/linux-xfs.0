Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:34:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m757YOmc012985
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:34:25 -0700
Subject: TAKE 981498 - extend completions to provide XFS object flush requirements
Message-Id: <20080805073536.A587B58C52A4@chook.melbourne.sgi.com>
Date: Tue,  5 Aug 2008 17:35:36 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Date:  Tue Aug  5 17:34:21 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
david@fromorbit.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  2.6.x-xfs-melb:linux:31816a
include/linux/completion.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/include/linux/completion.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- extend completions to provide XFS object flush requirements
	  XFS object flushing doesn't quite match existing completion semantics.  It
	  mixed exclusive access with completion.  That is, we need to mark an object as
	  being flushed before flushing it to disk, and then block any other attempt to
	  flush it until the completion occurs.  We do this but adding an extra count to
	  the completion before we start using them.  However, we still need to
	  determine if there is a completion in progress, and allow no-blocking attempts
	  fo completions to decrement the count.
	  To do this we introduce:
	  int try_wait_for_completion(struct completion *x)
	  returns a failure status if done == 0, otherwise decrements done
	  to zero and returns a "started" status. This is provided
	  to allow counted completions to begin safely while holding
	  object locks in inverted order.
	  int completion_done(struct completion *x)
	  returns 1 if there is no waiter, 0 if there is a waiter
	  (i.e. a completion in progress).
	  This replaces the use of semaphores for providing this exclusion
	  and completion mechanism.
	  Signed-off-by: Dave Chinner <david@fromorbit.com>
