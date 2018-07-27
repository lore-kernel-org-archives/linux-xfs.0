Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbeG0Tm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jul 2018 15:42:56 -0400
Date: Fri, 27 Jul 2018 11:19:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/16] xfs: repair the AGF
Message-ID: <20180727181945.GM30972@magnolia>
References: <153256436688.29021.4638459579042241728.stgit@magnolia>
 <153256439500.29021.5265670898665301362.stgit@magnolia>
 <20180727142348.GE22227@bfoster>
 <20180727160238.GL30972@magnolia>
 <20180727162555.GF22227@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727162555.GF22227@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Fri, Jul 27, 2018 at 12:25:56PM -0400, Brian Foster wrote:
> On Fri, Jul 27, 2018 at 09:02:38AM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 27, 2018 at 10:23:48AM -0400, Brian Foster wrote:
> > > On Wed, Jul 25, 2018 at 05:19:55PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Regenerate the AGF from the rmap data.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > Mostly seems sane to me. I still need to come up to speed on the broader
> > > xfs_scrub context. A few comments in the meantime..
> > 
> > <nod> Thanks for taking a look at this series. :)
> > 
> > > >  fs/xfs/scrub/agheader_repair.c |  366 ++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/scrub/repair.c          |   27 ++-
> > > >  fs/xfs/scrub/repair.h          |    4 
> > > >  fs/xfs/scrub/scrub.c           |    2 
> > > >  4 files changed, 389 insertions(+), 10 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > > > index 1e96621ece3a..938af216cb1c 100644
> > > > --- a/fs/xfs/scrub/agheader_repair.c
> > > > +++ b/fs/xfs/scrub/agheader_repair.c
> > > ...
> > > > @@ -54,3 +61,362 @@ xrep_superblock(
> > > >  	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
> > > >  	return error;
> > > >  }
> > > ...
> > > > +/* Update all AGF fields which derive from btree contents. */
> > > > +STATIC int
> > > > +xrep_agf_calc_from_btrees(
> > > > +	struct xfs_scrub	*sc,
> > > > +	struct xfs_buf		*agf_bp)
> > > > +{
> > > > +	struct xrep_agf_allocbt	raa = { .sc = sc };
> > > > +	struct xfs_btree_cur	*cur = NULL;
> > > > +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agf_bp);
> > > > +	struct xfs_mount	*mp = sc->mp;
> > > > +	xfs_agblock_t		btreeblks;
> > > > +	xfs_agblock_t		blocks;
> > > > +	int			error;
> > > > +
> > > > +	/* Update the AGF counters from the bnobt. */
> > > > +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> > > > +			XFS_BTNUM_BNO);
> > > > +	error = xfs_alloc_query_all(cur, xrep_agf_walk_allocbt, &raa);
> > > > +	if (error)
> > > > +		goto err;
> > > > +	error = xfs_btree_count_blocks(cur, &blocks);
> > > > +	if (error)
> > > > +		goto err;
> > > > +	xfs_btree_del_cursor(cur, error);
> > > > +	btreeblks = blocks - 1;
> > > 
> > > Why the -1? We don't count the root or something?
> > 
> > The AGF btreeblks field only counts the number of blocks added to the
> > bno/cnt/rmapbt since they were initialized (each with a single root
> > block).  I find it a little strange not to count the root, but oh well.
> > 
> 
> Got it.
> 
> > > > +	agf->agf_freeblks = cpu_to_be32(raa.freeblks);
> > > > +	agf->agf_longest = cpu_to_be32(raa.longest);
> > > > +
> > > > +	/* Update the AGF counters from the cntbt. */
> > > > +	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
> > > > +			XFS_BTNUM_CNT);
> > > > +	error = xfs_btree_count_blocks(cur, &blocks);
> > > > +	if (error)
> > > > +		goto err;
> > > > +	xfs_btree_del_cursor(cur, error);
> > > > +	btreeblks += blocks - 1;
> > > > +
> > > > +	/* Update the AGF counters from the rmapbt. */
> > > > +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> > > > +	error = xfs_btree_count_blocks(cur, &blocks);
> > > > +	if (error)
> > > > +		goto err;
> > > > +	xfs_btree_del_cursor(cur, error);
> > > > +	agf->agf_rmap_blocks = cpu_to_be32(blocks);
> > > > +	btreeblks += blocks - 1;
> > > > +
> > > > +	agf->agf_btreeblks = cpu_to_be32(btreeblks);
> > > > +
> > > > +	/* Update the AGF counters from the refcountbt. */
> > > > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > > > +		cur = xfs_refcountbt_init_cursor(mp, sc->tp, agf_bp,
> > > > +				sc->sa.agno, NULL);
> > > 
> > > FYI this fails to compile on for-next (dfops param has been removed).
> > 
> > Yeah, I'm working on a rebase to for-next (once I settle on the locking
> > question in hch's "reduce cow lookups" series).
> > 
> > > > +		error = xfs_btree_count_blocks(cur, &blocks);
> > > > +		if (error)
> > > > +			goto err;
> > > > +		xfs_btree_del_cursor(cur, error);
> > > > +		agf->agf_refcount_blocks = cpu_to_be32(blocks);
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +err:
> > > > +	xfs_btree_del_cursor(cur, error);
> > > > +	return error;
> > > > +}
> > > > +
> ...
> > > > +/* Repair the AGF. v5 filesystems only. */
> > > > +int
> > > > +xrep_agf(
> > > > +	struct xfs_scrub		*sc)
> > > > +{
> > > > +	struct xrep_find_ag_btree	fab[XREP_AGF_MAX] = {
> > > > +		[XREP_AGF_BNOBT] = {
> > > > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +			.buf_ops = &xfs_allocbt_buf_ops,
> > > > +			.magic = XFS_ABTB_CRC_MAGIC,
> > > > +		},
> > > > +		[XREP_AGF_CNTBT] = {
> > > > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +			.buf_ops = &xfs_allocbt_buf_ops,
> > > > +			.magic = XFS_ABTC_CRC_MAGIC,
> > > > +		},
> > > > +		[XREP_AGF_RMAPBT] = {
> > > > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +			.buf_ops = &xfs_rmapbt_buf_ops,
> > > > +			.magic = XFS_RMAP_CRC_MAGIC,
> > > > +		},
> > > > +		[XREP_AGF_REFCOUNTBT] = {
> > > > +			.rmap_owner = XFS_RMAP_OWN_REFC,
> > > > +			.buf_ops = &xfs_refcountbt_buf_ops,
> > > > +			.magic = XFS_REFC_CRC_MAGIC,
> > > > +		},
> > > > +		[XREP_AGF_END] = {
> > > > +			.buf_ops = NULL,
> > > > +		},
> > > > +	};
> > > > +	struct xfs_agf			old_agf;
> > > > +	struct xfs_mount		*mp = sc->mp;
> > > > +	struct xfs_buf			*agf_bp;
> > > > +	struct xfs_buf			*agfl_bp;
> > > > +	struct xfs_agf			*agf;
> > > > +	int				error;
> > > > +
> > > > +	/* We require the rmapbt to rebuild anything. */
> > > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	xchk_perag_get(sc->mp, &sc->sa);
> > > > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > > > +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
> > > > +			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
> > > > +	if (error)
> > > > +		return error;
> > > > +	agf_bp->b_ops = &xfs_agf_buf_ops;
> > > 
> > > Any reason we don't call xfs_read_agf() here? It looks like we use the
> > > similar helper for the agfl below.
> > 
> > We're grabbing the agf buffer without read verifiers so that we can
> > reinitialize it.  Note that scrub tries xfs_read_agf, and if it fails
> > with -EFSCORRUPTED/-EFSBADCRC it marks the agf as corrupt, so it's
> > possible that sc->sa.sa_agf is still null.
> > 
> 
> Ah, makes sense. I missed the NULL b_ops..
> 
> > This probably could have been trans_get_buf though...
> > 
> > > > +	agf = XFS_BUF_TO_AGF(agf_bp);
> > > > +
> > > > +	/*
> > > > +	 * Load the AGFL so that we can screen out OWN_AG blocks that are on
> > > > +	 * the AGFL now; these blocks might have once been part of the
> > > > +	 * bno/cnt/rmap btrees but are not now.  This is a chicken and egg
> > > > +	 * problem: the AGF is corrupt, so we have to trust the AGFL contents
> > > > +	 * because we can't do any serious cross-referencing with any of the
> > > > +	 * btrees rooted in the AGF.  If the AGFL contents are obviously bad
> > > > +	 * then we'll bail out.
> > > > +	 */
> > > > +	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.agno, &agfl_bp);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	/*
> > > > +	 * Spot-check the AGFL blocks; if they're obviously corrupt then
> > > > +	 * there's nothing we can do but bail out.
> > > > +	 */
> > > 
> > > Why? Can't we reset the agfl, or is that handled elsewhere?
> > 
> > It's handled in xrep_agfl, but userspace will have to call us again to
> > fix the agfl and then call us a third time about the agf repair.
> > 
> 
> Ok, this was one of the things I feel like I don't have enough context
> on wrt to online repair: in general, what dependent structures we expect
> to be consistent in order to repair some other interrelated structure.
> Userspace repair is straightforward in this regard since we slurp the
> whole fs into memory, adjust the global state as we go, then essentially
> regenerate new metadata based on the finalized state.

