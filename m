Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MNFING027543 for <xfs@oss.sgi.com>; Tue, 22 May 2012 18:15:18 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4QoFxH1gUOGrSIXF for <xfs@oss.sgi.com>;
	Tue, 22 May 2012 16:15:16 -0700 (PDT)
Date: Wed, 23 May 2012 09:15:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 3/3] xfs: fix xfsaild hang due to lost wake ups
Message-ID: <20120522231513.GJ25351@dastard>
References: <1337620886-41807-1-git-send-email-bfoster@redhat.com>
	<1337620886-41807-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1337620886-41807-4-git-send-email-bfoster@redhat.com>
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

On Mon, May 21, 2012 at 01:21:26PM -0400, Brian Foster wrote:
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
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_trans_ail.c  |    4 ++--
>  fs/xfs/xfs_trans_priv.h |    1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 5818076..35ae0d3 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -576,7 +576,7 @@ xfs_ail_push(
>  
>  	lip = xfs_ail_min(ailp);
>  	if (!lip || XFS_FORCED_SHUTDOWN(ailp->xa_mount) ||
> -	    XFS_LSN_CMP(threshold_lsn, ailp->xa_target) <= 0)
> +	    ((XFS_LSN_CMP(threshold_lsn, ailp->xa_target) <= 0) && !ailp->xa_pending_wake))
>  		return;
>  
>  	/*
> @@ -587,7 +587,7 @@ xfs_ail_push(
>  	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
>  	smp_wmb();
>  
> -	wake_up_process(ailp->xa_task);
> +	ailp->xa_pending_wake = !wake_up_process(ailp->xa_task);

That means xa_pending_wake is true when the aild is already running.

Which means that the above check for !ailp->xa_pending_wake mean
that we don't try a wakeup when the aild is not running. Is that
what you meant?

As it is, i don't think this is really all that sane - it has no
locking, so is going to be racy, and is really just working around
problems where the xfsaild goes to sleep without having completed
it's work. So if this patch is necessary, it is just papering over a
problem in the logic in the xfsaild where it is idling instead of
sleeping for a short time and starting again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
