Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:27974 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728363AbeKGQBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:23 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/16] iomap: prepare buffered IO paths for block size > page size
Date: Wed,  7 Nov 2018 17:31:18 +1100
Message-Id: <20181107063127.3902-8-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

With bs > ps, we have the situation where the page is no longer the
master of IO granularity. when doing IO to a page, we can't assume
there is a 1:N relationship between the page and the number of
blocks it covers. We actually have an N:1 relationship instead and
hence many of the assumptions about how the page cache interacts
with blocks need rethinking.

We can, however, still do page granulatiry IO - it's just that
certain operations need to be done on a block size granularity and
hence iterate multiple pages outside the actual page IO itself.
Before we get there, however, we need to make sure that the
functions that iterate blocks in pages do the right thing with bs >
ps.

Hence we need to change all the iop detection cases to detect block
size > page size rather than bs == ps, otherwise we will incorrectly
try to use the bs < ps code paths.

We also need to change all the code that uses block size for
iterating pages or finding offsets into pages to use PAGE_SIZE when
bs > ps, otherwise we calculate byte counts, offsets, into the page
we are operating on incorrectly. Because we are operating on single
pages, the size we need to use is no longer bs, but ps.

This also spills over into the XFS writepage code that interacts
directly with iomap page structures for block size < page size
writeback.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c            | 34 +++++++++++++++++++++++++---------
 fs/xfs/xfs_aops.c     | 13 +++++++------
 include/linux/iomap.h | 12 ++++++++++++
 3 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 8878b1f1f9c7..dd6aa6b403a6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -109,7 +109,7 @@ iomap_page_create(struct inode *inode, struct page *page)
 {
 	struct iomap_page *iop = to_iomap_page(page);
 
-	if (iop || i_blocksize(inode) == PAGE_SIZE)
+	if (iop || i_blocksize(inode) >= PAGE_SIZE)
 		return iop;
 
 	iop = kmalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
@@ -137,12 +137,15 @@ iomap_page_release(struct page *page)
 
 /*
  * Calculate the range inside the page that we actually need to read.
+ *
+ * For block size > page size, we need to use PAGE_SHIFT rather than
+ * inode->i_blkbits to calculate the offset into the page we are reading.
  */
 static void
 iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 		loff_t *pos, loff_t length, unsigned *offp, unsigned *lenp)
 {
-	unsigned block_bits = inode->i_blkbits;
+	unsigned block_bits = min_t(unsigned, inode->i_blkbits, PAGE_SHIFT);
 	unsigned block_size = (1 << block_bits);
 	unsigned poff = offset_in_page(*pos);
 	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, length);
