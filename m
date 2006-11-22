Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 20:25:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAM4PiaG028806
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 20:25:45 -0800
Date: Wed, 22 Nov 2006 15:24:45 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] Make stuff static
Message-ID: <20061122042445.GR37654165@melbourne.sgi.com>
References: <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com> <20061017215706.GI8394166@melbourne.sgi.com> <1161125131.5723.158.camel@xenon.msp.redhat.com> <20061122004216.GT11034@melbourne.sgi.com> <1164157783.19915.46.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1164157783.19915.46.camel@xenon.msp.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: David Chinner <dgc@sgi.com>, Tim Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Nov 21, 2006 at 07:09:43PM -0600, Russell Cattelan wrote:
> On Wed, 2006-11-22 at 11:42 +1100, David Chinner wrote:
> > Ok, so I've had time to look at this again. Here's the definitions
> > of STATIC and STATIC_INLINE for debug and nondebug from the
> > patch (whitespace damaged):
.....
> > Is this acceptible to everyone?
> Yup.
> 
> > 
> > FWIW, there is one other thing that this conversion causes
> > problems with, and that's variable definitions. i.e. we can't
> > use STATIC on them any more because of the "noinline" attribute
> > it has. Do we care about this and if so, any suggestions on
> > how to keep this functionality (a different STATIC_xxx define
> > for structures)?
> So I know things like systemtap kgdb oprofile all work better when
> functions are not static, but what about variables/structures?
> do things really get that confused?
> Maybe we shouldn't worry about conditioning them and just make them
> static

Ok, so I'd already converted them to static where necessary.
Attached is thecomplete patch. On ia64, the size of the xfs.ko
and xfs_quota.ko modules decreases with this patch:

Orig:

-rw-rw-r-- 1 dgc ptg  1662416 2006-11-22 14:41 fs/xfs/quota/xfs_quota.ko
-rw-rw-r-- 1 dgc ptg   856748 2006-11-22 14:41 fs/xfs/xfsidbg.ko
-rw-rw-r-- 1 dgc ptg 13614719 2006-11-22 14:41 fs/xfs/xfs.ko

With patch:

-rw-rw-r-- 1 dgc ptg  1657814 2006-11-22 14:42 fs/xfs/quota/xfs_quota.ko
-rw-rw-r-- 1 dgc ptg   856748 2006-11-22 14:42 fs/xfs/xfsidbg.ko
-rw-rw-r-- 1 dgc ptg 13557579 2006-11-22 14:42 fs/xfs/xfs.ko

The original top 10 stack users:

0x000e10c6 xfs_vn_mknod [xfs]:                          576
0x000ddfe6 xfs_ioctl [xfs]:                             368
0x000e1f46 xfs_vn_symlink [xfs]:                        368
0x000345a6 xfs_bmapi [xfs]:                             320
0x000b1146 _xfs_trans_commit [xfs]:                     272
0x000c59c6 xfs_change_file_space [xfs]:                 272
0x0003a6a6 xfs_bunmapi [xfs]:                           240
0x000afa06 xfs_trans_unreserve_and_mod_sb [xfs]:        224
0x00040626 xfs_bmbt_insert [xfs]:                       192
0x0008be26 xfs_iomap_write_delay [xfs]:                 192

[64 functions with stack usage larger than 100 bytes]

With patch:

0x000b7c46 _xfs_trans_commit [xfs]:                     272
0x000b5426 xfs_trans_unreserve_and_mod_sb [xfs]:        224
0x000e4106 xfs_find_handle [xfs]:                       224
0x000396c6 xfs_bmapi [xfs]:                             208
0x00090066 xfs_iomap_write_delay [xfs]:                 208
0x000e9046 xfs_cleanup_inode [xfs]:                     208
0x000058c6 xfs_acl_setmode [xfs]:                       160
0x00005f46 xfs_acl_allow_set [xfs]:                     160
0x000067c6 xfs_acl_vtoacl [xfs]:                        160
0x00007366 xfs_acl_vget [xfs]:                          160

[69 functions with stack usage larger than 100 bytes]

