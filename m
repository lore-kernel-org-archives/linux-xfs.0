Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SD1xhh005380 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 08:01:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8A8C1645855
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nxNoTMU4iOrQGXYe for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QFQuA-0003P5-I6
	for xfs@oss.sgi.com; Thu, 28 Apr 2011 13:05:14 +0000
Message-Id: <20110428130514.518468343@bombadil.infradead.org>
Date: Thu, 28 Apr 2011 08:55:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfs: use write_cache_pages for writeback clustering
References: <20110428125546.696493391@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-implement-writepages
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

Instead of implementing our own writeback clustering use write_cache_pages
to do it for us.  This means the guts of the current writepage implementation
become a new helper used both for implementing ->writepage and as a callback
to write_cache_pages for ->writepages.  A new struct xfs_writeback_ctx
is used to track block mapping state and the ioend chain over multiple
invocation of it.

The advantage over the old code is that we avoid a double pagevec lookup,
and a more efficient handling of extent boundaries inside a page for
small blocksize filesystems, as well as having less XFS specific code.

The downside is that we don't do writeback clustering when called from
kswapd anyore, but that is a case that should be avoided anyway.  Note
that we still convert the whole delalloc range from ->writepage, so
the on-disk allocation pattern is not affected.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-04-27 20:55:01.482820427 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2011-04-28 11:22:42.747447011 +0200
@@ -38,6 +38,12 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+struct xfs_writeback_ctx {
+	unsigned int		imap_valid;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_ioend	*iohead;
+	struct xfs_ioend	*ioend;
+};
 
 /*
  * Prime number of hash buckets since address is used as the key.
@@ -487,6 +493,7 @@ xfs_submit_ioend(
 	struct buffer_head	*bh;
 	struct bio		*bio;
 	sector_t		lastblock = 0;
+	struct blk_plug		plug;
 
 	/* Pass 1 - start writeback */
 	do {
@@ -496,6 +503,7 @@ xfs_submit_ioend(
 	} while ((ioend = next) != NULL);
 
 	/* Pass 2 - submit I/O */
+	blk_start_plug(&plug);
 	ioend = head;
 	do {
 		next = ioend->io_list;
@@ -522,6 +530,7 @@ xfs_submit_ioend(
 			xfs_submit_ioend_bio(wbc, ioend, bio);
 		xfs_finish_ioend(ioend);
 	} while ((ioend = next) != NULL);
+	blk_finish_plug(&plug);
 }
 
 /*
@@ -661,153 +670,6 @@ xfs_is_delayed_page(
 	return 0;
 }
 
-/*
- * Allocate & map buffers for page given the extent map. Write it out.
- * except for the original page of a writepage, this is called on
- * delalloc/unwritten pages only, for the original page it is possible
- * that the page has no mapping at all.
- */
-STATIC int
-xfs_convert_page(
-	struct inode		*inode,
-	struct page		*page,
-	loff_t			tindex,
-	struct xfs_bmbt_irec	*imap,
-	xfs_ioend_t		**ioendp,
-	struct writeback_control *wbc)
-{
-	struct buffer_head	*bh, *head;
-	xfs_off_t		end_offset;
-	unsigned long		p_offset;
-	unsigned int		type;
-	int			len, page_dirty;
-	int			count = 0, done = 0, uptodate = 1;
- 	xfs_off_t		offset = page_offset(page);
-
-	if (page->index != tindex)
-		goto fail;
-	if (!trylock_page(page))
-		goto fail;
-	if (PageWriteback(page))
-		goto fail_unlock_page;
-	if (page->mapping != inode->i_mapping)
-		goto fail_unlock_page;
-	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
-		goto fail_unlock_page;
-
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
-	 */
-	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
-			i_size_read(inode));
-
-	len = 1 << inode->i_blkbits;
-	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
-					PAGE_CACHE_SIZE);
-	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
-	page_dirty = p_offset / len;
-
-	bh = head = page_buffers(page);
-	do {
-		if (offset >= end_offset)
-			break;
-		if (!buffer_uptodate(bh))
-			uptodate = 0;
-		if (!(PageUptodate(page) || buffer_uptodate(bh))) {
-			done = 1;
-			continue;
-		}
-
-		if (buffer_unwritten(bh) || buffer_delay(bh) ||
-		    buffer_mapped(bh)) {
-			if (buffer_unwritten(bh))
-				type = IO_UNWRITTEN;
-			else if (buffer_delay(bh))
-				type = IO_DELALLOC;
-			else
-				type = IO_OVERWRITE;
-
-			if (!xfs_imap_valid(inode, imap, offset)) {
-				done = 1;
-				continue;
-			}
-
-			lock_buffer(bh);
-			if (type != IO_OVERWRITE)
-				xfs_map_at_offset(inode, bh, imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, type,
-					 ioendp, done);
-
-			page_dirty--;
-			count++;
-		} else {
-			done = 1;
-		}
-	} while (offset += len, (bh = bh->b_this_page) != head);
-
-	if (uptodate && bh == head)
-		SetPageUptodate(page);
-
-	if (count) {
-		if (--wbc->nr_to_write <= 0 &&
-		    wbc->sync_mode == WB_SYNC_NONE)
-			done = 1;
-	}
-	xfs_start_page_writeback(page, !page_dirty, count);
-
-	return done;
- fail_unlock_page:
-	unlock_page(page);
- fail:
-	return 1;
-}
-
-/*
- * Convert & write out a cluster of pages in the same extent as defined
- * by mp and following the start page.
- */
-STATIC void
-xfs_cluster_write(
-	struct inode		*inode,
-	pgoff_t			tindex,
-	struct xfs_bmbt_irec	*imap,
-	xfs_ioend_t		**ioendp,
-	struct writeback_control *wbc,
-	pgoff_t			tlast)
-{
-	struct pagevec		pvec;
-	int			done = 0, i;
-
-	pagevec_init(&pvec, 0);
-	while (!done && tindex <= tlast) {
-		unsigned len = min_t(pgoff_t, PAGEVEC_SIZE, tlast - tindex + 1);
-
-		if (!pagevec_lookup(&pvec, inode->i_mapping, tindex, len))
-			break;
-
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			done = xfs_convert_page(inode, pvec.pages[i], tindex++,
-					imap, ioendp, wbc);
-			if (done)
-				break;
-		}
-
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-}
-
 STATIC void
 xfs_vm_invalidatepage(
 	struct page		*page,
@@ -896,20 +758,20 @@ out_invalidate:
  * redirty the page.
  */
 STATIC int
-xfs_vm_writepage(
+__xfs_vm_writepage(
 	struct page		*page,
-	struct writeback_control *wbc)
+	struct writeback_control *wbc,
+	void			*data)
 {
+	struct xfs_writeback_ctx *ctx = data;
 	struct inode		*inode = page->mapping->host;
 	struct buffer_head	*bh, *head;
-	struct xfs_bmbt_irec	imap;
-	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
 	loff_t			offset;
 	unsigned int		type;
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
 	ssize_t			len;
-	int			err, imap_valid = 0, uptodate = 1;
+	int			err, uptodate = 1;
 	int			count = 0;
 
 	trace_xfs_writepage(inode, page, 0);
@@ -917,20 +779,6 @@ xfs_vm_writepage(
 	ASSERT(page_has_buffers(page));
 
 	/*
-	 * Refuse to write the page out if we are called from reclaim context.
-	 *
-	 * This avoids stack overflows when called from deeply used stacks in
-	 * random callers for direct reclaim or memcg reclaim.  We explicitly
-	 * allow reclaim from kswapd as the stack usage there is relatively low.
-	 *
-	 * This should really be done by the core VM, but until that happens
-	 * filesystems like XFS, btrfs and ext4 have to take care of this
-	 * by themselves.
-	 */
-	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
-		goto redirty;
-
-	/*
 	 * Given that we do not allow direct reclaim to call us we should
 	 * never be called while in a filesystem transaction.
 	 */
@@ -973,36 +821,38 @@ xfs_vm_writepage(
 		 * buffers covering holes here.
 		 */
 		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
-			imap_valid = 0;
+			ctx->imap_valid = 0;
 			continue;
 		}
 
 		if (buffer_unwritten(bh)) {
 			if (type != IO_UNWRITTEN) {
 				type = IO_UNWRITTEN;
-				imap_valid = 0;
+				ctx->imap_valid = 0;
 			}
 		} else if (buffer_delay(bh)) {
 			if (type != IO_DELALLOC) {
 				type = IO_DELALLOC;
-				imap_valid = 0;
+				ctx->imap_valid = 0;
 			}
 		} else if (buffer_uptodate(bh)) {
 			if (type != IO_OVERWRITE) {
 				type = IO_OVERWRITE;
-				imap_valid = 0;
+				ctx->imap_valid = 0;
 			}
 		} else {
 			if (PageUptodate(page)) {
 				ASSERT(buffer_mapped(bh));
-				imap_valid = 0;
+				ctx->imap_valid = 0;
 			}
 			continue;
 		}
 
-		if (imap_valid)
-			imap_valid = xfs_imap_valid(inode, &imap, offset);
-		if (!imap_valid) {
+		if (ctx->imap_valid) {
+			ctx->imap_valid =
+				xfs_imap_valid(inode, &ctx->imap, offset);
+		}
+		if (!ctx->imap_valid) {
 			/*
 			 * If we didn't have a valid mapping then we need to
 			 * put the new mapping into a separate ioend structure.
@@ -1012,22 +862,25 @@ xfs_vm_writepage(
 			 * time.
 			 */
 			new_ioend = 1;
-			err = xfs_map_blocks(inode, offset, &imap, type);
+			err = xfs_map_blocks(inode, offset, &ctx->imap, type);
 			if (err)
 				goto error;
-			imap_valid = xfs_imap_valid(inode, &imap, offset);
+			ctx->imap_valid =
+				xfs_imap_valid(inode, &ctx->imap, offset);
 		}
-		if (imap_valid) {
+		if (ctx->imap_valid) {
 			lock_buffer(bh);
-			if (type != IO_OVERWRITE)
-				xfs_map_at_offset(inode, bh, &imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
+			if (type != IO_OVERWRITE) {
+				xfs_map_at_offset(inode, bh, &ctx->imap,
+						  offset);
+			}
+			xfs_add_to_ioend(inode, bh, offset, type, &ctx->ioend,
 					 new_ioend);
 			count++;
 		}
 
-		if (!iohead)
-			iohead = ioend;
+		if (!ctx->iohead)
+			ctx->iohead = ctx->ioend;
 
 	} while (offset += len, ((bh = bh->b_this_page) != head));
 
@@ -1035,38 +888,9 @@ xfs_vm_writepage(
 		SetPageUptodate(page);
 
 	xfs_start_page_writeback(page, 1, count);
-
-	if (ioend && imap_valid) {
-		xfs_off_t		end_index;
-
-		end_index = imap.br_startoff + imap.br_blockcount;
-
-		/* to bytes */
-		end_index <<= inode->i_blkbits;
-
-		/* to pages */
-		end_index = (end_index - 1) >> PAGE_CACHE_SHIFT;
-
-		/* check against file size */
-		if (end_index > last_index)
-			end_index = last_index;
-
-		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
-				  wbc, end_index);
-	}
-
-	if (iohead)
-		xfs_submit_ioend(wbc, iohead);
-
 	return 0;
 
 error:
-	if (iohead)
-		xfs_cancel_ioend(iohead);
-
-	if (err == -EAGAIN)
-		goto redirty;
-
 	xfs_aops_discard_page(page);
 	ClearPageUptodate(page);
 	unlock_page(page);
@@ -1079,12 +903,62 @@ redirty:
 }
 
 STATIC int
+xfs_vm_writepage(
+	struct page		*page,
+	struct writeback_control *wbc)
+{
+	struct xfs_writeback_ctx ctx = { };
+	int ret;
+
+	/*
+	 * Refuse to write the page out if we are called from reclaim context.
+	 *
+	 * This avoids stack overflows when called from deeply used stacks in
+	 * random callers for direct reclaim or memcg reclaim.  We explicitly
+	 * allow reclaim from kswapd as the stack usage there is relatively low.
+	 *
+	 * This should really be done by the core VM, but until that happens
+	 * filesystems like XFS, btrfs and ext4 have to take care of this
+	 * by themselves.
+	 */
+	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC) {
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return 0;
+	}
+
+	ret = __xfs_vm_writepage(page, wbc, &ctx);
+
+	if (ctx.iohead) {
+		if (ret)
+			xfs_cancel_ioend(ctx.iohead);
+		else
+			xfs_submit_ioend(wbc, ctx.iohead);
+	}
+
+	return ret;
+}
+
+STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
 	struct writeback_control *wbc)
 {
+	struct xfs_writeback_ctx ctx = { };
+	int ret;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
-	return generic_writepages(mapping, wbc);
+
+	ret = write_cache_pages(mapping, wbc, __xfs_vm_writepage, &ctx);
+
+	if (ctx.iohead) {
+		if (ret)
+			xfs_cancel_ioend(ctx.iohead);
+		else
+			xfs_submit_ioend(wbc, ctx.iohead);
+	}
+
+	return ret;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
