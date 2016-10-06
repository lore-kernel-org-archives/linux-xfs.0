Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751779AbcJFMUK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Oct 2016 08:20:10 -0400
Date: Thu, 6 Oct 2016 08:20:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 37/63] xfs: implement CoW for directio writes
Message-ID: <20161006122007.GA16893@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520498004.29434.11046105793006225587.stgit@birch.djwong.org>
 <20161005182709.GC4042@bfoster.bfoster>
 <20161005205542.GA3992@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161005205542.GA3992@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Oct 05, 2016 at 01:55:42PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 05, 2016 at 02:27:10PM -0400, Brian Foster wrote:
> > On Thu, Sep 29, 2016 at 08:09:40PM -0700, Darrick J. Wong wrote:
> > > For O_DIRECT writes to shared blocks, we have to CoW them just like
> > > we would with buffered writes.  For writes that are not block-aligned,
> > > just bounce them to the page cache.
> > > 
> > > For block-aligned writes, however, we can do better than that.  Use
> > > the same mechanisms that we employ for buffered CoW to set up a
> > > delalloc reservation, allocate all the blocks at once, issue the
> > > writes against the new blocks and use the same ioend functions to
> > > remap the blocks after the write.  This should be fairly performant.
> > > 
> > > Christoph discovered that xfs_reflink_allocate_cow_range may stumble
> > > over invalid entries in the extent array given that it drops the ilock
> > > but still expects the index to be stable.  Simple fixing it to a new
> > > lookup for every iteration still isn't correct given that
> > > xfs_bmapi_allocate will trigger a BUG_ON() if hitting a hole, and
> > > there is nothing preventing a xfs_bunmapi_cow call removing extents
> > > once we dropped the ilock either.
> > > 
> > > This patch duplicates the inner loop of xfs_bmapi_allocate into a
> > > helper for xfs_reflink_allocate_cow_range so that it can be done under
> > > the same ilock critical section as our CoW fork delayed allocation.
> > > The directio CoW warts will be revisited in a later patch.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > > v2: Turns out that there's no way for xfs_end_io_direct_write to know
> > > if the write completed successfully.  Therefore, do /not/ use the
> > > ioend for dio cow post-processing; instead, move it to xfs_vm_do_dio
> > > where we *can* tell if the write succeeded or not.
> > > 
> > > v3: Update the file size if we do a directio CoW across EOF.  This
> > > can happen if the last block is shared, the cowextsize hint is set,
> > > and we do a dio write past the end of the file.
> > > 
> > > v4: Christoph rewrote the allocate code to fix some concurrency
> > > problems as part of migrating the code to support iomap.
> > > ---
> > >  fs/xfs/xfs_aops.c    |   91 +++++++++++++++++++++++++++++++++++++++----
> > >  fs/xfs/xfs_file.c    |   20 ++++++++-
> > >  fs/xfs/xfs_reflink.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  fs/xfs/xfs_reflink.h |    2 +
> > >  fs/xfs/xfs_trace.h   |    1 
> > >  5 files changed, 208 insertions(+), 13 deletions(-)
> > > 
> > > 
...
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index f99d7fa..025d52f 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -38,6 +38,7 @@
> > >  #include "xfs_icache.h"
> > >  #include "xfs_pnfs.h"
> > >  #include "xfs_iomap.h"
> > > +#include "xfs_reflink.h"
> > >  
> > >  #include <linux/dcache.h>
> > >  #include <linux/falloc.h>
> > > @@ -672,6 +673,13 @@ xfs_file_dio_aio_write(
> > >  
> > >  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos);
> > >  
> > > +	/* If this is a block-aligned directio CoW, remap immediately. */
> > > +	if (xfs_is_reflink_inode(ip) && !unaligned_io) {
> > > +		ret = xfs_reflink_allocate_cow_range(ip, iocb->ki_pos, count);
> > > +		if (ret)
> > > +			goto out;
> > > +	}
> > 
> > Is the fact that we do this allocation up front rather than via
> > get_blocks() (like traditional direct write) one of the "warts" that
> > needs cleaning, or for some other reason?
> 
> "Yes". :)
> 
> We do the allocation here because we know the exact size of the IO that
> userspace is asking for, so we might as well do all the allocations
> at once instead of repeatedly calling back into the allocator for each
> shared segment that gets fed into get_blocks.  Sort of warty.
> 
> I think this could get moved to get_blocks, though TBH I've been
> wondering if all this will just get replaced with iomap as part of
> killing buffer heads.
> 

Ok, kind of nasty with all of the various paths through get_blocks(),
but hopefully that dies off with buffer heads.

> > > +
> > >  	data = *from;
> > >  	ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
> > >  			xfs_get_blocks_direct, xfs_end_io_direct_write,
...
> > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > index d913ad1..c95cdc3 100644
> > > --- a/fs/xfs/xfs_reflink.c
> > > +++ b/fs/xfs/xfs_reflink.c
...
> > > @@ -347,6 +352,102 @@ xfs_reflink_reserve_cow_range(
> > >  	return error;
> > >  }
> > >  
> > > +/* Allocate all CoW reservations covering a range of blocks in a file. */
> > > +static int
> > > +__xfs_reflink_allocate_cow(
> > > +	struct xfs_inode	*ip,
> > > +	xfs_fileoff_t		*offset_fsb,
> > > +	xfs_fileoff_t		end_fsb)
> > > +{
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	struct xfs_bmbt_irec	imap;
> > > +	struct xfs_defer_ops	dfops;
> > > +	struct xfs_trans	*tp;
> > > +	xfs_fsblock_t		first_block;
> > > +	xfs_fileoff_t		next_fsb;
> > > +	int			nimaps = 1, error;
> > > +	bool			skipped = false;
> > > +
> > > +	xfs_defer_init(&dfops, &first_block);
> > > +
> > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
> > > +			XFS_TRANS_RESERVE, &tp);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > +
> > > +	next_fsb = *offset_fsb;
> > > +	error = __xfs_reflink_reserve_cow(ip, &next_fsb, end_fsb, &skipped);
> > > +	if (error)
> > > +		goto out_trans_cancel;
> > 
> > Do we really need to do the delayed allocation that results from this?
> > Couldn't we factor out the shared extent walking that allows us to just
> > perform the real allocations below?
> 
> The delayed reservation -> allocation two-step is necessary to create
> replacement that are aligned to the CoW extent size hint.  This is
> important for aligning extents in the same way as the regular extent
> size hint, and critical for detecting random writes and landing them all
> in as close to a contiguous physical extent as possible.  This helps us
> to reduce cow-related fragmentation to manageable levels, which is
> necessary to avoid ENOMEM problems with the current incore extent tree.
> 

