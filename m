Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36BC97F54
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 05:22:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05B68304032
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 03:22:23 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id jVNQmxB0vngBdstW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 03:22:22 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBSBMLSP031556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:22:22 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBMK5s022065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:22:21 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBMK1n022061 for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:22:20 GMT
Message-ID: <52BEB469.2000306@oracle.com>
Date: Sat, 28 Dec 2013 19:22:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 8/10] xfs: introduce xfs_bulkstat_ag_ichunk
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

Introduce xfs_bulkstat_ag_ichunk() to process inodes in chunk with
a pointer to a formatter function that will iget the inode and fill
in the appropriate structure.

Refactor xfs_bulkstat() with it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 142 ++++++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_itable.h |  16 ++++++
 2 files changed, 104 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c179e0e..249b516 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -260,6 +260,80 @@ xfs_bulkstat_grab_ichunk(
 #define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
 
 /*
+ * Process inodes in chunk with a pointer to a formatter function that will
+ * iget the inode and fill in the appropriate structure.
+ */
+STATIC int
+xfs_bulkstat_ag_ichunk(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_inobt_rec_incore	*irbp,
+	bulkstat_one_pf			formatter,
+	size_t				statstruct_size,
+	struct xfs_bulkstat_agichunk	*acp)
+{
+	xfs_ino_t			lastino = acp->ac_lastino;
+	char				__user *ubufp = acp->ac_ubuffer;
+	int				ubleft = acp->ac_ubleft;
+	int				ubelem = acp->ac_ubelem;
+	int				chunkidx, clustidx;
+	int				error = 0;
+	xfs_agino_t			agino;
+
+	for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
+	     XFS_BULKSTAT_UBLEFT(ubleft) &&
+	     irbp->ir_freecount < XFS_INODES_PER_CHUNK;
+	     chunkidx++, clustidx++, agino++) {
+		int		fmterror;	/* bulkstat formatter result */
+		int		ubused;
+		xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, agno, agino);
+
+		ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
+		/* Skip if this inode is free */
+		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
+			lastino = ino;
+			continue;
+		}
+
+		/*
+		 * Count used inodes as free so we can tell when the chunk is
+		 * used up.
+		 */
+		irbp->ir_freecount++;
+
+		/* Get the inode and fill in a single buffer */
+		ubused = statstruct_size;
+		error = formatter(mp, ino, ubufp, ubleft, &ubused, &fmterror);
+		if (fmterror == BULKSTAT_RV_NOTHING) {
+			if (error && error != ENOENT && error != EINVAL) {
+				ubleft = 0;
+				break;
+			}
+			error = 0;
+			lastino = ino;
+			continue;
+		}
+		if (fmterror == BULKSTAT_RV_GIVEUP) {
+			ubleft = 0;
+			ASSERT(error);
+			break;
+		}
+		if (ubufp)
+			ubufp += ubused;
+		ubleft -= ubused;
+		ubelem++;
+		lastino = ino;
+	}
+
+	if (!error) {
+		acp->ac_lastino = lastino;
+		acp->ac_ubleft = ubleft;
+		acp->ac_ubelem = ubelem;
+	}
+	return error;
+}
+
+/*
  * Return stat information in bulk (by-inode) for the filesystem.
  */
 int					/* error status */
@@ -276,8 +350,6 @@ xfs_bulkstat(
 	xfs_agi_t		*agi;	/* agi header data */
 	xfs_agino_t		agino;	/* inode # in allocation group */
 	xfs_agnumber_t		agno;	/* allocation group number */
-	int			chunkidx; /* current index into inode chunk */
-	int			clustidx; /* current index into inode cluster */
 	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
 	int			end_of_ag; /* set if we've seen the ag end */
 	int			error;	/* error code */
@@ -297,7 +369,6 @@ xfs_bulkstat(
 	int			ubleft;	/* bytes left in user's buffer */
 	char			__user *ubufp;	/* pointer into user's buffer */
 	int			ubelem;	/* spaces used in user's buffer */
-	int			ubused;	/* bytes used by formatter */
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
@@ -414,57 +485,20 @@ xfs_bulkstat(
 		irbufend = irbp;
 		for (irbp = irbuf;
 		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ubleft); irbp++) {
-			/*
-			 * Now process this chunk of inodes.
-			 */
-			for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
-			     XFS_BULKSTAT_UBLEFT(ubleft) &&
-				irbp->ir_freecount < XFS_INODES_PER_CHUNK;
-			     chunkidx++, clustidx++, agino++) {
-				ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
-
-				ino = XFS_AGINO_TO_INO(mp, agno, agino);
-				/*
-				 * Skip if this inode is free.
-				 */
-				if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
-					lastino = ino;
-					continue;
-				}
-				/*
-				 * Count used inodes as free so we can tell
-				 * when the chunk is used up.
-				 */
-				irbp->ir_freecount++;
-
-				/*
-				 * Get the inode and fill in a single buffer.
-				 */
-				ubused = statstruct_size;
-				error = formatter(mp, ino, ubufp, ubleft,
-						  &ubused, &fmterror);
-				if (fmterror == BULKSTAT_RV_NOTHING) {
-					if (error && error != ENOENT &&
-						error != EINVAL) {
-						ubleft = 0;
-						rval = error;
-						break;
-					}
-					lastino = ino;
-					continue;
-				}
-				if (fmterror == BULKSTAT_RV_GIVEUP) {
-					ubleft = 0;
-					ASSERT(error);
-					rval = error;
-					break;
-				}
-				if (ubufp)
-					ubufp += ubused;
-				ubleft -= ubused;
-				ubelem++;
-				lastino = ino;
-			}
+			struct xfs_bulkstat_agichunk ac;
+
+			ac.ac_lastino = lastino;
+			ac.ac_ubuffer = ubuffer;
+			ac.ac_ubleft = ubleft;
+			ac.ac_ubelem = ubelem;
+			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
+					formatter, statstruct_size, &ac);
+			if (error)
+				rval = error;
+
+			lastino = ac.ac_lastino;
+			ubleft = ac.ac_ubleft;
+			ubelem = ac.ac_ubelem;
 
 			cond_resched();
 		}
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index f78bbcf..e33ec46 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -30,6 +30,22 @@ typedef int (*bulkstat_one_pf)(struct xfs_mount	*mp,
 			       int		*ubused,
 			       int		*stat);
 
+struct xfs_bulkstat_agichunk {
+	xfs_ino_t	ac_lastino;	/* last inode returned */
+	char		__user *ac_ubuffer;/* pointer into user's buffer */
+	int		ac_ubleft;	/* bytes left in user's buffer */
+	int		ac_ubelem;	/* spaces used in user's buffer */
+};
+
+int
+xfs_bulkstat_ag_ichunk(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_inobt_rec_incore	*irbp,
+	bulkstat_one_pf			formatter,
+	size_t				statstruct_size,
+	struct xfs_bulkstat_agichunk	*acp);
+
 /*
  * Values for stat return value.
  */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
