Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 08:31:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1EGVJW5029623
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 08:31:20 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5DB2E1C2D7
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 08:31:42 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 6UjEXHKa6eYrTdrE for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 08:31:42 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1EGVaF3031701
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 17:31:36 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1EGVawc031699
	for xfs@oss.sgi.com; Thu, 14 Feb 2008 17:31:36 +0100
Date: Thu, 14 Feb 2008 17:31:35 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill xfs_rwlock/xfs_rwunlock
Message-ID: <20080214163135.GA31502@lst.de>
References: <20080103125641.GC5331@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103125641.GC5331@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Jan 03, 2008 at 01:56:41PM +0100, Christoph Hellwig wrote:
> We can just use xfs_ilock/xfs_iunlock instead and get rid of the ugly
> bhv_vrwlock_t.

Here's an updated version that applies after the refcache removal and
the successive fixup have hit the tree:

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-02-08 05:20:51.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-02-14 17:15:57.000000000 +0100
@@ -138,7 +138,7 @@ xfs_dm_send_data_event(
 	xfs_off_t	offset,
 	size_t		length,
 	int		flags,
-	bhv_vrwlock_t	*locktype)
+	int		*lock_flags)
 {
 	int		error;
 	xfs_inode_t	*ip;
@@ -150,8 +150,8 @@ xfs_dm_send_data_event(
 	ip = xfs_vtoi(vp);
 	do {
 		dmstate = ip->i_d.di_dmstate;
-		if (locktype)
-			xfs_rwunlock(ip, *locktype);
+		if (lock_flags)
+			xfs_iunlock(ip, *lock_flags);
 
 		up_rw_sems(inode, flags);
 
@@ -161,8 +161,8 @@ xfs_dm_send_data_event(
 
 		down_rw_sems(inode, flags);
 
-		if (locktype)
-			xfs_rwlock(ip, *locktype);
+		if (lock_flags)
+			xfs_ilock(ip, *lock_flags);
 	} while (!error && (ip->i_d.di_dmstate != dmstate));
 
 	return error;
@@ -3085,7 +3085,6 @@ xfs_dm_send_mmap_event(
 	xfs_inode_t	*ip;
 	int		error = 0;
 	dm_eventtype_t	max_event = DM_EVENT_READ;
-	bhv_vrwlock_t	locktype;
 	xfs_fsize_t	filesize;
 	xfs_off_t	length, end_of_area, evsize, offset;
 	int		iolock;
@@ -3140,20 +3139,16 @@ xfs_dm_send_mmap_event(
 	if (evsize < 0)
 		evsize = 0;
 
-	if (max_event == DM_EVENT_READ) {
-		locktype = VRWLOCK_READ;
+	if (max_event == DM_EVENT_READ)
 		iolock = XFS_IOLOCK_SHARED;
-	}
-	else {
-		locktype = VRWLOCK_WRITE;
+	else
 		iolock = XFS_IOLOCK_EXCL;
-	}
 
 	xfs_ilock(ip, iolock);
 	/* If write possible, try a DMAPI write event */
 	if (max_event == DM_EVENT_WRITE && DM_EVENT_ENABLED(ip, max_event)) {
 		error = xfs_dm_send_data_event(max_event, vp, offset,
-					       evsize, 0, &locktype);
+					       evsize, 0, &iolock);
 		goto out_unlock;
 	}
 
@@ -3162,7 +3157,7 @@ xfs_dm_send_mmap_event(
 	 */
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ)) {
 		error = xfs_dm_send_data_event(DM_EVENT_READ, vp, offset,
-					       evsize, 0, &locktype);
+					       evsize, 0, &iolock);
 	}
 out_unlock:
 	xfs_iunlock(ip, iolock);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2008-02-08 05:20:52.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2008-02-14 17:15:57.000000000 +0100
@@ -1532,9 +1532,9 @@ xfs_vm_bmap(
 	struct xfs_inode	*ip = XFS_I(inode);
 
 	xfs_itrace_entry(XFS_I(inode));
-	xfs_rwlock(ip, VRWLOCK_READ);
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
-	xfs_rwunlock(ip, VRWLOCK_READ);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-02-13 14:24:34.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-02-14 17:15:57.000000000 +0100
@@ -262,8 +262,6 @@ EXPORT_SYMBOL(xfs_mountfs);
 EXPORT_SYMBOL(xfs_qm_dqcheck);
 EXPORT_SYMBOL(xfs_readsb);
 EXPORT_SYMBOL(xfs_read_buf);
-EXPORT_SYMBOL(xfs_rwlock);
-EXPORT_SYMBOL(xfs_rwunlock);
 EXPORT_SYMBOL(xfs_setattr);
 EXPORT_SYMBOL(xfs_attr_get);
 EXPORT_SYMBOL(xfs_attr_set);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-02-08 05:20:52.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-02-14 17:15:57.000000000 +0100
@@ -228,11 +228,11 @@ xfs_read(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
-		bhv_vrwlock_t locktype = VRWLOCK_READ;
 		int dmflags = FILP_DELAY_FLAG(file) | DM_SEM_FLAG_RD(ioflags);
+		int iolock = XFS_IOLOCK_SHARED;
 
 		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, vp, *offset, size,
-					dmflags, &locktype);
+					dmflags, &iolock);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 			if (unlikely(ioflags & IO_ISDIRECT))
@@ -287,11 +287,11 @@ xfs_splice_read(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
-		bhv_vrwlock_t locktype = VRWLOCK_READ;
+		int iolock = XFS_IOLOCK_SHARED;
 		int error;
 
 		error = XFS_SEND_DATA(mp, DM_EVENT_READ, vp, *ppos, count,
-					FILP_DELAY_FLAG(infilp), &locktype);
+					FILP_DELAY_FLAG(infilp), &iolock);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 			return -error;
@@ -330,11 +330,11 @@ xfs_splice_write(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) && !(ioflags & IO_INVIS)) {
-		bhv_vrwlock_t locktype = VRWLOCK_WRITE;
+		int iolock = XFS_IOLOCK_EXCL;
 		int error;
 
 		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, vp, *ppos, count,
-					FILP_DELAY_FLAG(outfilp), &locktype);
+					FILP_DELAY_FLAG(outfilp), &iolock);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return -error;
@@ -580,7 +580,6 @@ xfs_write(
 	xfs_fsize_t		isize, new_size;
 	int			iolock;
 	int			eventsent = 0;
-	bhv_vrwlock_t		locktype;
 	size_t			ocount = 0, count;
 	loff_t			pos;
 	int			need_i_mutex;
@@ -607,11 +606,9 @@ xfs_write(
 relock:
 	if (ioflags & IO_ISDIRECT) {
 		iolock = XFS_IOLOCK_SHARED;
-		locktype = VRWLOCK_WRITE_DIRECT;
 		need_i_mutex = 0;
 	} else {
 		iolock = XFS_IOLOCK_EXCL;
-		locktype = VRWLOCK_WRITE;
 		need_i_mutex = 1;
 		mutex_lock(&inode->i_mutex);
 	}
@@ -635,8 +632,7 @@ start:
 
 		xfs_iunlock(xip, XFS_ILOCK_EXCL);
 		error = XFS_SEND_DATA(xip->i_mount, DM_EVENT_WRITE, vp,
-				      pos, count,
-				      dmflags, &locktype);
+				      pos, count, dmflags, &iolock);
 		if (error) {
 			goto out_unlock_internal;
 		}
@@ -667,7 +663,6 @@ start:
 		if (!need_i_mutex && (VN_CACHED(vp) || pos > xip->i_size)) {
 			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
-			locktype = VRWLOCK_WRITE;
 			need_i_mutex = 1;
 			mutex_lock(&inode->i_mutex);
 			xfs_ilock(xip, XFS_ILOCK_EXCL|iolock);
@@ -744,7 +739,6 @@ retry:
 			mutex_unlock(&inode->i_mutex);
 
 			iolock = XFS_IOLOCK_SHARED;
-			locktype = VRWLOCK_WRITE_DIRECT;
 			need_i_mutex = 0;
 		}
 
@@ -781,7 +775,7 @@ retry:
 
 	if (ret == -ENOSPC &&
 	    DM_EVENT_ENABLED(xip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
-		xfs_rwunlock(xip, locktype);
+		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
 		error = XFS_SEND_NAMESP(xip->i_mount, DM_EVENT_NOSPACE, vp,
@@ -789,7 +783,7 @@ retry:
 				0, 0, 0); /* Delay flag intentionally  unused */
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_rwlock(xip, locktype);
+		xfs_ilock(xip, iolock);
 		if (error)
 			goto out_unlock_internal;
 		pos = xip->i_size;
@@ -817,7 +811,8 @@ retry:
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
 		int error2;
-		xfs_rwunlock(xip, locktype);
+
+		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
 		error2 = sync_page_range(inode, mapping, pos, ret);
@@ -825,7 +820,7 @@ retry:
 			error = error2;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_rwlock(xip, locktype);
+		xfs_ilock(xip, iolock);
 		error2 = xfs_write_sync_logforce(mp, xip);
 		if (!error)
 			error = error2;
@@ -846,7 +841,7 @@ retry:
 			xip->i_d.di_size = xip->i_size;
 		xfs_iunlock(xip, XFS_ILOCK_EXCL);
 	}
-	xfs_rwunlock(xip, locktype);
+	xfs_iunlock(xip, iolock);
  out_unlock_mutex:
 	if (need_i_mutex)
 		mutex_unlock(&inode->i_mutex);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-02-14 17:15:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-02-14 17:15:57.000000000 +0100
@@ -46,18 +46,6 @@ static inline struct inode *vn_to_inode(
 }
 
 /*
- * Values for the vop_rwlock/rwunlock flags parameter.
- */
-typedef enum bhv_vrwlock {
-	VRWLOCK_NONE,
-	VRWLOCK_READ,
-	VRWLOCK_WRITE,
-	VRWLOCK_WRITE_DIRECT,
-	VRWLOCK_TRY_READ,
-	VRWLOCK_TRY_WRITE
-} bhv_vrwlock_t;
-
-/*
  * Return values for xfs_inactive.  A return value of
  * VN_INACTIVE_NOCACHE implies that the file system behavior
  * has disassociated its state and bhv_desc_t from the vnode.
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-02-14 17:15:50.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-02-14 17:15:57.000000000 +0100
@@ -67,7 +67,7 @@ struct xfs_mru_cache;
  */
 
 typedef int	(*xfs_send_data_t)(int, bhv_vnode_t *,
-			xfs_off_t, size_t, int, bhv_vrwlock_t *);
+			xfs_off_t, size_t, int, int *);
 typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
 typedef int	(*xfs_send_destroy_t)(bhv_vnode_t *, dm_right_t);
 typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-02-14 17:15:53.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-02-14 17:16:23.000000000 +0100
@@ -3375,47 +3375,6 @@ std_return:
 }
 
 int
