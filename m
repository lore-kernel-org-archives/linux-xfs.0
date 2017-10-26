Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27274 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdJZWte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 18:49:34 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9QMnWgn013326
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 22:49:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9QMnWjE025686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 22:49:32 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9QMnWBB001577
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 22:49:32 GMT
Subject: [PATCH 1/3] xfs: refactor extended attribute list operation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 26 Oct 2017 15:49:30 -0700
Message-ID: <150905817055.20365.4909470444810149179.stgit@magnolia>
In-Reply-To: <150905816454.20365.10479338108395001494.stgit@magnolia>
References: <150905816454.20365.10479338108395001494.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're iterating the attribute list and we can't find our previous
location based off the attribute cursor, we'll instead walk down the
attribute btree from the root trying to find where we left off.  Move
this code into a separate function for later cleanups.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_attr_list.c |  130 +++++++++++++++++++++++++++++-------------------
 1 file changed, 78 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 5816786..021ec5a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -204,19 +204,83 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	return 0;
 }
 
+/*
+ * We didn't find the block & hash mentioned in the cursor state, so
+ * walk down the attr btree looking for the hash.
+ */
 STATIC int
-xfs_attr_node_list(xfs_attr_list_context_t *context)
+xfs_attr_node_list_lookup(
+	struct xfs_attr_list_context	*context,
+	struct attrlist_cursor_kern	*cursor,
+	struct xfs_buf			**pbp)
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
+	struct xfs_da3_icnode_hdr	nodehdr;
+	struct xfs_da_intnode		*node;
+	struct xfs_da_node_entry	*btree;
+	struct xfs_inode		*dp = context->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_trans		*tp = context->tp;
+	struct xfs_buf			*bp;
+	int				i;
+	int				error = 0;
+	uint16_t			magic;
+
+	ASSERT(*pbp == NULL);
+	cursor->blkno = 0;
+	for (;;) {
+		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, &bp,
+				XFS_ATTR_FORK);
+		if (error)
+			return error;
+		node = bp->b_addr;
+		magic = be16_to_cpu(node->hdr.info.magic);
+		if (magic == XFS_ATTR_LEAF_MAGIC ||
+		    magic == XFS_ATTR3_LEAF_MAGIC)
+			break;
+		if (magic != XFS_DA_NODE_MAGIC &&
+		    magic != XFS_DA3_NODE_MAGIC) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					node);
+			goto out_corruptbuf;
+		}
+
+		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
+
+		btree = dp->d_ops->node_tree_p(node);
+		for (i = 0; i < nodehdr.count; btree++, i++) {
+			if (cursor->hashval <= be32_to_cpu(btree->hashval)) {
+				cursor->blkno = be32_to_cpu(btree->before);
+				trace_xfs_attr_list_node_descend(context,
+						btree);
+				break;
+			}
+		}
+		xfs_trans_brelse(tp, bp);
+
+		if (i == nodehdr.count)
+			return 0;
+	}
+
+	*pbp = bp;
+	return 0;
+
+out_corruptbuf:
+	xfs_trans_brelse(tp, bp);
+	return -EFSCORRUPTED;
+}
+
+STATIC int
+xfs_attr_node_list(
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct attrlist_cursor_kern	*cursor;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_da_intnode		*node;
+	struct xfs_buf			*bp;
+	struct xfs_inode		*dp = context->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	int				error;
 
 	trace_xfs_attr_node_list(context);
 
@@ -277,47 +341,9 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 * Note that start of node block is same as start of leaf block.
 	 */
 	if (bp == NULL) {
-		cursor->blkno = 0;
-		for (;;) {
-			uint16_t magic;
-
-			error = xfs_da3_node_read(context->tp, dp,
-						      cursor->blkno, -1, &bp,
-						      XFS_ATTR_FORK);
-			if (error)
-				return error;
-			node = bp->b_addr;
-			magic = be16_to_cpu(node->hdr.info.magic);
-			if (magic == XFS_ATTR_LEAF_MAGIC ||
-			    magic == XFS_ATTR3_LEAF_MAGIC)
-				break;
-			if (magic != XFS_DA_NODE_MAGIC &&
-			    magic != XFS_DA3_NODE_MAGIC) {
-				XFS_CORRUPTION_ERROR("xfs_attr_node_list(3)",
-						     XFS_ERRLEVEL_LOW,
-						     context->dp->i_mount,
-						     node);
-				xfs_trans_brelse(context->tp, bp);
-				return -EFSCORRUPTED;
-			}
-
-			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
-			btree = dp->d_ops->node_tree_p(node);
-			for (i = 0; i < nodehdr.count; btree++, i++) {
-				if (cursor->hashval
-						<= be32_to_cpu(btree->hashval)) {
-					cursor->blkno = be32_to_cpu(btree->before);
-					trace_xfs_attr_list_node_descend(context,
-									 btree);
-					break;
-				}
-			}
-			if (i == nodehdr.count) {
-				xfs_trans_brelse(context->tp, bp);
-				return 0;
-			}
-			xfs_trans_brelse(context->tp, bp);
-		}
+		error = xfs_attr_node_list_lookup(context, cursor, &bp);
+		if (error || !bp)
+			return error;
 	}
 	ASSERT(bp != NULL);
 

