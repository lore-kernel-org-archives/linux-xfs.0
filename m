Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E58C7F3F
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 05:22:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2243D304051
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 03:22:01 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IW7iXTZLWOEM5Pbp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 03:22:00 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBSBLwlh029569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:21:59 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBLvLt003522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:21:58 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBLvSk021564 for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:21:57 GMT
Message-ID: <52BEB453.9060002@oracle.com>
Date: Sat, 28 Dec 2013 19:21:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 5/10] xfs: fix error handling in xfs_bulkstat
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

We should not ignore the btree operation errors in xfs_bulkstat() but
to propagate them if any.  This patch fix two places in this function
and the remains things can be fixed with code refactoring thereafter.

Moreover, this fix also get rid of the redundant user buffer count
pre-checkups as it has already been validated in upper callers.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index b890d1f..4c6b0ab 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -230,9 +230,6 @@ xfs_bulkstat(
 		*ubcountp = 0;
 		return 0;
 	}
-	if (!ubcountp || *ubcountp <= 0) {
-		return EINVAL;
-	}
 	ubcount = *ubcountp; /* statstruct's */
 	ubleft = ubcount * statstruct_size; /* bytes */
 	*ubcountp = ubelem = 0;
@@ -255,14 +252,8 @@ xfs_bulkstat(
 	while (XFS_BULKSTAT_UBLEFT(ubleft) && agno < mp->m_sb.sb_agcount) {
 		cond_resched();
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-		if (error) {
-			/*
-			 * Skip this allocation group and go to the next one.
-			 */
-			agno++;
-			agino = 0;
-			continue;
-		}
+		if (error)
+			break;
 		agi = XFS_BUF_TO_AGI(agbp);
 		/*
 		 * Allocate and initialize a btree cursor for ialloc btree.
@@ -333,34 +324,15 @@ xfs_bulkstat(
 			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
 			icount = 0;
 		}
+		if (error)
+			break;
+
 		/*
 		 * Loop through inode btree records in this ag,
 		 * until we run out of inodes or space in the buffer.
 		 */
 		while (irbp < irbufend && icount < ubcount) {
-			xfs_inobt_rec_incore_t r;
-
-			/*
-			 * Loop as long as we're unable to read the
-			 * inode btree.
-			 */
-			while (error) {
-				agino += XFS_INODES_PER_CHUNK;
-				if (XFS_AGINO_TO_AGBNO(mp, agino) >=
-						be32_to_cpu(agi->agi_length))
-					break;
-				error = xfs_inobt_lookup(cur, agino,
-							 XFS_LOOKUP_GE, &tmp);
-				cond_resched();
-			}
-			/*
-			 * If ran off the end of the ag either with an error,
-			 * or the normal way, set end and stop collecting.
-			 */
-			if (error) {
-				end_of_ag = 1;
-				break;
-			}
+			struct xfs_inobt_rec_incore	r;
 
 			error = xfs_inobt_get_rec(cur, &r, &i);
 			if (error || i == 0) {
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
