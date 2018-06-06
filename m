Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbeFFE4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 00:56:08 -0400
Date: Tue, 5 Jun 2018 21:56:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/14] xfs: repair the AGF and AGFL
Message-ID: <20180606045603.GV9437@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770864591.11611.5564813732568495676.stgit@magnolia>
 <20180604015255.GJ10363@dastard>
 <20180605231856.GO9437@magnolia>
 <20180606040624.GO10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180606040624.GO10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 06, 2018 at 02:06:24PM +1000, Dave Chinner wrote:
> On Tue, Jun 05, 2018 at 04:18:56PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 04, 2018 at 11:52:55AM +1000, Dave Chinner wrote:
> > > On Wed, May 30, 2018 at 12:30:45PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Regenerate the AGF and AGFL from the rmap data.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > [...]
> > > 
> > > > +/* Repair the AGF. */
> > > > +int
> > > > +xfs_repair_agf(
> > > > +	struct xfs_scrub_context	*sc)
> > > > +{
> > > > +	struct xfs_repair_find_ag_btree	fab[] = {
> > > > +		{
> > > > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +			.buf_ops = &xfs_allocbt_buf_ops,
> > > > +			.magic = XFS_ABTB_CRC_MAGIC,
> > > > +		},
> > > > +		{
> > > > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +			.buf_ops = &xfs_allocbt_buf_ops,
> > > > +			.magic = XFS_ABTC_CRC_MAGIC,
> > > > +		},
> > > > +		{
> > > > +			.rmap_owner = XFS_RMAP_OWN_AG,
> > > > +			.buf_ops = &xfs_rmapbt_buf_ops,
> > > > +			.magic = XFS_RMAP_CRC_MAGIC,
> > > > +		},
> > > > +		{
> > > > +			.rmap_owner = XFS_RMAP_OWN_REFC,
> > > > +			.buf_ops = &xfs_refcountbt_buf_ops,
> > > > +			.magic = XFS_REFC_CRC_MAGIC,
> > > > +		},
> > > > +		{
> > > > +			.buf_ops = NULL,
> > > > +		},
> > > > +	};
> > > > +	struct xfs_repair_agf_allocbt	raa;
> > > > +	struct xfs_agf			old_agf;
> > > > +	struct xfs_mount		*mp = sc->mp;
> > > > +	struct xfs_buf			*agf_bp;
> > > > +	struct xfs_buf			*agfl_bp;
> > > > +	struct xfs_agf			*agf;
> > > > +	struct xfs_btree_cur		*cur = NULL;
> > > > +	struct xfs_perag		*pag;
> > > > +	xfs_agblock_t			blocks;
> > > > +	xfs_agblock_t			freesp_blocks;
> > > > +	int64_t				delta_fdblocks = 0;
> > > > +	int				error;
> > > > +
> > > > +	/* We require the rmapbt to rebuild anything. */
> > > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	xfs_scrub_perag_get(sc->mp, &sc->sa);
> > > > +	pag = sc->sa.pag;
> > > > +	memset(&raa, 0, sizeof(raa));
> > > > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > > > +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGF_DADDR(mp)),
> > > > +			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
> > > > +	if (error)
> > > > +		return error;
> > > > +	agf_bp->b_ops = &xfs_agf_buf_ops;
> > > > +
> > > > +	/*
> > > > +	 * Load the AGFL so that we can screen out OWN_AG blocks that
> > > > +	 * are on the AGFL now; these blocks might have once been part
> > > > +	 * of the bno/cnt/rmap btrees but are not now.
> > > > +	 */
> > > > +	error = xfs_alloc_read_agfl(mp, sc->tp, sc->sa.agno, &agfl_bp);
> > > > +	if (error)
> > > > +		return error;
> > > > +	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(agf_bp), agfl_bp,
> > > > +			xfs_repair_agf_check_agfl_block, sc);
> > > > +	if (error)
> > > > +		return error;
> > > 
> > > THis is a bit of a chicken/egg situation, isn't it? We haven't
> > > repaired the AGFL yet, so how do we know what is valid here?
> > 
> > Yep.  The AGF is corrupt, so we have to trust the AGFL contents because
> > we can't do any serious cross-referencing with any of the btrees rooted
> > in the AGF.  If the AGFL contents are obviously bad then we'll bail out.
> 
> Can you add that as a comment here?

Done.  FWIW each of these functions that gets split out has a nice big
comment above it now.

