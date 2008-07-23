Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 12:49:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NJmw0l010822
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:03 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39A6E31BCFD
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:52 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 76eadttA7FvBF97p for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:52 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NJngNg006611
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 21:49:43 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NJngvF006607
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 21:49:42 +0200
Date: Wed, 23 Jul 2008 21:49:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] remove spurious VN_HOLD/VN_RELE calls from xfs_acl.c
Message-ID: <20080723194942.GD6188@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

All the ACL routines are called from inode operations which are
guaranteed to have a referenced inode by the VFS, so there's no need
for the ACL code to grab another temporary one.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-07-23 19:40:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2008-07-23 19:40:37.000000000 +0200
@@ -217,7 +217,6 @@ xfs_acl_vget(
 	posix_acl_xattr_header	*ext_acl = acl;
 	int			flags = 0;
 
-	VN_HOLD(vp);
 	if(size) {
 		if (!(_ACL_ALLOC(xfs_acl))) {
 			error = ENOMEM;
@@ -243,7 +242,6 @@ xfs_acl_vget(
 		error = -posix_acl_xfs_to_xattr(xfs_acl, ext_acl, size);
 	}
 out:
-	VN_RELE(vp);
 	if(xfs_acl)
 		_ACL_FREE(xfs_acl);
 	return -error;
@@ -256,7 +254,6 @@ xfs_acl_vremove(
 {
 	int		error;
 
-	VN_HOLD(vp);
 	error = xfs_acl_allow_set(vp, kind);
 	if (!error) {
 		error = xfs_attr_remove(XFS_I(vp),
@@ -266,7 +263,6 @@ xfs_acl_vremove(
 		if (error == ENOATTR)
 			error = 0;	/* 'scool */
 	}
-	VN_RELE(vp);
 	return -error;
 }
 
@@ -298,7 +294,6 @@ xfs_acl_vset(
 		return 0;
 	}
 
-	VN_HOLD(vp);
 	error = xfs_acl_allow_set(vp, kind);
 
 	/* Incoming ACL exists, set file mode based on its value */
@@ -321,7 +316,6 @@ xfs_acl_vset(
 	}
 
 out:
-	VN_RELE(vp);
 	_ACL_FREE(xfs_acl);
 	return -error;
 }
