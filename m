Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 06:06:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4ID6SYq030430
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:06:28 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDB731847E9
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:07:16 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Zf2V9QRDPdMpy4QA for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:07:16 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4ID77F3028769
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 15:07:07 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4ID774u028767
	for xfs@oss.sgi.com; Sun, 18 May 2008 15:07:07 +0200
Date: Sun, 18 May 2008 15:07:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't update i_size for directories and special files
Message-ID: <20080518130707.GB28501@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The core kernel uses vfs_getattr to look at the inode size and similar
attributes, so there is no need to keep i_size uptodate for directories
or special files.  This means we can remove xfs_validate_fields because
the I/O path already keeps i_size uptodate for regular files.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-05-16 17:01:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-05-16 17:07:40.000000000 +0200
@@ -188,23 +188,6 @@ xfs_ichgtime_fast(
 		mark_inode_dirty_sync(inode);
 }
 
-
-/*
- * Pull the link count and size up from the xfs inode to the linux inode
- */
-STATIC void
-xfs_validate_fields(
-	struct inode		*inode)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	loff_t size;
-
-	/* we're under i_sem so i_size can't change under us */
-	size = XFS_ISIZE(ip);
-	if (i_size_read(inode) != size)
-		i_size_write(inode, size);
-}
-
 /*
  * Hook in SELinux.  This is not quite correct yet, what we really need
  * here (as we do for default ACLs) is a mechanism by which creation of
@@ -338,10 +321,7 @@ xfs_vn_mknod(
 	}
 
 
-	if (S_ISDIR(mode))
-		xfs_validate_fields(inode);
 	d_instantiate(dentry, inode);
-	xfs_validate_fields(dir);
 	return -error;
 
  out_cleanup_inode:
@@ -417,7 +397,6 @@ xfs_vn_link(
 	}
 
 	xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
-	xfs_validate_fields(inode);
 	d_instantiate(dentry, inode);
 	return 0;
 }
@@ -427,19 +406,11 @@ xfs_vn_unlink(
 	struct inode	*dir,
 	struct dentry	*dentry)
 {
-	struct inode	*inode;
+	struct inode	*inode = dentry->d_inode;
 	struct xfs_name	name;
-	int		error;
 
-	inode = dentry->d_inode;
 	xfs_dentry_to_name(&name, dentry);
-
-	error = xfs_remove(XFS_I(dir), &name, XFS_I(inode));
-	if (likely(!error)) {
-		xfs_validate_fields(dir);	/* size needs update */
-		xfs_validate_fields(inode);
-	}
-	return -error;
+	return -xfs_remove(XFS_I(dir), &name, XFS_I(inode));
 }
 
 STATIC int
@@ -469,8 +440,6 @@ xfs_vn_symlink(
 		goto out_cleanup_inode;
 
 	d_instantiate(dentry, inode);
-	xfs_validate_fields(dir);
-	xfs_validate_fields(inode);
 	return 0;
 
  out_cleanup_inode:
@@ -489,22 +458,13 @@ xfs_vn_rename(
 	struct inode	*new_inode = ndentry->d_inode;
 	struct xfs_name	oname;
 	struct xfs_name	nname;
-	int		error;
 
 	xfs_dentry_to_name(&oname, odentry);
 	xfs_dentry_to_name(&nname, ndentry);
 
-	error = xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
+	return -xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			   XFS_I(ndir), &nname, new_inode ?
 			   			XFS_I(new_inode) : NULL);
-	if (likely(!error)) {
-		if (new_inode)
-			xfs_validate_fields(new_inode);
-		xfs_validate_fields(odir);
-		if (ndir != odir)
-			xfs_validate_fields(ndir);
-	}
-	return -error;
 }
 
 /*
