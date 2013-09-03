Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E4E297F59
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 13:25:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4C18304089
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 11:25:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HAE2Sw6R4fvK5h5r for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 11:25:48 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r83IPlaI029404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r83IPkFV005904
	for <xfs@oss.sgi.com>; Tue, 3 Sep 2013 14:25:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 05/11] xfs: update ifree transaction reservations for
	finobt
Date: Tue,  3 Sep 2013 14:25:02 -0400
Message-Id: <1378232708-57156-6-git-send-email-bfoster@redhat.com>
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

Update the ifree transaction log reservations to support the
finobt. An inode free can now mean an extra record modification,
record removal (i.e., inode chunk being freed) or a record
insertion (i.e., a previously full inode chunk).

Define XFS_IFREE_SPACE_RES() for the inactive transaction to
reserve data blocks for possible finobt merge/split situations.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_resv.c  | 5 ++++-
 fs/xfs/xfs_trans_space.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 3040dad..bbd393a 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -388,8 +388,10 @@ xfs_calc_symlink_reservation(
  *    the super block free inode counter: sector size
  *    the agi hash list and counters: sector size
  *    the inode btree entry: block size
+ *    the free inode btree entry: block size
  *    the on disk inode before ours in the agi hash list: inode cluster size
  *    the inode btree: max depth * blocksize
+ *    the free inode btree: max depth * block size
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
@@ -399,12 +401,13 @@ xfs_calc_ifree_reservation(
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(2, XFS_FSB_TO_B(mp, 1)) +
 		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
 		    XFS_INODE_CLUSTER_SIZE(mp)) +
 		xfs_calc_buf_res(1, 0) +
 		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
 				 mp->m_in_maxlevels, 0) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
index 5dca732..4fc8c10 100644
--- a/fs/xfs/xfs_trans_space.h
+++ b/fs/xfs/xfs_trans_space.h
@@ -82,5 +82,7 @@
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
+#define XFS_IFREE_SPACE_RES(mp)		\
+	(mp)->m_in_maxlevels
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
