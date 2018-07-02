Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752611AbeGBO63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:29 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/22] xfs: allow writeback on pages without buffer heads
Date: Mon,  2 Jul 2018 08:58:10 -0600
Message-Id: <20180702145813.22496-20-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Disable the IOMAP_F_BUFFER_HEAD flag on file systems with a block size
equal to the page size, and deal with pages without buffer heads in
writeback.  Thanks to the previous refactoring this is basically trivial
now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c  | 51 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_iomap.c |  3 ++-
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c8e0d3055153..0058f9893705 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -79,6 +79,19 @@ xfs_find_daxdev_for_inode(
 		return mp->m_ddev_targp->bt_daxdev;
 }
 
+static void
+xfs_finish_page_writeback(
+	struct inode		*inode,
+	struct bio_vec		*bvec,
+	int			error)
+{
+	if (error) {
+		SetPageError(bvec->bv_page);
+		mapping_set_error(inode->i_mapping, -EIO);
+	}
+	end_page_writeback(bvec->bv_page);
+}
+
 /*
  * We're now finished for good with this page.  Update the page state via the
  * associated buffer_heads, paying attention to the start and end offsets that
@@ -91,7 +104,7 @@ xfs_find_daxdev_for_inode(
  * and buffers potentially freed after every call to end_buffer_async_write.
  */
 static void
-xfs_finish_page_writeback(
+xfs_finish_buffer_writeback(
 	struct inode		*inode,
 	struct bio_vec		*bvec,
 	int			error)
@@ -166,9 +179,12 @@ xfs_destroy_ioend(
 			next = bio->bi_private;
 
 		/* walk each page on bio, ending page IO on them */
-		bio_for_each_segment_all(bvec, bio, i)
-			xfs_finish_page_writeback(inode, bvec, error);
-
+		bio_for_each_segment_all(bvec, bio, i) {
+			if (page_has_buffers(bvec->bv_page))
+				xfs_finish_buffer_writeback(inode, bvec, error);
+			else
+				xfs_finish_page_writeback(inode, bvec, error);
+		}
 		bio_put(bio);
 	}
 
@@ -792,13 +808,16 @@ xfs_writepage_map(
 {
 	LIST_HEAD(submit_list);
 	struct xfs_ioend	*ioend, *next;
-	struct buffer_head	*bh;
+	struct buffer_head	*bh = NULL;
 	ssize_t			len = i_blocksize(inode);
 	uint64_t		file_offset;	/* file offset of page */
 	unsigned		poffset;	/* offset into page */
 	int			error = 0;
 	int			count = 0;
 
+	if (page_has_buffers(page))
+		bh = page_buffers(page);
+
 	/*
 	 * Walk the blocks on the page, and if we run off the end of the current
 	 * map or find the current map invalid, grab a new one.  We only use
@@ -806,28 +825,34 @@ xfs_writepage_map(
 	 * the iteration through the page. This allows us to replace the
 	 * bufferhead with some other state tracking mechanism in future.
 	 */
-	file_offset = page_offset(page);
-	bh = page_buffers(page);
-	for (poffset = 0;
+	for (poffset = 0, file_offset = page_offset(page);
 	     poffset < PAGE_SIZE;
-	     poffset += len, file_offset += len, bh = bh->b_this_page) {
+	     poffset += len, file_offset += len) {
 		/* past the range we are writing, so nothing more to write. */
 		if (file_offset >= end_offset)
 			break;
 
-		if (!buffer_uptodate(bh)) {
+		if (bh && !buffer_uptodate(bh)) {
 			if (PageUptodate(page))
 				ASSERT(buffer_mapped(bh));
+			bh = bh->b_this_page;
 			continue;
 		}
 
 		error = xfs_map_blocks(wpc, inode, file_offset);
 		if (error)
 			break;
-		if (wpc->io_type == XFS_IO_HOLE)
+
+		if (wpc->io_type == XFS_IO_HOLE) {
+			if (bh)
+				bh = bh->b_this_page;
 			continue;
+		}
 
-		xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
+		if (bh) {
+			xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
+			bh = bh->b_this_page;
+		}
 		xfs_add_to_ioend(inode, file_offset, page, wpc, wbc,
 				&submit_list);
 		count++;
@@ -925,8 +950,6 @@ xfs_do_writepage(
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
-	ASSERT(page_has_buffers(page));
-
 	/*
 	 * Refuse to write the page out if we are called from reclaim context.
 	 *
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 10c54fc7d1b4..7fe42a126ec1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1032,7 +1032,8 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	iomap->flags |= IOMAP_F_BUFFER_HEAD;
+	if (i_blocksize(inode) < PAGE_SIZE)
+		iomap->flags |= IOMAP_F_BUFFER_HEAD;
 
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
-- 
2.18.0

