Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730846AbeGSATl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 20:19:41 -0400
Subject: [PATCH 1/3] xfs: detect and fix bad summary counts at mount
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 16:39:23 -0700
Message-ID: <153195716331.16758.9434941216951792875.stgit@magnolia>
In-Reply-To: <153195715716.16758.18150859087945516040.stgit@magnolia>
References: <153195715716.16758.18150859087945516040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Filippo Giunchedi <fgiunchedi@wikimedia.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Filippo Giunchedi complained that xfs doesn't even perform basic sanity
checks of the fs summary counters at mount time.  Therefore, recalculate
the summary counters from the AGFs after log recovery if the counts were
bad (or we had to recover the fs).  Enhance the recalculation routine to
fail the mount entirely if the new values are also obviously incorrect.

We use a mount state flag to record the "bad summary count" state so
that the (subsequent) online fsck patches can detect subtlely incorrect
counts and set the flag; clear it userspace asks for a repair; or force
a recalculation at the next mount if nobody fixes it by unmount time.

Reported-by: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |   21 +++++++++++--
 fs/xfs/xfs_mount.c     |   80 ++++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_mount.h     |    1 +
 3 files changed, 73 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 350119eeaecb..b3ad15956366 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -804,6 +804,7 @@ xfs_initialize_perag_data(
 	uint64_t	bfree = 0;
 	uint64_t	bfreelst = 0;
 	uint64_t	btree = 0;
+	uint64_t	fdblocks;
 	int		error;
 
 	for (index = 0; index < agcount; index++) {
@@ -827,17 +828,31 @@ xfs_initialize_perag_data(
 		btree += pag->pagf_btreeblks;
 		xfs_perag_put(pag);
 	}
+	fdblocks = bfree + bfreelst + btree;
+
+	/*
+	 * If the new summary counts are obviously incorrect, fail the
+	 * mount operation because that implies the AGFs are also corrupt.
+	 * Clear BAD_SUMMARY so that we don't unmount with a dirty log, which
+	 * will prevent xfs_repair from fixing anything.
+	 */
+	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
+		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	/* Overwrite incore superblock counters with just-read data */
 	spin_lock(&mp->m_sb_lock);
 	sbp->sb_ifree = ifree;
 	sbp->sb_icount = ialloc;
-	sbp->sb_fdblocks = bfree + bfreelst + btree;
+	sbp->sb_fdblocks = fdblocks;
 	spin_unlock(&mp->m_sb_lock);
 
 	xfs_reinit_percpu_counters(mp);
-
-	return 0;
+out:
+	mp->m_flags &= ~XFS_MOUNT_BAD_SUMMARY;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a3378252baa1..60462c35ad4b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -606,6 +606,56 @@ xfs_default_resblks(xfs_mount_t *mp)
 	return resblks;
 }
 
+/* Ensure the summary counts are correct. */
+STATIC int
+xfs_check_summary_counts(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * The AG0 superblock verifier rejects in-progress filesystems,
+	 * so we should never see the flag set this far into mounting.
+	 */
+	if (mp->m_sb.sb_inprogress) {
+		xfs_err(mp, "sb_inprogress set after log recovery??");
+		WARN_ON(1);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Now the log is mounted, we know if it was an unclean shutdown or
+	 * not. If it was, with the first phase of recovery has completed, we
+	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
+	 * but they are recovered transactionally in the second recovery phase
+	 * later.
+	 *
+	 * If the log was clean when we mounted, we can check the summary
+	 * counters.  If any of them are obviously incorrect, we can recompute
+	 * them from the AGF headers in the next step.
+	 */
+	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
+	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
+	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
+		mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
+
+	/*
+	 * We can safely re-initialise incore superblock counters from the
+	 * per-ag data. These may not be correct if the filesystem was not
+	 * cleanly unmounted, so we waited for recovery to finish before doing
+	 * this.
+	 *
+	 * If the filesystem was cleanly unmounted or the previous check did
+	 * not flag anything weird, then we can trust the values in the
+	 * superblock to be correct and we don't need to do anything here.
+	 * Otherwise, recalculate the summary counters.
+	 */
+	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
+	    !(mp->m_flags & XFS_MOUNT_BAD_SUMMARY))
+		return 0;
+
+	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -831,32 +881,10 @@ xfs_mountfs(
 		goto out_fail_wait;
 	}
 
-	/*
-	 * Now the log is mounted, we know if it was an unclean shutdown or
-	 * not. If it was, with the first phase of recovery has completed, we
-	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
-	 * but they are recovered transactionally in the second recovery phase
-	 * later.
-	 *
-	 * Hence we can safely re-initialise incore superblock counters from
-	 * the per-ag data. These may not be correct if the filesystem was not
-	 * cleanly unmounted, so we need to wait for recovery to finish before
-	 * doing this.
-	 *
-	 * If the filesystem was cleanly unmounted, then we can trust the
-	 * values in the superblock to be correct and we don't need to do
-	 * anything here.
-	 *
-	 * If we are currently making the filesystem, the initialisation will
-	 * fail as the perag data is in an undefined state.
-	 */
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
-	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
-	     !mp->m_sb.sb_inprogress) {
-		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
-		if (error)
-			goto out_log_dealloc;
-	}
+	/* Make sure the summary counts are ok. */
+	error = xfs_check_summary_counts(mp);
+	if (error)
+		goto out_log_dealloc;
 
 	/*
 	 * Get and sanity-check the root inode.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 245349d1e23f..f08907db9c61 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -202,6 +202,7 @@ typedef struct xfs_mount {
 						   must be synchronous except
 						   for space allocations */
 #define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
+#define XFS_MOUNT_BAD_SUMMARY	(1ULL << 2)	/* summary counters are bad */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for

