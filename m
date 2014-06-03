Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27C637F69
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:18:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE5548F804B
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:18:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id TGHIDNbLfwEO4GiT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:18:21 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s539IJZu028180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:20 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539IJAs011500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:19 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s539IJiA011494 for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:18:19 GMT
Message-ID: <538D92D7.8000401@oracle.com>
Date: Tue, 03 Jun 2014 17:18:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 04/10] xfs: fix error handling at xfs_inumbers
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

To fetch the file system number tables, we currently just ignore the
errors and proceed to loop over the next AG or bump agino to the next
chunk in case of btree operations failed, that is not properly because
those errors might hint us potential file system problems.

This patch rework xfs_inumbers() to handle the btree operation errors
as well as the loop conditions.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 91 ++++++++++++++++++++++-------------------------------
 1 file changed, 37 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index dd68696..693e787 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -550,61 +550,40 @@ xfs_inumbers(
 
 	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
 	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
-	while (left > 0 && agno < mp->m_sb.sb_agcount) {
+	do {
 		struct xfs_inobt_rec_incore	r;
 		int				stat;
 
-		if (agbp == NULL) {
+		if (!agbp) {
 			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
-			if (error) {
-				/*
-				 * If we can't read the AGI of this ag,
-				 * then just skip to the next one.
-				 */
-				ASSERT(cur == NULL);
-				agbp = NULL;
-				agno++;
-				agino = 0;
-				continue;
-			}
+			if (error)
+				break;
+
 			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
 						    XFS_BTNUM_INO);
 			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
 						 &stat);
-			if (error) {
-				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-				cur = NULL;
-				xfs_buf_relse(agbp);
-				agbp = NULL;
-				/*
-				 * Move up the last inode in the current
-				 * chunk.  The lookup_ge will always get
-				 * us the first inode in the next chunk.
-				 */
-				agino += XFS_INODES_PER_CHUNK - 1;
-				continue;
-			}
+			if (error)
+				break;
+			if (!stat)
+				goto next_ag;
 		}
+
 		error = xfs_inobt_get_rec(cur, &r, &stat);
-		if (error || stat == 0) {
-			xfs_buf_relse(agbp);
-			agbp = NULL;
-			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-			cur = NULL;
-			agno++;
-			agino = 0;
-			continue;
-		}
+		if (error)
+			break;
+		if (!stat)
+			goto next_ag;
+
 		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
 		buffer[bufidx].xi_startino =
 			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
 		buffer[bufidx].xi_alloccount =
 			XFS_INODES_PER_CHUNK - r.ir_freecount;
 		buffer[bufidx].xi_allocmask = ~r.ir_free;
-		bufidx++;
-		left--;
-		if (bufidx == bcount) {
+		if (++bufidx == bcount) {
 			long written;
+
 			error = formatter(ubuffer, buffer, bufidx, &written);
 			if (error)
 				break;
@@ -612,22 +591,24 @@ xfs_inumbers(
 			*count += bufidx;
 			bufidx = 0;
 		}
-		if (left) {
-			error = xfs_btree_increment(cur, 0, &stat);
-			if (error) {
-				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-				cur = NULL;
-				xfs_buf_relse(agbp);
-				agbp = NULL;
-				/*
-				 * The agino value has already been bumped.
-				 * Just try to skip up to it.
-				 */
-				agino += XFS_INODES_PER_CHUNK;
-				continue;
-			}
-		}
-	}
+		if (--left)
+			break;
+
+		error = xfs_btree_increment(cur, 0, &stat);
+		if (error)
+			break;
+		if (stat)
+			continue;
+
+next_ag:
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+		cur = NULL;
+		xfs_buf_relse(agbp);
+		agbp = NULL;
+		agno++;
+		agino = 0;
+	} while (++agno < mp->m_sb.sb_agcount);
+
 	if (!error) {
 		if (bufidx) {
 			long written;
@@ -638,11 +619,13 @@ xfs_inumbers(
 		}
 		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
 	}
+
 	kmem_free(buffer);
 	if (cur)
 		xfs_btree_del_cursor(cur, (error ? XFS_BTREE_ERROR :
 					   XFS_BTREE_NOERROR));
 	if (agbp)
 		xfs_buf_relse(agbp);
+
 	return error;
 }
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
