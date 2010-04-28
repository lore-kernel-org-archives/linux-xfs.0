Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCUMiV233075 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:30:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A99E2F9891
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QNU5LlTaNdEfZtSu for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76PA-0000pj-1j
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:16 +0000
Message-Id: <20100428123015.969557658@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/11] xfs: clean up xfs_iomap_valid
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-9
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

Rename all iomap_valid identifiers to imap_valid to fit the new world order,
and clean up xfs_iomap_valid to convert the passed in offset to blocks
instead of the imap values to bytes.  Use the simpler inode->i_blkbits
instead of the XFS macros for this.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:42.130254345 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:49.296003890 +0200
@@ -328,17 +328,15 @@ xfs_map_blocks(
 }
 
 STATIC int
-xfs_iomap_valid(
+xfs_imap_valid(
 	struct inode		*inode,
 	struct xfs_bmbt_irec	*imap,
-	loff_t			offset)
+	xfs_off_t		offset)
 {
-	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
-	xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
-	xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	offset >>= inode->i_blkbits;
 
-	return offset >= iomap_offset &&
-		offset < iomap_offset + iomap_bsize;
+	return offset >= imap->br_startoff &&
+		offset < imap->br_startoff + imap->br_blockcount;
 }
 
 /*
@@ -824,7 +822,7 @@ xfs_convert_page(
 			else
 				type = IO_DELAY;
 
-			if (!xfs_iomap_valid(inode, imap, offset)) {
+			if (!xfs_imap_valid(inode, imap, offset)) {
 				done = 1;
 				continue;
 			}
@@ -1068,7 +1066,7 @@ xfs_page_state_convert(
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index, tlast;
 	ssize_t			size, len;
-	int			flags, err, iomap_valid = 0, uptodate = 1;
+	int			flags, err, imap_valid = 0, uptodate = 1;
 	int			page_dirty, count = 0;
 	int			trylock = 0;
 	int			all_bh = unmapped;
@@ -1129,12 +1127,12 @@ xfs_page_state_convert(
 			 * the iomap is actually still valid, but the ioend
 			 * isn't.  shouldn't happen too often.
 			 */
-			iomap_valid = 0;
+			imap_valid = 0;
 			continue;
 		}
 
-		if (iomap_valid)
-			iomap_valid = xfs_iomap_valid(inode, &imap, offset);
+		if (imap_valid)
+			imap_valid = xfs_imap_valid(inode, &imap, offset);
 
 		/*
 		 * First case, map an unwritten extent and prepare for
@@ -1155,7 +1153,7 @@ xfs_page_state_convert(
 			 * Make sure we don't use a read-only iomap
 			 */
 			if (flags == BMAPI_READ)
-				iomap_valid = 0;
+				imap_valid = 0;
 
 			if (buffer_unwritten(bh)) {
 				type = IO_UNWRITTEN;
@@ -1168,7 +1166,7 @@ xfs_page_state_convert(
 				flags = BMAPI_WRITE | BMAPI_MMAP;
 			}
 
-			if (!iomap_valid) {
+			if (!imap_valid) {
 				/*
 				 * if we didn't have a valid mapping then we
 				 * need to ensure that we put the new mapping
@@ -1189,9 +1187,10 @@ xfs_page_state_convert(
 						&imap, flags);
 				if (err)
 					goto error;
-				iomap_valid = xfs_iomap_valid(inode, &imap, offset);
+				imap_valid = xfs_imap_valid(inode, &imap,
+							    offset);
 			}
-			if (iomap_valid) {
+			if (imap_valid) {
 				xfs_map_at_offset(inode, bh, &imap, offset);
 				if (startio) {
 					xfs_add_to_ioend(inode, bh, offset,
@@ -1211,7 +1210,7 @@ xfs_page_state_convert(
 			 * That means it must already have extents allocated
 			 * underneath it. Map the extent by reading it.
 			 */
-			if (!iomap_valid || flags != BMAPI_READ) {
+			if (!imap_valid || flags != BMAPI_READ) {
 				flags = BMAPI_READ;
 				size = xfs_probe_cluster(inode, page, bh,
 								head, 1);
@@ -1219,7 +1218,8 @@ xfs_page_state_convert(
 						&imap, flags);
 				if (err)
 					goto error;
-				iomap_valid = xfs_iomap_valid(inode, &imap, offset);
+				imap_valid = xfs_imap_valid(inode, &imap,
+							    offset);
 			}
 
 			/*
@@ -1233,18 +1233,18 @@ xfs_page_state_convert(
 			type = IO_NEW;
 			if (trylock_buffer(bh)) {
 				ASSERT(buffer_mapped(bh));
-				if (iomap_valid)
+				if (imap_valid)
 					all_bh = 1;
 				xfs_add_to_ioend(inode, bh, offset, type,
-						&ioend, !iomap_valid);
+						&ioend, !imap_valid);
 				page_dirty--;
 				count++;
 			} else {
-				iomap_valid = 0;
+				imap_valid = 0;
 			}
 		} else if ((buffer_uptodate(bh) || PageUptodate(page)) &&
 			   (unmapped || startio)) {
-			iomap_valid = 0;
+			imap_valid = 0;
 		}
 
 		if (!iohead)
@@ -1258,7 +1258,7 @@ xfs_page_state_convert(
 	if (startio)
 		xfs_start_page_writeback(page, 1, count);
 
-	if (ioend && iomap_valid) {
+	if (ioend && imap_valid) {
 		struct xfs_mount	*m = XFS_I(inode)->i_mount;
 		xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap.br_startoff);
 		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(m, imap.br_blockcount);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
