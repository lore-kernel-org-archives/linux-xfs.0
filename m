Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 00:23:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L7NkkS019621
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 00:23:47 -0700
Date: Wed, 21 May 2008 09:24:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] streamline init/exit path
Message-ID: <20080521072425.GA29889@lst.de>
References: <20080518130511.GA28501@lst.de> <nccprrg32vr.fsf@sgi.com> <20080521060103.GA25003@lst.de> <nccej7w2l9c.fsf@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nccej7w2l9c.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

Updated patch below.  There's now split out function to create/destroy
the kmem zones and alloc/free the trace buffers.  I've also changed the
ktrace allocations to KM_MAYFAIL and handled errors resulting from that.

And yes, we really should replace the XFS_*_TRACE ifdefs with a single
XFS_TRACE..


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.c	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.c	2008-05-20 07:55:35.000000000 +0200
@@ -98,12 +98,21 @@ xfs_read_xfsstats(
 	return len;
 }
 
-void
+int
 xfs_init_procfs(void)
 {
 	if (!proc_mkdir("fs/xfs", NULL))
-		return;
-	create_proc_read_entry("fs/xfs/stat", 0, NULL, xfs_read_xfsstats, NULL);
+		goto out;
+
+	if (!create_proc_read_entry("fs/xfs/stat", 0, NULL,
+			xfs_read_xfsstats, NULL))
+		goto out_remove_entry;
+	return 0;
+
+ out_remove_entry:
+	remove_proc_entry("fs/xfs", NULL);
+ out:
+	return -ENOMEM;
 }
 
 void
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.h	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h	2008-05-20 07:55:35.000000000 +0200
@@ -134,7 +134,7 @@ DECLARE_PER_CPU(struct xfsstats, xfsstat
 #define XFS_STATS_DEC(v)	(per_cpu(xfsstats, current_cpu()).v--)
 #define XFS_STATS_ADD(v, inc)	(per_cpu(xfsstats, current_cpu()).v += (inc))
 
-extern void xfs_init_procfs(void);
+extern int xfs_init_procfs(void);
 extern void xfs_cleanup_procfs(void);
 
 
@@ -144,8 +144,13 @@ extern void xfs_cleanup_procfs(void);
 # define XFS_STATS_DEC(count)
 # define XFS_STATS_ADD(count, inc)
 
-static inline void xfs_init_procfs(void) { };
-static inline void xfs_cleanup_procfs(void) { };
+static inline int xfs_init_procfs(void)
+{
+	return 0
+};
+static inline void xfs_cleanup_procfs(void)
+{
+};
 
 #endif	/* !CONFIG_PROC_FS */
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-20 07:54:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-21 08:20:21.000000000 +0200
@@ -53,6 +53,11 @@
 #include "xfs_log_priv.h"
 #include "xfs_trans_priv.h"
 #include "xfs_filestream.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_trace.h"
+#include "xfs_extfree_item.h"
+#include "xfs_mru_cache.h"
+#include "xfs_inode_item.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -876,42 +881,6 @@ xfs_fs_inode_init_once(
 	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
 
-STATIC int __init
-xfs_init_zones(void)
-{
-	xfs_vnode_zone = kmem_zone_init_flags(sizeof(bhv_vnode_t), "xfs_vnode",
-					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
-					KM_ZONE_SPREAD,
-					xfs_fs_inode_init_once);
-	if (!xfs_vnode_zone)
-		goto out;
-
-	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
-	if (!xfs_ioend_zone)
-		goto out_destroy_vnode_zone;
-
-	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
-						  xfs_ioend_zone);
-	if (!xfs_ioend_pool)
-		goto out_free_ioend_zone;
-	return 0;
-
- out_free_ioend_zone:
-	kmem_zone_destroy(xfs_ioend_zone);
- out_destroy_vnode_zone:
-	kmem_zone_destroy(xfs_vnode_zone);
- out:
-	return -ENOMEM;
-}
-
-STATIC void
-xfs_destroy_zones(void)
-{
-	mempool_destroy(xfs_ioend_pool);
-	kmem_zone_destroy(xfs_vnode_zone);
-	kmem_zone_destroy(xfs_ioend_zone);
-}
-
 /*
  * Attempt to flush the inode, this will actually fail
  * if the inode is pinned, but we dirty the inode again
@@ -1838,9 +1807,235 @@ struct file_system_type xfs_fs_type = {
 };
 EXPORT_SYMBOL(xfs_fs_type);
 
+STATIC int __init
+xfs_alloc_trace_bufs(void)
+{
+#ifdef XFS_ALLOC_TRACE
+	xfs_alloc_trace_buf = ktrace_alloc(XFS_ALLOC_TRACE_SIZE, KM_MAYFAIL);
+	if (!xfs_alloc_trace_buf)
+		goto out;
+#endif
+#ifdef XFS_BMAP_TRACE
+	xfs_bmap_trace_buf = ktrace_alloc(XFS_BMAP_TRACE_SIZE, KM_MAYFAIL);
+	if (!xfs_bmap_trace_buf)
+		goto out_free_alloc_trace;
+#endif
+#ifdef XFS_BMBT_TRACE
+	xfs_bmbt_trace_buf = ktrace_alloc(XFS_BMBT_TRACE_SIZE, KM_MAYFAIL);
+	if (!xfs_bmbt_trace_buf)
+		goto out_free_bmap_trace;
+#endif
+#ifdef XFS_ATTR_TRACE
+	xfs_attr_trace_buf = ktrace_alloc(XFS_ATTR_TRACE_SIZE, KM_MAYFAIL);
+	if (!xfs_attr_trace_buf)
+		goto out_free_bmbt_trace;
+#endif
+#ifdef XFS_DIR2_TRACE
+	xfs_dir2_trace_buf = ktrace_alloc(XFS_DIR2_GTRACE_SIZE, KM_MAYFAIL);
+	if (!xfs_dir2_trace_buf)
+		goto out_free_attr_trace;
+#endif
+
+	return 0;
+
+#ifdef XFS_DIR2_TRACE
+ out_free_attr_trace:
+#endif
+#ifdef XFS_ATTR_TRACE
+	ktrace_free(xfs_attr_trace_buf);
+ out_free_bmbt_trace:
+#endif
+#ifdef XFS_BMBT_TRACE
+	ktrace_free(xfs_bmbt_trace_buf);
+ out_free_bmap_trace:
+#endif
+#ifdef XFS_BMAP_TRACE
+	ktrace_free(xfs_bmap_trace_buf);
+ out_free_alloc_trace:
+#endif
+#ifdef XFS_ALLOC_TRACE
+	ktrace_free(xfs_alloc_trace_buf);
+ out:
+#endif
+	return -ENOMEM;
+}
+
+STATIC void
+xfs_free_trace_bufs(void)
+{
+#ifdef XFS_DIR2_TRACE
+	ktrace_free(xfs_dir2_trace_buf);
+#endif
+#ifdef XFS_ATTR_TRACE
+	ktrace_free(xfs_attr_trace_buf);
+#endif
+#ifdef XFS_BMBT_TRACE
+	ktrace_free(xfs_bmbt_trace_buf);
+#endif
+#ifdef XFS_BMAP_TRACE
+	ktrace_free(xfs_bmap_trace_buf);
+#endif
+#ifdef XFS_ALLOC_TRACE
+	ktrace_free(xfs_alloc_trace_buf);
+#endif
+}
 
 STATIC int __init
-init_xfs_fs( void )
+xfs_init_zones(void)
+{
+	xfs_vnode_zone = kmem_zone_init_flags(sizeof(bhv_vnode_t), "xfs_vnode",
+					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
+					KM_ZONE_SPREAD,
+					xfs_fs_inode_init_once);
+	if (!xfs_vnode_zone)
+		goto out;
+
+	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
+	if (!xfs_ioend_zone)
+		goto out_destroy_vnode_zone;
+
+	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
+						  xfs_ioend_zone);
+	if (!xfs_ioend_pool)
+		goto out_destroy_ioend_zone;
+
+	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
+						"xfs_log_ticket");
+	if (!xfs_log_ticket_zone)
+		goto out_destroy_ioend_pool;
+
+	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
+						"xfs_bmap_free_item");
+	if (!xfs_bmap_free_item_zone)
+		goto out_destroy_log_ticket_zone;
+	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
+						"xfs_btree_cur");
+	if (!xfs_btree_cur_zone)
+		goto out_destroy_bmap_free_item_zone;
+
+	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
+						"xfs_da_state");
+	if (!xfs_da_state_zone)
+		goto out_destroy_btree_cur_zone;
+
+	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
+	if (!xfs_dabuf_zone)
+		goto out_destroy_da_state_zone;
+
+	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
+	if (!xfs_ifork_zone)
+		goto out_destroy_dabuf_zone;
+
+	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
+	if (!xfs_trans_zone)
+		goto out_destroy_ifork_zone;
+
+	/*
+	 * The size of the zone allocated buf log item is the maximum
+	 * size possible under XFS.  This wastes a little bit of memory,
+	 * but it is much faster.
+	 */
+	xfs_buf_item_zone = kmem_zone_init((sizeof(xfs_buf_log_item_t) +
+				(((XFS_MAX_BLOCKSIZE / XFS_BLI_CHUNK) /
+				  NBWORD) * sizeof(int))), "xfs_buf_item");
+	if (!xfs_buf_item_zone)
+		goto out_destroy_trans_zone;
+
+	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
+			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
+				 sizeof(xfs_extent_t))), "xfs_efd_item");
+	if (!xfs_efd_zone)
+		goto out_destroy_buf_item_zone;
+
+	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
+			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
+				sizeof(xfs_extent_t))), "xfs_efi_item");
+	if (!xfs_efi_zone)
+		goto out_destroy_efd_zone;
+
+	xfs_inode_zone =
+		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
+					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
+					KM_ZONE_SPREAD, NULL);
+	if (!xfs_inode_zone)
+		goto out_destroy_efi_zone;
+
+	xfs_ili_zone =
+		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
+					KM_ZONE_SPREAD, NULL);
+	if (!xfs_ili_zone)
+		goto out_destroy_inode_zone;
+
+#ifdef CONFIG_XFS_POSIX_ACL
+	xfs_acl_zone = kmem_zone_init(sizeof(xfs_acl_t), "xfs_acl");
+	if (!xfs_acl_zone)
+		goto out_destroy_ili_zone;
+#endif
+
+	return 0;
+
+#ifdef CONFIG_XFS_POSIX_ACL
+ out_destroy_ili_zone:
+#endif
+	kmem_zone_destroy(xfs_ili_zone);
+ out_destroy_inode_zone:
+	kmem_zone_destroy(xfs_inode_zone);
+ out_destroy_efi_zone:
+	kmem_zone_destroy(xfs_efi_zone);
+ out_destroy_efd_zone:
+	kmem_zone_destroy(xfs_efd_zone);
+ out_destroy_buf_item_zone:
+	kmem_zone_destroy(xfs_buf_item_zone);
+ out_destroy_trans_zone:
+	kmem_zone_destroy(xfs_trans_zone);
+ out_destroy_ifork_zone:
+	kmem_zone_destroy(xfs_ifork_zone);
+ out_destroy_dabuf_zone:
+	kmem_zone_destroy(xfs_dabuf_zone);
+ out_destroy_da_state_zone:
+	kmem_zone_destroy(xfs_da_state_zone);
+ out_destroy_btree_cur_zone:
+	kmem_zone_destroy(xfs_btree_cur_zone);
+ out_destroy_bmap_free_item_zone:
+	kmem_zone_destroy(xfs_bmap_free_item_zone);
+ out_destroy_log_ticket_zone:
+	kmem_zone_destroy(xfs_log_ticket_zone);
+ out_destroy_ioend_pool:
+	mempool_destroy(xfs_ioend_pool);
+ out_destroy_ioend_zone:
+	kmem_zone_destroy(xfs_ioend_zone);
+ out_destroy_vnode_zone:
+	kmem_zone_destroy(xfs_vnode_zone);
+ out:
+	return -ENOMEM;
+}
+
+STATIC void
+xfs_destroy_zones(void)
+{
+#ifdef CONFIG_XFS_POSIX_ACL
+	kmem_zone_destroy(xfs_acl_zone);
+#endif
+	kmem_zone_destroy(xfs_ili_zone);
+	kmem_zone_destroy(xfs_inode_zone);
+	kmem_zone_destroy(xfs_efi_zone);
+	kmem_zone_destroy(xfs_efd_zone);
+	kmem_zone_destroy(xfs_buf_item_zone);
+	kmem_zone_destroy(xfs_trans_zone);
+	kmem_zone_destroy(xfs_ifork_zone);
+	kmem_zone_destroy(xfs_dabuf_zone);
+	kmem_zone_destroy(xfs_da_state_zone);
+	kmem_zone_destroy(xfs_btree_cur_zone);
+	kmem_zone_destroy(xfs_bmap_free_item_zone);
+	kmem_zone_destroy(xfs_log_ticket_zone);
+	mempool_destroy(xfs_ioend_pool);
+	kmem_zone_destroy(xfs_ioend_zone);
+	kmem_zone_destroy(xfs_vnode_zone);
+
+}
+
+STATIC int __init
+init_xfs_fs(void)
 {
 	int			error;
 	static char		message[] __initdata = KERN_INFO \
@@ -1849,40 +2044,70 @@ init_xfs_fs( void )
 	printk(message);
 
 	ktrace_init(64);
+	vn_init();
+	xfs_dir_startup();
 
 	error = xfs_init_zones();
-	if (error < 0)
-		goto undo_zones;
+	if (error)
+		goto out;
+
+	error = xfs_alloc_trace_bufs();
+	if (error)
+		goto out_destroy_zones;
+
+	error = xfs_mru_cache_init();
+	if (error)
+		goto out_free_trace_buffers;
+
+	error = xfs_filestream_init();
+	if (error)
+		goto out_mru_cache_uninit;
 
 	error = xfs_buf_init();
-	if (error < 0)
-		goto undo_buffers;
+	if (error)
+		goto out_filestream_uninit;
 
-	vn_init();
-	xfs_init();
-	uuid_init();
+	error = xfs_init_procfs();
+	if (error)
+		goto out_buf_terminate;
+
+	error = xfs_sysctl_register();
+	if (error)
+		goto out_cleanup_procfs;
 
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
-		goto undo_register;
+		goto out_sysctl_unregister;
 	return 0;
 
-undo_register:
+ out_sysctl_unregister:
+	xfs_sysctl_unregister();
+ out_cleanup_procfs:
+	xfs_cleanup_procfs();
+ out_buf_terminate:
 	xfs_buf_terminate();
-
-undo_buffers:
+ out_filestream_uninit:
+	xfs_filestream_uninit();
+ out_mru_cache_uninit:
+	xfs_mru_cache_uninit();
+ out_free_trace_buffers:
+	xfs_free_trace_bufs();
+ out_destroy_zones:
 	xfs_destroy_zones();
-
-undo_zones:
+ out:
 	return error;
 }
 
 STATIC void __exit
