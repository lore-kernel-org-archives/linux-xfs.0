Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55996 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbeECSHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:07:17 -0400
Subject: [PATCH 10/12] xfs: btree scrub should check minrecs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:06:57 -0700
Message-ID: <152537081721.16676.15545226030889513612.stgit@magnolia>
In-Reply-To: <152537075334.16676.10600900179473864298.stgit@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Strengthen the btree block header checks to detect the number of records
being less than the btree type's minimum record count.  Certain blocks
are allowed to violate this constraint -- specifically any btree block
at the top of the tree can have fewer than minrecs records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/btree.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index ea972dab1485..2d29dceaa00e 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -454,6 +454,44 @@ xfs_scrub_btree_check_owner(
 	return xfs_scrub_btree_check_block_owner(bs, level, XFS_BUF_ADDR(bp));
 }
 
+/*
+ * Check that this btree block has at least minrecs records or is one of the
+ * special blocks that don't require that.
+ */
+STATIC void
+xfs_scrub_btree_check_minrecs(
+	struct xfs_scrub_btree	*bs,
+	int			level,
+	struct xfs_btree_block	*block)
+{
+	unsigned int		numrecs;
+	int			ok_level;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+
+	/* More records than minrecs means the block is ok. */
+	if (numrecs >= bs->cur->bc_ops->get_minrecs(bs->cur, level))
+		return;
+
+	/*
+	 * Certain btree blocks /can/ have fewer than minrecs records.  Any
+	 * level greater than or equal to the level of the highest dedicated
+	 * btree block are allowed to violate this constraint.
+	 *
+	 * For a btree rooted in a block, the btree root can have fewer than
+	 * minrecs records.  If the btree is rooted in an inode and does not
+	 * store records in the root, the direct children of the root and the
+	 * root itself can have fewer than minrecs records.
+	 */
+	ok_level = bs->cur->bc_nlevels - 1;
+	if (bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		ok_level--;
+	if (level >= ok_level)
+		return;
+
+	xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+}
+
 /*
  * Grab and scrub a btree block given a btree pointer.  Returns block
  * and buffer pointers (if applicable) if they're ok to use.
@@ -491,6 +529,8 @@ xfs_scrub_btree_get_block(
 	if (*pbp)
 		xfs_scrub_buffer_recheck(bs->sc, *pbp);
 
+	xfs_scrub_btree_check_minrecs(bs, level, *pblock);
+
 	/*
 	 * Check the block's owner; this function absorbs error codes
 	 * for us.

