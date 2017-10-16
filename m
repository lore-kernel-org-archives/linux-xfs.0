Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28662 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755734AbdJPTtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 15:49:35 -0400
Date: Mon, 16 Oct 2017 12:49:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 05/30] xfs: create inode pointer verifiers
Message-ID: <20171016194932.GH4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777247562.1724.7094279740133124537.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777247562.1724.7094279740133124537.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

Create some helper functions to check that inode pointers point to
somewhere within the filesystem and not at the static AG metadata.
Move xfs_internal_inum and create a directory inode check function.
We will use these functions in scrub and elsewhere.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix names, fix incorrect results returned from agino_range, remove
unnecessary tests
---
 fs/xfs/libxfs/xfs_dir2.c   |   19 +--------
 fs/xfs/libxfs/xfs_ialloc.c |   90 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    7 +++
 fs/xfs/xfs_itable.c        |   10 -----
 fs/xfs/xfs_itable.h        |    2 -
 5 files changed, 100 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index ccf9783..ee5e916 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -30,6 +30,7 @@
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_ialloc.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
@@ -202,22 +203,8 @@ xfs_dir_ino_validate(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino)
 {
-	xfs_agblock_t	agblkno;
-	xfs_agino_t	agino;
-	xfs_agnumber_t	agno;
-	int		ino_ok;
-	int		ioff;
-
-	agno = XFS_INO_TO_AGNO(mp, ino);
-	agblkno = XFS_INO_TO_AGBNO(mp, ino);
-	ioff = XFS_INO_TO_OFFSET(mp, ino);
-	agino = XFS_OFFBNO_TO_AGINO(mp, agblkno, ioff);
-	ino_ok =
-		agno < mp->m_sb.sb_agcount &&
-		agblkno < mp->m_sb.sb_agblocks &&
-		agblkno != 0 &&
-		ioff < (1 << mp->m_sb.sb_inopblog) &&
-		XFS_AGINO_TO_INO(mp, agno, agino) == ino;
+	bool		ino_ok = xfs_verify_dir_ino(mp, ino);
+
 	if (unlikely(XFS_TEST_ERROR(!ino_ok, mp, XFS_ERRTAG_DIR_INO_VALIDATE))) {
 		xfs_warn(mp, "Invalid inode number 0x%Lx",
 				(unsigned long long) ino);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index dfd6439..e11f8af 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2664,3 +2664,93 @@ xfs_ialloc_pagi_init(
 		xfs_trans_brelse(tp, bp);
 	return 0;
 }
+
+/* Calculate the first and last possible inode number in an AG. */
+void
+xfs_ialloc_agino_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		*first,
+	xfs_agino_t		*last)
+{
+	xfs_agblock_t		bno;
+	xfs_agblock_t		eoag;
+
+	eoag = xfs_ag_block_count(mp, agno);
+
+	/*
+	 * Calculate the first inode, which will be in the first
+	 * cluster-aligned block after the AGFL.
+	 */
+	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
+			xfs_ialloc_cluster_alignment(mp));
+	*first = XFS_OFFBNO_TO_AGINO(mp, bno, 0);
+
+	/*
+	 * Calculate the last inode, which will be at the end of the
+	 * last (aligned) cluster that can be allocated in the AG.
+	 */
+	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
+	*last = XFS_OFFBNO_TO_AGINO(mp, bno, 0) - 1;
+}
+
+/*
+ * Verify that an AG inode number pointer neither points outside the AG
+ * nor points at static metadata.
+ */
+bool
+xfs_verify_agino(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino)
+{
+	xfs_agino_t		first;
+	xfs_agino_t		last;
+
+	xfs_ialloc_agino_range(mp, agno, &first, &last);
+	return agino >= first && agino <= last;
+}
+
+/*
+ * Verify that an FS inode number pointer neither points outside the
+ * filesystem nor points at static AG metadata.
+ */
+bool
+xfs_verify_ino(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
+
+	if (agno >= mp->m_sb.sb_agcount)
+		return false;
+	if (XFS_AGINO_TO_INO(mp, agno, agino) != ino)
+		return false;
+	return xfs_verify_agino(mp, agno, agino);
+}
+
+/* Is this an internal inode number? */
+bool
+xfs_internal_inum(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
+		(xfs_sb_version_hasquota(&mp->m_sb) &&
+		 xfs_is_quota_inode(&mp->m_sb, ino));
+}
+
+/*
+ * Verify that a directory entry's inode number doesn't point at an internal
+ * inode, empty space, or static AG metadata.
+ */
+bool
+xfs_verify_dir_ino(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	if (xfs_internal_inum(mp, ino))
+		return false;
+	return xfs_verify_ino(mp, ino);
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index b32cfb5..d2bdcd5 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -173,5 +173,12 @@ void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
+void xfs_ialloc_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agino_t *first, xfs_agino_t *last);
+bool xfs_verify_agino(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agino_t agino);
+bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
+bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
+bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c393a2f..0172d0b 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -31,16 +31,6 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 
-int
-xfs_internal_inum(
-	xfs_mount_t	*mp,
-	xfs_ino_t	ino)
-{
-	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 xfs_is_quota_inode(&mp->m_sb, ino)));
-}
-
 /*
  * Return stat information for one inode.
  * Return 0 if ok, else errno.
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 17e86e0..6ea8b39 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -96,6 +96,4 @@ xfs_inumbers(
 	void			__user *buffer, /* buffer with inode info */
 	inumbers_fmt_pf		formatter);
 
-int xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
-
 #endif	/* __XFS_ITABLE_H__ */
