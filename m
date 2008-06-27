Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 08:45:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RFjBvT028942
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:45:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B20DBD69CE1
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:46:11 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id WnC2AAWPI3T7zAuF for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:46:11 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5RFk2NW031814
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:46:02 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5RFk20g031812
	for xfs@oss.sgi.com; Fri, 27 Jun 2008 17:46:02 +0200
Date: Fri, 27 Jun 2008 17:46:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] kill vn_revalidate
Message-ID: <20080627154602.GC31476@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

These days most of the attributes in struct inode are properly kept in
sync by XFS.  This patch removes the need for vn_revalidate completely
by:

 - keeping inode.i_flags uptodate after any flags are updated in
   xfs_ioctl_setattr
 - keeping i_mode, i_uid and i_gid uptodate in xfs_setattr


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-06-19 14:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-06-19 14:18:13.000000000 +0200
@@ -2663,7 +2663,6 @@ xfs_dm_set_fileattr(
 {
 	dm_fileattr_t	stat;
 	struct iattr	iattr;
-	int		error;
 
 	/* Returns negative errors to DMAPI */
 
@@ -2718,10 +2717,7 @@ xfs_dm_set_fileattr(
 		iattr.ia_size = stat.fa_size;
 	}
 
-	error = xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_DMI, NULL);
-	if (!error)
-		vn_revalidate(vn_from_inode(inode));	/* update Linux inode flags */
-	return(-error); /* Return negative error to DMAPI */
+	return -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_DMI, NULL);
 }
 
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_acl.c	2008-06-19 14:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_acl.c	2008-06-19 14:18:13.000000000 +0200
@@ -278,7 +278,6 @@ xfs_set_mode(struct inode *inode, mode_t
 		iattr.ia_mode = mode;
 
 		error = -xfs_setattr(XFS_I(inode), &iattr, 0, sys_cred);
-		inode->i_mode = mode;
 	}
 
 	return error;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-19 14:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-19 14:18:13.000000000 +0200
@@ -919,6 +919,30 @@ xfs_set_diflags(
 	ip->i_d.di_flags = di_flags;
 }
 
+STATIC void
+xfs_diflags_to_linux(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = XFS_ITOV(ip);
+	unsigned int		xflags = xfs_ip2xflags(ip);
+
+	if (xflags & XFS_XFLAG_IMMUTABLE)
+		inode->i_flags |= S_IMMUTABLE;
+	else
+		inode->i_flags &= ~S_IMMUTABLE;
+	if (xflags & XFS_XFLAG_APPEND)
+		inode->i_flags |= S_APPEND;
+	else
+		inode->i_flags &= ~S_APPEND;
+	if (xflags & XFS_XFLAG_SYNC)
+		inode->i_flags |= S_SYNC;
+	else
+		inode->i_flags &= ~S_SYNC;
+	if (xflags & XFS_XFLAG_NOATIME)
+		inode->i_flags |= S_NOATIME;
+	else
+		inode->i_flags &= ~S_NOATIME;
+}
 
 #define FSX_PROJID	1
 #define FSX_EXTSIZE	2
