Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06I7AGW101221 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 12:07:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 694481C3439F
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 10:08:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eGs322IInc1oDb7W for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 10:08:02 -0800 (PST)
Date: Wed, 6 Jan 2010 13:08:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Kill async inode writeback V2
Message-ID: <20100106180800.GA9613@infradead.org>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262649861-28530-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Btw, after this series XFS_IFLUSH_DELWRI_ELSE_SYNC is also unused,
might be worth to throw something like the patch below in to clean
up xfs_iflush:

I'm also not sure we do enough of the noblock calls either with or
without your series.  There seem to be a lot more non-blocking sync
calls than iflush calls.

Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2010-01-04 16:51:27.885262385 +0100
+++ linux-2.6/fs/xfs/xfs_inode.c	2010-01-04 17:03:28.096003992 +0100
@@ -2827,8 +2827,6 @@ xfs_iflush(
 	xfs_dinode_t		*dip;
 	xfs_mount_t		*mp;
 	int			error;
-	int			noblock = (flags == XFS_IFLUSH_DELWRI_NOBLOCK);
-	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
 
 	XFS_STATS_INC(xs_iflush_count);
 
@@ -2860,7 +2858,7 @@ xfs_iflush(
 	 * in the same cluster are dirty, they will probably write the inode
 	 * out for us if they occur after the log force completes.
 	 */
-	if (noblock && xfs_ipincount(ip)) {
+	if ((flags & XFS_IFLUSH_NOBLOCK) && xfs_ipincount(ip)) {
 		xfs_iunpin_nowait(ip);
 		xfs_ifunlock(ip);
 		return EAGAIN;
@@ -2881,52 +2879,11 @@ xfs_iflush(
 	}
 
 	/*
-	 * Decide how buffer will be flushed out.  This is done before
-	 * the call to xfs_iflush_int because this field is zeroed by it.
-	 */
-	if (iip != NULL && iip->ili_format.ilf_fields != 0) {
-		/*
-		 * Flush out the inode buffer according to the directions
-		 * of the caller.  In the cases where the caller has given
-		 * us a choice choose the non-delwri case.  This is because
-		 * the inode is in the AIL and we need to get it out soon.
-		 */
-		switch (flags) {
-		case XFS_IFLUSH_SYNC:
-		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
-			flags = 0;
-			break;
-		case XFS_IFLUSH_DELWRI:
-		case XFS_IFLUSH_DELWRI_NOBLOCK:
-			flags = INT_DELWRI;
-			break;
-		default:
-			ASSERT(0);
-			flags = 0;
-			break;
-		}
-	} else {
-		switch (flags) {
-		case XFS_IFLUSH_DELWRI_NOBLOCK:
-		case XFS_IFLUSH_DELWRI_ELSE_SYNC:
-		case XFS_IFLUSH_DELWRI:
-			flags = INT_DELWRI;
-			break;
-		case XFS_IFLUSH_SYNC:
-			flags = 0;
-			break;
-		default:
-			ASSERT(0);
-			flags = 0;
-			break;
-		}
-	}
-
-	/*
 	 * Get the buffer containing the on-disk inode.
 	 */
 	error = xfs_itobp(mp, NULL, ip, &dip, &bp,
-				noblock ? XFS_BUF_TRYLOCK : XFS_BUF_LOCK);
+				(flags & XFS_IFLUSH_NOBLOCK) ?
+				 XFS_BUF_TRYLOCK : XFS_BUF_LOCK);
 	if (error || !bp) {
 		xfs_ifunlock(ip);
 		return error;
@@ -2954,10 +2911,10 @@ xfs_iflush(
 	if (error)
 		goto cluster_corrupt_out;
 
-	if (flags & INT_DELWRI)
-		xfs_bdwrite(mp, bp);
-	else
+	if (flags & XFS_IFLUSH_SYNC)
 		error = xfs_bwrite(mp, bp);
+	else
+		xfs_bdwrite(mp, bp);
 	return error;
 
 corrupt_out:
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2010-01-04 16:59:53.765261226 +0100
+++ linux-2.6/fs/xfs/xfs_inode.h	2010-01-04 17:03:14.421006071 +0100
@@ -422,10 +422,8 @@ static inline void xfs_ifunlock(xfs_inod
 /*
  * Flags for xfs_iflush()
  */
-#define	XFS_IFLUSH_DELWRI_ELSE_SYNC	1
-#define	XFS_IFLUSH_SYNC			2
-#define	XFS_IFLUSH_DELWRI		3
-#define	XFS_IFLUSH_DELWRI_NOBLOCK	4
+#define	XFS_IFLUSH_SYNC		1
+#define	XFS_IFLUSH_NOBLOCK	2
 
 /*
  * Flags for xfs_itruncate_start().
Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2010-01-04 17:01:27.788003888 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2010-01-04 17:01:33.362004189 +0100
@@ -1075,7 +1075,7 @@ xfs_fs_write_inode(
 		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
 			goto out_unlock;
 
-		error = xfs_iflush(ip, XFS_IFLUSH_DELWRI_NOBLOCK);
+		error = xfs_iflush(ip, XFS_IFLUSH_NOBLOCK);
 	}
 
  out_unlock:
Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2010-01-04 17:01:27.801255295 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2010-01-04 17:02:00.155005972 +0100
@@ -260,8 +260,7 @@ xfs_sync_inode_attr(
 		goto out_unlock;
 	}
 
-	error = xfs_iflush(ip, (flags & SYNC_WAIT) ?
-			   XFS_IFLUSH_SYNC : XFS_IFLUSH_DELWRI);
+	error = xfs_iflush(ip, (flags & SYNC_WAIT) ? XFS_IFLUSH_SYNC : 0);
 
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -460,7 +459,7 @@ xfs_quiesce_fs(
 {
 	int	count = 0, pincount;
 
-	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
+	xfs_reclaim_inodes(mp, 0);
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
 
 	/*
@@ -585,7 +584,7 @@ xfs_sync_worker(
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
+		xfs_reclaim_inodes(mp, 0);
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
@@ -718,7 +717,7 @@ xfs_reclaim_inode(
 		 * xfs_iflush_done by locking and unlocking the flush lock.
 		 */
 		if (xfs_iflush(ip, sync_mode) == 0) {
-			if (sync_mode == XFS_IFLUSH_DELWRI)
+			if (sync_mode == 0)
 				goto unlock_and_requeue;
 			xfs_iflock(ip);
 			xfs_ifunlock(ip);
Index: linux-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.c	2010-01-04 17:03:37.557003904 +0100
+++ linux-2.6/fs/xfs/xfs_inode_item.c	2010-01-04 17:03:42.356006322 +0100
@@ -806,7 +806,7 @@ xfs_inode_item_push(
 	 * will pull th einode from the AIL, mark it clean and unlock the flush
 	 * lock.
 	 */
-	(void) xfs_iflush(ip, XFS_IFLUSH_DELWRI);
+	(void) xfs_iflush(ip, 0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	return;
Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c	2010-01-04 17:01:27.815003765 +0100
+++ linux-2.6/fs/xfs/xfs_mount.c	2010-01-04 17:02:16.218005804 +0100
@@ -1373,7 +1373,7 @@ xfs_unmountfs(
 	 * need to force the log first.
 	 */
 	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
-	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
+	xfs_reclaim_inodes(mp, 0);
 	XFS_bflush(mp->m_ddev_targp);
 
 	xfs_qm_unmount(mp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
