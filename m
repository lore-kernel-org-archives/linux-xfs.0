Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 23:07:10 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U675SS004297
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:07:06 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFD1619531CF
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:08:17 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id IB36CGeu8OEgOEvS for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:08:17 -0700 (PDT)
Date: Wed, 30 Jul 2008 16:08:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/21] implement generic xfs_btree_rshift
Message-ID: <20080730060808.GP13395@disturbed>
References: <20080729193125.GP19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193125.GP19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:25PM +0200, Christoph Hellwig wrote:
> Make the btree right shift code generic.  Based on a patch from David Chinner
> with lots of changes to follow the original btree implementations more
> closely.  While this loses some of the generic helper routines for
> inserting/moving/removing records it also solves some of the one off
> bugs in the original code and makes it easier to verify.

Looks good. A few comments below.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-27 17:40:52.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-28 16:13:33.000000000 +0200
> @@ -34,6 +34,7 @@
>  #include "xfs_attr_sf.h"
>  #include "xfs_dinode.h"
>  #include "xfs_inode.h"
> +#include "xfs_inode_item.h"
>  #include "xfs_btree.h"
>  #include "xfs_btree_trace.h"
>  #include "xfs_ialloc.h"
> @@ -952,6 +953,123 @@ xfs_btree_read_buf_block(
>  	return xfs_btree_check_block(cur, *block, level, *bpp);
>  }
>  
> +STATIC void
> +xfs_btree_move_ptrs(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*base,
> +	int			from,
> +	int			to,
> +	int			numptrs)
> +{
> +	ASSERT(from >= 0 && from <= 1000);
> +	ASSERT(to >= 0 && to <= 1000);
> +	ASSERT(numptrs >= 0);

Those numbers are not safe. I plucked them out of thin air to verify
validity on 4k block size filesystem which had (IIRC) a max of about
500 ptrs to a block. It was throwaway debug code to find a problem.
Larger block sizes can well exceed 1000. So realistically, the only
valid assert there is this one:

	ASSERT(numptrs >= 0);

> +/*
> + * Log block pointer fields from a btree block (nonleaf).
> + */
> +STATIC void
> +xfs_btree_log_ptrs(
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
> +	struct xfs_buf		*bp,	/* buffer containing btree block */
> +	int			pfirst,	/* index of first pointer to log */
> +	int			plast)	/* index of last pointer to log */

I'd call these first/last (being indexes), and these:

> +{
> +
> +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> +	XFS_BTREE_TRACE_ARGBII(cur, bp, pfirst, plast);
> +
> +	if (bp) {
> +		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> +		union xfs_btree_ptr	*pp;
> +		int			first;	/* first byte offset logged */
> +		int			last;	/* last byte offset logged */

start/end because they are byte range identifiers.

> +
> +		pp = cur->bc_ops->ptr_addr(cur, 1, block);
> +
> +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +			__be64		*lpp = &pp->l;
> +
> +			first = (int)((xfs_caddr_t)&lpp[pfirst - 1] -
> +					(xfs_caddr_t)block);
> +			last = (int)(((xfs_caddr_t)&lpp[plast] - 1) -
> +					(xfs_caddr_t)block);
> +		} else {
> +			__be32		*spp = &pp->s;
> +
> +			first = (int)((xfs_caddr_t)&spp[pfirst - 1] -
> +					(xfs_caddr_t)block);
> +			last = (int)(((xfs_caddr_t)&spp[plast] - 1) -
> +					(xfs_caddr_t)block);

Hmmmm. That's not very nice with all those casts. It's clear that
it's pointer arithmetic, but rather messy.

> +		}
> +
> +		xfs_trans_log_buf(cur->bc_tp, bp, first, last);

How about:

		union xfs_btree_ptr	*pp;
		xfs_caddr_t		*block = XFS_BUF_TO_BLOCK(bp);
		xfs_caddr_t		start;	/* first byte offset logged */
		xfs_caddr_t		end;	/* last byte offset logged */

		pp = cur->bc_ops->ptr_addr(cur, 1, XFS_BUF_TO_BLOCK(bp));

		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
			__be64		*lpp = &pp->l;

			start = (xfs_caddr_t)&lpp[first - 1] - block;
			end  = ((xfs_caddr_t)&lpp[last] - 1) - block;
		} else {
			__be32		*spp = &pp->s;

			start = (xfs_caddr_t)&spp[first - 1] - block;
			end  = ((xfs_caddr_t)&spp[last] - 1) - block;
		}

		xfs_trans_log_buf(cur->bc_tp, bp, (int)start, (int)end);

That makes it much easier to read (to me, anyway).

> +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> +	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
> +
> +	if (bp) {
> +		xfs_btree_offsets(fields,
> +				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
> +				  	loffsets : soffsets,
                                ^^
Some stray whitespace there.

> +				  XFS_BB_NUM_BITS, &first, &last);
> +		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
> +	} else {
> +		/* XXX(hch): maybe factor out into a method? */
> +		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
> +			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));

I don't think it is necessary at this point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
