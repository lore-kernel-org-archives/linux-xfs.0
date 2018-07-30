Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47536 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbeG3HDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 03:03:49 -0400
Subject: [PATCH 3/3] xfs: verify icount in superblock write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Jul 2018 22:30:27 -0700
Message-ID: <153292862751.19274.16285578072920087708.stgit@magnolia>
In-Reply-To: <153292860880.19274.14533449137039985963.stgit@magnolia>
References: <153292860880.19274.14533449137039985963.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_sb.c    |    1 +
 fs/xfs/libxfs/xfs_types.c |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h |    1 +
 3 files changed, 36 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 64bc471d57e6..e5972121e82d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -160,6 +160,7 @@ xfs_validate_sb_write(
 	 * cases.
 	 */
 	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
+	    !xfs_verify_icount(mp, sbp->sb_icount) ||
 	    sbp->sb_ifree > sbp->sb_icount) {
 		xfs_warn(mp, "SB summary counter sanity check failed");
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 2e2a243cef2e..57f4fd028898 100644
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
+	return icount >= min && icount < max;
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