<nod>

> For online repair, it sounds like we're potentially limited because
> repair of one structure may always depend on some other subset of
> metadata being consistent, right?

Correct.  There's an implicit assumption here (which is coded into a
warning message in xfs_scrub) that if the primary and secondary metadata
(rmapbt usually) are corrupt then the fs may be unrecoverable online...

> If so, is the goal of online repair to essentially "do the best we can
> but otherwise the most severe corruptions may have to always fall back
> to xfs_repair?"

...and so the only recourse is xfs_repair, with the usual caveat that a
severely damaged filesystem might be a total loss.  If the online repair
fails then the fs will be shut down (either due to cancelling a dirty
repair transaction or because xfs_scrub can call FS_IOC_SHUTDOWN after a
failure).

> So in this particular case, we expect a sane agfl and otherwise buzz off
> because 1.) this is a targeted agf repair request and 2.) we have a
> separate request to deal with the agfl. It sounds like the smarts to
> understand how we might have to jump back and forth between them is in
> userspace, so the end-user doesn't necessarily have to understand the
> dependency.

Correct.  Userspace should be running xfs_scrub, which knows in which
order metadata has to be checked, and what dependencies must be
satisfied for repairs to succeed.  While it's possible to invoke it
manually via xfs_io, in practice nobody but xfstests should be using
that method of invocation.

