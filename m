Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751435AbdFZOZ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jun 2017 10:25:28 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 2/5] ext4: Switch to page_cache_seek_hole_data
Date: Mon, 26 Jun 2017 16:25:15 +0200
Message-Id: <1498487118-6564-3-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
References: <1498487118-6564-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Fix SEEK_HOLE / SEEK_DATA when a page fits more than two filesystem
blocks (see the commit that introduces page_cache_seek_hole_data).

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ext4/file.c | 144 ++++++---------------------------------------------------
 1 file changed, 13 insertions(+), 131 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 94eeef2..3e8f3d1 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -461,129 +461,6 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 }
 
 /*
- * Here we use ext4_map_blocks() to get a block mapping for a extent-based
- * file rather than ext4_ext_walk_space() because we can introduce
- * SEEK_DATA/SEEK_HOLE for block-mapped and extent-mapped file at the same
- * function.  When extent status tree has been fully implemented, it will
- * track all extent status for a file and we can directly use it to
- * retrieve the offset for SEEK_DATA/SEEK_HOLE.
- */
-
-/*
- * When we retrieve the offset for SEEK_DATA/SEEK_HOLE, we would need to
- * lookup page cache to check whether or not there has some data between
- * [startoff, endoff] because, if this range contains an unwritten extent,
- * we determine this extent as a data or a hole according to whether the
- * page cache has data or not.
- */
-static int ext4_find_unwritten_pgoff(struct inode *inode,
-				     int whence,
-				     ext4_lblk_t end_blk,
-				     loff_t *offset)
-{
-	struct pagevec pvec;
-	unsigned int blkbits;
-	pgoff_t index;
-	pgoff_t end;
-	loff_t endoff;
-	loff_t startoff;
-	loff_t lastoff;
-	int found = 0;
-
-	blkbits = inode->i_sb->s_blocksize_bits;
-	startoff = *offset;
-	lastoff = startoff;
-	endoff = (loff_t)end_blk << blkbits;
-
-	index = startoff >> PAGE_SHIFT;
-	end = (endoff - 1) >> PAGE_SHIFT;
-
-	pagevec_init(&pvec, 0);
-	do {
-		int i, num;
-		unsigned long nr_pages;
-
-		num = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
-					  (pgoff_t)num);
-		if (nr_pages == 0)
-			break;
-
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-			struct buffer_head *bh, *head;
-
-			/*
-			 * If current offset is smaller than the page offset,
-			 * there is a hole at this offset.
-			 */
-			if (whence == SEEK_HOLE && lastoff < endoff &&
-			    lastoff < page_offset(pvec.pages[i])) {
-				found = 1;
-				*offset = lastoff;
-				goto out;
-			}
-
-			if (page->index > end)
-				goto out;
-
-			lock_page(page);
-
-			if (unlikely(page->mapping != inode->i_mapping)) {
-				unlock_page(page);
-				continue;
-			}
-
-			if (!page_has_buffers(page)) {
-				unlock_page(page);
-				continue;
-			}
-
-			if (page_has_buffers(page)) {
-				lastoff = page_offset(page);
-				bh = head = page_buffers(page);
-				do {
-					if (buffer_uptodate(bh) ||
-					    buffer_unwritten(bh)) {
-						if (whence == SEEK_DATA)
-							found = 1;
-					} else {
-						if (whence == SEEK_HOLE)
-							found = 1;
-					}
-					if (found) {
-						*offset = max_t(loff_t,
-							startoff, lastoff);
-						unlock_page(page);
-						goto out;
-					}
-					lastoff += bh->b_size;
-					bh = bh->b_this_page;
-				} while (bh != head);
-			}
-
-			lastoff = page_offset(page) + PAGE_SIZE;
-			unlock_page(page);
-		}
-
-		/* The no. of pages is less than our desired, we are done. */
-		if (nr_pages < num)
-			break;
-
-		index = pvec.pages[i - 1]->index + 1;
-		pagevec_release(&pvec);
-	} while (index <= end);
-
-	if (whence == SEEK_HOLE && lastoff < endoff) {
-		found = 1;
-		*offset = lastoff;
-	}
-out:
-	pagevec_release(&pvec);
-	return found;
-}
-
-/*
  * ext4_seek_data() retrieves the offset for SEEK_DATA.
  */
 static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
@@ -591,7 +468,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 	struct inode *inode = file->f_mapping->host;
 	struct extent_status es;
 	ext4_lblk_t start, last, end;
-	loff_t dataoff, isize;
+	loff_t dataoff, length, isize;
 	int blkbits;
 	int ret;
 
@@ -630,8 +507,10 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		 * it will be as a data or a hole according to page
 		 * cache that has data or not.
 		 */
-		if (ext4_find_unwritten_pgoff(inode, SEEK_DATA,
-					      es.es_lblk + es.es_len, &dataoff))
+		length = ((loff_t)(last + es.es_len) << blkbits) - dataoff;
+		dataoff = page_cache_seek_hole_data(inode, dataoff,
+						    length, SEEK_DATA);
+		if (dataoff >= 0)
 			break;
 		last += es.es_len;
 		dataoff = (loff_t)last << blkbits;
@@ -654,7 +533,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 	struct inode *inode = file->f_mapping->host;
 	struct extent_status es;
 	ext4_lblk_t start, last, end;
-	loff_t holeoff, isize;
+	loff_t holeoff, length, isize;
 	int blkbits;
 	int ret;
 
@@ -689,10 +568,13 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 		 * it will be as a data or a hole according to page
 		 * cache that has data or not.
 		 */
-		if (ext4_es_is_unwritten(&es) &&
-		    ext4_find_unwritten_pgoff(inode, SEEK_HOLE,
-					      last + es.es_len, &holeoff))
-			break;
+		if (ext4_es_is_unwritten(&es)) {
+			length = ((loff_t)(last + es.es_len) << blkbits) - holeoff;
+			holeoff = page_cache_seek_hole_data(inode, holeoff,
+							    length, SEEK_HOLE);
+			if (holeoff >= 0)
+				break;
+		}
 
 		last += es.es_len;
 		holeoff = (loff_t)last << blkbits;
-- 
2.7.5

