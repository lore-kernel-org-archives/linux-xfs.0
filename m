Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA8D07F59
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 03:28:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D9DBAC002
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 01:28:47 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ykOt2bMGidUFDWbk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 01:28:46 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAC9ShRi031781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:45 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9Sg4B017957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:43 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9SgeT026627 for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:42 GMT
Message-ID: <5281F518.3080106@oracle.com>
Date: Tue, 12 Nov 2013 17:30:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH 2/4] xfs: introduce a new helper
	xfs_inobt_lookup_grab_ichunk()
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

introduce a new helper xfs_inobt_lookup_grab_ichunk().  This function
can be used to lookup the inode chunk that the given inode lives in,
and then get the record if we found that chunk.  If the inode was not
the last in the chunk and there are some left allocated, update the
data for the pointed-to record.

Refactor xfs_bulkstat() to make use of the founction.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ialloc.h |    9 +++++++++
 fs/xfs/xfs_itable.c |   45 +++++++++--------------------------------
 3 files changed, 73 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 86436e7..e34e16f 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -111,6 +111,61 @@ xfs_inobt_get_rec(
 }
 
 /*
+ * Lookup the inode chunk that the given inode lives in and then get
+ * the record if we found the chunk.  If the inode was not the last
+ * in the chunk and there are some left allocated, update the data
+ * for the pointed-to record.
+ */
+int
+xfs_inobt_lookup_grab_ichunk(
+	struct xfs_btree_cur		*cur,	/* btree cursor */
+	xfs_agino_t			agino,	/* starting inode of chunk */
+	struct xfs_inobt_rec_incore	*irec,	/* btree record */
+	int				*stat)	/* success/failure */
+{
+	int				idx;	/* Index into inode chunk */
+	int				error;
+
+	/* Lookup the inode chunk that this inode lives in */
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, stat);
+	if (error || !*stat)
+		return error;
+
+	/* Get the record, should always work */
+	error = xfs_inobt_get_rec(cur, irec, stat);
+	ASSERT(!error && *stat);
+	if (error || !*stat)
+		return error;
+
+	*stat = 0;
+	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
+		return error;
+
+	idx = agino - irec->ir_startino + 1;
+	/*
+	 * We got a right chunk and there are some left inodes allocated at it.
+	 */
+	if (idx < XFS_INODES_PER_CHUNK &&
+	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
+		int	i;
+
+		/*
+		 * Grab the chunk record.  Mark all the uninteresting inodes free
+		 * (because they're before our start point).
+		 */
+		for (i = 0; i < idx; i++) {
+			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
+				irec->ir_freecount++;
+		}
+
+		irec->ir_free |= xfs_inobt_maskn(0, idx);
+		*stat = 1;
+	}
+
+	return error;
+}
+
+/*
  * Loop over all clusters in a chunk for a given incore inode
  * allocation btree record.  Do a readahead if there are any
  * allocated inodes in that cluster.
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 65b2bef..4b032d6 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -166,4 +166,13 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_inobt_reada_chunk(struct xfs_mount *mp, xfs_agnumber_t agno,
 			   struct xfs_inobt_rec_incore *irec);
 
+/*
+ * Lookup the inode chunk that the given inode lives in and then get
+ * the record if we found the chunk.  If the inode was not the last
+ * in the chunk and there are some left allocated, update the data
+ * for the pointed-to record.
+ */
+int xfs_inobt_lookup_grab_ichunk(struct xfs_btree_cur *cur, xfs_agino_t agino,
+				 struct xfs_inobt_rec_incore *irec, int *stat);
+
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 9ac69cd..3611fa3 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -274,50 +274,23 @@ xfs_bulkstat(
 		 * we need to get the remainder of the chunk we're in.
 		 */
 		if (agino > 0) {
-			xfs_inobt_rec_incore_t r;
-
-			/*
-			 * Lookup the inode chunk that this inode lives in.
-			 */
-			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE,
-						 &tmp);
-			if (!error &&	/* no I/O error */
-			    tmp &&	/* lookup succeeded */
-					/* got the record, should always work */
-			    !(error = xfs_inobt_get_rec(cur, &r, &i)) &&
-			    i == 1 &&
-					/* this is the right chunk */
-			    agino < r.ir_startino + XFS_INODES_PER_CHUNK &&
-					/* lastino was not last in chunk */
-			    (chunkidx = agino - r.ir_startino + 1) <
-				    XFS_INODES_PER_CHUNK &&
-					/* there are some left allocated */
-			    xfs_inobt_maskn(chunkidx,
-				    XFS_INODES_PER_CHUNK - chunkidx) &
-				    ~r.ir_free) {
+			xfs_inobt_rec_incore_t	r;
+			error = xfs_inobt_lookup_grab_ichunk(cur, agino, &r,
+							     &tmp);
+			if (error || !tmp) {
 				/*
-				 * Grab the chunk record.  Mark all the
-				 * uninteresting inodes (because they're
-				 * before our start point) free.
+				 * If any of those tests failed, bump the
+				 * inode number (just in case).
 				 */
-				for (i = 0; i < chunkidx; i++) {
-					if (XFS_INOBT_MASK(i) & ~r.ir_free)
-						r.ir_freecount++;
-				}
-				r.ir_free |= xfs_inobt_maskn(0, chunkidx);
+				agino++;
+				icount = 0;
+			} else {
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
 				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 				icount = XFS_INODES_PER_CHUNK - r.ir_freecount;
-			} else {
-				/*
-				 * If any of those tests failed, bump the
-				 * inode number (just in case).
-				 */
-				agino++;
-				icount = 0;
 			}
 			/*
 			 * In any case, increment to the next record.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
