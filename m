Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BGCfHc145683 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 11:12:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82389159483D
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:18:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bm6PSBENprNvY5HM for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:18:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1ON6sx-00065X-UV
	for xfs@oss.sgi.com; Fri, 11 Jun 2010 16:15:12 +0000
Message-Id: <20100611161511.791495868@bombadil.infradead.org>
Date: Fri, 11 Jun 2010 12:13:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: simplify xfs_vm_releasepage
References: <20100611161312.446670249@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-releasepage
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently the xfs releasepage implementation has code to deal with converting
delayed allocated and unwritten space.  But we never get called for those as
we always convert delayed and unwritten space when cleaning a page, or drop
the state from the buffers in block_invalidatepage.  We still keep a WARN_ON
on those cases for now, but remove all the case dealing with it, which allows
to fold xfs_page_state_convert into xfs_vm_writepage and remove the !startio
case from the whole writeback path.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-11 09:22:13.864253873 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-06-11 09:27:27.602003840 +0200
@@ -754,7 +754,6 @@ xfs_convert_page(
 	struct xfs_bmbt_irec	*imap,
 	xfs_ioend_t		**ioendp,
 	struct writeback_control *wbc,
-	int			startio,
 	int			all_bh)
 {
 	struct buffer_head	*bh, *head;
@@ -825,19 +824,14 @@ xfs_convert_page(
 			ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
 			xfs_map_at_offset(inode, bh, imap, offset);
-			if (startio) {
-				xfs_add_to_ioend(inode, bh, offset,
-						type, ioendp, done);
-			} else {
-				set_buffer_dirty(bh);
-				unlock_buffer(bh);
-				mark_buffer_dirty(bh);
-			}
+			xfs_add_to_ioend(inode, bh, offset, type,
+					 ioendp, done);
+
 			page_dirty--;
 			count++;
 		} else {
 			type = IO_NEW;
-			if (buffer_mapped(bh) && all_bh && startio) {
+			if (buffer_mapped(bh) && all_bh) {
 				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset,
 						type, ioendp, done);
@@ -852,14 +846,12 @@ xfs_convert_page(
 	if (uptodate && bh == head)
 		SetPageUptodate(page);
 
-	if (startio) {
-		if (count) {
-			wbc->nr_to_write--;
-			if (wbc->nr_to_write <= 0)
-				done = 1;
-		}
-		xfs_start_page_writeback(page, !page_dirty, count);
+	if (count) {
+		wbc->nr_to_write--;
+		if (wbc->nr_to_write <= 0)
+			done = 1;
 	}
+	xfs_start_page_writeback(page, !page_dirty, count);
 
 	return done;
  fail_unlock_page:
@@ -879,7 +871,6 @@ xfs_cluster_write(
 	struct xfs_bmbt_irec	*imap,
 	xfs_ioend_t		**ioendp,
 	struct writeback_control *wbc,
-	int			startio,
 	int			all_bh,
 	pgoff_t			tlast)
 {
@@ -895,7 +886,7 @@ xfs_cluster_write(
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			done = xfs_convert_page(inode, pvec.pages[i], tindex++,
-					imap, ioendp, wbc, startio, all_bh);
+					imap, ioendp, wbc, all_bh);
 			if (done)
 				break;
 		}
@@ -1025,51 +1016,101 @@ out_invalidate:
 }
 
 /*
- * Calling this without startio set means we are being asked to make a dirty
- * page ready for freeing it's buffers.  When called with startio set then
- * we are coming from writepage.
+ * Write out a dirty page.
  *
- * When called with startio set it is important that we write the WHOLE
- * page if possible.
- * The bh->b_state's cannot know if any of the blocks or which block for
- * that matter are dirty due to mmap writes, and therefore bh uptodate is
- * only valid if the page itself isn't completely uptodate.  Some layers
- * may clear the page dirty flag prior to calling write page, under the
- * assumption the entire page will be written out; by not writing out the
- * whole page the page can be reused before all valid dirty data is
- * written out.  Note: in the case of a page that has been dirty'd by
- * mapwrite and but partially setup by block_prepare_write the
- * bh->b_states's will not agree and only ones setup by BPW/BCW will have
- * valid state, thus the whole page must be written out thing.
+ * For delalloc space on the page we need to allocate space and flush it.
+ * For unwritten space on the page we need to start the conversion to
+ * regular allocated space.
+ * For unmapped buffer heads on the page we should allocate space if the
+ * page is uptodate.
+ * For any other dirty buffer heads on the page we should flush them.
+ *
+ * If we detect that a transaction would be required to flush the page, we
+ * have to check the process flags first, if we are already in a transaction
+ * or disk I/O during allocations is off, we need to fail the writepage and
+ * redirty the page.
+ *
+ * The bh->b_state's cannot know if any of the blocks or which block for that
+ * matter are dirty due to mmap writes, and therefore bh uptodate is only
+ * valid if the page itself isn't completely uptodate.
  */
-
 STATIC int
-xfs_page_state_convert(
-	struct inode	*inode,
-	struct page	*page,
-	struct writeback_control *wbc,
-	int		startio,
-	int		unmapped) /* also implies page uptodate */
+xfs_vm_writepage(
+	struct page		*page,
+	struct writeback_control *wbc)
 {
+	struct inode		*inode = page->mapping->host;
+	int			need_trans;
+	int			delalloc, unmapped, unwritten;
 	struct buffer_head	*bh, *head;
 	struct xfs_bmbt_irec	imap;
 	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
 	loff_t			offset;
-	unsigned long           p_offset = 0;
 	unsigned int		type;
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
 	ssize_t			size, len;
 	int			flags, err, imap_valid = 0, uptodate = 1;
-	int			page_dirty, count = 0;
-	int			trylock = 0;
-	int			all_bh = unmapped;
-
-	if (startio) {
-		if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
-			trylock |= BMAPI_TRYLOCK;
+	int			count = 0;
+	int			all_bh;
+
+	trace_xfs_writepage(inode, page, 0);
+
+	/*
+	 * Refuse to write the page out if we are called from reclaim context.
+	 *
+	 * This is primarily to avoid stack overflows when called from deep
+	 * used stacks in random callers for direct reclaim, but disabling
+	 * reclaim for kswap is a nice side-effect as kswapd causes rather
+	 * suboptimal I/O patters, too.
+	 *
+	 * This should really be done by the core VM, but until that happens
+	 * filesystems like XFS, btrfs and ext4 have to take care of this
+	 * by themselves.
+	 */
+	if (current->flags & PF_MEMALLOC)
+		goto out_fail;
+
+	/*
+	 * We need a transaction if:
+	 *  1. There are delalloc buffers on the page
+	 *  2. The page is uptodate and we have unmapped buffers
+	 *  3. The page is uptodate and we have no buffers
+	 *  4. There are unwritten buffers on the page
+	 */
+	if (!page_has_buffers(page)) {
+		unmapped = 1;
+		need_trans = 1;
+	} else {
+		xfs_count_page_state(page, &delalloc, &unmapped, &unwritten);
+		if (!PageUptodate(page))
+			unmapped = 0;
+		need_trans = delalloc + unmapped + unwritten;
 	}
 
+	/*
+	 * If we need a transaction and the process flags say
+	 * we are already in a transaction, or no IO is allowed
+	 * then mark the page dirty again and leave the page
+	 * as is.
+	 */
+	if (current_test_flags(PF_FSTRANS) && need_trans)
+		goto out_fail;
+
+	/*
+	 * Delay hooking up buffer heads until we have
+	 * made our go/no-go decision.
+	 */
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
+
+	/*
+	 * VM calculation for nr_to_write seems off.  Bump it way
+	 * up, this gets simple streaming writes zippy again.
+	 * To be reviewed again after Jens' writeback changes.
+	 */
+	wbc->nr_to_write *= 4;
+
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
 	end_index = offset >> PAGE_CACHE_SHIFT;
@@ -1077,53 +1118,27 @@ xfs_page_state_convert(
 	if (page->index >= end_index) {
 		if ((page->index >= end_index + 1) ||
 		    !(i_size_read(inode) & (PAGE_CACHE_SIZE - 1))) {
-			if (startio)
-				unlock_page(page);
+			unlock_page(page);
 			return 0;
 		}
 	}
 
-	/*
-	 * page_dirty is initially a count of buffers on the page before
-	 * EOF and is decremented as we move each into a cleanable state.
-	 *
-	 * Derivation:
-	 *
-	 * End offset is the highest offset that this page should represent.
-	 * If we are on the last page, (end_offset & (PAGE_CACHE_SIZE - 1))
-	 * will evaluate non-zero and be less than PAGE_CACHE_SIZE and
-	 * hence give us the correct page_dirty count. On any other page,
-	 * it will be zero and in that case we need page_dirty to be the
-	 * count of buffers on the page.
- 	 */
 	end_offset = min_t(unsigned long long,
 			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT, offset);
 	len = 1 << inode->i_blkbits;
-	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
-					PAGE_CACHE_SIZE);
-	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
-	page_dirty = p_offset / len;
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
 	flags = BMAPI_READ;
 	type = IO_NEW;
 
-	/* TODO: cleanup count and page_dirty */
+	all_bh = unmapped;
 
 	do {
 		if (offset >= end_offset)
 			break;
 		if (!buffer_uptodate(bh))
 			uptodate = 0;
-		if (!(PageUptodate(page) || buffer_uptodate(bh)) && !startio) {
-			/*
-			 * the iomap is actually still valid, but the ioend
-			 * isn't.  shouldn't happen too often.
-			 */
-			imap_valid = 0;
-			continue;
-		}
 
 		/*
 		 * A hole may still be marked uptodate because discard_buffer
@@ -1150,7 +1165,7 @@ xfs_page_state_convert(
 		 */
 		if (buffer_unwritten(bh) || buffer_delay(bh) ||
 		    ((buffer_uptodate(bh) || PageUptodate(page)) &&
-		     !buffer_mapped(bh) && (unmapped || startio))) {
+		     !buffer_mapped(bh))) {
 			int new_ioend = 0;
 
 			/*
@@ -1164,7 +1179,11 @@ xfs_page_state_convert(
 				flags = BMAPI_WRITE | BMAPI_IGNSTATE;
 			} else if (buffer_delay(bh)) {
 				type = IO_DELAY;
-				flags = BMAPI_ALLOCATE | trylock;
+				flags = BMAPI_ALLOCATE;
+
+				if (wbc->sync_mode == WB_SYNC_NONE &&
+				    wbc->nonblocking)
+					flags |= BMAPI_TRYLOCK;
 			} else {
 				type = IO_NEW;
 				flags = BMAPI_WRITE | BMAPI_MMAP;
@@ -1196,19 +1215,11 @@ xfs_page_state_convert(
 			}
 			if (imap_valid) {
 				xfs_map_at_offset(inode, bh, &imap, offset);
-				if (startio) {
-					xfs_add_to_ioend(inode, bh, offset,
-							type, &ioend,
-							new_ioend);
-				} else {
-					set_buffer_dirty(bh);
-					unlock_buffer(bh);
-					mark_buffer_dirty(bh);
-				}
-				page_dirty--;
+				xfs_add_to_ioend(inode, bh, offset, type,
+						 &ioend, new_ioend);
 				count++;
 			}
-		} else if (buffer_uptodate(bh) && startio) {
+		} else if (buffer_uptodate(bh)) {
 			/*
 			 * we got here because the buffer is already mapped.
 			 * That means it must already have extents allocated
@@ -1241,13 +1252,11 @@ xfs_page_state_convert(
 					all_bh = 1;
 				xfs_add_to_ioend(inode, bh, offset, type,
 						&ioend, !imap_valid);
-				page_dirty--;
 				count++;
 			} else {
 				imap_valid = 0;
 			}
-		} else if ((buffer_uptodate(bh) || PageUptodate(page)) &&
-			   (unmapped || startio)) {
+		} else if (PageUptodate(page)) {
 			imap_valid = 0;
 		}
 
@@ -1259,8 +1268,7 @@ xfs_page_state_convert(
 	if (uptodate && bh == head)
 		SetPageUptodate(page);
 
-	if (startio)
-		xfs_start_page_writeback(page, 1, count);
+	xfs_start_page_writeback(page, 1, count);
 
 	if (ioend && imap_valid) {
 		xfs_off_t		end_index;
@@ -1278,139 +1286,28 @@ xfs_page_state_convert(
 			end_index = last_index;
 
 		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
-					wbc, startio, all_bh, end_index);
+					wbc, all_bh, end_index);
 	}
 
 	if (iohead)
 		xfs_submit_ioend(wbc, iohead);
 
-	return page_dirty;
+	return 0;
 
 error:
 	if (iohead)
 		xfs_cancel_ioend(iohead);
 
-	/*
-	 * If it's delalloc and we have nowhere to put it,
-	 * throw it away, unless the lower layers told
-	 * us to try again.
-	 */
-	if (err != -EAGAIN) {
-		if (!unmapped)
-			xfs_aops_discard_page(page);
-		ClearPageUptodate(page);
-	}
+	if (!unmapped)
+		xfs_aops_discard_page(page);
+	ClearPageUptodate(page);
+	unlock_page(page);
 	return err;
-}
-
-/*
- * writepage: Called from one of two places:
- *
- * 1. we are flushing a delalloc buffer head.
- *
- * 2. we are writing out a dirty page. Typically the page dirty
- *    state is cleared before we get here. In this case is it
- *    conceivable we have no buffer heads.
- *
- * For delalloc space on the page we need to allocate space and
- * flush it. For unmapped buffer heads on the page we should
- * allocate space if the page is uptodate. For any other dirty
- * buffer heads on the page we should flush them.
- *
- * If we detect that a transaction would be required to flush
- * the page, we have to check the process flags first, if we
- * are already in a transaction or disk I/O during allocations
- * is off, we need to fail the writepage and redirty the page.
- */
-
-STATIC int
-xfs_vm_writepage(
-	struct page		*page,
-	struct writeback_control *wbc)
-{
-	int			error;
-	int			need_trans;
-	int			delalloc, unmapped, unwritten;
-	struct inode		*inode = page->mapping->host;
-
-	trace_xfs_writepage(inode, page, 0);
-
-	/*
-	 * Refuse to write the page out if we are called from reclaim context.
-	 *
-	 * This is primarily to avoid stack overflows when called from deep
-	 * used stacks in random callers for direct reclaim, but disabling
-	 * reclaim for kswap is a nice side-effect as kswapd causes rather
-	 * suboptimal I/O patters, too.
-	 *
-	 * This should really be done by the core VM, but until that happens
-	 * filesystems like XFS, btrfs and ext4 have to take care of this
-	 * by themselves.
-	 */
-	if (current->flags & PF_MEMALLOC)
-		goto out_fail;
-
-	/*
-	 * We need a transaction if:
-	 *  1. There are delalloc buffers on the page
-	 *  2. The page is uptodate and we have unmapped buffers
-	 *  3. The page is uptodate and we have no buffers
-	 *  4. There are unwritten buffers on the page
-	 */
-
-	if (!page_has_buffers(page)) {
-		unmapped = 1;
-		need_trans = 1;
-	} else {
-		xfs_count_page_state(page, &delalloc, &unmapped, &unwritten);
-		if (!PageUptodate(page))
-			unmapped = 0;
-		need_trans = delalloc + unmapped + unwritten;
-	}
-
-	/*
-	 * If we need a transaction and the process flags say
-	 * we are already in a transaction, or no IO is allowed
-	 * then mark the page dirty again and leave the page
-	 * as is.
-	 */
-	if (current_test_flags(PF_FSTRANS) && need_trans)
-		goto out_fail;
-
-	/*
-	 * Delay hooking up buffer heads until we have
-	 * made our go/no-go decision.
-	 */
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
-
-
-	/*
-	 *  VM calculation for nr_to_write seems off.  Bump it way
-	 *  up, this gets simple streaming writes zippy again.
-	 *  To be reviewed again after Jens' writeback changes.
-	 */
-	wbc->nr_to_write *= 4;
-
-	/*
-	 * Convert delayed allocate, unwritten or unmapped space
-	 * to real space and flush out to disk.
-	 */
-	error = xfs_page_state_convert(inode, page, wbc, 1, unmapped);
-	if (error == -EAGAIN)
-		goto out_fail;
-	if (unlikely(error < 0))
-		goto out_unlock;
-
-	return 0;
 
 out_fail:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 	return 0;
-out_unlock:
-	unlock_page(page);
-	return error;
 }
 
 STATIC int
@@ -1424,65 +1321,27 @@ xfs_vm_writepages(
 
 /*
  * Called to move a page into cleanable state - and from there
- * to be released. Possibly the page is already clean. We always
+ * to be released. The page should already be clean. We always
  * have buffer heads in this call.
  *
- * Returns 0 if the page is ok to release, 1 otherwise.
- *
- * Possible scenarios are:
- *
- * 1. We are being called to release a page which has been written
- *    to via regular I/O. buffer heads will be dirty and possibly
- *    delalloc. If no delalloc buffer heads in this case then we
- *    can just return zero.
- *
- * 2. We are called to release a page which has been written via
- *    mmap, all we need to do is ensure there is no delalloc
- *    state in the buffer heads, if not we can let the caller
- *    free them and we should come back later via writepage.
+ * Returns 1 if the page is ok to release, 0 otherwise.
  */
 STATIC int
 xfs_vm_releasepage(
 	struct page		*page,
 	gfp_t			gfp_mask)
 {
-	struct inode		*inode = page->mapping->host;
-	int			dirty, delalloc, unmapped, unwritten;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
-		.nr_to_write = 1,
-	};
-
-	trace_xfs_releasepage(inode, page, 0);
+	int			delalloc, unmapped, unwritten;
 
-	if (!page_has_buffers(page))
-		return 0;
+	trace_xfs_releasepage(page->mapping->host, page, 0);
 
 	xfs_count_page_state(page, &delalloc, &unmapped, &unwritten);
-	if (!delalloc && !unwritten)
-		goto free_buffers;
 
-	if (!(gfp_mask & __GFP_FS))
+	if (WARN_ON(delalloc))
 		return 0;
-
-	/* If we are already inside a transaction or the thread cannot
-	 * do I/O, we cannot release this page.
-	 */
-	if (current_test_flags(PF_FSTRANS))
+	if (WARN_ON(unwritten))
 		return 0;
 
-	/*
-	 * Convert delalloc space to real space, do not flush the
-	 * data out to disk, that will be done by the caller.
-	 * Never need to allocate space here - we will always
-	 * come back to writepage in that case.
-	 */
-	dirty = xfs_page_state_convert(inode, page, &wbc, 0, 0);
-	if (dirty == 0 && !unwritten)
-		goto free_buffers;
-	return 0;
-
-free_buffers:
 	return try_to_free_buffers(page);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
