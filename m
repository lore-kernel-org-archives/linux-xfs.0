Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33268 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbfFRVAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:00:13 -0400
Date: Tue, 18 Jun 2019 13:59:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: move xfs_ino_geometry to xfs_mount.h
Message-ID: <20190618205935.GS5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

The inode geometry structure isn't related to ondisk format; it's
support for the mount structure.  Move it to xfs_mount.h.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   41 -----------------------------------------
 fs/xfs/xfs_mount.h         |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5729474e362f..c968b60cee15 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1694,45 +1694,4 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
-struct xfs_ino_geometry {
-	/* Maximum inode count in this filesystem. */
-	uint64_t	maxicount;
-
-	/* Actual inode cluster buffer size, in bytes. */
-	unsigned int	inode_cluster_size;
-
-	/*
-	 * Desired inode cluster buffer size, in bytes.  This value is not
-	 * rounded up to at least one filesystem block, which is necessary for
-	 * the sole purpose of validating sb_spino_align.  Runtime code must
-	 * only ever use inode_cluster_size.
-	 */
-	unsigned int	inode_cluster_size_raw;
-
-	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
-	unsigned int	inodes_per_cluster;
-	unsigned int	blocks_per_cluster;
-
-	/* Inode cluster alignment. */
-	unsigned int	cluster_align;
-	unsigned int	cluster_align_inodes;
-	unsigned int	inoalign_mask;	/* mask sb_inoalignmt if used */
-
-	unsigned int	inobt_mxr[2]; /* max inobt btree records */
-	unsigned int	inobt_mnr[2]; /* min inobt btree records */
-	unsigned int	inobt_maxlevels; /* max inobt btree levels. */
-
-	/* Size of inode allocations under normal operation. */
-	unsigned int	ialloc_inos;
-	unsigned int	ialloc_blks;
-
-	/* Minimum inode blocks for a sparse allocation. */
-	unsigned int	ialloc_min_blks;
-
-	/* stripe unit inode alignment */
-	unsigned int	ialloc_align;
-
-	unsigned int	agino_log;	/* #bits for agino in inum */
-};
-
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 448986d260dd..7591c1b70e84 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -57,6 +57,48 @@ struct xfs_error_cfg {
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
+/* Computed inode geometry for the filesystem. */
+struct xfs_ino_geometry {
+	/* Maximum inode count in this filesystem. */
+	uint64_t	maxicount;
+
+	/* Actual inode cluster buffer size, in bytes. */
+	unsigned int	inode_cluster_size;
+
+	/*
+	 * Desired inode cluster buffer size, in bytes.  This value is not
+	 * rounded up to at least one filesystem block, which is necessary for
+	 * the sole purpose of validating sb_spino_align.  Runtime code must
+	 * only ever use inode_cluster_size.
+	 */
+	unsigned int	inode_cluster_size_raw;
+
+	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
+	unsigned int	inodes_per_cluster;
+	unsigned int	blocks_per_cluster;
+
+	/* Inode cluster alignment. */
+	unsigned int	cluster_align;
+	unsigned int	cluster_align_inodes;
+	unsigned int	inoalign_mask;	/* mask sb_inoalignmt if used */
+
+	unsigned int	inobt_mxr[2]; /* max inobt btree records */
+	unsigned int	inobt_mnr[2]; /* min inobt btree records */
+	unsigned int	inobt_maxlevels; /* max inobt btree levels. */
+
+	/* Size of inode allocations under normal operation. */
+	unsigned int	ialloc_inos;
+	unsigned int	ialloc_blks;
+
+	/* Minimum inode blocks for a sparse allocation. */
+	unsigned int	ialloc_min_blks;
+
+	/* stripe unit inode alignment */
+	unsigned int	ialloc_align;
+
+	unsigned int	agino_log;	/* #bits for agino in inum */
+};
+
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
