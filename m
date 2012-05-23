Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4ND55Ul162320 for <xfs@oss.sgi.com>; Wed, 23 May 2012 08:05:06 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l3AVw19OaYXL3zqx for
	<xfs@oss.sgi.com>; Wed, 23 May 2012 06:05:04 -0700 (PDT)
Message-ID: <4FBCE081.7050003@redhat.com>
Date: Wed, 23 May 2012 09:05:05 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v3 2/2] xfs: fix xfsaild hang due to lost wake ups
References: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
	<1337704714-50235-3-git-send-email-bfoster@redhat.com>
	<20120523005830.GL25351@dastard>
In-Reply-To: <20120523005830.GL25351@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/22/2012 08:58 PM, Dave Chinner wrote:
snip

> 
> Hi Brian - here's kind of what I was thinking when we were talking
> on IRC. basically we move all the idling logic into xfsaild() to
> keep it out of xfsaild_push(), and make sure we only idle on an
> empty AIL when we haven't raced with a target update.
> 
> So, I was thinking that we add a previous target variable to the
> xfs_ail structure. Then xfsaild would become something like:
> 
> 
> 	while (!kthread_should_stop()) {
> 
> 		spin_lock(&ailp->xa_lock);
> 		__set_current_state(TASK_INTERRUPTIBLE);
> 
> 		/* barrier matches the xa_target update in xfs_ail_push() */
> 		smp_rmb();
> 		if (!xfs_ail_min(ailp) && ailp->xa_target == ailp->xa_prev_target) {

Ok... IIUC, two things can happen here: 1.) we either detect an xa_target update and continue on or 2.) if an _ail_push() occurs any time between now and when we schedule out, it will issue the wakeup successfully because we've already set the task state above (thus avoiding the race).

> 			/* empty ail, not change to push target - idle */
> 			spin_unlock(&ailp->xa_lock);
> 			schedule();
> 			tout = 0;
> 		}
> 		spin_unlock(&ailp->xa_lock);
> 
> 		if (tout) {
> 			/* more work to do soon */
> 			schedule_timeout(msecs_to_jiffies(tout));
> 		}
> 		__set_current_state(TASK_RUNNING);
> 
> 		try_to_freeze();
> 
> 		tout = xfsaild_push(ailp);
> 	}
> 
> And in xfsaild_push(), move where we sample the push target to before the cursor
> setup, and keep a snapshot of it:
> 
> 	/* barrier matches the xa_target update in xfs_ail_push() */
> 	smp_rmb();
> 	target = ailp->xa_target;
> 	ailp->xa_prev_target = target;
> 

The rest is pretty clear...

> This means we do not idle if a new push target was set while we were pushing,
> even if we emptied the AIL (call it paranoia!).
> 

Sounds reasonable. It looks like the only place we update the push target corresponds to a wake anyway, so this is probably not a departure from intended behavior.

> We can avoid the returning of a zero timeout from xfsaild_push, too,
> because the idling is not based on the state that we return from the
> push. Hence we always will return a 10, 20 or 50ms timeout and we
> can avoid complicating xfsaild_push logic with idling logic. i.e.
> the logic that is there right now should not need modification...
> 
> Finally, rather than calling wake_up_process() in the
> xfs_ail_push*() functions, call wake_up(&ailp->xa_idle); There can
> only be one thread sleeping on that (the xfsaild) so there is no
> need to use the wake_up_all() variant...
> 
> FWIW, you might be able to do this without the idle wait queue and
> just use wake_up_process() - 
> 

Ok... I'll look into using a wait queue once I have the basics working as is and put the whole thing through my reproducer. Thanks again!

Brian

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
