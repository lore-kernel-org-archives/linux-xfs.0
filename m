Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755954AbeEaSIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:08:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/21] xfs: simplify xfs_aops_discard_page
Date: Thu, 31 May 2018 20:07:42 +0200
Message-Id: <20180531180759.21631-5-hch@lst.de>
In-Reply-To: <20180531180759.21631-1-hch@lst.de>
References: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Instead of looking at the buffer heads to see if a block is delalloc just
call xfs_bmap_punch_delalloc_range on the whole page - this will leave
any non-delalloc block intact and handle the iteration for us.  As a side
effect one more place stops caring about buffer heads and we can remove the
xfs_check_page_type function entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 85 +++++------------------------------------------
 1 file changed, 9 insertions(+), 76 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c631c457b444..f2333e351e07 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -711,49 +711,6 @@ xfs_map_at_offset(
 	clear_buffer_unwritten(bh);
 }
 
-/*
- * Test if a given page contains at least one buffer of a given @type.
- * If @check_all_buffers is true, then we walk all the buffers in the page to
- * try to find one of the type passed in. If it is not set, then the caller only
- * needs to check the first buffer on the page for a match.
- */
-STATIC bool
-xfs_check_page_type(
-	struct page		*page,
-	unsigned int		type,
-	bool			check_all_buffers)
-{
-	struct buffer_head	*bh;
-	struct buffer_head	*head;
-
-	if (PageWriteback(page))
-		return false;
-	if (!page->mapping)
-		return false;
-	if (!page_has_buffers(page))
-		return false;
-
-	bh = head = page_buffers(page);
-	do {
-		if (buffer_unwritten(bh)) {
-			if (type == XFS_IO_UNWRITTEN)
-				return true;
-		} else if (buffer_delay(bh)) {
-			if (type == XFS_IO_DELALLOC)
-				return true;
-		} else if (buffer_dirty(bh) && buffer_mapped(bh)) {
-			if (type == XFS_IO_OVERWRITE)
-				return true;
-		}
-
-		/* If we are only checking the first buffer, we are done now. */
-		if (!check_all_buffers)
-			break;
-	} while ((bh = bh->b_this_page) != head);
-
-	return false;
-}
-
 STATIC void
 xfs_vm_invalidatepage(
 	struct page		*page,
@@ -785,9 +742,6 @@ xfs_vm_invalidatepage(
  * transaction. Indeed - if we get ENOSPC errors, we have to be able to do this
  * truncation without a transaction as there is no space left for block
  * reservation (typically why we see a ENOSPC in writeback).
- *
- * This is not a performance critical path, so for now just do the punching a
- * buffer head at a time.
  */
 STATIC void
 xfs_aops_discard_page(
@@ -795,47 +749,26 @@ xfs_aops_discard_page(
 {
 	struct inode		*inode = page->mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct buffer_head	*bh, *head;
+	struct xfs_mount	*mp = ip->i_mount;
 	loff_t			offset = page_offset(page);
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	int			error;
 
-	if (!xfs_check_page_type(page, XFS_IO_DELALLOC, true))
-		goto out_invalidate;
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (XFS_FORCED_SHUTDOWN(mp))
 		goto out_invalidate;
 
-	xfs_alert(ip->i_mount,
+	xfs_alert(mp,
 		"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
 			page, ip->i_ino, offset);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	bh = head = page_buffers(page);
-	do {
-		int		error;
-		xfs_fileoff_t	start_fsb;
-
-		if (!buffer_delay(bh))
-			goto next_buffer;
-
-		start_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb, 1);
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_alert(ip->i_mount,
-			"page discard unable to remove delalloc mapping.");
-			}
-			break;
-		}
-next_buffer:
-		offset += i_blocksize(inode);
-
-	} while ((bh = bh->b_this_page) != head);
-
+	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+			PAGE_SIZE / i_blocksize(inode));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error && !XFS_FORCED_SHUTDOWN(mp))
+		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 out_invalidate:
 	xfs_vm_invalidatepage(page, 0, PAGE_SIZE);
-	return;
 }
 
 static int
-- 
2.17.0

