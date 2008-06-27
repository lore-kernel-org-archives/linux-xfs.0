Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 08:45:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RFj8Lf028899
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:45:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8647BD69CE1
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:46:07 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id AxG7iNGFhHyiRea6 for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 08:46:07 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m5RFjvNW031786
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:45:57 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m5RFjveH031784
	for xfs@oss.sgi.com; Fri, 27 Jun 2008 17:45:57 +0200
Date: Fri, 27 Jun 2008 17:45:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] simplify xfs_setattr
Message-ID: <20080627154557.GB31476@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that xfs_setattr is only used for attributes set from ->setattr it
can be switched to take struct iattr directly and thus simplify the
implementation greatly.  Also rename the ATTR_ flags to XFS_ATTR_ to
not conflict with the ATTR_ flags used by the VFS.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-06-15 18:10:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-06-15 18:25:24.000000000 +0200
@@ -2458,7 +2458,8 @@ xfs_dm_punch_hole(
 #endif
 
 	error = xfs_change_file_space(ip, XFS_IOC_UNRESVSP, &bf,
-				(xfs_off_t)off, sys_cred, ATTR_DMI|ATTR_NOLOCK);
+				(xfs_off_t)off, sys_cred,
+				XFS_ATTR_DMI|XFS_ATTR_NOLOCK);
 
 	/*
 	 * if punching to end of file, kill any blocks past EOF that
@@ -2661,7 +2662,7 @@ xfs_dm_set_fileattr(
 	dm_fileattr_t	__user *statp)
 {
 	dm_fileattr_t	stat;
-	bhv_vattr_t	vat;
+	struct iattr	iattr;
 	int		error;
 
 	/* Returns negative errors to DMAPI */
@@ -2672,52 +2673,52 @@ xfs_dm_set_fileattr(
 	if (copy_from_user( &stat, statp, sizeof(stat)))
 		return(-EFAULT);
 
-	vat.va_mask = 0;
+	iattr.ia_valid = 0;
 
 	if (mask & DM_AT_MODE) {
-		vat.va_mask |= XFS_AT_MODE;
-		vat.va_mode = stat.fa_mode;
+		iattr.ia_valid |= ATTR_MODE;
+		iattr.ia_mode = stat.fa_mode;
 	}
 	if (mask & DM_AT_UID) {
-		vat.va_mask |= XFS_AT_UID;
-		vat.va_uid = stat.fa_uid;
+		iattr.ia_valid |= ATTR_UID;
+		iattr.ia_uid = stat.fa_uid;
 	}
 	if (mask & DM_AT_GID) {
-		vat.va_mask |= XFS_AT_GID;
-		vat.va_gid = stat.fa_gid;
+		iattr.ia_valid |= ATTR_GID;
+		iattr.ia_gid = stat.fa_gid;
 	}
 	if (mask & DM_AT_ATIME) {
-		vat.va_mask |= XFS_AT_ATIME;
-		vat.va_atime.tv_sec = stat.fa_atime;
-		vat.va_atime.tv_nsec = 0;
+		iattr.ia_valid |= ATTR_ATIME;
+		iattr.ia_atime.tv_sec = stat.fa_atime;
+		iattr.ia_atime.tv_nsec = 0;
                 inode->i_atime.tv_sec = stat.fa_atime;
 	}
 	if (mask & DM_AT_MTIME) {
-		vat.va_mask |= XFS_AT_MTIME;
-		vat.va_mtime.tv_sec = stat.fa_mtime;
-		vat.va_mtime.tv_nsec = 0;
+		iattr.ia_valid |= ATTR_MTIME;
+		iattr.ia_mtime.tv_sec = stat.fa_mtime;
+		iattr.ia_mtime.tv_nsec = 0;
 	}
 	if (mask & DM_AT_CTIME) {
-		vat.va_mask |= XFS_AT_CTIME;
-		vat.va_ctime.tv_sec = stat.fa_ctime;
-		vat.va_ctime.tv_nsec = 0;
+		iattr.ia_valid |= ATTR_CTIME;
+		iattr.ia_ctime.tv_sec = stat.fa_ctime;
+		iattr.ia_ctime.tv_nsec = 0;
 	}
 
-	/* DM_AT_DTIME only takes effect if DM_AT_CTIME is not specified.  We
-	   overload ctime to also act as dtime, i.e. DM_CONFIG_DTIME_OVERLOAD.
-	*/
-
+	/*
+	 * DM_AT_DTIME only takes effect if DM_AT_CTIME is not specified.  We
+	 * overload ctime to also act as dtime, i.e. DM_CONFIG_DTIME_OVERLOAD.
+	 */
 	if ((mask & DM_AT_DTIME) && !(mask & DM_AT_CTIME)) {
-		vat.va_mask |= XFS_AT_CTIME;
-		vat.va_ctime.tv_sec = stat.fa_dtime;
-		vat.va_ctime.tv_nsec = 0;
+		iattr.ia_valid |= ATTR_CTIME;
+		iattr.ia_ctime.tv_sec = stat.fa_dtime;
+		iattr.ia_ctime.tv_nsec = 0;
 	}
 	if (mask & DM_AT_SIZE) {
-		vat.va_mask |= XFS_AT_SIZE;
-		vat.va_size = stat.fa_size;
+		iattr.ia_valid |= ATTR_SIZE;
+		iattr.ia_size = stat.fa_size;
 	}
 
-	error = xfs_setattr(XFS_I(inode), &vat, ATTR_DMI, NULL);
+	error = xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_DMI, NULL);
 	if (!error)
 		vn_revalidate(vn_from_inode(inode));	/* update Linux inode flags */
 	return(-error); /* Return negative error to DMAPI */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_acl.c	2008-06-15 18:08:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_acl.c	2008-06-15 18:20:16.000000000 +0200
