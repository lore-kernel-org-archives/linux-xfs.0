Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7XFNo203851 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:33:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79E3CB75E0
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id itI5HQo2N2pMxq8o for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:33 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLww-00034t-N2
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:02 +0000
Message-Id: <20090126073202.588218000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/17] xfs: merge xfs_inode_flush into xfs_fs_write_inode
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_inode_flush
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

Spliting the task for a VFS-induced inode flush into two functions doesn't
make any sense, so merge the two functions dealing with it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-01-24 18:40:10.116428891 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-01-24 18:50:29.764553115 +0100
@@ -990,26 +990,57 @@ xfs_fs_write_inode(
 	int			sync)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
-	int			flags = 0;
 
 	xfs_itrace_entry(ip);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
 	if (sync) {
 		error = xfs_wait_on_pages(ip, 0, -1);
 		if (error)
-			goto out_error;
-		flags |= FLUSH_SYNC;
+			goto out;
+	}
+
+	/*
+	 * Bypass inodes which have already been cleaned by
+	 * the inode flush clustering code inside xfs_iflush
+	 */
+	if (xfs_inode_clean(ip))
+		goto out;
+
+	/*
+	 * We make this non-blocking if the inode is contended, return
+	 * EAGAIN to indicate to the caller that they did not succeed.
+	 * This prevents the flush path from blocking on inodes inside
+	 * another operation right now, they get caught later by xfs_sync.
+	 */
+	if (sync) {
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		xfs_iflock(ip);
+
+		error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
+	} else {
+		error = EAGAIN;
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
+			goto out;
+		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
+			goto out_unlock;
+
+		error = xfs_iflush(ip, XFS_IFLUSH_ASYNC_NOBLOCK);
 	}
-	error = xfs_inode_flush(ip, flags);
 
-out_error:
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+ out:
 	/*
 	 * if we failed to write out the inode then mark
 	 * it dirty again so we'll try again later.
 	 */
 	if (error)
 		xfs_mark_inode_dirty_sync(ip);
-
 	return -error;
 }
 
Index: xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2009-01-21 21:03:27.831294794 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_vnode.h	2009-01-24 18:50:29.764553115 +0100
@@ -41,11 +41,6 @@ struct attrlist_cursor_kern;
 #define IO_INVIS	0x00020		/* don't update inode timestamps */
 
 /*
- * Flags for xfs_inode_flush
- */
-#define FLUSH_SYNC		1	/* wait for flush to complete	*/
-
-/*
  * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
  */
 #define FI_NONE			0	/* none */
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-01-24 18:50:11.826428845 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-01-24 18:50:29.767553567 +0100
@@ -2589,51 +2589,6 @@ std_return:
 }
 
 int
-xfs_inode_flush(
-	xfs_inode_t	*ip,
-	int		flags)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error = 0;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	/*
-	 * Bypass inodes which have already been cleaned by
-	 * the inode flush clustering code inside xfs_iflush
-	 */
-	if (xfs_inode_clean(ip))
-		return 0;
-
-	/*
-	 * We make this non-blocking if the inode is contended,
-	 * return EAGAIN to indicate to the caller that they
-	 * did not succeed. This prevents the flush path from
-	 * blocking on inodes inside another operation right
-	 * now, they get caught later by xfs_sync.
-	 */
-	if (flags & FLUSH_SYNC) {
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		xfs_iflock(ip);
-	} else if (xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
-		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip)) {
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			return EAGAIN;
-		}
-	} else {
-		return EAGAIN;
-	}
-
-	error = xfs_iflush(ip, (flags & FLUSH_SYNC) ? XFS_IFLUSH_SYNC
-						    : XFS_IFLUSH_ASYNC_NOBLOCK);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	return error;
-}
-
-
-int
 xfs_set_dmattrs(
 	xfs_inode_t     *ip,
 	u_int		evmask,
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2009-01-24 18:50:11.832429121 +0100
+++ xfs/fs/xfs/xfs_vnodeops.h	2009-01-24 18:50:40.648430311 +0100
@@ -38,7 +38,6 @@ int xfs_readdir(struct xfs_inode	*dp, vo
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, mode_t mode, struct xfs_inode **ipp,
 		cred_t *credp);
-int xfs_inode_flush(struct xfs_inode *ip, int flags);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
 int xfs_reclaim(struct xfs_inode *ip);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
