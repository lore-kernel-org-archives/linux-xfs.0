Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38252 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755504AbeAIAer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 19:34:47 -0500
Date: Mon, 8 Jan 2018 16:34:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/21] xfs: cross-reference with the bnobt
Message-ID: <20180109003441.GB5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398985848.18741.1443595678961710395.stgit@magnolia>
 <20180108235125.GG16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108235125.GG16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 10:51:25AM +1100, Dave Chinner wrote:
> On Fri, Dec 22, 2017 at 04:44:18PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're scrubbing various btrees, cross-reference the records with
> > the bnobt to ensure that we don't also think the space is free.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/agheader.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/alloc.c    |   19 +++++++++++
> >  fs/xfs/scrub/bmap.c     |   21 +++++++++++-
> >  fs/xfs/scrub/btree.c    |   12 +++++++
> >  fs/xfs/scrub/ialloc.c   |    1 +
> >  fs/xfs/scrub/inode.c    |   15 ++++++++
> >  fs/xfs/scrub/refcount.c |    1 +
> >  fs/xfs/scrub/rmap.c     |    4 ++
> >  fs/xfs/scrub/scrub.h    |    5 +++
> >  9 files changed, 161 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 5be9059..3bb0f96 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -107,6 +107,20 @@ xfs_scrub_superblock_xref(
> >  	struct xfs_scrub_context	*sc,
> >  	struct xfs_buf			*bp)
> >  {
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_agnumber_t			agno = sc->sm->sm_agno;
> > +	xfs_agblock_t			bno;
> > +	int				error;
> > +
> > +	bno = XFS_SB_BLOCK(mp);
> 
> 	agbno

Fixed (and all the others).

> > +
> > +	error = xfs_scrub_ag_init(sc, agno, &sc->sa);
> > +	if (!xfs_scrub_xref_process_error(sc, agno, bno, &error))
> > +		return;
> > +
> > +	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
> 
> "xref_not_free". That doesn't tell me what it's actually checking
> is not free, or what it's checking against. Seeing as we're checking
> these all against the bnobt, wouldn't something like this be more
> obvious:
> 
> 	xfs_scrub_is_used_space(sc, agbno, 1);

I've been trying to keep "xref" in the name of the functions that help
us do cross-referencing, but you're right that the **pcur parameter can
drop out.  I'll ... do that. :)

> > +	/* scrub teardown will take care of sc->sa for us */
> >  }
> >  
> >  /*
> > @@ -407,11 +421,51 @@ xfs_scrub_superblock(
> >  
> >  /* AGF */
> >  
> > +/* Tally freespace record lengths. */
> > +STATIC int
> > +xfs_scrub_agf_record_bno_lengths(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_alloc_rec_incore	*rec,
> > +	void				*priv)
> > +{
> > +	xfs_extlen_t			*blocks = priv;
> > +
> > +	(*blocks) += rec->ar_blockcount;
> > +	return 0;
> > +}
> > +
> >  /* Cross-reference with the other btrees. */
> >  STATIC void
> >  xfs_scrub_agf_xref(
> >  	struct xfs_scrub_context	*sc)
> >  {
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> > +	struct xfs_btree_cur		**pcur;
> > +	xfs_agblock_t			bno;
> > +	xfs_extlen_t			blocks;
> > +	int				error;
> > +
> > +	bno = XFS_AGF_BLOCK(mp);
> 
> agbno. (and for all the others)
> 
> > +
> > +	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
> > +	if (error)
> > +		return;
> > +
> > +	xfs_scrub_xref_not_free(sc, &sc->sa.bno_cur, bno, 1);
> > +
> > +	/* Check agf_freeblks */
> > +	pcur = &sc->sa.bno_cur;
> > +	if (*pcur) {
> > +		blocks = 0;
> > +		error = xfs_alloc_query_all(*pcur,
> > +				xfs_scrub_agf_record_bno_lengths, &blocks);
> > +		if (xfs_scrub_should_xref(sc, &error, pcur) &&
> > +		    blocks != be32_to_cpu(agf->agf_freeblks))
> > +			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
> > +	}
> 
> I have no idea what xfs_scrub_should_xref() means in this context.
> We're doing a xref scrub, so why are we asking if we should be
> running a xref?

Given that we tried to retrieve some data from some other data
structure, the function xfs_scrub_should_xref decides if we should
actually bother with the comparison checks?   In other words, if the
xfs_alloc_query_all returned an error code then we need to delete *pcur
and we can skip the "blocks != be32..." check since it makes no sense.

How about xfs_scrub_should_check_xref?

> 
> 
> > diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> > index 0d95b84..3d6f8cc 100644
> > --- a/fs/xfs/scrub/alloc.c
> > +++ b/fs/xfs/scrub/alloc.c
> > @@ -114,3 +114,22 @@ xfs_scrub_cntbt(
> >  {
> >  	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
> >  }
> > +
> > +/* xref check that the extent is not free */
> > +void
> > +xfs_scrub_xref_not_free(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_btree_cur		**pcur,
> > +	xfs_agblock_t			bno,
> > +	xfs_extlen_t			len)
> > +{
> > +	bool				is_freesp;
> > +	int				error;
> > +
> > +	if (!(*pcur))
> > +		return;
> > +
> > +	error = xfs_alloc_has_record(*pcur, bno, len, &is_freesp);
> > +	if (xfs_scrub_should_xref(sc, &error, pcur) && is_freesp)
> > +		xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
> > +}
> 
> Again, "should_xref" doesn't actually tell me anything about what
> this function is doing...
> 
> > @@ -117,6 +117,25 @@ xfs_scrub_bmap_extent_xref(
> >  	struct xfs_btree_cur		*cur,
> >  	struct xfs_bmbt_irec		*irec)
> >  {
> > +	struct xfs_scrub_ag		sa = { 0 };
> > +	struct xfs_mount		*mp = info->sc->mp;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			agbno;
> > +	xfs_extlen_t			len;
> > +	int				error;
> > +
> > +	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
> > +	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
> > +	len = irec->br_blockcount;
> > +
> > +	error = xfs_scrub_ag_init(info->sc, agno, &sa);
> > +	if (!xfs_scrub_fblock_process_error(info->sc, info->whichfork,
> > +			irec->br_startoff, &error))
> > +		return;
> > +
> > +	xfs_scrub_xref_not_free(info->sc, &sa.bno_cur, agbno, len);
> > +
> > +	xfs_scrub_ag_free(info->sc, &sa);
> 
> Why do we use an on-stack struct xfs_scrub_ag here, and not the one
> embedded into the scrub context like all the other functions in this
> patch?

I think this is an archaic side effect of a previous version of scrub
when the xfs_scrub_ag wasn't embedded in the scrub context. :/

IOWs, there's no reason, I'll go fix it (and the others).

--D

> >  }
> >  
> >  /* Scrub a single extent record. */
> > diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> > index 9151499..ae58fcc 100644
> > --- a/fs/xfs/scrub/btree.c
> > +++ b/fs/xfs/scrub/btree.c
> > @@ -381,9 +381,12 @@ xfs_scrub_btree_check_block_owner(
> >  	struct xfs_scrub_ag		sa = { 0 };
> >  	struct xfs_scrub_ag		*psa;
> >  	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			bno;
> > +	bool				is_freesp;
> >  	int				error = 0;
> >  
> >  	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
> > +	bno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
> 
> agbno.
> 
> > @@ -584,6 +584,21 @@ xfs_scrub_inode_xref(
> >  	xfs_ino_t			ino,
> >  	struct xfs_dinode		*dip)
> >  {
> > +	struct xfs_scrub_ag		sa = { 0 };
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			agbno;
> > +	int				error;
> > +
> > +	agno = XFS_INO_TO_AGNO(sc->mp, ino);
> > +	agbno = XFS_INO_TO_AGBNO(sc->mp, ino);
> > +
> > +	error = xfs_scrub_ag_init(sc, agno, &sa);
> > +	if (!xfs_scrub_xref_process_error(sc, agno, agbno, &error))
> > +		return;
> > +
> > +	xfs_scrub_xref_not_free(sc, &sa.bno_cur, agbno, 1);
> > +
> > +	xfs_scrub_ag_free(sc, &sa);
> 
> Same question here - on-stack vs embedded....
> 
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
