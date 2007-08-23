Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:38:41 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJca4p003408
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:38:37 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJcYA5008558
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:38:34 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJcYva008556
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:38:34 +0200
Date: Thu, 23 Aug 2007 21:38:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/17] move v_trace from bhv_vnode to xfs_inode
Message-ID: <20070823193834.GG8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

struct bhv_vnode is on it's way out, so move the trace buffer to the
XFS inode.  Note that this makes the tracing macros rather misnamed,
but this kind of fallout will be fixed up incrementally later on.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:53:52.000000000 +0200
@@ -1525,7 +1525,7 @@ xfs_vm_bmap(
 	struct inode		*inode = (struct inode *)mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 
-	vn_trace_entry(vn_from_inode(inode), __FUNCTION__,
+	vn_trace_entry(XFS_I(inode), __FUNCTION__,
 			(inst_t *)__return_address);
 	xfs_rwlock(ip, VRWLOCK_READ);
 	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 14:53:52.000000000 +0200
@@ -733,7 +733,7 @@ xfs_ioctl(
 	xfs_mount_t		*mp = ip->i_mount;
 	int			error;
 
-	vn_trace_entry(vp, "xfs_ioctl", (inst_t *)__return_address);
+	vn_trace_entry(XFS_I(inode), "xfs_ioctl", (inst_t *)__return_address);
 
 	switch (cmd) {
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:51:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:53:52.000000000 +0200
@@ -412,7 +412,7 @@ xfs_fs_write_inode(
 {
 	int			error = 0, flags = FLUSH_INODE;
 
-	vn_trace_entry(vn_from_inode(inode), __FUNCTION__,
+	vn_trace_entry(XFS_I(inode), __FUNCTION__,
 			(inst_t *)__return_address);
 	if (sync)
 		flags |= FLUSH_SYNC;
@@ -432,34 +432,27 @@ STATIC void
 xfs_fs_clear_inode(
 	struct inode		*inode)
 {
-	bhv_vnode_t		*vp = vn_from_inode(inode);
-
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
-
-	XFS_STATS_INC(vn_rele);
-	XFS_STATS_INC(vn_remove);
-	XFS_STATS_INC(vn_reclaim);
-	XFS_STATS_DEC(vn_active);
+	xfs_inode_t		*ip = XFS_I(inode);
 
 	/*
-	 * This can happen because xfs_iget_core calls xfs_idestroy if we
+	 * ip can be null when xfs_iget_core calls xfs_idestroy if we
 	 * find an inode with di_mode == 0 but without IGET_CREATE set.
 	 */
-	if (XFS_I(inode))
-		xfs_inactive(XFS_I(inode));
-
+	if (ip) {
+		vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
-	if (XFS_I(inode)) {
-		xfs_iflags_clear(XFS_I(inode), XFS_IMODIFIED);
-		if (xfs_reclaim(XFS_I(inode)))
-			panic("%s: cannot reclaim 0x%p\n", __FUNCTION__, vp);
+		XFS_STATS_INC(vn_rele);
+		XFS_STATS_INC(vn_remove);
+		XFS_STATS_INC(vn_reclaim);
+		XFS_STATS_DEC(vn_active);
+
+		xfs_inactive(ip);
+		xfs_iflags_clear(ip, XFS_IMODIFIED);
+		if (xfs_reclaim(ip))
+			panic("%s: cannot reclaim 0x%p\n", __FUNCTION__, inode);
 	}
 
 	ASSERT(XFS_I(inode) == NULL);
-
-#ifdef XFS_VNODE_TRACE
-	ktrace_free(vp->v_trace);
-#endif
 }
 
 /*
@@ -846,7 +839,8 @@ xfs_fs_fill_super(
 	}
 	if ((error = xfs_fs_start_syncd(vfsp)))
 		goto fail_vnrele;
-	vn_trace_exit(rootvp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_exit(XFS_I(sb->s_root->d_inode), __FUNCTION__,
+			(inst_t *)__return_address);
 
 	kmem_free(args, sizeof(*args));
 	return 0;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 14:53:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 14:53:56.000000000 +0200
@@ -103,11 +103,6 @@ vn_initialize(
 
 	ASSERT(VN_CACHED(vp) == 0);
 
-#ifdef	XFS_VNODE_TRACE
-	vp->v_trace = ktrace_alloc(VNODE_TRACE_SIZE, KM_SLEEP);
-#endif	/* XFS_VNODE_TRACE */
-
-	vn_trace_exit(vp, __FUNCTION__, (inst_t *)__return_address);
 	return vp;
 }
 
@@ -158,7 +153,7 @@ __vn_revalidate(
 {
 	int		error;
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(xfs_vtoi(vp), __FUNCTION__, (inst_t *)__return_address);
 	vattr->va_mask = XFS_AT_STAT | XFS_AT_XFLAGS;
 	error = xfs_getattr(xfs_vtoi(vp), vattr, 0);
 	if (likely(!error)) {
@@ -197,11 +192,11 @@ vn_hold(
 #ifdef	XFS_VNODE_TRACE
 
 #define KTRACE_ENTER(vp, vk, s, line, ra)			\
-	ktrace_enter(	(vp)->v_trace,				\
+	ktrace_enter(	(ip)->i_trace,				\
 /*  0 */		(void *)(__psint_t)(vk),		\
 /*  1 */		(void *)(s),				\
 /*  2 */		(void *)(__psint_t) line,		\
-/*  3 */		(void *)(__psint_t)(vn_count(vp)),	\
+/*  3 */		NULL,					\
 /*  4 */		(void *)(ra),				\
 /*  5 */		NULL,					\
 /*  6 */		(void *)(__psint_t)current_cpu(),	\
@@ -213,32 +208,32 @@ vn_hold(
  * Vnode tracing code.
  */
 void
-vn_trace_entry(bhv_vnode_t *vp, const char *func, inst_t *ra)
+vn_trace_entry(xfs_inode_t *ip, const char *func, inst_t *ra)
 {
-	KTRACE_ENTER(vp, VNODE_KTRACE_ENTRY, func, 0, ra);
+	KTRACE_ENTER(ip, VNODE_KTRACE_ENTRY, func, 0, ra);
 }
 
 void
-vn_trace_exit(bhv_vnode_t *vp, const char *func, inst_t *ra)
+vn_trace_exit(xfs_inode_t *ip, const char *func, inst_t *ra)
 {
-	KTRACE_ENTER(vp, VNODE_KTRACE_EXIT, func, 0, ra);
+	KTRACE_ENTER(ip, VNODE_KTRACE_EXIT, func, 0, ra);
 }
 
 void
-vn_trace_hold(bhv_vnode_t *vp, char *file, int line, inst_t *ra)
+vn_trace_hold(xfs_inode_t *ip, char *file, int line, inst_t *ra)
 {
-	KTRACE_ENTER(vp, VNODE_KTRACE_HOLD, file, line, ra);
+	KTRACE_ENTER(ip, VNODE_KTRACE_HOLD, file, line, ra);
 }
 
 void
-vn_trace_ref(bhv_vnode_t *vp, char *file, int line, inst_t *ra)
+vn_trace_ref(xfs_inode_t *ip, char *file, int line, inst_t *ra)
 {
-	KTRACE_ENTER(vp, VNODE_KTRACE_REF, file, line, ra);
+	KTRACE_ENTER(ip, VNODE_KTRACE_REF, file, line, ra);
 }
 
 void
-vn_trace_rele(bhv_vnode_t *vp, char *file, int line, inst_t *ra)
+vn_trace_rele(xfs_inode_t *ip, char *file, int line, inst_t *ra)
 {
-	KTRACE_ENTER(vp, VNODE_KTRACE_RELE, file, line, ra);
+	KTRACE_ENTER(ip, VNODE_KTRACE_RELE, file, line, ra);
 }
 #endif	/* XFS_VNODE_TRACE */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:51:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:53:56.000000000 +0200
@@ -29,9 +29,6 @@ typedef __u64		bhv_vnumber_t;
 
 typedef struct bhv_vnode {
 	bhv_vnumber_t	v_number;		/* in-core vnode number */
-#ifdef XFS_VNODE_TRACE
-	struct ktrace	*v_trace;		/* trace header structure    */
-#endif
 	struct inode	v_inode;		/* Linux inode */
 	/* inode MUST be last */
 } bhv_vnode_t;
@@ -222,9 +219,9 @@ extern bhv_vnode_t	*vn_hold(struct bhv_v
 #if defined(XFS_VNODE_TRACE)
 #define VN_HOLD(vp)		\
 	((void)vn_hold(vp),	\
-	  vn_trace_hold(vp, __FILE__, __LINE__, (inst_t *)__return_address))
+	  vn_trace_hold(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address))
 #define VN_RELE(vp)		\
-	  (vn_trace_rele(vp, __FILE__, __LINE__, (inst_t *)__return_address), \
+	  (vn_trace_rele(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address), \
 	   iput(vn_to_inode(vp)))
 #else
 #define VN_HOLD(vp)		((void)vn_hold(vp))
@@ -314,21 +311,17 @@ static inline void vn_atime_to_time_t(bh
 #define	VNODE_KTRACE_REF	4
 #define	VNODE_KTRACE_RELE	5
 
-extern void vn_trace_entry(struct bhv_vnode *, const char *, inst_t *);
-extern void vn_trace_exit(struct bhv_vnode *, const char *, inst_t *);
-extern void vn_trace_hold(struct bhv_vnode *, char *, int, inst_t *);
-extern void vn_trace_ref(struct bhv_vnode *, char *, int, inst_t *);
-extern void vn_trace_rele(struct bhv_vnode *, char *, int, inst_t *);
-
-#define	VN_TRACE(vp)		\
-	vn_trace_ref(vp, __FILE__, __LINE__, (inst_t *)__return_address)
+extern void vn_trace_entry(struct xfs_inode *, const char *, inst_t *);
+extern void vn_trace_exit(struct xfs_inode *, const char *, inst_t *);
+extern void vn_trace_hold(struct xfs_inode *, char *, int, inst_t *);
+extern void vn_trace_ref(struct xfs_inode *, char *, int, inst_t *);
+extern void vn_trace_rele(struct xfs_inode *, char *, int, inst_t *);
 #else
 #define	vn_trace_entry(a,b,c)
 #define	vn_trace_exit(a,b,c)
 #define	vn_trace_hold(a,b,c,d)
 #define	vn_trace_ref(a,b,c,d)
 #define	vn_trace_rele(a,b,c,d)
-#define	VN_TRACE(vp)
 #endif
 
 #endif	/* __XFS_VNODE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_dir2.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dir2.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dir2.c	2007-08-23 14:53:52.000000000 +0200
@@ -301,7 +301,7 @@ xfs_readdir(
 	int		rval;		/* return value */
 	int		v;		/* type-checking value */
 
-	vn_trace_entry(XFS_ITOV(dp), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-08-23 14:53:56.000000000 +0200
@@ -157,7 +157,7 @@ again:
 				goto again;
 			}
 
-			vn_trace_exit(vp, "xfs_iget.alloc",
+			vn_trace_exit(ip, "xfs_iget.alloc",
 				(inst_t *)__return_address);
 
 			XFS_STATS_INC(xs_ig_found);
@@ -212,7 +212,7 @@ finish_inode:
 			xfs_ilock(ip, lock_flags);
 
 		xfs_iflags_clear(ip, XFS_ISTALE);
-		vn_trace_exit(vp, "xfs_iget.found",
+		vn_trace_exit(ip, "xfs_iget.found",
 					(inst_t *)__return_address);
 		goto return_ip;
 	}
@@ -234,7 +234,7 @@ finish_inode:
 		return error;
 	}
 
-	vn_trace_exit(vp, "xfs_iget.alloc", (inst_t *)__return_address);
+	vn_trace_exit(ip, "xfs_iget.alloc", (inst_t *)__return_address);
 
 	xfs_inode_lock_init(ip, vp);
 	xfs_iocore_inode_init(ip);
@@ -477,7 +477,7 @@ xfs_iput(xfs_inode_t	*ip,
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 
-	vn_trace_entry(vp, "xfs_iput", (inst_t *)__return_address);
+	vn_trace_entry(ip, "xfs_iput", (inst_t *)__return_address);
 	xfs_iunlock(ip, lock_flags);
 	VN_RELE(vp);
 }
@@ -492,7 +492,7 @@ xfs_iput_new(xfs_inode_t	*ip,
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	struct inode	*inode = vn_to_inode(vp);
 
-	vn_trace_entry(vp, "xfs_iput_new", (inst_t *)__return_address);
+	vn_trace_entry(ip, "xfs_iput_new", (inst_t *)__return_address);
 
 	if ((ip->i_d.di_mode == 0)) {
 		ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-08-23 14:53:52.000000000 +0200
@@ -884,6 +884,9 @@ xfs_iread(
 	 * Initialize inode's trace buffers.
 	 * Do this before xfs_iformat in case it adds entries.
 	 */
+#ifdef	XFS_VNODE_TRACE
+	ip->i_trace = ktrace_alloc(VNODE_TRACE_SIZE, KM_SLEEP);
+#endif
 #ifdef XFS_BMAP_TRACE
 	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_SLEEP);
 #endif
@@ -2729,6 +2732,10 @@ xfs_idestroy(
 	mrfree(&ip->i_lock);
 	mrfree(&ip->i_iolock);
 	freesema(&ip->i_flock);
+
+#ifdef XFS_VNODE_TRACE
+	ktrace_free(ip->i_trace);
+#endif
 #ifdef XFS_BMAP_TRACE
 	ktrace_free(ip->i_xtrace);
 #endif
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-08-23 14:53:52.000000000 +0200
@@ -302,6 +302,9 @@ typedef struct xfs_inode {
 	xfs_fsize_t		i_size;		/* in-memory size */
 	atomic_t		i_iocount;	/* outstanding I/O count */
 	/* Trace buffers per inode. */
+#ifdef XFS_VNODE_TRACE
+	struct ktrace		*i_trace;	/* general inode trace */
+#endif
 #ifdef XFS_BMAP_TRACE
 	struct ktrace		*i_xtrace;	/* inode extent list trace */
 #endif
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2007-08-23 14:53:52.000000000 +0200
@@ -247,8 +247,8 @@ xfs_rename(
 	int		src_namelen = VNAMELEN(src_vname);
 	int		target_namelen = VNAMELEN(target_vname);
 
-	vn_trace_entry(src_dir_vp, "xfs_rename", (inst_t *)__return_address);
-	vn_trace_entry(target_dir_vp, "xfs_rename", (inst_t *)__return_address);
+	vn_trace_entry(src_dp, "xfs_rename", (inst_t *)__return_address);
+	vn_trace_entry(xfs_vtoi(target_dir_vp), "xfs_rename", (inst_t *)__return_address);
 
 	/*
 	 * Find the XFS behavior descriptor for the target directory
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2007-08-23 14:53:52.000000000 +0200
@@ -73,7 +73,7 @@ xfs_dir_lookup_int(
 {
 	int		error;
 
-	vn_trace_entry(XFS_ITOV(dp), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 	error = xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), inum);
 	if (!error) {
Index: linux-2.6-xfs/fs/xfs/xfs_utils.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.h	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.h	2007-08-23 14:53:52.000000000 +0200
@@ -20,7 +20,7 @@
 
 #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
 #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
-#define	ITRACE(ip)	vn_trace_ref(XFS_ITOV(ip), __FILE__, __LINE__, \
+#define	ITRACE(ip)	vn_trace_ref(ip, __FILE__, __LINE__, \
 				(inst_t *)__return_address)
 
 extern int xfs_get_dir_entry (bhv_vname_t *, xfs_inode_t **);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-23 14:53:52.000000000 +0200
@@ -88,7 +88,7 @@ xfs_getattr(
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	xfs_mount_t	*mp = ip->i_mount;
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -228,7 +228,7 @@ xfs_setattr(
 	int			file_owner;
 	int			need_iolock = 1;
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
 		return XFS_ERROR(EROFS);
@@ -915,7 +915,7 @@ xfs_access(
 {
 	int		error;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	error = xfs_iaccess(ip, mode, credp);
@@ -987,7 +987,7 @@ xfs_readlink(
 	int		pathlen;
 	int		error = 0;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -1033,7 +1033,7 @@ xfs_fsync(
 	int		error;
 	int		log_flushed = 0, changed = 1;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	ASSERT(start >= 0 && stop >= -1);
 
@@ -1594,7 +1594,7 @@ xfs_inactive(
 	int		error;
 	int		truncate;
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	/*
 	 * If the inode is already free, then there can be nothing
@@ -1807,7 +1807,7 @@ xfs_lookup(
 	int			error;
 	uint			lock_mode;
 
-	vn_trace_entry(XFS_ITOV(dp), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
@@ -1851,7 +1851,7 @@ xfs_create(
 	int			namelen;
 
 	ASSERT(!*vpp);
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 	dm_di_mode = vap->va_mode;
 	namelen = VNAMELEN(dentry);
@@ -2328,7 +2328,7 @@ xfs_remove(
 	uint			resblks;
 	int			namelen;
 
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -2371,7 +2371,7 @@ xfs_remove(
 
 	dm_di_mode = ip->i_d.di_mode;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	ITRACE(ip);
 
@@ -2505,7 +2505,7 @@ xfs_remove(
 	if (link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
-	vn_trace_exit(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_exit(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	IRELE(ip);
 
@@ -2569,8 +2569,8 @@ xfs_link(
 	char			*target_name = VNAME(dentry);
 	int			target_namelen;
 
-	vn_trace_entry(target_dir_vp, __FUNCTION__, (inst_t *)__return_address);
-	vn_trace_entry(src_vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(tdp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(xfs_vtoi(src_vp), __FUNCTION__, (inst_t *)__return_address);
 
 	target_namelen = VNAMELEN(dentry);
 	ASSERT(!VN_ISDIR(src_vp));
@@ -2753,7 +2753,7 @@ xfs_mkdir(
 
 	/* Return through std_return after this point. */
 
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 	mp = dp->i_mount;
 	udqp = gdqp = NULL;
@@ -2947,7 +2947,7 @@ xfs_rmdir(
 	int			last_cdp_link;
 	uint			resblks;
 
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -3200,7 +3200,7 @@ xfs_symlink(
 	ip = NULL;
 	tp = NULL;
 
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
 
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -3492,7 +3492,7 @@ xfs_fid2(
 {
 	xfs_fid2_t	*xfid = (xfs_fid2_t *)fidp;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 	ASSERT(sizeof(fid_t) >= sizeof(xfs_fid2_t));
 
 	xfid->fid_len = sizeof(xfs_fid2_t) - sizeof(xfid->fid_len);
@@ -3674,7 +3674,7 @@ xfs_reclaim(
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	ASSERT(!VN_MAPPED(vp));
 
@@ -3892,7 +3892,7 @@ xfs_alloc_file_space(
 	int			committed;
 	int			error;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -4162,7 +4162,7 @@ xfs_free_file_space(
 	vp = XFS_ITOV(ip);
 	mp = ip->i_mount;
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
 		return error;
@@ -4368,7 +4368,7 @@ xfs_change_file_space(
 	xfs_trans_t	*tp;
 	bhv_vattr_t	va;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
 	/*
 	 * must be a regular file and have write permission
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-23 14:51:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-23 14:53:56.000000000 +0200
@@ -113,6 +113,12 @@ static void	xfsidbg_xqm_dqtrace(xfs_dquo
 #ifdef XFS_FILESTREAMS_TRACE
 static void	xfsidbg_filestreams_trace(int);
 #endif
+#ifdef	XFS_VNODE_TRACE
+/*
+ * Print a vnode trace entry.
+ */
+static int	vn_trace_pr_entry(ktrace_entry_t *ktep);
+#endif
 
 
 /*
@@ -1432,18 +1438,37 @@ static int	kdbm_xfs_xnode(
 	int	argc,
 	const char **argv)
 {
+	xfs_inode_t *ip;
 	unsigned long addr;
 	int nextarg = 1;
 	long offset = 0;
 	int diag;
+#ifdef	XFS_VNODE_TRACE
+	ktrace_entry_t	*ktep;
+	ktrace_snap_t	kts;
+#endif
 
 	if (argc != 1)
 		return KDB_ARGCOUNT;
 	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
 	if (diag)
 		return diag;
+	ip = (xfs_inode_t *)addr;
+
+	xfsidbg_xnode(ip);
 
-	xfsidbg_xnode((xfs_inode_t *) addr);
+#ifdef	XFS_VNODE_TRACE
+	kdb_printf("--> itrace @ 0x%lx/0x%p\n", addr, ip->i_trace);
+	if (ip->i_trace == NULL)
+		return 0;
+	ktep = ktrace_first(ip->i_trace, &kts);
+	while (ktep != NULL) {
+		if (vn_trace_pr_entry(ktep))
+			kdb_printf("\n");
+
+		ktep = ktrace_next(ip->i_trace, &kts);
+	}
+#endif	/* XFS_VNODE_TRACE */
 	return 0;
 }
 
@@ -1758,10 +1783,6 @@ static void	printvnode(bhv_vnode_t *vp, 
 
 	kdb_printf("\n");
 
-#ifdef	XFS_VNODE_TRACE
-	kdb_printf("   v_trace 0x%p\n", vp->v_trace);
-#endif	/* XFS_VNODE_TRACE */
-
 	kdb_printf("   v_number 0x%llx\n", (unsigned long long)vp->v_number);
 }
 
@@ -1971,7 +1992,7 @@ static int	kdbm_vntrace(
 	int		nextarg = 1;
 	long		offset = 0;
 	unsigned long	addr;
-	bhv_vnode_t	*vp;
+	xfs_inode_t	*ip;
 	ktrace_entry_t	*ktep;
 	ktrace_snap_t	kts;
 
@@ -1984,23 +2005,23 @@ static int	kdbm_vntrace(
 	if (diag)
 		return diag;
 
-	vp = (bhv_vnode_t *)addr;
+	ip = (xfs_inode_t *)addr;
 
-	if (vp->v_trace == NULL) {
+	if (ip->i_trace == NULL) {
 		kdb_printf("The vnode trace buffer is not initialized\n");
 
 		return 0;
 	}
 
-	kdb_printf("vntrace vp 0x%p\n", vp);
+	kdb_printf("vntrace ip 0x%p\n", ip);
 
-	ktep = ktrace_first(vp->v_trace, &kts);
+	ktep = ktrace_first(ip->i_trace, &kts);
 
 	while (ktep != NULL) {
 		if (vn_trace_pr_entry(ktep))
 			kdb_printf("\n");
 
-		ktep = ktrace_next(vp->v_trace, &kts);
+		ktep = ktrace_next(ip->i_trace, &kts);
 	}
 
 	return 0;
@@ -2096,10 +2117,6 @@ static int	kdbm_vn(
 	unsigned long	addr;
 	struct inode	*ip;
 	bhv_vnode_t	vp;
-#ifdef	XFS_VNODE_TRACE
-	ktrace_entry_t	*ktep;
-	ktrace_snap_t	kts;
-#endif
 
 	if (argc != 1)
 		return KDB_ARGCOUNT;
@@ -2117,19 +2134,6 @@ static int	kdbm_vn(
 
 	kdb_printf("--> Vnode @ 0x%lx\n", addr);
 	printvnode(&vp, addr);
-
-#ifdef	XFS_VNODE_TRACE
-	kdb_printf("--> Vntrace @ 0x%lx/0x%p\n", addr, vp.v_trace);
-	if (vp.v_trace == NULL)
-		return 0;
-	ktep = ktrace_first(vp.v_trace, &kts);
-	while (ktep != NULL) {
-		if (vn_trace_pr_entry(ktep))
-			kdb_printf("\n");
-
-		ktep = ktrace_next(vp.v_trace, &kts);
-	}
-#endif	/* XFS_VNODE_TRACE */
 	return 0;
 }
 
@@ -6691,6 +6695,10 @@ xfsidbg_xnode(xfs_inode_t *ip)
 		ip->i_delayed_blks);
 	kdb_printf("size %lld\n",
 		ip->i_size);
+
+#ifdef	XFS_VNODE_TRACE
+	qprintf(" trace 0x%p\n", ip->i_trace);
+#endif
 #ifdef XFS_BMAP_TRACE
 	qprintf(" bmap_trace 0x%p\n", ip->i_xtrace);
 #endif
