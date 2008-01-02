Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jan 2008 13:39:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m02LdQW9020247
	for <xfs@oss.sgi.com>; Wed, 2 Jan 2008 13:39:29 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82E904DA139
	for <xfs@oss.sgi.com>; Wed,  2 Jan 2008 13:39:34 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id MZJ42rTGcc7wrkSF for <xfs@oss.sgi.com>; Wed, 02 Jan 2008 13:39:34 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m02LVeF3005341
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 2 Jan 2008 22:31:40 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m02LVe9i005339
	for xfs@oss.sgi.com; Wed, 2 Jan 2008 22:31:40 +0100
Date: Wed, 2 Jan 2008 22:31:40 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup xfs_vn_mknod
Message-ID: <20080102213140.GA5204@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 - use proper goto based unwinding instead of the current mess of
   multiple conditionals
 - rename ip to inode because that's the normal convention for Linux
   inodes while ip is the convention for xfs_inodes
 - remove unlikely checks for the default_acl - branches marked unlikely
   might lead to extreme branch bredictor slowdons if taken and for some
   workloads a default acl is quite common
 - properly indent the switch statements
 - remove xfs_has_fs_struct as nfsd has a fs_struct in any semi-recent
   kernel


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-21 07:25:06.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-21 07:33:25.000000000 +0100
@@ -241,18 +241,6 @@ xfs_init_security(
 	return error;
 }
 
-/*
- * Determine whether a process has a valid fs_struct (kernel daemons
- * like knfsd don't have an fs_struct).
- *
- * XXX(hch):  nfsd is broken, better fix it instead.
- */
-STATIC_INLINE int
-xfs_has_fs_struct(struct task_struct *task)
-{
-	return (task->fs != init_task.fs);
-}
-
 STATIC void
 xfs_cleanup_inode(
 	struct inode	*dir,
@@ -284,7 +272,7 @@ xfs_vn_mknod(
 	int		mode,
 	dev_t		rdev)
 {
-	struct inode	*ip;
+	struct inode	*inode;
 	bhv_vnode_t	*vp = NULL, *dvp = vn_from_inode(dir);
 	xfs_acl_t	*default_acl = NULL;
 	attrexists_t	test_default_acl = _ACL_DEFAULT_EXISTS;
@@ -297,7 +285,7 @@ xfs_vn_mknod(
 	if (unlikely(!sysv_valid_dev(rdev) || MAJOR(rdev) & ~0x1ff))
 		return -EINVAL;
 
-	if (unlikely(test_default_acl && test_default_acl(dvp))) {
+	if (test_default_acl && test_default_acl(dvp)) {
 		if (!_ACL_ALLOC(default_acl)) {
 			return -ENOMEM;
 		}
@@ -307,11 +295,14 @@ xfs_vn_mknod(
 		}
 	}
 
-	if (IS_POSIXACL(dir) && !default_acl && xfs_has_fs_struct(current))
+	if (IS_POSIXACL(dir) && !default_acl)
 		mode &= ~current->fs->umask;
 
 	switch (mode & S_IFMT) {
-	case S_IFCHR: case S_IFBLK: case S_IFIFO: case S_IFSOCK:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
 		rdev = sysv_encode_dev(rdev);
 	case S_IFREG:
 		error = xfs_create(XFS_I(dir), dentry, mode, rdev, &vp, NULL);
@@ -324,32 +315,34 @@ xfs_vn_mknod(
 		break;
 	}
 
-	if (unlikely(!error)) {
-		error = xfs_init_security(vp, dir);
-		if (error)
-			xfs_cleanup_inode(dir, vp, dentry, mode);
-	}
+	if (unlikely(error))
+		goto out_free_acl;
 
-	if (unlikely(default_acl)) {
-		if (!error) {
-			error = _ACL_INHERIT(vp, mode, default_acl);
-			if (!error)
-				xfs_iflags_set(XFS_I(vp), XFS_IMODIFIED);
-			else
-				xfs_cleanup_inode(dir, vp, dentry, mode);
-		}
+	error = xfs_init_security(vp, dir);
+	if (unlikely(error))
+		goto out_cleanup_inode;
+
+	if (default_acl) {
+		error = _ACL_INHERIT(vp, mode, default_acl);
+		if (unlikely(error))
+			goto out_cleanup_inode;
+		xfs_iflags_set(XFS_I(vp), XFS_IMODIFIED);
 		_ACL_FREE(default_acl);
 	}
 
-	if (likely(!error)) {
-		ASSERT(vp);
-		ip = vn_to_inode(vp);
+	inode = vn_to_inode(vp);
 
-		if (S_ISDIR(mode))
-			xfs_validate_fields(ip);
-		d_instantiate(dentry, ip);
-		xfs_validate_fields(dir);
-	}
+	if (S_ISDIR(mode))
+		xfs_validate_fields(inode);
+	d_instantiate(dentry, inode);
+	xfs_validate_fields(dir);
+	return -error;
+
+ out_cleanup_inode:
+	xfs_cleanup_inode(dir, vp, dentry, mode);
+ out_free_acl:
+	if (default_acl)
+		_ACL_FREE(default_acl);
 	return -error;
 }
 
