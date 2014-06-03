Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C79947F74
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:18:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A704E8F8050
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:18:41 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JaNu6oSPlgYw9JdG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:18:40 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s539Id32028573
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:40 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539Icc9027402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539IcmQ012509 for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:38 GMT
Message-ID: <538D92E9.3010207@oracle.com>
Date: Tue, 03 Jun 2014 17:18:33 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 06/10] xfs: fix error handling at xfs_bulkstat
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

We should not ignore the btree operation errors at xfs_bulkstat() but
to propagate them if any. This patch fix two places in this function
and the remains things will be fixed with code refactoring thereafter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index d210e24..a3c833c 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -252,14 +252,8 @@ xfs_bulkstat(
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
@@ -331,34 +325,15 @@ xfs_bulkstat(
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
