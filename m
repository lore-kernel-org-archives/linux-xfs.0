Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDB627F6C
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:38:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB03930406B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:38:45 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4KxxsKaPUmSm0XYW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:38:44 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBC7chg5026776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:44 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7cgxw020420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:43 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7cg5q025618 for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:38:42 GMT
Message-ID: <52A96800.5080706@oracle.com>
Date: Thu, 12 Dec 2013 15:38:40 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 5/8] xfs: use xfs_icluster_size_fsb in xfs_bulkstat
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

Use xfs_icluster_size_fsb() in xfs_bulkstat(), make the related
variables more meaningful and remove an unused variable nimask
from it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 0571012..f463382 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -209,9 +209,8 @@ xfs_bulkstat(
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
 	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
 	xfs_ino_t		lastino; /* last inode number returned */
-	int			nbcluster; /* # of blocks in a cluster */
-	int			nicluster; /* # of inodes in a cluster */
-	int			nimask;	/* mask for inode clusters */
+	int			blks_per_cluster; /* # of blocks per cluster */
+	int			inodes_per_cluster;/* # of inodes per cluster */
 	int			nirbuf;	/* size of irbuf */
 	int			rval;	/* return value error code */
 	int			tmp;	/* result value from btree calls */
@@ -243,11 +242,8 @@ xfs_bulkstat(
 	*done = 0;
 	fmterror = 0;
 	ubufp = ubuffer;
-	nicluster = mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size ?
-		mp->m_sb.sb_inopblock :
-		(mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog);
-	nimask = ~(nicluster - 1);
-	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
 	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
 	if (!irbuf)
 		return ENOMEM;
@@ -390,12 +386,12 @@ xfs_bulkstat(
 				agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
 				for (chunkidx = 0;
 				     chunkidx < XFS_INODES_PER_CHUNK;
-				     chunkidx += nicluster,
-				     agbno += nbcluster) {
-					if (xfs_inobt_maskn(chunkidx, nicluster)
-							& ~r.ir_free)
+				     chunkidx += inodes_per_cluster,
+				     agbno += blks_per_cluster) {
+					if (xfs_inobt_maskn(chunkidx,
+					    inodes_per_cluster) & ~r.ir_free)
 						xfs_btree_reada_bufs(mp, agno,
-							agbno, nbcluster,
+							agbno, blks_per_cluster,
 							&xfs_inode_buf_ops);
 				}
 				blk_finish_plug(&plug);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
