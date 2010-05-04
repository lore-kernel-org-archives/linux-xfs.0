Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o44DpetU230405 for <xfs@oss.sgi.com>; Tue, 4 May 2010 08:51:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D412F30C23C
	for <xfs@oss.sgi.com>; Tue,  4 May 2010 06:53:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BdY5xV8IWNQYPstO for
	<xfs@oss.sgi.com>; Tue, 04 May 2010 06:53:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O9IZI-0005Hl-E9
	for xfs@oss.sgi.com; Tue, 04 May 2010 13:53:48 +0000
Date: Tue, 4 May 2010 09:53:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs: cleanup log reservation calculactions
Message-ID: <20100504135348.GA18991@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Instead of having small helper functions calling big macros do the
calculations for the log reservations directly in the functions.  These
are mostly 1:1 from the macros execept that the macros kept the quota
calculations in their callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-05-04 15:47:36.143004267 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-05-04 15:49:00.118253812 +0200
@@ -49,134 +49,489 @@
 
 kmem_zone_t	*xfs_trans_zone;
 
+
+/*
+ * Various log reservation values.
+ *
+ * These are based on the size of the file system block because that is what
+ * most transactions manipulate.  Each adds in an additional 128 bytes per
+ * item logged to try to account for the overhead of the transaction mechanism.
+ *
+ * Note:  Most of the reservations underestimate the number of allocation
+ * groups into which they could free extents in the xfs_bmap_finish() call.
+ * This is because the number in the worst case is quite high and quite
+ * unusual.  In order to fix this we need to change xfs_bmap_finish() to free
+ * extents in only a single AG at a time.  This will require changes to the
+ * EFI code as well, however, so that the EFI for the extents not freed is
+ * logged again in each transaction.  See SGI PV #261917.
+ *
+ * Reservation functions here avoid a huge stack in xfs_trans_init due to
+ * register overflow from temporaries in the calculations.
+ */
+
+
 /*
- * Reservation functions here avoid a huge stack in xfs_trans_init
- * due to register overflow from temporaries in the calculations.
+ * In a write transaction we can allocate a maximum of 2
+ * extents.  This gives:
+ *    the inode getting the new extents: inode size
+ *    the inode's bmap btree: max depth * block size
+ *    the agfs of the ags from which the extents are allocated: 2 * sector
+ *    the superblock free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ * And the bmap_finish transaction can free bmap blocks in a join:
+ *    the agfs of the ags containing the blocks: 2 * sector size
+ *    the agfls of the ags containing the blocks: 2 * sector size
+ *    the super block free block counter: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
  */
 STATIC uint
-xfs_calc_write_reservation(xfs_mount_t *mp)
+xfs_calc_write_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_WRITE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 2))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * In truncating a file we free up to two extents at once.  We can modify:
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: (max depth + 1) * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_itruncate_reservation(xfs_mount_t *mp)
+xfs_calc_itruncate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ITRUNCATE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) +
+		     128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		    (4 * mp->m_sb.sb_sectsize +
+		     4 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 4) +
+		     128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4)) +
+		     128 * 5 +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * In renaming a files we can modify:
+ *    the four inodes involved: 4 * inode size
+ *    the two directory btrees: 2 * (max depth + v2) * dir block size
+ *    the two directory bmap btrees: 2 * max depth * block size
+ * And the bmap_finish transaction can free dir and bmap blocks (two sets
+ *	of bmap blocks) giving:
+ *    the agf for the ags in which the blocks live: 3 * sector size
+ *    the agfl for the ags in which the blocks live: 3 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_rename_reservation(xfs_mount_t *mp)
+xfs_calc_rename_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_RENAME_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((4 * mp->m_sb.sb_inodesize +
+		     2 * XFS_DIROP_LOG_RES(mp) +
+		     128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp))),
+		    (3 * mp->m_sb.sb_sectsize +
+		     3 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 3) +
+		     128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))));
 }
 
