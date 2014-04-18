Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6DFC7F7C
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 19:58:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 276B6AC001
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 17:58:54 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XrwEkPQ81lT0N0G9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Apr 2014 17:58:52 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s3I0wqUT016107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:52 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3I0wpKj020843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:51 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s3I0wouq025327 for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 00:58:50 GMT
Message-ID: <535078C5.5060107@oracle.com>
Date: Fri, 18 Apr 2014 08:58:45 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 07/10] xfs: introduce xfs_bulkstat_grab_ichunk
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

Introduce xfs_bulkstat_grab_ichunk() to look up an inode chunk in where
the given inode resides, then grab the record. Update the data for the
pointed-to record if the inode was not the last in the chunk and there
are some left allocated, return the grabbed inode count on success.

Refactor xfs_bulkstat() with it.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 121 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 70 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 6bde45d..be7ab58 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -203,6 +203,63 @@ xfs_bulkstat_ichunk_ra(
 	blk_finish_plug(&plug);
 }
 
+/*
+ * Lookup the inode chunk that the given inode lives in and then get the record
+ * if we found the chunk.  If the inode was not the last in the chunk and there
+ * are some left allocated, update the data for the pointed-to record as well as
+ * return the count of grabbed inodes.
+ */
+STATIC int
+xfs_bulkstat_grab_ichunk(
+	struct xfs_btree_cur		*cur,	/* btree cursor */
+	xfs_agino_t			agino,	/* starting inode of chunk */
+	int				*icount,/* return # of inodes grabbed */
+	struct xfs_inobt_rec_incore	*irec)	/* btree record */
+{
+	int				idx;	/* index into inode chunk */
+	int				stat;
+	int				error = 0;
+
+	/* Lookup the inode chunk that this inode lives in */
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*icount = 0;
+		return error;
+	}
+
+	/* Get the record, should always work */
+	error = xfs_inobt_get_rec(cur, irec, &stat);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(stat == 1);
+
+	/* Check if the record contains the inode in request */
+	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
+		return XFS_ERROR(EINVAL);
+
+	idx = agino - irec->ir_startino + 1;
+	if (idx < XFS_INODES_PER_CHUNK &&
+	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
+		int	i;
+
+		/* We got a right chunk with some left inodes allocated at it.
+		 * Grab the chunk record.  Mark all the uninteresting inodes
+		 * free -- because they're before our start point.
+		 */
+		for (i = 0; i < idx; i++) {
+			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
+				irec->ir_freecount++;
+		}
+
+		irec->ir_free |= xfs_inobt_maskn(0, idx);
+		*icount = XFS_INODES_PER_CHUNK - irec->ir_freecount;
+	}
+
+	return 0;
+}
+
 #define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
 
 /*
@@ -288,67 +345,29 @@ xfs_bulkstat(
 		irbp = irbuf;
 		irbufend = irbuf + nirbuf;
 		end_of_ag = 0;
-		/*
-		 * If we're returning in the middle of an allocation group,
-		 * we need to get the remainder of the chunk we're in.
-		 */
+		icount = 0;
 		if (agino > 0) {
-			xfs_inobt_rec_incore_t r;
-
 			/*
-			 * Lookup the inode chunk that this inode lives in.
+			 * In the middle of an allocation group, we need to get
+			 * the remainder of the chunk we're in.
 			 */
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
-				/*
-				 * Grab the chunk record.  Mark all the
-				 * uninteresting inodes (because they're
-				 * before our start point) free.
-				 */
-				for (i = 0; i < chunkidx; i++) {
-					if (XFS_INOBT_MASK(i) & ~r.ir_free)
-						r.ir_freecount++;
-				}
-				r.ir_free |= xfs_inobt_maskn(0, chunkidx);
+			struct xfs_inobt_rec_incore	r;
+
+			error = xfs_bulkstat_grab_ichunk(cur, agino, &icount, &r);
+			if (error)
+				break;
+			if (icount) {
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
 				irbp++;
-				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
-				icount = XFS_INODES_PER_CHUNK - r.ir_freecount;
-			} else {
-				/*
-				 * If any of those tests failed, bump the
-				 * inode number (just in case).
-				 */
-				agino++;
-				icount = 0;
+				agino += r.ir_startino + XFS_INODES_PER_CHUNK;
 			}
-			/*
-			 * In any case, increment to the next record.
-			 */
-			if (!error)
-				error = xfs_btree_increment(cur, 0, &tmp);
+			/* Increment to the next record */
+			error = xfs_btree_increment(cur, 0, &tmp);
 		} else {
-			/*
-			 * Start of ag.  Lookup the first inode chunk.
-			 */
+			/* Start of ag.  Lookup the first inode chunk */
 			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
-			icount = 0;
 		}
 		if (error)
 			break;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
