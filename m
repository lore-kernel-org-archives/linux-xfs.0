Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCSBJl232812 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:28:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE71F154E9C5
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LnKX1yqxB8V92v2t for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P9-0000mv-78
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:15 +0000
Message-Id: <20100428123015.107986898@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/11] xfs: report iomap_offset and iomap_bsize in block base
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-4
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

Report the iomap_offset and iomap_bsize fields of struct xfs_iomap
in terms of fsblocks instead of in terms of bytes.  Shift the byte
conversions into the callers temporarily, but they will disappear
or get cleaned up later.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 17:07:53.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 17:13:15.434005637 +0200
@@ -319,11 +319,16 @@ xfs_map_blocks(
 
 STATIC int
 xfs_iomap_valid(
+	struct inode		*inode,
 	xfs_iomap_t		*iomapp,
 	loff_t			offset)
 {
-	return offset >= iomapp->iomap_offset &&
-		offset < iomapp->iomap_offset + iomapp->iomap_bsize;
+	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+	xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, iomapp->iomap_offset);
+	xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, iomapp->iomap_bsize);
+
+	return offset >= iomap_offset &&
+		offset < iomap_offset + iomap_bsize;
 }
 
 /*
@@ -560,11 +565,13 @@ xfs_map_buffer(
 	xfs_off_t		offset)
 {
 	sector_t		bn;
+	struct xfs_mount	*m = XFS_I(inode)->i_mount;
+	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, mp->iomap_offset);
 
 	ASSERT(mp->iomap_bn != IOMAP_DADDR_NULL);
 
 	bn = (mp->iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
-	      ((offset - mp->iomap_offset) >> inode->i_blkbits);
+	      ((offset - iomap_offset) >> inode->i_blkbits);
 
 	ASSERT(bn || XFS_IS_REALTIME_INODE(XFS_I(inode)));
 
@@ -805,7 +812,7 @@ xfs_convert_page(
 			else
 				type = IOMAP_DELAY;
 
-			if (!xfs_iomap_valid(mp, offset)) {
+			if (!xfs_iomap_valid(inode, mp, offset)) {
 				done = 1;
 				continue;
 			}
@@ -1115,7 +1122,7 @@ xfs_page_state_convert(
 		}
 
 		if (iomap_valid)
-			iomap_valid = xfs_iomap_valid(&iomap, offset);
+			iomap_valid = xfs_iomap_valid(inode, &iomap, offset);
 
 		/*
 		 * First case, map an unwritten extent and prepare for
@@ -1170,7 +1177,7 @@ xfs_page_state_convert(
 						&iomap, flags);
 				if (err)
 					goto error;
-				iomap_valid = xfs_iomap_valid(&iomap, offset);
+				iomap_valid = xfs_iomap_valid(inode, &iomap, offset);
 			}
 			if (iomap_valid) {
 				xfs_map_at_offset(inode, bh, &iomap, offset);
@@ -1200,7 +1207,7 @@ xfs_page_state_convert(
 						&iomap, flags);
 				if (err)
 					goto error;
-				iomap_valid = xfs_iomap_valid(&iomap, offset);
+				iomap_valid = xfs_iomap_valid(inode, &iomap, offset);
 			}
 
 			/*
@@ -1240,7 +1247,11 @@ xfs_page_state_convert(
 		xfs_start_page_writeback(page, 1, count);
 
 	if (ioend && iomap_valid) {
-		offset = (iomap.iomap_offset + iomap.iomap_bsize - 1) >>
+		struct xfs_mount	*m = XFS_I(inode)->i_mount;
+		xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, iomap.iomap_offset);
+		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(m, iomap.iomap_bsize);
+
+		offset = (iomap_offset + iomap_bsize - 1) >>
 					PAGE_CACHE_SHIFT;
 		tlast = min_t(pgoff_t, offset, last_index);
 		xfs_cluster_write(inode, page->index + 1, &iomap, &ioend,
@@ -1511,11 +1522,14 @@ __xfs_get_blocks(
 	}
 
 	if (direct || size > (1 << inode->i_blkbits)) {
-		xfs_off_t iomap_delta = offset - iomap.iomap_offset;
+		struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+		xfs_off_t		iomap_offset = XFS_FSB_TO_B(mp, iomap.iomap_offset);
+		xfs_off_t		iomap_delta = offset - iomap_offset;
+		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(mp, iomap.iomap_bsize);
 
-		ASSERT(iomap.iomap_bsize - iomap_delta > 0);
+		ASSERT(iomap_bsize - iomap_delta > 0);
 		offset = min_t(xfs_off_t,
-				iomap.iomap_bsize - iomap_delta, size);
+				iomap_bsize - iomap_delta, size);
 		bh_result->b_size = (ssize_t)min_t(xfs_off_t, LONG_MAX, offset);
 	}
 
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-27 17:08:03.000000000 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-04-27 17:12:58.858068081 +0200
@@ -64,11 +64,10 @@ xfs_imap_to_bmap(
 	int		imaps,			/* Number of imap entries */
 	int		flags)
 {
-	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fsblock_t	start_block;
 
-	iomapp->iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
-	iomapp->iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	iomapp->iomap_offset = imap->br_startoff;
+	iomapp->iomap_bsize = imap->br_blockcount;
 	iomapp->iomap_flags = flags;
 
 	start_block = imap->br_startblock;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
