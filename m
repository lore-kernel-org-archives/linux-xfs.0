Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49074 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbeAPGfX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 01:35:23 -0500
Date: Mon, 15 Jan 2018 22:30:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 16/21] xfs: cross-reference inode btrees during scrub
Message-ID: <20180116063018.GG5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398987068.18741.4829286717637372866.stgit@magnolia>
 <20180109212218.GK5602@magnolia>
 <20180115221711.GB16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180115221711.GB16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 09:17:11AM +1100, Dave Chinner wrote:
> On Tue, Jan 09, 2018 at 01:22:18PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Cross-reference the inode btrees with the other metadata when we
> > scrub the filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: streamline scrubber arguments, remove stack allocated objects
> > ---
> >  fs/xfs/scrub/agheader.c |   19 +++++++++++++
> >  fs/xfs/scrub/alloc.c    |    1 +
> >  fs/xfs/scrub/bmap.c     |    1 +
> >  fs/xfs/scrub/ialloc.c   |   70 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/inode.c    |   49 +++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/refcount.c |    1 +
> >  fs/xfs/scrub/rmap.c     |    4 +++
> >  fs/xfs/scrub/scrub.h    |    4 +++
> >  8 files changed, 149 insertions(+)
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 3b66cd4..4d4ce1f 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -122,6 +122,7 @@ xfs_scrub_superblock_xref(
> >  		return;
> >  
> >  	xfs_scrub_xref_is_used_space(sc, agbno, 1);
> > +	xfs_scrub_xref_not_inodes(sc, agbno, 1);
> 
> Seems a bit strange to have "is" in "_is_used_space" and then don't
> put it in "_is_not_inodes"....

It does now. :)

> > @@ -752,6 +760,17 @@ xfs_scrub_agi_xref(
> >  		return;
> >  
> >  	xfs_scrub_xref_is_used_space(sc, agbno, 1);
> > +	xfs_scrub_xref_not_inodes(sc, agbno, 1);
> 
> Hmmm, what this actually means is "_is_not_inode_chunk", right?
> Kinda obscure to have the inode index checking it's "not inodes" :P

<nod>

> > +	if (sc->sa.ino_cur) {
> > +		error = xfs_ialloc_count_inodes(sc->sa.ino_cur, &icount,
> > +				&freecount);
> > +		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur) &&
> > +		    (be32_to_cpu(agi->agi_count) != icount ||
> > +		     be32_to_cpu(agi->agi_freecount) != freecount))
> > +			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> > +	}
> 
> Reduce the indent by doing:
> 
> if (!sc->sa.ino_cur)
> 	return;
> 
> ?

The downside is that later patches add more stuff after that, and we
don't necessarily want to abort the other xref checks just because we
failed to get/bombed out of getting the ino_cur.

<shrug> OTOH I guess that hunk could just be a(nother) static inline
function, which would make the _xref functions less messy.

> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 4526894..34c133e 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -67,10 +67,32 @@ xfs_scrub_iallocbt_chunk_xref(
> >  	xfs_agblock_t			agbno,
> >  	xfs_extlen_t			len)
> >  {
> > +	struct xfs_btree_cur		**pcur;
> > +	bool				has_irec;
> > +	int				error;
> > +
> >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> >  		return;
> >  
> >  	xfs_scrub_xref_is_used_space(sc, agbno, len);
> > +
> > +	/*
> > +	 * If we're checking the finobt, cross-reference with the inobt.
> > +	 * Otherwise we're checking the inobt; if there is an finobt,
> > +	 * make sure we have a record or not depending on freecount.
> > +	 */
> > +	if (sc->sm->sm_type == XFS_SCRUB_TYPE_FINOBT)
> > +		pcur = &sc->sa.ino_cur;
> > +	else
> > +		pcur = &sc->sa.fino_cur;
> > +	if (*pcur) {
> > +		error = xfs_ialloc_has_inode_record(*pcur,
> > +				agino, agino, &has_irec);
> > +		if (xfs_scrub_should_check_xref(sc, &error, pcur) &&
> > +		    ((irec->ir_freecount > 0 && !has_irec) ||
> > +		     (irec->ir_freecount == 0 && has_irec)))
> > +			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
> > +	}
> 
> Same here?

<nod>

> >  }
> >  
> >  /* Is this chunk worth checking? */
> > @@ -352,3 +374,51 @@ xfs_scrub_finobt(
> >  {
> >  	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
> >  }
> > +
> > +/* xref check that the extent is not covered by inodes */
> > +void
> > +xfs_scrub_xref_not_inodes(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_agblock_t			bno,
> > +	xfs_extlen_t			len)
> > +{
> > +	bool				has_inodes;
> > +	int				error;
> > +
> > +	if (sc->sa.ino_cur) {
> > +		error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur, bno,
> > +				len, &has_inodes);
> > +		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur) &&
> > +		    has_inodes)
> > +			xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.ino_cur, 0);
> > +	}
> > +
> > +	if (sc->sa.fino_cur) {
> > +		error = xfs_ialloc_has_inodes_at_extent(sc->sa.fino_cur, bno,
> > +				len, &has_inodes);
> > +		if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.fino_cur) &&
> > +		    has_inodes)
> > +			xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.fino_cur,
> > +					0);
> > +	}
> > +}
> > +
> > +/* xref check that the extent is covered by inodes */
> > +void
> > +xfs_scrub_xref_are_inodes(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_agblock_t			bno,
> > +	xfs_extlen_t			len)
> > +{
> > +	bool				has_inodes;
> > +	int				error;
> > +
> > +	if (!sc->sa.ino_cur)
> > +		return;
> > +
> > +	error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur, bno,
> > +			len, &has_inodes);
> > +	if (xfs_scrub_should_check_xref(sc, &error, &sc->sa.ino_cur) &&
> > +	    !has_inodes)
> > +		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.ino_cur, 0);
> > +}
> 
> That's 3 copies of that check and error handling.
> 
> xfs_scrub_xref_inode_check(
> 	struct xfs_scrub_context	*sc,
> 	xfs_agblock_t			bno,
> 	xfs_extlen_t			len,
> 	struct xfs_btree_cursor		**icur))
> {
> 	error = xfs_ialloc_has_inodes_at_extent(*icur, bno, len, &has_inodes);
> 	if (xfs_scrub_should_check_xref(sc, &error, icur) &&
> 	    !has_inodes)
> 		xfs_scrub_btree_xref_set_corrupt(sc, *icur, 0);
> }
> 
> And the callers become:
> 
> 	if (sc->sa.ino_cur)
> 		xfs_scrub_xref_inode_check(sc, bno, len, &sc->sa.ino_cur);
> 
> I find that much easier to read...

<nod>

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
