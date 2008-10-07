Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 13:28:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97KSJSo020672
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 13:28:19 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA36F4C5D0B
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 13:29:57 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ZxSOW3mke7Ei7npB for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 13:29:57 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m97KTuIF017118
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 22:29:56 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m97KTu3P017116
	for xfs@oss.sgi.com; Tue, 7 Oct 2008 22:29:56 +0200
Date: Tue, 7 Oct 2008 22:29:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] Remove restricted_chown parameter
Message-ID: <20081007202956.GA17005@lst.de>
References: <20080929215325.GB30363@lst.de> <20081001133431.GA18672@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001133431.GA18672@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Oct 01, 2008 at 03:34:31PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 29, 2008 at 11:53:25PM +0200, Christoph Hellwig wrote:
> > From: Tim Shimmin <tes@sgi.com>
> > 
> > On Linux all filesystems are supposed to be operating under
> > Posix' restricted chown. Restricted chown means it restricts
> > chown to the owner unless you have CAP_FOWNER.
> > 
> > [hch: forward-ported to the current tree]
> > 
> > Signed-off-by: Tim Shimmin <tes@sgi.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> And here's a version that also updates Documentation/filesystems/xfs.txt
> about the sysctl removal.

Ad another respin because kernel/sysctl_check.c includes xfs_sysctl.h
for some weird check that we need to remove, too.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_globals.c	2008-10-03 22:36:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c	2008-10-03 22:36:05.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-10-03 06:30:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2008-10-07 19:50:50.000000000 +0200
@@ -112,7 +112,6 @@
 #define HAVE_DMAPI
 #endif
 
-#define restricted_chown	xfs_params.restrict_chown.val
 #define irix_sgid_inherit	xfs_params.sgid_inherit.val
 #define irix_symlink_mode	xfs_params.symlink_mode.val
 #define xfs_panic_mask		xfs_params.panic_mask.val
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2008-06-25 06:16:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c	2008-10-03 22:36:05.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.h	2008-06-25 06:16:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h	2008-10-03 22:36:05.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-03 22:36:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-07 22:22:09.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-10-03 22:36:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-10-07 22:22:15.000000000 +0200
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
--- linux-2.6-xfs.orig/Documentation/filesystems/xfs.txt	2008-08-04 19:03:13.000000000 +0200
+++ linux-2.6-xfs/Documentation/filesystems/xfs.txt	2008-10-03 22:36:05.000000000 +0200
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
--- linux-2.6-xfs.orig/kernel/sysctl_check.c	2008-10-07 22:26:34.000000000 +0200
+++ linux-2.6-xfs/kernel/sysctl_check.c	2008-10-07 22:26:47.000000000 +0200
@@ -731,7 +731,6 @@ static const struct trans_ctl_table tran
 };
 
 static const struct trans_ctl_table trans_fs_xfs_table[] = {
-	{ XFS_RESTRICT_CHOWN,	"restrict_chown" },
 	{ XFS_SGID_INHERIT,	"irix_sgid_inherit" },
 	{ XFS_SYMLINK_MODE,	"irix_symlink_mode" },
 	{ XFS_PANIC_MASK,	"panic_mask" },
