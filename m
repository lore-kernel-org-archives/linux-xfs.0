Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39444 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdCPTRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 15:17:41 -0400
Date: Thu, 16 Mar 2017 12:17:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use dedicated log worker wq to avoid deadlock with
 cil wq
Message-ID: <20170316191734.GM5280@birch.djwong.org>
References: <1489083497-22964-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489083497-22964-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, David Jeffery <djeffery@redhat.com>

On Thu, Mar 09, 2017 at 01:18:17PM -0500, Brian Foster wrote:
> The log covering background task used to be part of the xfssyncd
> workqueue. That workqueue was removed as of commit 5889608df ("xfs:
> syncd workqueue is no more") and the associated work item scheduled
> to the xfs-log wq. The latter is used for log buffer I/O completion.
> 
> Since xfs_log_worker() can invoke a log flush, a deadlock is
> possible between the xfs-log and xfs-cil workqueues. Consider the
> following codepath from xfs_log_worker():
> 
> xfs_log_worker()
>   xfs_log_force()
>     _xfs_log_force()
>       xlog_cil_force()
>         xlog_cil_force_lsn()
>           xlog_cil_push_now()
>             flush_work()
> 
> The above is in xfs-log wq context and blocked waiting on the
> completion of an xfs-cil work item. Concurrently, the cil push in
> progress can end up blocked here:
> 
> xlog_cil_push_work()
>   xlog_cil_push()
>     xlog_write()
>       xlog_state_get_iclog_space()
>         xlog_wait(&log->l_flush_wait, ...)
> 
> The above is in xfs-cil context waiting on log buffer I/O
> completion, which executes in xfs-log wq context. In this scenario
> both workqueues are deadlocked waiting on eachother.
> 
> Add a new workqueue specifically for the high level log covering and
> ail pushing worker, as was the case prior to commit 5889608df.
> 
> Diagnosed-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Note that this seems difficult to reproduce in practice because I
> believe it also relies on memory pressure. Otherwise, the xfs-log wq
> rescuer thread may be available to unwind the deadlock.
> 
> Given that, one alternative approach I considered here is to use the
> rescuer thread check brought up in the other thread[1] regarding
> WQ_MEM_RECLAIM. I opted for this approach because I think the former is
> brittle in that it assumes context within the xfs_log_worker() code,
> adds non-determinism to the overall job of the background worker, and
> also doesn't address the fact that it's probably unnecessary to run this
> code at high priority.
> 
> Brian
> 
> [1] http://www.spinics.net/lists/linux-xfs/msg04673.html
> 
>  fs/xfs/xfs_log.c   | 2 +-
>  fs/xfs/xfs_mount.h | 1 +
>  fs/xfs/xfs_super.c | 8 ++++++++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b1469f0..bb58cd1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1293,7 +1293,7 @@ void
>  xfs_log_work_queue(
>  	struct xfs_mount        *mp)
>  {
> -	queue_delayed_work(mp->m_log_workqueue, &mp->m_log->l_work,
> +	queue_delayed_work(mp->m_sync_workqueue, &mp->m_log->l_work,
>  				msecs_to_jiffies(xfs_syncd_centisecs * 10));

I /think/ this looks ok?  But let me run it through xfstests before I
commit to anything. :)

--D

>  }
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 6db6fd6..22b2185 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -183,6 +183,7 @@ typedef struct xfs_mount {
>  	struct workqueue_struct	*m_reclaim_workqueue;
>  	struct workqueue_struct	*m_log_workqueue;
>  	struct workqueue_struct *m_eofblocks_workqueue;
> +	struct workqueue_struct	*m_sync_workqueue;
>  
>  	/*
>  	 * Generation of the filesysyem layout.  This is incremented by each
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 890862f..4bad410 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -877,8 +877,15 @@ xfs_init_mount_workqueues(
>  	if (!mp->m_eofblocks_workqueue)
>  		goto out_destroy_log;
>  
> +	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
> +					       mp->m_fsname);
> +	if (!mp->m_sync_workqueue)
> +		goto out_destroy_eofb;
> +
>  	return 0;
>  
> +out_destroy_eofb:
> +	destroy_workqueue(mp->m_eofblocks_workqueue);
>  out_destroy_log:
>  	destroy_workqueue(mp->m_log_workqueue);
>  out_destroy_reclaim:
> @@ -899,6 +906,7 @@ STATIC void
>  xfs_destroy_mount_workqueues(
>  	struct xfs_mount	*mp)
>  {
> +	destroy_workqueue(mp->m_sync_workqueue);
>  	destroy_workqueue(mp->m_eofblocks_workqueue);
>  	destroy_workqueue(mp->m_log_workqueue);
>  	destroy_workqueue(mp->m_reclaim_workqueue);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
