Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50856 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756013AbeEaSHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:07:37 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] fs: use ->is_partially_uptodate in page_cache_seek_hole_data
Date: Thu, 31 May 2018 20:07:24 +0200
Message-Id: <20180531180724.21573-4-hch@lst.de>
In-Reply-To: <20180531180724.21573-1-hch@lst.de>
References: <20180531180724.21573-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

This way the implementation doesn't depend on buffer_head internals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c | 83 ++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 43 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index e93bd4eb7fa7..49119e64edc3 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -807,34 +807,53 @@ EXPORT_SYMBOL_GPL(iomap_fiemap);
 
 /*
  * Seek for SEEK_DATA / SEEK_HOLE within @page, starting at @lastoff.
- *
- * Returns the offset within the file on success, and -ENOENT otherwise.
+ * Returns true if found and updates @lastoff to the offset in file.
  */
-static loff_t
-page_seek_hole_data(struct page *page, loff_t lastoff, int whence)
+static bool
+page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
+		int whence)
 {
-	loff_t offset = page_offset(page);
-	struct buffer_head *bh, *head;
+	const struct address_space_operations *ops = inode->i_mapping->a_ops;
+	unsigned int bsize = i_blocksize(inode), off;
 	bool seek_data = whence == SEEK_DATA;
+	loff_t poff = page_offset(page);
 
-	if (lastoff < offset)
-		lastoff = offset;
-
-	bh = head = page_buffers(page);
-	do {
-		offset += bh->b_size;
-		if (lastoff >= offset)
-			continue;
+	if (WARN_ON_ONCE(*lastoff >= poff + PAGE_SIZE))
+		return false;
 
+	if (*lastoff < poff) {
 		/*
-		 * Any buffer with valid data in it should have BH_Uptodate set.
+		 * Last offset smaller than the start of the page means we found
+		 * a hole:
 		 */
-		if (buffer_uptodate(bh) == seek_data)
-			return lastoff;
+		if (whence == SEEK_HOLE)
+			return true;
+		*lastoff = poff;
+	}
 
-		lastoff = offset;
-	} while ((bh = bh->b_this_page) != head);
-	return -ENOENT;
+	/*
+	 * Just check the page unless we can and should check block ranges:
+	 */
+	if (bsize == PAGE_SIZE || !ops->is_partially_uptodate)
+		return PageUptodate(page) == seek_data;
+
+	lock_page(page);
+	if (unlikely(page->mapping != inode->i_mapping))
+		goto out_unlock_not_found;
+
+	for (off = 0; off < PAGE_SIZE; off += bsize) {
+		if ((*lastoff & ~PAGE_MASK) >= off + bsize)
+			continue;
+		if (ops->is_partially_uptodate(page, off, bsize) == seek_data) {
+			unlock_page(page);
+			return true;
+		}
+		*lastoff = poff + off + bsize;
+	}
+
+out_unlock_not_found:
+	unlock_page(page);
+	return false;
 }
 
 /*
@@ -871,30 +890,8 @@ page_cache_seek_hole_data(struct inode *inode, loff_t offset, loff_t length,
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			/*
-			 * At this point, the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or
-			 * even swizzled back from swapper_space to tmpfs file
-			 * mapping.  However, page->index will not change
-			 * because we have a reference on the page.
-                         *
-			 * If current page offset is beyond where we've ended,
-			 * we've found a hole.
-                         */
-			if (whence == SEEK_HOLE &&
-			    lastoff < page_offset(page))
+			if (page_seek_hole_data(inode, page, &lastoff, whence))
 				goto check_range;
-
-			lock_page(page);
-			if (likely(page->mapping == inode->i_mapping) &&
-			    page_has_buffers(page)) {
-				lastoff = page_seek_hole_data(page, lastoff, whence);
-				if (lastoff >= 0) {
-					unlock_page(page);
-					goto check_range;
-				}
-			}
-			unlock_page(page);
 			lastoff = page_offset(page) + PAGE_SIZE;
 		}
 		pagevec_release(&pvec);
-- 
2.17.0

