Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 23:42:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m496gUvQ031221
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 23:42:34 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB19210FC776
	for <xfs@oss.sgi.com>; Thu,  8 May 2008 23:43:15 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 1qZ3Y1jGaTnMXoQO for <xfs@oss.sgi.com>; Thu, 08 May 2008 23:43:15 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m496h8F3025904
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 9 May 2008 08:43:09 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m496h86G025902
	for xfs@oss.sgi.com; Fri, 9 May 2008 08:43:08 +0200
Date: Fri, 9 May 2008 08:43:08 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/10] allow xfs_args_allocate to fail
Message-ID: <20080509064308.GC25251@lst.de>
References: <20080501220115.GF2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501220115.GF2315@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, May 02, 2008 at 12:01:15AM +0200, Christoph Hellwig wrote:
> Switch xfs_args_allocate to kzalloc and handle failures.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Respin ontop of the kmem_free signature change:


Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-09 08:40:14.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-09 08:40:54.000000000 +0200
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
-	kmem_free(args);
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
 
-	kmem_free(args);
+	kfree(args);
 	return 0;
 
  error2:
@@ -1875,7 +1886,7 @@ xfs_fs_fill_super(
 	kmem_free(mp);
 
  fail_vfsop:
-	kmem_free(args);
+	kfree(args);
 	return -error;
 }
 