-xfs_rwlock(
-	xfs_inode_t	*ip,
-	bhv_vrwlock_t	locktype)
-{
-	if (S_ISDIR(ip->i_d.di_mode))
-		return 1;
-	if (locktype == VRWLOCK_WRITE) {
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	} else if (locktype == VRWLOCK_TRY_READ) {
-		return xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED);
-	} else if (locktype == VRWLOCK_TRY_WRITE) {
-		return xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL);
-	} else {
-		ASSERT((locktype == VRWLOCK_READ) ||
-		       (locktype == VRWLOCK_WRITE_DIRECT));
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-
-	return 1;
-}
-
-
-void
-xfs_rwunlock(
-	xfs_inode_t     *ip,
-	bhv_vrwlock_t	locktype)
-{
- 	if (S_ISDIR(ip->i_d.di_mode))
-  		return;
-	if (locktype == VRWLOCK_WRITE) {
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	} else {
-		ASSERT((locktype == VRWLOCK_READ) ||
-		       (locktype == VRWLOCK_WRITE_DIRECT));
-		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-	}
-	return;
-}
-
-
-int
 xfs_inode_flush(
 	xfs_inode_t	*ip,
 	int		flags)
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-02-08 05:20:52.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-02-14 17:15:57.000000000 +0100
@@ -38,8 +38,6 @@ int xfs_readdir(struct xfs_inode	*dp, vo
 int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
 		char *target_path, mode_t mode, bhv_vnode_t **vpp,
 		struct cred *credp);
-int xfs_rwlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
-void xfs_rwunlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
 int xfs_inode_flush(struct xfs_inode *ip, int flags);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
 int xfs_reclaim(struct xfs_inode *ip);
