Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 017C67F55
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 08:51:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 761CFAC00A
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 06:51:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id abAoYDqDLFf7dzFo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jul 2013 06:51:24 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r61Dj2k4019765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 13:45:03 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r61DpLrI018157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 13:51:22 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r61DpL3d018149 for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 13:51:21 GMT
Message-ID: <51D18964.2030708@oracle.com>
Date: Mon, 01 Jul 2013 21:51:32 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: clean up unused codes at xfs_bulkstat()
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

There are some unused codes at xfs_bulkstat():

- Variable bp is defined to point to the on-disk inode cluster
  buffer, but it proved to be of no practical help.

- We process the chunks of good inodes which were fetched by iterating
  btree records from an AG.  When processing inodes from each chunk,
  the code recomputing agbno if run into the first inode of a cluster,
  however, the agbno is not being used thereafter.

This patch tries to clean up those things.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_itable.c |   28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -221,7 +221,6 @@ xfs_bulkstat(
 	char			__user *ubufp;	/* pointer into user's buffer */
 	int			ubelem;	/* spaces used in user's buffer */
 	int			ubused;	/* bytes used by formatter */
-	xfs_buf_t		*bp;	/* ptr to on-disk inode cluster buf */
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
@@ -263,7 +262,6 @@ xfs_bulkstat(
 	rval = 0;
 	while (XFS_BULKSTAT_UBLEFT(ubleft) && agno < mp->m_sb.sb_agcount) {
 		cond_resched();
-		bp = NULL;
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
 		if (error) {
 			/*
@@ -433,27 +431,7 @@ xfs_bulkstat(
 				irbp->ir_freecount < XFS_INODES_PER_CHUNK;
 			     chunkidx++, clustidx++, agino++) {
 				ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
-				/*
-				 * Recompute agbno if this is the
-				 * first inode of the cluster.
-				 *
-				 * Careful with clustidx.   There can be
-				 * multiple clusters per chunk, a single
-				 * cluster per chunk or a cluster that has
-				 * inodes represented from several different
-				 * chunks (if blocksize is large).
-				 *
-				 * Because of this, the starting clustidx is
-				 * initialized to zero in this loop but must
-				 * later be reset after reading in the cluster
-				 * buffer.
-				 */
-				if ((chunkidx & (nicluster - 1)) == 0) {
-					agbno = XFS_AGINO_TO_AGBNO(mp,
-							irbp->ir_startino) +
-						((chunkidx & nimask) >>
-						 mp->m_sb.sb_inopblog);
-				}
+
 				ino = XFS_AGINO_TO_INO(mp, agno, agino);
 				/*
 				 * Skip if this inode is free.
@@ -499,10 +477,6 @@ xfs_bulkstat(
 
 			cond_resched();
 		}
-
-		if (bp)
-			xfs_buf_relse(bp);
-
 		/*
 		 * Set up for the next loop iteration.
 		 */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
