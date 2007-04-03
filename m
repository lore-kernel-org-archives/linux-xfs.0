Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Apr 2007 23:09:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3369YfB022611
	for <xfs@oss.sgi.com>; Mon, 2 Apr 2007 23:09:36 -0700
Date: Tue, 03 Apr 2007 16:10:38 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: review: export xfs_buftarg_list for use by xfsidbg
Message-ID: <C012E350427BA5552771BCD5@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev@sgi.com

Hi,

This patch addresses the problem of having xfs_buftarg_list global for use
by kdb and xfsidbg, where otherwise it would be static.
If we are using xfsidbg, then we export the xfs_get_buftarg_list function
to it.
Previous to Dave's (dgc) static changes, we were only globalizing it if
we were in DEBUG - when really it is a question of xfsidbg.
Using CONFIG_KDB_MODULES as this is what we use in the Makefiles for
determining if xfsidbg is used.

--Tim

 linux-2.4/xfs_buf.c   |    8 ++++++++
 linux-2.4/xfs_buf.h   |    3 +++
 linux-2.4/xfs_ksyms.c |    5 ++---
 linux-2.6/xfs_buf.c   |   10 +++++++++-
 linux-2.6/xfs_buf.h   |    3 +++
 linux-2.6/xfs_ksyms.c |    5 ++---
 xfsidbg.c             |    9 +++------
 7 files changed, 30 insertions(+), 13 deletions(-)

===========================================================================
Index: fs/xfs/linux-2.4/xfs_buf.c
===========================================================================

--- a/fs/xfs/linux-2.4/xfs_buf.c	2007-04-03 15:47:15.000000000 +1000
+++ b/fs/xfs/linux-2.4/xfs_buf.c	2007-04-03 15:45:23.930213823 +1000
@@ -2335,3 +2335,11 @@ xfs_buf_terminate(void)
 	kmem_zone_destroy(xfs_buf_zone);
 	kmem_shake_deregister(xfs_buf_shake);
 }
+
+#ifdef CONFIG_KDB_MODULES
+struct list_head *
+xfs_get_buftarg_list(void)
+{
+	return &xfs_buftarg_list;
+}
+#endif

===========================================================================
Index: fs/xfs/linux-2.4/xfs_buf.h
===========================================================================

--- a/fs/xfs/linux-2.4/xfs_buf.h	2007-04-03 15:47:15.000000000 +1000
+++ b/fs/xfs/linux-2.4/xfs_buf.h	2007-04-03 15:46:59.997634360 +1000
@@ -500,6 +500,9 @@ extern void xfs_free_buftarg(xfs_buftarg
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
 extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
+#ifdef CONFIG_KDB_MODULES
+extern struct list_head *xfs_get_buftarg_list(void);
+#endif

 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_kdev)
 #define xfs_readonly_buftarg(buftarg)	is_read_only((buftarg)->bt_kdev)

===========================================================================
Index: fs/xfs/linux-2.4/xfs_ksyms.c
===========================================================================

--- a/fs/xfs/linux-2.4/xfs_ksyms.c	2007-04-03 15:47:15.000000000 +1000
+++ b/fs/xfs/linux-2.4/xfs_ksyms.c	2007-04-03 15:46:29.489629322 +1000
@@ -124,9 +124,8 @@ EXPORT_SYMBOL(xfs_params);
 EXPORT_SYMBOL(xfs_bmbt_disk_get_all);
 #endif

-#if defined(CONFIG_XFS_DEBUG)
-extern struct list_head xfs_buftarg_list;
-EXPORT_SYMBOL(xfs_buftarg_list);
+#if defined(CONFIG_KDB_MODULES)
+EXPORT_SYMBOL(xfs_get_buftarg_list);
 #endif

 /*

===========================================================================
Index: fs/xfs/linux-2.6/xfs_buf.c
===========================================================================

--- a/fs/xfs/linux-2.6/xfs_buf.c	2007-04-03 15:47:15.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_buf.c	2007-04-03 15:11:15.778300965 +1000
@@ -1426,7 +1426,7 @@ xfs_free_bufhash(
 /*
  *	buftarg list for delwrite queue processing
  */
