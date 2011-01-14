Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ENUvf3110831 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 17:30:57 -0600
Date: Fri, 14 Jan 2011 17:32:26 -0600
From: bpm@sgi.com
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110114233226.GO28274@sgi.com>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114214334.GN28274@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Fri, Jan 14, 2011 at 03:43:34PM -0600, bpm@sgi.com wrote:
> On Fri, Jan 14, 2011 at 11:29:00AM +1100, Dave Chinner wrote:
> > I'm sure there are other ways to solve these problems, but these two
> > are the ones that come to mind for me.  I'm open to other solutions
> > or ways to improve on these ones, especially if they are simpler. ;)
> > Anyone got any ideas or improvements?
> 
> The direction I've been taking is to use XFS_BMAPI_EXACT in
> *xfs_iomap_write_allocate to ensure that an extent covering exactly the
> pages we're prepared to write out immediately is allocated and the rest
> of the delalloc extent is left as is.  This exercises some of the btree
> code more heavily and led to the discovery of the
> allocate-in-the-middle-of-a-delalloc-extent bug.  It also presents a
> performance issue which I've tried to resolve by extending
> xfs_probe_cluster to probe delalloc extents-- lock up all of the pages
> to be converted before performing the allocation and hold those locks
> until they are submitted for writeback.  It's not very pretty but it
> resolves the corruption.

Here's the xfs_page_state_convert side of the patch so you can get an
idea what am trying for, and how ugly it is.  ;^)

I have not ported the xfs_iomap_write_allocate bits yet.  It is against
an older version of xfs... but you get the idea.

-Ben

Index: sles11-src/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- sles11-src.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ sles11-src/fs/xfs/linux-2.6/xfs_aops.c
@@ -585,41 +585,61 @@ STATIC unsigned int
 xfs_probe_page(
 	struct page		*page,
 	unsigned int		pg_offset,
-	int			mapped)
+	int			mapped,
+	unsigned int		type,
+	int			*entire)
 {
+	struct buffer_head	*bh, *head;
 	int			ret = 0;
 
 	if (PageWriteback(page))
 		return 0;
+	if (!page->mapping)
+		return 0;
+	if (!PageDirty(page))
+		return 0;
+	if (!page_has_buffers(page))
+		return 0;
 
-	if (page->mapping && PageDirty(page)) {
-		if (page_has_buffers(page)) {
-			struct buffer_head	*bh, *head;
-
-			bh = head = page_buffers(page);
-			do {
-				if (!buffer_uptodate(bh))
-					break;
-				if (mapped != buffer_mapped(bh))
-					break;
-				ret += bh->b_size;
-				if (ret >= pg_offset)
-					break;
-			} while ((bh = bh->b_this_page) != head);
-		} else
-			ret = mapped ? 0 : PAGE_CACHE_SIZE;
-	}
+	*entire = 0;
+	bh = head = page_buffers(page);
+	do {
+		if (!buffer_uptodate(bh))
+			break;
+		if (buffer_mapped(bh) != mapped)
+			break;
+		if (type == IOMAP_UNWRITTEN && !buffer_unwritten(bh))
+			break;
+		if (type == IOMAP_DELAY && !buffer_delay(bh))
+			break;
+		if (type == IOMAP_NEW && !buffer_dirty(bh))
+			break;
+
+		ret += bh->b_size;
+
+		if (ret >= pg_offset)
+			break;
+	} while ((bh = bh->b_this_page) != head);
+
+	if (bh == head)
+		*entire = 1;
 
 	return ret;
 }
 