@@ -1117,8 +1141,10 @@ xfs_ioctl_setattr(
 
 	if (mask & FSX_EXTSIZE)
 		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
-	if (mask & FSX_XFLAGS)
+	if (mask & FSX_XFLAGS) {
 		xfs_set_diflags(ip, fa->fsx_xflags);
+		xfs_diflags_to_linux(ip);
+	}
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
@@ -1156,7 +1182,6 @@ xfs_ioctl_setattr(
 				(mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
 	}
 
-	vn_revalidate(XFS_ITOV(ip));	/* update flags */
 	return 0;
 
  error_return:
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-06-19 14:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-06-19 14:18:13.000000000 +0200
@@ -624,18 +624,7 @@ xfs_vn_setattr(
 	struct inode	*inode = dentry->d_inode;
 	int		error;
 
-	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
-
-	if (iattr->ia_valid & ATTR_MODE) {
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			inode->i_mode &= ~S_ISGID;
-	}
-
 	error = xfs_setattr(XFS_I(inode), iattr, 0, NULL);
-	if (likely(!error))
-		vn_revalidate(vn_from_inode(inode));
-
 	if (!error && (iattr->ia_valid & ATTR_MODE))
 		error = -xfs_acl_chmod(inode);
 	return -error;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-06-19 14:18:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-06-19 14:18:25.000000000 +0200
@@ -175,7 +175,6 @@ EXPORT_SYMBOL(uuid_hash64);
 EXPORT_SYMBOL(uuid_is_nil);
 EXPORT_SYMBOL(uuid_table_remove);
 EXPORT_SYMBOL(vn_hold);
-EXPORT_SYMBOL(vn_revalidate);
 
 EXPORT_SYMBOL(xfs_alloc_buftarg);
 EXPORT_SYMBOL(xfs_flush_buftarg);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-06-19 14:17:04.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-06-19 14:18:13.000000000 +0200
@@ -82,56 +82,6 @@ vn_ioerror(
 		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ, f, l);
 }
 
-/*
- * Revalidate the Linux inode from the XFS inode.
- * Note: i_size _not_ updated; we must hold the inode
- * semaphore when doing that - callers responsibility.
- */
-int
-vn_revalidate(
-	bhv_vnode_t		*vp)
-{
-	struct inode		*inode = vn_to_inode(vp);
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	unsigned long		xflags;
-
-	xfs_itrace_entry(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	inode->i_mode	    = ip->i_d.di_mode;
-	inode->i_uid	    = ip->i_d.di_uid;
-	inode->i_gid	    = ip->i_d.di_gid;
-	inode->i_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
-	inode->i_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
-	inode->i_ctime.tv_sec = ip->i_d.di_ctime.t_sec;
-	inode->i_ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
-
-	xflags = xfs_ip2xflags(ip);
-	if (xflags & XFS_XFLAG_IMMUTABLE)
-		inode->i_flags |= S_IMMUTABLE;
-	else
-		inode->i_flags &= ~S_IMMUTABLE;
-	if (xflags & XFS_XFLAG_APPEND)
-		inode->i_flags |= S_APPEND;
-	else
-		inode->i_flags &= ~S_APPEND;
-	if (xflags & XFS_XFLAG_SYNC)
-		inode->i_flags |= S_SYNC;
-	else
-		inode->i_flags &= ~S_SYNC;
-	if (xflags & XFS_XFLAG_NOATIME)
-		inode->i_flags |= S_NOATIME;
-	else
-		inode->i_flags &= ~S_NOATIME;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	xfs_iflags_clear(ip, XFS_IMODIFIED);
-	return 0;
-}
 
 /*
  * Add a reference to a referenced vnode.
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-06-19 14:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-06-19 14:18:13.000000000 +0200
@@ -67,7 +67,6 @@ static inline struct inode *vn_to_inode(
 
 
 extern void	vn_init(void);
-extern int	vn_revalidate(bhv_vnode_t *);
 
 /*
  * Yeah, these don't take vnode anymore at all, all this should be
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-06-19 14:18:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-06-19 14:18:13.000000000 +0200
@@ -83,6 +83,7 @@ xfs_setattr(
 	cred_t			*credp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
+	struct inode		*inode = XFS_ITOV(ip);
 	int			mask = iattr->ia_valid;
 	xfs_trans_t		*tp;
 	int			code;
@@ -446,6 +447,9 @@ xfs_setattr(
 		ip->i_d.di_mode &= S_IFMT;
 		ip->i_d.di_mode |= iattr->ia_mode & ~S_IFMT;
 
+		inode->i_mode &= S_IFMT;
+		inode->i_mode |= iattr->ia_mode & ~S_IFMT;
+
 		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
 		timeflags |= XFS_ICHGTIME_CHG;
 	}
@@ -481,6 +485,7 @@ xfs_setattr(
 							&ip->i_udquot, udqp);
 			}
 			ip->i_d.di_uid = uid;
+			inode->i_uid = uid;
 		}
 		if (igid != gid) {
 			if (XFS_IS_GQUOTA_ON(mp)) {
@@ -491,6 +496,7 @@ xfs_setattr(
 							&ip->i_gdquot, gdqp);
 			}
 			ip->i_d.di_gid = gid;
+			inode->i_gid = gid;
 		}
 
 		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
@@ -503,12 +509,14 @@ xfs_setattr(
 	 */
 	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
 		if (mask & ATTR_ATIME) {
+			inode->i_atime = iattr->ia_atime;
 			ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
 			ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
 			ip->i_update_core = 1;
 			timeflags &= ~XFS_ICHGTIME_ACC;
 		}
 		if (mask & ATTR_MTIME) {
+			inode->i_mtime = iattr->ia_mtime;
 			ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
 			ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
 			timeflags &= ~XFS_ICHGTIME_MOD;
@@ -524,6 +532,7 @@ xfs_setattr(
 	 */
 
 	if ((flags & XFS_ATTR_DMI) && (mask & ATTR_CTIME)) {
+		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
 		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
 		ip->i_update_core = 1;
