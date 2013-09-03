Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96D3B7F58
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59E058F8035
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EmdDJ5iIc4dAqh2q for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:47 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPkUZ027300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r83IPk1Q004524
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 04/11] xfs: update inode allocation transaction
	reservations for finobt
Date: Tue,  3 Sep 2013 14:25:01 -0400
Message-Id: <1378232708-57156-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
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

Update inode allocation transaction reservations for the finobt. A
create via record modification requires a log reservation for the
additional finobt record. Any such allocation could result in an
finobt removal if the inode chunk has become fully allocated, thus
we include a reservation for a finobt btree merge as well.
Allocation of a new inode chunk must account for splits in the
finobt as well as the existing ialloc tree.

Also update XFS_IALLOC_SPACE_RES() to reserve data blocks for
finobt split/merge scenarios.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_resv.c  | 9 ++++++++-
 fs/xfs/xfs_trans_space.h | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index a65a3cc..3040dad 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -272,6 +272,8 @@ xfs_calc_remove_reservation(
  *    the parent directory inode: inode size
  *    the new inode: inode size
  *    the inode btree entry: block size
+ *    the free inode btree entry: block size
+ *    the free inode btree: max depth * block size
  *    the superblock for the nlink flag: sector size
  *    the directory btree: (max depth + v2) * dir block size
  *    the directory inode's bmap btree: (max depth + v2) * block size
@@ -282,7 +284,8 @@ xfs_calc_create_resv_modify(
 {
 	return xfs_calc_inode_res(mp, 2) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		(uint)XFS_FSB_TO_B(mp, 1) +
+		(uint)XFS_FSB_TO_B(mp, 2) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
 }
 
@@ -292,6 +295,7 @@ xfs_calc_create_resv_modify(
  *    the superblock for the nlink flag: sector size
  *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
  *    the inode btree: max depth * blocksize
+ *    the free inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
@@ -302,6 +306,7 @@ xfs_calc_create_resv_alloc(
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
@@ -320,6 +325,7 @@ __xfs_calc_create_reservation(
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
  *    the inode btree: max depth * blocksize
+ *    the free inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
@@ -329,6 +335,7 @@ xfs_calc_icreate_resv_alloc(
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
index 7d2c920..5dca732 100644
--- a/fs/xfs/xfs_trans_space.h
+++ b/fs/xfs/xfs_trans_space.h
@@ -47,7 +47,7 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	(XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels - 1)
+	(XFS_IALLOC_BLOCKS(mp) + 2 * ((mp)->m_in_maxlevels - 1))
 
 /*
  * Space reservation values for various transactions.
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
