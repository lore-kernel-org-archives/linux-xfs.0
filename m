Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98At2Xs055599 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 05:55:02 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	j7hLiOjK70KFTb4h for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 03:56:30 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLB0c-0000VW-5a
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:26 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLB0c-00027h-2G
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/14] xfs: xfs_sync_fsdata is redundant
Date: Mon,  8 Oct 2012 21:56:06 +1100
Message-Id: <1349693772-8064-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1349693772-8064-1-git-send-email-david@fromorbit.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Why do we need to write the superblock to disk once we've written
all the data?  We don't actually - the reasons for doing this are
lost in the mists of time, and go back to the way Irix used to drive
VFS flushing.

On linux, this code is only called from two contexts: remount and
.sync_fs. In the remount case, the call is followed by a metadata
sync, which unpins and writes the superblock.  In the sync_fs case,
we only need to force the log to disk to ensure that the superblock
is correctly on disk, so we don't actually need to write it. Hence
the functionality is either redundant or superfluous and thus can be
removed.

Seeing as xfs_quiesce_data is essentially now just a log force,
remove it as well and fold the code back into the two callers.
Neither of them need the log covering check, either, as that is
redundant for the remount case, and unnecessary for the .sync_fs
case.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_super.c |   19 +++++----------
 fs/xfs/xfs_sync.c  |   67 +++++++---------------------------------------------
 2 files changed, 14 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f45ebc5..6b0af18 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1057,7 +1057,6 @@ xfs_fs_sync_fs(
 	int			wait)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
-	int			error;
 
 	/*
 	 * Doing anything during the async pass would be counterproductive.
@@ -1065,10 +1064,7 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
-	error = xfs_quiesce_data(mp);
-	if (error)
-		return -error;
-
+	xfs_log_force(mp, XFS_LOG_SYNC);
 	if (laptop_mode) {
 		/*
 		 * The disk must be active because we're syncing.
@@ -1238,15 +1234,12 @@ xfs_fs_remount(
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
 		/*
-		 * After we have synced the data but before we sync the
-		 * metadata, we need to free up the reserve block pool so that
-		 * the used block count in the superblock on disk is correct at
-		 * the end of the remount. Stash the current reserve pool size
-		 * so that if we get remounted rw, we can return it to the same
-		 * size.
+		 * Before we sync the metadata, we need to free up the reserve
+		 * block pool so that the used block count in the superblock on
+		 * disk is correct at the end of the remount. Stash the current
+		 * reserve pool size so that if we get remounted rw, we can
+		 * return it to the same size.
 		 */
-
-		xfs_quiesce_data(mp);
 		xfs_save_resvblks(mp);
 		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 15be21f..581eb59 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -214,70 +214,16 @@ xfs_inode_ag_iterator(
 	return XFS_ERROR(last_error);
 }
 
-STATIC int
-xfs_sync_fsdata(
-	struct xfs_mount	*mp)
-{
-	struct xfs_buf		*bp;
-	int			error;
-
-	/*
-	 * If the buffer is pinned then push on the log so we won't get stuck
-	 * waiting in the write for someone, maybe ourselves, to flush the log.
-	 *
-	 * Even though we just pushed the log above, we did not have the
-	 * superblock buffer locked at that point so it can become pinned in
-	 * between there and here.
-	 */
-	bp = xfs_getsb(mp, 0);
-	if (xfs_buf_ispinned(bp))
-		xfs_log_force(mp, 0);
-	error = xfs_bwrite(bp);
-	xfs_buf_relse(bp);
-	return error;
-}
-
-/*
- * When remounting a filesystem read-only or freezing the filesystem, we have
- * two phases to execute. This first phase is syncing the data before we
- * quiesce the filesystem, and the second is flushing all the inodes out after
- * we've waited for all the transactions created by the first phase to
- * complete. The second phase ensures that the inodes are written to their
- * location on disk rather than just existing in transactions in the log. This
- * means after a quiesce there is no log replay required to write the inodes to
- * disk (this is the main difference between a sync and a quiesce).
- */
-/*
- * First stage of freeze - no writers will make progress now we are here,
- * so we flush delwri and delalloc buffers here, then wait for all I/O to
- * complete.  Data is frozen at that point. Metadata is not frozen,
- * transactions can still occur here so don't bother emptying the AIL
- * because it'll just get dirty again.
- */
-int
-xfs_quiesce_data(
-	struct xfs_mount	*mp)
-{
-	int			error, error2 = 0;
-
-	/* force out the log */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/* write superblock and hoover up shutdown errors */
-	error = xfs_sync_fsdata(mp);
-
-	/* mark the log as covered if needed */
-	if (xfs_log_need_covered(mp))
-		error2 = xfs_fs_log_dummy(mp);
-
-	return error ? error : error2;
-}
-
 /*
  * Second stage of a quiesce. The data is already synced, now we have to take
  * care of the metadata. New transactions are already blocked, so we need to
  * wait for any remaining transactions to drain out before proceeding.
  *
+ * The second phase ensures that the inodes are written to their
+ * location on disk rather than just existing in transactions in the log. This
+ * means after a quiesce there is no log replay required to write the inodes to
+ * disk (this is the main difference between a sync and a quiesce).
+ *
  * Note: this stops background sync work - the callers must ensure it is started
  * again when appropriate.
  */
@@ -291,6 +237,9 @@ xfs_quiesce_attr(
 	while (atomic_read(&mp->m_active_trans) > 0)
 		delay(100);
 
+	/* force the log to unpin objects from the now complete transactions */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
 	/* reclaim inodes to do any IO before the freeze completes */
 	xfs_reclaim_inodes(mp, 0);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
