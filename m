Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:36:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDadAs021672
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:36:39 -0700
Date: Mon, 27 Oct 2008 09:36:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] remove restricted_chown parameter
Message-ID: <20081027133637.GC761@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-restricted-chown
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Tim Shimmin <tes@sgi.com>

From: Tim Shimmin <tes@sgi.com>

On Linux all filesystems are supposed to be operating under
Posix' restricted chown. Restricted chown means it restricts
chown to the owner unless you have CAP_FOWNER.

[hch: forward-ported to the current tree]


Signed-off-by: Tim Shimmin <tes@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_globals.c	2008-10-15 13:31:22.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c	2008-10-15 13:31:22.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-10-14 19:55:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-10-22 09:29:08.000000000 +0200
@@ -112,7 +111,6 @@
 #define HAVE_DMAPI
 #endif
 
-#define restricted_chown	xfs_params.restrict_chown.val
 #define irix_sgid_inherit	xfs_params.sgid_inherit.val
 #define irix_symlink_mode	xfs_params.symlink_mode.val
 #define xfs_panic_mask		xfs_params.panic_mask.val
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2008-10-14 19:55:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c	2008-10-15 13:31:22.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.h	2008-10-14 19:55:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h	2008-10-15 13:31:22.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-15 13:31:22.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-22 09:29:45.000000000 +0200
@@ -1104,10 +1104,6 @@ xfs_ioctl_setattr(
 
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-10-15 13:31:22.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-10-22 09:29:45.000000000 +0200
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
Index: linux-2.6-xfs/Documentation/filesystems/xfs.txt
===================================================================
--- linux-2.6-xfs.orig/Documentation/filesystems/xfs.txt	2008-10-14 19:55:29.000000000 +0200
+++ linux-2.6-xfs/Documentation/filesystems/xfs.txt	2008-10-15 13:31:22.000000000 +0200
@@ -229,10 +229,6 @@ The following sysctls are available for 
 	ISGID bit is cleared if the irix_sgid_inherit compatibility sysctl
 	is set.
 
-  fs.xfs.restrict_chown		(Min: 0  Default: 1  Max: 1)
-  	Controls whether unprivileged users can use chown to "give away"
-	a file to another user.
-
   fs.xfs.inherit_sync		(Min: 0  Default: 1  Max: 1)
 	Setting this to "1" will cause the "sync" flag set
 	by the xfs_io(8) chattr command on a directory to be
Index: linux-2.6-xfs/kernel/sysctl_check.c
===================================================================
--- linux-2.6-xfs.orig/kernel/sysctl_check.c	2008-10-14 19:55:29.000000000 +0200
+++ linux-2.6-xfs/kernel/sysctl_check.c	2008-10-15 13:31:22.000000000 +0200
@@ -731,7 +731,6 @@ static const struct trans_ctl_table tran
 };
 
 static const struct trans_ctl_table trans_fs_xfs_table[] = {
-	{ XFS_RESTRICT_CHOWN,	"restrict_chown" },
 	{ XFS_SGID_INHERIT,	"irix_sgid_inherit" },
 	{ XFS_SYMLINK_MODE,	"irix_symlink_mode" },
 	{ XFS_PANIC_MASK,	"panic_mask" },

-- 