-LIST_HEAD(xfs_buftarg_list);
+static LIST_HEAD(xfs_buftarg_list);
 static DEFINE_SPINLOCK(xfs_buftarg_lock);

 STATIC void
@@ -1867,3 +1867,11 @@ xfs_buf_terminate(void)
 	ktrace_free(xfs_buf_trace_buf);
 #endif
 }
+
+#ifdef CONFIG_KDB_MODULES
+struct list_head *
+xfs_get_buftarg_list(void)
+{
+	return &xfs_buftarg_list;
+}
+#endif

===========================================================================
Index: fs/xfs/linux-2.6/xfs_buf.h
===========================================================================

--- a/fs/xfs/linux-2.6/xfs_buf.h	2007-04-03 15:47:15.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_buf.h	2007-04-03 15:22:51.547106965 +1000
@@ -411,6 +411,9 @@ extern void xfs_free_buftarg(xfs_buftarg
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
 extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
+#ifdef CONFIG_KDB_MODULES
+extern struct list_head *xfs_get_buftarg_list(void);
+#endif

 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)

===========================================================================
Index: fs/xfs/linux-2.6/xfs_ksyms.c
===========================================================================

--- a/fs/xfs/linux-2.6/xfs_ksyms.c	2007-04-03 15:47:15.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_ksyms.c	2007-04-03 14:52:27.011000730 +1000
@@ -125,9 +125,8 @@ EXPORT_SYMBOL(xfs_params);
 EXPORT_SYMBOL(xfs_bmbt_disk_get_all);
 #endif

-#if defined(CONFIG_XFS_DEBUG)
-extern struct list_head xfs_buftarg_list;
-EXPORT_SYMBOL(xfs_buftarg_list);
+#if defined(CONFIG_KDB_MODULES)
+EXPORT_SYMBOL(xfs_get_buftarg_list);
 #endif

 /*

===========================================================================
Index: fs/xfs/xfsidbg.c
===========================================================================

--- a/fs/xfs/xfsidbg.c	2007-04-03 15:47:15.000000000 +1000
+++ b/fs/xfs/xfsidbg.c	2007-04-03 15:24:02.201877199 +1000
@@ -62,6 +62,7 @@
 #include "xfs_quota.h"
 #include "quota/xfs_qm.h"
 #include "xfs_iomap.h"
+#include "xfs_buf.h"

 MODULE_AUTHOR("Silicon Graphics, Inc.");
 MODULE_DESCRIPTION("Additional kdb commands for debugging XFS");
@@ -2350,8 +2351,7 @@ kdbm_bp(int argc, const char **argv)
 static int
 kdbm_bpdelay(int argc, const char **argv)
 {
-#ifdef DEBUG
-	extern struct list_head xfs_buftarg_list;
+	struct list_head	*xfs_buftarg_list = xfs_get_buftarg_list();
 	struct list_head	*curr, *next;
 	xfs_buftarg_t		*tp, *n;
 	xfs_buf_t		bp;
@@ -2372,7 +2372,7 @@ kdbm_bpdelay(int argc, const char **argv
 	}


-	list_for_each_entry_safe(tp, n, &xfs_buftarg_list, bt_list) {
+	list_for_each_entry_safe(tp, n, xfs_buftarg_list, bt_list) {
 		list_for_each_safe(curr, next, &tp->bt_delwrite_queue) {
 			addr = (unsigned long)list_entry(curr, xfs_buf_t, b_list);
 			if ((diag = kdb_getarea(bp, addr)))
@@ -2388,9 +2388,6 @@ kdbm_bpdelay(int argc, const char **argv
 			}
 		}
 	}
-#else
-	kdb_printf("bt_delwrite_queue inaccessible (non-debug)\n");
-#endif
 	return 0;
 }
