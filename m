Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:38:15 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJc94p003015
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:38:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJc7A5008515
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:38:07 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJc7Ts008513
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:38:07 +0200
Date: Thu, 23 Aug 2007 21:38:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/17] kill the v_flag member in struct bhv_vnode
Message-ID: <20070823193807.GE8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


All flags previous handled at the vnode level are not in the xfs_inode
where we already have a flags mechanisms and free bits for flags
previously in the vnode.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-13 18:00:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-13 18:00:51.000000000 +0200
@@ -2599,7 +2599,7 @@ xfs_dm_punch_hole(
 	/* Let threads in send_data_event know we punched the file. */
 	ip->i_iocore.io_dmstate++;
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	VMODIFY(vp);
+	xfs_iflags_set(ip, XFS_IMODIFIED);
 
 up_and_out:
 	up_rw_sems(inode, DM_SEM_FLAG_WR);
@@ -2988,7 +2988,7 @@ xfs_dm_sync_by_handle(
 	dm_right_t	right)
 {
 	int		err, ret;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
+	xfs_inode_t	*ip = XFS_I(inode);
 
 	/* Returns negative errors to DMAPI */
 	if (right < DM_RIGHT_EXCL)
@@ -2997,7 +2997,7 @@ xfs_dm_sync_by_handle(
 	/* We need to protect against concurrent writers.. */
 	ret = filemap_fdatawrite(inode->i_mapping);
 	down_rw_sems(inode, DM_FLAGS_IMUX);
-	err = xfs_fsync(XFS_I(inode), FSYNC_WAIT, 0, -1);
+	err = xfs_fsync(ip, FSYNC_WAIT, 0, -1);
 	if (!ret)
 		ret = err;
 	up_rw_sems(inode, DM_FLAGS_IMUX);
@@ -3005,9 +3005,7 @@ xfs_dm_sync_by_handle(
 	if (!ret)
 		ret = err;
 
-	if (VN_TRUNC(vp))
-		VUNTRUNCATE(vp);
-
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	if (ret > 0)
 		ret = -ret;	/* Return negative errors to DMAPI */
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-08-13 18:00:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-08-13 18:00:51.000000000 +0200
@@ -303,13 +303,13 @@ xfs_map_blocks(
 	xfs_iomap_t		*mapp,
 	int			flags)
 {
-	bhv_vnode_t		*vp = vn_from_inode(inode);
+	xfs_inode_t		*ip = XFS_I(inode);
 	int			error, nmaps = 1;
 
-	error = xfs_bmap(xfs_vtoi(vp), offset, count,
+	error = xfs_bmap(ip, offset, count,
 				flags, mapp, &nmaps);
 	if (!error && (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)))
-		VMODIFY(vp);
+		xfs_iflags_set(ip, XFS_IMODIFIED);
 	return -error;
 }
 
@@ -1245,10 +1245,7 @@ xfs_vm_writepages(
 	struct address_space	*mapping,
 	struct writeback_control *wbc)
 {
-	struct bhv_vnode	*vp = vn_from_inode(mapping->host);
-
-	if (VN_TRUNC(vp))
-		VUNTRUNCATE(vp);
+	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return generic_writepages(mapping, wbc);
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2007-08-13 18:00:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2007-08-13 18:00:51.000000000 +0200
@@ -217,13 +217,11 @@ xfs_file_fsync(
 	struct dentry	*dentry,
 	int		datasync)
 {
-	bhv_vnode_t	*vp = vn_from_inode(dentry->d_inode);
 	int		flags = FSYNC_WAIT;
 
 	if (datasync)
 		flags |= FSYNC_DATA;
-	if (VN_TRUNC(vp))
-		VUNTRUNCATE(vp);
+	xfs_iflags_clear(XFS_I(dentry->d_inode), XFS_ITRUNCATED);
 	return -xfs_fsync(XFS_I(dentry->d_inode), flags,
 			(xfs_off_t)0, (xfs_off_t)-1);
 }
@@ -300,10 +298,9 @@ xfs_file_ioctl(
 {
 	int		error;
 	struct inode	*inode = filp->f_path.dentry->d_inode;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	error = xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
-	VMODIFY(vp);
+	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
 	 *	  byte count indicating success, such as
@@ -322,10 +319,9 @@ xfs_file_ioctl_invis(
 {
 	int		error;
 	struct inode	*inode = filp->f_path.dentry->d_inode;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	error = xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
-	VMODIFY(vp);
+	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
 	 *	  byte count indicating success, such as
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-08-13 18:00:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-08-13 18:00:51.000000000 +0200
@@ -61,8 +61,7 @@ xfs_flushinval_pages(
 	int		ret = 0;
 
 	if (VN_CACHED(vp)) {
-		if (VN_TRUNC(vp))
-			VUNTRUNCATE(vp);
+		xfs_iflags_clear(ip, XFS_ITRUNCATED);
 		ret = filemap_write_and_wait(inode->i_mapping);
 		if (!ret)
 			truncate_inode_pages(inode->i_mapping, first);
@@ -84,8 +83,7 @@ xfs_flush_pages(
 	int		ret2;
 
 	if (VN_DIRTY(vp)) {
-		if (VN_TRUNC(vp))
-			VUNTRUNCATE(vp);
+		xfs_iflags_clear(ip, XFS_ITRUNCATED);
 		ret = filemap_fdatawrite(inode->i_mapping);
 		if (flags & XFS_B_ASYNC)
 			return ret;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-08-13 18:00:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-08-13 18:00:51.000000000 +0200
@@ -371,7 +371,6 @@ xfs_compat_ioctl(
 	unsigned long	arg)
 {
 	struct inode	*inode = file->f_path.dentry->d_inode;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	int		error;
 
 	switch (cmd) {
@@ -459,7 +458,7 @@ xfs_compat_ioctl(
 	}
 
 	error = xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
-	VMODIFY(vp);
+	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
 
 	return error;
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-08-13 18:00:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-08-13 18:00:51.000000000 +0200
@@ -221,7 +221,7 @@ xfs_init_security(
 	error = xfs_attr_set(XFS_I(ip), name, value,
 			length, ATTR_SECURE);
 	if (!error)
-		VMODIFY(vp);
+		xfs_iflags_set(XFS_I(ip), XFS_IMODIFIED);
 
 	kfree(name);
 	kfree(value);
@@ -327,7 +327,7 @@ xfs_vn_mknod(
 		if (!error) {
 			error = _ACL_INHERIT(vp, &vattr, default_acl);
 			if (!error)
-				VMODIFY(vp);
+				xfs_iflags_set(XFS_I(&vp->v_inode), XFS_IMODIFIED);
 			else
 				xfs_cleanup_inode(dir, vp, dentry, mode);
 		}
@@ -409,7 +409,7 @@ xfs_vn_link(
 	if (unlikely(error)) {
 		VN_RELE(vp);
 	} else {
-		VMODIFY(vn_from_inode(dir));
+		xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
 		xfs_validate_fields(ip, &vattr);
 		d_instantiate(dentry, ip);
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:00:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:00:51.000000000 +0200
@@ -197,7 +197,7 @@ xfs_revalidate_inode(
 		inode->i_flags |= S_NOATIME;
 	else
 		inode->i_flags &= ~S_NOATIME;
-	vp->v_flag &= ~VMODIFIED;
+	xfs_iflags_clear(ip, XFS_IMODIFIED);
 }
 
 void
@@ -448,13 +448,12 @@ xfs_fs_clear_inode(
 	if (XFS_I(inode))
 		xfs_inactive(XFS_I(inode));
 
-	VN_LOCK(vp);
-	vp->v_flag &= ~VMODIFIED;
-	VN_UNLOCK(vp, 0);
 
-	if (XFS_I(inode))
+	if (XFS_I(inode)) {
+		xfs_iflags_clear(XFS_I(inode), XFS_IMODIFIED);
 		if (xfs_reclaim(XFS_I(inode)))
 			panic("%s: cannot reclaim 0x%p\n", __FUNCTION__, vp);
+	}
 
 	ASSERT(XFS_I(inode) == NULL);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-13 18:00:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-13 18:00:51.000000000 +0200
@@ -84,9 +84,6 @@ vn_initialize(
 	XFS_STATS_INC(vn_active);
 	XFS_STATS_INC(vn_alloc);
 
-	vp->v_flag = VMODIFIED;
-	spinlock_init(&vp->v_lock, "v_lock");
-
 	spin_lock(&vnumber_lock);
 	if (!++vn_generation)	/* v_number shouldn't be zero */
 		vn_generation++;
@@ -157,7 +154,7 @@ __vn_revalidate(
 	error = xfs_getattr(xfs_vtoi(vp), vattr, 0);
 	if (likely(!error)) {
 		vn_revalidate_core(vp, vattr);
-		VUNMODIFY(vp);
+		xfs_iflags_clear(xfs_vtoi(vp), XFS_IMODIFIED);
 	}
 	return -error;
 }
@@ -182,10 +179,8 @@ vn_hold(
 
 	XFS_STATS_INC(vn_hold);
 
-	VN_LOCK(vp);
 	inode = igrab(vn_to_inode(vp));
 	ASSERT(inode);
-	VN_UNLOCK(vp, 0);
 
 	return vp;
 }
@@ -199,7 +194,7 @@ vn_hold(
 /*  2 */		(void *)(__psint_t) line,		\
 /*  3 */		(void *)(__psint_t)(vn_count(vp)),	\
 /*  4 */		(void *)(ra),				\
-/*  5 */		(void *)(__psunsigned_t)(vp)->v_flag,	\
+/*  5 */		NULL,					\
 /*  6 */		(void *)(__psint_t)current_cpu(),	\
 /*  7 */		(void *)(__psint_t)current_pid(),	\
 /*  8 */		(void *)__return_address,		\
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-13 18:00:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-13 18:00:51.000000000 +0200
@@ -27,20 +27,8 @@ struct attrlist_cursor_kern;
 typedef struct dentry	bhv_vname_t;
 typedef __u64		bhv_vnumber_t;
 
-typedef enum bhv_vflags {
-	VMODIFIED	= 0x08,	/* XFS inode state possibly differs */
-				/* to the Linux inode state. */
-	VTRUNCATED	= 0x40,	/* truncated down so flush-on-close */
-} bhv_vflags_t;
-
-/*
- * MP locking protocols:
- *	v_flag, 				VN_LOCK/VN_UNLOCK
- */
 typedef struct bhv_vnode {
-	bhv_vflags_t	v_flag;			/* vnode flags (see above) */
 	bhv_vnumber_t	v_number;		/* in-core vnode number */
-	spinlock_t	v_lock;			/* VN_LOCK/VN_UNLOCK */
 	atomic_t	v_iocount;		/* outstanding I/O count */
 #ifdef XFS_VNODE_TRACE
 	struct ktrace	*v_trace;		/* trace header structure    */
@@ -255,35 +243,6 @@ static inline struct bhv_vnode *vn_grab(
 #define VNAME_TO_VNODE(dentry)	(vn_from_inode((dentry)->d_inode))
 
 /*
- * Vnode spinlock manipulation.
- */
-#define VN_LOCK(vp)		mutex_spinlock(&(vp)->v_lock)
-#define VN_UNLOCK(vp, s)	mutex_spinunlock(&(vp)->v_lock, s)
-
-STATIC_INLINE void vn_flagset(struct bhv_vnode *vp, uint flag)
-{
-	spin_lock(&vp->v_lock);
-	vp->v_flag |= flag;
-	spin_unlock(&vp->v_lock);
-}
-
-STATIC_INLINE uint vn_flagclr(struct bhv_vnode *vp, uint flag)
-{
-	uint	cleared;
-
-	spin_lock(&vp->v_lock);
-	cleared = (vp->v_flag & flag);
-	vp->v_flag &= ~flag;
-	spin_unlock(&vp->v_lock);
-	return cleared;
-}
-
-#define VMODIFY(vp)	vn_flagset(vp, VMODIFIED)
-#define VUNMODIFY(vp)	vn_flagclr(vp, VMODIFIED)
-#define VTRUNCATE(vp)	vn_flagset(vp, VTRUNCATED)
-#define VUNTRUNCATE(vp)	vn_flagclr(vp, VTRUNCATED)
-
-/*
  * Dealing with bad inodes
  */
 static inline void vn_mark_bad(struct bhv_vnode *vp)
@@ -322,7 +281,6 @@ static inline void vn_atime_to_time_t(bh
 #define VN_CACHED(vp)	(vn_to_inode(vp)->i_mapping->nrpages)
 #define VN_DIRTY(vp)	mapping_tagged(vn_to_inode(vp)->i_mapping, \
 					PAGECACHE_TAG_DIRTY)
-#define VN_TRUNC(vp)	((vp)->v_flag & VTRUNCATED)
 
 /*
  * Flags to vop_setattr/getattr.
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-08-13 18:00:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-08-13 18:00:51.000000000 +0200
@@ -346,6 +346,7 @@ finish_inode:
 	ASSERT(((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) != 0) ==
 	       ((ip->i_iocore.io_flags & XFS_IOCORE_RT) != 0));
 
+	xfs_iflags_set(ip, XFS_IMODIFIED);
 	*ipp = ip;
 
 	/*
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-08-13 18:00:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-08-13 18:00:51.000000000 +0200
@@ -392,6 +392,9 @@ xfs_iflags_test(xfs_inode_t *ip, unsigne
 #define XFS_IRECLAIMABLE 0x0020 /* inode can be reclaimed */
 #define XFS_INEW	0x0040
 #define XFS_IFILESTREAM	0x0080	/* inode is in a filestream directory */
+#define XFS_IMODIFIED	0x0100	/* XFS inode state possibly differs */
+				/* to the Linux inode state. */
+#define XFS_ITRUNCATED	0x0200	/* truncated down so flush-on-close */
 
 /*
  * Flags for inode locking.
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-13 18:00:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-13 18:00:51.000000000 +0200
@@ -660,7 +660,7 @@ xfs_setattr(
 			 * vnode and flush it when the file is closed, and
 			 * do not wait the usual (long) time for writeout.
 			 */
-			VTRUNCATE(vp);
+			xfs_iflags_set(ip, XFS_ITRUNCATED);
 		}
 		/*
 		 * Have to do this even if the file's size doesn't change.
@@ -1516,6 +1516,8 @@ xfs_release(
 		return 0;
 
 	if (!XFS_FORCED_SHUTDOWN(mp)) {
+		int truncated;
+
 		/*
 		 * If we are using filestreams, and we have an unlinked
 		 * file that we are processing the last close on, then nothing
@@ -1536,7 +1538,13 @@ xfs_release(
 		 * significantly reducing the time window where we'd otherwise
 		 * be exposed to that problem.
 		 */
-		if (VUNTRUNCATE(vp) && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
+		spin_lock(&ip->i_flags_lock);
+		truncated = __xfs_iflags_test(ip, XFS_ITRUNCATED);
+		if (truncated)
+			ip->i_flags &= ~XFS_ITRUNCATED;
+		spin_unlock(&ip->i_flags_lock);
+
+		if (truncated && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
 			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
 	}
 
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-13 18:00:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-13 18:00:51.000000000 +0200
@@ -1701,47 +1701,6 @@ static int	kdbm_xfs_xtrans_res(
 	return 0;
 }
 
-/*
- * Vnode descriptor dump.
- * This table is a string version of all the flags defined in vnode.h.
- */
-char *tab_vflags[] = {
-	/* local only flags */
-	"VINACT",		/*	 0x01 */
-	"VRECLM",		/*	 0x02 */
-	"VWAIT",		/*	 0x04 */
-	"VMODIFIED",		/*	 0x08 */
-	"INVALID0x10",		/*	 0x10 */
-	"INVALID0x20",		/*	 0x20 */
-	"INVALID0x40",		/*	 0x40 */
-	"INVALID0x80",		/*	 0x80 */
-	"INVALID0x100",		/*	0x100 */
-	"INVALID0x200",		/*	0x200 */
-	"INVALID0x400",		/*	0x400 */
-	"INVALID0x800",		/*	0x800 */
-	"INVALID0x1000",	/*     0x1000 */
-	"INVALID0x2000",	/*     0x2000 */
-	"INVALID0x4000",	/*     0x4000 */
-	"INVALID0x8000",	/*     0x8000 */
-	"INVALID0x10000",	/*    0x10000 */
-	"INVALID0x20000",	/*    0x20000 */
-	"INVALID0x40000",	/*    0x40000 */
-	"INVALID0x80000",	/*    0x80000 */
-	"VROOT",		/*   0x100000 */
-	"INVALID0x200000",	/*   0x200000 */
-	"INVALID00x400000",	/*   0x400000 */
-	"INVALID0x800000",	/*   0x800000 */
-	"INVALID0x1000000",	/*  0x1000000 */
-	"INVALID0x2000000",	/*  0x2000000 */
-	"VSHARE",		/*  0x4000000 */
-	"INVALID0x8000000",     /*  0x8000000 */
-	"VENF_LOCKING",		/* 0x10000000 */
-	"VOPLOCK",		/* 0x20000000 */
-	"VPURGE",		/* 0x40000000 */
-	"INVALID0x80000000",	/* 0x80000000 */
-	NULL
-};
-
 static void
 printflags(register uint64_t flags,
 	register char **strings,
@@ -1797,7 +1756,6 @@ static void	printvnode(bhv_vnode_t *vp, 
 {
 	kdb_printf("vnode: 0x%lx\n", addr);
 
-	printflags((__psunsigned_t)vp->v_flag, tab_vflags, "flag =");
 	kdb_printf("\n");
 
 #ifdef	XFS_VNODE_TRACE
@@ -1986,8 +1944,6 @@ vn_trace_pr_entry(ktrace_entry_t *ktep)
 	kdb_printf("  cpu = %ld pid = %d ",
 			(long)ktep->val[6], (pid_t)ktep->val[7]);
 
-	printflags((__psunsigned_t)ktep->val[5], tab_vflags, "flag =");
-
 	if (kdbnearsym((unsigned int)ktep->val[4], &symtab)) {
 		unsigned long offval;
 
@@ -6697,6 +6653,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 		"quiesce",	/* XFS_IQUIESCE */
 		"reclaim",	/* XFS_IRECLAIM */
 		"stale",	/* XFS_ISTALE */
+		"modified",	/* XFS_IMODIFIED */
+		"truncated",	/* XFS_ITRUNCATED */
 		NULL
 	};
 
