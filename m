Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q572OHTK027595 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 21:24:17 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bqfl0G3MwfBA17N8 for <xfs@oss.sgi.com>;
	Wed, 06 Jun 2012 19:24:15 -0700 (PDT)
Date: Thu, 7 Jun 2012 12:24:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: re-enable xfsaild idle mode and fix associated races
Message-ID: <20120607022412.GS22848@dastard>
References: <1337875602-63025-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1337875602-63025-1-git-send-email-bfoster@redhat.com>
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

On Thu, May 24, 2012 at 12:06:42PM -0400, Brian Foster wrote:
> xfsaild idle mode logic currently leads to a couple hangs:
> 
> 1.) If xfsaild is rescheduled in during an incremental scan
>     (i.e., tout != 0) and the target has been updated since
>     the previous run, we can hit the new target and go into
>     idle mode with a still populated ail.
> 2.) A wake up is only issued when the target is pushed forward.
>     The wake up can race with xfsaild if it is currently in the
>     process of entering idle mode, causing future wake up
>     events to be lost.
> 
> Both hangs are reproducible by running xfstests 273 in a loop.
> Modify xfsaild to enter idle mode only when the ail is empty
> and the push target has not been moved forward since the last
> push.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This is a lightly tested version against the xfs tree. I'll be more
> heavily testing a version based on my upstream reproducer tree over the
> next few days followed by similar testing on this patch if all goes
> well. Sending in advance for review.
> 
>  fs/xfs/xfs_trans_ail.c  |   29 ++++++++++++++++++++++++++---
>  fs/xfs/xfs_trans_priv.h |    1 +
>  2 files changed, 27 insertions(+), 3 deletions(-)

Looks OK but some minor formatting nits.

> @@ -527,8 +532,26 @@ xfsaild(
>  			__set_current_state(TASK_KILLABLE);
>  		else
>  			__set_current_state(TASK_INTERRUPTIBLE);
> -		schedule_timeout(tout ?
> -				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
> +
> +		spin_lock(&ailp->xa_lock);
> +
> +		/* barrier matches the xa_target update in xfs_ail_push() */
> +		smp_rmb();
> +		if (!xfs_ail_min(ailp) && (ailp->xa_target == ailp->xa_target_prev)) {
> +			/* the ail is empty and no change to the push target - idle */

I much prefer comments above the if() statement - the natural order
of reading something is top down - explain why, then do. iAlso,
there is no reason to write comments in abbreviated english - make
them verbose so that when you come back to this code in 2 years time
you can immediately understand why the code is like this from the
comment. So this:

		/*
		 * Idle if the ail is empty and we are not racing
		 * with a target update. The barrier matches the
		 * xa_target update in xfs_ail_push().
		 */
		smp_rmb();
		if (!xfs_ail_min(ailp) && (ailp->xa_target == ailp->xa_target_prev)) {

> +			spin_unlock(&ailp->xa_lock);
> +			schedule();
> +			tout = 0;
> +			continue;
> +		}
> +		spin_unlock(&ailp->xa_lock);
> +
> +		if (tout) {
> +			/* more work to do soon */
> +			schedule_timeout(msecs_to_jiffies(tout));
> +		}

And here I think this comment is redundant, because the code
is self documenting - if we have a timeout set, sleep for that
timeout, otherwise continue and do more work....

		if (tout)
			schedule_timeout(msecs_to_jiffies(tout));

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
