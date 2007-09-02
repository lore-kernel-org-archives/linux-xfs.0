Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Sep 2007 13:17:32 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l82KHS4p029282
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 13:17:29 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l82KHRA5029867
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 22:17:27 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l82KHRqV029864
	for xfs@oss.sgi.com; Sun, 2 Sep 2007 22:17:27 +0200
Date: Sun, 2 Sep 2007 22:17:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill probe_* sysctl leftovers
Message-ID: <20070902201727.GA29823@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

After my recent changes the probe_* sysctls are unused because we do
a proper request_module now if we actually know that we need the quota
or dmapi module.  Kill the leftovers that have no function anymore.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_globals.c	2007-09-02 21:48:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_globals.c	2007-09-02 22:02:29.000000000 +0200
@@ -32,9 +32,6 @@ xfs_param_t xfs_params = {
 	.panic_mask	= {	0,		0,		255	},
 	.error_level	= {	0,		3,		11	},
 	.syncd_timer	= {	1*100,		30*100,		7200*100},
-	.probe_dmapi	= {	0,		0,		1	},
-	.probe_ioops	= {	0,		0,		1	},
-	.probe_quota	= {	0,		1,		1	},
 	.stats_clear	= {	0,		0,		1	},
 	.inherit_sync	= {	0,		1,		1	},
 	.inherit_nodump	= {	0,		1,		1	},
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2007-09-02 21:48:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2007-09-02 22:02:29.000000000 +0200
@@ -119,9 +119,6 @@
 #define xfs_panic_mask		xfs_params.panic_mask.val
 #define xfs_error_level		xfs_params.error_level.val
 #define xfs_syncd_centisecs	xfs_params.syncd_timer.val
-#define xfs_probe_dmapi		xfs_params.probe_dmapi.val
-#define xfs_probe_ioops		xfs_params.probe_ioops.val
-#define xfs_probe_quota		xfs_params.probe_quota.val
 #define xfs_stats_clear		xfs_params.stats_clear.val
 #define xfs_inherit_sync	xfs_params.inherit_sync.val
 #define xfs_inherit_nodump	xfs_params.inherit_nodump.val
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2007-09-02 21:48:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c	2007-09-02 22:02:29.000000000 +0200
@@ -123,39 +123,6 @@ static ctl_table xfs_table[] = {
 		.extra2		= &xfs_params.syncd_timer.max
 	},
 	{
-		.ctl_name	= XFS_PROBE_DMAPI,
-		.procname	= "probe_dmapi",
-		.data		= &xfs_params.probe_dmapi.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &xfs_params.probe_dmapi.min,
-		.extra2		= &xfs_params.probe_dmapi.max
-	},
-	{
-		.ctl_name	= XFS_PROBE_IOOPS,
-		.procname	= "probe_ioops",
-		.data		= &xfs_params.probe_ioops.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &xfs_params.probe_ioops.min,
-		.extra2		= &xfs_params.probe_ioops.max
-	},
-	{
-		.ctl_name	= XFS_PROBE_QUOTA,
-		.procname	= "probe_quota",
-		.data		= &xfs_params.probe_quota.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &xfs_params.probe_quota.min,
-		.extra2		= &xfs_params.probe_quota.max
-	},
-	{
 		.ctl_name	= XFS_INHERIT_SYNC,
 		.procname	= "inherit_sync",
 		.data		= &xfs_params.inherit_sync.val,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.h	2007-09-02 21:48:26.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h	2007-09-02 22:02:29.000000000 +0200
@@ -39,9 +39,6 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t error_level;	/* Degree of reporting for problems  */
 	xfs_sysctl_val_t syncd_timer;	/* Interval between xfssyncd wakeups */
 	xfs_sysctl_val_t stats_clear;	/* Reset all XFS statistics to zero. */
-	xfs_sysctl_val_t probe_dmapi;	/* probe for DMAPI module on mount. */
-	xfs_sysctl_val_t probe_ioops;	/* probe for an IO module on mount. */
-	xfs_sysctl_val_t probe_quota;	/* probe for quota module on mount. */
 	xfs_sysctl_val_t inherit_sync;	/* Inherit the "sync" inode flag. */
 	xfs_sysctl_val_t inherit_nodump;/* Inherit the "nodump" inode flag. */
 	xfs_sysctl_val_t inherit_noatim;/* Inherit the "noatime" inode flag. */
@@ -77,9 +74,9 @@ enum {
 	XFS_PANIC_MASK = 6,
 	XFS_ERRLEVEL = 7,
 	XFS_SYNCD_TIMER = 8,
-	XFS_PROBE_DMAPI = 9,
-	XFS_PROBE_IOOPS = 10,
-	XFS_PROBE_QUOTA = 11,
+	/* XFS_PROBE_DMAPI = 9, */
+	/* XFS_PROBE_IOOPS = 10, */
+	/* XFS_PROBE_QUOTA = 11, */
 	XFS_STATS_CLEAR = 12,
 	XFS_INHERIT_SYNC = 13,
 	XFS_INHERIT_NODUMP = 14,
