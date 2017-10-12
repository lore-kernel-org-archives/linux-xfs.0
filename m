Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24021 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755944AbdJLL1d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 07:27:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68526C049D7F
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 11:27:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D11C6062F
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 11:27:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: fail if xattr inactivation hits a hole
Date: Thu, 12 Oct 2017 07:27:32 -0400
Message-Id: <20171012112732.39137-1-bfoster@redhat.com>
In-Reply-To: <20171010164756.28390-2-bfoster@redhat.com>
References: <20171010164756.28390-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The child buffer read in xfs_attr3_node_inactive() should never
reach a hole in the attr fork. If this occurs, it is likely due to a
bug. Prior to commit cd87d867 ("xfs: don't crash on unexpected holes
in dir/attr btrees"), this would result in a crash. Now that the
crash has been fixed, this is a silent failure.

Pass -1 to xfs_da3_node_read() from xfs_da3_node_inactive() to
indicate that reading from a hole is an error. This logs an error to
syslog and fails the inode inactivation, leaving the inode on the AG
unlinked list until removed by xfs_repair (or log recovery). Also
update the subsequent code to reflect that the read now returns a
non-NULL buffer or an error.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_attr_inactive.c | 69 ++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index e3a950e..52818ea 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -251,47 +251,44 @@ xfs_attr3_node_inactive(
 		 * traversal of the tree so we may deal with many blocks
 		 * before we come back to this one.
 		 */
-		error = xfs_da3_node_read(*trans, dp, child_fsb, -2, &child_bp,
-						XFS_ATTR_FORK);
+		error = xfs_da3_node_read(*trans, dp, child_fsb, -1, &child_bp,
+					  XFS_ATTR_FORK);
 		if (error)
 			return error;
-		if (child_bp) {
-						/* save for re-read later */
-			child_blkno = XFS_BUF_ADDR(child_bp);
 
-			/*
-			 * Invalidate the subtree, however we have to.
-			 */
-			info = child_bp->b_addr;
-			switch (info->magic) {
-			case cpu_to_be16(XFS_DA_NODE_MAGIC):
-			case cpu_to_be16(XFS_DA3_NODE_MAGIC):
-				error = xfs_attr3_node_inactive(trans, dp,
-							child_bp, level + 1);
-				break;
-			case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
-			case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
-				error = xfs_attr3_leaf_inactive(trans, dp,
-							child_bp);
-				break;
-			default:
-				error = -EIO;
-				xfs_trans_brelse(*trans, child_bp);
-				break;
-			}
-			if (error)
-				return error;
+		/* save for re-read later */
+		child_blkno = XFS_BUF_ADDR(child_bp);
 
-			/*
-			 * Remove the subsidiary block from the cache
-			 * and from the log.
-			 */
-			error = xfs_da_get_buf(*trans, dp, 0, child_blkno,
-				&child_bp, XFS_ATTR_FORK);
-			if (error)
-				return error;
-			xfs_trans_binval(*trans, child_bp);
+		/*
+		 * Invalidate the subtree, however we have to.
+		 */
+		info = child_bp->b_addr;
+		switch (info->magic) {
+		case cpu_to_be16(XFS_DA_NODE_MAGIC):
+		case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+			error = xfs_attr3_node_inactive(trans, dp, child_bp,
+							level + 1);
+			break;
+		case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
+		case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
+			break;
+		default:
+			error = -EIO;
+			xfs_trans_brelse(*trans, child_bp);
+			break;
 		}
+		if (error)
+			return error;
+
+		/*
+		 * Remove the subsidiary block from the cache and from the log.
+		 */
+		error = xfs_da_get_buf(*trans, dp, 0, child_blkno, &child_bp,
+				       XFS_ATTR_FORK);
+		if (error)
+			return error;
+		xfs_trans_binval(*trans, child_bp);
 
 		/*
 		 * If we're not done, re-read the parent to get the next
-- 
2.9.5

