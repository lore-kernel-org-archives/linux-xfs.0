Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37062 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbeG3UVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 16:21:10 -0400
Date: Mon, 30 Jul 2018 11:44:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/14] xfs: repair the AGI
Message-ID: <20180730184445.GA30972@magnolia>
References: <153292966714.24509.15809693393247424274.stgit@magnolia>
 <153292969532.24509.17576845400762793279.stgit@magnolia>
 <20180730182051.GE35107@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730182051.GE35107@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Mon, Jul 30, 2018 at 02:20:51PM -0400, Brian Foster wrote:
> On Sun, Jul 29, 2018 at 10:48:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rebuild the AGI header items with some help from the rmapbt.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> A couple nits and future thoughts..
> 
> >  fs/xfs/scrub/agheader_repair.c |  220 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/repair.h          |    2 
> >  fs/xfs/scrub/scrub.c           |    2 
> >  3 files changed, 223 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index bfef066c87c3..921e7d42a2ef 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -700,3 +700,223 @@ xrep_agfl(
> >  	xfs_bitmap_destroy(&agfl_extents);
> >  	return error;
> >  }
> ...
> > +STATIC int
> > +xrep_agi_find_btrees(
> > +	struct xfs_scrub		*sc,
> > +	struct xrep_find_ag_btree	*fab)
> > +{
> > +	struct xfs_buf			*agf_bp;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	int				error;
> > +
> > +	/* Read the AGF. */
> > +	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
> > +	if (error)
> > +		return error;
> > +	if (!agf_bp)
> > +		return -ENOMEM;
> > +
> > +	/* Find the btree roots. */
> > +	error = xrep_find_ag_btree_roots(sc, agf_bp, fab, NULL);
> > +	if (error)
> > +		return error;
> > +
> > +	/* We must find the inobt root. */
> > +	if (fab[XREP_AGI_INOBT].root == NULLAGBLOCK ||
> > +	    fab[XREP_AGI_INOBT].height > XFS_BTREE_MAXLEVELS)
> > +		return -EFSCORRUPTED;
> > +
> > +	/* We must find the finobt root if that feature is enabled. */
> > +	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
> > +	    (fab[XREP_AGI_FINOBT].root == NULLAGBLOCK ||
> > +	     fab[XREP_AGI_FINOBT].height > XFS_BTREE_MAXLEVELS))
> > +		return -EFSCORRUPTED;
> 
> Skimming around some of the existing code to find the btree roots, I
> notice that the .root field is going to be != NULLAGBLOCK so long as we
> find at least one appropriately typed block in the rmapbt. I know you
> mentioned that we depend on a correct rmapbt atm, but I'm wondering if
> there's room for slightly more robust error checks to at least prevent
> us from doing something damaging. For example, perhaps we could unset
> .root when we've found a second block at the same level as the current
> "root," and/or check some of the generic characteristics of a root btree
> block (no left/right siblings) once we're done..?

Good suggestion, I'll add it to xrep_findroot_block.

> > +
> > +	return 0;
> > +}
> > +
> ...
> > +/* Trigger reinitialization of the in-core data. */
> > +STATIC int
> > +xrep_agi_commit_new(
> > +	struct xfs_scrub	*sc,
> > +	struct xfs_buf		*agi_bp,
> > +	const struct xfs_agi	*old_agi)
> 
> old_agi is unused here.
> 
> > +{
> > +	struct xfs_perag	*pag;
> > +	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agi_bp);
> > +
> > +	/* Trigger inode count recalculation */
> > +	xfs_force_summary_recalc(sc->mp);
> > +
> > +	/* Write this to disk. */
> > +	xfs_trans_buf_set_type(sc->tp, agi_bp, XFS_BLFT_AGI_BUF);
> > +	xfs_trans_log_buf(sc->tp, agi_bp, 0, BBTOB(agi_bp->b_length) - 1);
> > +
> > +	/* Now reinitialize the in-core counters if necessary. */
> > +	pag = sc->sa.pag;
> > +	sc->sa.pag->pagi_init = 1;
> 
> Same s/sc->sa.pag/pag/ nit here as before.

Both fixed.

