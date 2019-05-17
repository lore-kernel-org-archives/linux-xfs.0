Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbfEQRu2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 13:50:28 -0400
Date: Fri, 17 May 2019 13:50:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/20] xfs: add a flag to release log items on commit
Message-ID: <20190517175025.GH7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:07AM +0200, Christoph Hellwig wrote:
> We have various items that are released from ->iop_comitting.  Add a
> flag to just call ->iop_release from the commit path to avoid tons
> of boilerplate code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Seems reasonable, but the naming is getting a little confusing. Your
commit log refers to ->iop_committing() and the patch modifies
->iop_committed(). Both the committing and committed callbacks still
exist, while the flag is called *_RELEASE_ON_COMMIT and thus doesn't
indicate which event it actually refers to. Can we fix this up? Maybe
just call it *_RELEASE_ON_COMMITTED?

>  fs/xfs/xfs_bmap_item.c     | 27 +--------------------------
>  fs/xfs/xfs_extfree_item.c  | 27 +--------------------------
>  fs/xfs/xfs_icreate_item.c  | 18 +-----------------
>  fs/xfs/xfs_refcount_item.c | 27 +--------------------------
>  fs/xfs/xfs_rmap_item.c     | 27 +--------------------------
>  fs/xfs/xfs_trans.c         |  5 +++++
>  fs/xfs/xfs_trans.h         |  7 +++++++
>  7 files changed, 17 insertions(+), 121 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 45a39de65997..52a8a8ff2ae9 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -849,6 +849,11 @@ xfs_trans_committed_bulk(
>  		struct xfs_log_item	*lip = lv->lv_item;
>  		xfs_lsn_t		item_lsn;
>  
> +		if (lip->li_ops->flags & XFS_ITEM_RELEASE_ON_COMMIT) {
> +			lip->li_ops->iop_release(lip);
> +			continue;
> +		}

It might be appropriate to set the aborted flag before the callback.
Even though none of the current users happen to care, it's a more
consistent semantic with the other direct caller of ->iop_release().

Brian

> +
>  		if (aborted)
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  		if (lip->li_ops->iop_committed)
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 7bd1867613c2..a38af44344bf 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -67,6 +67,7 @@ typedef struct xfs_log_item {
>  	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
>  
>  struct xfs_item_ops {
> +	unsigned flags;
>  	void (*iop_size)(xfs_log_item_t *, int *, int *);
>  	void (*iop_format)(xfs_log_item_t *, struct xfs_log_vec *);
>  	void (*iop_pin)(xfs_log_item_t *);
> @@ -78,6 +79,12 @@ struct xfs_item_ops {
>  	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
>  };
>  
> +/*
> + * Release the log item as soon as committed.  This is for items just logging
> + * intents that never need to be written back in place.
> + */
> +#define XFS_ITEM_RELEASE_ON_COMMIT	(1 << 0)
> +
>  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>  			  int type, const struct xfs_item_ops *ops);
>  
> -- 
> 2.20.1
> 
