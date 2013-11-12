Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAC127F60
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 03:28:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 913868F8040
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 01:28:46 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JFXMiiqkQn6O5qV8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 01:28:36 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAC9SZcM031597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:36 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9SZKR021150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:35 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9SZfa026270 for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:35 GMT
Message-ID: <5281F509.7020105@oracle.com>
Date: Tue, 12 Nov 2013 17:29:45 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH 1/4] xfs: introduce a new helper xfs_inobt_reada_chunk()
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

Introduce a new helper xfs_inobt_reada_chunk(), it is used to loop
over all clusters in the next inode chunk, then performs readahead
if there are any allocated inodes in that cluster.

Refactor xfs_bulkstat() to make use of this function.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_ialloc.h |    7 +++++++
 fs/xfs/xfs_itable.c |   21 +--------------------
 3 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 14d732f..86436e7 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -111,6 +111,35 @@ xfs_inobt_get_rec(
 }
 
 /*
+ * Loop over all clusters in a chunk for a given incore inode
+ * allocation btree record.  Do a readahead if there are any
+ * allocated inodes in that cluster.
+ */
+void
+xfs_inobt_reada_chunk(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	xfs_agblock_t			agbno = XFS_AGINO_TO_AGBNO(mp,
+						irec->ir_startino);
+	int				nicluster, nbcluster;
+	int				chunkidx;
+
+	nicluster = mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp) ?
+		    mp->m_sb.sb_inopblock :
+		    (XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
+	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
+
+	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
+	     chunkidx += nicluster, agbno += nbcluster) {
+		if (xfs_inobt_maskn(chunkidx, nicluster) & ~irec->ir_free)
+			xfs_btree_reada_bufs(mp, agno, agbno, nbcluster,
+					     &xfs_inode_buf_ops);
+	}
+}
+
+/*
  * Verify that the number of free inodes in the AGI is correct.
  */
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index a8f76a5..65b2bef 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -159,4 +159,11 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
+/*
+ * Lookup clusters in inode chunk for a given incore inobt record,
+ * do readahead if there are any allocated inodes in that cluster.
+ */
+void xfs_inobt_reada_chunk(struct xfs_mount *mp, xfs_agnumber_t agno,
+			   struct xfs_inobt_rec_incore *irec);
+
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c237ad1..9ac69cd 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -190,7 +190,6 @@ xfs_bulkstat(
 	char			__user *ubuffer, /* buffer with inode stats */
 	int			*done)	/* 1 if there are more stats to get */
 {
-	xfs_agblock_t		agbno=0;/* allocation group block number */
 	xfs_buf_t		*agbp;	/* agi header buffer */
 	xfs_agi_t		*agi;	/* agi header data */
 	xfs_agino_t		agino;	/* inode # in allocation group */
@@ -209,9 +208,6 @@ xfs_bulkstat(
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
 	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
 	xfs_ino_t		lastino; /* last inode number returned */
-	int			nbcluster; /* # of blocks in a cluster */
-	int			nicluster; /* # of inodes in a cluster */
-	int			nimask;	/* mask for inode clusters */
 	int			nirbuf;	/* size of irbuf */
 	int			rval;	/* return value error code */
 	int			tmp;	/* result value from btree calls */
@@ -243,11 +239,6 @@ xfs_bulkstat(
 	*done = 0;
 	fmterror = 0;
 	ubufp = ubuffer;
-	nicluster = mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp) ?
-		mp->m_sb.sb_inopblock :
-		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
-	nimask = ~(nicluster - 1);
-	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
 	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
 	if (!irbuf)
 		return ENOMEM;
@@ -387,17 +378,7 @@ xfs_bulkstat(
 				 * inodes in that cluster.
 				 */
 				blk_start_plug(&plug);
-				agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
-				for (chunkidx = 0;
-				     chunkidx < XFS_INODES_PER_CHUNK;
-				     chunkidx += nicluster,
-				     agbno += nbcluster) {
-					if (xfs_inobt_maskn(chunkidx, nicluster)
-							& ~r.ir_free)
-						xfs_btree_reada_bufs(mp, agno,
-							agbno, nbcluster,
-							&xfs_inode_buf_ops);
-				}
+				xfs_inobt_reada_chunk(mp, agno, &r);
 				blk_finish_plug(&plug);
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
