Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:56:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9uAGs024581
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:56:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC307331A2F
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:19 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 07Bz7LYhSca5bB7y for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:19 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q9vANg031910
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 11:57:10 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q9vAMw031908
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 11:57:10 +0200
Date: Sat, 26 Jul 2008 11:57:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] xfs_unmountfs should return void
Message-ID: <20080726095710.GC31858@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_unmounts can't and shouldn't return errors so declare it as
returning void.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-07-26 09:27:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-07-26 09:27:43.000000000 +0200
@@ -1229,16 +1229,15 @@ xfs_mountfs(
 }
 
 /*
- * xfs_unmountfs
- *
  * This flushes out the inodes,dquots and the superblock, unmounts the
  * log and makes sure that incore structures are freed.
  */
-int
-xfs_unmountfs(xfs_mount_t *mp)
+void
+xfs_unmountfs(
+	struct xfs_mount	*mp)
 {
-	__uint64_t	resblks;
-	int		error = 0;
+	__uint64_t		resblks;
+	int			error;
 
 	IRELE(mp->m_rootip);
 
@@ -1311,7 +1310,6 @@ xfs_unmountfs(xfs_mount_t *mp)
 	xfs_errortag_clearall(mp, 0);
 #endif
 	xfs_mount_free(mp);
-	return 0;
 }
 
 STATIC void
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-07-26 09:27:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-07-26 09:27:43.000000000 +0200
@@ -511,7 +511,7 @@ extern int	xfs_log_sbcount(xfs_mount_t *
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
-extern int	xfs_unmountfs(xfs_mount_t *);
+extern void	xfs_unmountfs(xfs_mount_t *);
 extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_unmount_flush(xfs_mount_t *, int);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