@@ -272,12 +272,12 @@ xfs_set_mode(struct inode *inode, mode_t
 	int error = 0;
 
 	if (mode != inode->i_mode) {
-		struct bhv_vattr va;
+		struct iattr iattr;
 
-		va.va_mask = XFS_AT_MODE;
-		va.va_mode = mode;
+		iattr.ia_valid = ATTR_MODE;
+		iattr.ia_mode = mode;
 
-		error = -xfs_setattr(XFS_I(inode), &va, 0, sys_cred);
+		error = -xfs_setattr(XFS_I(inode), &iattr, 0, sys_cred);
 		inode->i_mode = mode;
 	}
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-06-15 17:50:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-06-15 18:25:50.000000000 +0200
@@ -607,58 +607,24 @@ xfs_vn_getattr(
 STATIC int
 xfs_vn_setattr(
 	struct dentry	*dentry,
-	struct iattr	*attr)
+	struct iattr	*iattr)
 {
 	struct inode	*inode = dentry->d_inode;
-	unsigned int	ia_valid = attr->ia_valid;
-	bhv_vattr_t	vattr = { 0 };
-	int		flags = 0;
 	int		error;
 
-	if (ia_valid & ATTR_UID) {
-		vattr.va_mask |= XFS_AT_UID;
-		vattr.va_uid = attr->ia_uid;
-	}
-	if (ia_valid & ATTR_GID) {
-		vattr.va_mask |= XFS_AT_GID;
-		vattr.va_gid = attr->ia_gid;
-	}
-	if (ia_valid & ATTR_SIZE) {
-		vattr.va_mask |= XFS_AT_SIZE;
-		vattr.va_size = attr->ia_size;
-	}
-	if (ia_valid & ATTR_ATIME) {
-		vattr.va_mask |= XFS_AT_ATIME;
-		vattr.va_atime = attr->ia_atime;
-		inode->i_atime = attr->ia_atime;
-	}
-	if (ia_valid & ATTR_MTIME) {
-		vattr.va_mask |= XFS_AT_MTIME;
-		vattr.va_mtime = attr->ia_mtime;
-	}
-	if (ia_valid & ATTR_CTIME) {
-		vattr.va_mask |= XFS_AT_CTIME;
-		vattr.va_ctime = attr->ia_ctime;
-	}
-	if (ia_valid & ATTR_MODE) {
-		vattr.va_mask |= XFS_AT_MODE;
-		vattr.va_mode = attr->ia_mode;
+	if (iattr->ia_valid & ATTR_ATIME)
+		inode->i_atime = iattr->ia_atime;
+
+	if (iattr->ia_valid & ATTR_MODE) {
 		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
 			inode->i_mode &= ~S_ISGID;
 	}
 
-	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET))
-		flags |= ATTR_UTIME;
-#ifdef ATTR_NO_BLOCK
-	if ((ia_valid & ATTR_NO_BLOCK))
-		flags |= ATTR_NONBLOCK;
-#endif
-
-	error = xfs_setattr(XFS_I(inode), &vattr, flags, NULL);
+	error = xfs_setattr(XFS_I(inode), iattr, 0, NULL);
 	if (likely(!error))
 		vn_revalidate(vn_from_inode(inode));
 
-	if (!error && (attr->ia_valid & ATTR_MODE))
+	if (!error && (iattr->ia_valid & ATTR_MODE))
 		error = -xfs_acl_chmod(inode);
 	return -error;
 }