> > > Can we factor this function allow rebuild operation lines?
> > 
> > Yes...
> > 
> > > That will help document all the different pieces it is putting
> > > together. E.g move the AGF header init to before
> > > xfs_repair_find_ag_btree_roots(), and then pass it into
> > > xfs_repair_agf_rebuild_roots() which contains the above fab specific
> > > code.
> > 
> > ...however, that's the second (and admittedly not well documented)
> > second chicken-egg -- we find the agf btree roots by probing the rmapbt,
> > which is rooted in the agf.  So xfs_repair_find_ag_btree_roots has to be
> > fed the old agf_bp buffer, and if that blows up then we bail out without
> > changing anything.
> 
> Same again - factoring and adding comments to explain things like
> this will make it much easier to understand.

(Done)

> > > > +/* Record all freespace information. */
> > > > +STATIC int
> > > > +xfs_repair_agfl_rmap_fn(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	struct xfs_rmap_irec		*rec,
> > > > +	void				*priv)
> > > > +{
> > > > +	struct xfs_repair_agfl		*ra = priv;
> > > > +	struct xfs_buf			*bp;
> > > > +	xfs_fsblock_t			fsb;
> > > > +	int				i;
> > > > +	int				error = 0;
> > > > +
> > > > +	if (xfs_scrub_should_terminate(ra->sc, &error))
> > > > +		return error;
> > > > +
> > > > +	/* Record all the OWN_AG blocks... */
> > > > +	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
> > > > +		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> > > > +				rec->rm_startblock);
> > > > +		error = xfs_repair_collect_btree_extent(ra->sc,
> > > > +				&ra->freesp_list, fsb, rec->rm_blockcount);
> > > > +		if (error)
> > > > +			return error;
> > > > +	}
> > > > +
> > > > +	/* ...and all the rmapbt blocks... */
> > > > +	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
> > > 
> > > What is the significance of "cur->bc_ptrs[i] == 1"?
> > > 
> > > This loop looks like it is walking the btree path to this leaf, but
> > > bc_ptrs[] will only have a "1" in it if we are at the left-most edge
> > > of the tree, right? so what about all the other btree blocks?
> > 
> > Close.  We're walking up the tree from the leaf towards the root.  For
> > each level, we assume that if bc_ptrs[level] == 1, then this is the
> > first time we've seen the block at that level, so we remember that we
> > saw this rmapbt block.  bc_ptrs is the offset within a block, not the
> > offset for the entire level.
> > 
> > So if our rmapbt tree is:
> > 
> >    4
> >  / | \
> > 1  2  3
> > 
> > Pretend for this example that each leaf block has 100 rmap records.  For
> > the first rmap record, we'll observe that bc_ptrs[0] == 1, so we record
> > that we saw block 1.  Then we observe that bc_ptrs[1] == 1, so we record
> > block 4.  agmeta_list is [1, 4].
> > 
> > For the second rmap record, we see that bc_ptrs[0] == 2, so we exit the
> > loop.  agmeta_list remains [1, 4].
> > 
> > For the 101st rmap record, we've moved onto leaf block 2.  Now
> > bc_ptrs[0] == 1 again, so we record that we saw block 2.  We see that
> > bc_ptrs[1] == 2, so we exit the loop.  agmeta_list = [1, 4, 2].
> > 
> > For the 102nd rmap, bc_ptrs[0] == 2, so we exit.
> > 
> > For the 201st rmap record, we've moved on to leaf block 3.  bc_ptrs[0]
> > == 1, so we add 3 to agmeta_list.  [1, 4, 2, 3].
> 
> And that is crying out for either an iterator macro or a helper
> function with that explanation above it :P

Ok.  I'll fix up that explanation and make the whole thing a helper
function.

