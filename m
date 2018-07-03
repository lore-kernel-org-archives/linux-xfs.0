Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932109AbeGCX7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 19:59:05 -0400
Date: Tue, 3 Jul 2018 16:59:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/21] xfs: repair the rmapbt
Message-ID: <20180703235901.GY32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986827881.3155.10096839660329617215.stgit@magnolia>
 <20180703053200.GH2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703053200.GH2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 03:32:00PM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:24:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rebuild the reverse mapping btree from all primary metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ....
> 
> > +static inline int xfs_repair_rmapbt_setup(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip)
> > +{
> > +	/* We don't support rmap repair, but we can still do a scan. */
> > +	return xfs_scrub_setup_ag_btree(sc, ip, false);
> > +}
> 
> This comment seems at odds with the commit message....

This is the Kconfig shim needed if CONFIG_XFS_ONLINE_REPAIR=n.

> 
> ....
> 
> > +/*
> > + * Reverse Mapping Btree Repair
> > + * ============================
> > + *
> > + * This is the most involved of all the AG space btree rebuilds.  Everywhere
> > + * else in XFS we lock inodes and then AG data structures, but generating the
> > + * list of rmap records requires that we be able to scan both block mapping
> > + * btrees of every inode in the filesystem to see if it owns any extents in
> > + * this AG.  We can't tolerate any inode updates while we do this, so we
> > + * freeze the filesystem to lock everyone else out, and grant ourselves
> > + * special privileges to run transactions with regular background reclamation
> > + * turned off.
> 
> Hmmm. This implies we are going to scan the entire filesystem for
> every AG we need to rebuild the rmap tree in. That seems like an
> awful lot of work if there's more than one rmap btree that needs
> rebuild.

[some of this Dave and I discussed on IRC, so I'll summarize for
everyone else here...]

For this initial v0 iteration of the rmap repair code, yes, we have to
freeze the fs and iterate everything.  However, unless your computer and
storage are particularly untrustworthy, rmapbt reconstruction should be
a very infrequent thing.  Now that we have a FREEZE_OK flag, userspace
has to opt-in to slow repairs, and presumably it could choose instead to
unmount and run xfs_repair if that's too dear or there are too many
broken AGs, etc.  More on that later.

In the long run I don't see a need to freeze the filesystem to scan
every inode for bmbt entries in the damaged AG.  In fact, we can improve
the performance of all the AG repair functions in general with the
scheme I'm about to outline:

Create a "shut down this AG" primitive.  Once set, block and inode
allocation routines will bypass this AG.  Unlinked inodes are moved to
the unlinked list to avoid touching as much of the AGI as we practically
can.  Unmapped/freed blocks can be moved to a hidden inode (in another
AG) to be freed later.  Growfs operation in that AG can be rejected.

With AG shutdown in place, we no longer need to freeze the whole
filesystem.  Instead we traverse the live fs looking for mappings into
the afflicted AG, and when we're done rebuilding the rmapbt we can then
clean out the unlinked inodes and blocks, which catches us up to the
rest of the system.

(It would be awesome if we could capture the log intent items for the
removals until we're done rebuilding the rmapbt, but I suspect that
could fatally pin the log on us.)

However, given that adding AG shutdowns would be a lot of work I'd
prefer to get this launched even if it's reasonably likely early
versions will fail due to ENOMEM.  I tried to structure the rmapbt
repair so that we collect all the records and touch all the inodes
before we start writing anything so that if we run out of memory or
encounter a locked/reclaimable/whatever inode we'll just free all the
memory and bail out.  After that, the admin can take the fs offline and
run xfs_repair, so it shouldn't be much worse than today.

> > + * We also have to be very careful not to allow inode reclaim to start a
> > + * transaction because all transactions (other than our own) will block.
> 
> What happens when we run out of memory? Inode reclaim will need to
> run at that point, right?

Yes.

> > + * So basically we scan all primary per-AG metadata and all block maps of all
> > + * inodes to generate a huge list of reverse map records.  Next we look for
> > + * gaps in the rmap records to calculate all the unclaimed free space (1).
> > + * Next, we scan all other OWN_AG metadata (bnobt, cntbt, agfl) and subtract
> > + * the space used by those btrees from (1), and also subtract the free space
> > + * listed in the bnobt from (1).  What's left are the gaps in assigned space
> > + * that the new rmapbt knows about but the existing bnobt doesn't; these are
> > + * the blocks from the old rmapbt and they can be freed.
> 
> THis looks like a lot of repeated work. We've already scanned a
> bunch of these trees to repair them, then thrown away the scan
> results. Now we do another scan of what we've rebuilt.....
> 
> ... hold on. Chicken and egg.
> 
> We verify and rebuild all the other trees from the rmap information
> - how do we do determine that the rmap needs to rebuilt and that the
> metadata it's being rebuilt from is valid?

Userspace should invoke the other scrubbers for the AG before deciding
to re-run the rmap scrubber with IFLAG_REPAIR set.  xfs_scrub won't try
to repair rmap btrees until after it's already checked everything else
in the filesystem.  Currently xfs_scrub will complain if it finds
corruption in the primary data & the rmapbt; as the code matures I will
probably change it to error out when this happens.

> Given that we've effetively got to shut down access to the
> filesystem for the entire rmap rebuild while we do an entire
> filesystem scan, why would we do this online? It's going to be
> faster to do this rebuild offline (because of all the prefetching,
> rebuilding all AG trees from the state gathered in the full
> filesystem passes, etc) and we don't have to hack around potential
> transaction and memory reclaim deadlock situations, either?
> 
> So why do rmap rebuilds online at all?

The thing is, xfs_scrub will warm the xfs_buf cache during phases 2 and
3 while it checks everything.  By the time it gets to rmapbt repairs
towards the end of phase 4 (if there's enough memory) those blocks will
still be in cache and online repair doesn't have to wait for the disk.

If instead you unmount and run xfs_repair then xfs_repair has to reload
all that metadata and recheck it, all of which happens with the fs
offline.

So except for the extra complexity of avoiding deadlocks (which I
readily admit is not a small task) I at least don't think it's a
clear-cut downtime win to rely on xfs_repair.

> > + */
> > +
> > +/* Set us up to repair reverse mapping btrees. */
> > +int
> > +xfs_repair_rmapbt_setup(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip)
> > +{
> > +	int				error;
> > +
> > +	/*
> > +	 * Freeze out anything that can lock an inode.  We reconstruct
> > +	 * the rmapbt by reading inode bmaps with the AGF held, which is
> > +	 * only safe w.r.t. ABBA deadlocks if we're the only ones locking
> > +	 * inodes.
> > +	 */
> > +	error = xfs_scrub_fs_freeze(sc);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Check the AG number and set up the scrub context. */
> > +	error = xfs_scrub_setup_fs(sc, ip);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * Lock all the AG header buffers so that we can read all the
> > +	 * per-AG metadata too.
> > +	 */
> > +	error = xfs_repair_grab_all_ag_headers(sc);
> > +	if (error)
> > +		return error;
> 
> So if we have thousands of AGs (think PB scale filesystems) then
> we're going hold many thousands of locked buffers here? Just so we
> can rebuild the rmapbt in one AG?
> 
> What does holding these buffers locked protect us against that
> an active freeze doesn't?

Nothing, since we're frozen.  I think that's been around since before
rmapbt repair learned to freeze the fs.

> > +xfs_repair_rmapbt_new_rmap(
> > +	struct xfs_repair_rmapbt	*rr,
> > +	xfs_agblock_t			startblock,
> > +	xfs_extlen_t			blockcount,
> > +	uint64_t			owner,
> > +	uint64_t			offset,
> > +	unsigned int			flags)
> > +{
> > +	struct xfs_repair_rmapbt_extent	*rre;
> > +	int				error = 0;
> > +
> > +	trace_xfs_repair_rmap_extent_fn(rr->sc->mp, rr->sc->sa.agno,
> > +			startblock, blockcount, owner, offset, flags);
> > +
> > +	if (xfs_scrub_should_terminate(rr->sc, &error))
> > +		return error;
> > +
> > +	rre = kmem_alloc(sizeof(struct xfs_repair_rmapbt_extent), KM_MAYFAIL);
> > +	if (!rre)
> > +		return -ENOMEM;
> 
> This seems like a likely thing to happen given the "no reclaim"
> state of the filesystem and the memory demand a rmapbt rebuild
> can have. If we've got GBs of rmap info in the AG that needs to be
> rebuilt, how much RAM are we going to need to index it all as we
> scan the filesystem?

More than I'd like -- at least 24 bytes per record (which at least is no
larger than the size of the on-disk btree) plus a list_head until I can
move the repairers away from creating huge lists.

> > +xfs_repair_rmapbt_scan_ifork(
> > +	struct xfs_repair_rmapbt	*rr,
> > +	struct xfs_inode		*ip,
> > +	int				whichfork)
> > +{
> > +	struct xfs_bmbt_irec		rec;
> > +	struct xfs_iext_cursor		icur;
> > +	struct xfs_mount		*mp = rr->sc->mp;
> > +	struct xfs_btree_cur		*cur = NULL;
> > +	struct xfs_ifork		*ifp;
> > +	unsigned int			rflags;
> > +	int				fmt;
> > +	int				error = 0;
> > +
> > +	/* Do we even have data mapping extents? */
> > +	fmt = XFS_IFORK_FORMAT(ip, whichfork);
> > +	ifp = XFS_IFORK_PTR(ip, whichfork);
> > +	switch (fmt) {
> > +	case XFS_DINODE_FMT_BTREE:
> > +		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > +			error = xfs_iread_extents(rr->sc->tp, ip, whichfork);
> > +			if (error)
> > +				return error;
> > +		}
> 
> Ok, so we need inodes locked to do this....
> 
> ....
> > +/* Iterate all the inodes in an AG group. */
> > +STATIC int
> > +xfs_repair_rmapbt_scan_inobt(
> > +	struct xfs_btree_cur		*cur,
> > +	union xfs_btree_rec		*rec,
> > +	void				*priv)
> > +{
> > +	struct xfs_inobt_rec_incore	irec;
> > +	struct xfs_repair_rmapbt	*rr = priv;
> > +	struct xfs_mount		*mp = cur->bc_mp;
> > +	struct xfs_inode		*ip = NULL;
> > +	xfs_ino_t			ino;
> > +	xfs_agino_t			agino;
> > +	int				chunkidx;
> > +	int				lock_mode = 0;
> > +	int				error = 0;
> > +
> > +	xfs_inobt_btrec_to_irec(mp, rec, &irec);
> > +
> > +	for (chunkidx = 0, agino = irec.ir_startino;
> > +	     chunkidx < XFS_INODES_PER_CHUNK;
> > +	     chunkidx++, agino++) {
> > +		bool	inuse;
> > +
> > +		/* Skip if this inode is free */
> > +		if (XFS_INOBT_MASK(chunkidx) & irec.ir_free)
> > +			continue;
> > +		ino = XFS_AGINO_TO_INO(mp, cur->bc_private.a.agno, agino);
> > +
> > +		/* Back off and try again if an inode is being reclaimed */
> > +		error = xfs_icache_inode_is_allocated(mp, cur->bc_tp, ino,
> > +				&inuse);
> > +		if (error == -EAGAIN)
> > +			return -EDEADLOCK;
> 
> And we can get inode access errors here.....
> 
> FWIW, how is the inode being reclaimed if the filesystem is frozen?

Memory reclaim from some other process?  Maybe? :)

I'll do some research to learn if other processes can get into inode
reclaim on our frozen fs.

> > +
> > +		/*
> > +		 * Grab inode for scanning.  We cannot use DONTCACHE here
> > +		 * because we already have a transaction so the iput must not
> > +		 * trigger inode reclaim (which might allocate a transaction
> > +		 * to clean up posteof blocks).
> > +		 */
> > +		error = xfs_iget(mp, cur->bc_tp, ino, 0, 0, &ip);
> 
> So if there are enough inodes in the AG, we'll run out of memory
> here because we aren't reclaiming inodes from the cache but instead
> putting them all on the defferred iput list?

Enough inodes in the AG that also have post-eof blocks or cow blocks to
free.  If we don't have to do any inactive work then they just go away.

> > +		if (error)
> > +			return error;
> > +		trace_xfs_scrub_iget(ip, __this_address);
> > +
> > +		if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> > +		     !(ip->i_df.if_flags & XFS_IFEXTENTS)) ||
> > +		    (ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE &&
> > +		     !(ip->i_afp->if_flags & XFS_IFEXTENTS)))
> > +			lock_mode = XFS_ILOCK_EXCL;
> > +		else
> > +			lock_mode = XFS_ILOCK_SHARED;
> > +		if (!xfs_ilock_nowait(ip, lock_mode)) {
> > +			error = -EBUSY;
> > +			goto out_rele;
> > +		}
> 
> And in what situation do we get inodes stuck with the ilock held on
> frozen filesysetms?

I think we do not, and that this is a relic of pre-freeze rmap repair.

> ....
> 
> > +out_unlock:
> > +	xfs_iunlock(ip, lock_mode);
> > +out_rele:
> > +	iput(VFS_I(ip));
> > +	return error;
> 
> calling iput in the error path is a bug - it will trigger all the
> paths you're trying to avoid by using te deferred iput list.

Oops, that should be our xfs_scrub_repair_iput.

> ....
> 
> 
> > +/* Collect rmaps for all block mappings for every inode in this AG. */
> > +STATIC int
> > +xfs_repair_rmapbt_generate_aginode_rmaps(
> > +	struct xfs_repair_rmapbt	*rr,
> > +	xfs_agnumber_t			agno)
> > +{
> > +	struct xfs_scrub_context	*sc = rr->sc;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_btree_cur		*cur;
> > +	struct xfs_buf			*agi_bp;
> > +	int				error;
> > +
> > +	error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
> > +	if (error)
> > +		return error;
> > +	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, agno, XFS_BTNUM_INO);
> > +	error = xfs_btree_query_all(cur, xfs_repair_rmapbt_scan_inobt, rr);
> 
> So if we get a locked or reclaiming inode anywhere in the
> filesystem we see EDEADLOCK/EBUSY here without having scanned all
> the inodes in the AG, right?

Right.

> > +	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > +	xfs_trans_brelse(sc->tp, agi_bp);
> > +	return error;
> > +}
> > +
> > +/*
> > + * Generate all the reverse-mappings for this AG, a list of the old rmapbt
> > + * blocks, and the new btreeblks count.  Figure out if we have enough free
> > + * space to reconstruct the inode btrees.  The caller must clean up the lists
> > + * if anything goes wrong.
> > + */
> > +STATIC int
> > +xfs_repair_rmapbt_find_rmaps(
> > +	struct xfs_scrub_context	*sc,
> > +	struct list_head		*rmap_records,
> > +	xfs_agblock_t			*new_btreeblks)
> > +{
> > +	struct xfs_repair_rmapbt	rr;
> > +	xfs_agnumber_t			agno;
> > +	int				error;
> > +
> > +	rr.rmaplist = rmap_records;
> > +	rr.sc = sc;
> > +	rr.nr_records = 0;
> > +
> > +	/* Generate rmaps for AG space metadata */
> > +	error = xfs_repair_rmapbt_generate_agheader_rmaps(&rr);
> > +	if (error)
> > +		return error;
> > +	error = xfs_repair_rmapbt_generate_log_rmaps(&rr);
> > +	if (error)
> > +		return error;
> > +	error = xfs_repair_rmapbt_generate_freesp_rmaps(&rr, new_btreeblks);
> > +	if (error)
> > +		return error;
> > +	error = xfs_repair_rmapbt_generate_inobt_rmaps(&rr);
> > +	if (error)
> > +		return error;
> > +	error = xfs_repair_rmapbt_generate_refcountbt_rmaps(&rr);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Iterate all AGs for inodes rmaps. */
> > +	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> > +		error = xfs_repair_rmapbt_generate_aginode_rmaps(&rr, agno);
> > +		if (error)
> > +			return error;
> 
> And that means we abort here....
> 
> > +/* Repair the rmap btree for some AG. */
> > +int
> > +xfs_repair_rmapbt(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_owner_info		oinfo;
> > +	struct list_head		rmap_records;
> > +	xfs_extlen_t			new_btreeblks;
> > +	int				log_flags = 0;
> > +	int				error;
> > +
> > +	xfs_scrub_perag_get(sc->mp, &sc->sa);
> > +
> > +	/* Collect rmaps for all AG headers. */
> > +	INIT_LIST_HEAD(&rmap_records);
> > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_UNKNOWN);
> > +	error = xfs_repair_rmapbt_find_rmaps(sc, &rmap_records, &new_btreeblks);
> > +	if (error)
> > +		goto out;
> 
> And we drop out here. So, essentially, any ENOMEM, locked inode or
> inode in reclaim anywhere in the filesystem will prevent rmap
> rebuild. Which says to me that rebuilding the rmap on
> on any substantial filesystem is likely to fail.
> 
> Which brings me back to my original question: why attempt to do
> rmap rebuild online given how complex it is, the performance
> implications of a full filesystem scan per AG that needs rebuild,
> and all the ways it could easily fail?

Right.  If we run out of memory or hit a locked/in-reclaim inode we'll
bounce back out to userspace having not touched anything.  Userspace can
decide if it wants to migrate or shut down other services and retry the
online scrub, or if it wants to unmount and run xfs_repair instead.
My mid-term goals for the repair patchset is to minimize the memory use
and minimize the amount of time we spend in the freezer, but for that I
need to add a few more (largeish) tools to XFS and an trying to avoid
snowballing a ton of code in front of repair. :)

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
