Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:56:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9uD20024639
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:56:13 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A308EA5AD1
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:23 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id hc2F91NIEC44TcgN for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:23 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q9vENg031925
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 11:57:14 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q9vE23031923
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 11:57:14 +0200
Date: Sat, 26 Jul 2008 11:57:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] don't call xfs_freesb from xfs_unmountfs
Message-ID: <20080726095714.GD31858@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_readsb is called before xfs_mount so xfs_freesb should be called
after xfs_unmountfs, too.  This means it now happens after a few things
during the of xfs_unmount which all have nothing to do with the
superblock.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-24 22:57:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-24 23:00:27.000000000 +0200
@@ -1198,6 +1198,7 @@ xfs_fs_put_super(
 	}
 
 	xfs_unmountfs(mp);
+	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
@@ -1682,7 +1683,7 @@ xfs_fs_fill_super(
 	WARN_ON(error);
 
 	xfs_unmountfs(mp);
-	goto out_free_fsname;
+	goto out_free_sb;
 }
 
 STATIC int
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-07-24 22:58:14.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-07-24 23:00:27.000000000 +0200
@@ -1296,8 +1296,6 @@ xfs_unmountfs(
 	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
 	xfs_log_unmount(mp);			/* Done! No more fs ops. */
 
-	xfs_freesb(mp);
-
 	/*
 	 * All inodes from this mount point should be freed.
 	 */
