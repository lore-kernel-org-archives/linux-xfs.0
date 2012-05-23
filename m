Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4NHmsUn218827 for <xfs@oss.sgi.com>; Wed, 23 May 2012 12:48:54 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id E91kAYUId61FJjDI for
	<xfs@oss.sgi.com>; Wed, 23 May 2012 10:48:53 -0700 (PDT)
Message-ID: <4FBD2306.8090000@redhat.com>
Date: Wed, 23 May 2012 13:48:54 -0400
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
> Finally, rather than calling wake_up_process() in the
> xfs_ail_push*() functions, call wake_up(&ailp->xa_idle); There can
> only be one thread sleeping on that (the xfsaild) so there is no
> need to use the wake_up_all() variant...
> 
> FWIW, you might be able to do this without the idle wait queue and
> just use wake_up_process() - 
> 

Hi Dave,

I have a working version of your suggested algorithm. It looks mostly the same with the exception of a spin_unlock fix. I also have the below version that uses a wait_queue and that I plan to test overnight tonight:

	while (!kthread_should_stop()) {
		if (tout && tout <= 20)
			state = TASK_KILLABLE;
		else
			state = TASK_INTERRUPTIBLE;

		prepare_to_wait(&ailp->xa_idle, &wait, state);

		spin_lock(&ailp->xa_lock);
		/* barrier matches the xa_target update in xfs_ail_push() */
		smp_rmb();
		if (!xfs_ail_min(ailp) && (ailp->xa_target == ailp->xa_target_prev)) {
			/* the ail is empty and no change to the push target - idle */
			spin_unlock(&ailp->xa_lock);
			schedule();
		} else if (tout) {
			spin_unlock(&ailp->xa_lock);
			/* more work to do soon */
			schedule_timeout(msecs_to_jiffies(tout));
		} else {
			spin_unlock(&ailp->xa_lock);
		}

		finish_wait(&ailp->xa_idle, &wait);

		try_to_freeze();

		tout = xfsaild_push(ailp);
	}

... and obviously the xfs_ail_push() side changes to:

	wake_up(&ailp->xa_idle);

Does this wait_queue version look sane to you? Thanks again..

Brian

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