The cow extent size hint thing makes sense, but I don't see why we need
to do delayed allocation to incorporate it. Can we not accomodate a cow
extent size hint for a real allocation in the cow fork the same way a
direct write accomodates a traditional extent size hint in the data
fork? In fact, we've had logic for a while now that explicitly avoids
delayed allocation when a traditional extent size hint is set.

> Reducing fragmentation also helps us avoid problems seen on some other
> filesystem where reflinking of a 64G root image takes minutes after a
> couple of weeks of normal operations because the average extent size is
> now 2 blocks.
> 
> (By contrast we're still averaging ~800 blocks per extent.)
> 
> > It looks like speculative preallocation for dio is at least one strange
> > side effect that can result from this...
> 
> Christoph separated the delalloc reservation into separate functions for
> the data fork and the CoW fork.  xfs_file_iomap_begin_delay() is for the
> data fork (and does speculative prealloc), whereas
> __xfs_reflink_reserve_cow() is for the CoW fork and doesn't know about
> speculative prealloc.
> 

Ah, right. Then there's a bit of boilerplate code in
__xfs_reflink_reserve_cow() associated with 'orig_end_fsb' that can be
removed.

> > > +
> > > +	if (skipped) {
> > > +		*offset_fsb = next_fsb;
> > > +		goto out_trans_cancel;
> > > +	}
> > > +
> > > +	xfs_trans_ijoin(tp, ip, 0);
> > > +	error = xfs_bmapi_write(tp, ip, *offset_fsb, next_fsb - *offset_fsb,
> > > +			XFS_BMAPI_COWFORK, &first_block,
> > > +			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
> > > +			&imap, &nimaps, &dfops);
> > > +	if (error)
> > > +		goto out_trans_cancel;
> > 
> > Should we be using unwritten extents (BMAPI_PREALLOC) to avoid stale
> > data exposure similar to traditional direct write (or is the cow fork
> > extent never accessible until it is remapped)?
> 
> Correct.  CoW fork extents are not accessible until after remapping.
> 

Got it, thanks.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > +
> > > +	/* We might not have been able to map the whole delalloc extent */
> > > +	*offset_fsb = min(*offset_fsb + imap.br_blockcount, next_fsb);
> > > +
> > > +	error = xfs_defer_finish(&tp, &dfops, NULL);
> > > +	if (error)
> > > +		goto out_trans_cancel;
> > > +
> > > +	error = xfs_trans_commit(tp);
> > > +
> > > +out_unlock:
> > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > +	return error;
> > > +out_trans_cancel:
> > > +	xfs_defer_cancel(&dfops);
> > > +	xfs_trans_cancel(tp);
> > > +	goto out_unlock;
> > > +}
> > > +
> > > +/* Allocate all CoW reservations covering a part of a file. */
> > > +int
> > > +xfs_reflink_allocate_cow_range(
> > > +	struct xfs_inode	*ip,
> > > +	xfs_off_t		offset,
> > > +	xfs_off_t		count)
> > > +{
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > > +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
> > > +	int			error;
> > > +
> > > +	ASSERT(xfs_is_reflink_inode(ip));
> > > +
> > > +	trace_xfs_reflink_allocate_cow_range(ip, offset, count);
> > > +
> > > +	/*
> > > +	 * Make sure that the dquots are there.
> > > +	 */
> > > +	error = xfs_qm_dqattach(ip, 0);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	while (offset_fsb < end_fsb) {
> > > +		error = __xfs_reflink_allocate_cow(ip, &offset_fsb, end_fsb);
> > > +		if (error) {
> > > +			trace_xfs_reflink_allocate_cow_range_error(ip, error,
> > > +					_RET_IP_);
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	return error;
> > > +}
> > > +
> > >  /*
> > >   * Find the CoW reservation (and whether or not it needs block allocation)
> > >   * for a given byte offset of a file.
> > > diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> > > index bffa4be..c0c989a 100644
> > > --- a/fs/xfs/xfs_reflink.h
> > > +++ b/fs/xfs/xfs_reflink.h
> > > @@ -28,6 +28,8 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
> > >  
> > >  extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
> > >  		xfs_off_t offset, xfs_off_t count);
> > > +extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
> > > +		xfs_off_t offset, xfs_off_t count);
> > >  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> > >  		struct xfs_bmbt_irec *imap, bool *need_alloc);
> > >  extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index 7612096..8e89223 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -3332,7 +3332,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
> > >  
> > >  DEFINE_RW_EVENT(xfs_reflink_reserve_cow_range);
> > >  DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
> > > -DEFINE_INODE_IREC_EVENT(xfs_reflink_allocate_cow_extent);
> > >  
> > >  DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
> > >  DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
