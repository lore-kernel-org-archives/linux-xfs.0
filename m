Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 19:06:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U26MMl012415
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 19:06:25 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7A5715ED317
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 19:07:33 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id wiZ9w12wfbUNo2pz for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 19:07:33 -0700 (PDT)
Date: Wed, 30 Jul 2008 12:06:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] implement generic xfs_btree_increment
Message-ID: <20080730020645.GJ13395@disturbed>
References: <20080729193053.GJ19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193053.GJ19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:30:53PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> Because this is the first major generic btree routine this patch
> includes some infrastrucure, fistly a few routines to deal with
> a btree block that can be either in short or long form, and secondly
> xfs_btree_read_buf_block, which is the new central routine to read
> a btree block given a cursor.
> 
> [hch: split out from bigger patch and minor adaptions]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

> @@ -502,6 +506,23 @@ xfs_btree_setbuf(
>  	int			lev,	/* level in btree */
>  	struct xfs_buf		*bp);	/* new buffer to set */
>  
> +/*
> + * Common btree core entry points.
> + */
> +
> +int xfs_btree_increment(struct xfs_btree_cur *, int, int *);

I think for these interfaces it woul dbe better to include
variable names in the prototypes. i.e.:

int xfs_btree_increment(struct xfs_btree_cur *cur, int level, int *stat);

> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-21 04:41:51.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-21 06:47:21.000000000 +0200
> @@ -35,6 +35,7 @@
>  #include "xfs_dinode.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
> +#include "xfs_btree_trace.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_error.h"
>  
> @@ -829,3 +830,230 @@ xfs_btree_setbuf(
>  			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
>  	}
>  }
> +
> +STATIC int
> +xfs_btree_ptr_is_null(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr)
> +{
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
> +	else
> +		return be32_to_cpu(ptr->s) == NULLAGBLOCK;

Can kill the else there:

	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
	return be32_to_cpu(ptr->s) == NULLAGBLOCK;

> +}
> +
> +/*
> + * Get/set/init sibling pointers
> + */
> +STATIC void
> +xfs_btree_get_sibling(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_block	*block,
> +	union xfs_btree_ptr	*ptr,
> +	int			lr)
> +{
> +	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
> +
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +		if (lr == XFS_BB_RIGHTSIB)
> +			ptr->l = block->bb_u.l.bb_rightsib;
> +		else
> +			ptr->l = block->bb_u.l.bb_leftsib;
> +	} else {
> +		if (lr == XFS_BB_RIGHTSIB)
> +			ptr->s = block->bb_u.s.bb_rightsib;
> +		else
> +			ptr->s = block->bb_u.s.bb_leftsib;
> +	}
> +}

Should we use trinary notation for this? i.e:

{
	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
		ptr->l = (lr == XFS_BB_RIGHTSIB) ? block->bb_u.l.bb_rightsib
						 : block->bb_u.l.bb_leftsib;
	} else {
		ptr->s = (lr == XFS_BB_RIGHTSIB) ? block->bb_u.s.bb_rightsib
						 : block->bb_u.s.bb_leftsib;
	}
}

> +STATIC xfs_daddr_t
> +xfs_btree_ptr_to_daddr(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr)
> +{
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +		ASSERT(be64_to_cpu(ptr->l) != NULLFSBLOCK);
> +
> +		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
> +	} else {
> +		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
> +		ASSERT(be32_to_cpu(ptr->s) != NULLAGBLOCK);
> +
> +		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
> +					be32_to_cpu(ptr->s));
> +	}
> +}

Can kill the else here as well...

> +/*
> + * Read in the buffer at the given ptr and return the buffer and
> + * the block pointer within the buffer.
> + */
> +STATIC int
> +xfs_btree_read_buf_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr,
> +	int			level,
> +	int			flags,
> +	struct xfs_btree_block	**block,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_mount	*mp = cur->bc_mp;
> +	xfs_daddr_t		d;
> +	int			error;
> +
> +	/* need to sort out how callers deal with failures first */
> +	ASSERT(!(flags & XFS_BUF_TRYLOCK));
> +
> +	d = xfs_btree_ptr_to_daddr(cur, ptr);
> +	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
> +				   mp->m_bsize, flags, bpp);
> +	if (error)
> +		return error;
> +
> +	ASSERT(*bpp != NULL);
> +	ASSERT(!XFS_BUF_GETERROR(*bpp));
> +
> +	xfs_btree_set_refs(cur, *bpp);
> +	*block = XFS_BUF_TO_BLOCK(*bpp);
> +
> +	return xfs_btree_check_block(cur, *block, level, *bpp);
> +}

Hmmm - if xfs_btree_check_block() returns an error, we won't release
the buffer in the error handling path. While this may not be a
problem right now (as the only error is EFSCORRUPTED) we want to be
able to recover from errors here in the future so we should really
exit cleanly form this function....

> +/*
> + * Increment cursor by one record at the level.
> + * For nonzero levels the leaf-ward information is untouched.
> + */
> +int						/* error */
> +xfs_btree_increment(
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	int			*stat)		/* success/failure */
> +{
.....
> +	/*
> +	 * If we went off the root then we are either seriously
> +	 * confused or have the tree root in an inode.
> +	 */
> +	if (lev == cur->bc_nlevels) {
> +		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> +		goto out0;
> +	}

Would it be better here to explicitly test this rather than assert?
ie.:

	if (lev == cur->bc_nlevels) {
		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
			goto out0;
		ASSERT(0);
		error = EFSCORRUPTED;
		goto error0;
	}

So that we get an explicit error reported in the production systems
rather than carrying on and dying a horrible death somewhere else....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