+/*
+ * For creating a link to an inode:
+ *    the parent directory inode: inode size
+ *    the linked inode: inode size
+ *    the directory btree could split: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free some bmap blocks giving:
+ *    the agf for the ag in which the blocks live: sector size
+ *    the agfl for the ag in which the blocks live: sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_link_reservation(xfs_mount_t *mp)
+xfs_calc_link_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_LINK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		    (mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * For removing a directory entry we can modify:
+ *    the parent directory inode: inode size
+ *    the removed inode: inode size
+ *    the directory btree could join: (max depth + v2) * dir block size
+ *    the directory bmap btree could join or split: (max depth + v2) * blocksize
+ * And the bmap_finish transaction can free the dir and bmap blocks giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_remove_reservation(xfs_mount_t *mp)
+xfs_calc_remove_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_REMOVE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * For symlink we can modify:
+ *    the parent directory inode: inode size
+ *    the new inode: inode size
+ *    the inode btree entry: 1 block
+ *    the directory btree: (max depth + v2) * dir block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ *    the blocks for the symlink: 1 kB
+ * Or in the first xact we allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_symlink_reservation(xfs_mount_t *mp)
+xfs_calc_symlink_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_SYMLINK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, 1) +
+		     XFS_DIROP_LOG_RES(mp) +
+		     1024 +
+		     128 * (4 + XFS_DIROP_LOG_COUNT(mp))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
+		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * For create we can modify:
+ *    the parent directory inode: inode size
+ *    the new inode: inode size
+ *    the inode btree entry: block size
+ *    the superblock for the nlink flag: sector size
+ *    the directory btree: (max depth + v2) * dir block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ * Or in the first xact we allocate some inodes giving:
+ *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the superblock for the nlink flag: sector size
+ *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_create_reservation(xfs_mount_t *mp)
+xfs_calc_create_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_CREATE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_inodesize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, 1) +
+		     XFS_DIROP_LOG_RES(mp) +
+		     128 * (3 + XFS_DIROP_LOG_COUNT(mp))),
+		    (3 * mp->m_sb.sb_sectsize +
+		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
+		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
+		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
+/*
+ * Making a new directory is the same as creating a new file.
+ */
 STATIC uint
-xfs_calc_mkdir_reservation(xfs_mount_t *mp)
+xfs_calc_mkdir_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_MKDIR_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return xfs_calc_create_reservation(mp);
 }
 
+/*
+ * In freeing an inode we can modify:
+ *    the inode being freed: inode size
+ *    the super block free inode counter: sector size
+ *    the agi hash list and counters: sector size
+ *    the inode btree entry: block size
+ *    the on disk inode before ours in the agi hash list: inode cluster size
+ *    the inode btree: max depth * blocksize
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_ifree_reservation(xfs_mount_t *mp)
+xfs_calc_ifree_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_IFREE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, 1) +
+		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
+		    XFS_INODE_CLUSTER_SIZE(mp)) +
+		128 * 5 +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * When only changing the inode we log the inode and possibly the superblock
+ * We also add a bit of slop for the transaction stuff.
+ */
 STATIC uint
-xfs_calc_ichange_reservation(xfs_mount_t *mp)
+xfs_calc_ichange_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ICHANGE_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		512;
+
 }
 
+/*
+ * Growing the data section of the filesystem.
+ *	superblock
+ *	agi and agf
+ *	allocation btrees
+ */
 STATIC uint
-xfs_calc_growdata_reservation(xfs_mount_t *mp)
+xfs_calc_growdata_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWDATA_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize * 3 +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the first set of transactions (ALLOC) we allocate space to the
+ * bitmap or summary files.
+ *	superblock: sector size
+ *	agf of the ag from which the extent is allocated: sector size
+ *	bmap btree for bitmap/summary inode: max depth * blocksize
+ *	bitmap/summary inode: inode size
+ *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
+ */
 STATIC uint
-xfs_calc_growrtalloc_reservation(xfs_mount_t *mp)
+xfs_calc_growrtalloc_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTALLOC_LOG_RES(mp);
+	return 2 * mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
+		mp->m_sb.sb_inodesize +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the second set of transactions (ZERO) we zero the new metadata blocks.
+ *	one bitmap/summary block: blocksize
+ */
 STATIC uint
-xfs_calc_growrtzero_reservation(xfs_mount_t *mp)
+xfs_calc_growrtzero_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTZERO_LOG_RES(mp);
+	return mp->m_sb.sb_blocksize + 128;
 }
 