@@ -194,13 +197,14 @@ static void
 iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
 {
 	struct iomap_page *iop = to_iomap_page(page);
-	struct inode *inode = page->mapping->host;
-	unsigned first = off >> inode->i_blkbits;
-	unsigned last = (off + len - 1) >> inode->i_blkbits;
-	unsigned int i;
 	bool uptodate = true;
 
 	if (iop) {
+		struct inode *inode = page->mapping->host;
+		unsigned first = off >> inode->i_blkbits;
+		unsigned last = (off + len - 1) >> inode->i_blkbits;
+		unsigned int i;
+
 		for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
 			if (i >= first && i <= last)
 				set_bit(i, iop->uptodate);
@@ -600,12 +604,17 @@ iomap_read_page_sync(struct inode *inode, loff_t block_start, struct page *page,
 	return submit_bio_wait(&bio);
 }
 
+/*
+ * If block size > PAGE_SIZE, we're actually working on offsets into
+ * the page, not offsets into the block. IOWs, it looks exactly like
+ * the block size == PAGE_SIZE.
+ */
 static int
 __iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
 		struct page *page, struct iomap *iomap)
 {
 	struct iomap_page *iop = iomap_page_create(inode, page);
-	loff_t block_size = i_blocksize(inode);
+	loff_t block_size = iomap_pageblock_size(inode);
 	loff_t block_start = pos & ~(block_size - 1);
 	loff_t block_end = (pos + len + block_size - 1) & ~(block_size - 1);
 	unsigned from = offset_in_page(pos), to = from + len, poff, plen;
@@ -1021,11 +1030,18 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 }
 EXPORT_SYMBOL_GPL(iomap_zero_range);
 
+/*
+ * Zero the truncated tail of the page provided.
+ *
+ * For block size > page size, we zero just the tail of the page as that is all
+ * we need for mmap() to see correctly zeroed space. File extension
+ * will need to zero the remainder of the block that we haven't zeroed here.
+ */
 int
 iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops)
 {
-	unsigned int blocksize = i_blocksize(inode);
+	unsigned int blocksize = iomap_pageblock_size(inode);
 	unsigned int off = pos & (blocksize - 1);
 
 	/* Block boundary? Nothing to do */
@@ -1209,7 +1225,7 @@ page_seek_hole_data(struct inode *inode, struct page *page, loff_t *lastoff,
 		int whence)
 {
 	const struct address_space_operations *ops = inode->i_mapping->a_ops;
-	unsigned int bsize = i_blocksize(inode), off;
+	unsigned int bsize = iomap_pageblock_size(inode), off;
 	bool seek_data = whence == SEEK_DATA;
 	loff_t poff = page_offset(page);
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 95e67f595f98..f6ef9e0a7312 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -72,7 +72,7 @@ xfs_finish_page_writeback(
 		mapping_set_error(inode->i_mapping, -EIO);
 	}
 
-	ASSERT(iop || i_blocksize(inode) == PAGE_SIZE);
+	ASSERT(iop || i_blocksize(inode) >= PAGE_SIZE);
 	ASSERT(!iop || atomic_read(&iop->write_count) > 0);
 
 	if (!iop || atomic_dec_and_test(&iop->write_count))
@@ -599,7 +599,7 @@ xfs_add_to_ioend(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
-	unsigned		len = i_blocksize(inode);
+	unsigned		len = iomap_pageblock_size(inode);
 	unsigned		poff = offset & (PAGE_SIZE - 1);
 	sector_t		sector;
 
@@ -666,7 +666,7 @@ xfs_aops_discard_page(
 			page, ip->i_ino, offset);
 
 	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-			PAGE_SIZE / i_blocksize(inode));
+			PAGE_SIZE / iomap_pageblock_size(inode));
 	if (error && !XFS_FORCED_SHUTDOWN(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 out_invalidate:
@@ -699,12 +699,13 @@ xfs_writepage_map(
 {
 	LIST_HEAD(submit_list);
 	struct iomap_page	*iop = to_iomap_page(page);
-	unsigned		len = i_blocksize(inode);
+	unsigned		len = iomap_pageblock_size(inode);
+	unsigned		blks_per_page = PAGE_SIZE / len;
 	struct xfs_ioend	*ioend, *next;
 	uint64_t		file_offset;	/* file offset of page */
 	int			error = 0, count = 0, i;
 
-	ASSERT(iop || i_blocksize(inode) == PAGE_SIZE);
+	ASSERT(iop || len == PAGE_SIZE);
 	ASSERT(!iop || atomic_read(&iop->write_count) == 0);
 
 	/*
@@ -713,7 +714,7 @@ xfs_writepage_map(
 	 * one.
 	 */
 	for (i = 0, file_offset = page_offset(page);
-	     i < (PAGE_SIZE >> inode->i_blkbits) && file_offset < end_offset;
+	     i < blks_per_page && file_offset < end_offset;
 	     i++, file_offset += len) {
 		if (iop && !test_bit(i, iop->uptodate))
 			continue;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 9a4258154b25..671c0c387450 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -119,6 +119,18 @@ static inline struct iomap_page *to_iomap_page(struct page *page)
 	return NULL;
 }
 
+/*
+ * Return the block size we should use for page cache based operations.
+ * This will return the inode block size for block size < PAGE_SIZE,
+ * otherwise it will return PAGE_SIZE.
+ */
+static inline unsigned
+iomap_pageblock_size(struct inode *inode)
+{
+	return min_t(unsigned, PAGE_SIZE, i_blocksize(inode));
+}
+
+
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
-- 
2.19.1
