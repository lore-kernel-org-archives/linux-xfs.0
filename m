Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q54EeC7N236914 for <xfs@oss.sgi.com>; Mon, 4 Jun 2012 09:40:13 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WCaDbg3fAVwh4DBm for
	<xfs@oss.sgi.com>; Mon, 04 Jun 2012 07:40:11 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q54Ee98G028647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2012 10:40:09 -0400
Received: from laptop.bfoster (vpn-10-46.rdu.redhat.com [10.11.10.46])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q54Ee7Ni024863
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2012 10:40:08 -0400
Message-ID: <4FCCC897.9080200@redhat.com>
Date: Mon, 04 Jun 2012 10:39:19 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: re-enable xfsaild idle mode and fix associated races
References: <1337875602-63025-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On 05/24/2012 12:06 PM, Brian Foster wrote:
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

FYI, I've done a decent amount of testing at this point and can no
longer reproduce the original lockups due to idle mode. I can still
reproduce the sync worker lockup in the xfs tree, but I verify that
xfsaild is actually still running in that case (thus it's a different
issue). Unless there are other objections, this patch seems good to me.
Thanks.

Brian

>  fs/xfs/xfs_trans_ail.c  |   29 ++++++++++++++++++++++++++---
>  fs/xfs/xfs_trans_priv.h |    1 +
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 9c51448..0819cd3 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -383,6 +383,12 @@ xfsaild_push(
>  	}
>  
>  	spin_lock(&ailp->xa_lock);
> +
> +	/* barrier matches the xa_target update in xfs_ail_push() */
> +	smp_rmb();
> +	target = ailp->xa_target;
> +	ailp->xa_target_prev = target;
> +
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
>  	if (!lip) {
>  		/*
> @@ -397,7 +403,6 @@ xfsaild_push(
>  	XFS_STATS_INC(xs_push_ail);
>  
>  	lsn = lip->li_lsn;
> -	target = ailp->xa_target;
>  	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
>  		int	lock_result;
>  
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
> +
> +		__set_current_state(TASK_RUNNING);
>  
>  		try_to_freeze();
>  
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index fb62377..53b7c9b 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -67,6 +67,7 @@ struct xfs_ail {
>  	struct task_struct	*xa_task;
>  	struct list_head	xa_ail;
>  	xfs_lsn_t		xa_target;
> +	xfs_lsn_t		xa_target_prev;
>  	struct list_head	xa_cursors;
>  	spinlock_t		xa_lock;
>  	xfs_lsn_t		xa_last_pushed_lsn;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
