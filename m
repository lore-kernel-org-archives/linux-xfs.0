Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 08:42:24 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l89FgK4p016041
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 08:42:21 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l89FgKA5020109
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 17:42:21 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l89FgK93020107
	for xfs@oss.sgi.com; Sun, 9 Sep 2007 17:42:20 +0200
Date: Sun, 9 Sep 2007 17:42:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove dead SYNC_BDFLUSH case in xfs_sync_inodes
Message-ID: <20070909154220.GC19986@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

A large part of xfs_sync_inodes is conditional on the SYNC_BDFLUSH which
is never passed to it.  This patch removes it and adds an assert that
triggers in case some new code tries to pass SYNC_BDFLUSH to it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-09-08 17:43:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-09-08 19:06:31.000000000 +0200
@@ -981,8 +981,6 @@ xfs_sync_inodes(
 	int             *bypassed)
 {
 	xfs_inode_t	*ip = NULL;
-	xfs_inode_t	*ip_next;
-	xfs_buf_t	*bp;
 	bhv_vnode_t	*vp = NULL;
 	int		error;
 	int		last_error;
@@ -992,7 +990,6 @@ xfs_sync_inodes(
 	boolean_t	mount_locked;
 	boolean_t	vnode_refed;
 	int		preempt;
-	xfs_dinode_t	*dip;
 	xfs_iptr_t	*ipointer;
 #ifdef DEBUG
 	boolean_t	ipointer_in = B_FALSE;
@@ -1045,6 +1042,8 @@ xfs_sync_inodes(
 
 #define XFS_PREEMPT_MASK	0x7f
 
+	ASSERT(!(flags & SYNC_BDFLUSH));
+
 	if (bypassed)
 		*bypassed = 0;
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
@@ -1057,7 +1056,7 @@ xfs_sync_inodes(
 	ipointer = (xfs_iptr_t *)kmem_zalloc(sizeof(xfs_iptr_t), KM_SLEEP);
 
 	fflag = XFS_B_ASYNC;		/* default is don't wait */
-	if (flags & (SYNC_BDFLUSH | SYNC_DELWRI))
+	if (flags & SYNC_DELWRI)
 		fflag = XFS_B_DELWRI;
 	if (flags & SYNC_WAIT)
 		fflag = 0;		/* synchronous overrides all */
@@ -1147,24 +1146,6 @@ xfs_sync_inodes(
 		}
 
 		/*
-		 * If this is just vfs_sync() or pflushd() calling
-		 * then we can skip inodes for which it looks like
-		 * there is nothing to do.  Since we don't have the
-		 * inode locked this is racy, but these are periodic
-		 * calls so it doesn't matter.  For the others we want
-		 * to know for sure, so we at least try to lock them.
-		 */
-		if (flags & SYNC_BDFLUSH) {
-			if (((ip->i_itemp == NULL) ||
-			     !(ip->i_itemp->ili_format.ilf_fields &
-			       XFS_ILOG_ALL)) &&
-			    (ip->i_update_core == 0)) {
-				ip = ip->i_mnext;
-				continue;
-			}
-		}
-
-		/*
 		 * Try to lock without sleeping.  We're out of order with
 		 * the inode list lock here, so if we fail we need to drop
 		 * the mount lock and try again.  If we're called from
@@ -1181,7 +1162,7 @@ xfs_sync_inodes(
 		 * it.
 		 */
 		if (xfs_ilock_nowait(ip, lock_flags) == 0) {
-			if ((flags & SYNC_BDFLUSH) || (vp == NULL)) {
+			if (vp == NULL) {
 				ip = ip->i_mnext;
 				continue;
 			}
@@ -1242,160 +1223,27 @@ xfs_sync_inodes(
 			xfs_ilock(ip, XFS_ILOCK_SHARED);
 		}
 
-		if (flags & SYNC_BDFLUSH) {
-			if ((flags & SYNC_ATTR) &&
-			    ((ip->i_update_core) ||
-			     ((ip->i_itemp != NULL) &&
-			      (ip->i_itemp->ili_format.ilf_fields != 0)))) {
-
-				/* Insert marker and drop lock if not already
-				 * done.
-				 */
-				if (mount_locked) {
-					IPOINTER_INSERT(ip, mp);
-				}
-
-				/*
-				 * We don't want the periodic flushing of the
-				 * inodes by vfs_sync() to interfere with
-				 * I/O to the file, especially read I/O
-				 * where it is only the access time stamp
-				 * that is being flushed out.  To prevent
-				 * long periods where we have both inode
-				 * locks held shared here while reading the
-				 * inode's buffer in from disk, we drop the
-				 * inode lock while reading in the inode
-				 * buffer.  We have to release the buffer
-				 * and reacquire the inode lock so that they
-				 * are acquired in the proper order (inode
-				 * locks first).  The buffer will go at the
-				 * end of the lru chain, though, so we can
-				 * expect it to still be there when we go
-				 * for it again in xfs_iflush().
-				 */
-				if ((xfs_ipincount(ip) == 0) &&
-				    xfs_iflock_nowait(ip)) {
-
-					xfs_ifunlock(ip);
-					xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-					error = xfs_itobp(mp, NULL, ip,
-							  &dip, &bp, 0, 0);
-					if (!error) {
-						xfs_buf_relse(bp);
-					} else {
-						/* Bailing out, remove the
-						 * marker and free it.
-						 */
-						XFS_MOUNT_ILOCK(mp);
-						IPOINTER_REMOVE(ip, mp);
-						XFS_MOUNT_IUNLOCK(mp);
-
-						ASSERT(!(lock_flags &
-							XFS_IOLOCK_SHARED));
-
-						kmem_free(ipointer,
-							sizeof(xfs_iptr_t));
-						return (0);
-					}
-
-					/*
-					 * Since we dropped the inode lock,
-					 * the inode may have been reclaimed.
-					 * Therefore, we reacquire the mount
-					 * lock and check to see if we were the
-					 * inode reclaimed. If this happened
-					 * then the ipointer marker will no
-					 * longer point back at us. In this
-					 * case, move ip along to the inode
-					 * after the marker, remove the marker
-					 * and continue.
-					 */
-					XFS_MOUNT_ILOCK(mp);
-					mount_locked = B_TRUE;
-
-					if (ip != ipointer->ip_mprev) {
-						IPOINTER_REMOVE(ip, mp);
-
-						ASSERT(!vnode_refed);
-						ASSERT(!(lock_flags &
-							XFS_IOLOCK_SHARED));
-						continue;
-					}
-
-					ASSERT(ip->i_mount == mp);
-
-					if (xfs_ilock_nowait(ip,
-						    XFS_ILOCK_SHARED) == 0) {
-						ASSERT(ip->i_mount == mp);
-						/*
-						 * We failed to reacquire
-						 * the inode lock without
-						 * sleeping, so just skip
-						 * the inode for now.  We
-						 * clear the ILOCK bit from
-						 * the lock_flags so that we
-						 * won't try to drop a lock
-						 * we don't hold below.
-						 */
-						lock_flags &= ~XFS_ILOCK_SHARED;
-						IPOINTER_REMOVE(ip_next, mp);
-					} else if ((xfs_ipincount(ip) == 0) &&
-						   xfs_iflock_nowait(ip)) {
-						ASSERT(ip->i_mount == mp);
-						/*
-						 * Since this is vfs_sync()
-						 * calling we only flush the
-						 * inode out if we can lock
-						 * it without sleeping and
-						 * it is not pinned.  Drop
-						 * the mount lock here so
-						 * that we don't hold it for
-						 * too long. We already have
-						 * a marker in the list here.
-						 */
-						XFS_MOUNT_IUNLOCK(mp);
-						mount_locked = B_FALSE;
-						error = xfs_iflush(ip,
-							   XFS_IFLUSH_DELWRI);
-					} else {
-						ASSERT(ip->i_mount == mp);
-						IPOINTER_REMOVE(ip_next, mp);
-					}
-				}
-
-			}
+		if ((flags & SYNC_ATTR) &&
+		    (ip->i_update_core ||
+		     (ip->i_itemp && ip->i_itemp->ili_format.ilf_fields))) {
+			if (mount_locked)
+				IPOINTER_INSERT(ip, mp);
 
-		} else {
-			if ((flags & SYNC_ATTR) &&
-			    ((ip->i_update_core) ||
-			     ((ip->i_itemp != NULL) &&
-			      (ip->i_itemp->ili_format.ilf_fields != 0)))) {
-				if (mount_locked) {
-					IPOINTER_INSERT(ip, mp);
-				}
+			if (flags & SYNC_WAIT) {
+				xfs_iflock(ip);
+				error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
 
-				if (flags & SYNC_WAIT) {
-					xfs_iflock(ip);
-					error = xfs_iflush(ip,
-							   XFS_IFLUSH_SYNC);
-				} else {
-					/*
-					 * If we can't acquire the flush
-					 * lock, then the inode is already
-					 * being flushed so don't bother
-					 * waiting.  If we can lock it then
-					 * do a delwri flush so we can
-					 * combine multiple inode flushes
-					 * in each disk write.
-					 */
-					if (xfs_iflock_nowait(ip)) {
-						error = xfs_iflush(ip,
-							   XFS_IFLUSH_DELWRI);
-					}
-					else if (bypassed)
-						(*bypassed)++;
-				}
+			/*
+			 * If we can't acquire the flush lock, then the inode
+			 * is already being flushed so don't bother waiting.
+			 *
+			 * If we can lock it then do a delwri flush so we can
+			 * combine multiple inode flushes in each disk write.
+			 */
+			} else if (xfs_iflock_nowait(ip)) {
+				error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);
+			} else if (bypassed) {
+				(*bypassed)++;
 			}
 		}
 
