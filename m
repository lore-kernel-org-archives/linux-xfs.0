Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 02:12:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3D9CDQw018552
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:12:14 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A30B71296470
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:12:51 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id RKfE0q1Bg1p64Bz6 for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:12:51 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3D9CjF3020166
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 11:12:45 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3D9CjPK020164
	for xfs@oss.sgi.com; Sun, 13 Apr 2008 11:12:45 +0200
Date: Sun, 13 Apr 2008 11:12:45 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill xfs_getattr
Message-ID: <20080413091245.GB20022@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

It's currently used by the ACL code to read di_mode/di_uid, but these
are simple 32bit scalar values we can just read directly without
locking.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-04-11 12:39:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2008-04-11 12:48:48.000000000 +0200
@@ -238,15 +238,8 @@ xfs_acl_vget(
 			error = EINVAL;
 			goto out;
 		}
-		if (kind == _ACL_TYPE_ACCESS) {
-			bhv_vattr_t	va;
-
-			va.va_mask = XFS_AT_MODE;
-			error = xfs_getattr(xfs_vtoi(vp), &va, 0);
-			if (error)
-				goto out;
-			xfs_acl_sync_mode(va.va_mode, xfs_acl);
-		}
+		if (kind == _ACL_TYPE_ACCESS)
+			xfs_acl_sync_mode(xfs_vtoi(vp)->i_d.di_mode, xfs_acl);
 		error = -posix_acl_xfs_to_xattr(xfs_acl, ext_acl, size);
 	}
 out:
@@ -373,23 +366,15 @@ xfs_acl_allow_set(
 	bhv_vnode_t	*vp,
 	int		kind)
 {
-	xfs_inode_t	*ip = xfs_vtoi(vp);
-	bhv_vattr_t	va;
-	int		error;
-
 	if (vp->i_flags & (S_IMMUTABLE|S_APPEND))
 		return EPERM;
 	if (kind == _ACL_TYPE_DEFAULT && !S_ISDIR(vp->i_mode))
 		return ENOTDIR;
 	if (vp->i_sb->s_flags & MS_RDONLY)
 		return EROFS;
-	va.va_mask = XFS_AT_UID;
-	error = xfs_getattr(ip, &va, 0);
-	if (error)
-		return error;
-	if (va.va_uid != current->fsuid && !capable(CAP_FOWNER))
+	if (xfs_vtoi(vp)->i_d.di_uid != current->fsuid && !capable(CAP_FOWNER))
 		return EPERM;
-	return error;
+	return 0;
 }
 
 /*
@@ -644,7 +629,6 @@ xfs_acl_vtoacl(
 	xfs_acl_t	*access_acl,
 	xfs_acl_t	*default_acl)
 {
-	bhv_vattr_t	va;
 	int		error = 0;
 
 	if (access_acl) {
@@ -653,16 +637,10 @@ xfs_acl_vtoacl(
 		 * be obtained for some reason, invalidate the access ACL.
 		 */
 		xfs_acl_get_attr(vp, access_acl, _ACL_TYPE_ACCESS, 0, &error);
-		if (!error) {
-			/* Got the ACL, need the mode... */
-			va.va_mask = XFS_AT_MODE;
-			error = xfs_getattr(xfs_vtoi(vp), &va, 0);
-		}
-
 		if (error)
 			access_acl->acl_cnt = XFS_ACL_NOT_PRESENT;
 		else /* We have a good ACL and the file mode, synchronize. */
