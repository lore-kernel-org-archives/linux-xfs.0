Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34460 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752915AbdJUA2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 20:28:01 -0400
Date: Fri, 20 Oct 2017 17:27:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/15] xfs: rewrite xfs_bmap_first_unused to make better
 use of xfs_iext_get_extent
Message-ID: <20171021002757.GI4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019065942.18813-16-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:42AM +0200, Christoph Hellwig wrote:
> Look at the return value of xfs_iext_get_extent instead of figuring out
> the extent count first and looping up to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 56 ++++++++++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9b638cc49f5c..46813b71dd74 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1285,57 +1285,53 @@ xfs_bmap_read_extents(
>  }
>  
>  /*
> - * Returns the file-relative block number of the first unused block(s)
> - * in the file with at least "len" logically contiguous blocks free.
> - * This is the lowest-address hole if the file has holes, else the first block
> - * past the end of file.
> - * Return 0 if the file is currently local (in-inode).
> + * Returns the relative block number of the first unused block(s) in the given
> + * fork with at least "len" logically contiguous blocks free.  This is the
> + * lowest-address hole if the fork has holes, else the first block past the end
> + * of fork.  Return 0 if the fork is currently local (in-inode).
>   */
>  int						/* error */
>  xfs_bmap_first_unused(
> -	xfs_trans_t	*tp,			/* transaction pointer */
> -	xfs_inode_t	*ip,			/* incore inode */
> -	xfs_extlen_t	len,			/* size of hole to find */
> -	xfs_fileoff_t	*first_unused,		/* unused block */
> -	int		whichfork)		/* data or attr fork */
> +	struct xfs_trans	*tp,		/* transaction pointer */
> +	struct xfs_inode	*ip,		/* incore inode */
> +	xfs_extlen_t		len,		/* size of hole to find */
> +	xfs_fileoff_t		*first_unused,	/* unused block */
> +	int			whichfork)	/* data or attr fork */
>  {
> -	int		error;			/* error return value */
> -	int		idx;			/* extent record index */
> -	xfs_ifork_t	*ifp;			/* inode fork pointer */
> -	xfs_fileoff_t	lastaddr;		/* last block number seen */
> -	xfs_fileoff_t	lowest;			/* lowest useful block */
> -	xfs_fileoff_t	max;			/* starting useful block */
> -	xfs_extnum_t	nextents;		/* number of extent entries */
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_bmbt_irec	got;
> +	xfs_extnum_t		idx = 0;
> +	xfs_fileoff_t		lastaddr = 0;
> +	xfs_fileoff_t		lowest, max;
> +	int			error;
>  
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE ||
>  	       XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ||
>  	       XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
> +
>  	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
>  		*first_unused = 0;
>  		return 0;
>  	}
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> -	    (error = xfs_iread_extents(tp, ip, whichfork)))
> -		return error;
> -	lowest = *first_unused;
> -	nextents = xfs_iext_count(ifp);
> -	for (idx = 0, lastaddr = 0, max = lowest; idx < nextents; idx++) {
> -		struct xfs_bmbt_irec got;
>  
> -		xfs_iext_get_extent(ifp, idx, &got);
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(tp, ip, whichfork);
> +		if (error)
> +			return error;
> +	}
>  
> +	lowest = max = *first_unused;
> +	while (xfs_iext_get_extent(ifp, idx++, &got)) {
>  		/*
>  		 * See if the hole before this extent will work.
>  		 */
>  		if (got.br_startoff >= lowest + len &&
> -		    got.br_startoff - max >= len) {
> -			*first_unused = max;
> -			return 0;
> -		}
> +		    got.br_startoff - max >= len)
> +			break;
>  		lastaddr = got.br_startoff + got.br_blockcount;
>  		max = XFS_FILEOFF_MAX(lastaddr, lowest);
>  	}
> +
>  	*first_unused = max;
>  	return 0;
>  }
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