+/*
+ * Growing the rt section of the filesystem.
+ * In the third set of transactions (FREE) we update metadata without
+ * allocating any new blocks.
+ *	superblock: sector size
+ *	bitmap inode: inode size
+ *	summary inode: inode size
+ *	one bitmap block: blocksize
+ *	summary blocks: new summary size
+ */
 STATIC uint
-xfs_calc_growrtfree_reservation(xfs_mount_t *mp)
+xfs_calc_growrtfree_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_GROWRTFREE_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize +
+		2 * mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_blocksize +
+		mp->m_rsumsize +
+		128 * 5;
 }
 
+/*
+ * Logging the inode modification timestamp on a synchronous write.
+ *	inode
+ */
 STATIC uint
-xfs_calc_swrite_reservation(xfs_mount_t *mp)
+xfs_calc_swrite_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_SWRITE_LOG_RES(mp);
+	return mp->m_sb.sb_inodesize + 128;
 }
 
+/*
+ * Logging the inode mode bits when writing a setuid/setgid file
+ *	inode
+ */
 STATIC uint
 xfs_calc_writeid_reservation(xfs_mount_t *mp)
 {
-	return XFS_CALC_WRITEID_LOG_RES(mp);
+	return mp->m_sb.sb_inodesize + 128;
 }
 
+/*
+ * Converting the inode from non-attributed to attributed.
+ *	the inode being converted: inode size
+ *	agf block and superblock (for block allocation)
+ *	the new block (directory sized)
+ *	bmap blocks for the new directory block
+ *	allocation btrees
+ */
 STATIC uint
