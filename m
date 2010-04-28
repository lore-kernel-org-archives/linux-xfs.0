Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCSBOe232819 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:28:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02A31154E9C0
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bSH3ulYi3E5XjUBT for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P9-0000nW-Dz
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:15 +0000
Message-Id: <20100428123015.330173874@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/11] xfs: report iomap_bn in block base
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-5
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

Report the iomap_bn field of struct xfs_iomap in terms of filesystem blocks
instead of in terms of bytes.  Shift the byte conversions into the caller,
and replace the IOMAP_DELAY and IOMAP_HOLE flag checks with checks for
HOLESTARTBLOCK and DELAYSTARTBLOCK.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 17:39:18.329254483 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-27 17:39:20.699003542 +0200
@@ -567,10 +567,12 @@ xfs_map_buffer(
 	sector_t		bn;
 	struct xfs_mount	*m = XFS_I(inode)->i_mount;
 	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, mp->iomap_offset);
+	xfs_daddr_t		iomap_bn = xfs_fsb_to_db(XFS_I(inode), mp->iomap_bn);
 
-	ASSERT(mp->iomap_bn != IOMAP_DADDR_NULL);
+	ASSERT(mp->iomap_bn != HOLESTARTBLOCK);
+	ASSERT(mp->iomap_bn != DELAYSTARTBLOCK);
 
-	bn = (mp->iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
+	bn = (iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
 	      ((offset - iomap_offset) >> inode->i_blkbits);
 
 	ASSERT(bn || XFS_IS_REALTIME_INODE(XFS_I(inode)));
@@ -586,8 +588,8 @@ xfs_map_at_offset(
 	xfs_iomap_t		*iomapp,
 	xfs_off_t		offset)
 {
-	ASSERT(!(iomapp->iomap_flags & IOMAP_HOLE));
-	ASSERT(!(iomapp->iomap_flags & IOMAP_DELAY));
+	ASSERT(iomapp->iomap_bn != HOLESTARTBLOCK);
+	ASSERT(iomapp->iomap_bn != DELAYSTARTBLOCK);
 
 	lock_buffer(bh);
 	xfs_map_buffer(inode, bh, iomapp, offset);
@@ -817,8 +819,8 @@ xfs_convert_page(
 				continue;
 			}
 
-			ASSERT(!(mp->iomap_flags & IOMAP_HOLE));
-			ASSERT(!(mp->iomap_flags & IOMAP_DELAY));
+			ASSERT(mp->iomap_bn != HOLESTARTBLOCK);
+			ASSERT(mp->iomap_bn != DELAYSTARTBLOCK);
 
 			xfs_map_at_offset(inode, bh, mp, offset);
 			if (startio) {
@@ -1477,7 +1479,8 @@ __xfs_get_blocks(
 	if (niomap == 0)
 		return 0;
 
-	if (iomap.iomap_bn != IOMAP_DADDR_NULL) {
+	if (iomap.iomap_bn != HOLESTARTBLOCK &&
+	    iomap.iomap_bn != DELAYSTARTBLOCK) {
 		/*
 		 * For unwritten extents do not report a disk address on
 		 * the read case (treat as if we're reading into a hole).
@@ -1512,7 +1515,7 @@ __xfs_get_blocks(
 	     (iomap.iomap_flags & (IOMAP_NEW|IOMAP_UNWRITTEN))))
 		set_buffer_new(bh_result);
 
-	if (iomap.iomap_flags & IOMAP_DELAY) {
+	if (iomap.iomap_bn == DELAYSTARTBLOCK) {
 		BUG_ON(direct);
 		if (create) {
 			set_buffer_uptodate(bh_result);
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-27 17:39:18.313003820 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-04-27 17:39:20.700004101 +0200
@@ -64,24 +64,15 @@ xfs_imap_to_bmap(
 	int		imaps,			/* Number of imap entries */
 	int		flags)
 {
-	xfs_fsblock_t	start_block;
-
 	iomapp->iomap_offset = imap->br_startoff;
 	iomapp->iomap_bsize = imap->br_blockcount;
 	iomapp->iomap_flags = flags;
+	iomapp->iomap_bn = imap->br_startblock;
 
-	start_block = imap->br_startblock;
-	if (start_block == HOLESTARTBLOCK) {
-		iomapp->iomap_bn = IOMAP_DADDR_NULL;
-		iomapp->iomap_flags |= IOMAP_HOLE;
-	} else if (start_block == DELAYSTARTBLOCK) {
-		iomapp->iomap_bn = IOMAP_DADDR_NULL;
-		iomapp->iomap_flags |= IOMAP_DELAY;
-	} else {
-		iomapp->iomap_bn = xfs_fsb_to_db(ip, start_block);
-		if (ISUNWRITTEN(imap))
-			iomapp->iomap_flags |= IOMAP_UNWRITTEN;
-	}
+	if (imap->br_startblock != HOLESTARTBLOCK &&
+	    imap->br_startblock != DELAYSTARTBLOCK &&
+	    ISUNWRITTEN(imap))
+		iomapp->iomap_flags |= IOMAP_UNWRITTEN;
 }
 
 int
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-04-27 17:39:18.339273969 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-04-27 17:39:27.783067167 +0200
@@ -18,12 +18,8 @@
 #ifndef __XFS_IOMAP_H__
 #define __XFS_IOMAP_H__
 
-#define IOMAP_DADDR_NULL ((xfs_daddr_t) (-1LL))
-
-
 typedef enum {				/* iomap_flags values */
 	IOMAP_READ =		0,	/* mapping for a read */
-	IOMAP_HOLE =		0x02,	/* mapping covers a hole  */
 	IOMAP_DELAY =		0x04,	/* mapping covers delalloc region  */
 	IOMAP_UNWRITTEN =	0x20,	/* mapping covers allocated */
 					/* but uninitialized file data  */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
