Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:01:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41M0tt0001313
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:01:01 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78A921B2BBD9
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 15:01:21 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id eH2DIOjQCqFH8a6t for <xfs@oss.sgi.com>; Thu, 01 May 2008 15:01:21 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41M1FF3002435
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 00:01:15 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41M1FHK002433
	for xfs@oss.sgi.com; Fri, 2 May 2008 00:01:15 +0200
Date: Fri, 2 May 2008 00:01:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/10] allow xfs_args_allocate to fail
Message-ID: <20080501220115.GF2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Switch xfs_args_allocate to kzalloc and handle failures.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:06:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-01 20:15:00.000000000 +0200
@@ -75,7 +75,10 @@ xfs_args_allocate(
 {
 	struct xfs_mount_args	*args;
 
-	args = kmem_zalloc(sizeof(struct xfs_mount_args), KM_SLEEP);
+	args = kzalloc(sizeof(struct xfs_mount_args), GFP_KERNEL);
+	if (!args)
+		return NULL;
+
 	args->logbufs = args->logbufsize = -1;
 	strncpy(args->fsname, sb->s_id, MAXNAMELEN);
 
@@ -1396,9 +1399,13 @@ xfs_fs_remount(
 	char			*options)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
-	struct xfs_mount_args	*args = xfs_args_allocate(sb, 0);
+	struct xfs_mount_args	*args;
 	int			error;
 
+	args = xfs_args_allocate(sb, 0);
+	if (!args)
+		return -ENOMEM;
+
 	error = xfs_parseargs(mp, options, args, 1);
 	if (error)
 		goto out_free_args;
@@ -1420,7 +1427,7 @@ xfs_fs_remount(
 	}
 
  out_free_args:
-	kmem_free(args, sizeof(*args));
+	kfree(args);
 	return -error;
 }
 
@@ -1725,9 +1732,13 @@ xfs_fs_fill_super(
 {
 	struct inode		*root;
 	struct xfs_mount	*mp = NULL;
-	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
+	struct xfs_mount_args	*args;
 	int			flags = 0, error;
 
+	args = xfs_args_allocate(sb, silent);
+	if (!args)
+		return -ENOMEM;
+
 	mp = xfs_mount_init();
 
 	INIT_LIST_HEAD(&mp->m_sync_list);
@@ -1827,7 +1838,7 @@ xfs_fs_fill_super(
 
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 
-	kmem_free(args, sizeof(*args));
+	kfree(args);
 	return 0;
 
  error2:
@@ -1875,7 +1886,7 @@ xfs_fs_fill_super(
 	kmem_free(mp, sizeof(xfs_mount_t));
 
  fail_vfsop:
-	kmem_free(args, sizeof(*args));
+	kfree(args);
 	return -error;
 }
 
