Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48882 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbeHJR2h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 13:28:37 -0400
Date: Fri, 10 Aug 2018 07:58:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs: repair the AGFL
Message-ID: <20180810145815.GB15083@magnolia>
References: <153370061966.25077.161884080659267764.stgit@magnolia>
 <153370063920.25077.18266205510701321535.stgit@magnolia>
 <20180809130857.GD21639@bfoster>
 <20180809180604.GA15083@magnolia>
 <20180810103417.GB27330@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810103417.GB27330@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Fri, Aug 10, 2018 at 06:34:17AM -0400, Brian Foster wrote:
> On Thu, Aug 09, 2018 at 11:06:04AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 09, 2018 at 09:08:58AM -0400, Brian Foster wrote:
> > > On Tue, Aug 07, 2018 at 08:57:19PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Repair the AGFL from the rmap data.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/scrub/agheader_repair.c |  284 ++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/scrub/bitmap.c          |   92 +++++++++++++
> > > >  fs/xfs/scrub/bitmap.h          |    4 +
> > > >  fs/xfs/scrub/repair.h          |    2 
> > > >  fs/xfs/scrub/scrub.c           |    2 
> > > >  5 files changed, 383 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > > > index 4842fc598c9b..0decf711b3c7 100644
> > > > --- a/fs/xfs/scrub/agheader_repair.c
> > > > +++ b/fs/xfs/scrub/agheader_repair.c
> > > > @@ -424,3 +424,287 @@ xrep_agf(
> > > ...
> > > > +/* Repair the AGFL. */
> > > > +int
> > > > +xrep_agfl(
> > > > +	struct xfs_scrub	*sc)
> > > > +{
> > > > +	struct xfs_owner_info	oinfo;
> > > > +	struct xfs_bitmap	agfl_extents;
> > > > +	struct xfs_mount	*mp = sc->mp;
> > > > +	struct xfs_buf		*agf_bp;
> > > > +	struct xfs_buf		*agfl_bp;
> > > > +	xfs_agblock_t		flcount;
> > > > +	int			error;
> > > > +
> > > > +	/* We require the rmapbt to rebuild anything. */
> > > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	xchk_perag_get(sc->mp, &sc->sa);
> > > > +	xfs_bitmap_init(&agfl_extents);
> > > > +
> > > > +	/*
> > > > +	 * Read the AGF so that we can query the rmapbt.  We hope that there's
> > > > +	 * nothing wrong with the AGF, but all the AG header repair functions
> > > > +	 * have this chicken-and-egg problem.
> > > > +	 */
> > > > +	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
> > > > +	if (error)
> > > > +		return error;
> > > > +	if (!agf_bp)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	/*
> > > > +	 * Make sure we have the AGFL buffer, as scrub might have decided it
> > > > +	 * was corrupt after xfs_alloc_read_agfl failed with -EFSCORRUPTED.
> > > > +	 */
> > > > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > > > +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGFL_DADDR(mp)),
> > > > +			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
> > > > +	if (error)
> > > > +		return error;
> > > > +	agfl_bp->b_ops = &xfs_agfl_buf_ops;
> > > > +
> > > > +	/* Gather all the extents we're going to put on the new AGFL. */
> > > > +	error = xrep_agfl_collect_blocks(sc, agf_bp, &agfl_extents, &flcount);
> > > > +	if (error)
> > > > +		goto err;
> > > > +
> > > > +	/*
> > > > +	 * Update AGF and AGFL.  We reset the global free block counter when
> > > > +	 * we adjust the AGF flcount (which can fail) so avoid updating any
> > > > +	 * buffers until we know that part works.
> > > > +	 */
> > > > +	error = xrep_agfl_update_agf(sc, agf_bp, flcount);
> > > > +	if (error)
> > > > +		goto err;
> > > > +	xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
> > > > +
> > > > +	/*
> > > > +	 * Ok, the AGFL should be ready to go now.  Roll the transaction to
> > > > +	 * make the new AGFL permanent before we start using it to return
> > > > +	 * freespace overflow to the freespace btrees.
> > > > +	 */
> > > > +	sc->sa.agf_bp = agf_bp;
> > > > +	sc->sa.agfl_bp = agfl_bp;
> > > > +	error = xrep_roll_ag_trans(sc);
> > > > +	if (error)
> > > > +		goto err;
> > > > +
> > > > +	/* Dump any AGFL overflow. */
> > > > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > > > +	return xrep_reap_extents(sc, &agfl_extents, &oinfo, XFS_AG_RESV_AGFL);
> > > > +err:
> > > > +	xfs_bitmap_destroy(&agfl_extents);
> > > > +	return error;
> > > 
> > > Was there a reason we don't maintain the ability to revert the AGFL on
> > > error as is done in the AGF repair case? I take it we'll end up shutting
> > > down the fs if anything causes us to fail once we've logged the
> > > associated agf fields in xrep_agfl_update_agf()..?
> > 
> > Yep.  Once we've started logging we don't really want to deal with the
> > complexity of rolling back a transaction.  The fs will shut down and the
> > admin can run xfs_repair instead.
> > 
> 
> Right, but AFAICT AGF repair avoids logging (despite changing on-disk
> buffers) to the transaction until the last step of calling
> xrep_agf_commit_new(). This facilitates the ability to revert to the old
> structure if something fails before the commit.

Hmm.  One thought I had is to have the AG header repairers allocate a
sc->buf buffer big enough to hold the old contents of the AGF/AGFL/AGI,
that way we get that off the stack for the AGF/AGI repair and for AGFL
repair we actually /can/ revert the AGF fl* fields and the AGFL itself
in the case of repair failure.

> The AGFL repair logs earlier, directly in the associated modifier
> functions (xrep_agfl_update_agf(), xrep_agfl_init_header()). Looking
> again, perhaps this is simply because there is no error vector here
> analogous to the xrep_agf_calc_from_btrees() work on the agf side (i.e.,
> no need for a _commit_new() helper either). Since xrep_agfl_update_agf()
> only ever returns zero, this may be a bit more obvious if we changed
> that to a void to show that there is no error path out of the code
> sequence that updates the repaired structure.

<nod> I think Dave was nudging me towards having common names in all the
repair functions to make them a little easier to understand, since they
(mostly) have the same structure.

> That nit aside, the rest looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

--D

> 
> > --D
> > 
> > > Brian
> > > 
> > > > +}
> > > > diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> > > > index c770e2d0b6aa..fdadc9e1dc49 100644
> > > > --- a/fs/xfs/scrub/bitmap.c
> > > > +++ b/fs/xfs/scrub/bitmap.c
> > > > @@ -9,6 +9,7 @@
> > > >  #include "xfs_format.h"
> > > >  #include "xfs_trans_resv.h"
> > > >  #include "xfs_mount.h"
> > > > +#include "xfs_btree.h"
> > > >  #include "scrub/xfs_scrub.h"
> > > >  #include "scrub/scrub.h"
> > > >  #include "scrub/common.h"
> > > > @@ -209,3 +210,94 @@ xfs_bitmap_disunion(
> > > >  }
> > > >  #undef LEFT_ALIGNED
> > > >  #undef RIGHT_ALIGNED
> > > > +
> > > > +/*
> > > > + * Record all btree blocks seen while iterating all records of a btree.
> > > > + *
> > > > + * We know that the btree query_all function starts at the left edge and walks
> > > > + * towards the right edge of the tree.  Therefore, we know that we can walk up
> > > > + * the btree cursor towards the root; if the pointer for a given level points
> > > > + * to the first record/key in that block, we haven't seen this block before;
> > > > + * and therefore we need to remember that we saw this block in the btree.
> > > > + *
> > > > + * So if our btree is:
> > > > + *
> > > > + *    4
> > > > + *  / | \
> > > > + * 1  2  3
> > > > + *
> > > > + * Pretend for this example that each leaf block has 100 btree records.  For
> > > > + * the first btree record, we'll observe that bc_ptrs[0] == 1, so we record
> > > > + * that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
> > > > + * block 4.  The list is [1, 4].
> > > > + *
> > > > + * For the second btree record, we see that bc_ptrs[0] == 2, so we exit the
> > > > + * loop.  The list remains [1, 4].
> > > > + *
> > > > + * For the 101st btree record, we've moved onto leaf block 2.  Now
> > > > + * bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
> > > > + * bc_ptrs[1] == 2, so we exit the loop.  The list is now [1, 4, 2].
> > > > + *
> > > > + * For the 102nd record, bc_ptrs[0] == 2, so we continue.
> > > > + *
> > > > + * For the 201st record, we've moved on to leaf block 3.  bc_ptrs[0] == 1, so
> > > > + * we add 3 to the list.  Now it is [1, 4, 2, 3].
> > > > + *
> > > > + * For the 300th record we just exit, with the list being [1, 4, 2, 3].
> > > > + */
> > > > +
> > > > +/*
> > > > + * Record all the buffers pointed to by the btree cursor.  Callers already
> > > > + * engaged in a btree walk should call this function to capture the list of
> > > > + * blocks going from the leaf towards the root.
> > > > + */
> > > > +int
> > > > +xfs_bitmap_set_btcur_path(
> > > > +	struct xfs_bitmap	*bitmap,
> > > > +	struct xfs_btree_cur	*cur)
> > > > +{
> > > > +	struct xfs_buf		*bp;
> > > > +	xfs_fsblock_t		fsb;
> > > > +	int			i;
> > > > +	int			error;
> > > > +
> > > > +	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
> > > > +		xfs_btree_get_block(cur, i, &bp);
> > > > +		if (!bp)
> > > > +			continue;
> > > > +		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> > > > +		error = xfs_bitmap_set(bitmap, fsb, 1);
> > > > +		if (error)
> > > > +			return error;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/* Collect a btree's block in the bitmap. */
> > > > +STATIC int
> > > > +xfs_bitmap_collect_btblock(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	int			level,
> > > > +	void			*priv)
> > > > +{
> > > > +	struct xfs_bitmap	*bitmap = priv;
> > > > +	struct xfs_buf		*bp;
> > > > +	xfs_fsblock_t		fsbno;
> > > > +
> > > > +	xfs_btree_get_block(cur, level, &bp);
> > > > +	if (!bp)
> > > > +		return 0;
> > > > +
> > > > +	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> > > > +	return xfs_bitmap_set(bitmap, fsbno, 1);
> > > > +}
> > > > +
> > > > +/* Walk the btree and mark the bitmap wherever a btree block is found. */
> > > > +int
> > > > +xfs_bitmap_set_btblocks(
> > > > +	struct xfs_bitmap	*bitmap,
> > > > +	struct xfs_btree_cur	*cur)
> > > > +{
> > > > +	return xfs_btree_visit_blocks(cur, xfs_bitmap_collect_btblock, bitmap);
> > > > +}
> > > > diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> > > > index dad652ee9177..ae8ecbce6fa6 100644
> > > > --- a/fs/xfs/scrub/bitmap.h
> > > > +++ b/fs/xfs/scrub/bitmap.h
> > > > @@ -28,5 +28,9 @@ void xfs_bitmap_destroy(struct xfs_bitmap *bitmap);
> > > >  
> > > >  int xfs_bitmap_set(struct xfs_bitmap *bitmap, uint64_t start, uint64_t len);
> > > >  int xfs_bitmap_disunion(struct xfs_bitmap *bitmap, struct xfs_bitmap *sub);
> > > > +int xfs_bitmap_set_btcur_path(struct xfs_bitmap *bitmap,
> > > > +		struct xfs_btree_cur *cur);
> > > > +int xfs_bitmap_set_btblocks(struct xfs_bitmap *bitmap,
> > > > +		struct xfs_btree_cur *cur);
> > > >  
> > > >  #endif	/* __XFS_SCRUB_BITMAP_H__ */
> > > > diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > > > index 6f0903c51a47..1d283360b5ab 100644
> > > > --- a/fs/xfs/scrub/repair.h
> > > > +++ b/fs/xfs/scrub/repair.h
> > > > @@ -59,6 +59,7 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
> > > >  int xrep_probe(struct xfs_scrub *sc);
> > > >  int xrep_superblock(struct xfs_scrub *sc);
> > > >  int xrep_agf(struct xfs_scrub *sc);
> > > > +int xrep_agfl(struct xfs_scrub *sc);
> > > >  
> > > >  #else
> > > >  
> > > > @@ -83,6 +84,7 @@ xrep_calc_ag_resblks(
> > > >  #define xrep_probe			xrep_notsupported
> > > >  #define xrep_superblock			xrep_notsupported
> > > >  #define xrep_agf			xrep_notsupported
> > > > +#define xrep_agfl			xrep_notsupported
> > > >  
> > > >  #endif /* CONFIG_XFS_ONLINE_REPAIR */
> > > >  
> > > > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > > > index 1e8a17c8e2b9..2670f4cf62f4 100644
> > > > --- a/fs/xfs/scrub/scrub.c
> > > > +++ b/fs/xfs/scrub/scrub.c
> > > > @@ -220,7 +220,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
> > > >  		.type	= ST_PERAG,
> > > >  		.setup	= xchk_setup_fs,
> > > >  		.scrub	= xchk_agfl,
> > > > -		.repair	= xrep_notsupported,
> > > > +		.repair	= xrep_agfl,
> > > >  	},
> > > >  	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
> > > >  		.type	= ST_PERAG,
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
