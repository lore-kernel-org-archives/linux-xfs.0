Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfAGTLE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jan 2019 14:11:04 -0500
Date: Mon, 7 Jan 2019 14:11:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug 202053] [xfstests generic/464]: XFS corruption and
 Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
Message-ID: <20190107191101.GC5506@bfoster>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
 <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
 <20190104123217.GA16751@bfoster>
 <20190105213120.GS4205@dastard>
 <20190106215737.GT4205@dastard>
 <20190107144114.GB5506@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107144114.GB5506@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 07, 2019 at 09:41:14AM -0500, Brian Foster wrote:
> On Mon, Jan 07, 2019 at 08:57:37AM +1100, Dave Chinner wrote:
> > On Sun, Jan 06, 2019 at 08:31:20AM +1100, Dave Chinner wrote:
> > > On Fri, Jan 04, 2019 at 07:32:17AM -0500, Brian Foster wrote:
> > > > On Tue, Dec 25, 2018 at 06:10:59AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > > - writepages is in progress on a particular file that has decently sized
> > > >   post-eof speculative preallocation
> > > > - writepages gets to the point where it looks up or allocates a new imap
> > > >   that includes the preallocation, the allocation/lookup result is
> > > >   stored in wpc
> > > > - the file is closed by one process, killing off preallocation, then
> > > >   immediately appended to by another, updating the file size by a few
> > > >   bytes
> > > > - writepages comes back around to xfs_map_blocks() and trims imap to the
> > > >   current size, but imap still includes one block of the original speculative
> > > >   prealloc (that was truncated and recreated) because the size increased
> > > >   between the time imap was stored and trimmed
> > > 
> > > I'm betting hole punch can cause similar problems with cached maps
> > > in writepage. I wrote a patch yonks ago to put a generation number
> > > in the extent fork and to store it in the cached map, and to
> > > invalidate the cached map if they didn't match.
> > > 
> > > > The EOF trim approach is known to be a bandaid and potentially racy, but
> > > > ISTM that this problem can be trivially avoided by moving or adding
> > > > trims of wpc->imap immediately after a new one is cached. I don't
> > > > reproduce the problem so far with a couple such extra calls in place.
> > > > 
> > > > Bigger picture, we need some kind of invalidation mechanism similar to
> > > > what we're already doing for dealing with the COW fork in this writeback
> > > > context. I'm not sure the broad semantics used by the COW fork sequence
> > > > counter mechanism is really suitable for the data fork because any
> > > > extent-related change in the fork would cause an invalidation, but I am
> > > > wondering if we could define some subset of less frequent operations for
> > > > the same mechanism to reliably invalidate (e.g., on eofblocks trims, for
> > > > starters).
> > > 
> > > The patch I had is below - I haven't forward ported it or anything,
> > > just pulled it from my archive to demonstrate what I think we
> > > probably need to be doing here. If we want to limit when it causes
> > > invalidations, then we need probably need to limit which operations
> > > cause the generation number for that inode fork to be bumped.
> > 
> > Ugh. Didn't attach patch.
> > 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
> Thanks...
> 
> > 
> > xfs: add generation number for cached imap invalidation
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because writepage caches an extent map with locks being held, it can
> > race with truncate and other extent invalidations. This means we can
> > attempt to write to ranges that have been freed and/or use pages
> > that have been unmapped.
> > 
> > The band-aid of using xfs_trim_extent_eof() to invalidate mappings
> > introduces a new race condition between truncate_setsize() and
> > a page under writeback - the locked page can allocate a valid map
> > because it's over a delalloc region, but between xfs_map_blocks()
> > allocating the extent and xfs_imap_valid() checking it, the
> > inode size can change and that will result in xfs_imap_valid()
> > saying the map is invalid.
> > 
> 
> For reference, note that we partially screwed this up during review of
> the original patch. I had it in my mind that the race window here would
> be too small to exploit in practice and looking back, I see that is
> because we tweaked the logic during review. The original patch is
> here[1] and the tweaks seemed fine at the time, but this bug clearly
> demonstrates that was wrong.
> 
> [1] https://patchwork.kernel.org/patch/10001703/
> 
> This of course doesn't change the fact that the approach itself is
> fundamentally racy, but rather suggests that something like the patch
> that Zorro verified could serve as stable fodder on the way to a proper
> fix.
> 
> > Hence we get spurious writeback failures of correctly mapped
> > pages/buffers with allocated extents underneath them. This triggers
> > assert failures in writeback that are false positives - it occurs
> > when truncate_setsize() is waiting for IO on the page to complete
> > before allowing invalidation of the page to occur. Removal of the
> > extent being written into doesn't occur until after the page cache
> > truncation is completed, so xfs_trim_extent_eof() is acting
> > prematurely in this case.
> > 
> > To fix this, what we really need to do is invalidate the cached map
> > when the extent list changes, not when the vfs inode size changes.
> > Add a extent list generation number to the in-core extent list
> > that is bumped on every change to the extent list, and add that
> > in all imaps returned from xfs_bmapi_read().
> > 
> > When we go to use the information in the imap, and we've dropped the
> > locks that keep the map coherent, we need to recheck the the
> > generation is still valid once we regain the inode locks. If the
> > generation number has changed, we can't use the cached mapping
> > information and we need to back out and restart whatever operation
> > we are caching the map for.
> > 
> > In theory, this can be done with seqlocks, but I couldn't get my
> > head around how to do this sanely. Generation numbers are simple
> > to understand and implement...
> > 
> 
> I've only made a quick pass and much of the affected context has
> changed, but isn't this roughly equivalent to the mechanism introduced
> by Christoph's commit e666aa37f4 ("xfs: avoid COW fork extent lookups in
> writeback if the fork didn't change")? I was thinking we could
> essentially accomplish the same thing by generalizing that for the data
> fork. That's a very small change, but we'd still need to consider
> whether we really want to invalidate on every data fork update...
> 
> For example, I'm concerned that something like sustained buffered writes
> could completely break the writeback imap cache by continuously
> invalidating it. I think speculative preallocation should help with this
> in the common case by already spreading those writes over fewer
> allocations, but do we care enough about the case where preallocation
> might be turned down/off to try and restrict where we bump the sequence
> number (to > i_size changes, for example)? Maybe it's not worth the
> trouble just to optimize out a shared ilock cycle and lookup, since the
> extent list is still in-core after all.
> 

