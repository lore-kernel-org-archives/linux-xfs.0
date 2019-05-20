Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730458AbfETNM6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:12:58 -0400
Date: Mon, 20 May 2019 09:12:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 13/20] xfs: merge xfs_efd_init into xfs_trans_get_efd
Message-ID: <20190520131255.GD31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:12AM +0200, Christoph Hellwig wrote:
> There is no good reason to keep these two functions separate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good, and there's only one more user of the xfs_efd_log_item_t
typedef. ;)

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extfree_item.c  | 27 +++++++++++++++------------
>  fs/xfs/xfs_extfree_item.h  |  2 --
>  fs/xfs/xfs_trans_extfree.c | 26 --------------------------
>  3 files changed, 15 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index bb0b1e942d00..ccf95cb8234c 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -312,32 +312,35 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
>  };
>  
>  /*
> - * Allocate and initialize an efd item with the given number of extents.
> + * Allocate an "extent free done" log item that will hold nextents worth of
> + * extents.  The caller must use all nextents extents, because we are not
> + * flexible about this at all.
>   */
>  struct xfs_efd_log_item *
> -xfs_efd_init(
> -	struct xfs_mount	*mp,
> -	struct xfs_efi_log_item	*efip,
> -	uint			nextents)
> -
> +xfs_trans_get_efd(
> +	struct xfs_trans		*tp,
> +	struct xfs_efi_log_item		*efip,
> +	unsigned int			nextents)
>  {
> -	struct xfs_efd_log_item	*efdp;
> -	uint			size;
> +	struct xfs_efd_log_item		*efdp;
>  
>  	ASSERT(nextents > 0);
> +
>  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(xfs_efd_log_item_t) +
> -			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efdp = kmem_zalloc(size, KM_SLEEP);
> +		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> +				(nextents - 1) * sizeof(struct xfs_extent),
> +				KM_SLEEP);
>  	} else {
>  		efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
>  	}
>  
> -	xfs_log_item_init(mp, &efdp->efd_item, XFS_LI_EFD, &xfs_efd_item_ops);
> +	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
> +			  &xfs_efd_item_ops);
>  	efdp->efd_efip = efip;
>  	efdp->efd_format.efd_nextents = nextents;
>  	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
>  
> +	xfs_trans_add_item(tp, &efdp->efd_item);
>  	return efdp;
>  }
>  
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index b0dc4ebe8892..16aaab06d4ec 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -79,8 +79,6 @@ extern struct kmem_zone	*xfs_efi_zone;
>  extern struct kmem_zone	*xfs_efd_zone;
>  
>  xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
> -xfs_efd_log_item_t	*xfs_efd_init(struct xfs_mount *, xfs_efi_log_item_t *,
> -				      uint);
>  int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
>  					    xfs_efi_log_format_t *dst_efi_fmt);
>  void			xfs_efi_item_free(xfs_efi_log_item_t *);
> diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> index 8ee7a3f8bb20..20ab1c9d758f 100644
> --- a/fs/xfs/xfs_trans_extfree.c
> +++ b/fs/xfs/xfs_trans_extfree.c
> @@ -19,32 +19,6 @@
>  #include "xfs_bmap.h"
>  #include "xfs_trace.h"
>  
> -/*
> - * This routine is called to allocate an "extent free done"
> - * log item that will hold nextents worth of extents.  The
> - * caller must use all nextents extents, because we are not
> - * flexible about this at all.
> - */
> -struct xfs_efd_log_item *
> -xfs_trans_get_efd(struct xfs_trans		*tp,
> -		  struct xfs_efi_log_item	*efip,
> -		  uint				nextents)
> -{
> -	struct xfs_efd_log_item			*efdp;
> -
> -	ASSERT(tp != NULL);
> -	ASSERT(nextents > 0);
> -
> -	efdp = xfs_efd_init(tp->t_mountp, efip, nextents);
> -	ASSERT(efdp != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &efdp->efd_item);
> -	return efdp;
> -}
> -
>  /*
>   * Free an extent and log it to the EFD. Note that the transaction is marked
>   * dirty regardless of whether the extent free succeeds or fails to support the
> -- 
> 2.20.1
> 
