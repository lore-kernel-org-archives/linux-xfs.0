Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 23:53:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U6qftb009224
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:52:41 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A940ED4BB0
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:53:53 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id GXzKxgktPf75N8PH for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 23:53:53 -0700 (PDT)
Date: Wed, 30 Jul 2008 16:53:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/21] implement generic xfs_btree_split
Message-ID: <20080730065349.GR13395@disturbed>
References: <20080729192113.493074843@verein.lst.de> <20080729193137.GR19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080729193137.GR19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:37PM +0200, Christoph Hellwig wrote:
> Make the btree split code generic.  Based on a patch from David Chinner
> with lots of changes to follow the original btree implementations more
> closely.  While this loses some of the generic helper routines for
> inserting/moving/removing records it also solves some of the one off
> bugs in the original code and makes it easier to verify.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> +STATIC void
> +xfs_btree_init_block(
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	int			numrecs,
> +	struct xfs_btree_block	*new)	/* new block */
> +{
> +	new->bb_h.bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
> +	new->bb_h.bb_level = cpu_to_be16(level);
> +	new->bb_h.bb_numrecs = cpu_to_be16(numrecs);
> +
> +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
> +		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
> +	} else {
> +		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
> +		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
> +	}
> +}

This is where I begin to question this approach (i.e. using
helpers like this rather than specific ops like I did). It's
taken me 4 ŏr 5 patches to put my finger on it.

The intent of this factorisation is to make implementing new btree
structures easy, not making the current code better or more
managable. The first thing we need is is btrees with different
header blocks (self describing information, CRCs, etc). This above
function will suddenly have four combinations to deal with - long and
short, version 1 and version 2 header formats. The more we change,
the more this complicates these helpers. That is why I pushed
seemingly trivial stuff out to operations vectors - because of the
future flexibility it allowed in implementation of new btrees.....

I don't see this a problem for this patch series, but I can see that
some of this work will end up being converted back to ops vectors
as soon as we start modifying between structures....


> +STATIC int
> +xfs_btree_get_buf_block(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_ptr	*ptr,
> +	int			flags,
> +	struct xfs_btree_block	**block,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_mount	*mp = cur->bc_mp;
> +	xfs_daddr_t		d;
> +
> +	/* need to sort out how callers deal with failures first */
> +	ASSERT(!(flags & XFS_BUF_TRYLOCK));
> +
> +	d = xfs_btree_ptr_to_daddr(cur, ptr);
> +	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
> +				 mp->m_bsize, flags);
> +
> +	ASSERT(*bpp);
> +	ASSERT(!XFS_BUF_GETERROR(*bpp));

xfs_trans_get_buf() can return NULL, right?

> +	/* block allocation / freeing */
> +	int	(*alloc_block)(struct xfs_btree_cur *cur,
> +			       union xfs_btree_ptr *sbno,
> +			       union xfs_btree_ptr *nbno,

start_bno, new_bno.

Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