--D

> Brian
> 
> > (xfs_scrub does this, naturally...)
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > +	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(agf_bp), agfl_bp,
> > > > +			xrep_agf_check_agfl_block, sc);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	/*
> > > > +	 * Find the AGF btree roots.  This is also a chicken-and-egg situation;
> > > > +	 * see the function for more details.
> > > > +	 */
> > > > +	error = xrep_agf_find_btrees(sc, agf_bp, fab, agfl_bp);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	/* Start rewriting the header and implant the btrees we found. */
> > > > +	xrep_agf_init_header(sc, agf_bp, &old_agf);
> > > > +	xrep_agf_set_roots(sc, agf, fab);
> > > > +	error = xrep_agf_calc_from_btrees(sc, agf_bp);
> > > > +	if (error)
> > > > +		goto out_revert;
> > > > +
> > > > +	/* Commit the changes and reinitialize incore state. */
> > > > +	return xrep_agf_commit_new(sc, agf_bp);
> > > > +
> > > > +out_revert:
> > > > +	/* Mark the incore AGF state stale and revert the AGF. */
> > > > +	sc->sa.pag->pagf_init = 0;
> > > > +	memcpy(agf, &old_agf, sizeof(old_agf));
> > > > +	return error;
> > > > +}
> > > > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > > > index 85b048b341a0..17cf48564390 100644
> > > > --- a/fs/xfs/scrub/repair.c
> > > > +++ b/fs/xfs/scrub/repair.c
> > > > @@ -128,9 +128,12 @@ xrep_roll_ag_trans(
> > > >  	int			error;
> > > >  
> > > >  	/* Keep the AG header buffers locked so we can keep going. */
> > > > -	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> > > > -	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
> > > > -	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
> > > > +	if (sc->sa.agi_bp)
> > > > +		xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> > > > +	if (sc->sa.agf_bp)
> > > > +		xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
> > > > +	if (sc->sa.agfl_bp)
> > > > +		xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
> > > >  
> > > >  	/* Roll the transaction. */
> > > >  	error = xfs_trans_roll(&sc->tp);
> > > > @@ -138,9 +141,12 @@ xrep_roll_ag_trans(
> > > >  		goto out_release;
> > > >  
> > > >  	/* Join AG headers to the new transaction. */
> > > > -	xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
> > > > -	xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
> > > > -	xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
> > > > +	if (sc->sa.agi_bp)
> > > > +		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
> > > > +	if (sc->sa.agf_bp)
> > > > +		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
> > > > +	if (sc->sa.agfl_bp)
> > > > +		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
> > > >  
> > > >  	return 0;
> > > >  
> > > > @@ -150,9 +156,12 @@ xrep_roll_ag_trans(
> > > >  	 * buffers will be released during teardown on our way out
> > > >  	 * of the kernel.
> > > >  	 */
> > > > -	xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> > > > -	xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> > > > -	xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
> > > > +	if (sc->sa.agi_bp)
> > > > +		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> > > > +	if (sc->sa.agf_bp)
> > > > +		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> > > > +	if (sc->sa.agfl_bp)
> > > > +		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
> > > >  
> > > >  	return error;
> > > >  }
> > > > diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> > > > index 5a4e92221916..1d283360b5ab 100644
> > > > --- a/fs/xfs/scrub/repair.h
> > > > +++ b/fs/xfs/scrub/repair.h
> > > > @@ -58,6 +58,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
> > > >  
> > > >  int xrep_probe(struct xfs_scrub *sc);
> > > >  int xrep_superblock(struct xfs_scrub *sc);
> > > > +int xrep_agf(struct xfs_scrub *sc);
> > > > +int xrep_agfl(struct xfs_scrub *sc);
> > > >  
> > > >  #else
> > > >  
> > > > @@ -81,6 +83,8 @@ xrep_calc_ag_resblks(
> > > >  
> > > >  #define xrep_probe			xrep_notsupported
> > > >  #define xrep_superblock			xrep_notsupported
> > > > +#define xrep_agf			xrep_notsupported
> > > > +#define xrep_agfl			xrep_notsupported
> > > >  
> > > >  #endif /* CONFIG_XFS_ONLINE_REPAIR */
> > > >  
> > > > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > > > index 6efb926f3cf8..1e8a17c8e2b9 100644
> > > > --- a/fs/xfs/scrub/scrub.c
> > > > +++ b/fs/xfs/scrub/scrub.c
> > > > @@ -214,7 +214,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
> > > >  		.type	= ST_PERAG,
> > > >  		.setup	= xchk_setup_fs,
> > > >  		.scrub	= xchk_agf,
> > > > -		.repair	= xrep_notsupported,
> > > > +		.repair	= xrep_agf,
> > > >  	},
> > > >  	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
