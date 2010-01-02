Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0236cfc053708 for <xfs@oss.sgi.com>; Fri, 1 Jan 2010 21:06:38 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E1CE1502BEC
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2010 19:07:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	0EHShOQzjAgEHNRB for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2010 19:07:25 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10940215-1927428
	for <xfs@oss.sgi.com>; Sat, 02 Jan 2010 13:37:24 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NQuKc-0007yl-TH
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 14:07:10 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NQuHE-00057U-3d
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 14:03:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] XFS: Use delayed write for inodes rather than async
Date: Sat,  2 Jan 2010 14:03:34 +1100
Message-Id: <1262401416-19546-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1262401416-19546-1-git-send-email-david@fromorbit.com>
References: <1262401416-19546-1-git-send-email-david@fromorbit.com>
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

We currently do background inode flush asynchronously, resulting in
inodes being written in whatever order the background writeback
issues them.

Make the inode flush delayed write instead of asynchronous which
will push the inode into the backing buffer but not issue any IO.
The buffer will then sit in cache to be flushed by either an AIL
push or the xfsbufd timing out the buffer. This will allow
accumulation of dirty inode buffers in memory and allow optimisation
of inode cluster writeback at the xfsbufd level where we have much
greater queue depths than the block layer elevators.

This effectively means that any inode that is written back by
background writeback will be seen as flush locked during AIL
pushing, and will result in the buffers being pushed from there.
A future path will address this non-optimal form of writeback, too.

