Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 608277F80
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33AF7304064
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:23:15 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cn5Kki3szSEiKzfW for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:23:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiCt-00016W-Al
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:11 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiCt-00065k-7a
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/27] xfs: Inode create transaction reservations
Date: Wed, 12 Jun 2013 20:22:30 +1000
Message-Id: <1371032567-21772-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Define the log and space transaction sizes. Factor the current
create log reservation macro into the two logical halves and reuse
one half for the new icreate transactions. The icreate transaction
is transparent to all the high level create code - the
pre-calculated reservations will correctly set the reservations
dependent on whether the filesystem supports the icreate
transaction.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_trans.c |  118 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 77 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2fd7c1f..35a2299 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -234,71 +234,93 @@ xfs_calc_remove_reservation(
 }
 
 /*
- * For symlink we can modify:
+ * For create, break it in to the two cases that the transaction
+ * covers. We start with the modify case - allocation done by modification
+ * of the state of existing inodes - and the allocation case.
+ */
+
+/*
+ * For create we can modify:
  *    the parent directory inode: inode size
  *    the new inode: inode size
- *    the inode btree entry: 1 block
+ *    the inode btree entry: block size
+ *    the superblock for the nlink flag: sector size
  *    the directory btree: (max depth + v2) * dir block size
  *    the directory inode's bmap btree: (max depth + v2) * block size
- *    the blocks for the symlink: 1 kB
- * Or in the first xact we allocate some inodes giving:
+ */
+STATIC uint
+xfs_calc_create_resv_modify(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		(uint)XFS_FSB_TO_B(mp, 1) +
+		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * For create we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the superblock for the nlink flag: sector size
  *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
  *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
-xfs_calc_symlink_reservation(
+xfs_calc_create_resv_alloc(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		mp->m_sb.sb_sectsize +
+		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+STATIC uint
+__xfs_calc_create_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(1, 1024)),
-		    (xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp),
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(mp->m_in_maxlevels,
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+		MAX(xfs_calc_create_resv_alloc(mp),
+		    xfs_calc_create_resv_modify(mp));
 }
 
 /*
- * For create we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: block size
- *    the superblock for the nlink flag: sector size
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode's bmap btree: (max depth + v2) * block size
- * Or in the first xact we allocate some inodes giving:
+ * For icreate we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
-xfs_calc_create_reservation(
+xfs_calc_icreate_resv_alloc(
 	struct xfs_mount	*mp)
 {
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		mp->m_sb.sb_sectsize +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+STATIC uint
+xfs_calc_icreate_reservation(xfs_mount_t *mp)
+{
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		     (uint)XFS_FSB_TO_B(mp, 1) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		     mp->m_sb.sb_sectsize +
-		     xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp),
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(mp->m_in_maxlevels,
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+		MAX(xfs_calc_icreate_resv_alloc(mp),
+		    xfs_calc_create_resv_modify(mp));
+}
+
+STATIC uint
+xfs_calc_create_reservation(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return xfs_calc_icreate_reservation(mp);
+	return __xfs_calc_create_reservation(mp);
+
 }
 
 /*
@@ -311,6 +333,20 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_create_reservation(mp);
 }
 
+
+/*
+ * Making a new symplink is the same as creating a new file, but
+ * with the added blocks for remote symlink data which can be up to 1kB in
+ * length (MAXPATHLEN).
+ */
+STATIC uint
+xfs_calc_symlink_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_create_reservation(mp) +
+	       xfs_calc_buf_res(1, MAXPATHLEN);
+}
+
 /*
  * In freeing an inode we can modify:
  *    the inode being freed: inode size
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
