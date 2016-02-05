Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D05529E0D
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:41:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F4CD304059
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:41:21 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nhcAGBSQ6LApXR9y for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:41:18 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRUPV-0000Ri-9L
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRUPV-0005MS-8b
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs: remove XBF_DONE flag wrapper macros
Date: Fri,  5 Feb 2016 11:37:58 +1100
Message-Id: <1454632683-20543-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1454632683-20543-1-git-send-email-david@fromorbit.com>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

They only set/clear/check a flag, no need for obfuscating this
with a macro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c         | 2 +-
 fs/xfs/xfs_buf.h         | 4 ----
 fs/xfs/xfs_buf_item.c    | 6 +++---
 fs/xfs/xfs_inode.c       | 2 +-
 fs/xfs/xfs_log.c         | 4 ++--
 fs/xfs/xfs_log_recover.c | 2 +-
 fs/xfs/xfs_mount.c       | 2 +-
 fs/xfs/xfs_trans_buf.c   | 4 ++--
 8 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3c61547..5f7ff50 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -650,7 +650,7 @@ xfs_buf_read_map(
 	if (bp) {
 		trace_xfs_buf_read(bp, flags, _RET_IP_);
 
-		if (!XFS_BUF_ISDONE(bp)) {
+		if (!(bp->b_flags & XBF_DONE)) {
 			XFS_STATS_INC(target->bt_mount, xb_get_read);
 			bp->b_ops = ops;
 			_xfs_buf_read(bp, flags);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c75721a..03b5d3a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -321,10 +321,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
 #define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 
-#define XFS_BUF_DONE(bp)	((bp)->b_flags |= XBF_DONE)
-#define XFS_BUF_UNDONE(bp)	((bp)->b_flags &= ~XBF_DONE)
-#define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
-
 #define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
 #define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
 #define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 82f676f..2d2029d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -470,7 +470,7 @@ xfs_buf_item_unpin(
 		xfs_buf_hold(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioerror(bp, -EIO);
-		XFS_BUF_UNDONE(bp);
+		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
 		xfs_buf_ioend(bp);
 	}
@@ -951,7 +951,7 @@ xfs_buf_iodone_callbacks(
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
 		xfs_buf_stale(bp);
-		XFS_BUF_DONE(bp);
+		bp->b_flags |= XBF_DONE;
 		trace_xfs_buf_item_iodone(bp, _RET_IP_);
 		goto do_callbacks;
 	}
@@ -997,7 +997,7 @@ xfs_buf_iodone_callbacks(
 	 * sure to return the error to the caller of xfs_bwrite().
 	 */
 	xfs_buf_stale(bp);
-	XFS_BUF_DONE(bp);
+	bp->b_flags |= XBF_DONE;
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 205796f..415c70a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3297,7 +3297,7 @@ cluster_corrupt_out:
 		 * mark it as stale and brelse.
 		 */
 		if (bp->b_iodone) {
-			XFS_BUF_UNDONE(bp);
+			bp->b_flags &= ~XBF_DONE;
 			xfs_buf_stale(bp);
 			xfs_buf_ioerror(bp, -EIO);
 			xfs_buf_ioend(bp);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9c9a1c9..aa8c9bf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3979,7 +3979,7 @@ xfs_log_force_umount(
 	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
 		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 		if (mp->m_sb_bp)
-			XFS_BUF_DONE(mp->m_sb_bp);
+			mp->m_sb_bp->b_flags |= XBF_DONE;
 		return 0;
 	}
 
@@ -4009,7 +4009,7 @@ xfs_log_force_umount(
 	spin_lock(&log->l_icloglock);
 	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 	if (mp->m_sb_bp)
-		XFS_BUF_DONE(mp->m_sb_bp);
+		mp->m_sb_bp->b_flags |= XBF_DONE;
 
 	/*
 	 * Mark the log and the iclogs with IO error flags to prevent any
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bd6f23b..97cfeab 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4926,7 +4926,7 @@ xlog_do_recover(
 	 * updates, re-read in the superblock and reverify it.
 	 */
 	bp = xfs_getsb(log->l_mp, 0);
-	XFS_BUF_UNDONE(bp);
+	bp->b_flags &= ~XBF_DONE;
 	ASSERT(!(XFS_BUF_ISWRITE(bp)));
 	XFS_BUF_READ(bp);
 	XFS_BUF_UNASYNC(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d306105..986290c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1284,7 +1284,7 @@ xfs_getsb(
 	}
 
 	xfs_buf_hold(bp);
-	ASSERT(XFS_BUF_ISDONE(bp));
+	ASSERT(bp->b_flags & XBF_DONE);
 	return bp;
 }
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 7579841..ed6f61f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -155,7 +155,7 @@ xfs_trans_get_buf_map(
 		ASSERT(xfs_buf_islocked(bp));
 		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
 			xfs_buf_stale(bp);
-			XFS_BUF_DONE(bp);
+			bp->b_flags |= XBF_DONE;
 		}
 
 		ASSERT(bp->b_transp == tp);
@@ -518,7 +518,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	 * inside the b_bdstrat callback so that this won't get written to
 	 * disk.
 	 */
-	XFS_BUF_DONE(bp);
+	bp->b_flags |= XBF_DONE;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	bp->b_iodone = xfs_buf_iodone_callbacks;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
