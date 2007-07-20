Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 21:12:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K4CGbm027877
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 21:12:18 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 0542E1801056F
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 23:12:20 -0500 (CDT)
Message-ID: <46A03623.8010901@sandeen.net>
Date: Thu, 19 Jul 2007 23:12:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/7] - remove xfs_physmem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Now that nobody's using it, remove xfs_physmem & friends.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/linux-2.4/xfs_globals.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_globals.c
+++ linux/fs/xfs/linux-2.4/xfs_globals.c
@@ -21,11 +21,6 @@
 #include "xfs_refcache.h"
 
 /*
- * System memory size - used to scale certain data structures in XFS.
- */
-unsigned long xfs_physmem;
-
-/*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
  * other XFS code uses these values.  Times are measured in centisecs (i.e.
  * 100ths of a second).
Index: linux/fs/xfs/linux-2.4/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_super.c
+++ linux/fs/xfs/linux-2.4/xfs_super.c
@@ -1008,15 +1008,11 @@ STATIC int __init
 init_xfs_fs( void )
 {
 	int			error;
-	struct sysinfo		si;
 	static char		message[] __initdata = KERN_INFO \
 		XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled\n";
 
 	printk(message);
 
-	si_meminfo(&si);
-	xfs_physmem = si.totalram;
-
 	ktrace_init(64);
 
 	error = xfs_init_inodecache();
Index: linux/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_globals.c
+++ linux/fs/xfs/linux-2.6/xfs_globals.c
@@ -20,11 +20,6 @@
 #include "xfs_sysctl.h"
 
 /*
- * System memory size - used to scale certain data structures in XFS.
- */
-unsigned long xfs_physmem;
-
-/*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
  * other XFS code uses these values.  Times are measured in centisecs (i.e.
  * 100ths of a second).
Index: linux/fs/xfs/linux-2.6/xfs_globals.h
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_globals.h
+++ linux/fs/xfs/linux-2.6/xfs_globals.h
@@ -19,7 +19,6 @@
 #define __XFS_GLOBALS_H__
 
 extern uint64_t	xfs_panic_mask;		/* set to cause more panics */
-extern unsigned long xfs_physmem;
 extern struct cred *sys_cred;
 
 #endif	/* __XFS_GLOBALS_H__ */
Index: linux/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux/fs/xfs/linux-2.6/xfs_super.c
@@ -914,15 +914,11 @@ STATIC int __init
 init_xfs_fs( void )
 {
 	int			error;
-	struct sysinfo		si;
 	static char		message[] __initdata = KERN_INFO \
 		XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled\n";
 
 	printk(message);
 
-	si_meminfo(&si);
-	xfs_physmem = si.totalram;
-
 	ktrace_init(64);
 
 	error = xfs_init_zones();
Index: linux/fs/xfs/linux-2.4/xfs_globals.h
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_globals.h
+++ linux/fs/xfs/linux-2.4/xfs_globals.h
@@ -19,7 +19,6 @@
 #define __XFS_GLOBALS_H__
 
 extern uint64_t	xfs_panic_mask;		/* set to cause more panics */
-extern unsigned long xfs_physmem;
 extern struct cred *sys_cred;
 
 #endif	/* __XFS_GLOBALS_H__ */