> > > > +
> > > > +	/* We require the rmapbt to rebuild anything. */
> > > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	xfs_scrub_perag_get(sc->mp, &sc->sa);
> > > > +	xfs_repair_init_extent_list(&ra.freesp_list);
> > > > +	xfs_repair_init_extent_list(&ra.agmeta_list);
> > > > +	ra.sc = sc;
> > > > +
> > > > +	error = xfs_alloc_read_agf(mp, sc->tp, sc->sa.agno, 0, &agf_bp);
> > > > +	if (error)
> > > > +		return error;
> > > > +	if (!agf_bp)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > > > +			XFS_AG_DADDR(mp, sc->sa.agno, XFS_AGFL_DADDR(mp)),
> > > > +			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
> > > > +	if (error)
> > > > +		return error;
> > > > +	agfl_bp->b_ops = &xfs_agfl_buf_ops;
> > > 
> > > Be nice to have a __xfs_alloc_read_agfl() function that didn't set
> > > the ops, and have this and xfs_alloc_read_agfl() both call it.
> > 
> > Huh?  xfs_alloc_read_agfl always reads the agfl buffer with
> > &xfs_agfl_buf_ops, why would we want to call it without the verifier?
> 
> You wouldn't:
> 
> xfs_alloc_read_agfl()
> {
> 	return __xfs_alloc_read_agfl(..., &xfs_agfl_buf_ops);
> }
> 
> And then the above simply becomes
> 
> 	error = __xfs_alloc_read_agfl(..., NULL);
> 	if (error)
> 		return error;
> 	agfl_bp->b_ops = &xfs_agfl_buf_ops;
> 
> I'm more concerned about open coding of things we have currently
> centralised in helpers, and trying to see if there's ways to keep
> the functions centralised.
> 
> Don't worry about it - it was really just a comment about "it would
> be nice to have...".

<nod>

> > It's only scrub that gets to do screwy things like read buffers with no
> > verifier.  libxfs functions should never do that.
> 
> I didn't know (well, I don't recall that) we have this rule. Can you
> point me at the discussion so I can read up on it?  IMO libxfs is
> for centralising common operations, not for enforcing boundaries or
> rules on how we access objects.

Ok, fair enough, I concede. :)

I had simply thought that the convention was that in general we don't
let anyone do that, except for the the thing that deals with exceptional
situations.

> 
> > > > +int
> > > > +xfs_repair_mod_fdblocks(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	int64_t				delta_fdblocks)
> > > > +{
> > > > +	int				error;
> > > > +
> > > > +	if (delta_fdblocks == 0)
> > > > +		return 0;
> > > > +
> > > > +	if (delta_fdblocks < 0) {
> > > > +		error = xfs_trans_reserve_more(sc->tp, -delta_fdblocks, 0);
> > > > +		if (error)
> > > > +			return error;
> > > > +	}
> > > > +
> > > > +	xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_FDBLOCKS, delta_fdblocks);
> > > 
> > > This seems a little hacky - it's working around a transaction
> > > reservation overflow warning, right?
> > 
> > More than that -- we're trying to avoid the situation where the incore
> > free block counter goes negative.
> 
> Which will only happen if we overflow the transaction reservation,
> yes?
> 
> > Things go south pretty quickly when
> > that happens because transaction reservations succeed when there's not
> > enough free space to accomodate them.  We'd rather error out to
> > userspace and have the admin unmount and xfs_repair than risk letting
> > the fs really blow up.
> 
> Sure, but I really don't like retrospective modification of
> transaction reservations.  The repair code is already supposed to
> have a reservation that is big enough to rebuild the AG trees, so
> why should we need to reserve more space while rebuilding the AG
> trees?
> 
> > Note that this function has to be called before repair dirties anything
> > in the repair transaction so we're still at a place where we could back
> > out with no harm done.
> 
> Still doesn't explain to me what the problem is that this code works
> around. And because I don't understand why it is necessary, this just
> seems like a hack....

It /is/ a hack while I figure out a sane strategy for checking the
summary counters that doesn't regularly shut down the filesystem.  I've
thought that perhaps we should leave the global counters alone.  If
something corrupts agf_flcount to 0x1000032 (when the real flcount is
0x32) then we're going to subtract a huge quantity from the global
counter, which is totally stupid.

I've been mulling over what to do here -- normally, repair always writes
out fresh AG headers and summary counters and under normal circumstance
we'll always keep the AG counts and the global counts in sync, right?

The idea I have to solve all these problems is to add a superblock state
flag that we set whenever we think the global counters might be wrong.
We'd only do this if we had to fix the counters in an AGF, or if the
agfl padding fixer triggered, etc.

Then we add a new FSSUMMARY scrubber that only does anything if the
'counters might be wrong' flag is set.  When it does, we freeze the fs,
tally up all the counters and reservations, and fix the counters if we
can.  Then unfreeze and exit.  This way we're not locking the entire
filesystem every time scrub runs, but we have a way to fix the global
counters if we need to.  Granted, figuring out the total amount of
incore reservation might not be quick.

The other repair functions no longer need xfs_repair_mod_fdblocks; if
they has to make a correction to any of the per-ag free counters all
they do is set the "wrong counters" flag.

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
