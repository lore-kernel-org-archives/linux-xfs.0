Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30689 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbdHYP0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 11:26:53 -0400
Date: Fri, 25 Aug 2017 08:26:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] xfs: open-code xfs_buf_item_dirty()
Message-ID: <20170825152647.GL4796@magnolia>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825150557.43010-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2017 at 11:05:49AM -0400, Brian Foster wrote:
> It checks a single flag and has one caller. It probably isn't worth
> its own function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_buf_item.c  | 11 -----------
>  fs/xfs/xfs_buf_item.h  |  1 -
>  fs/xfs/xfs_trans_buf.c |  2 +-
>  3 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 573fc72..cdae0ad5e0 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -945,17 +945,6 @@ xfs_buf_item_log(
>  }
>  
>  
> -/*
> - * Return 1 if the buffer has been logged or ordered in a transaction (at any
> - * point, not just the current transaction) and 0 if not.
> - */
> -uint
> -xfs_buf_item_dirty(
> -	xfs_buf_log_item_t	*bip)
> -{
> -	return (bip->bli_flags & XFS_BLI_DIRTY);
> -}
> -
>  STATIC void
>  xfs_buf_item_free(
>  	xfs_buf_log_item_t	*bip)
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 530686e..e0e744a 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -64,7 +64,6 @@ typedef struct xfs_buf_log_item {
>  int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
>  void	xfs_buf_item_relse(struct xfs_buf *);
>  void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
> -uint	xfs_buf_item_dirty(xfs_buf_log_item_t *);
>  void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      void(*)(struct xfs_buf *, xfs_log_item_t *),
>  			      xfs_log_item_t *);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 86987d8..cac8abb 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -435,7 +435,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
>  	if (XFS_FORCED_SHUTDOWN(tp->t_mountp) && freed) {
>  		xfs_trans_ail_remove(&bip->bli_item, SHUTDOWN_LOG_IO_ERROR);
>  		xfs_buf_item_relse(bp);
> -	} else if (!xfs_buf_item_dirty(bip)) {
> +	} else if (!(bip->bli_flags & XFS_BLI_DIRTY)) {
>  /***
>  		ASSERT(bp->b_pincount == 0);
>  ***/
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
