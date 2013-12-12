Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41AD87F59
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:39:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3E2FAC008
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:39:02 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iQFaZZNWs5veWcUW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:39:01 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBC7d0np026969
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:39:01 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7d0bp020927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:39:00 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7cxjB026182 for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:59 GMT
Message-ID: <52A96810.9090400@oracle.com>
Date: Thu, 12 Dec 2013 15:38:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 7/8] xfs: use xfs_icluster_size_fsb in xfs_ifree_cluster
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

Use xfs_icluster_size_fsb() in xfs_ifree_cluster(), rename variable
ninodes to inodes_per_cluster, the later is more meaningful.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_inode.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0c8c334..833028c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2141,8 +2141,8 @@ xfs_ifree_cluster(
 {
 	xfs_mount_t		*mp = free_ip->i_mount;
 	int			blks_per_cluster;
+	int			inodes_per_cluster;
 	int			nbufs;
-	int			ninodes;
 	int			i, j;
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
@@ -2152,18 +2152,11 @@ xfs_ifree_cluster(
 	struct xfs_perag	*pag;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
-	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size) {
-		blks_per_cluster = 1;
-		ninodes = mp->m_sb.sb_inopblock;
-		nbufs = mp->m_ialloc_blks;
-	} else {
-		blks_per_cluster = mp->m_inode_cluster_size /
-				   mp->m_sb.sb_blocksize;
-		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
-		nbufs = mp->m_ialloc_blks / blks_per_cluster;
-	}
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
+	nbufs = mp->m_ialloc_blks / blks_per_cluster;
 
-	for (j = 0; j < nbufs; j++, inum += ninodes) {
+	for (j = 0; j < nbufs; j++, inum += inodes_per_cluster) {
 		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
 					 XFS_INO_TO_AGBNO(mp, inum));
 
@@ -2225,7 +2218,7 @@ xfs_ifree_cluster(
 		 * transaction stale above, which means there is no point in
 		 * even trying to lock them.
 		 */
-		for (i = 0; i < ninodes; i++) {
+		for (i = 0; i < inodes_per_cluster; i++) {
 retry:
 			rcu_read_lock();
 			ip = radix_tree_lookup(&pag->pag_ici_root,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
