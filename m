Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 03:13:50 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OADkfB026425
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 03:13:48 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l3OADgLD029799
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 12:13:42 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l3OADgmL029797
	for xfs@oss.sgi.com; Tue, 24 Apr 2007 12:13:42 +0200
Date: Tue, 24 Apr 2007 12:13:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [RFC PATCH 2/3] use xfs_reclaim_all in xfs_syncsub
Message-ID: <20070424101342.GC29731@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_sync_inodes currently opencodes xfs_finish_reclaim_all, except
using an m_inodes walk and checking for a NULL vnode instead of
walking m_del_inodes.  Change the code in xfs_syncsub to always
call xfs_finish_reclaim_all, and remove the code dealing with
deleted inodes without vnode from xfs_sync_inodes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vfsops.c	2007-04-24 10:58:55.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_vfsops.c	2007-04-24 11:00:14.000000000 +0200
@@ -1018,36 +1018,15 @@ xfs_sync_inodes(
 			continue;
 		}
 
-		vp = XFS_ITOV_NULL(ip);
-
 		/*
-		 * If the vnode is gone then this is being torn down,
-		 * call reclaim if it is flushed, else let regular flush
-		 * code deal with it later in the loop.
+		 * Inodes on the delayed reclaim list are beeing dealt
+		 * with in xfs_reclaim_all.  One may have sneaked in
+		 * here after we dropped the mount ilock, but we'll leave
+		 * them to the next xfs_reclaim_all call.
 		 */
-
+		vp = XFS_ITOV_NULL(ip);
 		if (vp == NULL) {
-			/* Skip ones already in reclaim */
-			if (ip->i_flags & XFS_IRECLAIM) {
-				ip = ip->i_mnext;
-				continue;
-			}
-			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0) {
-				ip = ip->i_mnext;
-			} else if ((xfs_ipincount(ip) == 0) &&
-				    xfs_iflock_nowait(ip)) {
-				IPOINTER_INSERT(ip, mp);
-
-				xfs_finish_reclaim(ip, 1,
-						XFS_IFLUSH_DELWRI_ELSE_ASYNC);
-
-				XFS_MOUNT_ILOCK(mp);
-				mount_locked = B_TRUE;
-				IPOINTER_REMOVE(ip, mp);
-			} else {
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				ip = ip->i_mnext;
-			}
+			ip = ip->i_mnext;
 			continue;
 		}
 
@@ -1434,10 +1413,8 @@ xfs_syncsub(
 	xfs_log_force(mp, (xfs_lsn_t)0, log_flags);
 
 	if (flags & (SYNC_ATTR|SYNC_DELWRI)) {
-		if (flags & SYNC_BDFLUSH)
-			xfs_finish_reclaim_all(mp, 1,
-					XFS_IFLUSH_DELWRI_ELSE_ASYNC);
-		else
+		xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		if (!(flags & SYNC_BDFLUSH))
 			error = xfs_sync_inodes(mp, flags, bypassed);
 	}
 
