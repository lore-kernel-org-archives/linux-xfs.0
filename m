Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18778 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbcKEA0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:26:39 -0400
Subject: [PATCH 19/39] xfs: scrub directory/attribute btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:26:36 -0700
Message-ID: <147830559620.4165.10485127137913292714.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Provide a way to check the shape and scrub the hashes and records
in a directory or extended attribute btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_dir2_node.c |   28 ++++++++++++++++++++++++++++
 libxfs/xfs_dir2_priv.h |    2 ++
 2 files changed, 30 insertions(+)


diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index b75b432..56f00f7 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -478,6 +478,34 @@ xfs_dir2_free_hdr_check(
  * Stale entries are ok.
  */
 xfs_dahash_t					/* hash value */
+xfs_dir2_leaf1_lasthash(
+	struct xfs_inode *dp,
+	struct xfs_buf	*bp,			/* leaf buffer */
+	int		*count)			/* count of entries in leaf */
+{
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_dir3_icleaf_hdr leafhdr;
+
+	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+
+	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
+	       leafhdr.magic == XFS_DIR3_LEAF1_MAGIC);
+
+	if (count)
+		*count = leafhdr.count;
+	if (!leafhdr.count)
+		return 0;
+
+	ents = dp->d_ops->leaf_ents_p(leaf);
+	return be32_to_cpu(ents[leafhdr.count - 1].hashval);
+}
+
+/*
+ * Return the last hash value in the leaf.
+ * Stale entries are ok.
+ */
+xfs_dahash_t					/* hash value */
 xfs_dir2_leafn_lasthash(
 	struct xfs_inode *dp,
 	struct xfs_buf	*bp,			/* leaf buffer */
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index d04547f..1abd314 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -93,6 +93,8 @@ extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
 /* xfs_dir2_node.c */
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 		struct xfs_buf *lbp);
+extern xfs_dahash_t xfs_dir2_leaf1_lasthash(struct xfs_inode *dp,
+		struct xfs_buf *bp, int *count);
 extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_inode *dp,
 		struct xfs_buf *bp, int *count);
 extern int xfs_dir2_leafn_lookup_int(struct xfs_buf *bp,

