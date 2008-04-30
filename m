Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 04:22:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UBLc8M006759
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:21:50 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5787C10E3F0
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:22:20 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id QcVwFbGlGjGrSzOl for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:22:20 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3UBMDF3017469
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 13:22:13 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3UBMDmi017467
	for xfs@oss.sgi.com; Wed, 30 Apr 2008 13:22:13 +0200
Date: Wed, 30 Apr 2008 13:22:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] kill attr_capable callbacks
Message-ID: <20080430112213.GA16966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

No need for addition permission checks in the xattr handler,
fs/xattr.c:xattr_permission() already does them, and in fact slightly
more strict then what was in the attr_capable handlers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-04-29 21:32:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-04-29 21:33:30.000000000 +0200
@@ -747,15 +747,11 @@ xfs_vn_setxattr(
 	char		*attr = (char *)name;
 	attrnames_t	*namesp;
 	int		xflags = 0;
-	int		error;
 
 	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
 	if (!namesp)
 		return -EOPNOTSUPP;
 	attr += namesp->attr_namelen;
-	error = namesp->attr_capable(vp, NULL);
-	if (error)
-		return error;
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
@@ -777,15 +773,11 @@ xfs_vn_getxattr(
 	char		*attr = (char *)name;
 	attrnames_t	*namesp;
 	int		xflags = 0;
-	ssize_t		error;
 
 	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
 	if (!namesp)
 		return -EOPNOTSUPP;
 	attr += namesp->attr_namelen;
-	error = namesp->attr_capable(vp, NULL);
-	if (error)
-		return error;
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (!size) {
@@ -825,15 +817,12 @@ xfs_vn_removexattr(
 	char		*attr = (char *)name;
 	attrnames_t	*namesp;
 	int		xflags = 0;
-	int		error;
 
 	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
 	if (!namesp)
 		return -EOPNOTSUPP;
 	attr += namesp->attr_namelen;
-	error = namesp->attr_capable(vp, NULL);
-	if (error)
-		return error;
+
 	xflags |= namesp->attr_flag;
 	return namesp->attr_remove(vp, attr, xflags);
 }
Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2008-04-29 21:32:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2008-04-29 21:32:51.000000000 +0200
@@ -2622,43 +2622,6 @@ attr_lookup_namespace(
 	return NULL;
 }
 
-/*
- * Some checks to prevent people abusing EAs to get over quota:
- * - Don't allow modifying user EAs on devices/symlinks;
- * - Don't allow modifying user EAs if sticky bit set;
- */
-STATIC int
-attr_user_capable(
-	bhv_vnode_t	*vp,
-	cred_t		*cred)
-{
-	struct inode	*inode = vn_to_inode(vp);
-
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return -EPERM;
-	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
-	    (current_fsuid(cred) != inode->i_uid) && !capable(CAP_FOWNER))
-		return -EPERM;
-	return 0;
-}
-
-STATIC int
-attr_trusted_capable(
-	bhv_vnode_t	*vp,
-	cred_t		*cred)
-{
-	struct inode	*inode = vn_to_inode(vp);
-
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	return 0;
-}
-
 STATIC int
 attr_system_set(
 	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
@@ -2709,7 +2672,6 @@ struct attrnames attr_system = {
 	.attr_get	= attr_system_get,
 	.attr_set	= attr_system_set,
 	.attr_remove	= attr_system_remove,
-	.attr_capable	= (attrcapable_t)fs_noerr,
 };
 
 struct attrnames attr_trusted = {
@@ -2719,7 +2681,6 @@ struct attrnames attr_trusted = {
 	.attr_get	= attr_generic_get,
 	.attr_set	= attr_generic_set,
 	.attr_remove	= attr_generic_remove,
-	.attr_capable	= attr_trusted_capable,
 };
 
 struct attrnames attr_secure = {
@@ -2729,7 +2690,6 @@ struct attrnames attr_secure = {
 	.attr_get	= attr_generic_get,
 	.attr_set	= attr_generic_set,
 	.attr_remove	= attr_generic_remove,
-	.attr_capable	= (attrcapable_t)fs_noerr,
 };
 
 struct attrnames attr_user = {
@@ -2738,7 +2698,6 @@ struct attrnames attr_user = {
 	.attr_get	= attr_generic_get,
 	.attr_set	= attr_generic_set,
 	.attr_remove	= attr_generic_remove,
-	.attr_capable	= attr_user_capable,
 };
 
 struct attrnames *attr_namespaces[] =
Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2008-04-29 21:33:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2008-04-29 21:33:52.000000000 +0200
@@ -42,7 +42,6 @@ typedef int (*attrset_t)(bhv_vnode_t *, 
 typedef int (*attrget_t)(bhv_vnode_t *, char *, void *, size_t, int);
 typedef int (*attrremove_t)(bhv_vnode_t *, char *, int);
 typedef int (*attrexists_t)(bhv_vnode_t *);
-typedef int (*attrcapable_t)(bhv_vnode_t *, struct cred *);
 
 typedef struct attrnames {
 	char *		attr_name;
@@ -52,7 +51,6 @@ typedef struct attrnames {
 	attrset_t	attr_set;
 	attrremove_t	attr_remove;
 	attrexists_t	attr_exists;
-	attrcapable_t	attr_capable;
 } attrnames_t;
 
 #define ATTR_NAMECOUNT	4
