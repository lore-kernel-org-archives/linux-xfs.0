Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29804 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754009AbcJEUzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 16:55:52 -0400
Date: Wed, 5 Oct 2016 13:55:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 37/63] xfs: implement CoW for directio writes
Message-ID: <20161005205542.GA3992@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520498004.29434.11046105793006225587.stgit@birch.djwong.org>
 <20161005182709.GC4042@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161005182709.GC4042@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Oct 05, 2016 at 02:27:10PM -0400, Brian Foster wrote:
> On Thu, Sep 29, 2016 at 08:09:40PM -0700, Darrick J. Wong wrote:
> > For O_DIRECT writes to shared blocks, we have to CoW them just like
> > we would with buffered writes.  For writes that are not block-aligned,
> > just bounce them to the page cache.
> > 
> > For block-aligned writes, however, we can do better than that.  Use
> > the same mechanisms that we employ for buffered CoW to set up a
> > delalloc reservation, allocate all the blocks at once, issue the
> > writes against the new blocks and use the same ioend functions to
> > remap the blocks after the write.  This should be fairly performant.
> > 
> > Christoph discovered that xfs_reflink_allocate_cow_range may stumble
> > over invalid entries in the extent array given that it drops the ilock
> > but still expects the index to be stable.  Simple fixing it to a new
> > lookup for every iteration still isn't correct given that
> > xfs_bmapi_allocate will trigger a BUG_ON() if hitting a hole, and
> > there is nothing preventing a xfs_bunmapi_cow call removing extents
> > once we dropped the ilock either.
> > 
> > This patch duplicates the inner loop of xfs_bmapi_allocate into a
> > helper for xfs_reflink_allocate_cow_range so that it can be done under
> > the same ilock critical section as our CoW fork delayed allocation.
> > The directio CoW warts will be revisited in a later patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> > v2: Turns out that there's no way for xfs_end_io_direct_write to know
> > if the write completed successfully.  Therefore, do /not/ use the
> > ioend for dio cow post-processing; instead, move it to xfs_vm_do_dio
> > where we *can* tell if the write succeeded or not.
> > 
> > v3: Update the file size if we do a directio CoW across EOF.  This
> > can happen if the last block is shared, the cowextsize hint is set,
> > and we do a dio write past the end of the file.
> > 
> > v4: Christoph rewrote the allocate code to fix some concurrency
> > problems as part of migrating the code to support iomap.
> > ---
> >  fs/xfs/xfs_aops.c    |   91 +++++++++++++++++++++++++++++++++++++++----
> >  fs/xfs/xfs_file.c    |   20 ++++++++-
> >  fs/xfs/xfs_reflink.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_reflink.h |    2 +
> >  fs/xfs/xfs_trace.h   |    1 
> >  5 files changed, 208 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 1d0435a..62a95e4 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -40,6 +40,7 @@
> >  /* flags for direct write completions */
> >  #define XFS_DIO_FLAG_UNWRITTEN	(1 << 0)
> >  #define XFS_DIO_FLAG_APPEND	(1 << 1)
> > +#define XFS_DIO_FLAG_COW	(1 << 2)
> >  
> >  /*
> >   * structure owned by writepages passed to individual writepage calls
> > @@ -1191,18 +1192,24 @@ xfs_map_direct(
> >  	struct inode		*inode,
> >  	struct buffer_head	*bh_result,
> >  	struct xfs_bmbt_irec	*imap,
> > -	xfs_off_t		offset)
> > +	xfs_off_t		offset,
> > +	bool			is_cow)
> >  {
> >  	uintptr_t		*flags = (uintptr_t *)&bh_result->b_private;
> >  	xfs_off_t		size = bh_result->b_size;
> >  
> >  	trace_xfs_get_blocks_map_direct(XFS_I(inode), offset, size,
> > -		ISUNWRITTEN(imap) ? XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, imap);
> > +		ISUNWRITTEN(imap) ? XFS_IO_UNWRITTEN : is_cow ? XFS_IO_COW :
> > +		XFS_IO_OVERWRITE, imap);
> >  
> >  	if (ISUNWRITTEN(imap)) {
> >  		*flags |= XFS_DIO_FLAG_UNWRITTEN;
> >  		set_buffer_defer_completion(bh_result);
> > -	} else if (offset + size > i_size_read(inode) || offset + size < 0) {
> > +	} else if (is_cow) {
> > +		*flags |= XFS_DIO_FLAG_COW;
> > +		set_buffer_defer_completion(bh_result);
> > +	}
> > +	if (offset + size > i_size_read(inode) || offset + size < 0) {
> >  		*flags |= XFS_DIO_FLAG_APPEND;
> >  		set_buffer_defer_completion(bh_result);
> >  	}
> > @@ -1248,6 +1255,44 @@ xfs_map_trim_size(
> >  	bh_result->b_size = mapping_size;
> >  }
> >  
> > +/* Bounce unaligned directio writes to the page cache. */
> > +static int
> > +xfs_bounce_unaligned_dio_write(
> > +	struct xfs_inode	*ip,
> > +	xfs_fileoff_t		offset_fsb,
> > +	struct xfs_bmbt_irec	*imap)
> > +{
> > +	struct xfs_bmbt_irec	irec;
> > +	xfs_fileoff_t		delta;
> > +	bool			shared;
> > +	bool			x;
> > +	int			error;
> > +
> > +	irec = *imap;
> > +	if (offset_fsb > irec.br_startoff) {
> > +		delta = offset_fsb - irec.br_startoff;
> > +		irec.br_blockcount -= delta;
> > +		irec.br_startblock += delta;
> > +		irec.br_startoff = offset_fsb;
> > +	}
> > +	error = xfs_reflink_trim_around_shared(ip, &irec, &x, &shared);
> 
> 'shared' is the 3rd parameter.

Fixed.  (I actually fixed it yesterday when I made the _find_shareds
return NULLAGBLOCK to mean "no shared blocks here" and generic/139
blew up.)

> > +	if (error)
> > +		return error;
> > +	/*
> > +	 * Are we doing a DIO write to a shared block?  In
> > +	 * the ideal world we at least would fork full blocks,
> > +	 * but for now just fall back to buffered mode.  Yuck.
> > +	 * Use -EREMCHG ("remote address changed") to signal
> > +	 * this, since in general XFS doesn't do this sort of
> > +	 * fallback.
> > +	 */
> > +	if (shared) {
> > +		trace_xfs_reflink_bounce_dio_write(ip, imap);
> > +		return -EREMCHG;
> > +	}
> 
> I get that this bumps the write back up to the buffered mechanism, but
> the purpose is not very clear. We have the !unaligned check back up in
> xfs_file_dio_aio_write(), in which case we do all of the cow allocation
> stuff. I presume in that case we should never fail this check (?).

Ewww, stale stinky comments!  Originally we were just going to demote
all dio writes to a shared region to the pagecache, but when I created
the CoW fork I realized that when the write request was block aligned
that it was easy enough to make the reservation and allocate it all in
one step.  The thing you pointed out in xfs_file_dio_aio_write() is
exactly that mechanism.

Unfortunately, it seems that I neglected to modify the comment to
mention that we only do the bouncing for unaligned directio cows.

/*
 * We're here because we're trying to do a directio write to a region
 * that isn't aligned to a filesystem block.  If any part of the extent
 * is shared, fall back to buffered mode to handle the RMW.  This is
 * done by returning -EREMCHG ("remote addr changed"), which is caught
 * further up the call stack.
 */

> If the dio is unaligned, we skip that bit, get down to here and kick it
> back only if the extent happens to be shared..? Unless I missed it, I
> think this needs to be explained in the comments in both places,
> including probably updating the comment at the end of dio_aio_write()
> that states we don't fall back to buffered I/O on dio error. 

Yep.

I'd assumed that everyone knew that except for this one case we never
fall back to buffered IO from any of the directio paths.  I'll update
the other EREMCHG comment in xfs_file_write_iter() to state that more
explicitly:

/*
 * Allow a directio write to fall back to a buffered
 * write *only* in the case that we're doing a reflink
 * CoW.  In all other directio scenarios we do not
 * allow an operation to fall back to buffered mode.
 */

> > +	return 0;
> > +}
> > +
> >  STATIC int
> >  __xfs_get_blocks(
> >  	struct inode		*inode,
> > @@ -1267,6 +1312,8 @@ __xfs_get_blocks(
> >  	xfs_off_t		offset;
> >  	ssize_t			size;
> >  	int			new = 0;
> > +	bool			is_cow = false;
> > +	bool			need_alloc = false;
> >  
> >  	BUG_ON(create && !direct);
> >  
> > @@ -1292,8 +1339,27 @@ __xfs_get_blocks(
> >  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
> >  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> >  
> > -	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> > -				&imap, &nimaps, XFS_BMAPI_ENTIRE);
> > +	if (create && direct) {
> > +		is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap,
> > +					&need_alloc);
> > +	}
> 
> Nits: no need for braces here and might be cleaner to check
> xfs_is_reflink_inode(ip) here, since !reflink is probably the common
> case.

<nod>

> > +
> > +	if (!is_cow) {
> > +		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> > +					&imap, &nimaps, XFS_BMAPI_ENTIRE);
> > +		/*
> > +		 * Truncate an overwrite extent if there's a pending CoW
> > +		 * reservation before the end of this extent.  This forces us
> > +		 * to come back to writepage to take care of the CoW.
> 
> writepage?

"...come back to get_blocks to take care of..."

> > +		 */
> > +		if (create && direct && nimaps &&
> > +		    imap.br_startblock != HOLESTARTBLOCK &&
> > +		    imap.br_startblock != DELAYSTARTBLOCK &&
> > +		    !ISUNWRITTEN(&imap))
> > +			xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb,
> > +					&imap);
> > +	}
> > +	ASSERT(!need_alloc);
> >  	if (error)
> >  		goto out_unlock;
> >  
> > @@ -1345,6 +1411,13 @@ __xfs_get_blocks(
> >  	if (imap.br_startblock != HOLESTARTBLOCK &&
> >  	    imap.br_startblock != DELAYSTARTBLOCK &&
> >  	    (create || !ISUNWRITTEN(&imap))) {
> > +		if (create && direct && !is_cow) {
> > +			error = xfs_bounce_unaligned_dio_write(ip, offset_fsb,
> > +					&imap);
> > +			if (error)
> > +				return error;
> > +		}
> > +
> >  		xfs_map_buffer(inode, bh_result, &imap, offset);
> >  		if (ISUNWRITTEN(&imap))
> >  			set_buffer_unwritten(bh_result);
> > @@ -1353,7 +1426,8 @@ __xfs_get_blocks(
> >  			if (dax_fault)
> >  				ASSERT(!ISUNWRITTEN(&imap));
> >  			else
> > -				xfs_map_direct(inode, bh_result, &imap, offset);
> > +				xfs_map_direct(inode, bh_result, &imap, offset,
> > +						is_cow);
> >  		}
> >  	}
> >  
> > @@ -1479,7 +1553,10 @@ xfs_end_io_direct_write(
> >  		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
> >  
> >  		error = xfs_iomap_write_unwritten(ip, offset, size);
> > -	} else if (flags & XFS_DIO_FLAG_APPEND) {
> > +	}
> > +	if (flags & XFS_DIO_FLAG_COW)
> > +		error = xfs_reflink_end_cow(ip, offset, size);
> > +	if (flags & XFS_DIO_FLAG_APPEND) {
> >  		trace_xfs_end_io_direct_write_append(ip, offset, size);
> >  
> >  		error = xfs_setfilesize(ip, offset, size);
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index f99d7fa..025d52f 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -38,6 +38,7 @@
> >  #include "xfs_icache.h"
> >  #include "xfs_pnfs.h"
> >  #include "xfs_iomap.h"
> > +#include "xfs_reflink.h"
> >  
> >  #include <linux/dcache.h>
> >  #include <linux/falloc.h>
> > @@ -672,6 +673,13 @@ xfs_file_dio_aio_write(
> >  
> >  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
> >  
> > +	/* If this is a block-aligned directio CoW, remap immediately. */
> > +	if (xfs_is_reflink_inode(ip) && !unaligned_io) {
> > +		ret = xfs_reflink_allocate_cow_range(ip, iocb->ki_pos, count);
> > +		if (ret)
> > +			goto out;
> > +	}
> 
> Is the fact that we do this allocation up front rather than via
> get_blocks() (like traditional direct write) one of the "warts" that
> needs cleaning, or for some other reason?

"Yes". :)

We do the allocation here because we know the exact size of the IO that
userspace is asking for, so we might as well do all the allocations
at once instead of repeatedly calling back into the allocator for each
shared segment that gets fed into get_blocks.  Sort of warty.

I think this could get moved to get_blocks, though TBH I've been
wondering if all this will just get replaced with iomap as part of
killing buffer heads.

> > +
> >  	data = *from;
> >  	ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
> >  			xfs_get_blocks_direct, xfs_end_io_direct_write,
> > @@ -812,10 +820,18 @@ xfs_file_write_iter(
> >  
> >  	if (IS_DAX(inode))
> >  		ret = xfs_file_dax_write(iocb, from);
> > -	else if (iocb->ki_flags & IOCB_DIRECT)
> > +	else if (iocb->ki_flags & IOCB_DIRECT) {
> > +		/*
> > +		 * Allow DIO to fall back to buffered *only* in the case
> > +		 * that we're doing a reflink CoW.
> > +		 */
> >  		ret = xfs_file_dio_aio_write(iocb, from);
> > -	else
> > +		if (ret == -EREMCHG)
> > +			goto buffered;
> > +	} else {
> > +buffered:
> >  		ret = xfs_file_buffered_aio_write(iocb, from);
> > +	}
> >  
> >  	if (ret > 0) {
> >  		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index d913ad1..c95cdc3 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -246,7 +246,8 @@ static int
> >  __xfs_reflink_reserve_cow(
> >  	struct xfs_inode	*ip,
> >  	xfs_fileoff_t		*offset_fsb,
> > -	xfs_fileoff_t		end_fsb)
> > +	xfs_fileoff_t		end_fsb,
> > +	bool			*skipped)
> >  {
> >  	struct xfs_bmbt_irec	got, prev, imap;
> >  	xfs_fileoff_t		orig_end_fsb;
> > @@ -279,8 +280,10 @@ __xfs_reflink_reserve_cow(
> >  	end_fsb = orig_end_fsb = imap.br_startoff + imap.br_blockcount;
> >  
> >  	/* Not shared?  Just report the (potentially capped) extent. */
> > -	if (!shared)
> > +	if (!shared) {
> > +		*skipped = true;
> >  		goto done;
> > +	}
> >  
> >  	/*
> >  	 * Fork all the shared blocks from our write offset until the end of
> > @@ -326,6 +329,7 @@ xfs_reflink_reserve_cow_range(
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	xfs_fileoff_t		offset_fsb, end_fsb;
> > +	bool			skipped = false;
> >  	int			error;
> >  
> >  	trace_xfs_reflink_reserve_cow_range(ip, offset, count);
> > @@ -335,7 +339,8 @@ xfs_reflink_reserve_cow_range(
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	while (offset_fsb < end_fsb) {
> > -		error = __xfs_reflink_reserve_cow(ip, &offset_fsb, end_fsb);
> > +		error = __xfs_reflink_reserve_cow(ip, &offset_fsb, end_fsb,
> > +				&skipped);
> >  		if (error) {
> >  			trace_xfs_reflink_reserve_cow_range_error(ip, error,
> >  				_RET_IP_);
> > @@ -347,6 +352,102 @@ xfs_reflink_reserve_cow_range(
> >  	return error;
> >  }
> >  
> > +/* Allocate all CoW reservations covering a range of blocks in a file. */
> > +static int
> > +__xfs_reflink_allocate_cow(
> > +	struct xfs_inode	*ip,
> > +	xfs_fileoff_t		*offset_fsb,
> > +	xfs_fileoff_t		end_fsb)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_bmbt_irec	imap;
> > +	struct xfs_defer_ops	dfops;
> > +	struct xfs_trans	*tp;
> > +	xfs_fsblock_t		first_block;
> > +	xfs_fileoff_t		next_fsb;
> > +	int			nimaps = 1, error;
> > +	bool			skipped = false;
> > +
> > +	xfs_defer_init(&dfops, &first_block);
> > +
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
> > +			XFS_TRANS_RESERVE, &tp);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +
> > +	next_fsb = *offset_fsb;
> > +	error = __xfs_reflink_reserve_cow(ip, &next_fsb, end_fsb, &skipped);
> > +	if (error)
> > +		goto out_trans_cancel;
> 
> Do we really need to do the delayed allocation that results from this?
> Couldn't we factor out the shared extent walking that allows us to just
> perform the real allocations below?

The delayed reservation -> allocation two-step is necessary to create
replacement that are aligned to the CoW extent size hint.  This is
important for aligning extents in the same way as the regular extent
size hint, and critical for detecting random writes and landing them all
in as close to a contiguous physical extent as possible.  This helps us
to reduce cow-related fragmentation to manageable levels, which is
necessary to avoid ENOMEM problems with the current incore extent tree.

Reducing fragmentation also helps us avoid problems seen on some other
filesystem where reflinking of a 64G root image takes minutes after a
couple of weeks of normal operations because the average extent size is
now 2 blocks.

(By contrast we're still averaging ~800 blocks per extent.)

> It looks like speculative preallocation for dio is at least one strange
> side effect that can result from this...

Christoph separated the delalloc reservation into separate functions for
the data fork and the CoW fork.  xfs_file_iomap_begin_delay() is for the
data fork (and does speculative prealloc), whereas
__xfs_reflink_reserve_cow() is for the CoW fork and doesn't know about
speculative prealloc.

> > +
> > +	if (skipped) {
> > +		*offset_fsb = next_fsb;
> > +		goto out_trans_cancel;
> > +	}
> > +
> > +	xfs_trans_ijoin(tp, ip, 0);
> > +	error = xfs_bmapi_write(tp, ip, *offset_fsb, next_fsb - *offset_fsb,
> > +			XFS_BMAPI_COWFORK, &first_block,
> > +			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
> > +			&imap, &nimaps, &dfops);
> > +	if (error)
> > +		goto out_trans_cancel;
> 
> Should we be using unwritten extents (BMAPI_PREALLOC) to avoid stale
> data exposure similar to traditional direct write (or is the cow fork
> extent never accessible until it is remapped)?

Correct.  CoW fork extents are not accessible until after remapping.

--D

> 
> Brian
> 
> > +
> > +	/* We might not have been able to map the whole delalloc extent */
> > +	*offset_fsb = min(*offset_fsb + imap.br_blockcount, next_fsb);
> > +
> > +	error = xfs_defer_finish(&tp, &dfops, NULL);
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> > +	error = xfs_trans_commit(tp);
> > +
> > +out_unlock:
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	return error;
> > +out_trans_cancel:
> > +	xfs_defer_cancel(&dfops);
> > +	xfs_trans_cancel(tp);
> > +	goto out_unlock;
> > +}
> > +
> > +/* Allocate all CoW reservations covering a part of a file. */
> > +int
> > +xfs_reflink_allocate_cow_range(
> > +	struct xfs_inode	*ip,
> > +	xfs_off_t		offset,
> > +	xfs_off_t		count)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
> > +	int			error;
> > +
> > +	ASSERT(xfs_is_reflink_inode(ip));
> > +
> > +	trace_xfs_reflink_allocate_cow_range(ip, offset, count);
> > +
> > +	/*
> > +	 * Make sure that the dquots are there.
> > +	 */
> > +	error = xfs_qm_dqattach(ip, 0);
> > +	if (error)
> > +		return error;
> > +
> > +	while (offset_fsb < end_fsb) {
> > +		error = __xfs_reflink_allocate_cow(ip, &offset_fsb, end_fsb);
> > +		if (error) {
> > +			trace_xfs_reflink_allocate_cow_range_error(ip, error,
> > +					_RET_IP_);
> > +			break;
> > +		}
> > +	}
> > +
> > +	return error;
> > +}
> > +
> >  /*
> >   * Find the CoW reservation (and whether or not it needs block allocation)
> >   * for a given byte offset of a file.
> > diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> > index bffa4be..c0c989a 100644
> > --- a/fs/xfs/xfs_reflink.h
> > +++ b/fs/xfs/xfs_reflink.h
> > @@ -28,6 +28,8 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
> >  
> >  extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
> >  		xfs_off_t offset, xfs_off_t count);
> > +extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
> > +		xfs_off_t offset, xfs_off_t count);
> >  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> >  		struct xfs_bmbt_irec *imap, bool *need_alloc);
> >  extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 7612096..8e89223 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3332,7 +3332,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
> >  
> >  DEFINE_RW_EVENT(xfs_reflink_reserve_cow_range);
> >  DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
> > -DEFINE_INODE_IREC_EVENT(xfs_reflink_allocate_cow_extent);
> >  
> >  DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
> >  DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
