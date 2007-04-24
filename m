Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 03:13:44 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OADcfB026337
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 03:13:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l3OADaLD029777
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 12:13:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l3OADauW029775
	for xfs@oss.sgi.com; Tue, 24 Apr 2007 12:13:36 +0200
Date: Tue, 24 Apr 2007 12:13:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [RFC PATCH 1/3]: cleanup xfs_finish_reclaim_all
Message-ID: <20070424101336.GB29731@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_finish_reclaim currently has a rather odd style using a while
loop and two local variables to implement a restart the list walking
loop operation.  Convert this to use a plain goto restart style as
used all over the kernel.  Also add a sync_mode argument instead of
always using XFS_IFLUSH_DELWRI_ELSE_ASYNC - a new caller added in
patch three will pass in a different argument.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2007-04-24 10:44:38.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_inode.h	2007-04-24 10:44:42.000000000 +0200
@@ -461,7 +461,7 @@ void		xfs_iunlock_map_shared(xfs_inode_t
 void		xfs_ifunlock(xfs_inode_t *);
 void		xfs_ireclaim(xfs_inode_t *);
 int		xfs_finish_reclaim(xfs_inode_t *, int, int);
-int		xfs_finish_reclaim_all(struct xfs_mount *, int);
+int		xfs_finish_reclaim_all(struct xfs_mount *, int, int);
 
 /*
  * xfs_inode.c prototypes.
Index: linux-2.6/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vfsops.c	2007-04-24 10:44:38.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_vfsops.c	2007-04-24 10:45:50.000000000 +0200
@@ -628,7 +628,7 @@ xfs_quiesce_fs(
 
 	xfs_refcache_purge_mp(mp);
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_finish_reclaim_all(mp, 0);
+	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
 	/* This loop must run at least twice.
 	 * The first instance of the loop will flush
@@ -1435,7 +1435,8 @@ xfs_syncsub(
 
 	if (flags & (SYNC_ATTR|SYNC_DELWRI)) {
 		if (flags & SYNC_BDFLUSH)
-			xfs_finish_reclaim_all(mp, 1);
+			xfs_finish_reclaim_all(mp, 1,
+					XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		else
 			error = xfs_sync_inodes(mp, flags, bypassed);
 	}
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2007-04-24 10:44:38.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2007-04-24 10:47:37.000000000 +0200
@@ -3908,36 +3908,29 @@ xfs_finish_reclaim(
 }
 
 int
-xfs_finish_reclaim_all(xfs_mount_t *mp, int noblock)
+xfs_finish_reclaim_all(
+	xfs_mount_t	*mp,
+	int		noblock,
+	int		sync_mode)
 {
-	int		purged;
 	xfs_inode_t	*ip, *n;
-	int		done = 0;
 
-	while (!done) {
-		purged = 0;
-		XFS_MOUNT_ILOCK(mp);
-		list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
-			if (noblock) {
-				if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
-					continue;
-				if (xfs_ipincount(ip) ||
-				    !xfs_iflock_nowait(ip)) {
-					xfs_iunlock(ip, XFS_ILOCK_EXCL);
-					continue;
-				}
+ restart:
+	XFS_MOUNT_ILOCK(mp);
+	list_for_each_entry_safe(ip, n, &mp->m_del_inodes, i_reclaim) {
+		if (noblock) {
+			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL) == 0)
+				continue;
+			if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip)) {
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
+				continue;
 			}
-			XFS_MOUNT_IUNLOCK(mp);
-			if (xfs_finish_reclaim(ip, noblock,
-					XFS_IFLUSH_DELWRI_ELSE_ASYNC))
-				delay(1);
-			purged = 1;
-			break;
 		}
-
-		done = !purged;
+		XFS_MOUNT_IUNLOCK(mp);
+		if (xfs_finish_reclaim(ip, noblock, sync_mode))
+			delay(1);
+		goto restart;
 	}
-
 	XFS_MOUNT_IUNLOCK(mp);
 	return 0;
 }