A side effect of this delayed write mechanism is that background
inode reclaim will no longer directly flush inodes, nor can it wait
on the flush lock. The result is that inode reclaim must leave the
inode in the reclaimable state until it is clean. Hence attempts to
reclaim a dirty inode in the background will simply skip the inode
until it is clean and this allows other mechanisms (i.e. xfsbufd) to
do more optimal writeback of the dirty buffers.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   52 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.c           |   31 ++++---------------------
 fs/xfs/xfs_inode.h           |    8 ++----
 fs/xfs/xfs_inode_item.c      |   10 +++++--
 fs/xfs/xfs_mount.c           |    3 +-
 6 files changed, 54 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 84ce77a..752fa10 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1074,7 +1074,7 @@ xfs_fs_write_inode(
 		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
 			goto out_unlock;
 
-		error = xfs_iflush(ip, XFS_IFLUSH_ASYNC_NOBLOCK);
+		error = xfs_iflush(ip, XFS_IFLUSH_DELWRI_NOBLOCK);
 	}
 
  out_unlock:
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index c980d68..f974d1a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -460,8 +460,8 @@ xfs_quiesce_fs(
 {
 	int	count = 0, pincount;
 
+	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/*
 	 * This loop must run at least twice.  The first instance of the loop
@@ -585,7 +585,7 @@ xfs_sync_worker(
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
@@ -687,7 +687,7 @@ xfs_reclaim_inode(
 		spin_unlock(&ip->i_flags_lock);
 		write_unlock(&pag->pag_ici_lock);
 		xfs_perag_put(pag);
-		return -EAGAIN;
+		return EAGAIN;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
@@ -695,32 +695,52 @@ xfs_reclaim_inode(
 	xfs_perag_put(pag);
 
 	/*
-	 * If the inode is still dirty, then flush it out.  If the inode
-	 * is not in the AIL, then it will be OK to flush it delwri as
-	 * long as xfs_iflush() does not keep any references to the inode.
-	 * We leave that decision up to xfs_iflush() since it has the
-	 * knowledge of whether it's OK to simply do a delwri flush of
-	 * the inode or whether we need to wait until the inode is
-	 * pulled from the AIL.
-	 * We get the flush lock regardless, though, just to make sure
-	 * we don't free it while it is being flushed.
+	 * The inode is flushed delayed write. That means the flush lock
+	 * may be held here and we will block for some time on it. Further,
+	 * if we hold the inode lock, we prevent the AIL from locking and
+	 * therefore being able to push the buffer. This means that we'll end
+	 * up waiting here for the xfsbufd to age the buffer and write it out,
+	 * which could be a long time. If we fail to get the flush lock, just
+	 * clear the reclaim in progress state (we haven't cleared the reclaim
+	 * needed state) so that the reclaim is delayed until the flush lock
+	 * can be gained without blocking.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_iflock(ip);
+	if (!xfs_iflock_nowait(ip))
+		goto unlock_and_requeue;
 
 	/*
 	 * In the case of a forced shutdown we rely on xfs_iflush() to
 	 * wait for the inode to be unpinned before returning an error.
 	 */
-	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
-		/* synchronize with xfs_iflush_done */
-		xfs_iflock(ip);
+	if (!is_bad_inode(VFS_I(ip)) && !xfs_inode_clean(ip)) {
+		/*
+		 * If we are flushing a dirty inode DELWRI, then don't
+		 * immediately wait on the flush lock - requeue the inode for
+		 * reclaim. Every time we re-enter and the flush lock is still
+		 * held we will requeue at the initial flush lock check above.
+		 * Otherwise, for synchronous writeback we synchronize with
+		 * xfs_iflush_done by locking and unlocking the flush lock.
+		 */
+		if (xfs_iflush(ip, sync_mode) == 0) {
+			if (sync_mode == XFS_IFLUSH_DELWRI)
+				goto unlock_and_requeue;
+			xfs_iflock(ip);
+			xfs_ifunlock(ip);
+		}
+	} else {
+		/* need to unlock the clean inodes */
 		xfs_ifunlock(ip);
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_ireclaim(ip);
 	return 0;
+
+unlock_and_requeue:
+	xfs_iflags_clear(ip, XFS_IRECLAIM);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return EAGAIN;
 }
 
 void
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5c9953..d175dca 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2832,7 +2832,7 @@ xfs_iflush(
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
 	int			error;
-	int			noblock = (flags == XFS_IFLUSH_ASYNC_NOBLOCK);
+	int			noblock = (flags == XFS_IFLUSH_DELWRI_NOBLOCK);
 	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
 
 	XFS_STATS_INC(xs_iflush_count);
@@ -2905,12 +2905,8 @@ xfs_iflush(
 		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
 			flags = 0;
 			break;
-		case XFS_IFLUSH_ASYNC_NOBLOCK:
-		case XFS_IFLUSH_ASYNC:
-		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
-			flags = INT_ASYNC;
-			break;
 		case XFS_IFLUSH_DELWRI:
+		case XFS_IFLUSH_DELWRI_NOBLOCK:
 			flags = INT_DELWRI;
 			break;
 		default:
@@ -2920,15 +2916,11 @@ xfs_iflush(
 		}
 	} else {
 		switch (flags) {
+		case XFS_IFLUSH_DELWRI_NOBLOCK:
 		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
-		case XFS_IFLUSH_DELWRI_ELSE_ASYNC:
 		case XFS_IFLUSH_DELWRI:
 			flags = INT_DELWRI;
 			break;
-		case XFS_IFLUSH_ASYNC_NOBLOCK:
-		case XFS_IFLUSH_ASYNC:
-			flags = INT_ASYNC;
-			break;
 		case XFS_IFLUSH_SYNC:
 			flags = 0;
 			break;
@@ -2971,13 +2963,10 @@ xfs_iflush(
 	if (error)
 		goto cluster_corrupt_out;
 
-	if (flags & INT_DELWRI) {
+	if (flags & INT_DELWRI)
 		xfs_bdwrite(mp, bp);
-	} else if (flags & INT_ASYNC) {
-		error = xfs_bawrite(mp, bp);
-	} else {
+	else
 		error = xfs_bwrite(mp, bp);
-	}
 	return error;
 
 corrupt_out:
@@ -3012,16 +3001,6 @@ xfs_iflush_int(
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
 
-
-	/*
-	 * If the inode isn't dirty, then just release the inode
-	 * flush lock and do nothing.
-	 */
-	if (xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		return 0;
-	}
-
 	/* set *dip = inode's place in the buffer */
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ec1f28c..559feeb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -423,11 +423,9 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
  * Flags for xfs_iflush()
  */
 #define	XFS_IFLUSH_DELWRI_ELSE_SYNC	1
-#define	XFS_IFLUSH_DELWRI_ELSE_ASYNC	2
-#define	XFS_IFLUSH_SYNC			3
-#define	XFS_IFLUSH_ASYNC		4
-#define	XFS_IFLUSH_DELWRI		5
-#define	XFS_IFLUSH_ASYNC_NOBLOCK	6
+#define	XFS_IFLUSH_SYNC			2
+#define	XFS_IFLUSH_DELWRI		3
+#define	XFS_IFLUSH_DELWRI_NOBLOCK	4
 
 /*
  * Flags for xfs_itruncate_start().
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f38855d..beb7d9f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -867,10 +867,14 @@ xfs_inode_item_push(
 	       iip->ili_format.ilf_fields != 0);
 
 	/*
-	 * Write out the inode.  The completion routine ('iflush_done') will
-	 * pull it from the AIL, mark it clean, unlock the flush lock.
+	 * Push the inode to it's backing buffer. This will not remove
+	 * the inode from the AIL - a further push will be required to trigger
+	 * a buffer push. However, this allows all the dirty inodes to be pushed to
+	 * the buffer before it is pushed to disk. THe buffer IO completion
+	 * will pull th einode from the AIL, mark it clean and unlock the flush
+	 * lock.
 	 */
-	(void) xfs_iflush(ip, XFS_IFLUSH_ASYNC);
+	(void) xfs_iflush(ip, XFS_IFLUSH_DELWRI);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	return;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 223d9c3..f3ce47a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1444,7 +1444,8 @@ xfs_unmountfs(
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
-	xfs_reclaim_inodes(mp, XFS_IFLUSH_ASYNC);
+	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
+	XFS_bflush(mp->m_ddev_targp);
 
 	xfs_qm_unmount(mp);
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
