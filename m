Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 20:57:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T3v7Df015287
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 20:57:08 -0700
Message-ID: <488E9559.409@sgi.com>
Date: Tue, 29 Jul 2008 13:58:17 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/15] small cleanups in xfs_btree.c
References: <20080723200820.GB7401@lst.de>
In-Reply-To: <20080723200820.GB7401@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Fine (not much going on there:).
I'll check it in.

--Tim

Christoph Hellwig wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-06 16:08:37.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-06 16:12:13.000000000 +0200
> @@ -46,38 +46,11 @@ kmem_zone_t	*xfs_btree_cur_zone;
>  /*
>   * Btree magic numbers.
>   */
> -const __uint32_t xfs_magics[XFS_BTNUM_MAX] =
> -{
> +const __uint32_t xfs_magics[XFS_BTNUM_MAX] = {
>  	XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC
>  };
>  
>  /*
> - * Prototypes for internal routines.
> - */
> -
> -/*
> - * Checking routine: return maxrecs for the block.
> - */
> -STATIC int				/* number of records fitting in block */
> -xfs_btree_maxrecs(
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> -	xfs_btree_block_t	*block);/* generic btree block pointer */
> -
> -/*
> - * Internal routines.
> - */
> -
> -/*
> - * Retrieve the block pointer from the cursor at the given level.
> - * This may be a bmap btree root or from a buffer.
> - */
> -STATIC xfs_btree_block_t *			/* generic btree block pointer */
> -xfs_btree_get_block(
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> -	int			level,	/* level in btree */
> -	struct xfs_buf		**bpp);	/* buffer containing the block */
> -
> -/*
>   * Checking routine: return maxrecs for the block.
>   */
>  STATIC int				/* number of records fitting in block */
> @@ -457,35 +430,6 @@ xfs_btree_dup_cursor(
>  }
>  
>  /*
> - * Change the cursor to point to the first record at the given level.
> - * Other levels are unaffected.
> - */
> -int					/* success=1, failure=0 */
> -xfs_btree_firstrec(
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> -	int			level)	/* level to change */
> -{
> -	xfs_btree_block_t	*block;	/* generic btree block pointer */
> -	xfs_buf_t		*bp;	/* buffer containing block */
> -
> -	/*
> -	 * Get the block pointer for this level.
> -	 */
> -	block = xfs_btree_get_block(cur, level, &bp);
> -	xfs_btree_check_block(cur, block, level, bp);
> -	/*
> -	 * It's empty, there is no such record.
> -	 */
> -	if (!block->bb_h.bb_numrecs)
> -		return 0;
> -	/*
> -	 * Set the ptr value to 1, that's the first record/key.
> -	 */
> -	cur->bc_ptrs[level] = 1;
> -	return 1;
> -}
> -
> -/*
>   * Retrieve the block pointer from the cursor at the given level.
>   * This may be a bmap btree root or from a buffer.
>   */
> @@ -671,6 +615,35 @@ xfs_btree_islastblock(
>  }
>  
>  /*
> + * Change the cursor to point to the first record at the given level.
> + * Other levels are unaffected.
> + */
> +int					/* success=1, failure=0 */
> +xfs_btree_firstrec(
> +	xfs_btree_cur_t		*cur,	/* btree cursor */
> +	int			level)	/* level to change */
> +{
> +	xfs_btree_block_t	*block;	/* generic btree block pointer */
> +	xfs_buf_t		*bp;	/* buffer containing block */
> +
> +	/*
> +	 * Get the block pointer for this level.
> +	 */
> +	block = xfs_btree_get_block(cur, level, &bp);
> +	xfs_btree_check_block(cur, block, level, bp);
> +	/*
> +	 * It's empty, there is no such record.
> +	 */
> +	if (!block->bb_h.bb_numrecs)
> +		return 0;
> +	/*
> +	 * Set the ptr value to 1, that's the first record/key.
> +	 */
> +	cur->bc_ptrs[level] = 1;
> +	return 1;
> +}
> +
> +/*
>   * Change the cursor to point to the last record in the current block
>   * at the given level.  Other levels are unaffected.
>   */
> 
> -- 