-			xfs_acl_sync_mode(va.va_mode, access_acl);
+			xfs_acl_sync_mode(xfs_vtoi(vp)->i_d.di_mode, access_acl);
 	}
 
 	if (default_acl) {
@@ -745,7 +723,7 @@ xfs_acl_setmode(
 	bhv_vattr_t	va;
 	xfs_acl_entry_t	*ap;
 	xfs_acl_entry_t	*gap = NULL;
-	int		i, error, nomask = 1;
+	int		i, nomask = 1;
 
 	*basicperms = 1;
 
@@ -757,11 +735,7 @@ xfs_acl_setmode(
 	 * mode.  The m:: bits take precedence over the g:: bits.
 	 */
 	va.va_mask = XFS_AT_MODE;
-	error = xfs_getattr(xfs_vtoi(vp), &va, 0);
-	if (error)
-		return error;
-
-	va.va_mask = XFS_AT_MODE;
+	va.va_mode = xfs_vtoi(vp)->i_d.di_mode;
 	va.va_mode &= ~(S_IRWXU|S_IRWXG|S_IRWXO);
 	ap = acl->acl_entry;
 	for (i = 0; i < acl->acl_cnt; ++i) {
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-11 12:39:30.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-11 12:47:06.000000000 +0200
@@ -76,132 +76,6 @@ xfs_open(
 }
 
 /*
- * xfs_getattr
- */
-int
-xfs_getattr(
-	xfs_inode_t	*ip,
-	bhv_vattr_t	*vap,
-	int		flags)
-{
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
-	xfs_mount_t	*mp = ip->i_mount;
-
-	xfs_itrace_entry(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
-
-	if (!(flags & ATTR_LAZY))
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-
-	vap->va_size = XFS_ISIZE(ip);
-	if (vap->va_mask == XFS_AT_SIZE)
-		goto all_done;
-
-	vap->va_nblocks =
-		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
-	vap->va_nodeid = ip->i_ino;
-#if XFS_BIG_INUMS
-	vap->va_nodeid += mp->m_inoadd;
-#endif
-	vap->va_nlink = ip->i_d.di_nlink;
-
-	/*
-	 * Quick exit for non-stat callers
-	 */
-	if ((vap->va_mask &
-	    ~(XFS_AT_SIZE|XFS_AT_FSID|XFS_AT_NODEID|
-	      XFS_AT_NLINK|XFS_AT_BLKSIZE)) == 0)
-		goto all_done;
-
-	/*
-	 * Copy from in-core inode.
-	 */
-	vap->va_mode = ip->i_d.di_mode;
-	vap->va_uid = ip->i_d.di_uid;
-	vap->va_gid = ip->i_d.di_gid;
-	vap->va_projid = ip->i_d.di_projid;
-
-	/*
-	 * Check vnode type block/char vs. everything else.
-	 */
-	switch (ip->i_d.di_mode & S_IFMT) {
-	case S_IFBLK:
-	case S_IFCHR:
-		vap->va_rdev = ip->i_df.if_u2.if_rdev;
-		vap->va_blocksize = BLKDEV_IOSIZE;
-		break;
-	default:
-		vap->va_rdev = 0;
-
-		if (!(XFS_IS_REALTIME_INODE(ip))) {
-			vap->va_blocksize = xfs_preferred_iosize(mp);
-		} else {
-
-			/*
-			 * If the file blocks are being allocated from a
-			 * realtime partition, then return the inode's
-			 * realtime extent size or the realtime volume's
-			 * extent size.
-			 */
-			vap->va_blocksize =
-				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
-		}
-		break;
-	}
-
-	vn_atime_to_timespec(vp, &vap->va_atime);
-	vap->va_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
-	vap->va_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
-	vap->va_ctime.tv_sec = ip->i_d.di_ctime.t_sec;
-	vap->va_ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
-
-	/*
-	 * Exit for stat callers.  See if any of the rest of the fields
-	 * to be filled in are needed.
-	 */
-	if ((vap->va_mask &
-	     (XFS_AT_XFLAGS|XFS_AT_EXTSIZE|XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|
-	      XFS_AT_GENCOUNT|XFS_AT_VCODE)) == 0)
-		goto all_done;
-
-	/*
-	 * Convert di_flags to xflags.
-	 */
-	vap->va_xflags = xfs_ip2xflags(ip);
-
-	/*
-	 * Exit for inode revalidate.  See if any of the rest of
-	 * the fields to be filled in are needed.
-	 */
-	if ((vap->va_mask &
-	     (XFS_AT_EXTSIZE|XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|
-	      XFS_AT_GENCOUNT|XFS_AT_VCODE)) == 0)
-		goto all_done;
-
-	vap->va_extsize = ip->i_d.di_extsize << mp->m_sb.sb_blocklog;
-	vap->va_nextents =
-		(ip->i_df.if_flags & XFS_IFEXTENTS) ?
-			ip->i_df.if_bytes / sizeof(xfs_bmbt_rec_t) :
-			ip->i_d.di_nextents;
-	if (ip->i_afp)
-		vap->va_anextents =
-			(ip->i_afp->if_flags & XFS_IFEXTENTS) ?
-				ip->i_afp->if_bytes / sizeof(xfs_bmbt_rec_t) :
-				 ip->i_d.di_anextents;
-	else
-		vap->va_anextents = 0;
-	vap->va_gen = ip->i_d.di_gen;
-
- all_done:
-	if (!(flags & ATTR_LAZY))
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return 0;
-}
-
-
-/*
  * xfs_setattr
  */
 int
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-04-11 12:47:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-04-11 12:47:11.000000000 +0200
@@ -15,7 +15,6 @@ struct xfs_iomap;
 
 
 int xfs_open(struct xfs_inode *ip);
-int xfs_getattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags);
 int xfs_setattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags,
 		struct cred *credp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