@@ -701,18 +667,18 @@ xfs_vn_fallocate(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-						0, NULL, ATTR_NOLOCK);
+				      0, NULL, XFS_ATTR_NOLOCK);
 	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode))
 		new_size = offset + len;
 
 	/* Change file size if needed */
 	if (new_size) {
-		bhv_vattr_t	va;
+		struct iattr iattr;
 
-		va.va_mask = XFS_AT_SIZE;
-		va.va_size = new_size;
-		error = xfs_setattr(ip, &va, ATTR_NOLOCK, NULL);
+		iattr.ia_valid = ATTR_SIZE;
+		iattr.ia_size = new_size;
+		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK, NULL);
 	}
 
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-06-15 18:01:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-06-15 18:24:04.000000000 +0200
@@ -19,7 +19,6 @@
 #define __XFS_VNODE_H__
 
 struct file;
-struct bhv_vattr;
 struct xfs_iomap;
 struct attrlist_cursor_kern;
 
@@ -66,69 +65,6 @@ static inline struct inode *vn_to_inode(
 					   Prevent VM access to the pages until
 					   the operation completes. */
 
-/*
- * Vnode attributes.  va_mask indicates those attributes the caller
- * wants to set or extract.
- */
-typedef struct bhv_vattr {
-	int		va_mask;	/* bit-mask of attributes present */
-	mode_t		va_mode;	/* file access mode and type */
-	xfs_nlink_t	va_nlink;	/* number of references to file */
-	uid_t		va_uid;		/* owner user id */
-	gid_t		va_gid;		/* owner group id */
-	xfs_ino_t	va_nodeid;	/* file id */
-	xfs_off_t	va_size;	/* file size in bytes */
-	u_long		va_blocksize;	/* blocksize preferred for i/o */
-	struct timespec	va_atime;	/* time of last access */
-	struct timespec	va_mtime;	/* time of last modification */
-	struct timespec	va_ctime;	/* time file changed */
-	u_int		va_gen;		/* generation number of file */
-	xfs_dev_t	va_rdev;	/* device the special file represents */
-	__int64_t	va_nblocks;	/* number of blocks allocated */
-	u_long		va_xflags;	/* random extended file flags */
-	u_long		va_extsize;	/* file extent size */
-	u_long		va_nextents;	/* number of extents in file */
-	u_long		va_anextents;	/* number of attr extents in file */
-	prid_t		va_projid;	/* project id */
-} bhv_vattr_t;
-
-/*
- * setattr or getattr attributes
- */
-#define XFS_AT_TYPE		0x00000001
-#define XFS_AT_MODE		0x00000002
-#define XFS_AT_UID		0x00000004
-#define XFS_AT_GID		0x00000008
-#define XFS_AT_FSID		0x00000010
-#define XFS_AT_NODEID		0x00000020
-#define XFS_AT_NLINK		0x00000040
-#define XFS_AT_SIZE		0x00000080
-#define XFS_AT_ATIME		0x00000100
-#define XFS_AT_MTIME		0x00000200
-#define XFS_AT_CTIME		0x00000400
-#define XFS_AT_RDEV		0x00000800
-#define XFS_AT_BLKSIZE		0x00001000
-#define XFS_AT_NBLOCKS		0x00002000
-#define XFS_AT_VCODE		0x00004000
-#define XFS_AT_MAC		0x00008000
-#define XFS_AT_UPDATIME		0x00010000
-#define XFS_AT_UPDMTIME		0x00020000
-#define XFS_AT_UPDCTIME		0x00040000
-#define XFS_AT_ACL		0x00080000
-#define XFS_AT_CAP		0x00100000
-#define XFS_AT_INF		0x00200000
-#define XFS_AT_NEXTENTS		0x01000000
-#define XFS_AT_ANEXTENTS	0x02000000
-#define XFS_AT_SIZE_NOPERM	0x08000000
-#define XFS_AT_GENCOUNT		0x10000000
-
-#define XFS_AT_TIMES	(XFS_AT_ATIME|XFS_AT_MTIME|XFS_AT_CTIME)
-
-#define XFS_AT_UPDTIMES	(XFS_AT_UPDATIME|XFS_AT_UPDMTIME|XFS_AT_UPDCTIME)
-
-#define XFS_AT_NOSET	(XFS_AT_NLINK|XFS_AT_RDEV|XFS_AT_FSID|XFS_AT_NODEID|\
-		XFS_AT_TYPE|XFS_AT_BLKSIZE|XFS_AT_NBLOCKS|XFS_AT_VCODE|\
-		XFS_AT_NEXTENTS|XFS_AT_ANEXTENTS|XFS_AT_GENCOUNT)
 
 extern void	vn_init(void);
 extern int	vn_revalidate(bhv_vnode_t *);
