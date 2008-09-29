Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 14:51:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TLpoAr032173
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:51:50 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2786A9B2630
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:53:26 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id SgR8ZRsfRIzopGKq for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 14:53:26 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8TLrPIF030728
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:53:25 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8TLrPqv030726
	for xfs@oss.sgi.com; Mon, 29 Sep 2008 23:53:25 +0200
Date: Mon, 29 Sep 2008 23:53:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] Remove restricted_chown parameter
Message-ID: <20080929215325.GB30363@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Tim Shimmin <tes@sgi.com>

On Linux all filesystems are supposed to be operating under
Posix' restricted chown. Restricted chown means it restricts
chown to the owner unless you have CAP_FOWNER.

[hch: forward-ported to the current tree]

Signed-off-by: Tim Shimmin <tes@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_globals.c	2008-09-29 18:26:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c	2008-09-29 18:27:29.000000000 +0200
@@ -26,7 +26,6 @@
  */
 xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
-	.restrict_chown	= {	0,		1,		1	},
 	.sgid_inherit	= {	0,		0,		1	},
 	.symlink_mode	= {	0,		0,		1	},
 	.panic_mask	= {	0,		0,		255	},
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-09-29 18:18:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-09-29 18:27:29.000000000 +0200
@@ -112,7 +112,6 @@
 #define HAVE_DMAPI
 #endif
 
-#define restricted_chown	xfs_params.restrict_chown.val
 #define irix_sgid_inherit	xfs_params.sgid_inherit.val
 #define irix_symlink_mode	xfs_params.symlink_mode.val
 #define xfs_panic_mask		xfs_params.panic_mask.val
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2008-09-29 18:18:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c	2008-09-29 18:27:29.000000000 +0200
@@ -56,17 +56,6 @@ xfs_stats_clear_proc_handler(
 
 static ctl_table xfs_table[] = {
 	{
-		.ctl_name	= XFS_RESTRICT_CHOWN,
-		.procname	= "restrict_chown",
-		.data		= &xfs_params.restrict_chown.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &xfs_params.restrict_chown.min,
-		.extra2		= &xfs_params.restrict_chown.max
-	},
-	{
 		.ctl_name	= XFS_SGID_INHERIT,
 		.procname	= "irix_sgid_inherit",
 		.data		= &xfs_params.sgid_inherit.val,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.h	2008-09-29 18:18:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h	2008-09-29 18:27:29.000000000 +0200
@@ -31,7 +31,6 @@ typedef struct xfs_sysctl_val {
 } xfs_sysctl_val_t;
 
 typedef struct xfs_param {
-	xfs_sysctl_val_t restrict_chown;/* Root/non-root can give away files.*/
 	xfs_sysctl_val_t sgid_inherit;	/* Inherit S_ISGID if process' GID is
 					 * not a member of parent dir GID. */
 	xfs_sysctl_val_t symlink_mode;	/* Link creat mode affected by umask */
@@ -68,7 +67,7 @@ typedef struct xfs_param {
 enum {
 	/* XFS_REFCACHE_SIZE = 1 */
 	/* XFS_REFCACHE_PURGE = 2 */
-	XFS_RESTRICT_CHOWN = 3,
+	/* XFS_RESTRICT_CHOWN = 3 */
 	XFS_SGID_INHERIT = 4,
 	XFS_SYMLINK_MODE = 5,
 	XFS_PANIC_MASK = 6,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-29 18:24:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-09-29 18:27:29.000000000 +0200
@@ -1106,10 +1106,6 @@ xfs_ioctl_setattr(
 
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
-	 * If the system was configured with the "restricted_chown"
-	 * option, the owner is not permitted to give away the file,
-	 * and can change the group id only to a group of which he
-	 * or she is a member.
 	 */
 	if (mask & FSX_PROJID) {
 		/*
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-09-29 18:25:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-09-29 18:27:29.000000000 +0200
@@ -210,10 +210,6 @@ xfs_setattr(
 
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
-	 * If the system was configured with the "restricted_chown"
-	 * option, the owner is not permitted to give away the file,
-	 * and can change the group id only to a group of which he
-	 * or she is a member.
 	 */
 	if (mask & (ATTR_UID|ATTR_GID)) {
 		/*
@@ -237,9 +233,8 @@ xfs_setattr(
 		 * shall be equal to either the group ID or one of the
 		 * supplementary group IDs of the calling process.
 		 */
-		if (restricted_chown &&
-		    (iuid != uid || (igid != gid &&
-				     !in_group_p((gid_t)gid))) &&
+		if ((iuid != uid ||
+		     (igid != gid && !in_group_p((gid_t)gid))) &&
 		    !capable(CAP_CHOWN)) {
 			code = XFS_ERROR(EPERM);
 			goto error_return;
@@ -433,10 +428,6 @@ xfs_setattr(
 
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
-	 * If the system was configured with the "restricted_chown"
-	 * option, the owner is not permitted to give away the file,
-	 * and can change the group id only to a group of which he
-	 * or she is a member.
 	 */
 	if (mask & (ATTR_UID|ATTR_GID)) {
 		/*