+#define MAX_WRITEBACK_PAGES	1024
+
 STATIC size_t
 xfs_probe_cluster(
 	struct inode		*inode,
 	struct page		*startpage,
 	struct buffer_head	*bh,
 	struct buffer_head	*head,
-	int			mapped)
+	int			mapped,
+	unsigned int		type,
+	struct page		**pages,
+	int			*pagecount,
+	struct writeback_control *wbc)
 {
 	struct pagevec		pvec;
 	pgoff_t			tindex, tlast, tloff;
@@ -628,8 +648,15 @@ xfs_probe_cluster(
 
 	/* First sum forwards in this page */
 	do {
-		if (!buffer_uptodate(bh) || (mapped != buffer_mapped(bh)))
+		if (!buffer_uptodate(bh) || (mapped != buffer_mapped(bh))) {
+			return total;
+		} else if (type == IOMAP_UNWRITTEN && !buffer_unwritten(bh)) {
 			return total;
+		} else if (type == IOMAP_DELAY && !buffer_delay(bh)) {
+			return total;
+		} else if (type == IOMAP_NEW && !buffer_dirty(bh)) {
+			return total;
+		}
 		total += bh->b_size;
 	} while ((bh = bh->b_this_page) != head);
 
@@ -637,8 +664,9 @@ xfs_probe_cluster(
 	tlast = i_size_read(inode) >> PAGE_CACHE_SHIFT;
 	tindex = startpage->index + 1;
 
-	/* Prune this back to avoid pathological behavior */
-	tloff = min(tlast, startpage->index + 64);
+	/* Prune this back to avoid pathological behavior, subtract 1 for the
+	 * first page. */
+	tloff = min(tlast, startpage->index + (pgoff_t)MAX_WRITEBACK_PAGES);
 
 	pagevec_init(&pvec, 0);
 	while (!done && tindex <= tloff) {
@@ -647,10 +675,10 @@ xfs_probe_cluster(
 		if (!pagevec_lookup(&pvec, inode->i_mapping, tindex, len))
 			break;
 
-		for (i = 0; i < pagevec_count(&pvec); i++) {
+		for (i = 0; i < pagevec_count(&pvec) && !done; i++) {
 			struct page *page = pvec.pages[i];
 			size_t pg_offset, pg_len = 0;
-
+			int	entire = 0;
 			if (tindex == tlast) {
 				pg_offset =
 				    i_size_read(inode) & (PAGE_CACHE_SIZE - 1);
@@ -658,20 +686,39 @@ xfs_probe_cluster(
 					done = 1;
 					break;
 				}
-			} else
+			} else {
 				pg_offset = PAGE_CACHE_SIZE;
-
-			if (page->index == tindex && trylock_page(page)) {
-				pg_len = xfs_probe_page(page, pg_offset, mapped);
-				unlock_page(page);
 			}
 
+			if (page->index == tindex &&
+			    *pagecount < MAX_WRITEBACK_PAGES - 1 &&
+			    trylock_page(page)) {
+	 			pg_len = xfs_probe_page(page, pg_offset,
+						mapped, type, &entire);
+				if (pg_len) {
+					pages[(*pagecount)++] = page;
+
+				} else {
+					unlock_page(page);
+				}
+			}
 			if (!pg_len) {
 				done = 1;
 				break;
 			}
 
 			total += pg_len;
+
+			/*
+			 * if probe did not succeed on all buffers in the page
+			 * we don't want to probe subsequent pages.  This
+			 * ensures that we don't have a mix of buffer types in
+			 * the iomap.
+			 */
+			if (!entire) {
+				done = 1;
+				break;
+			}
 			tindex++;
 		}
 
@@ -683,56 +730,19 @@ xfs_probe_cluster(
 }
 
 /*
- * Test if a given page is suitable for writing as part of an unwritten
- * or delayed allocate extent.
- */
-STATIC int
-xfs_is_delayed_page(
-	struct page		*page,
-	unsigned int		type)
-{
-	if (PageWriteback(page))
-		return 0;
-
-	if (page->mapping && page_has_buffers(page)) {
-		struct buffer_head	*bh, *head;
-		int			acceptable = 0;
-
-		bh = head = page_buffers(page);
-		do {
-			if (buffer_unwritten(bh))
-				acceptable = (type == IOMAP_UNWRITTEN);
-			else if (buffer_delay(bh))
-				acceptable = (type == IOMAP_DELAY);
-			else if (buffer_dirty(bh) && buffer_mapped(bh))
-				acceptable = (type == IOMAP_NEW);
-			else
-				break;
-		} while ((bh = bh->b_this_page) != head);
-
-		if (acceptable)
-			return 1;
-	}
-
-	return 0;
-}
-
-/*
  * Allocate & map buffers for page given the extent map. Write it out.
  * except for the original page of a writepage, this is called on
  * delalloc/unwritten pages only, for the original page it is possible
  * that the page has no mapping at all.
  */
-STATIC int
+STATIC void
 xfs_convert_page(
 	struct inode		*inode,
 	struct page		*page,
-	loff_t			tindex,
 	xfs_iomap_t		*mp,
 	xfs_ioend_t		**ioendp,
 	struct writeback_control *wbc,
-	int			startio,
-	int			all_bh)
+	int			startio)
 {
 	struct buffer_head	*bh, *head;
 	xfs_off_t		end_offset;
@@ -740,20 +750,9 @@ xfs_convert_page(
 	unsigned int		type;
 	int			bbits = inode->i_blkbits;
 	int			len, page_dirty;
-	int			count = 0, done = 0, uptodate = 1;
+	int			count = 0, uptodate = 1;
  	xfs_off_t		offset = page_offset(page);
 
-	if (page->index != tindex)
-		goto fail;
-	if (! trylock_page(page))
-		goto fail;
-	if (PageWriteback(page))
-		goto fail_unlock_page;
-	if (page->mapping != inode->i_mapping)
-		goto fail_unlock_page;
-	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
-		goto fail_unlock_page;
-
 	/*
 	 * page_dirty is initially a count of buffers on the page before
 	 * EOF and is decremented as we move each into a cleanable state.
@@ -770,6 +769,8 @@ xfs_convert_page(
 	end_offset = min_t(unsigned long long,
 			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
 			i_size_read(inode));
+	end_offset = min_t(unsigned long long, end_offset,
+			(mp->iomap_offset + mp->iomap_bsize));
 
 	len = 1 << inode->i_blkbits;
 	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
@@ -779,12 +780,12 @@ xfs_convert_page(
 
 	bh = head = page_buffers(page);
 	do {
-		if (offset >= end_offset)
+		if (offset >= end_offset) {
 			break;
+		}
 		if (!buffer_uptodate(bh))
 			uptodate = 0;
 		if (!(PageUptodate(page) || buffer_uptodate(bh))) {
-			done = 1;
 			continue;
 		}
 
@@ -794,10 +795,7 @@ xfs_convert_page(
 			else
 				type = IOMAP_DELAY;
 
-			if (!xfs_iomap_valid(mp, offset)) {
-				done = 1;
-				continue;
-			}
+			BUG_ON(!xfs_iomap_valid(mp, offset));
 
 			ASSERT(!(mp->iomap_flags & IOMAP_HOLE));
 			ASSERT(!(mp->iomap_flags & IOMAP_DELAY));
@@ -805,7 +803,7 @@ xfs_convert_page(
 			xfs_map_at_offset(bh, offset, bbits, mp);
 			if (startio) {
 				xfs_add_to_ioend(inode, bh, offset,
-						type, ioendp, done);
+						type, ioendp, 0 /* !done */);
 			} else {
 				set_buffer_dirty(bh);
 				unlock_buffer(bh);
@@ -814,15 +812,14 @@ xfs_convert_page(
 			page_dirty--;
 			count++;
 		} else {
+			WARN_ON(!xfs_iomap_valid(mp, offset));
 			type = IOMAP_NEW;
-			if (buffer_mapped(bh) && all_bh && startio) {
+			if (buffer_mapped(bh) && buffer_dirty(bh) && startio) {
 				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset,
-						type, ioendp, done);
+						type, ioendp, 0 /* !done */);
 				count++;
 				page_dirty--;
-			} else {
-				done = 1;
 			}
 		}
 	} while (offset += len, (bh = bh->b_this_page) != head);
@@ -838,19 +835,16 @@ xfs_convert_page(
 			wbc->nr_to_write--;
 			if (bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
-				done = 1;
 			} else if (wbc->nr_to_write <= 0) {
-				done = 1;
+				/* XXX ignore nr_to_write
+				done = 1; */
 			}
 		}
+		/* unlocks page */
 		xfs_start_page_writeback(page, wbc, !page_dirty, count);
+	} else {
+		unlock_page(page);
 	}
-
-	return done;
- fail_unlock_page:
-	unlock_page(page);
- fail:
-	return 1;
 }
 
 /*
@@ -860,33 +854,17 @@ xfs_convert_page(
 STATIC void
 xfs_cluster_write(
 	struct inode		*inode,
-	pgoff_t			tindex,
+	struct page		**pages,
+	int			pagecount,
 	xfs_iomap_t		*iomapp,
 	xfs_ioend_t		**ioendp,
 	struct writeback_control *wbc,
-	int			startio,
-	int			all_bh,
-	pgoff_t			tlast)
+	int			startio)
 {
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
-					iomapp, ioendp, wbc, startio, all_bh);
-			if (done)
-				break;
-		}
+	int			i;
 
-		pagevec_release(&pvec);
-		cond_resched();
+	for (i = 0; i < pagecount; i++) {
+		xfs_convert_page(inode, pages[i], iomapp, ioendp, wbc, startio);
 	}
 }
 
@@ -908,7 +886,6 @@ xfs_cluster_write(
  * bh->b_states's will not agree and only ones setup by BPW/BCW will have
  * valid state, thus the whole page must be written out thing.
  */
-
 STATIC int
 xfs_page_state_convert(
 	struct inode	*inode,
@@ -924,12 +901,13 @@ xfs_page_state_convert(
 	unsigned long           p_offset = 0;
 	unsigned int		type;
 	__uint64_t              end_offset;
-	pgoff_t                 end_index, last_index, tlast;
+	pgoff_t                 end_index, last_index;
 	ssize_t			size, len;
 	int			flags, err, iomap_valid = 0, uptodate = 1;
 	int			page_dirty, count = 0;
 	int			trylock = 0;
-	int			all_bh = unmapped;
+	struct page		**pages;
+	int			pagecount = 0, i;
 
 	if (startio) {
 		if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
@@ -949,6 +927,9 @@ xfs_page_state_convert(
 		}
 	}
 
+	pages = kmem_zalloc(sizeof(struct page*) * MAX_WRITEBACK_PAGES, KM_NOFS);
+
+
 	/*
 	 * page_dirty is initially a count of buffers on the page before
 	 * EOF and is decremented as we move each into a cleanable state.
@@ -1036,14 +1017,23 @@ xfs_page_state_convert(
 				 * for unwritten extent conversion.
 				 */
 				new_ioend = 1;
-				if (type == IOMAP_NEW) {
-					size = xfs_probe_cluster(inode,
-							page, bh, head, 0);
-				} else {
-					size = len;
+				size = 0;
+				if (type == IOMAP_NEW && !pagecount) {
+					size = xfs_probe_cluster(inode, page,
+							bh, head,
+							0 /* !mapped */, type,
+						       	pages, &pagecount, wbc);
+				} else if ((type == IOMAP_DELAY ||
+					    type == IOMAP_UNWRITTEN) &&
+						!pagecount) {
+					size = xfs_probe_cluster(inode, page,
+							bh, head,
+							1 /* mapped */, type,
+							pages, &pagecount, wbc);
 				}
 
-				err = xfs_map_blocks(inode, offset, size,
+				err = xfs_map_blocks(inode, offset,
+						size ? size : len,
 						&iomap, flags);
 				if (err)
 					goto error;
@@ -1072,9 +1062,16 @@ xfs_page_state_convert(
 			 */
 			if (!iomap_valid || flags != BMAPI_READ) {
 				flags = BMAPI_READ;
-				size = xfs_probe_cluster(inode, page, bh,
-								head, 1);
-				err = xfs_map_blocks(inode, offset, size,
+				size = 0;
+				if (!pagecount) {
+					size = xfs_probe_cluster(inode, page,
+							bh, head,
+							1 /* mapped */,
+							IOMAP_NEW,
+							pages, &pagecount, wbc);
+				}
+				err = xfs_map_blocks(inode, offset,
+						size ? size : len,
 						&iomap, flags);
 				if (err)
 					goto error;
@@ -1092,8 +1089,6 @@ xfs_page_state_convert(
 			type = IOMAP_NEW;
 			if (!test_and_set_bit(BH_Lock, &bh->b_state)) {
 				ASSERT(buffer_mapped(bh));
-				if (iomap_valid)
-					all_bh = 1;
 				xfs_add_to_ioend(inode, bh, offset, type,
 						&ioend, !iomap_valid);
 				page_dirty--;
@@ -1104,6 +1099,8 @@ xfs_page_state_convert(
 		} else if ((buffer_uptodate(bh) || PageUptodate(page)) &&
 			   (unmapped || startio)) {
 			iomap_valid = 0;
+		} else {
+			WARN_ON(1);
 		}
 
 		if (!iohead)
@@ -1117,13 +1114,11 @@ xfs_page_state_convert(
 	if (startio)
 		xfs_start_page_writeback(page, wbc, 1, count);
 
-	if (ioend && iomap_valid) {
-		offset = (iomap.iomap_offset + iomap.iomap_bsize - 1) >>
-					PAGE_CACHE_SHIFT;
-		tlast = min_t(pgoff_t, offset, last_index);
-		xfs_cluster_write(inode, page->index + 1, &iomap, &ioend,
-					wbc, startio, all_bh, tlast);
+	if (ioend && iomap_valid && pagecount) {
+		xfs_cluster_write(inode, pages, pagecount, &iomap, &ioend,
+					wbc, startio);
 	}
+	kmem_free(pages, sizeof(struct page *) * MAX_WRITEBACK_PAGES);
 
 	if (iohead)
 		xfs_submit_ioend(iohead);
@@ -1133,7 +1128,12 @@ xfs_page_state_convert(
 error:
 	if (iohead)
 		xfs_cancel_ioend(iohead);
-
+	if (pages) {
+		for (i = 0; i < pagecount; i++) {
+			unlock_page(pages[i]);
+		}
+		kmem_free(pages, sizeof(struct page *) * MAX_WRITEBACK_PAGES);
+	}
 	return err;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
