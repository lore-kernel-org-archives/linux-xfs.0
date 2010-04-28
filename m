Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCUHH3233042 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:30:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3924F2F988F
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ar8naoPpuYhx2vag for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P8-0000lg-S7
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:14 +0000
Message-Id: <20100428123014.699705209@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/11] xfs: remove iomap_target
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-2
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

Instead of using the iomap_target field in struct xfs_iomap and the
IOMAP_REALTIME flag just use the already existing xfs_find_bdev_for_inode
helper.  There's some fallout as we need to pass the inode in a few more
places, which we also use to sanitize some calling conventions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 14:14:17.050004169 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 14:14:43.975254833 +0200
@@ -102,8 +102,9 @@ xfs_count_page_state(
 
 STATIC struct block_device *
 xfs_find_bdev_for_inode(
-	struct xfs_inode	*ip)
+	struct inode		*inode)
 {
+	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 
 	if (XFS_IS_REALTIME_INODE(ip))
@@ -553,19 +554,19 @@ xfs_add_to_ioend(
 
 STATIC void
 xfs_map_buffer(
+	struct inode		*inode,
 	struct buffer_head	*bh,
 	xfs_iomap_t		*mp,
-	xfs_off_t		offset,
-	uint			block_bits)
+	xfs_off_t		offset)
 {
 	sector_t		bn;
 
 	ASSERT(mp->iomap_bn != IOMAP_DADDR_NULL);
 
-	bn = (mp->iomap_bn >> (block_bits - BBSHIFT)) +
-	      ((offset - mp->iomap_offset) >> block_bits);
+	bn = (mp->iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
+	      ((offset - mp->iomap_offset) >> inode->i_blkbits);
 
-	ASSERT(bn || (mp->iomap_flags & IOMAP_REALTIME));
+	ASSERT(bn || XFS_IS_REALTIME_INODE(XFS_I(inode)));
 
 	bh->b_blocknr = bn;
 	set_buffer_mapped(bh);
@@ -573,17 +574,17 @@ xfs_map_buffer(
 
 STATIC void
 xfs_map_at_offset(
+	struct inode		*inode,
 	struct buffer_head	*bh,
-	loff_t			offset,
-	int			block_bits,
-	xfs_iomap_t		*iomapp)
+	xfs_iomap_t		*iomapp,
+	xfs_off_t		offset)
 {
 	ASSERT(!(iomapp->iomap_flags & IOMAP_HOLE));
 	ASSERT(!(iomapp->iomap_flags & IOMAP_DELAY));
 
 	lock_buffer(bh);
-	xfs_map_buffer(bh, iomapp, offset, block_bits);
-	bh->b_bdev = iomapp->iomap_target->bt_bdev;
+	xfs_map_buffer(inode, bh, iomapp, offset);
+	bh->b_bdev = xfs_find_bdev_for_inode(inode);
 	set_buffer_mapped(bh);
 	clear_buffer_delay(bh);
 	clear_buffer_unwritten(bh);
@@ -749,7 +750,6 @@ xfs_convert_page(
 	xfs_off_t		end_offset;
 	unsigned long		p_offset;
 	unsigned int		type;
-	int			bbits = inode->i_blkbits;
 	int			len, page_dirty;
 	int			count = 0, done = 0, uptodate = 1;
  	xfs_off_t		offset = page_offset(page);
@@ -813,7 +813,7 @@ xfs_convert_page(
 			ASSERT(!(mp->iomap_flags & IOMAP_HOLE));
 			ASSERT(!(mp->iomap_flags & IOMAP_DELAY));
 
-			xfs_map_at_offset(bh, offset, bbits, mp);
+			xfs_map_at_offset(inode, bh, mp, offset);
 			if (startio) {
 				xfs_add_to_ioend(inode, bh, offset,
 						type, ioendp, done);
@@ -1173,8 +1173,7 @@ xfs_page_state_convert(
 				iomap_valid = xfs_iomap_valid(&iomap, offset);
 			}
 			if (iomap_valid) {
-				xfs_map_at_offset(bh, offset,
-						inode->i_blkbits, &iomap);
+				xfs_map_at_offset(inode, bh, &iomap, offset);
 				if (startio) {
 					xfs_add_to_ioend(inode, bh, offset,
 							type, &ioend,
@@ -1472,10 +1471,8 @@ __xfs_get_blocks(
 		 * For unwritten extents do not report a disk address on
 		 * the read case (treat as if we're reading into a hole).
 		 */
-		if (create || !(iomap.iomap_flags & IOMAP_UNWRITTEN)) {
-			xfs_map_buffer(bh_result, &iomap, offset,
-				       inode->i_blkbits);
-		}
+		if (create || !(iomap.iomap_flags & IOMAP_UNWRITTEN))
+			xfs_map_buffer(inode, bh_result, &iomap, offset);
 		if (create && (iomap.iomap_flags & IOMAP_UNWRITTEN)) {
 			if (direct)
 				bh_result->b_private = inode;
@@ -1487,7 +1484,7 @@ __xfs_get_blocks(
 	 * If this is a realtime file, data may be on a different device.
 	 * to that pointed to from the buffer_head b_bdev currently.
 	 */
-	bh_result->b_bdev = iomap.iomap_target->bt_bdev;
+	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
 
 	/*
 	 * If we previously allocated a block out beyond eof and we are now
@@ -1611,7 +1608,7 @@ xfs_vm_direct_IO(
 	struct block_device *bdev;
 	ssize_t		ret;
 
-	bdev = xfs_find_bdev_for_inode(XFS_I(inode));
+	bdev = xfs_find_bdev_for_inode(inode);
 
 	iocb->private = xfs_alloc_ioend(inode, rw == WRITE ?
 					IOMAP_UNWRITTEN : IOMAP_READ);
Index: xfs/fs/xfs/xfs_iomap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.c	2010-04-28 14:14:38.708003332 +0200
+++ xfs/fs/xfs/xfs_iomap.c	2010-04-28 14:14:43.976254414 +0200
@@ -72,12 +72,6 @@ xfs_imap_to_bmap(
 	iomapp->iomap_bsize = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomapp->iomap_flags = flags;
 
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		iomapp->iomap_flags |= IOMAP_REALTIME;
-		iomapp->iomap_target = mp->m_rtdev_targp;
-	} else {
-		iomapp->iomap_target = mp->m_ddev_targp;
-	}
 	start_block = imap->br_startblock;
 	if (start_block == HOLESTARTBLOCK) {
 		iomapp->iomap_bn = IOMAP_DADDR_NULL;
Index: xfs/fs/xfs/xfs_iomap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iomap.h	2010-04-28 14:14:17.430004169 +0200
+++ xfs/fs/xfs/xfs_iomap.h	2010-04-28 14:14:43.982253995 +0200
@@ -25,7 +25,6 @@ typedef enum {				/* iomap_flags values
 	IOMAP_READ =		0,	/* mapping for a read */
 	IOMAP_HOLE =		0x02,	/* mapping covers a hole  */
 	IOMAP_DELAY =		0x04,	/* mapping covers delalloc region  */
-	IOMAP_REALTIME =	0x10,	/* mapping on the realtime device  */
 	IOMAP_UNWRITTEN =	0x20,	/* mapping covers allocated */
 					/* but uninitialized file data  */
 	IOMAP_NEW =		0x40	/* just allocate */
@@ -71,7 +70,6 @@ typedef enum {
 
 typedef struct xfs_iomap {
 	xfs_daddr_t		iomap_bn;	/* first 512B blk of mapping */
-	xfs_buftarg_t		*iomap_target;
 	xfs_off_t		iomap_offset;	/* offset of mapping, bytes */
 	xfs_off_t		iomap_bsize;	/* size of mapping, bytes */
 	xfs_off_t		iomap_delta;	/* offset into mapping, bytes */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
