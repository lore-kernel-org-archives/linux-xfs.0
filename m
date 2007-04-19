Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 16:19:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3JNJ5fB000769
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 16:19:07 -0700
Date: Fri, 20 Apr 2007 09:18:59 +1000
From: David Chinner <dgc@sgi.com>
Subject: review [1 of 3]: lazy superblock counters - fix interaction with per-cpu incore counters
Message-ID: <20070419231859.GY48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


We need to reinitialise the per-cpu superblock counters after
we have corrected them in the new recovery phase (summing hte AGF/AGI
counters.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_mount.c |   53 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-04-19 13:46:42.536211213 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-04-19 13:47:41.272642686 +1000
@@ -676,6 +676,10 @@ xfs_initialize_perag_data(xfs_mount_t *m
 	sbp->sb_icount = ialloc;
 	sbp->sb_fdblocks = bfree + bfreelst + btree;
 	XFS_SB_UNLOCK(mp, s);
+
+	/* Fixup the per-cpu counters as well. */
+	xfs_icsb_reinit_counters(mp);
+
 	return 0;
 }
 
@@ -1022,6 +1026,34 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Now the log is mounted, we know if it was an unclean shutdown or
+	 * not. If it was, with the first phase of recovery has completed, we
+	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
+	 * but they are recovered transactionally in the second recovery phase
+	 * later.
+	 *
+	 * Hence we can safely re-initialise incore superblock counters from
+	 * the per-ag data. These may not be correct if the filesystem was not
+	 * cleanly unmounted, so we need to wait for recovery to finish before
+	 * doing this.
+	 *
+	 * If the filesystem was cleanly unmounted, then we can trust the
+	 * values in the superblock to be correct and we don't need to do
+	 * anything here.
+	 *
+	 * If we are currently making the filesystem, the initialisation will
+	 * fail as the perag data is in an undefined state.
+	 */
+
+	if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb) &&
+	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
+	     !mp->m_sb.sb_inprogress) {
+		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
+		if (error) {
+			goto error2;
+		}
+	}
+	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
 	 */
@@ -1084,27 +1116,6 @@ xfs_mountfs(
 		goto error4;
 	}
 
-	/*
-	 * Now recovery has completed, we can initialise incore
-	 * superblock counters from the per-ag data. These may not
-	 * be correct if the filesystem was not cleanly unmounted,
-	 * so we need to wait for recovery to finish before doing this.
-	 *
-	 * If the filesystem was cleanly unmounted, then we can trust
-	 * the values in the superblock to be correct and we don't need
-	 * to do anything here.
-	 *
-	 * If we are currently making the filesystem, the initialisation
-	 * will fail as the perag data is in an undefined state.
-	 */
-	if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb) &&
-	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
-	     !mp->m_sb.sb_inprogress) {
-		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
-		if (error) {
-			goto error4;
-		}
-	}
 
 	/*
 	 * Complete the quota initialisation, post-log-replay component.
