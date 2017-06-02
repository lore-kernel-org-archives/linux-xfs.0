Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29802 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:25:11 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LPAVh010276
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LPA8M010133
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:10 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52LP9CL026014
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:25:09 GMT
Subject: [PATCH 11/13] xfs: return the hash value of a leaf1 directory block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:25:08 -0700
Message-ID: <149643870873.23065.5974641750134566189.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Provide a way to calculate the highest hash value of a leaf1 block.
This will be used by the directory scrubbing code to check the sanity
of hashes in leaf1 directory blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_priv.h |    2 ++
 2 files changed, 30 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index bbd1238..15c1881 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -524,6 +524,34 @@ xfs_dir2_free_hdr_check(
 #endif	/* DEBUG */
 
 /*
+ * Return the last hash value in the leaf1.
+ * Stale entries are ok.
+ */
+xfs_dahash_t					/* hash value */
+xfs_dir2_leaf1_lasthash(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp,		/* leaf buffer */
+	int			*count)		/* count of entries in leaf */
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
  * Return the last hash value in the leaf.
  * Stale entries are ok.
  */
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 576f2d2..c09bca1 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -95,6 +95,8 @@ extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
 /* xfs_dir2_node.c */
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 		struct xfs_buf *lbp);
+extern xfs_dahash_t xfs_dir2_leaf1_lasthash(struct xfs_inode *dp,
+		struct xfs_buf *bp, int *count);
 extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_inode *dp,
 		struct xfs_buf *bp, int *count);
 extern int xfs_dir2_leafn_lookup_int(struct xfs_buf *bp,

