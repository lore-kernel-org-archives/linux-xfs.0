Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 574BB7CB7
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 18B7A8F8033
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:20 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vPP8FrT6ulVT5Giu for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:17 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004lu-Nh
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00013y-Ms
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/15] xfs: factor btree block freeing into a helper
Date: Wed, 17 Feb 2016 18:20:40 +1100
Message-Id: <1455693652-3899-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Christoph Hellwig <hch@lst.de>

Source kernel commit c46ee8ad7856b58eeb383c30ce847897f85c4103

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_btree.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 14d8bf3..f4a1c67 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -290,6 +290,19 @@ xfs_btree_sblock_verify_crc(
 	return true;
 }
 
+static int
+xfs_btree_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	int			error;
+
+	error = cur->bc_ops->free_block(cur, bp);
+	if (!error)
+		XFS_BTREE_STATS_INC(cur, free);
+	return error;
+}
+
 /*
  * Delete the btree cursor.
  */
@@ -3282,12 +3295,11 @@ xfs_btree_kill_iroot(
 #endif
 	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
 
-	error = cur->bc_ops->free_block(cur, cbp);
+	error = xfs_btree_free_block(cur, cbp);
 	if (error) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
 	}
-	XFS_BTREE_STATS_INC(cur, free);
 
 	cur->bc_bufs[level - 1] = NULL;
 	be16_add_cpu(&block->bb_level, -1);
@@ -3320,14 +3332,12 @@ xfs_btree_kill_root(
 	 */
 	cur->bc_ops->set_root(cur, newroot, -1);
 
-	error = cur->bc_ops->free_block(cur, bp);
+	error = xfs_btree_free_block(cur, bp);
 	if (error) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
 	}
 
-	XFS_BTREE_STATS_INC(cur, free);
-
 	cur->bc_bufs[level] = NULL;
 	cur->bc_ra[level] = 0;
 	cur->bc_nlevels--;
@@ -3833,10 +3843,9 @@ xfs_btree_delrec(
 	}
 
 	/* Free the deleted block. */
-	error = cur->bc_ops->free_block(cur, rbp);
+	error = xfs_btree_free_block(cur, rbp);
 	if (error)
 		goto error0;
-	XFS_BTREE_STATS_INC(cur, free);
 
 	/*
 	 * If we joined with the left neighbor, set the buffer in the
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
