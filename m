Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F7F37F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:38:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C2AF30406B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:38:27 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GNy4wV0ND4uf3jym (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:38:23 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBC7cMfK026527
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:23 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7cL3n019593
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:21 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7cKb6024825 for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:21 GMT
Message-ID: <52A967E9.7070508@oracle.com>
Date: Thu, 12 Dec 2013 15:38:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 3/8] xfs: get rid of XFS_IALLOC_BLOCKS macros
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Get rid of XFS_IALLOC_BLOCKS() marcos, use mp->m_ialloc_blks directly.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c      | 12 ++++++------
 fs/xfs/xfs_ialloc.h      |  5 -----
 fs/xfs/xfs_inode.c       |  4 ++--
 fs/xfs/xfs_log_recover.c |  4 ++--
 fs/xfs/xfs_trans_resv.c  |  8 ++++----
 fs/xfs/xfs_trans_space.h |  2 +-
 6 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c707bd7..5acba64 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -333,7 +333,7 @@ xfs_ialloc_ag_alloc(
 	if (args.mp->m_maxicount &&
 	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
 		return XFS_ERROR(ENOSPC);
-	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
+	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
@@ -343,7 +343,7 @@ xfs_ialloc_ag_alloc(
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
-			XFS_IALLOC_BLOCKS(args.mp);
+		     args.mp->m_ialloc_blks;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
@@ -585,7 +585,7 @@ xfs_ialloc_ag_select(
 		 * Is there enough free space for the file plus a block of
 		 * inodes? (if we need to allocate some)?
 		 */
-		ineed = XFS_IALLOC_BLOCKS(mp);
+		ineed = mp->m_ialloc_blks;
 		longest = pag->pagf_longest;
 		if (!longest)
 			longest = pag->pagf_flcount > 0;
@@ -1228,9 +1228,9 @@ xfs_difree(
 			goto error0;
 		}
 
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
-				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
-				XFS_IALLOC_BLOCKS(mp), flist, mp);
+		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
+				  XFS_INO_TO_AGBNO(mp, rec.ir_startino)),
+				  mp->m_ialloc_blks, flist, mp);
 	} else {
 		*delete = 0;
 
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 98ce63e..d86f8bd 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -25,11 +25,6 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_btree_cur;
 
-/*
- * Allocation parameters for inode allocation.
- */
-#define	XFS_IALLOC_BLOCKS(mp)	(mp)->m_ialloc_blks
-
 /* Move inodes in clusters of this size */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c1642c9..0c8c334 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2155,12 +2155,12 @@ xfs_ifree_cluster(
 	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size) {
 		blks_per_cluster = 1;
 		ninodes = mp->m_sb.sb_inopblock;
-		nbufs = XFS_IALLOC_BLOCKS(mp);
+		nbufs = mp->m_ialloc_blks;
 	} else {
 		blks_per_cluster = mp->m_inode_cluster_size /
 				   mp->m_sb.sb_blocksize;
 		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
-		nbufs = XFS_IALLOC_BLOCKS(mp) / blks_per_cluster;
+		nbufs = mp->m_ialloc_blks / blks_per_cluster;
 	}
 
 	for (j = 0; j < nbufs; j++, inum += ninodes) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 42458ab..22b6f35 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3209,9 +3209,9 @@ xlog_recover_do_icreate_pass2(
 
 	/* existing allocation is fixed value */
 	ASSERT(count == mp->m_ialloc_inos);
-	ASSERT(length == XFS_IALLOC_BLOCKS(mp));
+	ASSERT(length == mp->m_ialloc_blks);
 	if (count != mp->m_ialloc_inos ||
-	     length != XFS_IALLOC_BLOCKS(mp)) {
+	     length != mp->m_ialloc_blks) {
 		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count 2");
 		return EINVAL;
 	}
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 51c181d..2ffd3e3 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -174,7 +174,7 @@ xfs_calc_itruncate_reservation(
 		    xfs_calc_buf_res(5, 0) +
 		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				     XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+		    xfs_calc_buf_res(2 + mp->m_ialloc_blks +
 				     mp->m_in_maxlevels, 0)));
 }
 
@@ -282,7 +282,7 @@ xfs_calc_create_resv_modify(
  * For create we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode blocks allocated: mp->m_ialloc_blks * blocksize
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
@@ -292,7 +292,7 @@ xfs_calc_create_resv_alloc(
 {
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
@@ -387,7 +387,7 @@ xfs_calc_ifree_reservation(
 		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
 		max_t(uint, XFS_FSB_TO_B(mp, 1), mp->m_inode_cluster_size) +
 		xfs_calc_buf_res(1, 0) +
-		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+		xfs_calc_buf_res(2 + mp->m_ialloc_blks +
 				 mp->m_in_maxlevels, 0) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
index 7d2c920..af5dbe0 100644
--- a/fs/xfs/xfs_trans_space.h
+++ b/fs/xfs/xfs_trans_space.h
@@ -47,7 +47,7 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	(XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels - 1)
+	((mp)->m_ialloc_blks + (mp)->m_in_maxlevels - 1)
 
 /*
  * Space reservation values for various transactions.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