@@ -199,15 +135,6 @@ static inline void vn_atime_to_time_t(bh
 #define VN_DIRTY(vp)	mapping_tagged(vn_to_inode(vp)->i_mapping, \
 					PAGECACHE_TAG_DIRTY)
 
-/*
- * Flags to vop_setattr/getattr.
- */
-#define	ATTR_UTIME	0x01	/* non-default utime(2) request */
-#define	ATTR_DMI	0x08	/* invocation from a DMI function */
-#define	ATTR_LAZY	0x80	/* set/get attributes lazily */
-#define	ATTR_NONBLOCK	0x100	/* return EAGAIN if operation would block */
-#define ATTR_NOLOCK	0x200	/* Don't grab any conflicting locks */
-#define ATTR_NOSIZETOK	0x400	/* Don't get the SIZE token */
 
 /*
  * Tracking vnode activity.
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-06-15 17:50:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-06-15 18:27:04.000000000 +0200
@@ -75,19 +75,16 @@ xfs_open(
 	return 0;
 }
 
-/*
- * xfs_setattr
- */
 int
 xfs_setattr(
-	xfs_inode_t		*ip,
-	bhv_vattr_t		*vap,
+	struct xfs_inode	*ip,
+	struct iattr		*iattr,
 	int			flags,
 	cred_t			*credp)
 {
 	xfs_mount_t		*mp = ip->i_mount;
+	int			mask = iattr->ia_valid;
 	xfs_trans_t		*tp;
-	int			mask;
 	int			code;
 	uint			lock_flags;
 	uint			commit_flags=0;
@@ -103,30 +100,9 @@ xfs_setattr(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return XFS_ERROR(EROFS);
 
-	/*
-	 * Cannot set certain attributes.
-	 */
-	mask = vap->va_mask;
-	if (mask & XFS_AT_NOSET) {
-		return XFS_ERROR(EINVAL);
-	}
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	/*
-	 * Timestamps do not need to be logged and hence do not
-	 * need to be done within a transaction.
-	 */
-	if (mask & XFS_AT_UPDTIMES) {
-		ASSERT((mask & ~XFS_AT_UPDTIMES) == 0);
-		timeflags = ((mask & XFS_AT_UPDATIME) ? XFS_ICHGTIME_ACC : 0) |
-			    ((mask & XFS_AT_UPDCTIME) ? XFS_ICHGTIME_CHG : 0) |
-			    ((mask & XFS_AT_UPDMTIME) ? XFS_ICHGTIME_MOD : 0);
-		xfs_ichgtime(ip, timeflags);
-		return 0;
-	}
-
 	olddquot1 = olddquot2 = NULL;
 	udqp = gdqp = NULL;
 
@@ -138,17 +114,17 @@ xfs_setattr(
 	 * If the IDs do change before we take the ilock, we're covered
 	 * because the i_*dquot fields will get updated anyway.
 	 */
-	if (XFS_IS_QUOTA_ON(mp) && (mask & (XFS_AT_UID|XFS_AT_GID))) {
+	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
 		uint	qflags = 0;
 
-		if ((mask & XFS_AT_UID) && XFS_IS_UQUOTA_ON(mp)) {
-			uid = vap->va_uid;
+		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
+			uid = iattr->ia_uid;
 			qflags |= XFS_QMOPT_UQUOTA;
 		} else {
 			uid = ip->i_d.di_uid;
 		}
-		if ((mask & XFS_AT_GID) && XFS_IS_GQUOTA_ON(mp)) {
-			gid = vap->va_gid;
+		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
+			gid = iattr->ia_gid;
 			qflags |= XFS_QMOPT_GQUOTA;
 		}  else {
 			gid = ip->i_d.di_gid;
@@ -173,10 +149,10 @@ xfs_setattr(
 	 */
 	tp = NULL;
 	lock_flags = XFS_ILOCK_EXCL;
-	if (flags & ATTR_NOLOCK)
+	if (flags & XFS_ATTR_NOLOCK)
 		need_iolock = 0;
-	if (!(mask & XFS_AT_SIZE)) {
-		if ((mask != (XFS_AT_CTIME|XFS_AT_ATIME|XFS_AT_MTIME)) ||
+	if (!(mask & ATTR_SIZE)) {
+		if ((mask != (ATTR_CTIME|ATTR_ATIME|ATTR_MTIME)) ||
 		    (mp->m_flags & XFS_MOUNT_WSYNC)) {
 			tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 			commit_flags = 0;
@@ -189,10 +165,10 @@ xfs_setattr(
 		}
 	} else {
 		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
-		    !(flags & ATTR_DMI)) {
+		    !(flags & XFS_ATTR_DMI)) {
 			int dmflags = AT_DELAY_FLAG(flags) | DM_SEM_FLAG_WR;
 			code = XFS_SEND_DATA(mp, DM_EVENT_TRUNCATE, ip,
-				vap->va_size, 0, dmflags, NULL);
+				iattr->ia_size, 0, dmflags, NULL);
 			if (code) {
 				lock_flags = 0;
 				goto error_return;
@@ -212,7 +188,7 @@ xfs_setattr(
 	 * Only the owner or users with CAP_FOWNER
 	 * capability may do these things.
 	 */
-	if (mask & (XFS_AT_MODE|XFS_AT_UID|XFS_AT_GID)) {
+	if (mask & (ATTR_MODE|ATTR_UID|ATTR_GID)) {
 		/*
 		 * CAP_FOWNER overrides the following restrictions:
 		 *
@@ -236,21 +212,21 @@ xfs_setattr(
 		 * IDs of the calling process shall match the group owner of
 		 * the file when setting the set-group-ID bit on that file
 		 */
-		if (mask & XFS_AT_MODE) {
+		if (mask & ATTR_MODE) {
 			mode_t m = 0;
 
-			if ((vap->va_mode & S_ISUID) && !file_owner)
+			if ((iattr->ia_mode & S_ISUID) && !file_owner)
 				m |= S_ISUID;
-			if ((vap->va_mode & S_ISGID) &&
+			if ((iattr->ia_mode & S_ISGID) &&
 			    !in_group_p((gid_t)ip->i_d.di_gid))
 				m |= S_ISGID;
 #if 0
 			/* Linux allows this, Irix doesn't. */
-			if ((vap->va_mode & S_ISVTX) && !S_ISDIR(ip->i_d.di_mode))
+			if ((iattr->ia_mode & S_ISVTX) && !S_ISDIR(ip->i_d.di_mode))
 				m |= S_ISVTX;
 #endif
 			if (m && !capable(CAP_FSETID))
-				vap->va_mode &= ~m;
+				iattr->ia_mode &= ~m;
 		}
 	}
 
@@ -261,7 +237,7 @@ xfs_setattr(
 	 * and can change the group id only to a group of which he
 	 * or she is a member.
 	 */
-	if (mask & (XFS_AT_UID|XFS_AT_GID)) {
+	if (mask & (ATTR_UID|ATTR_GID)) {
 		/*
 		 * These IDs could have changed since we last looked at them.
 		 * But, we're assured that if the ownership did change
@@ -270,8 +246,8 @@ xfs_setattr(
 		 */
 		iuid = ip->i_d.di_uid;
 		igid = ip->i_d.di_gid;
-		gid = (mask & XFS_AT_GID) ? vap->va_gid : igid;
-		uid = (mask & XFS_AT_UID) ? vap->va_uid : iuid;
+		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
+		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
 		/*
 		 * CAP_CHOWN overrides the following restrictions:
@@ -308,13 +284,13 @@ xfs_setattr(
 	/*
 	 * Truncate file.  Must have write permission and not be a directory.
 	 */
-	if (mask & XFS_AT_SIZE) {
+	if (mask & ATTR_SIZE) {
 		/* Short circuit the truncate case for zero length files */
-		if ((vap->va_size == 0) &&
-		   (ip->i_size == 0) && (ip->i_d.di_nextents == 0)) {
+		if (iattr->ia_size == 0 &&
+		    ip->i_size == 0 && ip->i_d.di_nextents == 0) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			lock_flags &= ~XFS_ILOCK_EXCL;
-			if (mask & XFS_AT_CTIME)
+			if (mask & ATTR_CTIME)
 				xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 			code = 0;
 			goto error_return;
@@ -337,9 +313,9 @@ xfs_setattr(
 	/*
 	 * Change file access or modified times.
 	 */
-	if (mask & (XFS_AT_ATIME|XFS_AT_MTIME)) {
+	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
 		if (!file_owner) {
-			if ((flags & ATTR_UTIME) &&
+			if ((mask & (ATTR_MTIME_SET|ATTR_ATIME_SET)) &&
 			    !capable(CAP_FOWNER)) {
 				code = XFS_ERROR(EPERM);
 				goto error_return;
@@ -349,23 +325,22 @@ xfs_setattr(
 
 	/*
 	 * Now we can make the changes.  Before we join the inode
-	 * to the transaction, if XFS_AT_SIZE is set then take care of
+	 * to the transaction, if ATTR_SIZE is set then take care of
 	 * the part of the truncation that must be done without the
 	 * inode lock.  This needs to be done before joining the inode
 	 * to the transaction, because the inode cannot be unlocked
 	 * once it is a part of the transaction.
 	 */
-	if (mask & XFS_AT_SIZE) {
+	if (mask & ATTR_SIZE) {
 		code = 0;
-		if ((vap->va_size > ip->i_size) &&
-		    (flags & ATTR_NOSIZETOK) == 0) {
+		if (iattr->ia_size > ip->i_size) {
 			/*
 			 * Do the first part of growing a file: zero any data
 			 * in the last block that is beyond the old EOF.  We
 			 * need to do this before the inode is joined to the
 			 * transaction to modify the i_size.
 			 */
-			code = xfs_zero_eof(ip, vap->va_size, ip->i_size);
+			code = xfs_zero_eof(ip, iattr->ia_size, ip->i_size);
 		}
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
@@ -382,10 +357,10 @@ xfs_setattr(
 		 * not within the range we care about here.
 		 */
 		if (!code &&
-		    (ip->i_size != ip->i_d.di_size) &&
-		    (vap->va_size > ip->i_d.di_size)) {
+		    ip->i_size != ip->i_d.di_size &&
+		    iattr->ia_size > ip->i_d.di_size) {
 			code = xfs_flush_pages(ip,
-					ip->i_d.di_size, vap->va_size,
+					ip->i_d.di_size, iattr->ia_size,
 					XFS_B_ASYNC, FI_NONE);
 		}
 
@@ -393,7 +368,7 @@ xfs_setattr(
 		vn_iowait(ip);
 
 		if (!code)
-			code = xfs_itruncate_data(ip, vap->va_size);
+			code = xfs_itruncate_data(ip, iattr->ia_size);
 		if (code) {
 			ASSERT(tp == NULL);
 			lock_flags &= ~XFS_ILOCK_EXCL;
@@ -422,31 +397,30 @@ xfs_setattr(
 	/*
 	 * Truncate file.  Must have write permission and not be a directory.
 	 */
-	if (mask & XFS_AT_SIZE) {
+	if (mask & ATTR_SIZE) {
 		/*
 		 * Only change the c/mtime if we are changing the size
 		 * or we are explicitly asked to change it. This handles
 		 * the semantic difference between truncate() and ftruncate()
 		 * as implemented in the VFS.
 		 */
-		if (vap->va_size != ip->i_size || (mask & XFS_AT_CTIME))
+		if (iattr->ia_size != ip->i_size || (mask & ATTR_CTIME))
 			timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
 
-		if (vap->va_size > ip->i_size) {
-			ip->i_d.di_size = vap->va_size;
-			ip->i_size = vap->va_size;
-			if (!(flags & ATTR_DMI))
+		if (iattr->ia_size > ip->i_size) {
+			ip->i_d.di_size = iattr->ia_size;
+			ip->i_size = iattr->ia_size;
+			if (!(flags & XFS_ATTR_DMI))
 				xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		} else if ((vap->va_size <= ip->i_size) ||
-			   ((vap->va_size == 0) && ip->i_d.di_nextents)) {
+		} else if (iattr->ia_size <= ip->i_size ||
+			   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
 			/*
 			 * signal a sync transaction unless
 			 * we're truncating an already unlinked
 			 * file on a wsync filesystem
 			 */
-			code = xfs_itruncate_finish(&tp, ip,
-					    (xfs_fsize_t)vap->va_size,
+			code = xfs_itruncate_finish(&tp, ip, iattr->ia_size,
 					    XFS_DATA_FORK,
 					    ((ip->i_d.di_nlink != 0 ||
 					      !(mp->m_flags & XFS_MOUNT_WSYNC))
@@ -468,9 +442,9 @@ xfs_setattr(
 	/*
 	 * Change file access modes.
 	 */
-	if (mask & XFS_AT_MODE) {
+	if (mask & ATTR_MODE) {
 		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= vap->va_mode & ~S_IFMT;
+		ip->i_d.di_mode |= iattr->ia_mode & ~S_IFMT;
 
 		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
 		timeflags |= XFS_ICHGTIME_CHG;
@@ -483,7 +457,7 @@ xfs_setattr(
 	 * and can change the group id only to a group of which he
 	 * or she is a member.
 	 */
-	if (mask & (XFS_AT_UID|XFS_AT_GID)) {
+	if (mask & (ATTR_UID|ATTR_GID)) {
 		/*
 		 * CAP_FSETID overrides the following restrictions:
 		 *
@@ -501,7 +475,7 @@ xfs_setattr(
 		 */
 		if (iuid != uid) {
 			if (XFS_IS_UQUOTA_ON(mp)) {
-				ASSERT(mask & XFS_AT_UID);
+				ASSERT(mask & ATTR_UID);
 				ASSERT(udqp);
 				olddquot1 = XFS_QM_DQVOPCHOWN(mp, tp, ip,
 							&ip->i_udquot, udqp);
@@ -511,7 +485,7 @@ xfs_setattr(
 		if (igid != gid) {
 			if (XFS_IS_GQUOTA_ON(mp)) {
 				ASSERT(!XFS_IS_PQUOTA_ON(mp));
-				ASSERT(mask & XFS_AT_GID);
+				ASSERT(mask & ATTR_GID);
 				ASSERT(gdqp);
 				olddquot2 = XFS_QM_DQVOPCHOWN(mp, tp, ip,
 							&ip->i_gdquot, gdqp);
@@ -527,31 +501,31 @@ xfs_setattr(
 	/*
 	 * Change file access or modified times.
 	 */
-	if (mask & (XFS_AT_ATIME|XFS_AT_MTIME)) {
-		if (mask & XFS_AT_ATIME) {
-			ip->i_d.di_atime.t_sec = vap->va_atime.tv_sec;
-			ip->i_d.di_atime.t_nsec = vap->va_atime.tv_nsec;
+	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
+		if (mask & ATTR_ATIME) {
+			ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
+			ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
 			ip->i_update_core = 1;
 			timeflags &= ~XFS_ICHGTIME_ACC;
 		}
-		if (mask & XFS_AT_MTIME) {
-			ip->i_d.di_mtime.t_sec = vap->va_mtime.tv_sec;
-			ip->i_d.di_mtime.t_nsec = vap->va_mtime.tv_nsec;
+		if (mask & ATTR_MTIME) {
+			ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
+			ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
 			timeflags &= ~XFS_ICHGTIME_MOD;
 			timeflags |= XFS_ICHGTIME_CHG;
 		}
-		if (tp && (flags & ATTR_UTIME))
+		if (tp && (mask & (ATTR_MTIME_SET|ATTR_ATIME_SET)))
 			xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
 	}
 
 	/*
-	 * Change file inode change time only if XFS_AT_CTIME set
+	 * Change file inode change time only if ATTR_CTIME set
 	 * AND we have been called by a DMI function.
 	 */
 
-	if ( (flags & ATTR_DMI) && (mask & XFS_AT_CTIME) ) {
-		ip->i_d.di_ctime.t_sec = vap->va_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = vap->va_ctime.tv_nsec;
+	if ((flags & XFS_ATTR_DMI) && (mask & ATTR_CTIME)) {
+		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
+		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
 		ip->i_update_core = 1;
 		timeflags &= ~XFS_ICHGTIME_CHG;
 	}
@@ -560,7 +534,7 @@ xfs_setattr(
 	 * Send out timestamp changes that need to be set to the
 	 * current time.  Not done when called by a DMI function.
 	 */
-	if (timeflags && !(flags & ATTR_DMI))
+	if (timeflags && !(flags & XFS_ATTR_DMI))
 		xfs_ichgtime(ip, timeflags);
 
 	XFS_STATS_INC(xs_ig_attrchg);
@@ -598,7 +572,7 @@ xfs_setattr(
 	}
 
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE) &&
-	    !(flags & ATTR_DMI)) {
+	    !(flags & XFS_ATTR_DMI)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL, NULL, NULL,
 					0, 0, AT_DELAY_FLAG(flags));
@@ -3050,7 +3024,7 @@ xfs_alloc_file_space(
 
 	/*	Generate a DMAPI event if needed.	*/
 	if (alloc_type != 0 && offset < ip->i_size &&
-			(attr_flags&ATTR_DMI) == 0  &&
+			(attr_flags & XFS_ATTR_DMI) == 0  &&
 			DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
 		xfs_off_t           end_dmi_offset;
 
@@ -3164,7 +3138,7 @@ retry:
 		allocatesize_fsb -= allocated_fsb;
 	}
 dmapi_enospc_check:
-	if (error == ENOSPC && (attr_flags & ATTR_DMI) == 0 &&
+	if (error == ENOSPC && (attr_flags & XFS_ATTR_DMI) == 0 &&
 	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_NOSPACE,
 				ip, DM_RIGHT_NULL,
@@ -3311,7 +3285,7 @@ xfs_free_file_space(
 	end_dmi_offset = offset + len;
 	endoffset_fsb = XFS_B_TO_FSBT(mp, end_dmi_offset);
 
-	if (offset < ip->i_size && (attr_flags & ATTR_DMI) == 0 &&
+	if (offset < ip->i_size && (attr_flags & XFS_ATTR_DMI) == 0 &&
 	    DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
@@ -3322,7 +3296,7 @@ xfs_free_file_space(
 			return error;
 	}
 
-	if (attr_flags & ATTR_NOLOCK)
+	if (attr_flags & XFS_ATTR_NOLOCK)
 		need_iolock = 0;
 	if (need_iolock) {
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
@@ -3499,7 +3473,7 @@ xfs_change_file_space(
 	xfs_off_t	startoffset;
 	xfs_off_t	llen;
 	xfs_trans_t	*tp;
-	bhv_vattr_t	va;
+	struct iattr	iattr;
 
 	xfs_itrace_entry(ip);
 
@@ -3573,10 +3547,10 @@ xfs_change_file_space(
 				break;
 		}
 
-		va.va_mask = XFS_AT_SIZE;
-		va.va_size = startoffset;
+		iattr.ia_valid = ATTR_SIZE;
+		iattr.ia_size = startoffset;
 
-		error = xfs_setattr(ip, &va, attr_flags, credp);
+		error = xfs_setattr(ip, &iattr, attr_flags, credp);
 
 		if (error)
 			return error;
@@ -3606,7 +3580,7 @@ xfs_change_file_space(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_ihold(tp, ip);
 
-	if ((attr_flags & ATTR_DMI) == 0) {
+	if ((attr_flags & XFS_ATTR_DMI) == 0) {
 		ip->i_d.di_mode &= ~S_ISUID;
 
 		/*
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-06-15 18:17:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-06-15 18:24:55.000000000 +0200
@@ -2,9 +2,9 @@
 #define _XFS_VNODEOPS_H 1
 
 struct attrlist_cursor_kern;
-struct bhv_vattr;
 struct cred;
 struct file;
+struct iattr;
 struct inode;
 struct iovec;
 struct kiocb;
@@ -15,8 +15,12 @@ struct xfs_iomap;
 
 
 int xfs_open(struct xfs_inode *ip);
-int xfs_setattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags,
+int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags,
 		struct cred *credp);
+#define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
+#define	XFS_ATTR_NONBLOCK	0x02	/* return EAGAIN if operation would block */
+#define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
+
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_fsync(struct xfs_inode *ip);
 int xfs_release(struct xfs_inode *ip);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-15 18:27:12.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-15 18:27:53.000000000 +0200
@@ -684,9 +684,9 @@ xfs_ioc_space(
 		return -XFS_ERROR(EFAULT);
 
 	if (filp->f_flags & (O_NDELAY|O_NONBLOCK))
-		attr_flags |= ATTR_NONBLOCK;
+		attr_flags |= XFS_ATTR_NONBLOCK;
 	if (ioflags & IO_INVIS)
-		attr_flags |= ATTR_DMI;
+		attr_flags |= XFS_ATTR_DMI;
 
 	error = xfs_change_file_space(ip, cmd, &bf, filp->f_pos,
 					      NULL, attr_flags);
Index: linux-2.6-xfs/fs/xfs/xfs_dmapi.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dmapi.h	2008-06-15 18:27:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dmapi.h	2008-06-15 18:27:42.000000000 +0200
@@ -166,6 +166,6 @@ typedef enum {
 
 #define FILP_DELAY_FLAG(filp) ((filp->f_flags&(O_NDELAY|O_NONBLOCK)) ? \
 			DM_FLAGS_NDELAY : 0)
-#define AT_DELAY_FLAG(f) ((f&ATTR_NONBLOCK) ? DM_FLAGS_NDELAY : 0)
+#define AT_DELAY_FLAG(f) ((f & XFS_ATTR_NONBLOCK) ? DM_FLAGS_NDELAY : 0)
 
 #endif  /* __XFS_DMAPI_H__ */
