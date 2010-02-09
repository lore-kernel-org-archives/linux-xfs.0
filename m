Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o193twYm182630 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 21:55:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C8E41BBE11
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 19:57:10 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	5Z5DTc6nIOq6v5rl for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2010 19:57:10 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: log changed inodes instead of writing them
	synchronously
Date: Tue,  9 Feb 2010 14:56:41 +1100
Message-Id: <1265687802-23043-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1265687802-23043-1-git-send-email-david@fromorbit.com>
References: <1265687802-23043-1-git-send-email-david@fromorbit.com>
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
Cc: Christoph Hellwig <hch@infradead.org>

From: Christoph Hellwig <hch@infradead.org>

When an inode has already be flushed delayed write,
xfs_inode_clean() returns true and hence xfs_fs_write_inode() can
return on a synchronous inode write without having written the
inode. Currently these sycnhronous writes only come sync(1),
unmount, a sycnhronous NFS export and cachefiles so should be
relatively rare and out of common performance paths.

Realistically, a synchronous inode write is not necessary here; we
can avoid writing the inode by logging any non-transactional changes
that are pending.  This needs to be done with synchronous
transactions, but it avoids seeking between the log and inode
clusters as we do now. We don't force the log if the inode is
pinned, though, so this differs from the fsync case.  For normal
sys_sync and unmount behaviour this is fine because we do a
synchronous log force in xfs_sync_data which is called from the
->sync_fs code.

It does however break the NFS synchronous export guarantees for now,
but work is under way to fix this at a higher level or for the
higher level to provide an additional flag in the writeback control
to tell us that a log force is needed.

Portions of this patch are based on work from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |  111 +++++++++++++++++++++++++++++++-----------
 1 files changed, 82 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 3b5b46b..25ea240 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1021,12 +1021,45 @@ xfs_fs_dirty_inode(
 	XFS_I(inode)->i_update_core = 1;
 }
 
-/*
- * Attempt to flush the inode, this will actually fail
- * if the inode is pinned, but we dirty the inode again
- * at the point when it is unpinned after a log write,
- * since this is when the inode itself becomes flushable.
- */
+STATIC int
+xfs_log_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		/* we need to return with the lock hold shared */
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * Note - it's possible that we might have pushed ourselves out of the
+	 * way during trans_reserve which would flush the inode.  But there's
+	 * no guarantee that the inode buffer has actually gone out yet (it's
+	 * delwri).  Plus the buffer could be pinned anyway if it's part of
+	 * an inode in another recent transaction.  So we play it safe and
+	 * fire off the transaction anyway.
+	 */
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ihold(tp, ip);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp, 0);
+	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
 STATIC int
 xfs_fs_write_inode(
 	struct inode		*inode,
@@ -1034,7 +1067,7 @@ xfs_fs_write_inode(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
+	int			error = EAGAIN;
 
 	xfs_itrace_entry(ip);
 
@@ -1045,35 +1078,55 @@ xfs_fs_write_inode(
 		error = xfs_wait_on_pages(ip, 0, -1);
 		if (error)
 			goto out;
-	}
-
-	/*
-	 * Bypass inodes which have already been cleaned by
-	 * the inode flush clustering code inside xfs_iflush
-	 */
-	if (xfs_inode_clean(ip))
-		goto out;
 
-	/*
-	 * We make this non-blocking if the inode is contended, return
-	 * EAGAIN to indicate to the caller that they did not succeed.
-	 * This prevents the flush path from blocking on inodes inside
-	 * another operation right now, they get caught later by xfs_sync.
-	 */
-	if (sync) {
+		/*
+		 * Make sure the inode has hit stable storage.  By using the
+		 * log and the fsync transactions we reduce the IOs we have
+		 * to do here from two (log and inode) to just the log.
+		 *
+		 * Note: We still need to do a delwri write of the inode after
+		 * this to flush it to the backing buffer so that bulkstat
+		 * works properly if this is the first time the inode has been
+		 * written.  Because we hold the ilock atomically over the
+		 * transaction commit and the inode flush we are guaranteed
+		 * that the inode is not pinned when it returns. If the flush
+		 * lock is already held, then the inode has already been
+		 * flushed once and we don't need to flush it again.  Hence
+		 * the code will only flush the inode if it isn't already
+		 * being flushed.
+		 */
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		xfs_iflock(ip);
-
-		error = xfs_iflush(ip, SYNC_WAIT);
+		if (ip->i_update_core) {
+			error = xfs_log_inode(ip);
+			if (error)
+				goto out_unlock;
+		}
 	} else {
-		error = EAGAIN;
+		/*
+		 * We make this non-blocking if the inode is contended, return
+		 * EAGAIN to indicate to the caller that they did not succeed.
+		 * This prevents the flush path from blocking on inodes inside
+		 * another operation right now, they get caught later by xfs_sync.
+		 */
 		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
 			goto out;
-		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
-			goto out_unlock;
+	}
+
+	if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
+		goto out_unlock;
 
-		error = xfs_iflush(ip, 0);
+	/*
+	 * Now we have the flush lock and the inode is not pinned, we can check
+	 * if the inode is really clean as we know that there are no pending
+	 * transaction completions, it is not waiting on the delayed write
+	 * queue and there is no IO in progress.
+	 */
+	if (xfs_inode_clean(ip)) {
+		xfs_ifunlock(ip);
+		error = 0;
+		goto out_unlock;
 	}
+	error = xfs_iflush(ip, 0);
 
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
