Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Aug 2007 10:21:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7JHKubm024681
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 10:20:57 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 6F6F218DF93BB
	for <xfs@oss.sgi.com>; Sun, 19 Aug 2007 12:21:00 -0500 (CDT)
Message-ID: <46C87C05.5040905@sandeen.net>
Date: Sun, 19 Aug 2007 12:21:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] make xfs stats Kconfigurable
References: <46C750C9.8040604@sandeen.net>
In-Reply-To: <46C750C9.8040604@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Oops, typo in Makefile (CONFIG_XFS_STAT vs _STATS).

----


xfs stats are already optional based on CONFIG_PROC_FS, and there
is already a (never-set) macro XFS_STATS_OFF which can turn them
off.  Making it a configurable option, if I turn them off I can
get a little stack savings on x86, gcc 4.1:

xfs_attr_list		-8
xfs_bmap_rtalloc	-16
xfs_bmap_search_extents	-8
xfs_buf_find		+8 (not sure why)
xfs_iflush		-4
xfs_imap		-12
xfs_log_reserve		-4
xfs_log_sync		-8

It'd reduce the size of the binary a bit too.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22.i386/fs/xfs/Kconfig
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/Kconfig
+++ linux-2.6.22.i386/fs/xfs/Kconfig
@@ -59,6 +59,17 @@ config XFS_POSIX_ACL
 
 	  If you don't know what Access Control Lists are, say N.
 
+	config XFS_STATS
+	bool "XFS statistics"
+	depends on XFS_FS && PROC_FS
+	help
+	  If you say Y here xfs will gather detailed statistics during
+	  its operation, and present them in /proc/fs/xfs/stat and
+	  (CONFIG_XFS_QUOTA is enabled) /proc/fs/xfs/xqmstat.  Disabling
+	  this will make the compiled code and stack usage slightly smaller.
+
+	  If unsure, say Y.
+
 config XFS_RT
 	bool "XFS Realtime subvolume support"
 	depends on XFS_FS
Index: linux-2.6.22.i386/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/Makefile-linux-2.6
+++ linux-2.6.22.i386/fs/xfs/Makefile-linux-2.6
@@ -35,12 +35,12 @@ xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix 
 				   xfs_qm.o)
 
 ifeq ($(CONFIG_XFS_QUOTA),y)
-xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_stats.o
+xfs-$(CONFIG_XFS_STATS)		+= quota/xfs_qm_stats.o
 endif
 
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
-xfs-$(CONFIG_PROC_FS)		+= $(XFS_LINUX)/xfs_stats.o
+xfs-$(CONFIG_XFS_STATS)		+= $(XFS_LINUX)/xfs_stats.o
 xfs-$(CONFIG_SYSCTL)		+= $(XFS_LINUX)/xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= $(XFS_LINUX)/xfs_ioctl32.o
 
Index: linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_stats.h
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/linux-2.6/xfs_stats.h
+++ linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_stats.h
@@ -19,7 +19,7 @@
 #define __XFS_STATS_H__
 
 
-#if defined(CONFIG_PROC_FS) && !defined(XFS_STATS_OFF)
+#if defined(CONFIG_XFS_STATS)
 
 #include <linux/percpu.h>
 
@@ -137,8 +137,7 @@ DECLARE_PER_CPU(struct xfsstats, xfsstat
 extern void xfs_init_procfs(void);
 extern void xfs_cleanup_procfs(void);
 
-
-#else	/* !CONFIG_PROC_FS */
+#else	/* !CONFIG_XFS_STATS */
 
 # define XFS_STATS_INC(count)
 # define XFS_STATS_DEC(count)
@@ -147,6 +146,6 @@ extern void xfs_cleanup_procfs(void);
 static __inline void xfs_init_procfs(void) { };
 static __inline void xfs_cleanup_procfs(void) { };
 
-#endif	/* !CONFIG_PROC_FS */
+#endif /* !CONFIG_XFS_STATS */
 
 #endif /* __XFS_STATS_H__ */
Index: linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/linux-2.6/xfs_sysctl.c
+++ linux-2.6.22.i386/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -21,7 +21,7 @@
 
 static struct ctl_table_header *xfs_table_header;
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_XFS_STATS
 STATIC int
 xfs_stats_clear_proc_handler(
 	ctl_table	*ctl,
@@ -52,7 +52,7 @@ xfs_stats_clear_proc_handler(
 
 	return ret;
 }
-#endif /* CONFIG_PROC_FS */
+#endif /* CONFIG_XFS_STATS */
 
 static ctl_table xfs_table[] = {
 	{
@@ -222,7 +222,7 @@ static ctl_table xfs_table[] = {
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
 	/* please keep this the last entry */
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_XFS_STATS
 	{
 		.ctl_name	= XFS_STATS_CLEAR,
 		.procname	= "stats_clear",
Index: linux-2.6.22.i386/fs/xfs/quota/xfs_qm_stats.h
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/quota/xfs_qm_stats.h
+++ linux-2.6.22.i386/fs/xfs/quota/xfs_qm_stats.h
@@ -18,7 +18,7 @@
 #ifndef __XFS_QM_STATS_H__
 #define __XFS_QM_STATS_H__
 
-#if defined(CONFIG_PROC_FS) && !defined(XFS_STATS_OFF)
+#ifdef CONFIG_XFS_STATS
 
 /*
  * XQM global statistics
