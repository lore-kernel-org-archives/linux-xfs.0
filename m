Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 23:23:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U6NEUb006080
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:23:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6C29ED4CE8
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:24:27 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id XB5cF4o5TzwBE2mS for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:24:27 -0700 (PDT)
Date: Wed, 30 Jul 2008 16:24:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/21] implement generic xfs_btree_lshift
Message-ID: <20080730062422.GQ13395@disturbed>
References: <20080729193132.GQ19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193132.GQ19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:32PM +0200, Christoph Hellwig wrote:
> Make the btree left shift code generic.  Based on a patch from David Chinner
> with lots of changes to follow the original btree implementations more
> closely.  While this loses some of the generic helper routines for
> inserting/moving/removing records it also solves some of the one off
> bugs in the original code and makes it easier to verify.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-28 16:13:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-28 16:16:22.000000000 +0200
> @@ -976,6 +976,21 @@ xfs_btree_move_ptrs(
>  	}
>  }
>  
> +STATIC void
> +xfs_btree_copy_ptrs(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*src_ptr,
> +	union xfs_btree_ptr	*dst_ptr,
> +	int			numptrs)
> +{
> +	ASSERT(numptrs > 0);
> +
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be64));
> +	else
> +		memcpy(dst_ptr, src_ptr, numptrs * sizeof(__be32));
> +}

These should really use memmove, not memcpy. There is no guarantee
the source and destination do not overlap.

At minimum, we need comments to say this must only be used to
copy between blocks, and xfs_btree_move_ptrs() must be used to
copy within a block. I note the original patchset of mine
commented on this distinction when defining the ->move_* and
->copy_* operations.

FWIW, that also helps explain why they have different interfaces...

> +
>  /*
>   * Log block pointer fields from a btree block (nonleaf).
>   */
> @@ -1597,6 +1612,188 @@ error0:
>  }
>  
>  /*
> + * Move 1 record left from cur/level if possible.
> + * Update cur to reflect the new path.
> + */
> +int					/* error */
> +xfs_btree_lshift(
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	int			*stat)		/* success/failure */
> +{
> +	union xfs_btree_key	key;		/* btree key */
> +	struct xfs_buf		*lbp;		/* left buffer pointer */
> +	struct xfs_btree_block	*left;		/* left btree block */
> +	int			lrecs;		/* left record count */
> +	struct xfs_buf		*rbp;		/* right buffer pointer */
> +	struct xfs_btree_block	*right;		/* right btree block */
> +	int			rrecs;		/* right record count */
> +	union xfs_btree_ptr	lptr;		/* left btree pointer */
> +	union xfs_btree_key	*rkp = NULL;	/* right btree key */
> +	union xfs_btree_ptr	*rpp = NULL;	/* right address pointer */
> +	union xfs_btree_rec	*rrp = NULL;	/* right record pointer */
> +	int			error;		/* error return value */
> +#ifdef DEBUG
> +	int			i;		/* loop index */
> +#endif

This can be moved inside the branch it is used in.

> +	lrecs++;
> +	rrecs--;
> +
> +	XFS_BTREE_STATS_INC(cur, lshift);
> +
> +	/*
> +	 * If non-leaf, copy a key and a ptr to the left block.
> +	 * Log the changes to the left block.
> +	 */
> +	XFS_BTREE_STATS_ADD(cur, moves, 1);

Move the XFS_BTREE_STATS_ADD() above the comment to match the rshift
code.

Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
