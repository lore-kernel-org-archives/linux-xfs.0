Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59890 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbeECSHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:07:22 -0400
Subject: [PATCH 11/12] xfs: refactor scrub transaction allocation function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:07:03 -0700
Message-ID: <152537082334.16676.5389122114896718490.stgit@magnolia>
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

Since the transaction allocation helper is about to become more complex,
move it to common.c and remove the redundant parameters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/bmap.c   |    3 +--
 fs/xfs/scrub/common.c |   16 +++++++++++++---
 fs/xfs/scrub/common.h |   14 +-------------
 fs/xfs/scrub/inode.c  |    5 ++---
 4 files changed, 17 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index c28ff2ec201a..42a115e83739 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -51,7 +51,6 @@ xfs_scrub_setup_inode_bmap(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
 	error = xfs_scrub_get_inode(sc, ip);
@@ -75,7 +74,7 @@ xfs_scrub_setup_inode_bmap(
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 335c7a305e15..62b33c99efe4 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -570,13 +570,24 @@ xfs_scrub_ag_init(
 
 /* Per-scrubber setup functions */
 
+/*
+ * Grab an empty transaction so that we can re-grab locked buffers if
+ * one of our btrees turns out to be cyclic.
+ */
+int
+xfs_scrub_trans_alloc(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+}
+
 /* Set us up with a transaction and an empty context. */
 int
 xfs_scrub_setup_fs(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
+	return xfs_scrub_trans_alloc(sc);
 }
 
 /* Set us up with AG headers and btree cursors. */
@@ -697,7 +708,6 @@ xfs_scrub_setup_inode_contents(
 	struct xfs_inode		*ip,
 	unsigned int			resblks)
 {
-	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
 	error = xfs_scrub_get_inode(sc, ip);
@@ -707,7 +717,7 @@ xfs_scrub_setup_inode_contents(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ad736c411287..5d78bb9602ab 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -38,19 +38,7 @@ xfs_scrub_should_terminate(
 	return false;
 }
 
-/*
- * Grab an empty transaction so that we can re-grab locked buffers if
- * one of our btrees turns out to be cyclic.
- */
-static inline int
-xfs_scrub_trans_alloc(
-	struct xfs_scrub_metadata	*sm,
-	struct xfs_mount		*mp,
-	struct xfs_trans		**tpp)
-{
-	return xfs_trans_alloc_empty(mp, tpp);
-}
-
+int xfs_scrub_trans_alloc(struct xfs_scrub_context *sc);
 bool xfs_scrub_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
 bool xfs_scrub_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 8532fc7be838..550c0cf70a92 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -55,7 +55,6 @@ xfs_scrub_setup_inode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
 	/*
@@ -68,7 +67,7 @@ xfs_scrub_setup_inode(
 		break;
 	case -EFSCORRUPTED:
 	case -EFSBADCRC:
-		return xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+		return xfs_scrub_trans_alloc(sc);
 	default:
 		return error;
 	}
@@ -76,7 +75,7 @@ xfs_scrub_setup_inode(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;