A follow up FWIW... a quick test of some changes to reuse the existing
mechanism doesn't appear to show much of a problem in this regard, even
with allocsize=4k. I think another thing that minimizes impact is that
even if we end up revalidating the same imap over and over, the ioend
construction logic is distinct and based on contiguity. IOW, writeback
is still sending the same sized I/Os for contiguous blocks...

Brian

> Brian
> 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 08df809e2315..1ec408007cab 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3691,6 +3691,7 @@ xfs_bmapi_trim_map(
> >  	mval->br_blockcount = XFS_FILBLKS_MIN(end - *bno,
> >  			got->br_blockcount - (*bno - got->br_startoff));
> >  	mval->br_state = got->br_state;
> > +	mval->br_generation = got->br_generation;
> >  	ASSERT(mval->br_blockcount <= len);
> >  	return;
> >  }
> > @@ -3799,6 +3800,7 @@ xfs_bmapi_read(
> >  		mval->br_startblock = HOLESTARTBLOCK;
> >  		mval->br_blockcount = len;
> >  		mval->br_state = XFS_EXT_NORM;
> > +		mval->br_generation = xfs_iext_generation_fetch(ifp);
> >  		*nmap = 1;
> >  		return 0;
> >  	}
> > @@ -3815,9 +3817,14 @@ xfs_bmapi_read(
> >  	obno = bno;
> >  
> >  	while (bno < end && n < *nmap) {
> > -		/* Reading past eof, act as though there's a hole up to end. */
> > -		if (eof)
> > +		/*
> > +		 * If we are mapping past the last extent in the fork, act as
> > +		 * though there's a hole up to end of the requested mapping.
> > +		 */
> > +		if (eof) {
> >  			got.br_startoff = end;
> > +			got.br_generation = xfs_iext_generation_fetch(ifp);
> > +		}
> >  		if (got.br_startoff > bno) {
> >  			/* Reading in a hole.  */
> >  			mval->br_startoff = bno;
> > @@ -3825,6 +3832,7 @@ xfs_bmapi_read(
> >  			mval->br_blockcount =
> >  				XFS_FILBLKS_MIN(len, got.br_startoff - bno);
> >  			mval->br_state = XFS_EXT_NORM;
> > +			mval->br_generation = got.br_generation;
> >  			bno += mval->br_blockcount;
> >  			len -= mval->br_blockcount;
> >  			mval++;
> > diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> > index 343a94246f5b..bc52269b7973 100644
> > --- a/fs/xfs/libxfs/xfs_iext_tree.c
> > +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> > @@ -663,6 +663,7 @@ xfs_iext_insert(
> >  
> >  	if (new)
> >  		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
> > +	xfs_iext_generation_inc(ifp);
> >  }
> >  
> >  static struct xfs_iext_node *
> > @@ -890,6 +891,7 @@ xfs_iext_remove(
> >  		cur->pos = 0;
> >  	}
> >  
> > +	xfs_iext_generation_inc(ifp);
> >  	if (nr_entries >= RECS_PER_LEAF / 2)
> >  		return;
> >  
> > @@ -944,6 +946,7 @@ xfs_iext_lookup_extent(
> >  		return false;
> >  found:
> >  	xfs_iext_get(gotp, cur_rec(cur));
> > +	gotp->br_generation = xfs_iext_generation_fetch(ifp);
> >  	return true;
> >  }
> >  
> > @@ -990,6 +993,7 @@ xfs_iext_update_extent(
> >  
> >  	trace_xfs_bmap_pre_update(ip, cur, state, _RET_IP_);
> >  	xfs_iext_set(cur_rec(cur), new);
> > +	xfs_iext_generation_inc(ifp);
> >  	trace_xfs_bmap_post_update(ip, cur, state, _RET_IP_);
> >  }
> >  
> > @@ -1006,6 +1010,7 @@ xfs_iext_get_extent(
> >  	if (!xfs_iext_valid(ifp, cur))
> >  		return false;
> >  	xfs_iext_get(gotp, cur_rec(cur));
> > +	gotp->br_generation = xfs_iext_generation_fetch(ifp);
> >  	return true;
> >  }
> >  
> > @@ -1040,4 +1045,5 @@ xfs_iext_destroy(
> >  	ifp->if_bytes = 0;
> >  	ifp->if_height = 0;
> >  	ifp->if_u1.if_root = NULL;
> > +	xfs_iext_generation_inc(ifp);
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index b9f0098e33b8..3a1c1dcb8b54 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -28,6 +28,7 @@ typedef struct xfs_ifork {
> >  	int			if_bytes;	/* bytes in if_u1 */
> >  	int			if_real_bytes;	/* bytes allocated in if_u1 */
> >  	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
> > +	uint32_t		if_generation;	/* extent list generation # */
> >  	short			if_broot_bytes;	/* bytes allocated for root */
> >  	unsigned char		if_flags;	/* per-fork flags */
> >  	int			if_height;	/* height of the extent tree */
> > @@ -186,4 +187,32 @@ extern struct kmem_zone	*xfs_ifork_zone;
> >  
> >  extern void xfs_ifork_init_cow(struct xfs_inode *ip);
> >  
> > +/*
> > + * Bump the fork's generation count and drop a write barrier so it can
> > + * be checked without holding locks
> > + */
> > +static inline void
> > +xfs_iext_generation_inc(
> > +	struct xfs_ifork	*ifp)
> > +{
> > +	ifp->if_generation++;
> > +	smp_wmb();
> > +}
> > +
> > +static inline uint32_t
> > +xfs_iext_generation_fetch(
> > +	struct xfs_ifork	*ifp)
> > +{
> > +	smp_rmb();
> > +	return READ_ONCE(ifp->if_generation);
> > +}
> > +
> > +static inline bool
> > +xfs_iext_generation_same(
> > +	struct xfs_ifork	*ifp,
> > +	uint32_t		val)
> > +{
> > +	return (val == xfs_iext_generation_fetch(ifp));
> > +}
> > +
> >  #endif	/* __XFS_INODE_FORK_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 3c560695c546..781ca5252fe4 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -151,12 +151,18 @@ typedef enum {
> >  	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
> >  } xfs_exntst_t;
> >  
> > +/*
> > + * There is a generation number added to the incore BMBT record structure for
> > + * determining when cached records held outside of the extent list locks are
> > + * still valid.  This is only filled out on lookups, and is a read-only value.
> > + */
> >  typedef struct xfs_bmbt_irec
> >  {
> >  	xfs_fileoff_t	br_startoff;	/* starting file offset */
> >  	xfs_fsblock_t	br_startblock;	/* starting block number */
> >  	xfs_filblks_t	br_blockcount;	/* number of blocks */
> >  	xfs_exntst_t	br_state;	/* extent state */
> > +	uint32_t	br_generation;	/* extent list generation number */
> >  } xfs_bmbt_irec_t;
> >  
> >  #endif	/* __XFS_TYPES_H__ */
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 0ca511857f7c..4504e8ecbae1 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -793,6 +793,7 @@ xfs_map_blocks(
> >  			imap->br_startoff = offset_fsb;
> >  			imap->br_blockcount = end_fsb - offset_fsb;
> >  			imap->br_startblock = HOLESTARTBLOCK;
> > +			imap->br_generation = xfs_iext_generation_fetch(&ip->i_df);
> >  			*type = XFS_IO_HOLE;
> >  		} else if (imap->br_startblock == HOLESTARTBLOCK) {
> >  			/* landed in a hole */
> > @@ -864,23 +865,46 @@ STATIC bool
> >  xfs_imap_valid(
> >  	struct inode		*inode,
> >  	struct xfs_bmbt_irec	*imap,
> > -	xfs_off_t		offset)
> > +	xfs_off_t		offset,
> > +	int			type)
> >  {
> > -	offset >>= inode->i_blkbits;
> > +	struct xfs_ifork	*ifp;
> > +
> >  
> >  	/*
> > -	 * We have to make sure the cached mapping is within EOF to protect
> > -	 * against eofblocks trimming on file release leaving us with a stale
> > -	 * mapping. Otherwise, a page for a subsequent file extending buffered
> > -	 * write could get picked up by this writeback cycle and written to the
> > -	 * wrong blocks.
> > +	 * We have to make sure the cached mapping hasn't been invalidated by an
> > +	 * extent list modification (e.g. truncate, releasing post-eof blocks,
> > +	 * etc). If the extent list has changed, we need to get a new map.
> > +	 *
> > +	 * Removing a range of a file will clear extents from both the data and
> > +	 * COW fork. That means a single extent range removal will bump both the
> > +	 * data and cow fork generation numbers if such extents exist in the
> > +	 * range. Hence we can safely check against the generation number of the
> > +	 * specific fork we are operating on here as it will flag an
> > +	 * invalidation if the removal affected the specific fork we are doing
> > +	 * IO from.
> >  	 *
> > -	 * Note that what we really want here is a generic mapping invalidation
> > -	 * mechanism to protect us from arbitrary extent modifying contexts, not
> > -	 * just eofblocks.
> > +	 * Finally, page invalidation will block on the page lock we are
> > +	 * holding, but truncate may have already changed the file size. Hence
> > +	 * we could be beyond the new EOF here, but truncate can't proceed until
> > +	 * we finish IO on this page. Checking against EOF right now means we
> > +	 * have to unwind and discard the page, and we have to do similar checks
> > +	 * everywhere we pick up the inode locks again.
> > +	 *
> > +	 * However, it's still valid to allocate and write the data here because
> > +	 * we have valid data and the the extent removal after the page
> > +	 * invalidation completes will clean up for us. Ignoring this size
> > +	 * change race condition and using on extent map coherency checks to
> > +	 * determine whether to proceed or not makes everything in the writepage
> > +	 * path simpler.
> >  	 */
> > -	xfs_trim_extent_eof(imap, XFS_I(inode));
> > +	ifp = XFS_IFORK_PTR(XFS_I(inode), type == XFS_IO_COW ? XFS_COW_FORK
> > +							     : XFS_DATA_FORK);
> > +	if (!xfs_iext_generation_same(ifp, imap->br_generation))
> > +		return false;
> >  
> > +
> > +	offset >>= inode->i_blkbits;
> >  	return offset >= imap->br_startoff &&
> >  		offset < imap->br_startoff + imap->br_blockcount;
> >  }
> > @@ -932,6 +956,7 @@ xfs_writepage_map(
> >  	for (poffset = 0;
> >  	     poffset < PAGE_SIZE;
> >  	     poffset += len, file_offset += len, bh = bh->b_this_page) {
> > +		int retries = 0;
> >  
> >  		/* past the range we are writing, so nothing more to write. */
> >  		if (file_offset >= end_offset)
> > @@ -954,24 +979,54 @@ xfs_writepage_map(
> >  		/* Check to see if current map spans this file offset */
> >  		if (wpc->imap_valid)
> >  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> > -							 file_offset);
> > +						 file_offset, wpc->io_type);
> >  
> >  		/*
> > -		 * If we don't have a valid map, now it's time to get
> > -		 * a new one for this offset. This will allocate delalloc
> > -		 * regions or COW shared extents. If we return without a valid
> > -		 * map, it means we landed in a hole and we skip the block.
> > +		 * If we don't have a valid map, now it's time to get a new one
> > +		 * for this offset. This will allocate delalloc regions or COW
> > +		 * shared extents. If we return without a valid map, it means we
> > +		 * raced with another extent operation.
> > +		 *
> > +		 * If we are racing with invalidation, it will wait for us to
> > +		 * release the page lock which means allocation and IO is ok to
> > +		 * finish off.
> > +		 *
> > +		 * Hence we loop here trying to remap the page until we get a
> > +		 * valid map that hasn't been changed by the time we check it.
> >  		 */
> > -		if (!wpc->imap_valid) {
> > +		while (!wpc->imap_valid) {
> > +			if (!(++retries % 10)) {
> > +				xfs_warn_ratelimited(XFS_I(inode)->i_mount,
> > +					"%s: looping %d times", __func__, retries);
> > +			}
> > +
> >  			error = xfs_map_blocks(inode, file_offset, &wpc->imap,
> >  					     &wpc->io_type);
> > +			if (error == -EAGAIN) {
> > +				/*
> > +				 * Raced with another extent list modification
> > +				 * between map and allocate operations. Back off
> > +				 * for a short while, try again.
> > +				 */
> > +				msleep(1);
> > +				continue;
> > +			}
> >  			if (error)
> >  				goto out;
> > +
> > +			/*
> > +			 * We can still race with another extent list mod by the
> > +			 * time we get back here. It may have been a truncate,
> > +			 * so if the extent is not valid now, we need to map
> > +			 * again, knowing the truncate will be complete before
> > +			 * the next map is executed and so any future
> > +			 * invalidation mod will block on the page lock we hold
> > +			 */
> >  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> > -							 file_offset);
> > +						 file_offset, wpc->io_type);
> >  		}
> >  
> > -		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE) {
> > +		if (wpc->io_type == XFS_IO_HOLE) {
> >  			/*
> >  			 * set_page_dirty dirties all buffers in a page, independent
> >  			 * of their state.  The dirty state however is entirely
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index ad48e2f24699..3383287633ff 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -674,8 +674,8 @@ xfs_iomap_write_allocate(
> >  	xfs_bmbt_irec_t *imap)
> >  {
> >  	xfs_mount_t	*mp = ip->i_mount;
> > -	xfs_fileoff_t	offset_fsb, last_block;
> > -	xfs_fileoff_t	end_fsb, map_start_fsb;
> > +	xfs_fileoff_t	offset_fsb;
> > +	xfs_fileoff_t	map_start_fsb;
> >  	xfs_fsblock_t	first_block;
> >  	struct xfs_defer_ops	dfops;
> >  	xfs_filblks_t	count_fsb;
> > @@ -730,56 +730,28 @@ xfs_iomap_write_allocate(
> >  			xfs_defer_init(&dfops, &first_block);
> >  
> >  			/*
> > -			 * it is possible that the extents have changed since
> > -			 * we did the read call as we dropped the ilock for a
> > -			 * while. We have to be careful about truncates or hole
> > -			 * punchs here - we are not allowed to allocate
> > -			 * non-delalloc blocks here.
> > -			 *
> > -			 * The only protection against truncation is the pages
> > -			 * for the range we are being asked to convert are
> > -			 * locked and hence a truncate will block on them
> > -			 * first.
> > -			 *
> > -			 * As a result, if we go beyond the range we really
> > -			 * need and hit an delalloc extent boundary followed by
> > -			 * a hole while we have excess blocks in the map, we
> > -			 * will fill the hole incorrectly and overrun the
> > -			 * transaction reservation.
> > +			 * Now we've locked the inode, we can determine if the
> > +			 * region we are attempting to allocate over is still
> > +			 * valid. If it's potentially invalid, then generation
> > +			 * numbers won't match and we need to back out
> > +			 * completely and let the caller decide what to do.
> >  			 *
> > -			 * Using a single map prevents this as we are forced to
> > -			 * check each map we look for overlap with the desired
> > -			 * range and abort as soon as we find it. Also, given
> > -			 * that we only return a single map, having one beyond
> > -			 * what we can return is probably a bit silly.
> > -			 *
> > -			 * We also need to check that we don't go beyond EOF;
> > -			 * this is a truncate optimisation as a truncate sets
> > -			 * the new file size before block on the pages we
> > -			 * currently have locked under writeback. Because they
> > -			 * are about to be tossed, we don't need to write them
> > -			 * back....
> > +			 * This will occur if we race with truncate or some
> > +			 * other extent manipulation while we don't have the
> > +			 * inode locked.
> >  			 */
> > -			nimaps = 1;
> > -			end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> > -			error = xfs_bmap_last_offset(ip, &last_block,
> > -							XFS_DATA_FORK);
> > -			if (error)
> > +			if (!xfs_iext_generation_same(
> > +					XFS_IFORK_PTR(ip, whichfork),
> > +					imap->br_generation)) {
> > +				error = -EAGAIN;
> >  				goto trans_cancel;
> > -
> > -			last_block = XFS_FILEOFF_MAX(last_block, end_fsb);
> > -			if ((map_start_fsb + count_fsb) > last_block) {
> > -				count_fsb = last_block - map_start_fsb;
> > -				if (count_fsb == 0) {
> > -					error = -EAGAIN;
> > -					goto trans_cancel;
> > -				}
> >  			}
> >  
> >  			/*
> >  			 * From this point onwards we overwrite the imap
> >  			 * pointer that the caller gave to us.
> >  			 */
> > +			nimaps = 1;
> >  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
> >  						count_fsb, flags, &first_block,
> >  						nres, imap, &nimaps,