Performance appears to be slight faster with the noinline
patch, but the variation is within the error margins of
my measurements so I'd say it's neutral.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/dmapi/xfs_dm.c         |    6 +++---
 fs/xfs/linux-2.4/mrlock.c     |    2 +-
 fs/xfs/linux-2.4/xfs_buf.c    |   30 +++++++++++++++---------------
 fs/xfs/linux-2.4/xfs_file.c   |    8 ++++----
 fs/xfs/linux-2.4/xfs_super.c  |   14 +++++++-------
 fs/xfs/linux-2.4/xfs_vnode.h  |    4 ++--
 fs/xfs/linux-2.6/xfs_aops.c   |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c    |   24 ++++++++++++------------
 fs/xfs/linux-2.6/xfs_export.c |    2 +-
 fs/xfs/linux-2.6/xfs_file.c   |    4 ++--
 fs/xfs/linux-2.6/xfs_iops.c   |    4 ++--
 fs/xfs/linux-2.6/xfs_super.c  |   16 ++++++++--------
 fs/xfs/linux-2.6/xfs_sysctl.c |    6 +++---
 fs/xfs/linux-2.6/xfs_vfs.c    |    5 +++--
 fs/xfs/linux-2.6/xfs_vnode.c  |    2 +-
 fs/xfs/linux-2.6/xfs_vnode.h  |    4 ++--
 fs/xfs/quota/xfs_dquot_item.c |    6 +++---
 fs/xfs/quota/xfs_qm.c         |    6 +++---
 fs/xfs/quota/xfs_qm_bhv.c     |    2 +-
 fs/xfs/support/debug.h        |   30 +++++++++++++++++++++++++++---
 fs/xfs/xfs_attr.c             |   12 ++++++------
 fs/xfs/xfs_attr_leaf.c        |    6 +++---
 fs/xfs/xfs_bit.c              |    2 +-
 fs/xfs/xfs_bmap_btree.c       |    2 +-
 fs/xfs/xfs_buf_item.c         |    2 +-
 fs/xfs/xfs_extfree_item.c     |    4 ++--
 fs/xfs/xfs_ialloc.c           |    2 +-
 fs/xfs/xfs_inode.c            |    2 +-
 fs/xfs/xfs_inode_item.c       |    2 +-
 fs/xfs/xfs_mount.c            |    8 ++++----
 fs/xfs/xfs_refcache.c         |   10 +++++-----
 31 files changed, 127 insertions(+), 102 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_file.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_file.c	2006-11-22 14:41:06.076805511 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_file.c	2006-11-22 14:42:21.558973682 +1100
@@ -55,7 +55,7 @@ static struct vm_operations_struct xfs_d
 #define do_up_read(x)
 #endif
 
