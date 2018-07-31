Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeGaFeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 01:34:11 -0400
Subject: [PATCH 3/4] xfs: verify icount in superblock write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jul 2018 20:55:56 -0700
Message-ID: <153300935638.5164.15451295330900701809.stgit@magnolia>
In-Reply-To: <153300933773.5164.7520087911614107147.stgit@magnolia>
References: <153300933773.5164.7520087911614107147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Bill O'Donnell <billodo@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a helper predicate to check the inode count for sanity, then use it
in the superblock write verifier to inspect sb_icount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c    |    3 ++-
 fs/xfs/libxfs/xfs_types.c |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h |    1 +
 3 files changed, 37 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 3d29f4a5242f..05e7ed1b8022 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -154,9 +154,10 @@ xfs_validate_sb_write(
 	 * Carry out additional sb summary counter sanity checks when we write
 	 * the superblock.  We skip this in the read validator because there
 	 * could be newer superblocks in the log and if the values are garbage
-	 * we'll recalculate them at the end of log mount.
+	 * even after replay we'll recalculate them at the end of log mount.
 	 */
 	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
+	    !xfs_verify_icount(mp, sbp->sb_icount) ||
 	    sbp->sb_ifree > sbp->sb_icount) {
 		xfs_warn(mp, "SB summary counter sanity check failed");
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 2e2a243cef2e..33a5ca346baf 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -171,3 +171,37 @@ xfs_verify_rtbno(
 {
 	return rtbno < mp->m_sb.sb_rblocks;
 }
+
+/* Calculate the range of valid icount values. */
+static void
+xfs_icount_range(
+	struct xfs_mount	*mp,
+	unsigned long long	*min,
+	unsigned long long	*max)
+{
+	unsigned long long	nr_inos = 0;
+	xfs_agnumber_t		agno;
+
+	/* root, rtbitmap, rtsum all live in the first chunk */
+	*min = XFS_INODES_PER_CHUNK;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		xfs_agino_t	first, last;
+
+		xfs_agino_range(mp, agno, &first, &last);
+		nr_inos += last - first + 1;
+	}
+	*max = nr_inos;
+}
+
+/* Sanity-checking of inode counts. */
+bool
+xfs_verify_icount(
+	struct xfs_mount	*mp,
+	unsigned long long	icount)
+{
+	unsigned long long	min, max;
+
+	xfs_icount_range(mp, &min, &max);
+	return icount >= min && icount <= max;
+}
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 4055d62f690c..b9e6c89284c3 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -165,5 +165,6 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 
 #endif	/* __XFS_TYPES_H__ */

