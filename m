Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37600 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdJXA20 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 20:28:26 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9O0SPXu022383
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 00:28:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9O0SP5H028425
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 00:28:25 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9O0SP7N025889
        for <linux-xfs@vger.kernel.org>; Tue, 24 Oct 2017 00:28:25 GMT
Date: Mon, 23 Oct 2017 17:28:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: abort extended attribute list operation if btree is
 obviously weird
Message-ID: <20171024002824.GL5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Abort an attribute list operation if the attr btree has obvious problems
like loops back to the root or pointers don't point down the tree.
Found by fuzzing btree[0].before to zero in xfs/402.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_attr_list.c |   54 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 5816786..9f6fcc6 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -205,18 +205,21 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 }
 
 STATIC int
-xfs_attr_node_list(xfs_attr_list_context_t *context)
+xfs_attr_node_list(
+	struct xfs_attr_list_context	*context)
 {
-	attrlist_cursor_kern_t *cursor;
-	xfs_attr_leafblock_t *leaf;
-	xfs_da_intnode_t *node;
-	struct xfs_attr3_icleaf_hdr leafhdr;
-	struct xfs_da3_icnode_hdr nodehdr;
-	struct xfs_da_node_entry *btree;
-	int error, i;
-	struct xfs_buf *bp;
-	struct xfs_inode	*dp = context->dp;
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xfs_da3_icnode_hdr	nodehdr;
+	struct attrlist_cursor_kern	*cursor;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_da_intnode		*node;
+	struct xfs_da_node_entry	*btree;
+	struct xfs_buf			*bp;
+	struct xfs_inode		*dp = context->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	int				i;
+	unsigned int			expected_level;
+	int				error;
 
 	trace_xfs_attr_node_list(context);
 
@@ -277,6 +280,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 * Note that start of node block is same as start of leaf block.
 	 */
 	if (bp == NULL) {
+		expected_level = -1U;
 		cursor->blkno = 0;
 		for (;;) {
 			uint16_t magic;
@@ -302,6 +306,30 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			}
 
 			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
+
+			/* Tree taller than we can handle; bail out! */
+			if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
+				xfs_trans_brelse(context->tp, bp);
+				return -EFSCORRUPTED;
+			}
+
+			if (cursor->blkno == 0) {
+				/*
+				 * This is the root node, set up for the
+				 * next level we want to see.
+				 */
+				expected_level = nodehdr.level - 1;
+			} else if (expected_level != nodehdr.level) {
+				/*
+				 * Not the level we were expecting, which
+				 * implies that the tree is bad.
+				 */
+				xfs_trans_brelse(context->tp, bp);
+				return -EFSCORRUPTED;
+			} else {
+				expected_level--;
+			}
+
 			btree = dp->d_ops->node_tree_p(node);
 			for (i = 0; i < nodehdr.count; btree++, i++) {
 				if (cursor->hashval
@@ -317,6 +345,10 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 				return 0;
 			}
 			xfs_trans_brelse(context->tp, bp);
+
+			/* We can't point back to the root. */
+			if (cursor->blkno == 0)
+				return -EFSCORRUPTED;
 		}
 	}
 	ASSERT(bp != NULL);
