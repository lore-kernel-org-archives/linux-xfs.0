Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 06:56:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DDtnu0012359
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:55:49 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75534126BEDF
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:18 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id qAjmpmumluliKUPy for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:18 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVcd-0007UI-AL
	for xfs@oss.sgi.com; Sat, 13 Sep 2008 23:57:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/10] XFS: Kill xfs_sync()
Date: Sat, 13 Sep 2008 23:57:09 +1000
Message-Id: <1221314230-28618-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314230-28618-1-git-send-email-david@fromorbit.com>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There are no more callers to xfs_sync() now, so remove the
function altogther.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |  132 +++++--------------------------------------
 fs/xfs/linux-2.6/xfs_sync.h |   25 +-------
 fs/xfs/quota/xfs_qm.c       |   10 +--
 fs/xfs/xfs_iget.c           |   15 ++---
 4 files changed, 29 insertions(+), 153 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 91a54a7..ed24435 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -316,11 +316,21 @@ xfs_sync_fsdata(
 }
 
 /*
- * First stage of freeze - no more writers will make progress now we are here,
+ * When remounting a filesystem read-only or freezing the filesystem, we have
+ * two phases to execute. This first phase is syncing the data before we
+ * quiesce the filesystem, and the second is flushing all the inodes out after
+ * we've waited for all the transactions created by the first phase to
+ * complete. The second phase ensures that the inodes are written to their
+ * location on disk rather than just existing in transactions in the log. This
+ * means after a quiesce there is no log replay required to write the inodes to
+ * disk (this is the main difference between a sync and a quiesce).
+ */
+/*
+ * First stage of freeze - no writers will make progress now we are here,
  * so we flush delwri and delalloc buffers here, then wait for all I/O to
  * complete.  Data is frozen at that point. Metadata is not frozen,
- * transactions can still occur here so don't bother flushing the buftarg (i.e
- * SYNC_QUIESCE) because it'll just get dirty again.
+ * transactions can still occur here so don't bother flushing the buftarg
+ * because it'll just get dirty again.
  */
 int
 xfs_quiesce_data(
@@ -337,11 +347,10 @@ xfs_quiesce_data(
 	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
 	XFS_QM_DQSYNC(mp, SYNC_WAIT);
 
-	/* write superblock and hoover shutdown errors */
+	/* write superblock and hoover up shutdown errors */
 	error = xfs_sync_fsdata(mp, 0);
 
-	/* flush devices */
-	XFS_bflush(mp->m_ddev_targp);
+	/* flush data-only devices */
 	if (mp->m_rtdev_targp)
 		XFS_bflush(mp->m_rtdev_targp);
 
@@ -349,117 +358,6 @@ xfs_quiesce_data(
 }
 
 /*
- * xfs_sync flushes any pending I/O to file system vfsp.
- *
- * This routine is called by vfs_sync() to make sure that things make it
- * out to disk eventually, on sync() system calls to flush out everything,
- * and when the file system is unmounted.  For the vfs_sync() case, all
- * we really need to do is sync out the log to make all of our meta-data
- * updates permanent (except for timestamps).  For calls from pflushd(),
- * dirty pages are kept moving by calling pdflush() on the inodes
- * containing them.  We also flush the inodes that we can lock without
- * sleeping and the superblock if we can lock it without sleeping from
- * vfs_sync() so that items at the tail of the log are always moving out.
- *
- * Flags:
- *      SYNC_BDFLUSH - We're being called from vfs_sync() so we don't want
- *		       to sleep if we can help it.  All we really need
- *		       to do is ensure that the log is synced at least
- *		       periodically.  We also push the inodes and
- *		       superblock if we can lock them without sleeping
- *			and they are not pinned.
- *      SYNC_ATTR    - We need to flush the inodes. Now handled by direct calls
- *		       to xfs_sync_inodes().
- *      SYNC_WAIT    - All the flushes that take place in this call should
- *		       be synchronous.
- *      SYNC_DELWRI  - This tells us to push dirty pages associated with
- *		       inodes.  SYNC_WAIT and SYNC_BDFLUSH are used to
- *		       determine if they should be flushed sync, async, or
- *		       delwri.
- *      SYNC_FSDATA  - This indicates that the caller would like to make
- *		       sure the superblock is safe on disk.  We can ensure
- *		       this by simply making sure the log gets flushed
- *		       if SYNC_BDFLUSH is set, and by actually writing it
- *		       out otherwise.
- *	SYNC_IOWAIT  - The caller wants us to wait for all data I/O to complete
- *		       before we return (including direct I/O). Forms the drain
- *		       side of the write barrier needed to safely quiesce the
- *		       filesystem.
- *
- */
-int
-xfs_sync(
-	xfs_mount_t	*mp,
-	int		flags)
-{
-	int		error;
-	int		last_error = 0;
-	uint		log_flags = XFS_LOG_FORCE;
-
-	ASSERT(!(flags & SYNC_ATTR));
-
-	/*
-	 * Get the Quota Manager to flush the dquots.
-	 *
-	 * If XFS quota support is not enabled or this filesystem
-	 * instance does not use quotas XFS_QM_DQSYNC will always
-	 * return zero.
-	 */
-	error = XFS_QM_DQSYNC(mp, flags);
-	if (error) {
-		/*
-		 * If we got an IO error, we will be shutting down.
-		 * So, there's nothing more for us to do here.
-		 */
-		ASSERT(error != EIO || XFS_FORCED_SHUTDOWN(mp));
-		if (XFS_FORCED_SHUTDOWN(mp))
-			return XFS_ERROR(error);
-	}
-
-	if (flags & SYNC_IOWAIT)
-		xfs_filestream_flush(mp);
-
-	/*
-	 * Sync out the log.  This ensures that the log is periodically
-	 * flushed even if there is not enough activity to fill it up.
-	 */
-	if (flags & SYNC_WAIT)
-		log_flags |= XFS_LOG_SYNC;
-
-	xfs_log_force(mp, (xfs_lsn_t)0, log_flags);
-
-	if (flags & SYNC_DELWRI) {
-		if (flags & SYNC_BDFLUSH)
-			xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
-		else
-			error = xfs_sync_inodes(mp, flags);
-		/*
-		 * Flushing out dirty data above probably generated more
-		 * log activity, so if this isn't vfs_sync() then flush
-		 * the log again.
-		 */
-		xfs_log_force(mp, 0, log_flags);
-	}
-
-	if (flags & SYNC_FSDATA) {
-		error = xfs_sync_fsdata(mp, flags);
-		if (error)
-			last_error = error;
-	}
-
-	/*
-	 * Now check to see if the log needs a "dummy" transaction.
-	 */
-	if (!(flags & SYNC_REMOUNT) && xfs_log_need_covered(mp)) {
-		error = xfs_commit_dummy_trans(mp, log_flags);
-		if (error)
-			return error;
-	}
-
-	return XFS_ERROR(last_error);
-}
-
-/*
  * Enqueue a work item to be picked up by the vfs xfssyncd thread.
  * Doing this has two advantages:
  * - It saves on stack space, which is tight in certain situations
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 2509db0..4591dc0 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -28,31 +28,14 @@ typedef struct bhv_vfs_sync_work {
 } bhv_vfs_sync_work_t;
 
 #define SYNC_ATTR		0x0001	/* sync attributes */
-#define SYNC_DELWRI		0x0004	/* look at delayed writes */
-#define SYNC_WAIT		0x0008	/* wait for i/o to complete */
-#define SYNC_BDFLUSH		0x0010	/* BDFLUSH is calling -- don't block */
-#define SYNC_FSDATA		0x0020	/* flush fs data (e.g. superblocks) */
-#define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
-#define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
-#define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
-
-/*
- * When remounting a filesystem read-only or freezing the filesystem,
- * we have two phases to execute. This first phase is syncing the data
- * before we quiesce the fielsystem, and the second is flushing all the
- * inodes out after we've waited for all the transactions created by
- * the first phase to complete. The second phase uses SYNC_INODE_QUIESCE
- * to ensure that the inodes are written to their location on disk
- * rather than just existing in transactions in the log. This means
- * after a quiesce there is no log replay required to write the inodes
- * to disk (this is the main difference between a sync and a quiesce).
- */
-#define SYNC_DATA_QUIESCE	(SYNC_DELWRI|SYNC_FSDATA|SYNC_WAIT|SYNC_IOWAIT)
+#define SYNC_DELWRI		0x0002	/* look at delayed writes */
+#define SYNC_WAIT		0x0004	/* wait for i/o to complete */
+#define SYNC_BDFLUSH		0x0008	/* BDFLUSH is calling -- don't block */
+#define SYNC_IOWAIT		0x0010  /* wait for all I/O to complete */
 
 int xfs_syncd_init(struct xfs_mount *mp);
 void xfs_syncd_stop(struct xfs_mount *mp);
 
-int xfs_sync(struct xfs_mount *mp, int flags);
 int xfs_sync_inodes(struct xfs_mount *mp, int flags);
 int xfs_sync_fsdata(struct xfs_mount *mp, int flags);
 
diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
index df0ffef..46465e7 100644
--- a/fs/xfs/quota/xfs_qm.c
+++ b/fs/xfs/quota/xfs_qm.c
@@ -987,14 +987,10 @@ xfs_qm_dqdetach(
 }
 
 /*
- * This is called by VFS_SYNC and flags arg determines the caller,
- * and its motives, as done in xfs_sync.
- *
- * vfs_sync: SYNC_FSDATA|SYNC_ATTR|SYNC_BDFLUSH 0x31
- * syscall sync: SYNC_FSDATA|SYNC_ATTR|SYNC_DELWRI 0x25
- * umountroot : SYNC_WAIT | SYNC_CLOSE | SYNC_ATTR | SYNC_FSDATA
+ * This is called to sync quotas. We can be told to use non-blocking
+ * semantics by either the SYNC_BDFLUSH flag or the absence of the
+ * SYNC_WAIT flag.
  */
-
 int
 xfs_qm_sync(
 	xfs_mount_t	*mp,
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 60554ce..7932551 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -443,14 +443,13 @@ xfs_ireclaim(xfs_inode_t *ip)
 	xfs_iextract(ip);
 
 	/*
-	 * Here we do a spurious inode lock in order to coordinate with
-	 * xfs_sync().  This is because xfs_sync() references the inodes
-	 * in the mount list without taking references on the corresponding
-	 * vnodes.  We make that OK here by ensuring that we wait until
-	 * the inode is unlocked in xfs_sync() before we go ahead and
-	 * free it.  We get both the regular lock and the io lock because
-	 * the xfs_sync() code may need to drop the regular one but will
-	 * still hold the io lock.
+	 * Here we do a spurious inode lock in order to coordinate with inode
+	 * cache radix tree lookups.  This is because the lookup can reference
+	 * the inodes in the cache without taking references.  We make that OK
+	 * here by ensuring that we wait until the inode is unlocked after the
+	 * lookup before we go ahead and free it.  We get both the ilock and
+	 * the iolock because the code may need to drop the ilock one but will
+	 * still hold the iolock.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
-- 
1.5.6
