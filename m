Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfEOMtY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:49:24 -0400
Date: Wed, 15 May 2019 08:49:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove the debug-only q_transp field from struct
 xfs_dquot
Message-ID: <20190515124922.GC2898@bfoster>
References: <20190515081045.3343-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515081045.3343-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 10:10:45AM +0200, Christoph Hellwig wrote:
> The field is only used for a few assertations.  Shrink the dqout
> structure instead, similarly to what commit f3ca87389dbf
> ("xfs: remove i_transp") did for the xfs_inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dquot.h       |  1 -
>  fs/xfs/xfs_dquot_item.c  |  5 -----
>  fs/xfs/xfs_trans_dquot.c | 10 ----------
>  3 files changed, 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 64bd8640f6e8..4fe85709d55d 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -34,7 +34,6 @@ typedef struct xfs_dquot {
>  	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
>  	struct list_head q_lru;		/* global free list of dquots */
>  	struct xfs_mount*q_mount;	/* filesystem this relates to */
> -	struct xfs_trans*q_transp;	/* trans this belongs to currently */
>  	uint		 q_nrefs;	/* # active refs from inodes */
>  	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
>  	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 7dedd17c4813..87b23ae44397 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -223,11 +223,6 @@ xfs_qm_dquot_logitem_unlock(
>  
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  
> -	/*
> -	 * Clear the transaction pointer in the dquot
> -	 */
> -	dqp->q_transp = NULL;
> -
>  	/*
>  	 * dquots are never 'held' from getting unlocked at the end of
>  	 * a transaction.  Their locking and unlocking is hidden inside the
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index cd664a03613f..ba3de1f03b98 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -29,7 +29,6 @@ xfs_trans_dqjoin(
>  	xfs_trans_t	*tp,
>  	xfs_dquot_t	*dqp)
>  {
> -	ASSERT(dqp->q_transp != tp);
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  	ASSERT(dqp->q_logitem.qli_dquot == dqp);
>  
> @@ -37,15 +36,8 @@ xfs_trans_dqjoin(
>  	 * Get a log_item_desc to point at the new item.
>  	 */
>  	xfs_trans_add_item(tp, &dqp->q_logitem.qli_item);
> -
> -	/*
> -	 * Initialize d_transp so we can later determine if this dquot is
> -	 * associated with this transaction.
> -	 */
> -	dqp->q_transp = tp;
>  }
>  
> -
>  /*
>   * This is called to mark the dquot as needing
>   * to be logged when the transaction is committed.  The dquot must
> @@ -61,7 +53,6 @@ xfs_trans_log_dquot(
>  	xfs_trans_t	*tp,
>  	xfs_dquot_t	*dqp)
>  {
> -	ASSERT(dqp->q_transp == tp);
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
> @@ -347,7 +338,6 @@ xfs_trans_apply_dquot_deltas(
>  				break;
>  
>  			ASSERT(XFS_DQ_IS_LOCKED(dqp));
> -			ASSERT(dqp->q_transp == tp);
>  
>  			/*
>  			 * adjust the actual number of blocks used
> -- 
> 2.20.1
> 
