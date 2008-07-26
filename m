Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Jul 2008 23:33:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q6WU2A002419
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:32:31 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10EFC192E56D
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:33:41 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id cCDnfVGN3RgH2RAe for <xfs@oss.sgi.com>; Fri, 25 Jul 2008 23:33:41 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q6XVNg022911
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 08:33:31 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q6XVgj022909
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 08:33:31 +0200
Date: Sat, 26 Jul 2008 08:33:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] update timestamp in xfs_ialloc manually
Message-ID: <20080726063331.GA22603@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

In xfs_ialloc we just want to set all timestamps to the current time.
We don't need to mark the inode dirty like xfs_ichgtime does, and we
don't need nor want the opimizations in xfs_ichgtime that I will
introduce in the next patch.

So just opencode the timestamp update in xfs_ialloc, and remove the new
unused XFS_ICHGTIME_ACC case in xfs_ichgtime.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-07-23 23:29:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-07-23 23:29:59.000000000 +0200
@@ -89,12 +89,6 @@ xfs_mark_inode_dirty_sync(
  * Change the requested timestamp in the given inode.
  * We don't lock across timestamp updates, and we don't log them but
  * we do record the fact that there is dirty information in core.
- *
- * NOTE -- callers MUST combine XFS_ICHGTIME_MOD or XFS_ICHGTIME_CHG
- *		with XFS_ICHGTIME_ACC to be sure that access time
- *		update will take.  Calling first with XFS_ICHGTIME_ACC
- *		and then XFS_ICHGTIME_MOD may fail to modify the access
- *		timestamp if the filesystem is mounted noacctm.
  */
 void
 xfs_ichgtime(
@@ -110,11 +104,6 @@ xfs_ichgtime(
 		ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
 	}
-	if (flags & XFS_ICHGTIME_ACC) {
-		inode->i_atime = tv;
-		ip->i_d.di_atime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_atime.t_nsec = (__int32_t)tv.tv_nsec;
-	}
 	if (flags & XFS_ICHGTIME_CHG) {
 		inode->i_ctime = tv;
 		ip->i_d.di_ctime.t_sec = (__int32_t)tv.tv_sec;
@@ -150,12 +139,6 @@ xfs_ichgtime_fast(
 	timespec_t	*tvp;
 
 	/*
-	 * Atime updates for read() & friends are handled lazily now, and
-	 * explicit updates must go through xfs_ichgtime()
-	 */
-	ASSERT((flags & XFS_ICHGTIME_ACC) == 0);
-
-	/*
 	 * We're not supposed to change timestamps in readonly-mounted
 	 * filesystems.  Throw it away if anyone asks us.
 	 */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-07-23 23:27:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-07-23 23:29:07.000000000 +0200
@@ -1049,6 +1049,7 @@ xfs_ialloc(
 	xfs_inode_t	*ip;
 	uint		flags;
 	int		error;
+	timespec_t	tv;
 
 	/*
 	 * Call the space management code to pick
@@ -1129,7 +1130,13 @@ xfs_ialloc(
 	ip->i_size = 0;
 	ip->i_d.di_nextents = 0;
 	ASSERT(ip->i_d.di_nblocks == 0);
-	xfs_ichgtime(ip, XFS_ICHGTIME_CHG|XFS_ICHGTIME_ACC|XFS_ICHGTIME_MOD);
+
+	nanotime(&tv);
+	ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
+	ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
+	ip->i_d.di_atime = ip->i_d.di_mtime;
+	ip->i_d.di_ctime = ip->i_d.di_mtime;
+
 	/*
 	 * di_gen will have been taken care of in xfs_iread.
 	 */
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-07-23 23:30:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-07-23 23:30:16.000000000 +0200
@@ -87,8 +87,7 @@ typedef struct xfs_ifork {
  * Flags for xfs_ichgtime().
  */
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_ACC	0x2	/* data fork access timestamp */
-#define	XFS_ICHGTIME_CHG	0x4	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 
 /*
  * Per-fork incore inode flags.
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-07-23 23:29:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-07-23 23:29:37.000000000 +0200
@@ -513,7 +513,6 @@ xfs_setattr(
 			ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
 			ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
 			ip->i_update_core = 1;
-			timeflags &= ~XFS_ICHGTIME_ACC;
 		}
 		if (mask & ATTR_MTIME) {
 			inode->i_mtime = iattr->ia_mtime;
