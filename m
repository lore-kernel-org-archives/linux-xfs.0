Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751005AbeEGMRA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 08:17:00 -0400
Date: Mon, 7 May 2018 08:16:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/10] xfs: catch log items multiply joined to a
 transaction
Message-ID: <20180507121658.GC38916@bfoster.bfoster>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502080157.11386-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 02, 2018 at 06:01:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I've comes across a series of subtle bugs in development code that
> are a result of inodes being joined to the same transaction more
> than once. This means the transaction has multiple log item
> descriptors pointing to the same log item, and so processes them
> multiple times during transaction commit processing. Further, the
> log item can only store a single log item descriptor back pointer,
> so this means all but one of the log item descriptors pointing
> to the log item can't be found from the log item.
> 
> Add a log item flag to say the item has been joined to a transaction
> and assert that it's not set when adding a log item to a
> transaction. Clear it when the log item is disconnected from the log
> item descriptor. This will tell us if there are other log items that
> transactions are referencing multiple times.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans.c | 6 ++++--
>  fs/xfs/xfs_trans.h | 4 +++-
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index c6a2a3cb9df5..33c40788cffa 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -741,6 +741,7 @@ xfs_trans_add_item(
>  
>  	ASSERT(lip->li_mountp == tp->t_mountp);
>  	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
> +	ASSERT(!test_bit(XFS_LI_TRANS, &lip->li_flags));
>  
>  	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
>  
> @@ -749,6 +750,7 @@ xfs_trans_add_item(
>  	list_add_tail(&lidp->lid_trans, &tp->t_items);
>  
>  	lip->li_desc = lidp;
> +	set_bit(XFS_LI_TRANS, &lip->li_flags);
>  }
>  
>  STATIC void
> @@ -766,6 +768,7 @@ void
>  xfs_trans_del_item(
>  	struct xfs_log_item	*lip)
>  {
> +	clear_bit(XFS_LI_TRANS, &lip->li_flags);
>  	xfs_trans_free_item_desc(lip->li_desc);
>  	lip->li_desc = NULL;
>  }
> @@ -785,7 +788,7 @@ xfs_trans_free_items(
>  	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
>  		struct xfs_log_item	*lip = lidp->lid_item;
>  
> -		lip->li_desc = NULL;
> +		xfs_trans_del_item(lip);
>  
>  		if (commit_lsn != NULLCOMMITLSN)
>  			lip->li_ops->iop_committing(lip, commit_lsn);
> @@ -793,7 +796,6 @@ xfs_trans_free_items(
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  		lip->li_ops->iop_unlock(lip);
>  
> -		xfs_trans_free_item_desc(lidp);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 51145ddf7e5b..af52107adffc 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -72,11 +72,13 @@ typedef struct xfs_log_item {
>  #define	XFS_LI_IN_AIL	0
>  #define	XFS_LI_ABORTED	1
>  #define	XFS_LI_FAILED	2
> +#define	XFS_LI_TRANS	3	/* attached to an active transaction */
>  
>  #define XFS_LI_FLAGS \
>  	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
>  	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
> -	{ (1 << XFS_LI_FAILED),		"FAILED" }
> +	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
> +	{ (1 << XFS_LI_TRANS),		"TRANS" }
>  
>  struct xfs_item_ops {
>  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
