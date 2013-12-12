Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8AF87F62
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:38:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A0BDD8F8049
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:38:12 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YI0ryWHRmaoH3DSQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:38:11 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBC7cAu5026219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:11 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7c97s018369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:10 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7c9kK018354 for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:09 GMT
Message-ID: <52A967DD.3040909@oracle.com>
Date: Thu, 12 Dec 2013 15:38:05 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 2/8] xfs: get rid of XFS_INODE_CLUSTER_SIZE macros
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

Get rid of XFS_INODE_CLUSTER_SIZE() macros, use mp->m_inode_cluster_size
directly.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c      | 10 +++++-----
 fs/xfs/xfs_ialloc.h      |  5 +----
 fs/xfs/xfs_inode.c       | 10 +++++-----
 fs/xfs/xfs_itable.c      |  4 ++--
 fs/xfs/xfs_log_recover.c |  8 ++++----
 fs/xfs/xfs_trans_resv.c  |  2 +-
 6 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 99e8b2c..c707bd7 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -52,7 +52,7 @@ xfs_ialloc_cluster_alignment(
 {
 	if (xfs_sb_version_hasalign(&args->mp->m_sb) &&
 	    args->mp->m_sb.sb_inoalignmt >=
-	     XFS_B_TO_FSBT(args->mp, XFS_INODE_CLUSTER_SIZE(args->mp)))
+	     XFS_B_TO_FSBT(args->mp, args->mp->m_inode_cluster_size))
 		return args->mp->m_sb.sb_inoalignmt;
 	return 1;
 }
@@ -181,12 +181,12 @@ xfs_ialloc_inode_init(
 	 * For small block sizes, manipulate the inodes in buffers
 	 * which are multiples of the blocks size.
 	 */
-	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
+	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size) {
 		blks_per_cluster = 1;
 		nbufs = length;
 		ninodes = mp->m_sb.sb_inopblock;
 	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
+		blks_per_cluster = mp->m_inode_cluster_size /
 				   mp->m_sb.sb_blocksize;
 		nbufs = length / blks_per_cluster;
 		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
@@ -1384,7 +1384,7 @@ xfs_imap(
 		return XFS_ERROR(EINVAL);
 	}
 
-	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
+	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
 
 	/*
 	 * For bulkstat and handle lookups, we have an untrusted inode number
@@ -1405,7 +1405,7 @@ xfs_imap(
 	 * If the inode cluster size is the same as the blocksize or
 	 * smaller we get to the buffer by simple arithmetics.
 	 */
-	if (XFS_INODE_CLUSTER_SIZE(mp) <= mp->m_sb.sb_blocksize) {
+	if (mp->m_inode_cluster_size <= mp->m_sb.sb_blocksize) {
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 4689b02..98ce63e 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -30,11 +30,8 @@ struct xfs_btree_cur;
  */
 #define	XFS_IALLOC_BLOCKS(mp)	(mp)->m_ialloc_blks
 
-/*
- * Move inodes in clusters of this size.
- */
+/* Move inodes in clusters of this size */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
-#define	XFS_INODE_CLUSTER_SIZE(mp)	(mp)->m_inode_cluster_size
 
 /*
  * Make an inode pointer out of the buffer/offset.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 001aa89..c1642c9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2152,13 +2152,13 @@ xfs_ifree_cluster(
 	struct xfs_perag	*pag;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
-	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
+	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size) {
 		blks_per_cluster = 1;
 		ninodes = mp->m_sb.sb_inopblock;
 		nbufs = XFS_IALLOC_BLOCKS(mp);
 	} else {
-		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
-					mp->m_sb.sb_blocksize;
+		blks_per_cluster = mp->m_inode_cluster_size /
+				   mp->m_sb.sb_blocksize;
 		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
 		nbufs = XFS_IALLOC_BLOCKS(mp) / blks_per_cluster;
 	}
@@ -2906,13 +2906,13 @@ xfs_iflush_cluster(
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
-	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
+	inodes_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
 	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!ilist)
 		goto out_put;
 
-	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
+	mask = ~(((mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
 	rcu_read_lock();
 	/* really need a gang lookup range call here */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c237ad1..0571012 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -243,9 +243,9 @@ xfs_bulkstat(
 	*done = 0;
 	fmterror = 0;
 	ubufp = ubuffer;
-	nicluster = mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp) ?
+	nicluster = mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size ?
 		mp->m_sb.sb_inopblock :
-		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
+		(mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog);
 	nimask = ~(nicluster - 1);
 	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
 	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f76de2e..42458ab 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2523,19 +2523,19 @@ xlog_recover_buffer_pass2(
 	 *
 	 * Also make sure that only inode buffers with good sizes stay in
 	 * the buffer cache.  The kernel moves inodes in buffers of 1 block
-	 * or XFS_INODE_CLUSTER_SIZE bytes, whichever is bigger.  The inode
+	 * or mp->m_inode_cluster_size bytes, whichever is bigger.  The inode
 	 * buffers in the log can be a different size if the log was generated
 	 * by an older kernel using unclustered inode buffers or a newer kernel
 	 * running with a different inode cluster size.  Regardless, if the
-	 * the inode buffer size isn't MAX(blocksize, XFS_INODE_CLUSTER_SIZE)
-	 * for *our* value of XFS_INODE_CLUSTER_SIZE, then we need to keep
+	 * the inode buffer size isn't MAX(blocksize, mp->m_inode_cluster_size)
+	 * for *our* value of mp->m_inode_cluster_size, then we need to keep
 	 * the buffer out of the buffer cache so that the buffer won't
 	 * overlap with future reads of those inodes.
 	 */
 	if (XFS_DINODE_MAGIC ==
 	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
 	    (BBTOB(bp->b_io_length) != MAX(log->l_mp->m_sb.sb_blocksize,
-			(__uint32_t)XFS_INODE_CLUSTER_SIZE(log->l_mp)))) {
+			(__uint32_t)log->l_mp->m_inode_cluster_size))) {
 		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
 	} else {
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 2fd59c0..51c181d 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -385,7 +385,7 @@ xfs_calc_ifree_reservation(
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
-		max_t(uint, XFS_FSB_TO_B(mp, 1), XFS_INODE_CLUSTER_SIZE(mp)) +
+		max_t(uint, XFS_FSB_TO_B(mp, 1), mp->m_inode_cluster_size) +
 		xfs_calc_buf_res(1, 0) +
 		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
 				 mp->m_in_maxlevels, 0) +
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