-xfs_calc_addafork_reservation(xfs_mount_t *mp)
+xfs_calc_addafork_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ADDAFORK_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize * 2 +
+		mp->m_dirblksize +
+		XFS_FSB_TO_B(mp, XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (4 + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1 +
+		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
+/*
+ * Removing the attribute fork of a file
+ *    the inode being truncated: inode size
+ *    the inode's bmap btree: max depth * block size
+ * And the bmap_finish transaction can free the blocks and bmap blocks:
+ *    the agf for each of the ags: 4 * sector size
+ *    the agfl for each of the ags: 4 * sector size
+ *    the super block to reflect the freed blocks: sector size
+ *    worst case split in allocation btrees per extent assuming 4 extents:
+ *		4 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_attrinval_reservation(xfs_mount_t *mp)
+xfs_calc_attrinval_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRINVAL_LOG_RES(mp);
+	return MAX((mp->m_sb.sb_inodesize +
+		    XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
+		    128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))),
+		   (4 * mp->m_sb.sb_sectsize +
+		    4 * mp->m_sb.sb_sectsize +
+		    mp->m_sb.sb_sectsize +
+		    XFS_ALLOCFREE_LOG_RES(mp, 4) +
+		    128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))));
 }
 
+/*
+ * Setting an attribute.
+ *	the inode getting the attribute
+ *	the superblock for allocations
+ *	the agfs extents are allocated from
+ *	the attribute btree * max depth
+ *	the inode allocation btree
+ * Since attribute transaction space is dependent on the size of the attribute,
+ * the calculation is done partially at mount time and partially at runtime.
+ */
 STATIC uint
-xfs_calc_attrset_reservation(xfs_mount_t *mp)
+xfs_calc_attrset_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRSET_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		mp->m_sb.sb_inodesize +
+		mp->m_sb.sb_sectsize +
+		XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
+		128 * (2 + XFS_DA_NODE_MAXDEPTH);
 }
 
+/*
+ * Removing an attribute.
+ *    the inode: inode size
+ *    the attribute btree could join: max depth * block size
+ *    the inode bmap btree could join or split: max depth * block size
+ * And the bmap_finish transaction can free the attr blocks freed giving:
+ *    the agf for the ag in which the blocks live: 2 * sector size
+ *    the agfl for the ag in which the blocks live: 2 * sector size
+ *    the superblock for the free block count: sector size
+ *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
+ */
 STATIC uint
-xfs_calc_attrrm_reservation(xfs_mount_t *mp)
+xfs_calc_attrrm_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_ATTRRM_LOG_RES(mp) + XFS_DQUOT_LOGRES(mp);
+	return XFS_DQUOT_LOGRES(mp) +
+		MAX((mp->m_sb.sb_inodesize +
+		     XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
+		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
+		     128 * (1 + XFS_DA_NODE_MAXDEPTH +
+			    XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		    (2 * mp->m_sb.sb_sectsize +
+		     2 * mp->m_sb.sb_sectsize +
+		     mp->m_sb.sb_sectsize +
+		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
+		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
+/*
+ * Clearing a bad agino number in an agi hash bucket.
+ */
 STATIC uint
-xfs_calc_clear_agi_bucket_reservation(xfs_mount_t *mp)
+xfs_calc_clear_agi_bucket_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_CALC_CLEAR_AGI_BUCKET_LOG_RES(mp);
+	return mp->m_sb.sb_sectsize + 128;
 }
 
 /*
@@ -185,11 +540,10 @@ xfs_calc_clear_agi_bucket_reservation(xf
  */
 void
 xfs_trans_init(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_trans_reservations_t	*resp;
+	struct xfs_trans_reservations *resp = &mp->m_reservations;
 
-	resp = &(mp->m_reservations);
 	resp->tr_write = xfs_calc_write_reservation(mp);
 	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
 	resp->tr_rename = xfs_calc_rename_reservation(mp);
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2010-05-04 15:47:36.150003848 +0200
+++ xfs/fs/xfs/xfs_trans.h	2010-05-04 15:47:55.115254931 +0200
@@ -300,24 +300,6 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_
 
 
 /*
- * Various log reservation values.
- * These are based on the size of the file system block
- * because that is what most transactions manipulate.
- * Each adds in an additional 128 bytes per item logged to
- * try to account for the overhead of the transaction mechanism.
- *
- * Note:
- * Most of the reservations underestimate the number of allocation
- * groups into which they could free extents in the xfs_bmap_finish()
- * call.  This is because the number in the worst case is quite high
- * and quite unusual.  In order to fix this we need to change
- * xfs_bmap_finish() to free extents in only a single AG at a time.
- * This will require changes to the EFI code as well, however, so that
- * the EFI for the extents not freed is logged again in each transaction.
- * See bug 261917.
- */
-
-/*
  * Per-extent log reservation for the allocation btree changes
  * involved in freeing or allocating an extent.
  * 2 trees * (2 blocks/level * max depth - 1) * block size
@@ -341,429 +323,36 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_
 	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
 
-/*
- * In a write transaction we can allocate a maximum of 2
- * extents.  This gives:
- *    the inode getting the new extents: inode size
- *    the inode's bmap btree: max depth * block size
- *    the agfs of the ags from which the extents are allocated: 2 * sector
- *    the superblock free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- * And the bmap_finish transaction can free bmap blocks in a join:
- *    the agfs of the ags containing the blocks: 2 * sector size
- *    the agfls of the ags containing the blocks: 2 * sector size
- *    the super block free block counter: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define XFS_CALC_WRITE_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + XFS_ALLOCFREE_LOG_COUNT(mp, 2)))),\
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
 
 #define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
-
-/*
- * In truncating a file we free up to two extents at once.  We can modify:
- *    the inode being truncated: inode size
- *    the inode's bmap btree: (max depth + 1) * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_ITRUNCATE_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) + \
-	  (128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)))), \
-	 ((4 * (mp)->m_sb.sb_sectsize) + \
-	  (4 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 4) + \
-	  (128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))) + \
-	  (128 * 5) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	   (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
-	    XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
-
-/*
- * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
- *    the two directory btrees: 2 * (max depth + v2) * dir block size
- *    the two directory bmap btrees: 2 * max depth * block size
- * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
- *    the agf for the ags in which the blocks live: 3 * sector size
- *    the agfl for the ags in which the blocks live: 3 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_RENAME_LOG_RES(mp) \
-	(MAX( \
-	 ((4 * (mp)->m_sb.sb_inodesize) + \
-	  (2 * XFS_DIROP_LOG_RES(mp)) + \
-	  (128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((3 * (mp)->m_sb.sb_sectsize) + \
-	  (3 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 3) + \
-	  (128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))))))
-
 #define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
-
-/*
- * For creating a link to an inode:
- *    the parent directory inode: inode size
- *    the linked inode: inode size
- *    the directory btree could split: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free some bmap blocks giving:
- *    the agf for the ag in which the blocks live: sector size
- *    the agfl for the ag in which the blocks live: sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_LINK_LOG_RES(mp) \
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (2 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((mp)->m_sb.sb_sectsize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
-
-/*
- * For removing a directory entry we can modify:
- *    the parent directory inode: inode size
- *    the removed inode: inode size
- *    the directory btree could join: (max depth + v2) * dir block size
- *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free the dir and bmap blocks giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_REMOVE_LOG_RES(mp)	\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (2 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
-
 #define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
-
-/*
- * For symlink we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: 1 block
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode's bmap btree: (max depth + v2) * block size
- *    the blocks for the symlink: 1 kB
- * Or in the first xact we allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_SYMLINK_LOG_RES(mp)		\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B(mp, 1) + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  1024 + \
-	  (128 * (4 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 (2 * (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), (mp)->m_in_maxlevels) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
-
-/*
- * For create we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: block size
- *    the superblock for the nlink flag: sector size
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode's bmap btree: (max depth + v2) * block size
- * Or in the first xact we allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
- *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_CREATE_LOG_RES(mp)		\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_inodesize + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B(mp, 1) + \
-	  XFS_DIROP_LOG_RES(mp) + \
-	  (128 * (3 + XFS_DIROP_LOG_COUNT(mp)))), \
-	 (3 * (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), (mp)->m_in_maxlevels) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
-
 #define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
-
-/*
- * Making a new directory is the same as creating a new file.
- */
-#define	XFS_CALC_MKDIR_LOG_RES(mp)	XFS_CALC_CREATE_LOG_RES(mp)
-
 #define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
-
-/*
- * In freeing an inode we can modify:
- *    the inode being freed: inode size
- *    the super block free inode counter: sector size
- *    the agi hash list and counters: sector size
- *    the inode btree entry: block size
- *    the on disk inode before ours in the agi hash list: inode cluster size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
- */
-#define	XFS_CALC_IFREE_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize + \
-	 (mp)->m_sb.sb_sectsize + \
-	 XFS_FSB_TO_B((mp), 1) + \
-	 MAX((__uint16_t)XFS_FSB_TO_B((mp), 1), XFS_INODE_CLUSTER_SIZE(mp)) + \
-	 (128 * 5) + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
-
 #define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
-
-/*
- * When only changing the inode we log the inode and possibly the superblock
- * We also add a bit of slop for the transaction stuff.
- */
-#define	XFS_CALC_ICHANGE_LOG_RES(mp)	((mp)->m_sb.sb_inodesize + \
-					 (mp)->m_sb.sb_sectsize + 512)
-
 #define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
-
-/*
- * Growing the data section of the filesystem.
- *	superblock
- *	agi and agf
- *	allocation btrees
- */
-#define	XFS_CALC_GROWDATA_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize * 3 + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
-
-/*
- * Growing the rt section of the filesystem.
- * In the first set of transactions (ALLOC) we allocate space to the
- * bitmap or summary files.
- *	superblock: sector size
- *	agf of the ag from which the extent is allocated: sector size
- *	bmap btree for bitmap/summary inode: max depth * blocksize
- *	bitmap/summary inode: inode size
- *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
- */
-#define	XFS_CALC_GROWRTALLOC_LOG_RES(mp) \
-	(2 * (mp)->m_sb.sb_sectsize + \
-	 XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) + \
-	 (mp)->m_sb.sb_inodesize + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * \
-	  (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + \
-	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
-
-/*
- * Growing the rt section of the filesystem.
- * In the second set of transactions (ZERO) we zero the new metadata blocks.
- *	one bitmap/summary block: blocksize
- */
-#define	XFS_CALC_GROWRTZERO_LOG_RES(mp) \
-	((mp)->m_sb.sb_blocksize + 128)
-
 #define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
-
-/*
- * Growing the rt section of the filesystem.
- * In the third set of transactions (FREE) we update metadata without
- * allocating any new blocks.
- *	superblock: sector size
- *	bitmap inode: inode size
- *	summary inode: inode size
- *	one bitmap block: blocksize
- *	summary blocks: new summary size
- */
-#define	XFS_CALC_GROWRTFREE_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize + \
-	 2 * (mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_blocksize + \
-	 (mp)->m_rsumsize + \
-	 (128 * 5))
-
 #define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
-
-/*
- * Logging the inode modification timestamp on a synchronous write.
- *	inode
- */
-#define	XFS_CALC_SWRITE_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + 128)
-
 #define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
-
 /*
  * Logging the inode timestamps on an fsync -- same as SWRITE
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
-
-/*
- * Logging the inode mode bits when writing a setuid/setgid file
- *	inode
- */
-#define	XFS_CALC_WRITEID_LOG_RES(mp) \
-	((mp)->m_sb.sb_inodesize + 128)
-
 #define	XFS_WRITEID_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
-
-/*
- * Converting the inode from non-attributed to attributed.
- *	the inode being converted: inode size
- *	agf block and superblock (for block allocation)
- *	the new block (directory sized)
- *	bmap blocks for the new directory block
- *	allocation btrees
- */
-#define	XFS_CALC_ADDAFORK_LOG_RES(mp)	\
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize * 2 + \
-	 (mp)->m_dirblksize + \
-	 XFS_FSB_TO_B(mp, (XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1)) + \
-	 XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	 (128 * (4 + (XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) + \
-		 XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
-
 #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
-
-/*
- * Removing the attribute fork of a file
- *    the inode being truncated: inode size
- *    the inode's bmap btree: max depth * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
- *    the agf for each of the ags: 4 * sector size
- *    the agfl for each of the ags: 4 * sector size
- *    the super block to reflect the freed blocks: sector size
- *    worst case split in allocation btrees per extent assuming 4 extents:
- *		4 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_ATTRINVAL_LOG_RES(mp)	\
-	(MAX( \
-	 ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) + \
-	  (128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))), \
-	 ((4 * (mp)->m_sb.sb_sectsize) + \
-	  (4 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 4) + \
-	  (128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))))))
-
 #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
-
-/*
- * Setting an attribute.
- *	the inode getting the attribute
- *	the superblock for allocations
- *	the agfs extents are allocated from
- *	the attribute btree * max depth
- *	the inode allocation btree
- * Since attribute transaction space is dependent on the size of the attribute,
- * the calculation is done partially at mount time and partially at runtime.
- */
-#define	XFS_CALC_ATTRSET_LOG_RES(mp)	\
-	((mp)->m_sb.sb_inodesize + \
-	 (mp)->m_sb.sb_sectsize + \
-	  XFS_FSB_TO_B((mp), XFS_DA_NODE_MAXDEPTH) + \
-	  (128 * (2 + XFS_DA_NODE_MAXDEPTH)))
-
 #define	XFS_ATTRSET_LOG_RES(mp, ext)	\
 	((mp)->m_reservations.tr_attrset + \
 	 (ext * (mp)->m_sb.sb_sectsize) + \
 	 (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
 	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
-
-/*
- * Removing an attribute.
- *    the inode: inode size
- *    the attribute btree could join: max depth * block size
- *    the inode bmap btree could join or split: max depth * block size
- * And the bmap_finish transaction can free the attr blocks freed giving:
- *    the agf for the ag in which the blocks live: 2 * sector size
- *    the agfl for the ag in which the blocks live: 2 * sector size
- *    the superblock for the free block count: sector size
- *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
- */
-#define	XFS_CALC_ATTRRM_LOG_RES(mp)	\
-	(MAX( \
-	  ((mp)->m_sb.sb_inodesize + \
-	  XFS_FSB_TO_B((mp), XFS_DA_NODE_MAXDEPTH) + \
-	  XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) + \
-	  (128 * (1 + XFS_DA_NODE_MAXDEPTH + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)))), \
-	 ((2 * (mp)->m_sb.sb_sectsize) + \
-	  (2 * (mp)->m_sb.sb_sectsize) + \
-	  (mp)->m_sb.sb_sectsize + \
-	  XFS_ALLOCFREE_LOG_RES(mp, 2) + \
-	  (128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))))))
-
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
-
-/*
- * Clearing a bad agino number in an agi hash bucket.
- */
-#define	XFS_CALC_CLEAR_AGI_BUCKET_LOG_RES(mp) \
-	((mp)->m_sb.sb_sectsize + 128)
-
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
