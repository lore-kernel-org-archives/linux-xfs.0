Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MMDmfQ001221 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 16:13:48 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 482FF12C8027
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:16:31 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	KxGsNCvrXAecgB6F for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 14:16:31 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: introduce inode cluster buffer trylocks for
	xfs_iflush
Date: Wed, 23 Feb 2011 09:16:05 +1100
Message-Id: <1298412969-14389-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1298412969-14389-1-git-send-email-david@fromorbit.com>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
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
Cc: chris.mason@oracle.com

From: Dave Chinner <dchinner@redhat.com>

There is an ABBA deadlock between synchronous inode flushing in
xfs_reclaim_inode and xfs_icluster_free. xfs_icluster_free locks the
buffer, then takes inode ilocks, whilst synchronous reclaim takes
the ilock followed by the buffer lock in xfs_iflush().

To avoid this deadlock, separate the inode cluster buffer locking
semantics from the synchronous inode flush semantics, allowing
callers to attempt to lock the buffer but still issue synchronous IO
if it can get the buffer. This requires xfs_iflush() calls that
currently use non-blocking semantics to pass SYNC_TRYLOCK rather
than 0 as the flags parameter.

This allows xfs_reclaim_inode to avoid the deadlock on the buffer
lock and detect the failure so that it can drop the inode ilock and
restart the reclaim attempt on the inode. This allows
xfs_ifree_cluster to obtain the inode lock, mark the inode stale and
release it and hence defuse the deadlock situation. It also has the
pleasant side effect of avoiding IO in xfs_reclaim_inode when it
tries to next reclaim the inode as it is now marked stale.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   30 +++++++++++++++++++++++++++---
 fs/xfs/linux-2.6/xfs_sync.h  |    1 +
 fs/xfs/xfs_inode.c           |    2 +-
 fs/xfs/xfs_inode_item.c      |    6 +++---
 5 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 4b2b1c7..e010830 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1077,7 +1077,7 @@ xfs_fs_write_inode(
 			error = 0;
 			goto out_unlock;
 		}
-		error = xfs_iflush(ip, 0);
+		error = xfs_iflush(ip, SYNC_TRYLOCK);
 	}
 
  out_unlock:
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 6c10f1d..594cd82 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -761,8 +761,10 @@ xfs_reclaim_inode(
 	struct xfs_perag	*pag,
 	int			sync_mode)
 {
-	int	error = 0;
+	int	error;
 
+restart:
+	error = 0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iflock_nowait(ip)) {
 		if (!(sync_mode & SYNC_WAIT))
@@ -788,9 +790,31 @@ xfs_reclaim_inode(
 	if (xfs_inode_clean(ip))
 		goto reclaim;
 
-	/* Now we have an inode that needs flushing */
-	error = xfs_iflush(ip, sync_mode);
+	/*
+	 * Now we have an inode that needs flushing.
+	 *
+	 * We do a nonblocking flush here even if we are doing a SYNC_WAIT
+	 * reclaim as we can deadlock with inode cluster removal.
+	 * xfs_ifree_cluster() can lock the inode buffer before it locks the
+	 * ip->i_lock, and we are doing the exact opposite here. As a result,
+	 * doing a blocking xfs_itobp() to get the cluster buffer will result
+	 * in an ABBA deadlock with xfs_ifree_cluster().
+	 *
+	 * As xfs_ifree_cluser() must gather all inodes that are active in the
+	 * cache to mark them stale, if we hit this case we don't actually want
+	 * to do IO here - we want the inode marked stale so we can simply
+	 * reclaim it. Hence if we get an EAGAIN error on a SYNC_WAIT flush,
+	 * just unlock the inode, back off and try again. Hopefully the next
+	 * pass through will see the stale flag set on the inode.
+	 */
+	error = xfs_iflush(ip, SYNC_TRYLOCK | sync_mode);
 	if (sync_mode & SYNC_WAIT) {
+		if (error == EAGAIN) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			/* backoff longer than in xfs_ifree_cluster */
+			delay(2);
+			goto restart;
+		}
 		xfs_iflock(ip);
 		goto reclaim;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 32ba662..0ae48ff 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -34,6 +34,7 @@ typedef struct xfs_sync_work {
 
 int xfs_syncd_init(struct xfs_mount *mp);
 void xfs_syncd_stop(struct xfs_mount *mp);
+void xfs_syncd_queue_sync(struct xfs_mount *mp, int flags);
 
 int xfs_quiesce_data(struct xfs_mount *mp);
 void xfs_quiesce_attr(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6b3424b..a44c015 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2834,7 +2834,7 @@ xfs_iflush(
 	 * Get the buffer containing the on-disk inode.
 	 */
 	error = xfs_itobp(mp, NULL, ip, &dip, &bp,
-				(flags & SYNC_WAIT) ? XBF_LOCK : XBF_TRYLOCK);
+				(flags & SYNC_TRYLOCK) ? XBF_TRYLOCK : XBF_LOCK);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
 		return error;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fd4f398..46cc401 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -760,11 +760,11 @@ xfs_inode_item_push(
 	 * Push the inode to it's backing buffer. This will not remove the
 	 * inode from the AIL - a further push will be required to trigger a
 	 * buffer push. However, this allows all the dirty inodes to be pushed
-	 * to the buffer before it is pushed to disk. THe buffer IO completion
-	 * will pull th einode from the AIL, mark it clean and unlock the flush
+	 * to the buffer before it is pushed to disk. The buffer IO completion
+	 * will pull the inode from the AIL, mark it clean and unlock the flush
 	 * lock.
 	 */
-	(void) xfs_iflush(ip, 0);
+	(void) xfs_iflush(ip, SYNC_TRYLOCK);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 }
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
