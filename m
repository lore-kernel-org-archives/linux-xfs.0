Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GKSuog016812 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 14:28:56 -0600
Date: Thu, 16 Feb 2012 14:29:02 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 07/12] xfs: add xlog_grant_head_init
Message-ID: <20120216202902.GV7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.689066888@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141434.689066888@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Add xlog_grant_head_init() to initialize xlog_grant_head structures,
replacing the duplicated code in xlog_alloc_log.

Reviewed-by: Ben Myers <bpm@sgi.com>

On Mon, Dec 12, 2011 at 09:13:54AM -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_log.c |   18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:24:39.502740565 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:28:15.334904636 +0100
> @@ -150,6 +150,15 @@ xlog_grant_add_space(
>  	} while (head_val != old);
>  }
>  
> +STATIC void
> +xlog_grant_head_init(
> +	struct xlog_grant_head	*head)
> +{
> +	xlog_assign_grant_head(&head->grant, 1, 0);
> +	INIT_LIST_HEAD(&head->waiters);
> +	spin_lock_init(&head->lock);
> +}
> +
>  STATIC bool
>  xlog_reserveq_wake(
>  	struct log		*log,
> @@ -1070,12 +1079,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
>  	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
>  	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
> -	xlog_assign_grant_head(&log->l_reserve_head.grant, 1, 0);
> -	xlog_assign_grant_head(&log->l_write_head.grant, 1, 0);
> -	INIT_LIST_HEAD(&log->l_reserve_head.waiters);
> -	INIT_LIST_HEAD(&log->l_write_head.waiters);
> -	spin_lock_init(&log->l_reserve_head.lock);
> -	spin_lock_init(&log->l_write_head.lock);
> +
> +	xlog_grant_head_init(&log->l_reserve_head);
> +	xlog_grant_head_init(&log->l_write_head);
>  
>  	error = EFSCORRUPTED;
>  	if (xfs_sb_version_hassector(&mp->m_sb)) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
