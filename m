Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35946 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbdKCQio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 12:38:44 -0400
Date: Fri, 3 Nov 2017 09:38:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/21] xfs: move xfs_bmbt_irec and xfs_exntst_t to
 xfs_types.h
Message-ID: <20171103163841.GL4911@magnolia>
References: <20171103144539.2187-1-hch@lst.de>
 <20171103144539.2187-22-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103144539.2187-22-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 05:45:39PM +0300, Christoph Hellwig wrote:
> Neither defines an on-disk format, so move them out of xfs_format.h.

/me wonders if the other irec structures ought to move too, but that's
no reason not to:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h | 18 ------------------
>  fs/xfs/libxfs/xfs_types.h  | 12 ++++++++++++
>  2 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index fbe7d3c31345..2e047e76db2f 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1577,24 +1577,6 @@ static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
>  	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
>  }
>  
> -/*
> - * Possible extent states.
> - */
> -typedef enum {
> -	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
> -} xfs_exntst_t;
> -
> -/*
> - * Incore version of above.
> - */
> -typedef struct xfs_bmbt_irec
> -{
> -	xfs_fileoff_t	br_startoff;	/* starting file offset */
> -	xfs_fsblock_t	br_startblock;	/* starting block number */
> -	xfs_filblks_t	br_blockcount;	/* number of blocks */
> -	xfs_exntst_t	br_state;	/* extent state */
> -} xfs_bmbt_irec_t;
> -
>  /*
>   * Key structure for non-leaf levels of the tree.
>   */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 983878019097..3c560695c546 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -147,4 +147,16 @@ struct xfs_iext_cursor {
>  	int			pos;
>  };
>  
> +typedef enum {
> +	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
> +} xfs_exntst_t;
> +
> +typedef struct xfs_bmbt_irec
> +{
> +	xfs_fileoff_t	br_startoff;	/* starting file offset */
> +	xfs_fsblock_t	br_startblock;	/* starting block number */
> +	xfs_filblks_t	br_blockcount;	/* number of blocks */
> +	xfs_exntst_t	br_state;	/* extent state */
> +} xfs_bmbt_irec_t;
> +
>  #endif	/* __XFS_TYPES_H__ */
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