-STATIC inline ssize_t
+STATIC_INLINE ssize_t
 __xfs_file_read(
 	struct file	*file,
 	char		*buf,
@@ -99,7 +99,7 @@ xfs_file_read_invis(
 }
 
 
-STATIC inline ssize_t
+STATIC_INLINE ssize_t
 __xfs_file_write(
 	struct file	*file,
 	const char	*buf,
@@ -146,7 +146,7 @@ __xfs_file_write(
 	return rval;
 }
 
-STATIC inline ssize_t
+STATIC_INLINE ssize_t
 xfs_file_write(
 	struct file	*file,
 	const char	*buf,
@@ -156,7 +156,7 @@ xfs_file_write(
 	return __xfs_file_write(file, buf, 0, count, ppos);
 }
 
-STATIC inline ssize_t
+STATIC_INLINE ssize_t
 xfs_file_write_invis(
 	struct file	*file,
 	const char	*buf,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2006-11-22 14:42:21.558973682 +1100
@@ -246,7 +246,7 @@ xfs_map_blocks(
 	return -error;
 }
 
-STATIC inline int
+STATIC_INLINE int
 xfs_iomap_valid(
 	xfs_iomap_t		*iomapp,
 	loff_t			offset)
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2006-11-22 14:42:21.562973161 +1100
@@ -34,13 +34,13 @@
 #include <linux/backing-dev.h>
 #include "xfs_linux.h"
 
-STATIC kmem_zone_t *xfs_buf_zone;
-STATIC kmem_shaker_t xfs_buf_shake;
+static kmem_zone_t *xfs_buf_zone;
+static kmem_shaker_t xfs_buf_shake;
 STATIC int xfsbufd(void *);
 STATIC int xfsbufd_wakeup(int, gfp_t);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
 
-STATIC struct workqueue_struct *xfslogd_workqueue;
+static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
 
 #ifdef XFS_BUF_TRACE
@@ -139,7 +139,7 @@ page_region_mask(
 	return mask;
 }
 
-STATIC inline void
+STATIC_INLINE void
 set_page_region(
 	struct page	*page,
 	size_t		offset,
@@ -151,7 +151,7 @@ set_page_region(
 		SetPageUptodate(page);
 }
 
-STATIC inline int
+STATIC_INLINE int
 test_page_region(
 	struct page	*page,
 	size_t		offset,
@@ -171,9 +171,9 @@ typedef struct a_list {
 	struct a_list	*next;
 } a_list_t;
 
-STATIC a_list_t		*as_free_head;
-STATIC int		as_list_len;
-STATIC DEFINE_SPINLOCK(as_lock);
+static a_list_t		*as_free_head;
+static int		as_list_len;
+static DEFINE_SPINLOCK(as_lock);
 
 /*
  *	Try to batch vunmaps because they are costly.
@@ -1084,7 +1084,7 @@ xfs_buf_iostart(
 	return status;
 }
 
-STATIC __inline__ int
+STATIC_INLINE int
 _xfs_buf_iolocked(
 	xfs_buf_t		*bp)
 {
@@ -1094,7 +1094,7 @@ _xfs_buf_iolocked(
 	return 0;
 }
 
-STATIC __inline__ void
+STATIC_INLINE void
 _xfs_buf_ioend(
 	xfs_buf_t		*bp,
 	int			schedule)
@@ -1425,8 +1425,8 @@ xfs_free_bufhash(
 /*
  *	buftarg list for delwrite queue processing
  */
-STATIC LIST_HEAD(xfs_buftarg_list);
-STATIC DEFINE_SPINLOCK(xfs_buftarg_lock);
+LIST_HEAD(xfs_buftarg_list);
+static DEFINE_SPINLOCK(xfs_buftarg_lock);
 
 STATIC void
 xfs_register_buftarg(
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_file.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c	2006-11-22 14:42:21.562973161 +1100
@@ -46,7 +46,7 @@ static struct vm_operations_struct xfs_f
 static struct vm_operations_struct xfs_dmapi_file_vm_ops;
 #endif
 
-STATIC inline ssize_t
+STATIC_INLINE ssize_t
 __xfs_file_read(
 	struct kiocb		*iocb,
 	const struct iovec	*iov,
@@ -84,7 +84,7 @@ xfs_file_aio_read_invis(
 	return __xfs_file_read(iocb, iov, nr_segs, IO_ISAIO|IO_INVIS, pos);
 }
 
-STATIC inline ssize_t
+STATIC_INLINE ssize_t
 __xfs_file_write(
 	struct kiocb		*iocb,
 	const struct iovec	*iov,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2006-11-22 14:42:21.562973161 +1100
@@ -250,13 +250,13 @@ xfs_init_security(
  *
  * XXX(hch):  nfsd is broken, better fix it instead.
  */
-STATIC inline int
+STATIC_INLINE int
 xfs_has_fs_struct(struct task_struct *task)
 {
 	return (task->fs != init_task.fs);
 }
 
-STATIC inline void
+STATIC void
 xfs_cleanup_inode(
 	bhv_vnode_t	*dvp,
 	bhv_vnode_t	*vp,
Index: 2.6.x-xfs-new/fs/xfs/support/debug.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/support/debug.h	2006-11-22 14:41:06.144796655 +1100
+++ 2.6.x-xfs-new/fs/xfs/support/debug.h	2006-11-22 14:42:21.566972640 +1100
@@ -38,13 +38,37 @@ extern void assfail(char *expr, char *f,
 
 #ifndef DEBUG
 # define ASSERT(expr)	((void)0)
-#else
+
+#ifndef STATIC
+# define STATIC static noinline
+#endif
+
+#ifndef STATIC_INLINE
+# define STATIC_INLINE static inline
+#endif
+
+#else /* DEBUG */
+
 # define ASSERT(expr)	ASSERT_ALWAYS(expr)
 extern unsigned long random(void);
-#endif
 
 #ifndef STATIC
-# define STATIC static
+# define STATIC noinline
+#endif
+
+/*
+ * We stop inlining of inline functions in debug mode.
+ * Unfortunately, this means static inline in header files
+ * get multiple definitions, so they need to remain static.
+ * This then gives tonnes of warnings about unused but defined
+ * functions, so we need to add the unused attribute to prevent
+ * these spurious warnings.
+ */
+#ifndef STATIC_INLINE
+# define STATIC_INLINE static __attribute__ ((unused)) noinline
 #endif
 
+#endif /* DEBUG */
+
+
 #endif  /* __XFS_SUPPORT_DEBUG_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfs_attr_leaf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_attr_leaf.c	2006-11-22 14:41:06.180791966 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_attr_leaf.c	2006-11-22 14:42:21.566972640 +1100
@@ -94,7 +94,7 @@ STATIC int xfs_attr_leaf_entsize(xfs_att
  * Namespace helper routines
  *========================================================================*/
 
-STATIC inline attrnames_t *
+STATIC_INLINE attrnames_t *
 xfs_attr_flags_namesp(int flags)
 {
 	return ((flags & XFS_ATTR_SECURE) ? &attr_secure:
@@ -105,7 +105,7 @@ xfs_attr_flags_namesp(int flags)
  * If namespace bits don't match return 0.
  * If all match then return 1.
  */
-STATIC inline int
+STATIC_INLINE int
 xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
 {
 	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
@@ -116,7 +116,7 @@ xfs_attr_namesp_match(int arg_flags, int
  * then return 0.
  * If all match or are overridable then return 1.
  */
-STATIC inline int
+STATIC_INLINE int
 xfs_attr_namesp_match_overrides(int arg_flags, int ondisk_flags)
 {
 	if (((arg_flags & ATTR_SECURE) == 0) !=
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-11-22 14:41:06.180791966 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-11-22 14:42:21.566972640 +1100
@@ -1796,7 +1796,7 @@ xfs_icsb_destroy_counters(
 	}
 }
 
-STATIC inline void
+STATIC_INLINE void
 xfs_icsb_lock_cntr(
 	xfs_icsb_cnts_t	*icsbp)
 {
@@ -1805,7 +1805,7 @@ xfs_icsb_lock_cntr(
 	}
 }
 
-STATIC inline void
+STATIC_INLINE void
 xfs_icsb_unlock_cntr(
 	xfs_icsb_cnts_t	*icsbp)
 {
@@ -1813,7 +1813,7 @@ xfs_icsb_unlock_cntr(
 }
 
 
-STATIC inline void
+STATIC_INLINE void
 xfs_icsb_lock_all_counters(
 	xfs_mount_t	*mp)
 {
@@ -1826,7 +1826,7 @@ xfs_icsb_lock_all_counters(
 	}
 }
 
-STATIC inline void
+STATIC_INLINE void
 xfs_icsb_unlock_all_counters(
 	xfs_mount_t	*mp)
 {
Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_buf.c	2006-11-22 14:41:06.076805511 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_buf.c	2006-11-22 14:42:21.578971077 +1100
@@ -67,17 +67,17 @@
 #define VM_MAP	VM_ALLOC
 #endif
 
-STATIC kmem_zone_t *xfs_buf_zone;
-STATIC kmem_shaker_t xfs_buf_shake;
+static kmem_zone_t *xfs_buf_zone;
+static kmem_shaker_t xfs_buf_shake;
 
 #define MAX_IO_DAEMONS		NR_CPUS
 #define CPU_TO_DAEMON(cpu)	(cpu)
-STATIC int xb_logio_daemons[MAX_IO_DAEMONS];
-STATIC struct list_head xfs_buf_logiodone_tq[MAX_IO_DAEMONS];
-STATIC wait_queue_head_t xfs_buf_logiodone_wait[MAX_IO_DAEMONS];
-STATIC int xb_dataio_daemons[MAX_IO_DAEMONS];
-STATIC struct list_head xfs_buf_dataiodone_tq[MAX_IO_DAEMONS];
-STATIC wait_queue_head_t xfs_buf_dataiodone_wait[MAX_IO_DAEMONS];
+static int xb_logio_daemons[MAX_IO_DAEMONS];
+static struct list_head xfs_buf_logiodone_tq[MAX_IO_DAEMONS];
+static wait_queue_head_t xfs_buf_logiodone_wait[MAX_IO_DAEMONS];
+static int xb_dataio_daemons[MAX_IO_DAEMONS];
+static struct list_head xfs_buf_dataiodone_tq[MAX_IO_DAEMONS];
+static wait_queue_head_t xfs_buf_dataiodone_wait[MAX_IO_DAEMONS];
 
 /*
  * For pre-allocated buffer head pool
@@ -154,9 +154,9 @@ typedef struct a_list {
 	struct a_list	*next;
 } a_list_t;
 
-STATIC a_list_t		*as_free_head;
-STATIC int		as_list_len;
-STATIC DEFINE_SPINLOCK(as_lock);
+static a_list_t		*as_free_head;
+static int		as_list_len;
+static DEFINE_SPINLOCK(as_lock);
 
 /*
  *	Try to batch vunmaps because they are costly.
@@ -515,7 +515,7 @@ _xfs_buf_get_prealloc_bh(void)
  *	Otherwise, put it back in the pool, and wake up anybody
  *	waiting for one.
  */
-STATIC inline void
+STATIC_INLINE void
 _xfs_buf_free_bh(
 	struct buffer_head	*bh)
 {
@@ -1204,7 +1204,7 @@ xfs_buf_iostart(
 	return status;
 }
 
-STATIC __inline__ int
+STATIC_INLINE int
 _xfs_buf_iolocked(
 	xfs_buf_t		*bp)
 {
@@ -1366,8 +1366,8 @@ xfs_free_bufhash(
 /*
  *	buftarg list for delwrite queue processing
  */
-STATIC LIST_HEAD(xfs_buftarg_list);
-STATIC DEFINE_SPINLOCK(xfs_buftarg_lock);
+static LIST_HEAD(xfs_buftarg_list);
+static DEFINE_SPINLOCK(xfs_buftarg_lock);
 
 STATIC void
 xfs_register_buftarg(
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_sysctl.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_sysctl.c	2006-11-22 14:42:21.594968993 +1100
@@ -54,7 +54,7 @@ xfs_stats_clear_proc_handler(
 }
 #endif /* CONFIG_PROC_FS */
 
-STATIC ctl_table xfs_table[] = {
+static ctl_table xfs_table[] = {
 	{XFS_RESTRICT_CHOWN, "restrict_chown", &xfs_params.restrict_chown.val,
 	sizeof(int), 0644, NULL, &proc_dointvec_minmax,
 	&sysctl_intvec, NULL,
@@ -151,12 +151,12 @@ STATIC ctl_table xfs_table[] = {
 	{0}
 };
 
-STATIC ctl_table xfs_dir_table[] = {
+static ctl_table xfs_dir_table[] = {
 	{FS_XFS, "xfs", NULL, 0, 0555, xfs_table},
 	{0}
 };
 
-STATIC ctl_table xfs_root_table[] = {
+static ctl_table xfs_root_table[] = {
 	{CTL_FS, "fs",  NULL, 0, 0555, xfs_dir_table},
 	{0}
 };
Index: 2.6.x-xfs-new/fs/xfs/xfs_attr.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_attr.c	2006-11-22 14:41:06.188790924 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_attr.c	2006-11-22 14:42:21.598968473 +1100
@@ -57,9 +57,9 @@
  */
 
 #define ATTR_SYSCOUNT	2
-STATIC struct attrnames posix_acl_access;
-STATIC struct attrnames posix_acl_default;
-STATIC struct attrnames *attr_system_names[ATTR_SYSCOUNT];
+static struct attrnames posix_acl_access;
+static struct attrnames posix_acl_default;
+static struct attrnames *attr_system_names[ATTR_SYSCOUNT];
 
 /*========================================================================
  * Function prototypes for the kernel.
@@ -2477,7 +2477,7 @@ posix_acl_default_exists(
 	return xfs_acl_vhasacl_default(vp);
 }
 
-STATIC struct attrnames posix_acl_access = {
+static struct attrnames posix_acl_access = {
 	.attr_name	= "posix_acl_access",
 	.attr_namelen	= sizeof("posix_acl_access") - 1,
 	.attr_get	= posix_acl_access_get,
@@ -2486,7 +2486,7 @@ STATIC struct attrnames posix_acl_access
 	.attr_exists	= posix_acl_access_exists,
 };
 
-STATIC struct attrnames posix_acl_default = {
+static struct attrnames posix_acl_default = {
 	.attr_name	= "posix_acl_default",
 	.attr_namelen	= sizeof("posix_acl_default") - 1,
 	.attr_get	= posix_acl_default_get,
@@ -2495,7 +2495,7 @@ STATIC struct attrnames posix_acl_defaul
 	.attr_exists	= posix_acl_default_exists,
 };
 
-STATIC struct attrnames *attr_system_names[] =
+static struct attrnames *attr_system_names[] =
 	{ &posix_acl_access, &posix_acl_default };
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.c	2006-11-22 14:41:06.196789882 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_bit.c	2006-11-22 14:42:21.598968473 +1100
@@ -29,7 +29,7 @@
 /*
  * Index of high bit number in byte, -1 for none set, 0..7 otherwise.
  */
-STATIC const char xfs_highbit[256] = {
+static const char xfs_highbit[256] = {
        -1, 0, 1, 1, 2, 2, 2, 2,			/* 00 .. 07 */
 	3, 3, 3, 3, 3, 3, 3, 3,			/* 08 .. 0f */
 	4, 4, 4, 4, 4, 4, 4, 4,			/* 10 .. 17 */
Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/mrlock.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/mrlock.c	2006-11-22 14:41:06.076805511 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.4/mrlock.c	2006-11-22 14:42:21.598968473 +1100
@@ -195,7 +195,7 @@ mrtryupdate(mrlock_t *mrp)
 	return 1;
 }
 
-static __inline__ void mrwake(mrlock_t *mrp)
+STATIC_INLINE void mrwake(mrlock_t *mrp)
 {
 	/*
 	 * First, if the count is now 0, we need to wake-up anyone waiting.
Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_super.c	2006-11-22 14:41:06.076805511 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_super.c	2006-11-22 14:42:21.598968473 +1100
@@ -54,9 +54,9 @@
 
 #include <linux/init.h>
 
-STATIC struct quotactl_ops xfs_quotactl_operations;
-STATIC struct super_operations xfs_super_operations;
-STATIC kmem_zone_t *xfs_vnode_zone;
+static struct quotactl_ops xfs_quotactl_operations;
+static struct super_operations xfs_super_operations;
+static kmem_zone_t *xfs_vnode_zone;
 
 STATIC struct xfs_mount_args *
 xfs_args_allocate(
@@ -113,7 +113,7 @@ xfs_max_file_offset(
 	return (((__uint64_t)pagefactor) << bitshift) - 1;
 }
 
-STATIC __inline__ void
+STATIC_INLINE void
 xfs_set_inodeops(
 	struct inode		*inode)
 {
@@ -140,7 +140,7 @@ xfs_set_inodeops(
 	}
 }
 
-STATIC __inline__ void
+STATIC_INLINE void
 xfs_revalidate_inode(
 	xfs_mount_t		*mp,
 	bhv_vnode_t		*vp,
@@ -974,7 +974,7 @@ fail_vfsop:
 }
 
 
-STATIC struct super_operations xfs_super_operations = {
+static struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
 	.write_inode		= xfs_fs_write_inode,
@@ -991,7 +991,7 @@ STATIC struct super_operations xfs_super
 	.show_options		= xfs_fs_show_options,
 };
 
-STATIC struct quotactl_ops xfs_quotactl_operations = {
+static struct quotactl_ops xfs_quotactl_operations = {
 	.quota_sync		= xfs_fs_quotasync,
 	.get_xstate		= xfs_fs_getxstate,
 	.set_xstate		= xfs_fs_setxstate,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_vnode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.4/xfs_vnode.h	2006-11-22 14:41:06.092803428 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.4/xfs_vnode.h	2006-11-22 14:42:21.598968473 +1100
@@ -468,14 +468,14 @@ static inline struct bhv_vnode *vn_grab(
 #define VN_LOCK(vp)		mutex_spinlock(&(vp)->v_lock)
 #define VN_UNLOCK(vp, s)	mutex_spinunlock(&(vp)->v_lock, s)
 
-static __inline__ void vn_flagset(struct bhv_vnode *vp, uint flag)
+STATIC_INLINE void vn_flagset(struct bhv_vnode *vp, uint flag)
 {
 	spin_lock(&vp->v_lock);
 	vp->v_flag |= flag;
 	spin_unlock(&vp->v_lock);
 }
 
-static __inline__ uint vn_flagclr(struct bhv_vnode *vp, uint flag)
+STATIC_INLINE uint vn_flagclr(struct bhv_vnode *vp, uint flag)
 {
 	uint	cleared;
 
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2006-11-22 14:42:21.602967952 +1100
@@ -57,10 +57,10 @@
 #include <linux/writeback.h>
 #include <linux/kthread.h>
 
-STATIC struct quotactl_ops xfs_quotactl_operations;
-STATIC struct super_operations xfs_super_operations;
-STATIC kmem_zone_t *xfs_vnode_zone;
-STATIC kmem_zone_t *xfs_ioend_zone;
+static struct quotactl_ops xfs_quotactl_operations;
+static struct super_operations xfs_super_operations;
+static kmem_zone_t *xfs_vnode_zone;
+static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
 STATIC struct xfs_mount_args *
@@ -120,7 +120,7 @@ xfs_max_file_offset(
 	return (((__uint64_t)pagefactor) << bitshift) - 1;
 }
 
-STATIC __inline__ void
+STATIC_INLINE void
 xfs_set_inodeops(
 	struct inode		*inode)
 {
@@ -146,7 +146,7 @@ xfs_set_inodeops(
 	}
 }
 
-STATIC __inline__ void
+STATIC_INLINE void
 xfs_revalidate_inode(
 	xfs_mount_t		*mp,
 	bhv_vnode_t		*vp,
@@ -881,7 +881,7 @@ xfs_fs_get_sb(
 			   mnt);
 }
 
-STATIC struct super_operations xfs_super_operations = {
+static struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
 	.write_inode		= xfs_fs_write_inode,
@@ -895,7 +895,7 @@ STATIC struct super_operations xfs_super
 	.show_options		= xfs_fs_show_options,
 };
 
-STATIC struct quotactl_ops xfs_quotactl_operations = {
+static struct quotactl_ops xfs_quotactl_operations = {
 	.quota_sync		= xfs_fs_quotasync,
 	.get_xstate		= xfs_fs_getxstate,
 	.set_xstate		= xfs_fs_setxstate,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vnode.h	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h	2006-11-22 14:42:21.602967952 +1100
@@ -492,14 +492,14 @@ static inline struct bhv_vnode *vn_grab(
 #define VN_LOCK(vp)		mutex_spinlock(&(vp)->v_lock)
 #define VN_UNLOCK(vp, s)	mutex_spinunlock(&(vp)->v_lock, s)
 
-static __inline__ void vn_flagset(struct bhv_vnode *vp, uint flag)
+STATIC_INLINE void vn_flagset(struct bhv_vnode *vp, uint flag)
 {
 	spin_lock(&vp->v_lock);
 	vp->v_flag |= flag;
 	spin_unlock(&vp->v_lock);
 }
 
-static __inline__ uint vn_flagclr(struct bhv_vnode *vp, uint flag)
+STATIC_INLINE uint vn_flagclr(struct bhv_vnode *vp, uint flag)
 {
 	uint	cleared;
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap_btree.c	2006-11-22 14:41:06.204788840 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c	2006-11-22 14:42:21.602967952 +1100
@@ -1862,7 +1862,7 @@ xfs_bmbt_delete(
  * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
  */
 
-STATIC __inline__ void
+STATIC_INLINE void
 __xfs_bmbt_get_all(
 		__uint64_t l0,
 		__uint64_t l1,
Index: 2.6.x-xfs-new/fs/xfs/xfs_extfree_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_extfree_item.c	2006-11-22 14:41:06.204788840 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_extfree_item.c	2006-11-22 14:42:21.606967431 +1100
@@ -227,7 +227,7 @@ xfs_efi_item_committing(xfs_efi_log_item
 /*
  * This is the ops vector shared by all efi log items.
  */
-STATIC struct xfs_item_ops xfs_efi_item_ops = {
+static struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_efi_item_size,
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_efi_item_format,
@@ -525,7 +525,7 @@ xfs_efd_item_committing(xfs_efd_log_item
 /*
  * This is the ops vector shared by all efd log items.
  */
-STATIC struct xfs_item_ops xfs_efd_item_ops = {
+static struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_efd_item_size,
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_efd_item_format,
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-11-22 14:41:06.204788840 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-11-22 14:42:21.614966389 +1100
@@ -2125,7 +2125,7 @@ xfs_iunlink_remove(
 	return 0;
 }
 
-static __inline__ int xfs_inode_clean(xfs_inode_t *ip)
+STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
 {
 	return (((ip->i_itemp == NULL) ||
 		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
Index: 2.6.x-xfs-new/fs/xfs/xfs_buf_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_buf_item.c	2006-11-22 14:41:06.204788840 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_buf_item.c	2006-11-22 14:42:21.618965868 +1100
@@ -660,7 +660,7 @@ xfs_buf_item_committing(xfs_buf_log_item
 /*
  * This is the ops vector shared by all buf log items.
  */
-STATIC struct xfs_item_ops xfs_buf_item_ops = {
+static struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_buf_item_size,
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_buf_item_format,
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2006-11-22 14:41:06.204788840 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2006-11-22 14:42:21.618965868 +1100
@@ -342,7 +342,7 @@ xfs_ialloc_ag_alloc(
 	return 0;
 }
 
-STATIC __inline xfs_agnumber_t
+STATIC_INLINE xfs_agnumber_t
 xfs_ialloc_next_ag(
 	xfs_mount_t	*mp)
 {
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode_item.c	2006-11-22 14:41:06.204788840 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode_item.c	2006-11-22 14:42:21.618965868 +1100
@@ -887,7 +887,7 @@ xfs_inode_item_committing(
 /*
  * This is the ops vector shared by all buf log items.
  */
-STATIC struct xfs_item_ops xfs_inode_item_ops = {
+static struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_inode_item_size,
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_inode_item_format,
Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2006-11-22 14:41:06.268780504 +1100
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2006-11-22 14:42:21.622965347 +1100
@@ -133,9 +133,9 @@ typedef struct {
    changed!
 */
 
-STATIC	const	char	dmattr_prefix[DMATTR_PREFIXLEN + 1] = DMATTR_PREFIXSTRING;
+static	const	char	dmattr_prefix[DMATTR_PREFIXLEN + 1] = DMATTR_PREFIXSTRING;
 
-STATIC	dm_size_t  dm_min_dio_xfer = 0; /* direct I/O disabled for now */
+static	dm_size_t  dm_min_dio_xfer = 0; /* direct I/O disabled for now */
 
 
 /* See xfs_dm_get_dmattr() for a description of why this is needed. */
@@ -3124,7 +3124,7 @@ xfs_dm_obj_ref_hold(
 }
 
 
-STATIC fsys_function_vector_t	xfs_fsys_vector[DM_FSYS_MAX];
+static fsys_function_vector_t	xfs_fsys_vector[DM_FSYS_MAX];
 
 
 int
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_export.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_export.c	2006-11-22 14:42:21.622965347 +1100
@@ -24,7 +24,7 @@
 #include "xfs_mount.h"
 #include "xfs_export.h"
 
-STATIC struct dentry dotdot = { .d_name.name = "..", .d_name.len = 2, };
+static struct dentry dotdot = { .d_name.name = "..", .d_name.len = 2, };
 
 /*
  * XFS encodes and decodes the fileid portion of NFS filehandles
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.c	2006-11-22 14:41:06.112800823 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.c	2006-11-22 14:42:21.622965347 +1100
@@ -295,8 +295,9 @@ typedef struct bhv_module_list {
 	const char *		bm_name;
 	void *			bm_ops;
 } bhv_module_list_t;
-STATIC DEFINE_SPINLOCK(bhv_lock);
-STATIC struct list_head bhv_list = LIST_HEAD_INIT(bhv_list);
+
+static DEFINE_SPINLOCK(bhv_lock);
+static struct list_head bhv_list = LIST_HEAD_INIT(bhv_list);
 
 void
 bhv_module_init(
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_dquot_item.c	2006-11-22 14:41:06.300776336 +1100
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_dquot_item.c	2006-11-22 14:42:21.626964826 +1100
@@ -399,7 +399,7 @@ xfs_qm_dquot_logitem_committing(
 /*
  * This is the ops vector for dquots
  */
-STATIC struct xfs_item_ops xfs_dquot_item_ops = {
+static struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_qm_dquot_logitem_size,
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_dquot_logitem_format,
@@ -606,7 +606,7 @@ xfs_qm_qoffend_logitem_committing(xfs_qo
 	return;
 }
 
-STATIC struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
+static struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_size,
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_qoff_logitem_format,
@@ -628,7 +628,7 @@ STATIC struct xfs_item_ops xfs_qm_qoffen
 /*
  * This is the ops vector shared by all quotaoff-start log items.
  */
-STATIC struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
+static struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= (uint(*)(xfs_log_item_t*))xfs_qm_qoff_logitem_size,
 	.iop_format	= (void(*)(xfs_log_item_t*, xfs_log_iovec_t*))
 					xfs_qm_qoff_logitem_format,
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm.c	2006-11-22 14:41:06.316774252 +1100
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm.c	2006-11-22 14:42:21.626964826 +1100
@@ -64,10 +64,10 @@ uint		ndquot;
 
 kmem_zone_t	*qm_dqzone;
 kmem_zone_t	*qm_dqtrxzone;
-STATIC kmem_shaker_t	xfs_qm_shaker;
+static kmem_shaker_t	xfs_qm_shaker;
 
-STATIC cred_t	xfs_zerocr;
-STATIC xfs_inode_t	xfs_zeroino;
+static cred_t	xfs_zerocr;
+static xfs_inode_t	xfs_zeroino;
 
 STATIC void	xfs_qm_list_init(xfs_dqlist_t *, char *, int);
 STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
Index: 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/quota/xfs_qm_bhv.c	2006-11-22 14:41:06.316774252 +1100
+++ 2.6.x-xfs-new/fs/xfs/quota/xfs_qm_bhv.c	2006-11-22 14:42:21.630964305 +1100
@@ -384,7 +384,7 @@ xfs_qm_dqrele_null(
 }
 
 
-STATIC struct xfs_qmops xfs_qmcore_xfs = {
+static struct xfs_qmops xfs_qmcore_xfs = {
 	.xfs_qminit		= xfs_qm_newmount,
 	.xfs_qmdone		= xfs_qm_unmount_quotadestroy,
 	.xfs_qmmount		= xfs_qm_endmount,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vnode.c	2006-11-22 14:41:06.120799781 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.c	2006-11-22 14:42:21.630964305 +1100
@@ -26,7 +26,7 @@ DEFINE_SPINLOCK(vnumber_lock);
  */
 #define NVSYNC                  37
 #define vptosync(v)             (&vsync[((unsigned long)v) % NVSYNC])
-STATIC wait_queue_head_t vsync[NVSYNC];
+static wait_queue_head_t vsync[NVSYNC];
 
 void
 vn_init(void)
Index: 2.6.x-xfs-new/fs/xfs/xfs_refcache.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_refcache.c	2006-11-22 14:41:06.324773210 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_refcache.c	2006-11-22 14:42:21.630964305 +1100
@@ -45,11 +45,11 @@
 #include "xfs_buf_item.h"
 #include "xfs_refcache.h"
 
-STATIC spinlock_t	xfs_refcache_lock = SPIN_LOCK_UNLOCKED;
-STATIC xfs_inode_t	**xfs_refcache;
-STATIC int		xfs_refcache_index;
-STATIC int		xfs_refcache_busy;
-STATIC int		xfs_refcache_count;
+static spinlock_t	xfs_refcache_lock = SPIN_LOCK_UNLOCKED;
+static xfs_inode_t	**xfs_refcache;
+static int		xfs_refcache_index;
+static int		xfs_refcache_busy;
+static int		xfs_refcache_count;
 
 /*
  * Insert the given inode into the reference cache.
