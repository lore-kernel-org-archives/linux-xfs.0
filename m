Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54838 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAPGsL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 01:48:11 -0500
Date: Mon, 15 Jan 2018 22:38:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 17/21] xfs: cross-reference reverse-mapping btree
Message-ID: <20180116063806.GH5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398987679.18741.2129470901020229164.stgit@magnolia>
 <20180109212449.GL5602@magnolia>
 <20180115230417.GC16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180115230417.GC16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 10:04:17AM +1100, Dave Chinner wrote:
> On Tue, Jan 09, 2018 at 01:24:49PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When scrubbing various btrees, we should cross-reference the records
> > with the reverse mapping btree and ensure that traversing the btree
> > finds the same number of blocks that the rmapbt thinks are owned by
> > that btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: streamline scrubber arguments, remove stack allocated objects
> > ---
> 
> .....
> 
> > diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> > index 2a58558..b4defa4 100644
> > --- a/fs/xfs/scrub/alloc.c
> > +++ b/fs/xfs/scrub/alloc.c
> > @@ -105,6 +105,7 @@ xfs_scrub_allocbt_xref(
> >  
> >  	xfs_scrub_allocbt_xref_other(sc, agbno, len);
> >  	xfs_scrub_xref_not_inodes(sc, agbno, len);
> > +	xfs_scrub_xref_no_rmap(sc, agbno, len);
> 
> Hmmm - this is actually checking the rmap considers it free space,
> right? so rather than cross referencing is as "no rmap record"
> (which bleeds implementation into the API), wouldn't it be better
> to name this consistently with the other used/free space xref
> checks?  e.g. xfs_scrub_xref_rmap_is_free_space()?

Yes.

> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index d2b4747..ef7b461 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -99,6 +99,109 @@ struct xfs_scrub_bmap_info {
> >  	int				whichfork;
> >  };
> >  
> > +/* Make sure that we have rmapbt records for this extent. */
> > +STATIC void
> > +xfs_scrub_bmap_xref_rmap(
> > +	struct xfs_scrub_bmap_info	*info,
> > +	struct xfs_bmbt_irec		*irec,
> > +	xfs_fsblock_t			bno)
> > +{
> > +	struct xfs_rmap_irec		rmap;
> > +	uint64_t			owner;
> > +	xfs_fileoff_t			offset;
> > +	unsigned long long		rmap_end;
> > +	unsigned int			rflags;
> > +	int				has_rmap;
> > +	int				error;
> > +
> > +	if (!info->sc->sa.rmap_cur)
> > +		return;
> > +	if (info->whichfork == XFS_COW_FORK) {
> > +		owner = XFS_RMAP_OWN_COW;
> > +		offset = 0;
> > +	} else {
> > +		owner = info->sc->ip->i_ino;
> > +		offset = irec->br_startoff;
> > +	}
> > +
> > +	/* Look for a corresponding rmap. */
> > +	rflags = 0;
> > +	if (info->whichfork == XFS_ATTR_FORK)
> > +		rflags |= XFS_RMAP_ATTR_FORK;
> > +
> > +	if (info->is_shared) {
> 
> What's this mean?

is_shared is true if the passed-in irec represents a data fork extent
of a reflink inode.  I'll add a comment to explain how we end up in this
block and why we have to use range lookup here.

> > +		error = xfs_rmap_lookup_le_range(info->sc->sa.rmap_cur, bno,
> > +				owner, offset, rflags, &rmap, &has_rmap);
> > +		if (!xfs_scrub_should_check_xref(info->sc, &error,
> > +				&info->sc->sa.rmap_cur))
> > +			return;
> > +		if (!has_rmap) {
> > +			xfs_scrub_fblock_xref_set_corrupt(info->sc,
> > +					info->whichfork, irec->br_startoff);
> > +			return;
> > +		}
> > +	} else {
> > +		error = xfs_rmap_lookup_le(info->sc->sa.rmap_cur, bno, 0, owner,
> > +				offset, rflags, &has_rmap);
> > +		if (!xfs_scrub_should_check_xref(info->sc, &error,
> > +				&info->sc->sa.rmap_cur))
> > +			return;
> > +		if (!has_rmap) {
> > +			xfs_scrub_fblock_xref_set_corrupt(info->sc,
> > +					info->whichfork, irec->br_startoff);
> > +			return;
> > +		}
> > +
> > +		error = xfs_rmap_get_rec(info->sc->sa.rmap_cur, &rmap,
> > +				&has_rmap);
> > +		if (!xfs_scrub_should_check_xref(info->sc, &error,
> > +				&info->sc->sa.rmap_cur))
> > +			return;
> > +		if (!has_rmap) {
> > +			xfs_scrub_fblock_xref_set_corrupt(info->sc,
> > +					info->whichfork, irec->br_startoff);
> > +			return;
> > +		}
> > +	}
> 
> i.e. why is one branch doing a range lookup, and the other not?
> Perhaps this should also be put in a helper function....
> 
> > +
> > +	/* Check the rmap. */
> > +	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
> > +	if (rmap.rm_startblock > bno ||
> > +	    bno + irec->br_blockcount > rmap_end)
> > +		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
> > +				irec->br_startoff);
> > +
> > +	if (owner != XFS_RMAP_OWN_COW) {
> > +		rmap_end = (unsigned long long)rmap.rm_offset +
> > +				rmap.rm_blockcount;
> > +		if (rmap.rm_offset > offset ||
> > +		    offset + irec->br_blockcount > rmap_end)
> > +			xfs_scrub_fblock_xref_set_corrupt(info->sc,
> > +					info->whichfork, irec->br_startoff);
> > +	} else {
> > +		/*
> > +		 * We don't set the unwritten flag for CoW
> > +		 * staging extent rmaps; everything is unwritten.
> > +		 */
> > +		irec->br_state = XFS_EXT_NORM;
> > +	}
> 
> There are two unrelated things in the different branches. Shouldn't
> this irec mod be done right at the start where we are setting up for
> cow vs non-cow fork checks?

Ok.

> .....
> 
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index 68fea09..d3aaa6a 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -325,6 +325,53 @@ xfs_scrub_set_incomplete(
> >  }
> >  
> >  /*
> > + * rmap scrubbing -- compute the number of blocks with a given owner,
> > + * at least according to the reverse mapping data.
> > + */
> > +
> > +struct xfs_scrub_rmap_ownedby_info {
> > +	struct xfs_owner_info	*oinfo;
> > +	xfs_filblks_t		*blocks;
> > +};
> > +
> > +STATIC int
> > +xfs_scrub_count_rmap_ownedby_helper(
> 
> xfs_scrub_count_rmap_ownedby_irec()

Ok.

> > +	struct xfs_btree_cur			*cur,
> > +	struct xfs_rmap_irec			*rec,
> > +	void					*priv)
> > +{
> > +	struct xfs_scrub_rmap_ownedby_info	*sroi = priv;
> > +
> > +	if (rec->rm_owner == sroi->oinfo->oi_owner &&
> > +	    (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> > +	     !!(rec->rm_flags & XFS_RMAP_ATTR_FORK) ==
> > +	     !!(sroi->oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)))
> 
> Urk! that takes some parsing. Perhaps something like this?
> 
> 	bool irec_attr = (rec->rm_flags & XFS_RMAP_ATTR_FORK);
> 	bool oinfo_attr = (sroi->oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK);
> 
> 	if (rec->rm_owner != sroi->oinfo->oi_owner)
> 		return 0;
> 	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> 	    irec_attr == oinfo_attr)
> 		(*sroi->blocks) += rec->rm_blockcount;
> 	return 0;
> 
> ?

Yep.

> >  	}
> > +
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> > +	xfs_scrub_xref_owned_by(sc, agbno, len, &oinfo);
> >  }
> >  
> >  /* Is this chunk worth checking? */
> > @@ -228,6 +232,13 @@ xfs_scrub_iallocbt_check_freemask(
> >  			continue;
> >  		}
> >  
> > +		if (ir_holemask == 0)
> > +			xfs_scrub_xref_owned_by(bs->sc, agbno,
> > +					blks_per_cluster, &oinfo);
> > +		else
> > +			xfs_scrub_xref_not_owned_by(bs->sc, agbno,
> > +					blks_per_cluster, &oinfo);
> > +
> >  		/* If any part of this is a hole, skip it. */
> >  		if (ir_holemask)
> >  			continue;
> 
> I think these two conditions should be combined, along with an
> update to the comment about holes not containing inode chunks?

