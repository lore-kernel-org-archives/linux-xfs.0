Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D64E7F54
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 05:22:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E77FB8F8035
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 03:22:06 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QII9CbeCqhu6SSBX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 03:22:05 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBSBM4ij029827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:22:05 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBM4WR003797
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:22:04 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBM3UT003792 for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:22:03 GMT
Message-ID: <52BEB459.7020202@oracle.com>
Date: Sat, 28 Dec 2013 19:22:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 6/10] xfs: introduce xfs_bulkstat_ichunk_ra
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

Introduce xfs_bulkstat_ichunk_ra() to loop over all clusters in
the next inode chunk, then performs readahead if there are any
allocated inodes in that cluster.

Refactor xfs_bulkstat() with it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 56 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4c6b0ab..144e403 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -172,6 +172,37 @@ xfs_bulkstat_one(
 				    xfs_bulkstat_one_fmt, ubused, stat);
 }
 
+/*
+ * Loop over all clusters in a chunk for a given incore inode allocation btree
+ * record.  Do a readahead if there are any allocated inodes in that cluster.
+ */
+STATIC void
+xfs_bulkstat_ichunk_ra(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	xfs_agblock_t			agbno;
+	struct blk_plug			plug;
+	int				blks_per_cluster;
+	int				inodes_per_cluster;
+	int				i;	/* inode chunk index */
+
+	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
+
+	blk_start_plug(&plug);
+	for (i = 0; i < XFS_INODES_PER_CHUNK;
+	     i += inodes_per_cluster, agbno += blks_per_cluster) {
+		if (xfs_inobt_maskn(i, inodes_per_cluster) & ~irec->ir_free) {
+			xfs_btree_reada_bufs(mp, agno, agbno, blks_per_cluster,
+					     &xfs_inode_buf_ops);
+		}
+	}
+	blk_finish_plug(&plug);
+}
+
 #define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
 
 /*
@@ -187,7 +218,6 @@ xfs_bulkstat(
 	char			__user *ubuffer, /* buffer with inode stats */
 	int			*done)	/* 1 if there are more stats to get */
 {
-	xfs_agblock_t		agbno=0;/* allocation group block number */
 	xfs_buf_t		*agbp;	/* agi header buffer */
 	xfs_agi_t		*agi;	/* agi header data */
 	xfs_agino_t		agino;	/* inode # in allocation group */
@@ -206,8 +236,6 @@ xfs_bulkstat(
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
 	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
 	xfs_ino_t		lastino; /* last inode number returned */
-	int			blks_per_cluster; /* # of blocks per cluster */
-	int			inodes_per_cluster;/* # of inodes per cluster */
 	int			nirbuf;	/* size of irbuf */
 	int			rval;	/* return value error code */
 	int			tmp;	/* result value from btree calls */
@@ -236,8 +264,6 @@ xfs_bulkstat(
 	*done = 0;
 	fmterror = 0;
 	ubufp = ubuffer;
-	blks_per_cluster = xfs_icluster_size_fsb(mp);
-	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
 	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
 	if (!irbuf)
 		return ENOMEM;
@@ -345,25 +371,7 @@ xfs_bulkstat(
 			 * Also start read-ahead now for this chunk.
 			 */
 			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
-				struct blk_plug	plug;
-				/*
-				 * Loop over all clusters in the next chunk.
-				 * Do a readahead if there are any allocated
-				 * inodes in that cluster.
-				 */
-				blk_start_plug(&plug);
-				agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
-				for (chunkidx = 0;
-				     chunkidx < XFS_INODES_PER_CHUNK;
-				     chunkidx += inodes_per_cluster,
-				     agbno += blks_per_cluster) {
-					if (xfs_inobt_maskn(chunkidx,
-					    inodes_per_cluster) & ~r.ir_free)
-						xfs_btree_reada_bufs(mp, agno,
-							agbno, blks_per_cluster,
-							&xfs_inode_buf_ops);
-				}
-				blk_finish_plug(&plug);
+				xfs_bulkstat_ichunk_ra(mp, agno, &r);
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
