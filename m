Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7A1CD7F78
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:07:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69066304048
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 11:07:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PI4DHz0pAa2WT8Gs for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 11:07:33 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r99I7X0L029933
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Oct 2013 14:07:33 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r99I7WiF019034
	for <xfs@oss.sgi.com>; Wed, 9 Oct 2013 14:07:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 04/10] xfs: update inode allocation/free transaction
	reservations for finobt
Date: Wed,  9 Oct 2013 14:06:52 -0400
Message-Id: <1381342018-35829-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1381342018-35829-1-git-send-email-bfoster@redhat.com>
References: <1381342018-35829-1-git-send-email-bfoster@redhat.com>
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

Create the xfs_calc_finobt_res() helper to calculate the finobt log
reservation for inode allocation and free. Update
XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
reserve blocks for the potential finobt record insertion on inode
free (i.e., if an inode chunk was previously fully allocated).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c       |  4 +++-
 fs/xfs/xfs_trans_resv.c  | 47 +++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans_space.h |  7 ++++++-
 3 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5fce726..9b5e40b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1731,7 +1731,9 @@ xfs_inactive_ifree(
 	int			error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
+	tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
+				  XFS_IFREE_SPACE_RES(mp), 0);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index a65a3cc..ecd20d0 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -106,6 +106,37 @@ xfs_calc_inode_res(
 }
 
 /*
+ * The free inode btree is a conditional feature and the log reservation
+ * requirements differ slightly from that of the traditional inode allocation
+ * btree. The finobt tracks records for inode chunks with at least one free inode.
+ * Therefore, a record can be removed from the tree for an inode allocation or
+ * free and the associated merge reservation is unconditional. This also covers
+ * the possibility of a split on record insertion.
+ *
+ * the free inode btree: max depth * block size
+ * the free inode btree entry: block size
+ *
+ * TODO: is the modify res really necessary? covered by the merge/split res?
+ * This seems to be the pattern of ifree, but not create_resv_alloc. Why?
+ */
+STATIC uint
+xfs_calc_finobt_res(
+	struct xfs_mount 	*mp,
+	int			modify)
+{
+	uint res;
+
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+		return 0;
+
+	res = xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1));
+	if (modify)
+		res += (uint)XFS_FSB_TO_B(mp, 1);
+
+	return res;
+}
+
+/*
  * Various log reservation values.
  *
  * These are based on the size of the file system block because that is what
@@ -275,6 +306,7 @@ xfs_calc_remove_reservation(
  *    the superblock for the nlink flag: sector size
  *    the directory btree: (max depth + v2) * dir block size
  *    the directory inode's bmap btree: (max depth + v2) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_create_resv_modify(
@@ -283,7 +315,8 @@ xfs_calc_create_resv_modify(
 	return xfs_calc_inode_res(mp, 2) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		(uint)XFS_FSB_TO_B(mp, 1) +
-		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 1);
 }
 
 /*
@@ -293,6 +326,7 @@ xfs_calc_create_resv_modify(
  *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_create_resv_alloc(
@@ -303,7 +337,8 @@ xfs_calc_create_resv_alloc(
 		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 0);
 }
 
 STATIC uint
@@ -321,6 +356,7 @@ __xfs_calc_create_reservation(
  *    the superblock for the nlink flag: sector size
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_icreate_resv_alloc(
@@ -330,7 +366,8 @@ xfs_calc_icreate_resv_alloc(
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 0);
 }
 
 STATIC uint
@@ -384,6 +421,7 @@ xfs_calc_symlink_reservation(
  *    the on disk inode before ours in the agi hash list: inode cluster size
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_ifree_reservation(
@@ -399,7 +437,8 @@ xfs_calc_ifree_reservation(
 		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
 				 mp->m_in_maxlevels, 0) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 1);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
index 7d2c920..a7d1721e 100644
--- a/fs/xfs/xfs_trans_space.h
+++ b/fs/xfs/xfs_trans_space.h
@@ -47,7 +47,9 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	(XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels - 1)
+	(XFS_IALLOC_BLOCKS(mp) + \
+	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
+	  ((mp)->m_in_maxlevels - 1)))
 
 /*
  * Space reservation values for various transactions.
@@ -82,5 +84,8 @@
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
+#define XFS_IFREE_SPACE_RES(mp)		\
+	(xfs_sb_version_hasfinobt(&mp->m_sb) ? (mp)->m_in_maxlevels : 0)
+
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
