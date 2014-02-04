Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D76D17F59
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:50:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE6E88F8050
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:50:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 46wpVIAvbe8xHVyC for
	<xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:49:45 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s14HniFP000941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:44 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s14HniXo018297
	for <xfs@oss.sgi.com>; Tue, 4 Feb 2014 12:49:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Date: Tue,  4 Feb 2014 12:49:35 -0500
Message-Id: <1391536182-9048-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
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
index 001aa89..57c77ed 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1730,7 +1730,9 @@ xfs_inactive_ifree(
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
index 2fd59c0..32f35c1 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -98,6 +98,37 @@ xfs_calc_inode_res(
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
@@ -267,6 +298,7 @@ xfs_calc_remove_reservation(
  *    the superblock for the nlink flag: sector size
  *    the directory btree: (max depth + v2) * dir block size
  *    the directory inode's bmap btree: (max depth + v2) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_create_resv_modify(
@@ -275,7 +307,8 @@ xfs_calc_create_resv_modify(
 	return xfs_calc_inode_res(mp, 2) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		(uint)XFS_FSB_TO_B(mp, 1) +
-		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 1);
 }
 
 /*
@@ -285,6 +318,7 @@ xfs_calc_create_resv_modify(
  *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_create_resv_alloc(
@@ -295,7 +329,8 @@ xfs_calc_create_resv_alloc(
 		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 0);
 }
 
 STATIC uint
@@ -313,6 +348,7 @@ __xfs_calc_create_reservation(
  *    the superblock for the nlink flag: sector size
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_icreate_resv_alloc(
@@ -322,7 +358,8 @@ xfs_calc_icreate_resv_alloc(
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 0);
 }
 
 STATIC uint
@@ -376,6 +413,7 @@ xfs_calc_symlink_reservation(
  *    the on disk inode before ours in the agi hash list: inode cluster size
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt
  */
 STATIC uint
 xfs_calc_ifree_reservation(
@@ -390,7 +428,8 @@ xfs_calc_ifree_reservation(
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
