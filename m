Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbeGBO6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 10:58:21 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/22] xfs: rename the offset variable in xfs_writepage_map
Date: Mon,  2 Jul 2018 08:58:00 -0600
Message-Id: <20180702145813.22496-10-hch@lst.de>
In-Reply-To: <20180702145813.22496-1-hch@lst.de>
References: <20180702145813.22496-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Calling it file_offset makes the usage more clear, especially with
a new poffset variable that will be added soon for the offset inside
the page.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 65454a4f4d93..4dc5fcff226e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -823,15 +823,15 @@ xfs_writepage_map(
 	struct xfs_ioend	*ioend, *next;
 	struct buffer_head	*bh, *head;
 	ssize_t			len = i_blocksize(inode);
-	uint64_t		offset;	/* file offset of page */
+	uint64_t		file_offset;	/* file offset of page */
 	int			error = 0;
 	int			count = 0;
 	unsigned int		new_type;
 
 	bh = head = page_buffers(page);
-	offset = page_offset(page);
+	file_offset = page_offset(page);
 	do {
-		if (offset >= end_offset)
+		if (file_offset >= end_offset)
 			break;
 
 		/*
@@ -863,7 +863,7 @@ xfs_writepage_map(
 		 * If we already have a valid COW mapping keep using it.
 		 */
 		if (wpc->io_type == XFS_IO_COW &&
-		    xfs_imap_valid(inode, &wpc->imap, offset)) {
+		    xfs_imap_valid(inode, &wpc->imap, file_offset)) {
 			wpc->imap_valid = true;
 			new_type = XFS_IO_COW;
 		}
@@ -875,7 +875,7 @@ xfs_writepage_map(
 
 		if (wpc->imap_valid)
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 offset);
+							 file_offset);
 
 		/*
 		 * COW fork blocks can overlap data fork blocks even if the
@@ -886,11 +886,11 @@ xfs_writepage_map(
 		if (!wpc->imap_valid ||
 		    (xfs_is_reflink_inode(XFS_I(inode)) &&
 		     wpc->io_type != XFS_IO_COW)) {
-			error = xfs_map_blocks(wpc, inode, offset);
+			error = xfs_map_blocks(wpc, inode, file_offset);
 			if (error)
 				goto out;
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 offset);
+							 file_offset);
 		}
 
 		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE)
@@ -898,10 +898,10 @@ xfs_writepage_map(
 
 		lock_buffer(bh);
 		if (wpc->io_type != XFS_IO_OVERWRITE)
-			xfs_map_at_offset(inode, bh, &wpc->imap, offset);
-		xfs_add_to_ioend(inode, bh, offset, wpc, wbc, &submit_list);
+			xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
+		xfs_add_to_ioend(inode, bh, file_offset, wpc, wbc, &submit_list);
 		count++;
-	} while (offset += len, ((bh = bh->b_this_page) != head));
+	} while (file_offset += len, ((bh = bh->b_this_page) != head));
 
 	ASSERT(wpc->ioend || list_empty(&submit_list));
 
-- 
2.18.0

