Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:01:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M11QQ001340
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:01:07 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BDCC1176F0
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:45 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id WcSgMN0bsUuXGywF for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:45 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M1cF3002509
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:01:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M1c8q002507
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:01:38 +0200
Date: Fri, 2 May 2008 00:01:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] add missing call to xfs_filestream_unmount on xfs_mountfs failure
Message-ID: <20080501220138.GJ2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:35:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:36:38.000000000 +0200
@@ -1811,7 +1811,7 @@ xfs_fs_fill_super(
 
 	error = xfs_mountfs(mp, flags);
 	if (error)
-		goto out_free_sb;
+		goto out_filestream_unmount;
 
 	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, args->mtpt, args->fsname);
 
@@ -1851,6 +1851,8 @@ xfs_fs_fill_super(
 	kfree(args);
 	return 0;
 
+ out_filestream_unmount:
+	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
  out_destroy_counters:
