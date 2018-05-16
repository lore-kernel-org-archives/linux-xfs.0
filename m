Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4021 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750995AbeEPHHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 03:07:49 -0400
Date: Wed, 16 May 2018 17:07:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/22] xfs: add helpers to allocate and initialize fresh
 btree roots
Message-ID: <20180516070746.GQ23861@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363169.1556.14593532407537096653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152642363169.1556.14593532407537096653.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 15, 2018 at 03:33:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a pair of helper functions to allocate and initialize fresh btree
> roots.  The repair functions will use these as part of recreating
> corrupted metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/repair.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.h |    6 ++++
>  2 files changed, 87 insertions(+)

Looks good, but....

> +/* Initialize a new AG btree root block with zero entries. */
> +int
> +xfs_repair_init_btblock(
> +	struct xfs_scrub_context	*sc,
> +	xfs_fsblock_t			fsb,
> +	struct xfs_buf			**bpp,
> +	xfs_btnum_t			btnum,
> +	const struct xfs_buf_ops	*ops)
> +{
> +	struct xfs_trans		*tp = sc->tp;
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_buf			*bp;
> +
> +	trace_xfs_repair_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
> +			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
> +
> +	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
> +	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, fsb),
> +			XFS_FSB_TO_BB(mp, 1), 0);
> +	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> +	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno,
> +			XFS_BTREE_CRC_BLOCKS);

This flag does nothing in xfs_btree_init_block(). Any reason for
setting it?

With that fixed, though,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
> +	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
> +	bp->b_ops = ops;
> +	*bpp = bp;
> +
> +	return 0;
> +}

For followup patches, I think there's some overlap with the new
libxfs/xfs_ag.c functions for initialising new btree root blocks for
growfs? e.g. Make the struct xfs_aghdr_grow_data aghdr_data[] array
a static global, and then we can do something like:

	bp = xfs_ag_init_btroot(mp, tp, agno, agbno, btnum);
	xfs_trans_log_buf(tp, bp, 0, bp->b_length);

and all the details of reading the btree block and setting it up go
away from this code....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
