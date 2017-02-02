Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750924AbdBBTm6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 14:42:58 -0500
Date: Thu, 2 Feb 2017 14:42:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 7/7] xfs: mark speculative prealloc CoW fork extents
 unwritten
Message-ID: <20170202194256.GA37517@bfoster.bfoster>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582223303.12293.11053073799262731296.stgit@birch.djwong.org>
 <20170201023617.GM9134@birch.djwong.org>
 <20170202150435.GA3487@bfoster.bfoster>
 <20170202170431.GA14001@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170202170431.GA14001@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 02, 2017 at 09:04:31AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 02, 2017 at 10:04:35AM -0500, Brian Foster wrote:
> > On Tue, Jan 31, 2017 at 06:36:17PM -0800, Darrick J. Wong wrote:
> > > Christoph Hellwig pointed out that there's a potentially nasty race when
> > > performing simultaneous nearby directio cow writes:
> > > 
> > > "Thread 1 writes a range from B to c
> > > 
> > > "                    B --------- C
> > >                            p
> > > 
> > > "a little later thread 2 writes from A to B
> > > 
> > > "        A --------- B
> > >                p
> > > 
> > > [editor's note: the 'p' denote cowextsize boundaries, which I added to
> > > make this more clear]
> > > 
> > > "but the code preallocates beyond B into the range where thread
> > > "1 has just written, but ->end_io hasn't been called yet.
> > 
> > I'm confused by the description. Wouldn't thread 1 have already
> > allocated from B-C in the COW fork in order to send a write I/O? How
> > could thread 2 then "preallocate into a range" of the COW fork that has
> > been allocated by thread 1? (Also, wouldn't the ioend offset+size limit
> > a COW remap to the range that is covered by the completed write?)
> 
> No, it hasn't, because ... oh let's make another diagram. :)
> 
> Let's say cowextsize = 8 blocks.
> 
>     0       1       2      3
>     0123456701234567012345701234567
> 
> s = shared real blocks, R = unshared original real blocks,
> C = cow reservation, u = unwritten blocks, r = replacement real blocks
> d = where our dio write happens
> 
> D:  ssssRRRRRRRRsssssssssssssssssss
> C:  -------------------------------
> 
> Blocks 0-3 and 12-31 are shared, blocks 4-11 are unshared.
> 
> Now let's say that thread 1 tries a directio write for blocks 6-14:
> 
> t1: ------ddddddddd----------------
> 
> The whole directio context gets marked IOMAP_DIO_COW because the last 3
> blocks (12-14) have to be CoWed, and a cowextsz reservation gets created
> for blocks 8-16.  However, a cowextsz reservation is not created for
> blocks 0-7 because blocks 6-7 aren't shared.
> 

Ah, I see. This is the bit I was missing. For some reason I was thinking
we'd get a separate end_io between the regular blocks and the shared
blocks. The rest makes more sense knowing that we have one dio context
covering an I/O range split across the data and cow forks, and the only
thing to otherwise tell us what was written to the cow fork (and thus
needs to be remapped into the data fork on completion) is the existence
of those blocks in the cow fork. Thanks for the explanation.

Brian

