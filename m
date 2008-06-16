Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 23:24:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G6OPgC017137
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:24:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49D24CC1D62
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:25:22 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id BXy3T3Z0g7qyuTOr for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 23:25:22 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5G6PDNW005930
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 08:25:13 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5G6PD6G005927
	for xfs@oss.sgi.com; Mon, 16 Jun 2008 08:25:13 +0200
Date: Mon, 16 Jun 2008 08:25:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] don't update i_size for directories and special files
Message-ID: <20080616062513.GA5842@lst.de>
References: <20080518130707.GB28501@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080518130707.GB28501@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Sun, May 18, 2008 at 03:07:07PM +0200, Christoph Hellwig wrote:
> The core kernel uses vfs_getattr to look at the inode size and similar
> attributes, so there is no need to keep i_size uptodate for directories
> or special files.  This means we can remove xfs_validate_fields because
> the I/O path already keeps i_size uptodate for regular files.
>

Updated for the d_invalidate added on unlink/rmdir.

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-06-16 08:15:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-06-16 08:20:56.000000000 +0200
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
@@ -457,7 +437,6 @@ xfs_vn_link(
 	}
 
 	xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
-	xfs_validate_fields(inode);
 	d_instantiate(dentry, inode);
 	return 0;
 }
@@ -467,26 +446,23 @@ xfs_vn_unlink(
 	struct inode	*dir,
 	struct dentry	*dentry)
 {
-	struct inode	*inode;
 	struct xfs_name	name;
 	int		error;
 
-	inode = dentry->d_inode;
 	xfs_dentry_to_name(&name, dentry);
 
-	error = xfs_remove(XFS_I(dir), &name, XFS_I(inode));
-	if (likely(!error)) {
-		xfs_validate_fields(dir);	/* size needs update */
-		xfs_validate_fields(inode);
-		/*
-		 * With unlink, the VFS makes the dentry "negative": no inode,
-		 * but still hashed. This is incompatible with case-insensitive
-		 * mode, so invalidate (unhash) the dentry in CI-mode.
-		 */
-		if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
-			d_invalidate(dentry);
-	}
-	return -error;
+	error = -xfs_remove(XFS_I(dir), &name, XFS_I(dentry->d_inode));
+	if (error)
+		return error;
+
+	/*
+	 * With unlink, the VFS makes the dentry "negative": no inode,
+	 * but still hashed. This is incompatible with case-insensitive
+	 * mode, so invalidate (unhash) the dentry in CI-mode.
+	 */
+	if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
+		d_invalidate(dentry);
+	return 0;
 }
 
 STATIC int
@@ -516,8 +492,6 @@ xfs_vn_symlink(
 		goto out_cleanup_inode;
 
 	d_instantiate(dentry, inode);
-	xfs_validate_fields(dir);
-	xfs_validate_fields(inode);
 	return 0;
 
  out_cleanup_inode:
@@ -536,22 +510,13 @@ xfs_vn_rename(
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
