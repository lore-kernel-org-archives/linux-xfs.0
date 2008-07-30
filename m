Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 22:29:26 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U5TPoZ001406
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:29:25 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75DD81953168
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:30:35 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id HnvdSBYrpjZWFzOD for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:30:35 -0700 (PDT)
Date: Wed, 30 Jul 2008 15:29:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/21] implement generic xfs_btree_update
Message-ID: <20080730052959.GN13395@disturbed>
References: <20080729193116.GN19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080729193116.GN19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:16PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> The most complicated part here is the lastrec tracking for
> the alloc btree.  Most logic is in the update_lastrec method
> which has to do some hopefully good enough dirty magic to
> maintain it.
> 
> [hch: split out from bigger patch and a rework of the lastrec
>  logic]
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-21 05:10:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-21 05:24:20.000000000 +0200
> @@ -867,6 +867,30 @@ xfs_btree_get_sibling(
>  	}
>  }
>  
> +/*
> + * Return true if ptr is the last record in the btree and
> + * we need to track updateѕ to this record.  The decision
> + * will be further refined in the update_lastrec method.
> + */
> +STATIC int
> +xfs_btree_is_lastrec(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_block	*block,
> +	int			level)
> +{
> +	union xfs_btree_ptr	ptr;
> +
> +	if (level > 0)
> +		return 0;
> +	if (!(cur->bc_flags & XFS_BTREE_LASTREC_UPDATE))
> +		return 0;
> +
> +	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
> +	if (!xfs_btree_ptr_is_null(cur, &ptr))
> +		return 0;
> +	return 1;
> +}

That is not checking if it's the last record - it's checking if it
is the rightmost block in the btree. i.e. if the block contains
the last record. If the code is to remain this way, that needs
renaming.

> +
>  STATIC struct xfs_btree_block *
>  xfs_btree_buf_to_block(
>  	struct xfs_btree_cur	*cur,
> @@ -1417,3 +1441,66 @@ xfs_btree_updkey(
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
>  	return 0;
>  }
> +
> +/*
> + * Update the record referred to by cur to the value in the
> + * given record. This either works (return 0) or gets an
> + * EFSCORRUPTED error.
> + */
> +int
> +xfs_btree_update(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_rec	*rec)
> +{
> +	struct xfs_btree_block	*block;
> +	struct xfs_buf		*bp;
> +	int			error;
> +	int			ptr;
> +	union xfs_btree_rec	*rp;
> +
> +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> +	XFS_BTREE_TRACE_ARGR(cur, rec);
> +
> +	/* Pick up the current block. */
> +	block = xfs_btree_get_block(cur, 0, &bp);
> +
> +#ifdef DEBUG
> +	error = xfs_btree_check_block(cur, block, 0, bp);
> +	if (error)
> +		goto error0;
> +#endif
> +	/* Get the address of the rec to be updated. */
> +	ptr = cur->bc_ptrs[0];
> +	rp = cur->bc_ops->rec_addr(cur, ptr, block);
> +
> +	/* Fill in the new contents and log them. */
> +	cur->bc_ops->copy_recs(cur, rec, rp, 1);
> +	cur->bc_ops->log_recs(cur, bp, ptr, ptr);
> +
> +	/*
> +	 * If we are tracking the last record in the tree and
> +	 * we are at the far right edge of the tree, update it.
> +	 */
> +	if (xfs_btree_is_lastrec(cur, block, 0)) {
> +		cur->bc_ops->update_lastrec(cur, block, rec,
> +					    ptr, LASTREC_UPDATE);
> +	}

So this will update the last record on any update to a record in
the last block. Seeing as we will typically be allocating out of
the last block (where the biggest extents are) this is somewhat
additional overhead, right? This is the code that used to trigger
the update:

	/*
	 * If it's the by-size btree and it's the last leaf block and
	 * it's the last record... then update the size of the longest
	 * extent in the a.g., which we cache in the a.g. freelist header.
	 */
	if (cur->bc_btnum == XFS_BTNUM_CNT &&
	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
	    ptr == be16_to_cpu(block->bb_numrecs)) {

So it's clear we aren't doing the same check here. My original code
had the ptr check in it. Why did you drop it?

> +STATIC void
> +xfs_allocbt_update_lastrec(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_block	*block,
> +	union xfs_btree_rec	*rec,
> +	int			ptr,
> +	int			reason)
>  {
.....
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
> +	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
> +	__be32			len;
>  
.....
> +	ASSERT(cur->bc_btnum == XFS_BTNUM_CNT);
>  
.....
> +	switch (reason) {
> +	case LASTREC_UPDATE:
>  		/*
.....
> +		 * If this is the last leaf block and it's the last record,
> +		 * then update the size of the longest extent in the AG.
>  		 */
.....
> +		if (ptr != xfs_btree_get_numrecs(block))
> +			return;
> +		len = rec->alloc.ar_blockcount;
> +		break;
> +	default:
> +		ASSERT(0);
> +		return;
>  	}

Oh, it's be moved inside the update code itself. So, why always call
the update function and then check the ptr? Why not the way it was
originally done?

> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-21 05:11:01.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-21 05:23:07.000000000 +0200
> @@ -191,6 +191,11 @@ struct xfs_btree_ops {
>  	/* get inode rooted btree root */
>  	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
>  
> +	/* updated last record information */
> +	void	(*update_lastrec)(struct xfs_btree_cur *,
> +				  struct xfs_btree_block *,
> +				  union xfs_btree_rec *, int, int);

Can you add the variable names to the prototype parameters?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