> D:  ssssRRRRRRRRsssssssssssssssssss
> C:  --------CCCCCCCC---------------
> t1: ------ddddddddd----------------
> 
> The key here is that we don't look far enough back (or forward) in the
> data fork to realize that part of our dio write lies within a potential
> cowextsize region that has shared blocks, even though none the parts of
> that segment that this directio is writing to are themselves shared.
> 
> In other words, we see that blocks 6-7 are not shared but we do not look
> at blocks 0-5 to realize that some of those are shared.  Therefore we
> don't create a cowextsize reservation for blocks 0-7.  Furthermore, if
> we never write blocks 0-3, then promoting blocks 6-7 to a CoW is
> unnecessary.  It's unclear to me if we should do that anyway, or just
> leave it.
> 
> Before issuing the write bios, we convert the reservation to a real
> extent:
> 
> D:  ssssRRRRRRRRRRsssssssssssssssss
> C:  --------rrrrrrrr---------------
> t1: ------ddddddddd----------------
> 
> Then thread 1 issues a write to the original blocks 6-7 and to the
> replacement blocks 8-14.
> 
> Now let's say thread 2 comes along and wants to write to block 0:
> 
> D:  ssssRRRRRRRRRRsssssssssssssssss
> C:  --------rrrrrrrr---------------
> t1: ------ddddddddd----------------
> t2: d------------------------------
> 
> Since block 0 is shared, we create a cow reservation for blocks 0-7:
> 
> D:  ssssRRRRRRRRRRsssssssssssssssss
> C:  rrrrrrrrrrrrrrrr---------------
> t1: ------ddddddddd----------------
> t2: d------------------------------
> 
> Thread 1's write now finishes.  The directio context is marked COW, so
> it remaps anything it finds in the cow fork between blocks 6 and 14:
> 
> D:  ssssRRrrrrrrrrrssssssssssssssss
> C:  rrrrrr---------r---------------
> t1: ------ddddddddd----------------
> t2: d------------------------------
> 
> Oh no!  Thread 1 wrote to original blocks 6-7 and then unmapped them!
> Worse yet it replaced them with whatever allocation the CoW fork made,
> so we've inserted stale data blocks into the original file!
> 
> --D
> 
> > 
> > Brian
> > 
> > > "But once ->end_io is called thread 2 has already allocated
> > > "up to the extent size hint into the write range of thread 1,
> > > "so the end_io handler will splice the unintialized blocks from
> > > "that preallocation back into the file right after B."
> > > 
> > > We can avoid this race by ensuring that thread 1 cannot accidentally
> > > remap the blocks that thread 2 allocated (as part of speculative
> > > preallocation) as part of t2's write preparation in t1's end_io handler.
> > > The way we make this happen is by taking advantage of the unwritten
> > > extent flag as an intermediate step.
> > > 
> > > Recall that when we begin the process of writing data to shared blocks,
> > > we create a delayed allocation extent in the CoW fork:
> > > 
> > > D: --RRRRRRSSSRRRRRRRR---
> > > C: ------DDDDDDD---------
> > > 
> > > When a thread prepares to CoW some dirty data out to disk, it will now
> > > convert the delalloc reservation into an /unwritten/ allocated extent in
> > > the cow fork.  The da conversion code tries to opportunistically
> > > allocate as much of a (speculatively prealloc'd) extent as possible, so
> > > we may end up allocating a larger extent than we're actually writing
> > > out:
> > > 
> > > D: --RRRRRRSSSRRRRRRRR---
> > > U: ------UUUUUUU---------
> > > 
> > > Next, we convert only the part of the extent that we're actively
> > > planning to write to normal (i.e. not unwritten) status:
> > > 
> > > D: --RRRRRRSSSRRRRRRRR---
> > > U: ------UURRUUU---------
> > > 
> > > If the write succeeds, the end_cow function will now scan the relevant
> > > range of the CoW fork for real extents and remap only the real extents
> > > into the data fork:
> > > 
> > > D: --RRRRRRRRSRRRRRRRR---
> > > U: ------UU--UUU---------
> > > 
> > > This ensures that we never obliterate valid data fork extents with
> > > unwritten blocks from the CoW fork.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: We don't update anything on disk for the CoW unwritten extent
> > > conversion, so don't allocate a transaction.
> > > ---
> > >  fs/xfs/xfs_aops.c    |    6 +++
> > >  fs/xfs/xfs_iomap.c   |    2 -
> > >  fs/xfs/xfs_reflink.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++---
> > >  fs/xfs/xfs_reflink.h |    2 +
> > >  fs/xfs/xfs_trace.h   |    8 +++
> > >  5 files changed, 125 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > index 631e7c0..1ff9df7 100644
> > > --- a/fs/xfs/xfs_aops.c
> > > +++ b/fs/xfs/xfs_aops.c
> > > @@ -481,6 +481,12 @@ xfs_submit_ioend(
> > >  	struct xfs_ioend	*ioend,
> > >  	int			status)
> > >  {
> > > +	/* Convert CoW extents to regular */
> > > +	if (!status && ioend->io_type == XFS_IO_COW) {
> > > +		status = xfs_reflink_convert_cow(XFS_I(ioend->io_inode),
> > > +				ioend->io_offset, ioend->io_size);
> > > +	}
> > > +
> > >  	/* Reserve log space if we might write beyond the on-disk inode size. */
> > >  	if (!status &&
> > >  	    ioend->io_type != XFS_IO_UNWRITTEN &&
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 1aa3abd..767208f 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > > @@ -685,7 +685,7 @@ xfs_iomap_write_allocate(
> > >  	int		nres;
> > >  
> > >  	if (whichfork == XFS_COW_FORK)
> > > -		flags |= XFS_BMAPI_COWFORK;
> > > +		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> > >  
> > >  	/*
> > >  	 * Make sure that the dquots are there.
> > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > index 07593a3..a2e1fff 100644
> > > --- a/fs/xfs/xfs_reflink.c
> > > +++ b/fs/xfs/xfs_reflink.c
> > > @@ -82,11 +82,22 @@
> > >   * mappings are a reservation against the free space in the filesystem;
> > >   * adjacent mappings can also be combined into fewer larger mappings.
> > >   *
> > > + * As an optimization, the CoW extent size hint (cowextsz) creates
> > > + * outsized aligned delalloc reservations in the hope of landing out of
> > > + * order nearby CoW writes in a single extent on disk, thereby reducing
> > > + * fragmentation and improving future performance.
> > > + *
> > > + * D: --RRRRRRSSSRRRRRRRR--- (data fork)
> > > + * C: ------DDDDDDD--------- (CoW fork)
> > > + *
> > >   * When dirty pages are being written out (typically in writepage), the
> > > - * delalloc reservations are converted into real mappings by allocating
> > > - * blocks and replacing the delalloc mapping with real ones.  A delalloc
> > > - * mapping can be replaced by several real ones if the free space is
> > > - * fragmented.
> > > + * delalloc reservations are converted into unwritten mappings by
> > > + * allocating blocks and replacing the delalloc mapping with real ones.
> > > + * A delalloc mapping can be replaced by several unwritten ones if the
> > > + * free space is fragmented.
> > > + *
> > > + * D: --RRRRRRSSSRRRRRRRR---
> > > + * C: ------UUUUUUU---------
> > >   *
> > >   * We want to adapt the delalloc mechanism for copy-on-write, since the
> > >   * write paths are similar.  The first two steps (creating the reservation
> > > @@ -101,13 +112,29 @@
> > >   * Block-aligned directio writes will use the same mechanism as buffered
> > >   * writes.
> > >   *
> > > + * Just prior to submitting the actual disk write requests, we convert
> > > + * the extents representing the range of the file actually being written
> > > + * (as opposed to extra pieces created for the cowextsize hint) to real
> > > + * extents.  This will become important in the next step:
> > > + *
> > > + * D: --RRRRRRSSSRRRRRRRR---
> > > + * C: ------UUrrUUU---------
> > > + *
> > >   * CoW remapping must be done after the data block write completes,
> > >   * because we don't want to destroy the old data fork map until we're sure
> > >   * the new block has been written.  Since the new mappings are kept in a
> > >   * separate fork, we can simply iterate these mappings to find the ones
> > >   * that cover the file blocks that we just CoW'd.  For each extent, simply
> > >   * unmap the corresponding range in the data fork, map the new range into
> > > - * the data fork, and remove the extent from the CoW fork.
> > > + * the data fork, and remove the extent from the CoW fork.  Because of
> > > + * the presence of the cowextsize hint, however, we must be careful
> > > + * only to remap the blocks that we've actually written out --  we must
> > > + * never remap delalloc reservations nor CoW staging blocks that have
> > > + * yet to be written.  This corresponds exactly to the real extents in
> > > + * the CoW fork:
> > > + *
> > > + * D: --RRRRRRrrSRRRRRRRR---
> > > + * C: ------UU--UUU---------
> > >   *
> > >   * Since the remapping operation can be applied to an arbitrary file
> > >   * range, we record the need for the remap step as a flag in the ioend
> > > @@ -296,6 +323,66 @@ xfs_reflink_reserve_cow(
> > >  	return 0;
> > >  }
> > >  
> > > +/* Convert part of an unwritten CoW extent to a real one. */
> > > +STATIC int
> > > +__xfs_reflink_convert_cow(
> > > +	struct xfs_inode		*ip,
> > > +	struct xfs_bmbt_irec		*imap,
> > > +	xfs_fileoff_t			offset_fsb,
> > > +	xfs_filblks_t			count_fsb,
> > > +	struct xfs_defer_ops		*dfops)
> > > +{
> > > +	struct xfs_bmbt_irec		irec = *imap;
> > > +	xfs_fsblock_t			first_block;
> > > +	int				nimaps = 1;
> > > +
> > > +	xfs_trim_extent(&irec, offset_fsb, count_fsb);
> > > +	trace_xfs_reflink_convert_cow(ip, &irec);
> > > +	if (irec.br_blockcount == 0)
> > > +		return 0;
> > > +	return xfs_bmapi_write(NULL, ip, irec.br_startoff, irec.br_blockcount,
> > > +			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, &first_block,
> > > +			0, &irec, &nimaps, dfops);
> > > +}
> > > +
> > > +/* Convert all of the unwritten CoW extents in a file's range to real ones. */
> > > +int
> > > +xfs_reflink_convert_cow(
> > > +	struct xfs_inode	*ip,
> > > +	xfs_off_t		offset,
> > > +	xfs_off_t		count)
> > > +{
> > > +	struct xfs_bmbt_irec	got;
> > > +	struct xfs_defer_ops	dfops;
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> > > +	xfs_fileoff_t		offset_fsb;
> > > +	xfs_fileoff_t		end_fsb;
> > > +	xfs_extnum_t		idx;
> > > +	bool			found;
> > > +	int			error;
> > > +
> > > +	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > > +	end_fsb = XFS_B_TO_FSB(mp, offset + count);
> > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > +
> > > +	/* Convert all the extents to real from unwritten. */
> > > +	for (found = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
> > > +	     found && got.br_startoff < end_fsb;
> > > +	     found = xfs_iext_get_extent(ifp, ++idx, &got)) {
> > > +		if (got.br_state == XFS_EXT_NORM)
> > > +			continue;
> > > +		error = __xfs_reflink_convert_cow(ip, &got, offset_fsb,
> > > +				end_fsb - offset_fsb, &dfops);
> > > +		if (error)
> > > +			break;
> > > +	}
> > > +
> > > +	/* Finish up. */
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > +	return error;
> > > +}
> > > +
> > >  /* Allocate all CoW reservations covering a range of blocks in a file. */
> > >  static int
> > >  __xfs_reflink_allocate_cow(
> > > @@ -328,6 +415,7 @@ __xfs_reflink_allocate_cow(
> > >  		goto out_unlock;
> > >  	ASSERT(nimaps == 1);
> > >  
> > > +	/* Make sure there's a CoW reservation for it. */
> > >  	error = xfs_reflink_reserve_cow(ip, &imap, &shared);
> > >  	if (error)
> > >  		goto out_trans_cancel;
> > > @@ -337,14 +425,16 @@ __xfs_reflink_allocate_cow(
> > >  		goto out_trans_cancel;
> > >  	}
> > >  
> > > +	/* Allocate the entire reservation as unwritten blocks. */
> > >  	xfs_trans_ijoin(tp, ip, 0);
> > >  	error = xfs_bmapi_write(tp, ip, imap.br_startoff, imap.br_blockcount,
> > > -			XFS_BMAPI_COWFORK, &first_block,
> > > +			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, &first_block,
> > >  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
> > >  			&imap, &nimaps, &dfops);
> > >  	if (error)
> > >  		goto out_trans_cancel;
> > >  
> > > +	/* Finish up. */
> > >  	error = xfs_defer_finish(&tp, &dfops, NULL);
> > >  	if (error)
> > >  		goto out_trans_cancel;
> > > @@ -389,10 +479,13 @@ xfs_reflink_allocate_cow_range(
> > >  		if (error) {
> > >  			trace_xfs_reflink_allocate_cow_range_error(ip, error,
> > >  					_RET_IP_);
> > > -			break;
> > > +			goto out;
> > >  		}
> > >  	}
> > >  
> > > +	/* Convert the CoW extents to regular. */
> > > +	error = xfs_reflink_convert_cow(ip, offset, count);
> > > +out:
> > >  	return error;
> > >  }
> > >  
> > > @@ -641,6 +734,16 @@ xfs_reflink_end_cow(
> > >  
> > >  		ASSERT(!isnullstartblock(got.br_startblock));
> > >  
> > > +		/*
> > > +		 * Don't remap unwritten extents; these are
> > > +		 * speculatively preallocated CoW extents that have been
> > > +		 * allocated but have not yet been involved in a write.
> > > +		 */
> > > +		if (got.br_state == XFS_EXT_UNWRITTEN) {
> > > +			idx--;
> > > +			goto next_extent;
> > > +		}
> > > +
> > >  		/* Unmap the old blocks in the data fork. */
> > >  		xfs_defer_init(&dfops, &firstfsb);
> > >  		rlen = del.br_blockcount;
> > > diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> > > index aa6a4d6..1583c47 100644
> > > --- a/fs/xfs/xfs_reflink.h
> > > +++ b/fs/xfs/xfs_reflink.h
> > > @@ -30,6 +30,8 @@ extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
> > >  		struct xfs_bmbt_irec *imap, bool *shared);
> > >  extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
> > >  		xfs_off_t offset, xfs_off_t count);
> > > +extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
> > > +		xfs_off_t count);
> > >  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> > >  		struct xfs_bmbt_irec *imap);
> > >  extern void xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index 69c5bcd..d3d11905 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -3089,6 +3089,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
> > >  		__field(xfs_fileoff_t, lblk)
> > >  		__field(xfs_extlen_t, len)
> > >  		__field(xfs_fsblock_t, pblk)
> > > +		__field(int, state)
> > >  	),
> > >  	TP_fast_assign(
> > >  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> > > @@ -3096,13 +3097,15 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
> > >  		__entry->lblk = irec->br_startoff;
> > >  		__entry->len = irec->br_blockcount;
> > >  		__entry->pblk = irec->br_startblock;
> > > +		__entry->state = irec->br_state;
> > >  	),
> > > -	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x pblk %llu",
> > > +	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x pblk %llu st %d",
> > >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > >  		  __entry->ino,
> > >  		  __entry->lblk,
> > >  		  __entry->len,
> > > -		  __entry->pblk)
> > > +		  __entry->pblk,
> > > +		  __entry->state)
> > >  );
> > >  #define DEFINE_INODE_IREC_EVENT(name) \
> > >  DEFINE_EVENT(xfs_inode_irec_class, name, \
> > > @@ -3242,6 +3245,7 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
> > >  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_alloc);
> > >  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
> > >  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
> > > +DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
> > >  
> > >  DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
> > >  DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
