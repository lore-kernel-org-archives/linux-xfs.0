Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ECA186A
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 05:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734242252; cv=none; b=pxvJVs27p10kE4TAFY5+KUvv9AI1dr9VvFEQ3ztCNPDiIUYAadC1kCyu/+FQlIiM+D1nqegxSpOXss2i0q2DiJc1dpT033htaFsRM2LVrT+9wNuxs6O52/cx5R6MFSAqil8r5tpv4qi3Ule1ZjSvPaUbUY2jFC7l+gpeOVTzXBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734242252; c=relaxed/simple;
	bh=IZrg/Kx6yVJYoy6+vwX0nw7ZrZ89O6H7ztL1Vi8o3d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/Ckb5ROd1f04oE/Zil1NICImDjwKP0KqwbjRbnK3lvzf4dSY2yctCKGbPbtNa3P/R7rWmY1ODBcXRhA6PTeWBgEN6yJMzaI+kT9vOEHwmF3P+mnGBOOw9l2w2nF2zaPWxfsOM+riJTBvSYOf84dca3uFFHHUAXV7EU1RaGFJgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A93E468C7B; Sun, 15 Dec 2024 06:57:23 +0100 (CET)
Date: Sun, 15 Dec 2024 06:57:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/43] xfs: implement zoned garbage collection
Message-ID: <20241215055723.GF10051@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-27-hch@lst.de> <20241213221851.GP6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213221851.GP6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 02:18:51PM -0800, Darrick J. Wong wrote:
> Can we do the garbage collection from userspace?

Well, you can try, but it will be less efficient and more fragile.  It'll
probably also be very had to make it not deadlock.

> I've had a freespace
> defragmenter banging around in my dev tree for years:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace_2024-12-12
> 
> Which has the nice property that it knows how to query the refcount
> btree to try to move the most heavily shared blocks first.  For zoned
> that might not matter since we /must/ evacuate the whole zone.

Is moving heavily shared blocks first actually a good idea?  It is a
lot more work to move them and generates more metadata vs moving unshared
blocks.  That being said it at least handles reflinks, which this currently
doesn't.  I'll take a look at it for ideas on implementing shared block
support for the GC code.

> Regardless, it could be nice to have a userspace process that we could
> trigger from the kernel at some threshold (e.g. 70% space used) to see
> if it can clean out some zones before the kernel one kicks in and slows
> everyone down.

As said above I'm not sold on doing the work in userspace.  But adding
config nobs to start GC earlier is on Hans' TODO list, and being able
to force it also sounds useful for some use case.  I also suspect that
reusing some of this code, but driving it from the bmap btree instead
of the rmap one could be really nice for file mapping defragmentation.

> > -	struct xfs_extent_busy_tree *xg_busy_extents;
> > +	union {
> > +		/*
> > +		 * Track freed but not yet committed extents.
> > +		 */
> > +		struct xfs_extent_busy_tree	*xg_busy_extents;
> > +
> > +		/*
> > +		 * List of groups that need a zone reset for zoned file systems.
> > +		 */
> > +		struct xfs_group		*xg_next_reset;
> > +	};
> 
> Don't we need busy extents for zoned rtgroups?  I was under the
> impression that the busy extents code prevents us from reallocating
> recently freed space until the EFI (and hence the bunmapi) transaction
> are persisted to the log so that new contents written after a
> reallocation + write + fdatasync won't reappear in the old file?

Yes, but remember blocks can't be reused in a zoned file systems until
the zone has been reset.  And xfs_reset_zones forces a flush on the
RT device before starting the current patch of resets, and then also
forces the log out so that all transactions that touched the rmap inode
(which includes the EFI transaction) are forced to disk.

> > @@ -592,6 +594,7 @@ static inline bool xfs_clear_resuming_quotaon(struct xfs_mount *mp)
> >  #endif /* CONFIG_XFS_QUOTA */
> >  __XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
> >  __XFS_IS_OPSTATE(using_logged_xattrs, USE_LARP)
> > +__XFS_IS_OPSTATE(in_gc, IN_GC)
> 
> Nit: I might've called this ZONEGC_RUNNING.
> 
> 	if (xfs_is_zonegc_running(mp))
> 		frob();

Fine with me.

> > +	 * State of this gc_bio.  Done means the current I/O completed.
> > +	 * Set from the bio end I/O handler, read from the GC thread.
> > +	 */
> > +	unsigned long			state;
> > +#define XFS_GC_BIO_NEW			0
> > +#define XFS_GC_BIO_DONE			1
> 
> Are these bits, or a enum in disguise?

