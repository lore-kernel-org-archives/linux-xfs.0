Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48016 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933113AbeGCWFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 18:05:25 -0400
Date: Tue, 3 Jul 2018 15:05:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/22] xfs: add support for sub-pagesize writeback
 without buffer_heads
Message-ID: <20180703220501.GX32415@magnolia>
References: <20180702145813.22496-1-hch@lst.de>
 <20180702145813.22496-22-hch@lst.de>
 <20180703123603.GB22789@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703123603.GB22789@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jul 03, 2018 at 08:36:04AM -0400, Brian Foster wrote:
> On Mon, Jul 02, 2018 at 08:58:12AM -0600, Christoph Hellwig wrote:
> > Switch to using the iomap_page structure for checking sub-page uptodate
> > status and track sub-page I/O completion status, and remove large
> > quantities of boilerplate code working around buffer heads.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_aops.c  | 492 ++++++---------------------------------------
> >  fs/xfs/xfs_buf.h   |   1 -
> >  fs/xfs/xfs_iomap.c |   3 -
> >  fs/xfs/xfs_super.c |   2 +-
> >  fs/xfs/xfs_trace.h |  18 +-
> >  5 files changed, 61 insertions(+), 455 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 0058f9893705..bae88ac1101d 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> ...
> > @@ -85,67 +63,17 @@ xfs_finish_page_writeback(
> >  	struct bio_vec		*bvec,
> >  	int			error)
> >  {
> > +	struct iomap_page	*iop = to_iomap_page(bvec->bv_page);
> > +
> >  	if (error) {
> >  		SetPageError(bvec->bv_page);
> >  		mapping_set_error(inode->i_mapping, -EIO);
> >  	}
> > -	end_page_writeback(bvec->bv_page);
> > -}
> >  
> > -/*
> > - * We're now finished for good with this page.  Update the page state via the
> > - * associated buffer_heads, paying attention to the start and end offsets that
> > - * we need to process on the page.
> > - *
> > - * Note that we open code the action in end_buffer_async_write here so that we
> > - * only have to iterate over the buffers attached to the page once.  This is not
> > - * only more efficient, but also ensures that we only calls end_page_writeback
> > - * at the end of the iteration, and thus avoids the pitfall of having the page
> > - * and buffers potentially freed after every call to end_buffer_async_write.
> > - */
> > -static void
> > -xfs_finish_buffer_writeback(
> > -	struct inode		*inode,
> > -	struct bio_vec		*bvec,
> > -	int			error)
> > -{
> > -	struct buffer_head	*head = page_buffers(bvec->bv_page), *bh = head;
> > -	bool			busy = false;
> > -	unsigned int		off = 0;
> > -	unsigned long		flags;
> > -
> > -	ASSERT(bvec->bv_offset < PAGE_SIZE);
> > -	ASSERT((bvec->bv_offset & (i_blocksize(inode) - 1)) == 0);
> > -	ASSERT(bvec->bv_offset + bvec->bv_len <= PAGE_SIZE);
> > -	ASSERT((bvec->bv_len & (i_blocksize(inode) - 1)) == 0);
> > -
> > -	local_irq_save(flags);
> > -	bit_spin_lock(BH_Uptodate_Lock, &head->b_state);
> > -	do {
> > -		if (off >= bvec->bv_offset &&
> > -		    off < bvec->bv_offset + bvec->bv_len) {
> > -			ASSERT(buffer_async_write(bh));
> > -			ASSERT(bh->b_end_io == NULL);
> > -
> > -			if (error) {
> > -				mark_buffer_write_io_error(bh);
> > -				clear_buffer_uptodate(bh);
> 
> So the buffer completion code clears the uptodate status of the buffer
> on error. I assume that means the next read would replace the data we
> failed to write with whatever was previously on disk.

I've always found it a little weird that we basically throw away the
newer page contents on error, but we shouldn't be changing the behavior
in quite so subtle a way.

Also, since we clear uptodate the next (buffered) write will reread the
page contents.

> I guess it's debatable whether that is the right thing to do in
> general, but that seems like a higher level issue nonetheless (i.e., I
> don't think we'd ever retry the writepage either?).

AFAIK we don't retry failed writes unless userspace dirties the page.

> So is there any reason not to do the analogous in the iomap completion
> code?

Will let Christoph answer that one.

--D

> Otherwise the rest looks fine to me.
> 
> Brian
> 
> > -				SetPageError(bvec->bv_page);
> > -			} else {
> > -				set_buffer_uptodate(bh);
> > -			}
> > -			clear_buffer_async_write(bh);
> > -			unlock_buffer(bh);
> > -		} else if (buffer_async_write(bh)) {
> > -			ASSERT(buffer_locked(bh));
> > -			busy = true;
> > -		}
> > -		off += bh->b_size;
> > -	} while ((bh = bh->b_this_page) != head);
> > -	bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
> > -	local_irq_restore(flags);
> > +	ASSERT(iop || i_blocksize(inode) == PAGE_SIZE);
> > +	ASSERT(!iop || atomic_read(&iop->write_count) > 0);
> >  
> > -	if (!busy)
> > +	if (!iop || atomic_dec_and_test(&iop->write_count))
> >  		end_page_writeback(bvec->bv_page);
> >  }
> >  
> > @@ -179,12 +107,8 @@ xfs_destroy_ioend(
> >  			next = bio->bi_private;
> >  
> >  		/* walk each page on bio, ending page IO on them */
> > -		bio_for_each_segment_all(bvec, bio, i) {
> > -			if (page_has_buffers(bvec->bv_page))
> > -				xfs_finish_buffer_writeback(inode, bvec, error);
> > -			else
> > -				xfs_finish_page_writeback(inode, bvec, error);
> > -		}
> > +		bio_for_each_segment_all(bvec, bio, i)
> > +			xfs_finish_page_writeback(inode, bvec, error);
> >  		bio_put(bio);
> >  	}
> >  
> > @@ -638,6 +562,7 @@ xfs_add_to_ioend(
> >  	struct inode		*inode,
> >  	xfs_off_t		offset,
> >  	struct page		*page,
> > +	struct iomap_page	*iop,
> >  	struct xfs_writepage_ctx *wpc,
> >  	struct writeback_control *wbc,
> >  	struct list_head	*iolist)
> > @@ -661,100 +586,37 @@ xfs_add_to_ioend(
> >  				bdev, sector);
> >  	}
> >  
> > -	/*
> > -	 * If the block doesn't fit into the bio we need to allocate a new
> > -	 * one.  This shouldn't happen more than once for a given block.
> > -	 */
> > -	while (bio_add_page(wpc->ioend->io_bio, page, len, poff) != len)
> > -		xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
> > +	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff)) {
> > +		if (iop)
> > +			atomic_inc(&iop->write_count);
> > +		if (bio_full(wpc->ioend->io_bio))
> > +			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
> > +		__bio_add_page(wpc->ioend->io_bio, page, len, poff);
> > +	}
> >  
> >  	wpc->ioend->io_size += len;
> >  }
> >  
> > -STATIC void
> > -xfs_map_buffer(
> > -	struct inode		*inode,
> > -	struct buffer_head	*bh,
> > -	struct xfs_bmbt_irec	*imap,
> > -	xfs_off_t		offset)
> > -{
> > -	sector_t		bn;
> > -	struct xfs_mount	*m = XFS_I(inode)->i_mount;
> > -	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap->br_startoff);
> > -	xfs_daddr_t		iomap_bn = xfs_fsb_to_db(XFS_I(inode), imap->br_startblock);
> > -
> > -	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
> > -	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
> > -
> > -	bn = (iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
> > -	      ((offset - iomap_offset) >> inode->i_blkbits);
> > -
> > -	ASSERT(bn || XFS_IS_REALTIME_INODE(XFS_I(inode)));
> > -
> > -	bh->b_blocknr = bn;
> > -	set_buffer_mapped(bh);
> > -}
> > -
> > -STATIC void
> > -xfs_map_at_offset(
> > -	struct inode		*inode,
> > -	struct buffer_head	*bh,
> > -	struct xfs_bmbt_irec	*imap,
> > -	xfs_off_t		offset)
> > -{
> > -	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
> > -	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
> > -
> > -	lock_buffer(bh);
> > -	xfs_map_buffer(inode, bh, imap, offset);
> > -	set_buffer_mapped(bh);
> > -	clear_buffer_delay(bh);
> > -	clear_buffer_unwritten(bh);
> > -
> > -	/*
> > -	 * If this is a realtime file, data may be on a different device.
> > -	 * to that pointed to from the buffer_head b_bdev currently. We can't
> > -	 * trust that the bufferhead has a already been mapped correctly, so
> > -	 * set the bdev now.
> > -	 */
> > -	bh->b_bdev = xfs_find_bdev_for_inode(inode);
> > -	bh->b_end_io = NULL;
> > -	set_buffer_async_write(bh);
> > -	set_buffer_uptodate(bh);
> > -	clear_buffer_dirty(bh);
> > -}
> > -
> >  STATIC void
> >  xfs_vm_invalidatepage(
> >  	struct page		*page,
> >  	unsigned int		offset,
> >  	unsigned int		length)
> >  {
> > -	trace_xfs_invalidatepage(page->mapping->host, page, offset,
> > -				 length);
> > -
> > -	/*
> > -	 * If we are invalidating the entire page, clear the dirty state from it
> > -	 * so that we can check for attempts to release dirty cached pages in
> > -	 * xfs_vm_releasepage().
> > -	 */
> > -	if (offset == 0 && length >= PAGE_SIZE)
> > -		cancel_dirty_page(page);
> > -	block_invalidatepage(page, offset, length);
> > +	trace_xfs_invalidatepage(page->mapping->host, page, offset, length);
> > +	iomap_invalidatepage(page, offset, length);
> >  }
> >  
> >  /*
> > - * If the page has delalloc buffers on it, we need to punch them out before we
> > - * invalidate the page. If we don't, we leave a stale delalloc mapping on the
> > - * inode that can trip a BUG() in xfs_get_blocks() later on if a direct IO read
> > - * is done on that same region - the delalloc extent is returned when none is
> > - * supposed to be there.
> > + * If the page has delalloc blocks on it, we need to punch them out before we
> > + * invalidate the page.  If we don't, we leave a stale delalloc mapping on the
> > + * inode that can trip up a later direct I/O read operation on the same region.
> >   *
> > - * We prevent this by truncating away the delalloc regions on the page before
> > - * invalidating it. Because they are delalloc, we can do this without needing a
> > - * transaction. Indeed - if we get ENOSPC errors, we have to be able to do this
> > - * truncation without a transaction as there is no space left for block
> > - * reservation (typically why we see a ENOSPC in writeback).
> > + * We prevent this by truncating away the delalloc regions on the page.  Because
> > + * they are delalloc, we can do this without needing a transaction. Indeed - if
> > + * we get ENOSPC errors, we have to be able to do this truncation without a
> > + * transaction as there is no space left for block reservation (typically why we
> > + * see a ENOSPC in writeback).
> >   */
> >  STATIC void
> >  xfs_aops_discard_page(
> > @@ -786,7 +648,7 @@ xfs_aops_discard_page(
> >   * We implement an immediate ioend submission policy here to avoid needing to
> >   * chain multiple ioends and hence nest mempool allocations which can violate
> >   * forward progress guarantees we need to provide. The current ioend we are
> > - * adding buffers to is cached on the writepage context, and if the new buffer
> > + * adding blocks to is cached on the writepage context, and if the new block
> >   * does not append to the cached ioend it will create a new ioend and cache that
> >   * instead.
> >   *
> > @@ -807,54 +669,33 @@ xfs_writepage_map(
> >  	uint64_t		end_offset)
> >  {
> >  	LIST_HEAD(submit_list);
> > +	struct iomap_page	*iop = to_iomap_page(page);
> > +	unsigned		len = i_blocksize(inode);
> >  	struct xfs_ioend	*ioend, *next;
> > -	struct buffer_head	*bh = NULL;
> > -	ssize_t			len = i_blocksize(inode);
> >  	uint64_t		file_offset;	/* file offset of page */
> > -	unsigned		poffset;	/* offset into page */
> > -	int			error = 0;
> > -	int			count = 0;
> > +	int			error = 0, count = 0, i;
> >  
> > -	if (page_has_buffers(page))
> > -		bh = page_buffers(page);
> > +	ASSERT(iop || i_blocksize(inode) == PAGE_SIZE);
> > +	ASSERT(!iop || atomic_read(&iop->write_count) == 0);
> >  
> >  	/*
> > -	 * Walk the blocks on the page, and if we run off the end of the current
> > -	 * map or find the current map invalid, grab a new one.  We only use
> > -	 * bufferheads here to check per-block state - they no longer control
> > -	 * the iteration through the page. This allows us to replace the
> > -	 * bufferhead with some other state tracking mechanism in future.
> > +	 * Walk through the page to find areas to write back. If we run off the
> > +	 * end of the current map or find the current map invalid, grab a new
> > +	 * one.
> >  	 */
> > -	for (poffset = 0, file_offset = page_offset(page);
> > -	     poffset < PAGE_SIZE;
> > -	     poffset += len, file_offset += len) {
> > -		/* past the range we are writing, so nothing more to write. */
> > -		if (file_offset >= end_offset)
> > -			break;
> > -
> > -		if (bh && !buffer_uptodate(bh)) {
> > -			if (PageUptodate(page))
> > -				ASSERT(buffer_mapped(bh));
> > -			bh = bh->b_this_page;
> > +	for (i = 0, file_offset = page_offset(page);
> > +	     i < (PAGE_SIZE >> inode->i_blkbits) && file_offset < end_offset;
> > +	     i++, file_offset += len) {
> > +		if (iop && !test_bit(i, iop->uptodate))
> >  			continue;
> > -		}
> >  
> >  		error = xfs_map_blocks(wpc, inode, file_offset);
> >  		if (error)
> >  			break;
> > -
> > -		if (wpc->io_type == XFS_IO_HOLE) {
> > -			if (bh)
> > -				bh = bh->b_this_page;
> > +		if (wpc->io_type == XFS_IO_HOLE)
> >  			continue;
> > -		}
> > -
> > -		if (bh) {
> > -			xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
> > -			bh = bh->b_this_page;
> > -		}
> > -		xfs_add_to_ioend(inode, file_offset, page, wpc, wbc,
> > -				&submit_list);
> > +		xfs_add_to_ioend(inode, file_offset, page, iop, wpc, wbc,
> > +				 &submit_list);
> >  		count++;
> >  	}
> >  
> > @@ -863,21 +704,18 @@ xfs_writepage_map(
> >  	ASSERT(!PageWriteback(page));
> >  
> >  	/*
> > -	 * On error, we have to fail the ioend here because we have locked
> > -	 * buffers in the ioend. If we don't do this, we'll deadlock
> > -	 * invalidating the page as that tries to lock the buffers on the page.
> > -	 * Also, because we may have set pages under writeback, we have to make
> > -	 * sure we run IO completion to mark the error state of the IO
> > -	 * appropriately, so we can't cancel the ioend directly here. That means
> > -	 * we have to mark this page as under writeback if we included any
> > -	 * buffers from it in the ioend chain so that completion treats it
> > -	 * correctly.
> > +	 * On error, we have to fail the ioend here because we may have set
> > +	 * pages under writeback, we have to make sure we run IO completion to
> > +	 * mark the error state of the IO appropriately, so we can't cancel the
> > +	 * ioend directly here.  That means we have to mark this page as under
> > +	 * writeback if we included any blocks from it in the ioend chain so
> > +	 * that completion treats it correctly.
> >  	 *
> >  	 * If we didn't include the page in the ioend, the on error we can
> >  	 * simply discard and unlock it as there are no other users of the page
> > -	 * or it's buffers right now. The caller will still need to trigger
> > -	 * submission of outstanding ioends on the writepage context so they are
> > -	 * treated correctly on error.
> > +	 * now.  The caller will still need to trigger submission of outstanding
> > +	 * ioends on the writepage context so they are treated correctly on
> > +	 * error.
> >  	 */
> >  	if (unlikely(error)) {
> >  		if (!count) {
> > @@ -918,8 +756,8 @@ xfs_writepage_map(
> >  	}
> >  
> >  	/*
> > -	 * We can end up here with no error and nothing to write if we race with
> > -	 * a partial page truncate on a sub-page block sized filesystem.
> > +	 * We can end up here with no error and nothing to write only if we race
> > +	 * with a partial page truncate on a sub-page block sized filesystem.
> >  	 */
> >  	if (!count)
> >  		end_page_writeback(page);
> > @@ -934,7 +772,6 @@ xfs_writepage_map(
> >   * For delalloc space on the page we need to allocate space and flush it.
> >   * For unwritten space on the page we need to start the conversion to
> >   * regular allocated space.
> > - * For any other dirty buffer heads on the page we should flush them.
> >   */
> >  STATIC int
> >  xfs_do_writepage(
> > @@ -1088,166 +925,13 @@ xfs_dax_writepages(
> >  			xfs_find_bdev_for_inode(mapping->host), wbc);
> >  }
> >  
> > -/*
> > - * Called to move a page into cleanable state - and from there
> > - * to be released. The page should already be clean. We always
> > - * have buffer heads in this call.
> > - *
> > - * Returns 1 if the page is ok to release, 0 otherwise.
> > - */
> >  STATIC int
> >  xfs_vm_releasepage(
> >  	struct page		*page,
> >  	gfp_t			gfp_mask)
> >  {
> > -	int			delalloc, unwritten;
> > -
> >  	trace_xfs_releasepage(page->mapping->host, page, 0, 0);
> > -
> > -	/*
> > -	 * mm accommodates an old ext3 case where clean pages might not have had
> > -	 * the dirty bit cleared. Thus, it can send actual dirty pages to
> > -	 * ->releasepage() via shrink_active_list(). Conversely,
> > -	 * block_invalidatepage() can send pages that are still marked dirty but
> > -	 * otherwise have invalidated buffers.
> > -	 *
> > -	 * We want to release the latter to avoid unnecessary buildup of the
> > -	 * LRU, so xfs_vm_invalidatepage() clears the page dirty flag on pages
> > -	 * that are entirely invalidated and need to be released.  Hence the
> > -	 * only time we should get dirty pages here is through
> > -	 * shrink_active_list() and so we can simply skip those now.
> > -	 *
> > -	 * warn if we've left any lingering delalloc/unwritten buffers on clean
> > -	 * or invalidated pages we are about to release.
> > -	 */
> > -	if (PageDirty(page))
> > -		return 0;
> > -
> > -	xfs_count_page_state(page, &delalloc, &unwritten);
> > -
> > -	if (WARN_ON_ONCE(delalloc))
> > -		return 0;
> > -	if (WARN_ON_ONCE(unwritten))
> > -		return 0;
> > -
> > -	return try_to_free_buffers(page);
> > -}
> > -
> > -/*
> > - * If this is O_DIRECT or the mpage code calling tell them how large the mapping
> > - * is, so that we can avoid repeated get_blocks calls.
> > - *
> > - * If the mapping spans EOF, then we have to break the mapping up as the mapping
> > - * for blocks beyond EOF must be marked new so that sub block regions can be
> > - * correctly zeroed. We can't do this for mappings within EOF unless the mapping
> > - * was just allocated or is unwritten, otherwise the callers would overwrite
> > - * existing data with zeros. Hence we have to split the mapping into a range up
> > - * to and including EOF, and a second mapping for beyond EOF.
> > - */
> > -static void
> > -xfs_map_trim_size(
> > -	struct inode		*inode,
> > -	sector_t		iblock,
> > -	struct buffer_head	*bh_result,
> > -	struct xfs_bmbt_irec	*imap,
> > -	xfs_off_t		offset,
> > -	ssize_t			size)
> > -{
> > -	xfs_off_t		mapping_size;
> > -
> > -	mapping_size = imap->br_startoff + imap->br_blockcount - iblock;
> > -	mapping_size <<= inode->i_blkbits;
> > -
> > -	ASSERT(mapping_size > 0);
> > -	if (mapping_size > size)
> > -		mapping_size = size;
> > -	if (offset < i_size_read(inode) &&
> > -	    (xfs_ufsize_t)offset + mapping_size >= i_size_read(inode)) {
> > -		/* limit mapping to block that spans EOF */
> > -		mapping_size = roundup_64(i_size_read(inode) - offset,
> > -					  i_blocksize(inode));
> > -	}
> > -	if (mapping_size > LONG_MAX)
> > -		mapping_size = LONG_MAX;
> > -
> > -	bh_result->b_size = mapping_size;
> > -}
> > -
> > -static int
> > -xfs_get_blocks(
> > -	struct inode		*inode,
> > -	sector_t		iblock,
> > -	struct buffer_head	*bh_result,
> > -	int			create)
> > -{
> > -	struct xfs_inode	*ip = XFS_I(inode);
> > -	struct xfs_mount	*mp = ip->i_mount;
> > -	xfs_fileoff_t		offset_fsb, end_fsb;
> > -	int			error = 0;
> > -	int			lockmode = 0;
> > -	struct xfs_bmbt_irec	imap;
> > -	int			nimaps = 1;
> > -	xfs_off_t		offset;
> > -	ssize_t			size;
> > -
> > -	BUG_ON(create);
> > -
> > -	if (XFS_FORCED_SHUTDOWN(mp))
> > -		return -EIO;
> > -
> > -	offset = (xfs_off_t)iblock << inode->i_blkbits;
> > -	ASSERT(bh_result->b_size >= i_blocksize(inode));
> > -	size = bh_result->b_size;
> > -
> > -	if (offset >= i_size_read(inode))
> > -		return 0;
> > -
> > -	/*
> > -	 * Direct I/O is usually done on preallocated files, so try getting
> > -	 * a block mapping without an exclusive lock first.
> > -	 */
> > -	lockmode = xfs_ilock_data_map_shared(ip);
> > -
> > -	ASSERT(offset <= mp->m_super->s_maxbytes);
> > -	if (offset > mp->m_super->s_maxbytes - size)
> > -		size = mp->m_super->s_maxbytes - offset;
> > -	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
> > -	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > -
> > -	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
> > -			&nimaps, 0);
> > -	if (error)
> > -		goto out_unlock;
> > -	if (!nimaps) {
> > -		trace_xfs_get_blocks_notfound(ip, offset, size);
> > -		goto out_unlock;
> > -	}
> > -
> > -	trace_xfs_get_blocks_found(ip, offset, size,
> > -		imap.br_state == XFS_EXT_UNWRITTEN ?
> > -			XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, &imap);
> > -	xfs_iunlock(ip, lockmode);
> > -
> > -	/* trim mapping down to size requested */
> > -	xfs_map_trim_size(inode, iblock, bh_result, &imap, offset, size);
> > -
> > -	/*
> > -	 * For unwritten extents do not report a disk address in the buffered
> > -	 * read case (treat as if we're reading into a hole).
> > -	 */
> > -	if (xfs_bmap_is_real_extent(&imap))
> > -		xfs_map_buffer(inode, bh_result, &imap, offset);
> > -
> > -	/*
> > -	 * If this is a realtime file, data may be on a different device.
> > -	 * to that pointed to from the buffer_head b_bdev currently.
> > -	 */
> > -	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
> > -	return 0;
> > -
> > -out_unlock:
> > -	xfs_iunlock(ip, lockmode);
> > -	return error;
> > +	return iomap_releasepage(page, gfp_mask);
> >  }
> >  
> >  STATIC sector_t
> > @@ -1279,9 +963,7 @@ xfs_vm_readpage(
> >  	struct page		*page)
> >  {
> >  	trace_xfs_vm_readpage(page->mapping->host, 1);
> > -	if (i_blocksize(page->mapping->host) == PAGE_SIZE)
> > -		return iomap_readpage(page, &xfs_iomap_ops);
> > -	return mpage_readpage(page, xfs_get_blocks);
> > +	return iomap_readpage(page, &xfs_iomap_ops);
> >  }
> >  
> >  STATIC int
> > @@ -1292,65 +974,7 @@ xfs_vm_readpages(
> >  	unsigned		nr_pages)
> >  {
> >  	trace_xfs_vm_readpages(mapping->host, nr_pages);
> > -	if (i_blocksize(mapping->host) == PAGE_SIZE)
> > -		return iomap_readpages(mapping, pages, nr_pages, &xfs_iomap_ops);
> > -	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
> > -}
> > -
> > -/*
> > - * This is basically a copy of __set_page_dirty_buffers() with one
> > - * small tweak: buffers beyond EOF do not get marked dirty. If we mark them
> > - * dirty, we'll never be able to clean them because we don't write buffers
> > - * beyond EOF, and that means we can't invalidate pages that span EOF
> > - * that have been marked dirty. Further, the dirty state can leak into
> > - * the file interior if the file is extended, resulting in all sorts of
> > - * bad things happening as the state does not match the underlying data.
> > - *
> > - * XXX: this really indicates that bufferheads in XFS need to die. Warts like
> > - * this only exist because of bufferheads and how the generic code manages them.
> > - */
> > -STATIC int
> > -xfs_vm_set_page_dirty(
> > -	struct page		*page)
> > -{
> > -	struct address_space	*mapping = page->mapping;
> > -	struct inode		*inode = mapping->host;
> > -	loff_t			end_offset;
> > -	loff_t			offset;
> > -	int			newly_dirty;
> > -
> > -	if (unlikely(!mapping))
> > -		return !TestSetPageDirty(page);
> > -
> > -	end_offset = i_size_read(inode);
> > -	offset = page_offset(page);
> > -
> > -	spin_lock(&mapping->private_lock);
> > -	if (page_has_buffers(page)) {
> > -		struct buffer_head *head = page_buffers(page);
> > -		struct buffer_head *bh = head;
> > -
> > -		do {
> > -			if (offset < end_offset)
> > -				set_buffer_dirty(bh);
> > -			bh = bh->b_this_page;
> > -			offset += i_blocksize(inode);
> > -		} while (bh != head);
> > -	}
> > -	/*
> > -	 * Lock out page->mem_cgroup migration to keep PageDirty
> > -	 * synchronized with per-memcg dirty page counters.
> > -	 */
> > -	lock_page_memcg(page);
> > -	newly_dirty = !TestSetPageDirty(page);
> > -	spin_unlock(&mapping->private_lock);
> > -
> > -	if (newly_dirty)
> > -		__set_page_dirty(page, mapping, 1);
> > -	unlock_page_memcg(page);
> > -	if (newly_dirty)
> > -		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> > -	return newly_dirty;
> > +	return iomap_readpages(mapping, pages, nr_pages, &xfs_iomap_ops);
> >  }
> >  
> >  static int
> > @@ -1368,13 +992,13 @@ const struct address_space_operations xfs_address_space_operations = {
> >  	.readpages		= xfs_vm_readpages,
> >  	.writepage		= xfs_vm_writepage,
> >  	.writepages		= xfs_vm_writepages,
> > -	.set_page_dirty		= xfs_vm_set_page_dirty,
> > +	.set_page_dirty		= iomap_set_page_dirty,
> >  	.releasepage		= xfs_vm_releasepage,
> >  	.invalidatepage		= xfs_vm_invalidatepage,
> >  	.bmap			= xfs_vm_bmap,
> >  	.direct_IO		= noop_direct_IO,
> > -	.migratepage		= buffer_migrate_page,
> > -	.is_partially_uptodate  = block_is_partially_uptodate,
> > +	.migratepage		= iomap_migrate_page,
> > +	.is_partially_uptodate  = iomap_is_partially_uptodate,
> >  	.error_remove_page	= generic_error_remove_page,
> >  	.swap_activate		= xfs_iomap_swapfile_activate,
> >  };
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index d24dbd4dac39..6ddf1907fc7a 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -12,7 +12,6 @@
> >  #include <linux/mm.h>
> >  #include <linux/fs.h>
> >  #include <linux/dax.h>
> > -#include <linux/buffer_head.h>
> >  #include <linux/uio.h>
> >  #include <linux/list_lru.h>
> >  
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 7fe42a126ec1..778b8c850de3 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1032,9 +1032,6 @@ xfs_file_iomap_begin(
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return -EIO;
> >  
> > -	if (i_blocksize(inode) < PAGE_SIZE)
> > -		iomap->flags |= IOMAP_F_BUFFER_HEAD;
> > -
> >  	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
> >  			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
> >  		/* Reserve delalloc blocks for regular writeback. */
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 9d791f158dfe..f9f8dc490d3d 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1860,7 +1860,7 @@ MODULE_ALIAS_FS("xfs");
> >  STATIC int __init
> >  xfs_init_zones(void)
> >  {
> > -	if (bioset_init(&xfs_ioend_bioset, 4 * MAX_BUF_PER_PAGE,
> > +	if (bioset_init(&xfs_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> >  			offsetof(struct xfs_ioend, io_inline_bio),
> >  			BIOSET_NEED_BVECS))
> >  		goto out;
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 1af123df19b5..7f4c7071e7ed 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1153,33 +1153,23 @@ DECLARE_EVENT_CLASS(xfs_page_class,
> >  		__field(loff_t, size)
> >  		__field(unsigned long, offset)
> >  		__field(unsigned int, length)
> > -		__field(int, delalloc)
> > -		__field(int, unwritten)
> >  	),
> >  	TP_fast_assign(
> > -		int delalloc = -1, unwritten = -1;
> > -
> > -		if (page_has_buffers(page))
> > -			xfs_count_page_state(page, &delalloc, &unwritten);
> >  		__entry->dev = inode->i_sb->s_dev;
> >  		__entry->ino = XFS_I(inode)->i_ino;
> >  		__entry->pgoff = page_offset(page);
> >  		__entry->size = i_size_read(inode);
> >  		__entry->offset = off;
> >  		__entry->length = len;
> > -		__entry->delalloc = delalloc;
> > -		__entry->unwritten = unwritten;
> >  	),
> >  	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
> > -		  "length %x delalloc %d unwritten %d",
> > +		  "length %x",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  __entry->ino,
> >  		  __entry->pgoff,
> >  		  __entry->size,
> >  		  __entry->offset,
> > -		  __entry->length,
> > -		  __entry->delalloc,
> > -		  __entry->unwritten)
> > +		  __entry->length)
> >  )
> >  
> >  #define DEFINE_PAGE_EVENT(name)		\
> > @@ -1263,9 +1253,6 @@ DEFINE_EVENT(xfs_imap_class, name,	\
> >  	TP_ARGS(ip, offset, count, type, irec))
> >  DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
> >  DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
> > -DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
> > -DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
> > -DEFINE_IOMAP_EVENT(xfs_get_blocks_map_direct);
> >  DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
> >  DEFINE_IOMAP_EVENT(xfs_iomap_found);
> >  
> > @@ -1304,7 +1291,6 @@ DEFINE_EVENT(xfs_simple_io_class, name,	\
> >  	TP_ARGS(ip, offset, count))
> >  DEFINE_SIMPLE_IO_EVENT(xfs_delalloc_enospc);
> >  DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
> > -DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
> >  DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
> >  DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
> >  DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
> > -- 
> > 2.18.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
