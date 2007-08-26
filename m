Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Aug 2007 23:35:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7Q6Yw4p032232
	for <xfs@oss.sgi.com>; Sat, 25 Aug 2007 23:35:01 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E412318DB0F08
	for <xfs@oss.sgi.com>; Sun, 26 Aug 2007 01:34:57 -0500 (CDT)
Message-ID: <46D11F1B.5020409@sandeen.net>
Date: Sun, 26 Aug 2007 01:35:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] clean up vnode^winode tracing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Simplify vnode tracing calls by embedding function name & return addr
in the calling macro.

Also do a lot of vnode->inode renaming for consistency, while
we're at it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
@@ -1525,8 +1525,7 @@ xfs_vm_bmap(
 	struct inode		*inode = (struct inode *)mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 
-	vn_trace_entry(XFS_I(inode), __FUNCTION__,
-			(inst_t *)__return_address);
+	ip_trace_entry(XFS_I(inode));
 	xfs_rwlock(ip, VRWLOCK_READ);
 	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
 	xfs_rwunlock(ip, VRWLOCK_READ);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -733,8 +733,7 @@ xfs_ioctl(
 	xfs_mount_t		*mp = ip->i_mount;
 	int			error;
 
-	vn_trace_entry(XFS_I(inode), "xfs_ioctl", (inst_t *)__return_address);
-
+	ip_trace_entry(XFS_I(inode));
 	switch (cmd) {
 
 	case XFS_IOC_ALLOCSP:
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
@@ -83,12 +83,12 @@ EXPORT_SYMBOL(ktrace_first);
 EXPORT_SYMBOL(ktrace_next);
 #endif
 
-#ifdef XFS_VNODE_TRACE
-EXPORT_SYMBOL(vn_trace_ref);
-EXPORT_SYMBOL(vn_trace_entry);
-EXPORT_SYMBOL(vn_trace_exit);
-EXPORT_SYMBOL(vn_trace_hold);
-EXPORT_SYMBOL(vn_trace_rele);
+#ifdef XFS_INODE_TRACE
+EXPORT_SYMBOL(_ip_trace_ref);
+EXPORT_SYMBOL(_ip_trace_entry);
+EXPORT_SYMBOL(_ip_trace_exit);
+EXPORT_SYMBOL(ip_trace_hold);
+EXPORT_SYMBOL(ip_trace_rele);
 #endif
 
 #ifdef XFS_ILOCK_TRACE
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
@@ -403,8 +403,7 @@ xfs_fs_write_inode(
 {
 	int			error = 0, flags = FLUSH_INODE;
 
-	vn_trace_entry(XFS_I(inode), __FUNCTION__,
-			(inst_t *)__return_address);
+	ip_trace_entry(XFS_I(inode));
 	if (sync)
 		flags |= FLUSH_SYNC;
 	error = xfs_inode_flush(XFS_I(inode), flags);
@@ -430,8 +429,7 @@ xfs_fs_clear_inode(
 	 * find an inode with di_mode == 0 but without IGET_CREATE set.
 	 */
 	if (ip) {
-		vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
-
+		ip_trace_entry(ip);
 		XFS_STATS_INC(vn_rele);
 		XFS_STATS_INC(vn_remove);
 		XFS_STATS_INC(vn_reclaim);
@@ -820,8 +818,7 @@ xfs_fs_fill_super(
 		goto fail_vnrele;
 	}
 
-	vn_trace_exit(XFS_I(sb->s_root->d_inode), __FUNCTION__,
-			(inst_t *)__return_address);
+	ip_trace_exit(XFS_I(sb->s_root->d_inode));
 
 	kmem_free(args, sizeof(*args));
 	return 0;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
@@ -143,7 +143,7 @@ __vn_revalidate(
 {
 	int		error;
 
-	vn_trace_entry(xfs_vtoi(vp), __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(xfs_vtoi(vp));
 	vattr->va_mask = XFS_AT_STAT | XFS_AT_XFLAGS;
 	error = xfs_getattr(xfs_vtoi(vp), vattr, 0);
 	if (likely(!error)) {
@@ -179,7 +179,7 @@ vn_hold(
 	return vp;
 }
 
-#ifdef	XFS_VNODE_TRACE
+#ifdef	XFS_INODE_TRACE
 
 /*
  * Reference count of Linux inode if present, -1 if the xfs_inode
@@ -211,32 +211,32 @@ static inline int xfs_icount(struct xfs_
  * Vnode tracing code.
  */
 void
-vn_trace_entry(xfs_inode_t *ip, const char *func, inst_t *ra)
+_ip_trace_entry(xfs_inode_t *ip, const char *func, inst_t *ra)
 {
-	KTRACE_ENTER(ip, VNODE_KTRACE_ENTRY, func, 0, ra);
+	KTRACE_ENTER(ip, INODE_KTRACE_ENTRY, func, 0, ra);
 }
 
 void
-vn_trace_exit(xfs_inode_t *ip, const char *func, inst_t *ra)
+_ip_trace_exit(xfs_inode_t *ip, const char *func, inst_t *ra)
 {
-	KTRACE_ENTER(ip, VNODE_KTRACE_EXIT, func, 0, ra);
+	KTRACE_ENTER(ip, INODE_KTRACE_EXIT, func, 0, ra);
 }
 
 void
-vn_trace_hold(xfs_inode_t *ip, char *file, int line, inst_t *ra)
+ip_trace_hold(xfs_inode_t *ip, char *file, int line, inst_t *ra)
 {
-	KTRACE_ENTER(ip, VNODE_KTRACE_HOLD, file, line, ra);
+	KTRACE_ENTER(ip, INODE_KTRACE_HOLD, file, line, ra);
 }
 
 void
-vn_trace_ref(xfs_inode_t *ip, char *file, int line, inst_t *ra)
+_ip_trace_ref(xfs_inode_t *ip, char *file, int line, inst_t *ra)
 {
-	KTRACE_ENTER(ip, VNODE_KTRACE_REF, file, line, ra);
+	KTRACE_ENTER(ip, INODE_KTRACE_REF, file, line, ra);
 }
 
 void
-vn_trace_rele(xfs_inode_t *ip, char *file, int line, inst_t *ra)
+ip_trace_rele(xfs_inode_t *ip, char *file, int line, inst_t *ra)
 {
-	KTRACE_ENTER(ip, VNODE_KTRACE_RELE, file, line, ra);
+	KTRACE_ENTER(ip, INODE_KTRACE_RELE, file, line, ra);
 }
-#endif	/* XFS_VNODE_TRACE */
+#endif	/* XFS_INODE_TRACE */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
@@ -210,12 +210,12 @@ static inline int vn_count(bhv_vnode_t *
  */
 extern bhv_vnode_t	*vn_hold(bhv_vnode_t *);
 
-#if defined(XFS_VNODE_TRACE)
+#if defined(XFS_INODE_TRACE)
 #define VN_HOLD(vp)		\
 	((void)vn_hold(vp),	\
-	  vn_trace_hold(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address))
+	  ip_trace_hold(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address))
 #define VN_RELE(vp)		\
-	  (vn_trace_rele(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address), \
+	  (ip_trace_rele(xfs_vtoi(vp), __FILE__, __LINE__, (inst_t *)__return_address), \
 	   iput(vn_to_inode(vp)))
 #else
 #define VN_HOLD(vp)		((void)vn_hold(vp))
@@ -296,26 +296,33 @@ static inline void vn_atime_to_time_t(bh
 /*
  * Tracking vnode activity.
  */
-#if defined(XFS_VNODE_TRACE)
+#if defined(XFS_INODE_TRACE)
+
+#define	INODE_TRACE_SIZE	16		/* number of trace entries */
+#define	INODE_KTRACE_ENTRY	1
+#define	INODE_KTRACE_EXIT	2
+#define	INODE_KTRACE_HOLD	3
+#define	INODE_KTRACE_REF	4
+#define	INODE_KTRACE_RELE	5
+
+extern void _ip_trace_entry(struct xfs_inode *, const char *, inst_t *);
+extern void _ip_trace_exit(struct xfs_inode *, const char *, inst_t *);
+extern void ip_trace_hold(struct xfs_inode *, char *, int, inst_t *);
+extern void _ip_trace_ref(struct xfs_inode *, char *, int, inst_t *);
+extern void ip_trace_rele(struct xfs_inode *, char *, int, inst_t *);
+#define ip_trace_entry(ip)	\
+	_ip_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address)
+#define ip_trace_exit(ip)	\
+	_ip_trace_exit(ip, __FUNCTION__, (inst_t *)__return_address)
+#define ip_trace_ref(ip)	\
+	_ip_trace_ref(ip, __FILE__, __LINE__, (inst_t *)__return_address)
 
-#define	VNODE_TRACE_SIZE	16		/* number of trace entries */
-#define	VNODE_KTRACE_ENTRY	1
-#define	VNODE_KTRACE_EXIT	2
-#define	VNODE_KTRACE_HOLD	3
-#define	VNODE_KTRACE_REF	4
-#define	VNODE_KTRACE_RELE	5
-
-extern void vn_trace_entry(struct xfs_inode *, const char *, inst_t *);
-extern void vn_trace_exit(struct xfs_inode *, const char *, inst_t *);
-extern void vn_trace_hold(struct xfs_inode *, char *, int, inst_t *);
-extern void vn_trace_ref(struct xfs_inode *, char *, int, inst_t *);
-extern void vn_trace_rele(struct xfs_inode *, char *, int, inst_t *);
 #else
-#define	vn_trace_entry(a,b,c)
-#define	vn_trace_exit(a,b,c)
-#define	vn_trace_hold(a,b,c,d)
-#define	vn_trace_ref(a,b,c,d)
-#define	vn_trace_rele(a,b,c,d)
+#define	ip_trace_entry(a)
+#define	ip_trace_exit(a)
+#define	ip_trace_hold(a, b, c, d)
+#define	ip_trace_ref(a)
+#define	ip_trace_rele(a, b, c, d)
 #endif
 
 #endif	/* __XFS_VNODE_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_dir2.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dir2.c
+++ linux-2.6-xfs/fs/xfs/xfs_dir2.c
@@ -301,7 +301,7 @@ xfs_readdir(
 	int		rval;		/* return value */
 	int		v;		/* type-checking value */
 
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(dp);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c
@@ -157,7 +157,7 @@ again:
 				goto again;
 			}
 
-			vn_trace_exit(ip, "xfs_iget.alloc",
+			_ip_trace_exit(ip, "xfs_iget.alloc",
 				(inst_t *)__return_address);
 
 			XFS_STATS_INC(xs_ig_found);
@@ -212,7 +212,7 @@ finish_inode:
 			xfs_ilock(ip, lock_flags);
 
 		xfs_iflags_clear(ip, XFS_ISTALE);
-		vn_trace_exit(ip, "xfs_iget.found",
+		_ip_trace_exit(ip, "xfs_iget.found",
 					(inst_t *)__return_address);
 		goto return_ip;
 	}
@@ -234,7 +234,7 @@ finish_inode:
 		return error;
 	}
 
-	vn_trace_exit(ip, "xfs_iget.alloc", (inst_t *)__return_address);
+	_ip_trace_exit(ip, "xfs_iget.alloc", (inst_t *)__return_address);
 
 	xfs_inode_lock_init(ip, vp);
 	xfs_iocore_inode_init(ip);
@@ -467,7 +467,7 @@ xfs_iput(xfs_inode_t	*ip,
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 
-	vn_trace_entry(ip, "xfs_iput", (inst_t *)__return_address);
+	ip_trace_entry(ip);
 	xfs_iunlock(ip, lock_flags);
 	VN_RELE(vp);
 }
@@ -482,7 +482,7 @@ xfs_iput_new(xfs_inode_t	*ip,
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	struct inode	*inode = vn_to_inode(vp);
 
-	vn_trace_entry(ip, "xfs_iput_new", (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	if ((ip->i_d.di_mode == 0)) {
 		ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c
@@ -884,8 +884,8 @@ xfs_iread(
 	 * Initialize inode's trace buffers.
 	 * Do this before xfs_iformat in case it adds entries.
 	 */
-#ifdef	XFS_VNODE_TRACE
-	ip->i_trace = ktrace_alloc(VNODE_TRACE_SIZE, KM_SLEEP);
+#ifdef	XFS_INODE_TRACE
+	ip->i_trace = ktrace_alloc(INODE_TRACE_SIZE, KM_SLEEP);
 #endif
 #ifdef XFS_BMAP_TRACE
 	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_SLEEP);
@@ -2733,7 +2733,7 @@ xfs_idestroy(
 	mrfree(&ip->i_iolock);
 	freesema(&ip->i_flock);
 
-#ifdef XFS_VNODE_TRACE
+#ifdef XFS_INODE_TRACE
 	ktrace_free(ip->i_trace);
 #endif
 #ifdef XFS_BMAP_TRACE
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c
@@ -118,7 +118,7 @@ xfs_lock_for_rename(
 	inum1 = ip1->i_ino;
 
 	ASSERT(ip1);
-	ITRACE(ip1);
+	ip_trace_ref(ip1);
 
 	/*
 	 * Unlock dp1 and lock dp2 if they are different.
@@ -141,7 +141,7 @@ xfs_lock_for_rename(
 		IRELE (ip1);
 		return error;
 	} else {
-		ITRACE(ip2);
+		ip_trace_ref(ip2);
 	}
 
 	/*
@@ -247,8 +247,8 @@ xfs_rename(
 	int		src_namelen = VNAMELEN(src_vname);
 	int		target_namelen = VNAMELEN(target_vname);
 
-	vn_trace_entry(src_dp, "xfs_rename", (inst_t *)__return_address);
-	vn_trace_entry(xfs_vtoi(target_dir_vp), "xfs_rename", (inst_t *)__return_address);
+	ip_trace_entry(src_dp);
+	ip_trace_entry(xfs_vtoi(target_dir_vp));
 
 	/*
 	 * Find the XFS behavior descriptor for the target directory
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c
@@ -73,7 +73,7 @@ xfs_dir_lookup_int(
 {
 	int		error;
 
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(dp);
 
 	error = xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), inum);
 	if (!error) {
Index: linux-2.6-xfs/fs/xfs/xfs_utils.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.h
+++ linux-2.6-xfs/fs/xfs/xfs_utils.h
@@ -20,8 +20,6 @@
 
 #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
 #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
-#define	ITRACE(ip)	vn_trace_ref(ip, __FILE__, __LINE__, \
-				(inst_t *)__return_address)
 
 extern int xfs_get_dir_entry (bhv_vname_t *, xfs_inode_t **);
 extern int xfs_dir_lookup_int (xfs_inode_t *, uint, bhv_vname_t *, xfs_ino_t *,
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
@@ -88,7 +88,7 @@ xfs_getattr(
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	xfs_mount_t	*mp = ip->i_mount;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -228,7 +228,7 @@ xfs_setattr(
 	int			file_owner;
 	int			need_iolock = 1;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return XFS_ERROR(EROFS);
@@ -915,8 +915,7 @@ xfs_access(
 {
 	int		error;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
-
+	ip_trace_entry(ip);
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	error = xfs_iaccess(ip, mode, credp);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -987,7 +986,7 @@ xfs_readlink(
 	int		pathlen;
 	int		error = 0;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -1033,7 +1032,7 @@ xfs_fsync(
 	int		error;
 	int		log_flushed = 0, changed = 1;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	ASSERT(start >= 0 && stop >= -1);
 
@@ -1589,7 +1588,7 @@ xfs_inactive(
 	int		error;
 	int		truncate;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	/*
 	 * If the inode is already free, then there can be nothing
@@ -1802,7 +1801,7 @@ xfs_lookup(
 	int			error;
 	uint			lock_mode;
 
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(dp);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
@@ -1811,7 +1810,7 @@ xfs_lookup(
 	error = xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip);
 	if (!error) {
 		*vpp = XFS_ITOV(ip);
-		ITRACE(ip);
+		ip_trace_ref(ip);
 	}
 	xfs_iunlock_map_shared(dp, lock_mode);
 	return error;
@@ -1846,7 +1845,7 @@ xfs_create(
 	int			namelen;
 
 	ASSERT(!*vpp);
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(dp);
 
 	dm_di_mode = vap->va_mode;
 	namelen = VNAMELEN(dentry);
@@ -1932,7 +1931,7 @@ xfs_create(
 			goto error_return;
 		goto abort_return;
 	}
-	ITRACE(ip);
+	ip_trace_ref(ip);
 
 	/*
 	 * At this point, we've gotten a newly allocated inode.
@@ -2100,7 +2099,7 @@ again:
 
 	e_inum = ip->i_ino;
 
-	ITRACE(ip);
+	ip_trace_ref(ip);
 
 	/*
 	 * We want to lock in increasing inum. Since we've already
@@ -2323,7 +2322,7 @@ xfs_remove(
 	uint			resblks;
 	int			namelen;
 
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(dp);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -2366,9 +2365,8 @@ xfs_remove(
 
 	dm_di_mode = ip->i_d.di_mode;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
-
-	ITRACE(ip);
+	ip_trace_entry(ip);
+	ip_trace_ref(ip);
 
 	error = XFS_QM_DQATTACH(mp, dp, 0);
 	if (!error && dp != ip)
@@ -2500,8 +2498,7 @@ xfs_remove(
 	if (link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
-	vn_trace_exit(ip, __FUNCTION__, (inst_t *)__return_address);
-
+	ip_trace_exit(ip);
 	IRELE(ip);
 
 /*	Fall through to std_return with error = 0 */
@@ -2564,8 +2561,8 @@ xfs_link(
 	char			*target_name = VNAME(dentry);
 	int			target_namelen;
 
-	vn_trace_entry(tdp, __FUNCTION__, (inst_t *)__return_address);
-	vn_trace_entry(xfs_vtoi(src_vp), __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(tdp);
+	ip_trace_entry(xfs_vtoi(src_vp));
 
 	target_namelen = VNAMELEN(dentry);
 	ASSERT(!VN_ISDIR(src_vp));
@@ -2748,7 +2745,7 @@ xfs_mkdir(
 
 	/* Return through std_return after this point. */
 
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(dp);
 
 	mp = dp->i_mount;
 	udqp = gdqp = NULL;
@@ -2816,7 +2813,7 @@ xfs_mkdir(
 			goto error_return;
 		goto abort_return;
 	}
-	ITRACE(cdp);
+	ip_trace_ref(cdp);
 
 	/*
 	 * Now we add the directory inode to the transaction.
@@ -2942,7 +2939,7 @@ xfs_rmdir(
 	int			last_cdp_link;
 	uint			resblks;
 
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(dp);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -3047,7 +3044,7 @@ xfs_rmdir(
 		VN_HOLD(dir_vp);
 	}
 
-	ITRACE(cdp);
+	ip_trace_ref(cdp);
 	xfs_trans_ijoin(tp, cdp, XFS_ILOCK_EXCL);
 
 	ASSERT(cdp->i_d.di_nlink >= 2);
@@ -3195,8 +3192,7 @@ xfs_symlink(
 	ip = NULL;
 	tp = NULL;
 
-	vn_trace_entry(dp, __FUNCTION__, (inst_t *)__return_address);
-
+	ip_trace_entry(dp);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -3325,7 +3321,7 @@ xfs_symlink(
 			goto error_return;
 		goto error1;
 	}
-	ITRACE(ip);
+	ip_trace_ref(ip);
 
 	/*
 	 * An error after we've joined dp to the transaction will result in the
@@ -3487,7 +3483,7 @@ xfs_fid2(
 {
 	xfs_fid2_t	*xfid = (xfs_fid2_t *)fidp;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 	ASSERT(sizeof(fid_t) >= sizeof(xfs_fid2_t));
 
 	xfid->fid_len = sizeof(xfs_fid2_t) - sizeof(xfid->fid_len);
@@ -3669,7 +3665,7 @@ xfs_reclaim(
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	ASSERT(!VN_MAPPED(vp));
 
@@ -3887,7 +3883,7 @@ xfs_alloc_file_space(
 	int			committed;
 	int			error;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -4157,7 +4153,7 @@ xfs_free_file_space(
 	vp = XFS_ITOV(ip);
 	mp = ip->i_mount;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
 		return error;
@@ -4363,7 +4359,7 @@ xfs_change_file_space(
 	xfs_trans_t	*tp;
 	bhv_vattr_t	va;
 
-	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
+	ip_trace_entry(ip);
 
 	/*
 	 * must be a regular file and have write permission
Index: linux-2.6-xfs/fs/xfs/xfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs.h
+++ linux-2.6-xfs/fs/xfs/xfs.h
@@ -37,7 +37,7 @@
 #define XFS_LOG_TRACE 1
 #define XFS_RW_TRACE 1
 #define XFS_BUF_TRACE 1
-#define XFS_VNODE_TRACE 1
+#define XFS_INODE_TRACE 1
 #define XFS_FILESTREAMS_TRACE 1
 #endif
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h
@@ -300,7 +300,7 @@ typedef struct xfs_inode {
 	xfs_fsize_t		i_size;		/* in-memory size */
 	atomic_t		i_iocount;	/* outstanding I/O count */
 	/* Trace buffers per inode. */
-#ifdef XFS_VNODE_TRACE
+#ifdef XFS_INODE_TRACE
 	struct ktrace		*i_trace;	/* general inode trace */
 #endif
 #ifdef XFS_BMAP_TRACE
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c
@@ -113,11 +113,11 @@ static void	xfsidbg_xqm_dqtrace(xfs_dquo
 #ifdef XFS_FILESTREAMS_TRACE
 static void	xfsidbg_filestreams_trace(int);
 #endif
-#ifdef	XFS_VNODE_TRACE
+#ifdef	XFS_INODE_TRACE
 /*
- * Print a vnode trace entry.
+ * Print a inode trace entry.
  */
-static int	vn_trace_pr_entry(ktrace_entry_t *ktep);
+static int	ip_trace_pr_entry(ktrace_entry_t *ktep);
 #endif
 
 
@@ -1443,7 +1443,7 @@ static int	kdbm_xfs_xnode(
 	int nextarg = 1;
 	long offset = 0;
 	int diag;
-#ifdef	XFS_VNODE_TRACE
+#ifdef	XFS_INODE_TRACE
 	ktrace_entry_t	*ktep;
 	ktrace_snap_t	kts;
 #endif
@@ -1457,18 +1457,18 @@ static int	kdbm_xfs_xnode(
 
 	xfsidbg_xnode(ip);
 
-#ifdef	XFS_VNODE_TRACE
+#ifdef	XFS_INODE_TRACE
 	kdb_printf("--> itrace @ 0x%lx/0x%p\n", addr, ip->i_trace);
 	if (ip->i_trace == NULL)
 		return 0;
 	ktep = ktrace_first(ip->i_trace, &kts);
 	while (ktep != NULL) {
-		if (vn_trace_pr_entry(ktep))
+		if (ip_trace_pr_entry(ktep))
 			kdb_printf("\n");
 
 		ktep = ktrace_next(ip->i_trace, &kts);
 	}
-#endif	/* XFS_VNODE_TRACE */
+#endif	/* XFS_INODE_TRACE */
 	return 0;
 }
 
@@ -1784,12 +1784,12 @@ static int	kdbm_vnode(
 	return 0;
 }
 
-#ifdef	XFS_VNODE_TRACE
+#ifdef	XFS_INODE_TRACE
 /*
- * Print a vnode trace entry.
+ * Print a inode trace entry.
  */
 static int
-vn_trace_pr_entry(ktrace_entry_t *ktep)
+ip_trace_pr_entry(ktrace_entry_t *ktep)
 {
 	char		funcname[128];
 	kdb_symtab_t	symtab;
@@ -1812,19 +1812,19 @@ vn_trace_pr_entry(ktrace_entry_t *ktep)
 
 
 	switch ((__psint_t)ktep->val[0]) {
-	case VNODE_KTRACE_ENTRY:
+	case INODE_KTRACE_ENTRY:
 		kdb_printf("entry to %s i_count = %ld",
 						(char *)ktep->val[1],
 						(long)ktep->val[3]);
 		break;
 
-	case VNODE_KTRACE_EXIT:
+	case INODE_KTRACE_EXIT:
 		kdb_printf("exit from %s i_count = %lu",
 						(char *)ktep->val[1],
 						(long)ktep->val[3]);
 		break;
 
-	case VNODE_KTRACE_HOLD:
+	case INODE_KTRACE_HOLD:
 		if ((__psint_t)ktep->val[3] != 1)
 			kdb_printf("hold @%s:%ld(%s) i_count %ld => %ld ",
 						(char *)ktep->val[1],
@@ -1840,7 +1840,7 @@ vn_trace_pr_entry(ktrace_entry_t *ktep)
 						(long)ktep->val[3]);
 		break;
 
-	case VNODE_KTRACE_REF:
+	case INODE_KTRACE_REF:
 		kdb_printf("ref @%s:%ld(%s) i_count = %ld",
 						(char *)ktep->val[1],
 						(long)ktep->val[2],
@@ -1848,7 +1848,7 @@ vn_trace_pr_entry(ktrace_entry_t *ktep)
 						(long)ktep->val[3]);
 		break;
 
-	case VNODE_KTRACE_RELE:
+	case INODE_KTRACE_RELE:
 		if ((__psint_t)ktep->val[3] != 1)
 			kdb_printf("rele @%s:%ld(%s) i_count %ld => %ld ",
 						(char *)ktep->val[1],
@@ -1865,7 +1865,7 @@ vn_trace_pr_entry(ktrace_entry_t *ktep)
 		break;
 
 	default:
-		kdb_printf("unknown vntrace record\n");
+		kdb_printf("unknown intrace record\n");
 		return 1;
 	}
 
@@ -1891,9 +1891,9 @@ vn_trace_pr_entry(ktrace_entry_t *ktep)
 
 
 /*
- * Print out the trace buffer attached to the given vnode.
+ * Print out the trace buffer attached to the given inode.
  */
-static int	kdbm_vntrace(
+static int	kdbm_iptrace(
 	int	argc,
 	const char **argv)
 {
@@ -1917,17 +1917,17 @@ static int	kdbm_vntrace(
 	ip = (xfs_inode_t *)addr;
 
 	if (ip->i_trace == NULL) {
-		kdb_printf("The vnode trace buffer is not initialized\n");
+		kdb_printf("The inode trace buffer is not initialized\n");
 
 		return 0;
 	}
 
-	kdb_printf("vntrace ip 0x%p\n", ip);
+	kdb_printf("iptrace ip 0x%p\n", ip);
 
 	ktep = ktrace_first(ip->i_trace, &kts);
 
 	while (ktep != NULL) {
-		if (vn_trace_pr_entry(ktep))
+		if (ip_trace_pr_entry(ktep))
 			kdb_printf("\n");
 
 		ktep = ktrace_next(ip->i_trace, &kts);
@@ -1936,9 +1936,9 @@ static int	kdbm_vntrace(
 	return 0;
 }
 /*
- * Print out the trace buffer attached to the given vnode.
+ * Print out the trace buffer attached to the given inode.
  */
-static int	kdbm_vntraceaddr(
+static int	kdbm_iptraceaddr(
 	int	argc,
 	const char **argv)
 {
@@ -1961,12 +1961,12 @@ static int	kdbm_vntraceaddr(
 
 	kt = (struct ktrace *)addr;
 
-	kdb_printf("vntraceaddr kt 0x%p\n", kt);
+	kdb_printf("iptraceaddr kt 0x%p\n", kt);
 
 	ktep = ktrace_first(kt, &kts);
 
 	while (ktep != NULL) {
-		if (vn_trace_pr_entry(ktep))
+		if (ip_trace_pr_entry(ktep))
 			kdb_printf("\n");
 
 		ktep = ktrace_next(kt, &kts);
@@ -1974,7 +1974,7 @@ static int	kdbm_vntraceaddr(
 
 	return 0;
 }
-#endif	/* XFS_VNODE_TRACE */
+#endif	/* XFS_INODE_TRACE */
 
 
 static void	printinode(struct inode *ip)
@@ -2393,10 +2393,10 @@ struct xif {
 static struct xif xfsidbg_funcs[] = {
   {  "vn",	kdbm_vn,	"<vnode>", "Dump inode/vnode/trace"},
   {  "vnode",	kdbm_vnode,	"<vnode>", "Dump vnode"},
-#ifdef XFS_VNODE_TRACE
-  {  "vntrace",	kdbm_vntrace,	"<vntrace>", "Dump vnode Trace"},
-  {  "vntraceaddr",	kdbm_vntraceaddr, "<vntrace>",
-				"Dump vnode Trace by Address"},
+#ifdef XFS_INODE_TRACE
+  {  "iptrace",	kdbm_iptrace,	"<iptrace>", "Dump inode Trace"},
+  {  "iptraceaddr",	kdbm_iptraceaddr, "<iptrace>",
+				"Dump inode Trace by Address"},
 #endif
   {  "xagf",	kdbm_xfs_xagf,	"<agf>",
 				"Dump XFS allocation group freespace" },
@@ -6603,7 +6603,7 @@ xfsidbg_xnode(xfs_inode_t *ip)
 	kdb_printf("size %lld\n",
 		ip->i_size);
 
-#ifdef	XFS_VNODE_TRACE
+#ifdef	XFS_INODE_TRACE
 	qprintf(" trace 0x%p\n", ip->i_trace);
 #endif
 #ifdef XFS_BMAP_TRACE
