Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7BD67F53
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 07:41:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40543AC003
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 05:41:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mGvnenjwvrSBESY1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 05:41:19 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s54CfIjS022263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2014 12:41:19 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s54CfHIw015628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2014 12:41:18 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s54CfHh9015619 for <xfs@oss.sgi.com>; Wed, 4 Jun 2014 12:41:17 GMT
Message-ID: <538F13EA.5030005@oracle.com>
Date: Wed, 04 Jun 2014 20:41:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 04/10] xfs: fix error handling at xfs_inumbers
References: <538D92D7.8000401@oracle.com>
In-Reply-To: <538D92D7.8000401@oracle.com>
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

Sorry, there is an issue in this patch, an updated version was shown
as following,

From: Jie Liu <jeff.liu@oracle.com>

To fetch the file system number tables, we currently just ignore the
errors and proceed to loop over the next AG or bump agino to the next
chunk in case of btree operations failed, that is not properly because
those errors might hint us potential file system problems.

This patch rework xfs_inumbers() to handle the btree operation errors
as well as the loop conditions.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 96 ++++++++++++++++++++++-------------------------------
 1 file changed, 39 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index dd68696..4b41910 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -536,7 +536,7 @@ xfs_inumbers(
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastino);
 	struct xfs_btree_cur	*cur = NULL;
-	xfs_buf_t		*agbp = NULL;
+	struct xfs_buf		*agbp = NULL;
 	struct xfs_inogrp	*buffer;
 	int			bcount;
 	int			left = *count;
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
-			long written;
+		if (++bufidx == bcount) {
+			long	written;
+
 			error = formatter(ubuffer, buffer, bufidx, &written);
 			if (error)
 				break;
@@ -612,25 +591,26 @@ xfs_inumbers(
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
+		if (!--left)
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
+		agino = 0;
+	} while (++agno < mp->m_sb.sb_agcount);
+
 	if (!error) {
 		if (bufidx) {
-			long written;
+			long	written;
 
 			error = formatter(ubuffer, buffer, bufidx, &written);
 			if (!error)
@@ -638,11 +618,13 @@ xfs_inumbers(
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