> > +	pag->pagi_count = be32_to_cpu(agi->agi_count);
> > +	pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Repair the AGI. */
> > +int
> > +xrep_agi(
> > +	struct xfs_scrub		*sc)
> > +{
> > +	struct xrep_find_ag_btree	fab[XREP_AGI_MAX] = {
> > +		[XREP_AGI_INOBT] = {
> > +			.rmap_owner = XFS_RMAP_OWN_INOBT,
> > +			.buf_ops = &xfs_inobt_buf_ops,
> > +			.magic = XFS_IBT_CRC_MAGIC,
> > +		},
> > +		[XREP_AGI_FINOBT] = {
> > +			.rmap_owner = XFS_RMAP_OWN_INOBT,
> > +			.buf_ops = &xfs_inobt_buf_ops,
> > +			.magic = XFS_FIBT_CRC_MAGIC,
> > +		},
> > +		[XREP_AGI_END] = {
> > +			.buf_ops = NULL
> > +		},
> > +	};
> > +	struct xfs_agi			old_agi;
> 
> It's not immediately clear to me how much of a danger this is here, if
> at all, but FWIW xfs_agi is one of our larger structures at 336 bytes
> (mostly due to agi_unlinked). I'm not terribly concerned if this isn't
> currently exploding, but it might be worth thinking about another
> technique to preserve original behavior without the stack usage. Perhaps
> we could use an uncached buffer to preserve the original data and
> implement an xfs_buf_copy() helper to facilitate, for example.

It's not a huge deal since (vmap) kernel stacks are 16K(!) these days on
64-bit machines, but if it ever becomes a problem we can simply allocate
some memory in sc->buf in the setup routine.

--D

> Brian
> 
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_buf			*agi_bp;
> > +	struct xfs_agi			*agi;
> > +	int				error;
> > +
> > +	/* We require the rmapbt to rebuild anything. */
> > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	xchk_perag_get(sc->mp, &sc->sa);
> > +	/*
> > +	 * Make sure we have the AGI buffer, as scrub might have decided it
> > +	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
> > +	 */
> > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGI_DADDR(mp)),
> > +			XFS_FSS_TO_BB(mp, 1), 0, &agi_bp, NULL);
> > +	if (error)
> > +		return error;
> > +	agi_bp->b_ops = &xfs_agi_buf_ops;
> > +	agi = XFS_BUF_TO_AGI(agi_bp);
> > +
> > +	/* Find the AGI btree roots. */
> > +	error = xrep_agi_find_btrees(sc, fab);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Start rewriting the header and implant the btrees we found. */
> > +	xrep_agi_init_header(sc, agi_bp, &old_agi);
> > +	xrep_agi_set_roots(sc, agi, fab);
> > +	error = xrep_agi_calc_from_btrees(sc, agi_bp);
> > +	if (error)
> > +		goto out_revert;
> > +
> > +	/* Reinitialize in-core state. */
> > +	return xrep_agi_commit_new(sc, agi_bp, &old_agi);
> > +
> > +out_revert:
> > +	/* Mark the incore AGI state stale and revert the AGI. */
> > +	sc->sa.pag->pagi_init = 0;
> > +	memcpy(agi, &old_agi, sizeof(old_agi));
> > +	return error;
> > +}
> > diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > index 1d283360b5ab..9de321eee4ab 100644
> > --- a/fs/xfs/scrub/repair.h
> > +++ b/fs/xfs/scrub/repair.h
> > @@ -60,6 +60,7 @@ int xrep_probe(struct xfs_scrub *sc);
> >  int xrep_superblock(struct xfs_scrub *sc);
> >  int xrep_agf(struct xfs_scrub *sc);
> >  int xrep_agfl(struct xfs_scrub *sc);
> > +int xrep_agi(struct xfs_scrub *sc);
> >  
> >  #else
> >  
> > @@ -85,6 +86,7 @@ xrep_calc_ag_resblks(
> >  #define xrep_superblock			xrep_notsupported
> >  #define xrep_agf			xrep_notsupported
> >  #define xrep_agfl			xrep_notsupported
> > +#define xrep_agi			xrep_notsupported
> >  
> >  #endif /* CONFIG_XFS_ONLINE_REPAIR */
> >  
> > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > index 2670f4cf62f4..4bfae1e61d30 100644
> > --- a/fs/xfs/scrub/scrub.c
> > +++ b/fs/xfs/scrub/scrub.c
> > @@ -226,7 +226,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
> >  		.type	= ST_PERAG,
> >  		.setup	= xchk_setup_fs,
> >  		.scrub	= xchk_agi,
> > -		.repair	= xrep_notsupported,
> > +		.repair	= xrep_agi,
> >  	},
> >  	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
> >  		.type	= ST_PERAG,
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
