Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 02:10:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3D9ALSL017990
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:10:23 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E720C1296432
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:11:00 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id IiXTiy6GvwruQRF5 for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:11:00 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3D9ArF3020078
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 11:10:54 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3D9AroF020076
	for xfs@oss.sgi.com; Sun, 13 Apr 2008 11:10:53 +0200
Date: Sun, 13 Apr 2008 11:10:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] VN_IS* macros and related cruft
Message-ID: <20080413091053.GA20022@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We can just check i_mode / di_mode directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-04-11 12:24:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-04-11 12:31:14.000000000 +0200
@@ -25,12 +25,6 @@ struct attrlist_cursor_kern;
 
 typedef struct inode	bhv_vnode_t;
 
-#define VN_ISLNK(vp)	S_ISLNK((vp)->i_mode)
-#define VN_ISREG(vp)	S_ISREG((vp)->i_mode)
-#define VN_ISDIR(vp)	S_ISDIR((vp)->i_mode)
-#define VN_ISCHR(vp)	S_ISCHR((vp)->i_mode)
-#define VN_ISBLK(vp)	S_ISBLK((vp)->i_mode)
-
 /*
  * Vnode to Linux inode mapping.
  */
@@ -151,24 +145,6 @@ typedef struct bhv_vattr {
 		XFS_AT_TYPE|XFS_AT_BLKSIZE|XFS_AT_NBLOCKS|XFS_AT_VCODE|\
 		XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|XFS_AT_GENCOUNT)
 
-/*
- *  Modes.
- */
-#define VSUID	S_ISUID		/* set user id on execution */
-#define VSGID	S_ISGID		/* set group id on execution */
-#define VSVTX	S_ISVTX		/* save swapped text even after use */
-#define VREAD	S_IRUSR		/* read, write, execute permissions */
-#define VWRITE	S_IWUSR
-#define VEXEC	S_IXUSR
-
-#define MODEMASK S_IALLUGO	/* mode bits plus permission bits */
-
-/*
- * Check whether mandatory file locking is enabled.
- */
-#define MANDLOCK(vp, mode)	\
-	(VN_ISREG(vp) && ((mode) & (VSGID|(VEXEC>>3))) == VSGID)
-
 extern void	vn_init(void);
 extern int	vn_revalidate(bhv_vnode_t *);
 
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-04-11 12:28:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2008-04-11 12:29:05.000000000 +0200
@@ -72,7 +72,7 @@ xfs_acl_vhasacl_default(
 {
 	int		error;
 
-	if (!VN_ISDIR(vp))
+	if (!S_ISDIR(vp->i_mode))
 		return 0;
 	xfs_acl_get_attr(vp, NULL, _ACL_TYPE_DEFAULT, ATTR_KERNOVAL, &error);
 	return (error == 0);
@@ -379,7 +379,7 @@ xfs_acl_allow_set(
 
 	if (vp->i_flags & (S_IMMUTABLE|S_APPEND))
 		return EPERM;
-	if (kind == _ACL_TYPE_DEFAULT && !VN_ISDIR(vp))
+	if (kind == _ACL_TYPE_DEFAULT && !S_ISDIR(vp->i_mode))
 		return ENOTDIR;
 	if (vp->i_sb->s_flags & MS_RDONLY)
 		return EROFS;
@@ -720,7 +720,7 @@ xfs_acl_inherit(
 	 * If the new file is a directory, its default ACL is a copy of
 	 * the containing directory's default ACL.
 	 */
-	if (VN_ISDIR(vp))
+	if (S_ISDIR(vp->i_mode))
 		xfs_acl_set_attr(vp, pdaclp, _ACL_TYPE_DEFAULT, &error);
 	if (!error && !basicperms)
 		xfs_acl_set_attr(vp, cacl, _ACL_TYPE_ACCESS, &error);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-11 12:25:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-11 12:37:36.000000000 +0200
@@ -211,7 +211,6 @@ xfs_setattr(
 	int			flags,
 	cred_t			*credp)
 {
-	bhv_vnode_t		*vp = XFS_ITOV(ip);
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_trans_t		*tp;
 	int			mask;
@@ -222,7 +221,6 @@ xfs_setattr(
 	gid_t			gid=0, igid=0;
 	int			timeflags = 0;
 	xfs_prid_t		projid=0, iprojid=0;
-	int			mandlock_before, mandlock_after;
 	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
 	int			file_owner;
 	int			need_iolock = 1;
@@ -383,7 +381,7 @@ xfs_setattr(
 				m |= S_ISGID;
 #if 0
 			/* Linux allows this, Irix doesn't. */
-			if ((vap->va_mode & S_ISVTX) && !VN_ISDIR(vp))
+			if ((vap->va_mode & S_ISVTX) && !S_ISDIR(ip->i_d.di_mode))
 				m |= S_ISVTX;
 #endif
 			if (m && !capable(CAP_FSETID))
@@ -461,10 +459,10 @@ xfs_setattr(
 			goto error_return;
 		}
 
-		if (VN_ISDIR(vp)) {
+		if (S_ISDIR(ip->i_d.di_mode)) {
 			code = XFS_ERROR(EISDIR);
 			goto error_return;
-		} else if (!VN_ISREG(vp)) {
+		} else if (!S_ISREG(ip->i_d.di_mode)) {
 			code = XFS_ERROR(EINVAL);
 			goto error_return;
 		}
@@ -626,9 +624,6 @@ xfs_setattr(
 		xfs_trans_ihold(tp, ip);
 	}
 
-	/* determine whether mandatory locking mode changes */
-	mandlock_before = MANDLOCK(vp, ip->i_d.di_mode);
-
 	/*
 	 * Truncate file.  Must have write permission and not be a directory.
 	 */
@@ -858,13 +853,6 @@ xfs_setattr(
 		code = xfs_trans_commit(tp, commit_flags);
 	}
 
-	/*
-	 * If the (regular) file's mandatory locking mode changed, then
-	 * notify the vnode.  We do this under the inode lock to prevent
-	 * racing calls to vop_vnode_change.
-	 */
-	mandlock_after = MANDLOCK(vp, ip->i_d.di_mode);
-
 	xfs_iunlock(ip, lock_flags);
 
 	/*
@@ -1491,7 +1479,7 @@ xfs_release(
 	xfs_mount_t	*mp = ip->i_mount;
 	int		error;
 
-	if (!VN_ISREG(vp) || (ip->i_d.di_mode == 0))
+	if (!S_ISREG(ip->i_d.di_mode) || (ip->i_d.di_mode == 0))
 		return 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
