Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46834 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933662AbdHYPvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 11:51:05 -0400
Date: Fri, 25 Aug 2017 08:51:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/9] xfs: remove unnecessary dirty bli format check for
 ordered bufs
Message-ID: <20170825155100.GN4796@magnolia>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825150557.43010-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 11:05:50AM -0400, Brian Foster wrote:
> xfs_buf_item_unlock() historically checked the dirty state of the
> buffer by manually checking the buffer log formats for dirty
> segments. The introduction of ordered buffers invalidated this check
> because ordered buffers have dirty bli's but no dirty (logged)
> segments. The check was updated to accommodate ordered buffers by
> looking at the bli state first and considering the blf only if the
> bli is clean.
> 
> This logic is safe but unnecessary. There is no valid case where the
> bli is clean yet the blf has dirty segments. The bli is set dirty
> whenever the blf is logged (via xfs_trans_log_buf()) and the blf is
> cleared in the only place BLI_DIRTY is cleared (xfs_trans_binval()).
> 
> Remove the conditional blf dirty checks and replace with an assert
> that should catch any discrepencies between bli and blf dirty
> states. Refactor the old blf dirty check into a helper function to
> be used by the assert.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 46 +++++++++++++++++++++++++++++++---------------
>  fs/xfs/xfs_buf_item.h |  1 +
>  2 files changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index cdae0ad5e0..9f4dbca 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -575,8 +575,9 @@ xfs_buf_item_unlock(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	bool			clean;
> +	bool			dirty;
>  	bool			aborted;
> +	bool			ordered;
>  	int			flags;
>  
>  	/* Clear the buffer's association with this transaction. */
> @@ -620,20 +621,13 @@ xfs_buf_item_unlock(
>  	 * regardless of whether it is dirty or not. A dirty abort implies a
>  	 * shutdown, anyway.
>  	 *
> -	 * Ordered buffers are dirty but may have no recorded changes, so ensure
> -	 * we only release clean items here.
> +	 * The bli dirty state should match whether the blf has logged segments
> +	 * except for ordered buffers, where only the bli should be dirty.
>  	 */
> -	clean = (flags & XFS_BLI_DIRTY) ? false : true;
> -	if (clean) {
> -		int i;
> -		for (i = 0; i < bip->bli_format_count; i++) {
> -			if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
> -				     bip->bli_formats[i].blf_map_size)) {
> -				clean = false;
> -				break;
> -			}
> -		}
> -	}
> +	dirty = (flags & XFS_BLI_DIRTY) ? true : false;
> +	ordered = (flags & XFS_BLI_ORDERED) ? true : false;
> +	ASSERT((!ordered && dirty == xfs_buf_item_dirty_format(bip)) ||
> +	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
>  
>  	/*
>  	 * Clean buffers, by definition, cannot be in the AIL. However, aborted
> @@ -652,7 +646,7 @@ xfs_buf_item_unlock(
>  			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
>  			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
> -		} else if (clean)
> +		} else if (!dirty)
>  			xfs_buf_item_relse(bp);
>  	}
>  
> @@ -945,6 +939,28 @@ xfs_buf_item_log(
>  }
>  
>  
> +/*
> + * Return true if the buffer has any ranges logged/dirtied by a transaction,
> + * false otherwise.
> + */
> +bool
> +xfs_buf_item_dirty_format(
> +	struct xfs_buf_log_item	*bip)
> +{
> +	int			i;
> +	bool			dirty = false;
> +
> +	for (i = 0; i < bip->bli_format_count; i++) {
> +		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
> +			     bip->bli_formats[i].blf_map_size)) {
> +			dirty = true;
> +			break;

/me imagines this could be shortened to 'return true', but looks ok otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +		}
> +	}
> +
> +	return dirty;
> +}
> +
>  STATIC void
>  xfs_buf_item_free(
>  	xfs_buf_log_item_t	*bip)
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index e0e744a..9690ce6 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -64,6 +64,7 @@ typedef struct xfs_buf_log_item {
>  int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
>  void	xfs_buf_item_relse(struct xfs_buf *);
>  void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
> +bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
>  void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      void(*)(struct xfs_buf *, xfs_log_item_t *),
>  			      xfs_log_item_t *);
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