They are an enum in disguise (sounds like a great country song, to go
along with this recent programming theme metal song:

https://www.youtube.com/watch?v=yup8gIXxWDU

> 
> > +
> > +	/*
> > +	 * Pointer to the inode and range of the inode that the GC is performed
> > +	 * for.
> > +	 */
> > +	struct xfs_inode		*ip;
> > +	loff_t				offset;
> > +	unsigned int			len;
> 
> Are offset/len in bytes?  It looks like they are.

Yes.

> > +xfs_zoned_need_gc(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
> > +		return false;
> > +	if (xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE) <
> > +	    mp->m_groups[XG_TYPE_RTG].blocks *
> > +	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
> 
> Is the righthand side of the comparison the number of blocks in the
> zones that are open for userspace can write to?

Yes.  m_max_open_zones is the maximum number of zones we can write to
at the same time.  From that XFS_OPEN_GC_ZONES is deducted because GC
zones (there's only 1 right now) always use reserved blocks.

> > +struct xfs_zone_gc_iter {
> > +	struct xfs_rtgroup		*victim_rtg;
> > +	unsigned int			rec_count;
> > +	unsigned int			rec_idx;
> > +	xfs_agblock_t			next_startblock;
> > +	struct xfs_rmap_irec		recs[XFS_ZONE_GC_RECS];
> > +};
> 
> Hmm, each xfs_rmap_irec is 32 bytes, so this structure consumes a little
> bit more than 32K of memory.  How about 1023 records to be nicer to the
> slab allocator?

Sure.

> > +static int
> > +xfs_zone_gc_query_cb(
> 
> This function gathers rmaps for file blocks to evacuate, right?

Yes.

> 
> > +	struct xfs_btree_cur	*cur,
> > +	const struct xfs_rmap_irec *irec,
> > +	void			*private)
> > +{
> > +	struct xfs_zone_gc_iter	*iter = private;
> > +
> > +	ASSERT(!XFS_RMAP_NON_INODE_OWNER(irec->rm_owner));
> > +	ASSERT(!xfs_is_sb_inum(cur->bc_mp, irec->rm_owner));
> > +	ASSERT(!(irec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK)));
> 
> I wonder if you actually want to return EFSCORRUPTED for these?

They could.  OTOH returning all this on a rtrmap query is more than just
a corrupted file system, isn't it?

> > +	const struct xfs_rmap_irec	*recb = b;
> > +	int64_t				diff;
> > +
> > +	diff = reca->rm_owner - recb->rm_owner;
> > +	if (!diff)
> > +		diff = reca->rm_offset - recb->rm_offset;
> > +	return clamp(diff, -1, 1);
> > +}
> 
> A silly trick I learned from Kent is that this avoids problems with
> unsigned comparisons and other weird C behavior:
> 
> #define cmp_int(l, r)            ((l > r) - (l < r))

Looks like that is used in a few places and would be nice to have
in kernel.h.

> > +	error = xfs_trans_alloc_empty(mp, &tp);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> > +	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
> 
> Why join the rtrmap inode when this is an empty transaction?

Probably because I stupidly copy and pasted this from somewhere and
it didn't blow up? :)

> > +}
> > +
> > +/*
> > + * Iterate through all zones marked as reclaimable and find a candidate that is
> > + * either good enough for instant reclaim, or the one with the least used space.
> 
> What is instant reclaim?  Is there a non-instant(aneous) reclaim?
> Are we biasing towards reclaiming zones with fewer blocks to evacuate?

Instantly reclaims is when the zone is used less than 1% and we just take
it instead of looking for the best candidate (least used blocks)
otherwise.



> > +static struct xfs_open_zone *
> > +xfs_select_gc_zone(
> 
> For what purpose are we selecting a gc zone?  I guess this is the zone
> that we're evacuating blocks *into*?  As opposed to choosing a zone to
> evacuate, which I think is what xfs_zone_reclaim_pick does?

Exactly.

> (This could use a short comment for readers to perform their own grok
> checking.)

Sure.  And maybe we can also work on the naming to throw in more
consistent victim and target prefixes.

> > +
> > +static bool
> > +xfs_zone_gc_allocate(
> 
> What are allocating here?  The @data and the xfs_open_zone already
> exist, right?  AFAICT we're really just picking a zone to evacuate into,
> and then returning the daddr/rtbcount so the caller can allocate a bio,
> right?

Yes, it allocates blocks from the gc zones.  I.e this is the GC
counterpart of xfs_zone_alloc_blocks.  Maybe xfs_zone_gc_alloc_blocks
might be a better name?

> > +	struct xfs_zone_gc_data	*data = chunk->data;
> > +	struct xfs_mount	*mp = chunk->ip->i_mount;
> > +	unsigned int		folio_offset = chunk->bio.bi_io_vec->bv_offset;
> > +	struct xfs_gc_bio	*split_chunk;
> > +
> > +	if (chunk->bio.bi_status)
> > +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> 
> Media errors happen, is there a gentler way to handle a read error
> besides shutting down the fs?  We /do/ have all that infrastructure for
> retrying IOs.

We do have it, and as far as I can tell it's pretty useless.  Retryable
errors are already retried by the device or drive, so once things bubble
up to the file system they tend to be fatal.  So the only thing we do
with retrying here is to delay the inevitable trouble.

I'm actually looking into something related at the moment:  for writes
XFS currently bubbles up write errors to the caller (dio) or stores
them in the mapping (buffered I/O), which for the latter means we lose
the pagecache because the dirty bits are cleared, but only users that
actually fsync or close will ever see it.  And with modern media you
will only get these errors if shit really hit the fan.  For normal
1 device XFS configurations we'll hit a metadata write error sooner
or later and shut the file system down, but with an external RT device
we don't and basically never shut down which is rather problematic.
So I'm tempted to add code to (at least optionally) shut down after
data write errors.

> > +static void
> > +xfs_zone_gc_finish_chunk(
> > +	struct xfs_gc_bio	*chunk)
> > +{
> > +	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> > +	struct xfs_inode	*ip = chunk->ip;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	int			error;
> > +
> > +	if (chunk->bio.bi_status)
> > +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> 
> Can we pick a different zone and try again?

We could.  But it will just fail again and we'll delay the failure
reporting to the upper layer which would much rather know about that and
say move it's data to a different node.

> > +	/*
> > +	 * Cycle through the iolock and wait for direct I/O and layouts to
> > +	 * ensure no one is reading from the old mapping before it goes away.
> > +	 */
> > +	xfs_ilock(ip, iolock);
> > +	error = xfs_break_layouts(VFS_I(ip), &iolock, BREAK_UNMAP);
> > +	if (!error)
> > +		inode_dio_wait(VFS_I(ip));
> > +	xfs_iunlock(ip, iolock);
> 
> But we drop the io/mmaplocks, which means someone can wander in and
> change the file before we get to xfs_zoned_end_io.  Is that a problem?

No, that's why xfs_zoned_end_io has the special mode where the old
startblock is passed in by GC, and it won't remap when they mismatch.
xfs_zoned_end_extent has a comment describing it.

> > +int
> > +xfs_zone_reset_sync(
> > +	struct xfs_rtgroup	*rtg)
> > +{
> > +	int			error = 0;
> > +	struct bio		bio;
> > +
> > +	bio_init(&bio, rtg_mount(rtg)->m_rtdev_targp->bt_bdev, NULL, 0,
> > +			REQ_OP_ZONE_RESET);
> > +	if (xfs_prepare_zone_reset(&bio, rtg))
> > +		error = submit_bio_wait(&bio);
> > +	bio_uninit(&bio);
> > +
> > +	return error;
> > +}
> 
> The only caller of this is in xfs_zone_alloc, maybe it belongs there?

I actually split it out recently so that we don't need a forward
declaration for xfs_zone_gc_data in xfs_zone_priv.h that was needed
previously and which is a bit ugly.  I also conceptually is part of
GC, as it finishes off a GC process interrupted by a powerfail.

> TBH I sorta expected all the functions in here to be xfs_zonegc_XXX.

I can look into that.

> For us clueless dolts, it would be useful to have a comment somewhere
> explaining the high level operation of the garbage collector

Sure.

> -- it picks
> a non-empty zone to empty and a not-full zone to write into, queries the
> rmap to find all the space mappings, initiates a read of the disk
> contents, writes (or zone appends) the data to the new zone, then remaps
> the space in the file.  When the zone becomes empty, it is reset.

Yes, I'll add something.

> > +	struct xfs_zone_gc_data	*data;
> > +	struct xfs_zone_gc_iter	*iter;
> > +
> > +	data = xfs_zone_gc_data_alloc(mp);
> > +	if (!data)
> > +		return -ENOMEM;
> 
> If we return ENOMEM here, who gets the return value from the thread
> function?  I thought it was kthread_stop, and kthread_create only
> returns errors encountered while setting up the thread?

Hmm.  I guess I can move it to the caller, although passing both the
data and iter will make it a bit complicated.

> > --- a/fs/xfs/xfs_zone_space_resv.c
> > +++ b/fs/xfs/xfs_zone_space_resv.c
> > @@ -159,6 +159,13 @@ xfs_zoned_reserve_available(
> >  		if (error != -ENOSPC)
> >  			break;
> >  
> > +		/*
> > +		 * If there is nothing left to reclaim, give up.
> > +		 */
> > +		if (!xfs_is_in_gc(mp) &&
> > +		    !xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
> > +			break;
> 
> Should the caller try again with a different zone if this happens?

No zones involved at all at this level of code.  We're before
taking iolock and just reserving space.  But
!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE) means there
literally isn't any reclaimable space left, and !xfs_is_in_gc means
there's also no more ongoing processes that might have taken the last
zone from reclaimable space, but haven't added it to the available
pool yet. I.e. this is the hard ENOSPC condition.

