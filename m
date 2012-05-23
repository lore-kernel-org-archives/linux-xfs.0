Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4N0wZLl050813 for <xfs@oss.sgi.com>; Tue, 22 May 2012 19:58:35 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FxkrYTVbLDXxcfVh for <xfs@oss.sgi.com>;
	Tue, 22 May 2012 17:58:33 -0700 (PDT)
Date: Wed, 23 May 2012 10:58:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v3 2/2] xfs: fix xfsaild hang due to lost wake ups
Message-ID: <20120523005830.GL25351@dastard>
References: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
	<1337704714-50235-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1337704714-50235-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, May 22, 2012 at 12:38:34PM -0400, Brian Foster wrote:
> Running xfstests 273 in a loop reproduces an XFS lockup due to
> xfsaild entering idle mode indefinitely. The following
> high-level sequence of events leads to the hang:
> 
> - xfsaild is running with a cached target lsn
> - xfs_ail_push() is invoked, updates ailp->xa_target_lsn and
>   invokes wake_up_process(). wake_up_process() returns 0
>   because xfsaild is already running.
> - xfsaild enters idle mode having met its current target.
> 
> Once in the described state, xfs_ail_push() is invoked many
> more times with the already set threshold_lsn, but these calls
> do not lead to wake_up_process() calls because no further
> invocations result in moving the threshold_lsn forward. Add a
> flag to xfs_ail to capture whether an issued wake actually
> succeeds. If not, continue issuing wakes until we know one has
> been successful for the current target.

Hi Brian - here's kind of what I was thinking when we were talking
on IRC. basically we move all the idling logic into xfsaild() to
keep it out of xfsaild_push(), and make sure we only idle on an
empty AIL when we haven't raced with a target update.

So, I was thinking that we add a previous target variable to the
xfs_ail structure. Then xfsaild would become something like:


	while (!kthread_should_stop()) {

		spin_lock(&ailp->xa_lock);
		__set_current_state(TASK_INTERRUPTIBLE);

		/* barrier matches the xa_target update in xfs_ail_push() */
		smp_rmb();
		if (!xfs_ail_min(ailp) && ailp->xa_target == ailp->xa_prev_target) {
			/* empty ail, not change to push target - idle */
			spin_unlock(&ailp->xa_lock);
			schedule();
			tout = 0;
		}
		spin_unlock(&ailp->xa_lock);

		if (tout) {
			/* more work to do soon */
			schedule_timeout(msecs_to_jiffies(tout));
		}
		__set_current_state(TASK_RUNNING);

		try_to_freeze();

		tout = xfsaild_push(ailp);
	}

And in xfsaild_push(), move where we sample the push target to before the cursor
setup, and keep a snapshot of it:

	/* barrier matches the xa_target update in xfs_ail_push() */
	smp_rmb();
	target = ailp->xa_target;
	ailp->xa_prev_target = target;

This means we do not idle if a new push target was set while we were pushing,
even if we emptied the AIL (call it paranoia!).

We can avoid the returning of a zero timeout from xfsaild_push, too,
because the idling is not based on the state that we return from the
push. Hence we always will return a 10, 20 or 50ms timeout and we
can avoid complicating xfsaild_push logic with idling logic. i.e.
the logic that is there right now should not need modification...

Finally, rather than calling wake_up_process() in the
xfs_ail_push*() functions, call wake_up(&ailp->xa_idle); There can
only be one thread sleeping on that (the xfsaild) so there is no
need to use the wake_up_all() variant...

FWIW, you might be able to do this without the idle wait queue and
just use wake_up_process() - 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
