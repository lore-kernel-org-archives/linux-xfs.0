Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 13:10:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3QK9sEM025822
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:10:00 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D76D015EE0B3
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:10:36 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id soaoJNtc17svLbCE for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 13:10:36 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3QKAUF3014269
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 22:10:30 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3QKAUIf014267
	for xfs@oss.sgi.com; Sat, 26 Apr 2008 22:10:30 +0200
Date: Sat, 26 Apr 2008 22:10:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] merge xfs_mntupdate into xfs_fs_remount
Message-ID: <20080426201029.GB14172@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_mntupdate already is completely Linux specific due to the VFS flags
passed in, so it might aswell be merged into xfs_fs_remount.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-04-25 20:42:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-04-25 20:44:55.000000000 +0200
@@ -52,6 +52,7 @@
 #include "xfs_version.h"
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
+#include "xfs_filestream.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1220,8 +1221,26 @@ xfs_fs_remount(
 	int			error;
 
 	error = xfs_parseargs(mp, options, args, 1);
-	if (!error)
-		error = xfs_mntupdate(mp, flags, args);
+	if (error)
+		goto out_free_args;
+
+	if (!(*flags & MS_RDONLY)) {			/* rw/ro -> rw */
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			mp->m_flags &= ~XFS_MOUNT_RDONLY;
+		if (args->flags & XFSMNT_BARRIER) {
+			mp->m_flags |= XFS_MOUNT_BARRIER;
+			xfs_mountfs_check_barriers(mp);
+		} else {
+			mp->m_flags &= ~XFS_MOUNT_BARRIER;
+		}
+	} else if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {	/* rw -> ro */
+		xfs_filestream_flush(mp);
+		xfs_sync(mp, SYNC_DATA_QUIESCE);
+		xfs_attr_quiesce(mp);
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	}
+
+ out_free_args:
 	kmem_free(args, sizeof(*args));
 	return -error;
 }
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-04-25 20:42:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-04-25 20:43:36.000000000 +0200
@@ -693,30 +693,6 @@ xfs_attr_quiesce(
 	xfs_unmountfs_writesb(mp);
 }
 
-int
-xfs_mntupdate(
-	struct xfs_mount		*mp,
-	int				*flags,
-	struct xfs_mount_args		*args)
-{
-	if (!(*flags & MS_RDONLY)) {			/* rw/ro -> rw */
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
-			mp->m_flags &= ~XFS_MOUNT_RDONLY;
-		if (args->flags & XFSMNT_BARRIER) {
-			mp->m_flags |= XFS_MOUNT_BARRIER;
-			xfs_mountfs_check_barriers(mp);
-		} else {
-			mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		}
-	} else if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {	/* rw -> ro */
-		xfs_filestream_flush(mp);
-		xfs_sync(mp, SYNC_DATA_QUIESCE);
-		xfs_attr_quiesce(mp);
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	}
-	return 0;
-}
-
 /*
  * xfs_unmount_flush implements a set of flush operation on special
  * inodes, which are needed as a separate set of operations so that
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2008-04-25 20:42:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2008-04-25 20:42:48.000000000 +0200
@@ -11,8 +11,6 @@ struct xfs_mount_args;
 int xfs_mount(struct xfs_mount *mp, struct xfs_mount_args *args,
 		struct cred *credp);
 int xfs_unmount(struct xfs_mount *mp, int flags, struct cred *credp);
-int xfs_mntupdate(struct xfs_mount *mp, int *flags,
-		struct xfs_mount_args *args);
 int xfs_sync(struct xfs_mount *mp, int flags);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
