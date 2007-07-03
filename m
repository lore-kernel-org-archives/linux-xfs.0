Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 18:10:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l631APtL030589
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 18:10:27 -0700
Date: Tue, 3 Jul 2007 11:10:19 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Teach do_mpage_readpage() about unwritten buffers
Message-ID: <20070703011019.GQ989688@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lkml <linux-kernel@vger.kernel.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Teach do_mpage_readpage() about unwritten extents so we can
always map them in get_blocks rather than they are are holes on
read. Allows setup_swap_extents() to use preallocated files on XFS
filesystems for swap files without ever needing to convert them.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/mpage.c                  |    5 +++--
 fs/xfs/linux-2.6/xfs_aops.c |   13 +++----------
 2 files changed, 6 insertions(+), 12 deletions(-)

Index: 2.6.x-xfs-new/fs/mpage.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/mpage.c	2007-05-29 16:17:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/mpage.c	2007-06-27 22:39:35.568852270 +1000
@@ -207,7 +207,8 @@ do_mpage_readpage(struct bio *bio, struc
 	 * Map blocks using the result from the previous get_blocks call first.
 	 */
 	nblocks = map_bh->b_size >> blkbits;
-	if (buffer_mapped(map_bh) && block_in_file > *first_logical_block &&
+	if (buffer_mapped(map_bh) && !buffer_unwritten(map_bh) &&
+			block_in_file > *first_logical_block &&
 			block_in_file < (*first_logical_block + nblocks)) {
 		unsigned map_offset = block_in_file - *first_logical_block;
 		unsigned last = nblocks - map_offset;
@@ -242,7 +243,7 @@ do_mpage_readpage(struct bio *bio, struc
 			*first_logical_block = block_in_file;
 		}
 
-		if (!buffer_mapped(map_bh)) {
+		if (!buffer_mapped(map_bh) || buffer_unwritten(map_bh)) {
 			fully_mapped = 0;
 			if (first_hole == blocks_per_page)
 				first_hole = page_block;
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-06-05 22:14:39.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-06-27 22:39:29.545636749 +1000
@@ -1340,16 +1340,9 @@ __xfs_get_blocks(
 		return 0;
 
 	if (iomap.iomap_bn != IOMAP_DADDR_NULL) {
-		/*
-		 * For unwritten extents do not report a disk address on
-		 * the read case (treat as if we're reading into a hole).
-		 */
-		if (create || !(iomap.iomap_flags & IOMAP_UNWRITTEN)) {
-			xfs_map_buffer(bh_result, &iomap, offset,
-				       inode->i_blkbits);
-		}
-		if (create && (iomap.iomap_flags & IOMAP_UNWRITTEN)) {
-			if (direct)
+		xfs_map_buffer(bh_result, &iomap, offset, inode->i_blkbits);
+		if (iomap.iomap_flags & IOMAP_UNWRITTEN) {
+			if (create && direct)
 				bh_result->b_private = inode;
 			set_buffer_unwritten(bh_result);
 		}