Ok.

> > @@ -266,6 +277,7 @@ xfs_scrub_iallocbt_rec(
> >  	union xfs_btree_rec		*rec)
> >  {
> >  	struct xfs_mount		*mp = bs->cur->bc_mp;
> > +	xfs_filblks_t			*inode_blocks = bs->private;
> >  	struct xfs_inobt_rec_incore	irec;
> >  	uint64_t			holes;
> >  	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> > @@ -302,6 +314,8 @@ xfs_scrub_iallocbt_rec(
> >  	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
> >  	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
> >  		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> > +	*inode_blocks += XFS_B_TO_FSB(mp,
> > +			irec.ir_count * mp->m_sb.sb_inodesize);
> 
> Line of whitespace to separate the corruption checks from the
> accounting logic?

Oops, sorry about that.

> >  
> >  	/* Handle non-sparse inodes */
> >  	if (!xfs_inobt_issparse(irec.ir_holemask)) {
> > @@ -347,6 +361,56 @@ xfs_scrub_iallocbt_rec(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Make sure the inode btrees are as large as the rmap thinks they are.
> > + * Don't bother if we're missing btree cursors, as we're already corrupt.
> > + */
> > +STATIC void
> > +xfs_scrub_iallocbt_xref_rmap(
> > +	struct xfs_scrub_context	*sc,
> > +	int				which,
> > +	struct xfs_owner_info		*oinfo,
> > +	xfs_filblks_t			inode_blocks)
> > +{
> > +	xfs_filblks_t			blocks;
> > +	xfs_extlen_t			inobt_blocks = 0;
> > +	xfs_extlen_t			finobt_blocks = 0;
> > +	int				error;
> > +
> > +	if (!sc->sa.ino_cur || !sc->sa.rmap_cur)
> > +		return;
> > +
> > +	/* Check that we saw as many inobt blocks as the rmap says. */
> > +	error = xfs_btree_count_blocks(sc->sa.ino_cur, &inobt_blocks);
> > +	if (error)
> > +		return;
> 
> Shouldn't a failure set some kind of corruption flag here rather
> than silently failing?

Yes.

> > +
> > +	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
> > +		if (!sc->sa.fino_cur)
> > +			return;
> 
> Put this check at the start with the other cursor checks.

Ok.

> .....
> > @@ -355,10 +419,20 @@ xfs_scrub_iallocbt(
> >  {
> >  	struct xfs_btree_cur		*cur;
> >  	struct xfs_owner_info		oinfo;
> > +	xfs_filblks_t			inode_blocks = 0;
> > +	int				error;
> >  
> >  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> >  	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
> > -	return xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_rec, &oinfo, NULL);
> > +	error = xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_rec, &oinfo,
> > +			&inode_blocks);
> > +	if (error)
> > +		return error;
> > +
> > +	if (which == XFS_BTNUM_INO)
> > +		xfs_scrub_iallocbt_xref_rmap(sc, which, &oinfo, inode_blocks);
> 
> Why do we only xref the inobt?

Hmm.  The goal of this function is to ensure that there are as many
OWN_INOBT blocks in the rmapbt as there are blocks in the inobt/finobt.

In theory we only need to check this once per scrub run (in which we're
guaranteed to scan both inode btrees) though from the perspective of
individual scrub ioctl calls, we probably ought to call this from either
scrubber for completeness.

> .....
> > diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> > index 02704b0..8421c6e 100644
> > --- a/fs/xfs/scrub/rmap.c
> > +++ b/fs/xfs/scrub/rmap.c
> > @@ -157,3 +157,66 @@ xfs_scrub_rmapbt(
> >  	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_rec,
> >  			&oinfo, NULL);
> >  }
> > +
> > +/* xref check that the extent is owned by a given owner */
> > +static inline void
> > +xfs_scrub_xref_check_owner(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_agblock_t			bno,
> > +	xfs_extlen_t			len,
> > +	struct xfs_owner_info		*oinfo,
> > +	bool				fs_ok)
> 
> Not sure about this variable name. "record_should_exist"?

Yep.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
