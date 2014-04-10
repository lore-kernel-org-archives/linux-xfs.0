Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5EADB7F91
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:08:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6951AC00B
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2iGHQS18Uk8tp4nT for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:39 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AG8cs2007093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:39 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s3AG8cr1010788
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Date: Thu, 10 Apr 2014 12:08:29 -0400
Message-Id: <1397146116-42546-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_inode.c       | 25 ++++++++++++++++++++++-
 fs/xfs/xfs_trans_resv.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trans_space.h |  7 ++++++-
 3 files changed, 80 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5e7a38f..8576892 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1837,8 +1837,31 @@ xfs_inactive_ifree(
 	int			error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, 0, 0);
+
+	/*
+	 * The ifree transaction might need to allocate blocks for record
+	 * insertion to the finobt. We don't want to fail here at ENOSPC, so
+	 * allow ifree to dip into the reserved block pool if necessary.
+	 *
+	 * Freeing large sets of inodes generally means freeing inode chunks,
+	 * directory and file data blocks, so this should be relatively safe.
+	 * Only under severe circumstances should it be possible to free enough
+	 * inodes to exhaust the reserve block pool via finobt expansion while
+	 * at the same time not creating free space in the filesystem.
+	 *
+	 * Send a warning if the reservation does happen to fail, as the inode
+	 * now remains allocated and sits on the unlinked list until the fs is
+	 * repaired.
+	 */
+	tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
+				  XFS_IFREE_SPACE_RES(mp), 0);
 	if (error) {
+		if (error == ENOSPC)
+			xfs_warn_ratelimited(mp,
+			"Failed to remove inode(s) from unlinked list. "
+			"Please free space, unmount and run xfs_repair.");
+
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
 		return error;
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index ae36816..52b6c3e 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -106,6 +106,47 @@ xfs_calc_inode_res(
 }
 
 /*
+ * The free inode btree is a conditional feature and the log reservation
+ * requirements differ slightly from that of the traditional inode allocation
+ * btree. The finobt tracks records for inode chunks with at least one free
+ * inode. A record can be removed from the tree for an inode allocation
+ * or free and thus the finobt reservation is unconditional across:
+ *
+ * 	- inode allocation
+ * 	- inode free
+ * 	- inode chunk allocation
+ *
+ * The 'modify' param indicates to include the record modification scenario. The
+ * 'alloc' param indicates to include the reservation for free space btree
+ * modifications on behalf of finobt modifications. This is required only for
+ * transactions that do not already account for free space btree modifications.
+ *
+ * the free inode btree: max depth * block size
+ * the allocation btrees: 2 trees * (max depth - 1) * block size
+ * the free inode btree entry: block size
+ */
+STATIC uint
+xfs_calc_finobt_res(
+	struct xfs_mount 	*mp,
+	int			alloc,
+	int			modify)
+{
+	uint res;
+
+	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+		return 0;
+
+	res = xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1));
+	if (alloc)
+		res += xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1), 
+					XFS_FSB_TO_B(mp, 1));
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
@@ -302,6 +343,7 @@ xfs_calc_remove_reservation(
  *    the superblock for the nlink flag: sector size
  *    the directory btree: (max depth + v2) * dir block size
  *    the directory inode's bmap btree: (max depth + v2) * block size
+ *    the finobt (record modification and allocation btrees)
  */
 STATIC uint
 xfs_calc_create_resv_modify(
@@ -310,7 +352,8 @@ xfs_calc_create_resv_modify(
 	return xfs_calc_inode_res(mp, 2) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		(uint)XFS_FSB_TO_B(mp, 1) +
-		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 1, 1);
 }
 
 /*
@@ -348,6 +391,7 @@ __xfs_calc_create_reservation(
  *    the superblock for the nlink flag: sector size
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt (record insertion)
  */
 STATIC uint
 xfs_calc_icreate_resv_alloc(
@@ -357,7 +401,8 @@ xfs_calc_icreate_resv_alloc(
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 0, 0);
 }
 
 STATIC uint
@@ -425,6 +470,7 @@ xfs_calc_symlink_reservation(
  *    the on disk inode before ours in the agi hash list: inode cluster size
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the finobt (record insertion, removal or modification)
  */
 STATIC uint
 xfs_calc_ifree_reservation(
@@ -439,7 +485,8 @@ xfs_calc_ifree_reservation(
 		xfs_calc_buf_res(2 + mp->m_ialloc_blks +
 				 mp->m_in_maxlevels, 0) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_finobt_res(mp, 0, 1);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
index af5dbe0..df4c1f8 100644
--- a/fs/xfs/xfs_trans_space.h
+++ b/fs/xfs/xfs_trans_space.h
@@ -47,7 +47,9 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	((mp)->m_ialloc_blks + (mp)->m_in_maxlevels - 1)
+	((mp)->m_ialloc_blks + \
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