-exit_xfs_fs( void )
+exit_xfs_fs(void)
 {
 	unregister_filesystem(&xfs_fs_type);
-	xfs_cleanup();
+	xfs_sysctl_unregister();
+	xfs_cleanup_procfs();
 	xfs_buf_terminate();
+	xfs_filestream_uninit();
+	xfs_mru_cache_uninit();
+	xfs_free_trace_bufs();
 	xfs_destroy_zones();
 	ktrace_uninit();
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.c	2008-05-20 07:55:35.000000000 +0200
@@ -259,15 +259,17 @@ static ctl_table xfs_root_table[] = {
 	{}
 };
 
-void
+int
 xfs_sysctl_register(void)
 {
 	xfs_table_header = register_sysctl_table(xfs_root_table);
+	if (!xfs_table_header)
+		return -ENOMEM;
+	return 0;
 }
 
 void
 xfs_sysctl_unregister(void)
 {
-	if (xfs_table_header)
-		unregister_sysctl_table(xfs_table_header);
+	unregister_sysctl_table(xfs_table_header);
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_sysctl.h	2008-05-20 07:42:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_sysctl.h	2008-05-20 07:55:35.000000000 +0200
@@ -93,10 +93,10 @@ enum {
 extern xfs_param_t	xfs_params;
 
 #ifdef CONFIG_SYSCTL
-extern void xfs_sysctl_register(void);
+extern int xfs_sysctl_register(void);
 extern void xfs_sysctl_unregister(void);
 #else
-# define xfs_sysctl_register()		do { } while (0)
+# define xfs_sysctl_register()		(0)
 # define xfs_sysctl_unregister()	do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
Index: linux-2.6-xfs/fs/xfs/support/uuid.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/uuid.c	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/support/uuid.c	2008-05-20 07:55:35.000000000 +0200
@@ -17,7 +17,7 @@
  */
 #include <xfs.h>
 
-static mutex_t	uuid_monitor;
+static DEFINE_MUTEX(uuid_monitor);
 static int	uuid_table_size;
 static uuid_t	*uuid_table;
 
@@ -132,9 +132,3 @@ uuid_table_remove(uuid_t *uuid)
 	ASSERT(i < uuid_table_size);
 	mutex_unlock(&uuid_monitor);
 }
-
-void __init
-uuid_init(void)
-{
-	mutex_init(&uuid_monitor);
-}
Index: linux-2.6-xfs/fs/xfs/support/uuid.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/support/uuid.h	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/support/uuid.h	2008-05-20 07:55:35.000000000 +0200
@@ -22,7 +22,6 @@ typedef struct {
 	unsigned char	__u_bits[16];
 } uuid_t;
 
-extern void uuid_init(void);
 extern void uuid_create_nil(uuid_t *uuid);
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
Index: linux-2.6-xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_da_btree.c	2008-05-20 07:42:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_da_btree.c	2008-05-20 07:55:35.000000000 +0200
@@ -2218,7 +2218,7 @@ xfs_da_state_free(xfs_da_state_t *state)
 
 #ifdef XFS_DABUF_DEBUG
 xfs_dabuf_t	*xfs_dabuf_global_list;
-spinlock_t	xfs_dabuf_global_lock;
+static DEFINE_SPINLOCK(xfs_dabuf_global_lock);
 #endif
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_error.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_error.c	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_error.c	2008-05-20 07:55:35.000000000 +0200
@@ -66,14 +66,6 @@ int	xfs_etest[XFS_NUM_INJECT_ERROR];
 int64_t	xfs_etest_fsid[XFS_NUM_INJECT_ERROR];
 char *	xfs_etest_fsname[XFS_NUM_INJECT_ERROR];
 
-void
-xfs_error_test_init(void)
-{
-	memset(xfs_etest, 0, sizeof(xfs_etest));
-	memset(xfs_etest_fsid, 0, sizeof(xfs_etest_fsid));
-	memset(xfs_etest_fsname, 0, sizeof(xfs_etest_fsname));
-}
-
 int
 xfs_error_test(int error_tag, int *fsidp, char *expression,
 	       int line, char *file, unsigned long randfactor)
Index: linux-2.6-xfs/fs/xfs/xfs_error.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_error.h	2008-05-20 07:42:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_error.h	2008-05-20 07:55:35.000000000 +0200
@@ -127,7 +127,6 @@ extern void xfs_corruption_error(char *t
 
 #if (defined(DEBUG) || defined(INDUCE_IO_ERROR))
 extern int xfs_error_test(int, int *, char *, int, char *, unsigned long);
-extern void xfs_error_test_init(void);
 
 #define	XFS_NUM_INJECT_ERROR				10
 
Index: linux-2.6-xfs/fs/xfs/xfs_filestream.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_filestream.c	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_filestream.c	2008-05-20 07:55:35.000000000 +0200
@@ -397,10 +397,12 @@ int
 xfs_filestream_init(void)
 {
 	item_zone = kmem_zone_init(sizeof(fstrm_item_t), "fstrm_item");
+	if (!item_zone)
+		return -ENOMEM;
 #ifdef XFS_FILESTREAMS_TRACE
 	xfs_filestreams_trace_buf = ktrace_alloc(XFS_FSTRM_KTRACE_SIZE, KM_SLEEP);
 #endif
-	return item_zone ? 0 : -ENOMEM;
+	return 0;
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-05-20 07:47:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-05-20 07:55:35.000000000 +0200
@@ -545,9 +545,6 @@ extern void	xfs_qmops_put(struct xfs_mou
 
 extern struct xfs_dmops xfs_dmcore_xfs;
 
-extern int	xfs_init(void);
-extern void	xfs_cleanup(void);
-
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_MOUNT_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_mru_cache.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mru_cache.c	2008-05-20 07:42:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mru_cache.c	2008-05-20 07:55:35.000000000 +0200
@@ -307,15 +307,18 @@ xfs_mru_cache_init(void)
 	xfs_mru_elem_zone = kmem_zone_init(sizeof(xfs_mru_cache_elem_t),
 	                                 "xfs_mru_cache_elem");
 	if (!xfs_mru_elem_zone)
-		return ENOMEM;
+		goto out;
 
 	xfs_mru_reap_wq = create_singlethread_workqueue("xfs_mru_cache");
-	if (!xfs_mru_reap_wq) {
-		kmem_zone_destroy(xfs_mru_elem_zone);
-		return ENOMEM;
-	}
+	if (!xfs_mru_reap_wq)
+		goto out_destroy_mru_elem_zone;
 
 	return 0;
+
+ out_destroy_mru_elem_zone:
+	kmem_zone_destroy(xfs_mru_elem_zone);
+ out:
+	return -ENOMEM;
 }
 
 void
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-05-20 07:47:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-05-20 07:55:35.000000000 +0200
@@ -58,137 +58,6 @@
 #include "xfs_utils.h"
 
 
-int __init
-xfs_init(void)
-{
-#ifdef XFS_DABUF_DEBUG
-	extern spinlock_t        xfs_dabuf_global_lock;
-	spin_lock_init(&xfs_dabuf_global_lock);
-#endif
-
-	/*
-	 * Initialize all of the zone allocators we use.
-	 */
-	xfs_log_ticket_zone = kmem_zone_init(sizeof(xlog_ticket_t),
-						"xfs_log_ticket");
-	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
-						"xfs_bmap_free_item");
-	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
-						"xfs_btree_cur");
-	xfs_da_state_zone = kmem_zone_init(sizeof(xfs_da_state_t),
-						"xfs_da_state");
-	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
-	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
-	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
-	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
-	xfs_mru_cache_init();
-	xfs_filestream_init();
-
-	/*
-	 * The size of the zone allocated buf log item is the maximum
-	 * size possible under XFS.  This wastes a little bit of memory,
-	 * but it is much faster.
-	 */
-	xfs_buf_item_zone =
-		kmem_zone_init((sizeof(xfs_buf_log_item_t) +
-				(((XFS_MAX_BLOCKSIZE / XFS_BLI_CHUNK) /
-				  NBWORD) * sizeof(int))),
-			       "xfs_buf_item");
-	xfs_efd_zone =
-		kmem_zone_init((sizeof(xfs_efd_log_item_t) +
-			       ((XFS_EFD_MAX_FAST_EXTENTS - 1) *
-				 sizeof(xfs_extent_t))),
-				      "xfs_efd_item");
-	xfs_efi_zone =
-		kmem_zone_init((sizeof(xfs_efi_log_item_t) +
-			       ((XFS_EFI_MAX_FAST_EXTENTS - 1) *
-				 sizeof(xfs_extent_t))),
-				      "xfs_efi_item");
-
-	/*
-	 * These zones warrant special memory allocator hints
-	 */
-	xfs_inode_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
-					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
-					KM_ZONE_SPREAD, NULL);
-	xfs_ili_zone =
-		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
-					KM_ZONE_SPREAD, NULL);
-
-	/*
-	 * Allocate global trace buffers.
-	 */
-#ifdef XFS_ALLOC_TRACE
-	xfs_alloc_trace_buf = ktrace_alloc(XFS_ALLOC_TRACE_SIZE, KM_SLEEP);
-#endif
-#ifdef XFS_BMAP_TRACE
-	xfs_bmap_trace_buf = ktrace_alloc(XFS_BMAP_TRACE_SIZE, KM_SLEEP);
-#endif
-#ifdef XFS_BMBT_TRACE
-	xfs_bmbt_trace_buf = ktrace_alloc(XFS_BMBT_TRACE_SIZE, KM_SLEEP);
-#endif
-#ifdef XFS_ATTR_TRACE
-	xfs_attr_trace_buf = ktrace_alloc(XFS_ATTR_TRACE_SIZE, KM_SLEEP);
-#endif
-#ifdef XFS_DIR2_TRACE
-	xfs_dir2_trace_buf = ktrace_alloc(XFS_DIR2_GTRACE_SIZE, KM_SLEEP);
-#endif
-
-	xfs_dir_startup();
-
-#if (defined(DEBUG) || defined(INDUCE_IO_ERROR))
-	xfs_error_test_init();
-#endif /* DEBUG || INDUCE_IO_ERROR */
-
-	xfs_init_procfs();
-	xfs_sysctl_register();
-	return 0;
-}
-
-void __exit
-xfs_cleanup(void)
-{
-	extern kmem_zone_t	*xfs_inode_zone;
-	extern kmem_zone_t	*xfs_efd_zone;
-	extern kmem_zone_t	*xfs_efi_zone;
-
-	xfs_cleanup_procfs();
-	xfs_sysctl_unregister();
-	xfs_filestream_uninit();
-	xfs_mru_cache_uninit();
-	xfs_acl_zone_destroy(xfs_acl_zone);
-
-#ifdef XFS_DIR2_TRACE
-	ktrace_free(xfs_dir2_trace_buf);
-#endif
-#ifdef XFS_ATTR_TRACE
-	ktrace_free(xfs_attr_trace_buf);
-#endif
-#ifdef XFS_BMBT_TRACE
-	ktrace_free(xfs_bmbt_trace_buf);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ktrace_free(xfs_bmap_trace_buf);
-#endif
-#ifdef XFS_ALLOC_TRACE
-	ktrace_free(xfs_alloc_trace_buf);
-#endif
-
-	kmem_zone_destroy(xfs_bmap_free_item_zone);
-	kmem_zone_destroy(xfs_btree_cur_zone);
-	kmem_zone_destroy(xfs_inode_zone);
-	kmem_zone_destroy(xfs_trans_zone);
-	kmem_zone_destroy(xfs_da_state_zone);
-	kmem_zone_destroy(xfs_dabuf_zone);
-	kmem_zone_destroy(xfs_buf_item_zone);
-	kmem_zone_destroy(xfs_efd_zone);
-	kmem_zone_destroy(xfs_efi_zone);
-	kmem_zone_destroy(xfs_ifork_zone);
-	kmem_zone_destroy(xfs_ili_zone);
-	kmem_zone_destroy(xfs_log_ticket_zone);
-}
-
 STATIC void
 xfs_quiesce_fs(
 	xfs_mount_t		*mp)
