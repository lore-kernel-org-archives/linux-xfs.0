Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 04:39:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53BdAnU016084
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 04:39:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 692051DE2F8
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 04:40:03 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id jTq5FFMzks6vWkAf for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 04:40:03 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m53BdtOc002844
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 13:39:55 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m53BdtEt002842
	for xfs@oss.sgi.com; Tue, 3 Jun 2008 13:39:55 +0200
Date: Tue, 3 Jun 2008 13:39:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] factor out inode has attrs check
Message-ID: <20080603113955.GA2703@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Note that xfs_attr_fetch did the check twice while keeping the inode
locked and we can just remove the superflous check.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2008-06-01 14:32:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2008-06-01 14:40:04.000000000 +0200
@@ -111,6 +111,17 @@ xfs_attr_name_to_xname(
 	return 0;
 }
 
+STATIC int
+xfs_inode_hasattr(
+	struct xfs_inode	*ip)
+{
+	if (!XFS_IFORK_Q(ip) ||
+	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     ip->i_d.di_anextents == 0))
+		return 0;
+	return 1;
+}
+
 /*========================================================================
  * Overall external interface routines.
  *========================================================================*/
@@ -122,10 +133,8 @@ xfs_attr_fetch(xfs_inode_t *ip, struct x
 	xfs_da_args_t   args;
 	int             error;
 
-	if ((XFS_IFORK_Q(ip) == 0) ||
-	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     ip->i_d.di_anextents == 0))
-		return(ENOATTR);
+	if (!xfs_inode_hasattr(ip))
+		return ENOATTR;
 
 	/*
 	 * Fill in the arg structure for this request.
@@ -143,11 +152,7 @@ xfs_attr_fetch(xfs_inode_t *ip, struct x
 	/*
 	 * Decide on what work routines to call based on the inode size.
 	 */
-	if (XFS_IFORK_Q(ip) == 0 ||
-	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     ip->i_d.di_anextents == 0)) {
-		error = XFS_ERROR(ENOATTR);
-	} else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
 		error = xfs_attr_shortform_getvalue(&args);
 	} else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_get(&args);
@@ -523,9 +528,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, str
 	/*
 	 * Decide on what work routines to call based on the inode size.
 	 */
-	if (XFS_IFORK_Q(dp) == 0 ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
+	if (!xfs_inode_hasattr(dp)) {
 		error = XFS_ERROR(ENOATTR);
 		goto out;
 	}
@@ -595,11 +598,9 @@ xfs_attr_remove(
 		return error;
 
 	xfs_ilock(dp, XFS_ILOCK_SHARED);
-	if (XFS_IFORK_Q(dp) == 0 ||
-		   (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-		    dp->i_d.di_anextents == 0)) {
+	if (!xfs_inode_hasattr(dp)) {
 		xfs_iunlock(dp, XFS_ILOCK_SHARED);
-		return(XFS_ERROR(ENOATTR));
+		return XFS_ERROR(ENOATTR);
 	}
 	xfs_iunlock(dp, XFS_ILOCK_SHARED);
 
@@ -615,9 +616,7 @@ xfs_attr_list_int(xfs_attr_list_context_
 	/*
 	 * Decide on what work routines to call based on the inode size.
 	 */
-	if (XFS_IFORK_Q(dp) == 0 ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
+	if (!xfs_inode_hasattr(dp)) {
 		error = 0;
 	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
 		error = xfs_attr_shortform_list(context);
@@ -810,12 +809,10 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
 
 	xfs_ilock(dp, XFS_ILOCK_SHARED);
-	if ((XFS_IFORK_Q(dp) == 0) ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
+	if (!xfs_inode_hasattr(dp) ||
+	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
 		xfs_iunlock(dp, XFS_ILOCK_SHARED);
-		return(0);
+		return 0;
 	}
 	xfs_iunlock(dp, XFS_ILOCK_SHARED);
 
@@ -848,10 +845,8 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	/*
 	 * Decide on what work routines to call based on the inode size.
 	 */
-	if ((XFS_IFORK_Q(dp) == 0) ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
+	if (!xfs_inode_hasattr(dp) ||
+	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
 		error = 0;
 		goto out;
 	}
