Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbeEPRPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 13:15:52 -0400
Date: Wed, 16 May 2018 10:15:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/22] xfs: add helpers to allocate and initialize fresh
 btree roots
Message-ID: <20180516171548.GH23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363169.1556.14593532407537096653.stgit@magnolia>
 <20180516070746.GQ23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516070746.GQ23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 05:07:46PM +1000, Dave Chinner wrote:
> On Tue, May 15, 2018 at 03:33:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a pair of helper functions to allocate and initialize fresh btree
> > roots.  The repair functions will use these as part of recreating
> > corrupted metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/repair.h |    6 ++++
> >  2 files changed, 87 insertions(+)
> 
> Looks good, but....
> 
> > +/* Initialize a new AG btree root block with zero entries. */
> > +int
> > +xfs_repair_init_btblock(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_fsblock_t			fsb,
> > +	struct xfs_buf			**bpp,
> > +	xfs_btnum_t			btnum,
> > +	const struct xfs_buf_ops	*ops)
> > +{
> > +	struct xfs_trans		*tp = sc->tp;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_buf			*bp;
> > +
> > +	trace_xfs_repair_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
> > +			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
> > +
> > +	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
> > +	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, fsb),
> > +			XFS_FSB_TO_BB(mp, 1), 0);
> > +	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> > +	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno,
> > +			XFS_BTREE_CRC_BLOCKS);
> 
> This flag does nothing in xfs_btree_init_block(). Any reason for
> setting it?

Nope.  Will fix.

> With that fixed, though,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > +	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
> > +	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
> > +	bp->b_ops = ops;
> > +	*bpp = bp;
> > +
> > +	return 0;
> > +}
> 
> For followup patches, I think there's some overlap with the new
> libxfs/xfs_ag.c functions for initialising new btree root blocks for
> growfs? e.g. Make the struct xfs_aghdr_grow_data aghdr_data[] array
> a static global, and then we can do something like:
> 
> 	bp = xfs_ag_init_btroot(mp, tp, agno, agbno, btnum);
> 	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
> 
> and all the details of reading the btree block and setting it up go
> away from this code....

I'm not sure aghdr_data can be made static global since parts of it
depend on the struct xfs_mount, but at the very least we should try to
refactor this (in the followup series) to simplify the repair code.

There may be complications relating to the xfs_*root_init functions
initializing default records that are appropriate for a freshly created
AG that are totally wrong for regenerating a broken AG, and in any case
repair really requires totally empty root blocks since it has already
generated the list of records it's going to put into the new btree.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
