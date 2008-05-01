Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:01:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0uRM001323
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:01:04 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCEA91B2BBD9
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:40 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Yu8WrgKKzto30mn3 for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:40 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M1XF3002489
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:01:33 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M1XoI002486
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:01:33 +0200
Date: Fri, 2 May 2008 00:01:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/10] rename error2 goto label in xfs_fs_fill_super
Message-ID: <20080501220133.GI2315@lst.de>
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:34:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:35:30.000000000 +0200
@@ -1796,22 +1796,22 @@ xfs_fs_fill_super(
 		goto out_destroy_counters;
 	error = xfs_finish_flags(args, mp);
 	if (error)
-		goto error2;
+		goto out_free_sb;
 
 	error = xfs_setup_devices(mp);
 	if (error)
-		goto error2;
+		goto out_free_sb;
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_mountfs_check_barriers(mp);
 
 	error = xfs_filestream_mount(mp);
 	if (error)
-		goto error2;
+		goto out_free_sb;
 
 	error = xfs_mountfs(mp, flags);
 	if (error)
-		goto error2;
+		goto out_free_sb;
 
 	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, args->mtpt, args->fsname);
 
@@ -1851,9 +1851,8 @@ xfs_fs_fill_super(
 	kfree(args);
 	return 0;
 
- error2:
-	if (mp->m_sb_bp)
-		xfs_freesb(mp);
+ out_free_sb:
+	xfs_freesb(mp);
  out_destroy_counters:
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
