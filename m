Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfBOQmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 11:42:06 -0500
Date: Fri, 15 Feb 2019 08:41:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/10] xfs: simplify the xfs_bmap_btree_to_extents
 calling conventions
Message-ID: <20190215164152.GM32253@magnolia>
References: <20190215144725.8894-1-hch@lst.de>
 <20190215144725.8894-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215144725.8894-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Feb 15, 2019 at 03:47:18PM +0100, Christoph Hellwig wrote:
> Move boilerplate code from the callers into xfs_bmap_btree_to_extents:
> 
>  - exit early without failure if we don't need to convert to the
>    extent format
>  - assert that we have a btree cursor
>  - don't reinitialize the passed in logflags argument
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 78 ++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f4a65330a2a9..7fa454f71f46 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -577,42 +577,44 @@ __xfs_bmap_add_free(
>   */
>  
>  /*
> - * Transform a btree format file with only one leaf node, where the
> - * extents list will fit in the inode, into an extents format file.
> - * Since the file extents are already in-core, all we have to do is
> - * give up the space for the btree root and pitch the leaf block.
> + * Convert the inode format to extent format if it currently is in btree format,
> + * but the extent list is small enough that it fits into the extent format.
> + 8

"*", not "8"; I'll fix that on import if I pull this series.

Otherwise looks ok to me,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> + * Since the extents are already in-core, all we have to do is give up the space
> + * for the btree root and pitch the leaf block.
>   */
>  STATIC int				/* error */
>  xfs_bmap_btree_to_extents(
> -	xfs_trans_t		*tp,	/* transaction pointer */
> -	xfs_inode_t		*ip,	/* incore inode pointer */
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> +	struct xfs_trans	*tp,	/* transaction pointer */
> +	struct xfs_inode	*ip,	/* incore inode pointer */
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
>  	int			*logflagsp, /* inode logging flags */
>  	int			whichfork)  /* data or attr fork */
>  {
> -	/* REFERENCED */
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_btree_block	*rblock = ifp->if_broot;
>  	struct xfs_btree_block	*cblock;/* child btree block */
>  	xfs_fsblock_t		cbno;	/* child block number */
>  	xfs_buf_t		*cbp;	/* child block's buffer */
>  	int			error;	/* error return value */
> -	struct xfs_ifork	*ifp;	/* inode fork data */
> -	xfs_mount_t		*mp;	/* mount point structure */
>  	__be64			*pp;	/* ptr to block address */
> -	struct xfs_btree_block	*rblock;/* root btree block */
>  	struct xfs_owner_info	oinfo;
>  
> -	mp = ip->i_mount;
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> +	/* check if we actually need the extent format first: */
> +	if (!xfs_bmap_wants_extents(ip, whichfork))
> +		return 0;
> +
> +	ASSERT(cur);
>  	ASSERT(whichfork != XFS_COW_FORK);
>  	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
> -	rblock = ifp->if_broot;
>  	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
>  	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
>  	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
> +
>  	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
>  	cbno = be64_to_cpu(*pp);
> -	*logflagsp = 0;
>  #ifdef DEBUG
>  	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
>  			xfs_btree_check_lptr(cur, cbno, 1));
> @@ -635,7 +637,7 @@ xfs_bmap_btree_to_extents(
>  	ASSERT(ifp->if_broot == NULL);
>  	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
>  	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
> -	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
> +	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
>  	return 0;
>  }
>  
> @@ -4424,19 +4426,10 @@ xfs_bmapi_write(
>  	}
>  	*nmap = n;
>  
> -	/*
> -	 * Transform from btree to extents, give it cur.
> -	 */
> -	if (xfs_bmap_wants_extents(ip, whichfork)) {
> -		int		tmp_logflags = 0;
> -
> -		ASSERT(bma.cur);
> -		error = xfs_bmap_btree_to_extents(tp, ip, bma.cur,
> -			&tmp_logflags, whichfork);
> -		bma.logflags |= tmp_logflags;
> -		if (error)
> -			goto error0;
> -	}
> +	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
> +			whichfork);
> +	if (error)
> +		goto error0;
>  
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE ||
>  	       XFS_IFORK_NEXTENTS(ip, whichfork) >
> @@ -4574,13 +4567,7 @@ xfs_bmapi_remap(
>  	if (error)
>  		goto error0;
>  
> -	if (xfs_bmap_wants_extents(ip, whichfork)) {
> -		int		tmp_logflags = 0;
> -
> -		error = xfs_bmap_btree_to_extents(tp, ip, cur,
> -			&tmp_logflags, whichfork);
> -		logflags |= tmp_logflags;
> -	}
> +	error = xfs_bmap_btree_to_extents(tp, ip, cur, &logflags, whichfork);
>  
>  error0:
>  	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS)
> @@ -5444,24 +5431,11 @@ __xfs_bunmapi(
>  		error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0,
>  				&tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
> -		if (error)
> -			goto error0;
> -	}
> -	/*
> -	 * transform from btree to extents, give it cur
> -	 */
> -	else if (xfs_bmap_wants_extents(ip, whichfork)) {
> -		ASSERT(cur != NULL);
> -		error = xfs_bmap_btree_to_extents(tp, ip, cur, &tmp_logflags,
> +	} else {
> +		error = xfs_bmap_btree_to_extents(tp, ip, cur, &logflags,
>  			whichfork);
> -		logflags |= tmp_logflags;
> -		if (error)
> -			goto error0;
>  	}
> -	/*
> -	 * transform from extents to local?
> -	 */
> -	error = 0;
> +
>  error0:
>  	/*
>  	 * Log everything.  Do this after conversion, there's no point in
> -- 
> 2.20.1
> 
