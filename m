Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:37:43 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJbW4p002653
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:37:35 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJbQA5008460
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:37:27 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJbQY8008458
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:37:26 +0200
Date: Thu, 23 Aug 2007 21:37:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/17] call common xfs vnode-level helpers directly and remove vnode operations
Message-ID: <20070823193726.GC8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2007-08-23 19:00:43.000000000 +0200
@@ -37,6 +37,7 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_ioctl32.h"
+#include "xfs_vnodeops.h"
 
 #include <linux/dcache.h>
 #include <linux/smp_lock.h>
@@ -55,13 +56,12 @@ __xfs_file_read(
 	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
-	bhv_vnode_t		*vp = vn_from_inode(file->f_path.dentry->d_inode);
 
 	BUG_ON(iocb->ki_pos != pos);
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= IO_ISDIRECT;
-	return bhv_vop_read(vp, iocb, iov, nr_segs, &iocb->ki_pos,
-				ioflags, NULL);
+	return xfs_read(XFS_I(file->f_path.dentry->d_inode), iocb, iov,
+				nr_segs, &iocb->ki_pos, ioflags);
 }
 
 STATIC ssize_t
@@ -93,14 +93,12 @@ __xfs_file_write(
 	loff_t			pos)
 {
 	struct file	*file = iocb->ki_filp;
-	struct inode	*inode = file->f_mapping->host;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	BUG_ON(iocb->ki_pos != pos);
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= IO_ISDIRECT;
-	return bhv_vop_write(vp, iocb, iov, nr_segs, &iocb->ki_pos,
-				ioflags, NULL);
+	return xfs_write(XFS_I(file->f_mapping->host), iocb, iov, nr_segs,
+				&iocb->ki_pos, ioflags);
 }
 
 STATIC ssize_t
@@ -131,8 +129,8 @@ xfs_file_sendfile(
 	read_actor_t		actor,
 	void			*target)
 {
-	return bhv_vop_sendfile(vn_from_inode(filp->f_path.dentry->d_inode),
-				filp, pos, 0, count, actor, target, NULL);
+	return xfs_sendfile(XFS_I(filp->f_path.dentry->d_inode),
+				filp, pos, 0, count, actor, target);
 }
 
 STATIC ssize_t
@@ -143,8 +141,8 @@ xfs_file_sendfile_invis(
 	read_actor_t		actor,
 	void			*target)
 {
-	return bhv_vop_sendfile(vn_from_inode(filp->f_path.dentry->d_inode),
-				filp, pos, IO_INVIS, count, actor, target, NULL);
+	return xfs_sendfile(XFS_I(filp->f_path.dentry->d_inode),
+				filp, pos, IO_INVIS, count, actor, target);
 }
 
 STATIC ssize_t
@@ -155,8 +153,8 @@ xfs_file_splice_read(
 	size_t			len,
 	unsigned int		flags)
 {
-	return bhv_vop_splice_read(vn_from_inode(infilp->f_path.dentry->d_inode),
-				   infilp, ppos, pipe, len, flags, 0, NULL);
+	return xfs_splice_read(XFS_I(infilp->f_path.dentry->d_inode),
+				   infilp, ppos, pipe, len, flags, 0);
 }
 
 STATIC ssize_t
@@ -167,9 +165,8 @@ xfs_file_splice_read_invis(
 	size_t			len,
 	unsigned int		flags)
 {
-	return bhv_vop_splice_read(vn_from_inode(infilp->f_path.dentry->d_inode),
-				   infilp, ppos, pipe, len, flags, IO_INVIS,
-				   NULL);
+	return xfs_splice_read(XFS_I(infilp->f_path.dentry->d_inode),
+				   infilp, ppos, pipe, len, flags, IO_INVIS);
 }
 
 STATIC ssize_t
@@ -180,8 +177,8 @@ xfs_file_splice_write(
 	size_t			len,
 	unsigned int		flags)
 {
-	return bhv_vop_splice_write(vn_from_inode(outfilp->f_path.dentry->d_inode),
-				    pipe, outfilp, ppos, len, flags, 0, NULL);
+	return xfs_splice_write(XFS_I(outfilp->f_path.dentry->d_inode),
+				    pipe, outfilp, ppos, len, flags, 0);
 }
 
 STATIC ssize_t
@@ -192,9 +189,8 @@ xfs_file_splice_write_invis(
 	size_t			len,
 	unsigned int		flags)
 {
-	return bhv_vop_splice_write(vn_from_inode(outfilp->f_path.dentry->d_inode),
-				    pipe, outfilp, ppos, len, flags, IO_INVIS,
-				    NULL);
+	return xfs_splice_write(XFS_I(outfilp->f_path.dentry->d_inode),
+				    pipe, outfilp, ppos, len, flags, IO_INVIS);
 }
 
 STATIC int
@@ -204,7 +200,7 @@ xfs_file_open(
 {
 	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EFBIG;
-	return -bhv_vop_open(vn_from_inode(inode), NULL);
+	return -xfs_open(XFS_I(inode));
 }
 
 STATIC int
@@ -212,11 +208,7 @@ xfs_file_release(
 	struct inode	*inode,
 	struct file	*filp)
 {
-	bhv_vnode_t	*vp = vn_from_inode(inode);
-
-	if (vp)
-		return -bhv_vop_release(vp);
-	return 0;
+	return -xfs_release(XFS_I(inode));
 }
 
 STATIC int
@@ -232,7 +224,8 @@ xfs_file_fsync(
 		flags |= FSYNC_DATA;
 	if (VN_TRUNC(vp))
 		VUNTRUNCATE(vp);
-	return -bhv_vop_fsync(vp, flags, NULL, (xfs_off_t)0, (xfs_off_t)-1);
+	return -xfs_fsync(XFS_I(dentry->d_inode), flags,
+			(xfs_off_t)0, (xfs_off_t)-1);
 }
 
 #ifdef HAVE_DMAPI
@@ -259,7 +252,7 @@ xfs_file_readdir(
 	filldir_t	filldir)
 {
 	struct inode	*inode = filp->f_path.dentry->d_inode;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
+	xfs_inode_t	*ip = XFS_I(inode);
 	int		error;
 	size_t		bufsize;
 
@@ -277,7 +270,7 @@ xfs_file_readdir(
 	 */
 	bufsize = (size_t)min_t(loff_t, PAGE_SIZE, inode->i_size);
 
-	error = bhv_vop_readdir(vp, dirent, bufsize,
+	error = xfs_readdir(ip, dirent, bufsize,
 				(xfs_off_t *)&filp->f_pos, filldir);
 	if (error)
 		return -error;
@@ -310,7 +303,7 @@ xfs_file_ioctl(
 	struct inode	*inode = filp->f_path.dentry->d_inode;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 
-	error = bhv_vop_ioctl(vp, inode, filp, 0, cmd, (void __user *)p);
+	error = xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
 	VMODIFY(vp);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
@@ -332,7 +325,7 @@ xfs_file_ioctl_invis(
 	struct inode	*inode = filp->f_path.dentry->d_inode;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 
-	error = bhv_vop_ioctl(vp, inode, filp, IO_INVIS, cmd, (void __user *)p);
+	error = xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
 	VMODIFY(vp);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-08-23 18:58:43.000000000 +0200
@@ -46,6 +46,7 @@
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
+#include "xfs_vnodeops.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -53,22 +54,6 @@
 #include <linux/security.h>
 
 /*
- * Get a XFS inode from a given vnode.
- */
-xfs_inode_t *
-xfs_vtoi(
-	bhv_vnode_t	*vp)
-{
-	bhv_desc_t      *bdp;
-
-	bdp = bhv_lookup_range(VN_BHV_HEAD(vp),
-			VNODE_POSITION_XFS, VNODE_POSITION_XFS);
-	if (unlikely(bdp == NULL))
-		return NULL;
-	return XFS_BHVTOI(bdp);
-}
-
-/*
  * Bring the atime in the XFS inode uptodate.
  * Used before logging the inode to disk or when the Linux inode goes away.
  */
@@ -199,7 +184,7 @@ xfs_validate_fields(
 	bhv_vattr_t	*vattr)
 {
 	vattr->va_mask = XFS_AT_NLINK|XFS_AT_SIZE|XFS_AT_NBLOCKS;
-	if (!bhv_vop_getattr(vn_from_inode(ip), vattr, ATTR_LAZY, NULL)) {
+	if (!xfs_getattr(XFS_I(ip), vattr, ATTR_LAZY)) {
 		ip->i_nlink = vattr->va_nlink;
 		ip->i_blocks = vattr->va_nblocks;
 
@@ -233,7 +218,8 @@ xfs_init_security(
 		return -error;
 	}
 
-	error = bhv_vop_attr_set(vp, name, value, length, ATTR_SECURE, NULL);
+	error = xfs_attr_set(XFS_I(ip), name, value,
+			length, ATTR_SECURE);
 	if (!error)
 		VMODIFY(vp);
 
@@ -256,7 +242,7 @@ xfs_has_fs_struct(struct task_struct *ta
 
 STATIC void
 xfs_cleanup_inode(
-	bhv_vnode_t	*dvp,
+	struct inode	*dir,
 	bhv_vnode_t	*vp,
 	struct dentry	*dentry,
 	int		mode)
@@ -272,9 +258,9 @@ xfs_cleanup_inode(
 	teardown.d_name = dentry->d_name;
 
 	if (S_ISDIR(mode))
-	  	bhv_vop_rmdir(dvp, &teardown, NULL);
+		xfs_rmdir(XFS_I(dir), &teardown);
 	else
-		bhv_vop_remove(dvp, &teardown, NULL);
+		xfs_remove(XFS_I(dir), &teardown);
 	VN_RELE(vp);
 }
 
@@ -321,10 +307,10 @@ xfs_vn_mknod(
 		vattr.va_mask |= XFS_AT_RDEV;
 		/*FALLTHROUGH*/
 	case S_IFREG:
-		error = bhv_vop_create(dvp, dentry, &vattr, &vp, NULL);
+		error = xfs_create(XFS_I(dir), dentry, &vattr, &vp, NULL);
 		break;
 	case S_IFDIR:
-		error = bhv_vop_mkdir(dvp, dentry, &vattr, &vp, NULL);
+		error = xfs_mkdir(XFS_I(dir), dentry, &vattr, &vp, NULL);
 		break;
 	default:
 		error = EINVAL;
@@ -334,7 +320,7 @@ xfs_vn_mknod(
 	if (unlikely(!error)) {
 		error = xfs_init_security(vp, dir);
 		if (error)
-			xfs_cleanup_inode(dvp, vp, dentry, mode);
+			xfs_cleanup_inode(dir, vp, dentry, mode);
 	}
 
 	if (unlikely(default_acl)) {
@@ -343,7 +329,7 @@ xfs_vn_mknod(
 			if (!error)
 				VMODIFY(vp);
 			else
-				xfs_cleanup_inode(dvp, vp, dentry, mode);
+				xfs_cleanup_inode(dir, vp, dentry, mode);
 		}
 		_ACL_FREE(default_acl);
 	}
@@ -387,13 +373,13 @@ xfs_vn_lookup(
 	struct dentry	*dentry,
 	struct nameidata *nd)
 {
-	bhv_vnode_t	*vp = vn_from_inode(dir), *cvp;
+	bhv_vnode_t	*cvp;
 	int		error;
 
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	error = bhv_vop_lookup(vp, dentry, &cvp, 0, NULL, NULL);
+	error = xfs_lookup(XFS_I(dir), dentry, &cvp);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
 			return ERR_PTR(-error);
@@ -411,21 +397,19 @@ xfs_vn_link(
 	struct dentry	*dentry)
 {
 	struct inode	*ip;	/* inode of guy being linked to */
-	bhv_vnode_t	*tdvp;	/* target directory for new name/link */
 	bhv_vnode_t	*vp;	/* vp of name being linked */
 	bhv_vattr_t	vattr;
 	int		error;
 
 	ip = old_dentry->d_inode;	/* inode being linked to */
-	tdvp = vn_from_inode(dir);
 	vp = vn_from_inode(ip);
 
 	VN_HOLD(vp);
-	error = bhv_vop_link(tdvp, vp, dentry, NULL);
+	error = xfs_link(XFS_I(dir), vp, dentry);
 	if (unlikely(error)) {
 		VN_RELE(vp);
 	} else {
-		VMODIFY(tdvp);
+		VMODIFY(vn_from_inode(dir));
 		xfs_validate_fields(ip, &vattr);
 		d_instantiate(dentry, ip);
 	}
@@ -438,14 +422,12 @@ xfs_vn_unlink(
 	struct dentry	*dentry)
 {
 	struct inode	*inode;
-	bhv_vnode_t	*dvp;	/* directory containing name to remove */
 	bhv_vattr_t	vattr;
 	int		error;
 
 	inode = dentry->d_inode;
-	dvp = vn_from_inode(dir);
 
-	error = bhv_vop_remove(dvp, dentry, NULL);
+	error = xfs_remove(XFS_I(dir), dentry);
 	if (likely(!error)) {
 		xfs_validate_fields(dir, &vattr);	/* size needs update */
 		xfs_validate_fields(inode, &vattr);
@@ -461,18 +443,17 @@ xfs_vn_symlink(
 {
 	struct inode	*ip;
 	bhv_vattr_t	va = { 0 };
-	bhv_vnode_t	*dvp;	/* directory containing name of symlink */
 	bhv_vnode_t	*cvp;	/* used to lookup symlink to put in dentry */
 	int		error;
 
-	dvp = vn_from_inode(dir);
 	cvp = NULL;
 
 	va.va_mode = S_IFLNK |
 		(irix_symlink_mode ? 0777 & ~current->fs->umask : S_IRWXUGO);
 	va.va_mask = XFS_AT_TYPE|XFS_AT_MODE;
 
-	error = bhv_vop_symlink(dvp, dentry, &va, (char *)symname, &cvp, NULL);
+	error = xfs_symlink(XFS_I(dir), dentry, &va,
+			(char *)symname, &cvp, NULL);
 	if (likely(!error && cvp)) {
 		error = xfs_init_security(cvp, dir);
 		if (likely(!error)) {
@@ -481,7 +462,7 @@ xfs_vn_symlink(
 			xfs_validate_fields(dir, &va);
 			xfs_validate_fields(ip, &va);
 		} else {
-			xfs_cleanup_inode(dvp, cvp, dentry, 0);
+			xfs_cleanup_inode(dir, cvp, dentry, 0);
 		}
 	}
 	return -error;
@@ -493,11 +474,10 @@ xfs_vn_rmdir(
 	struct dentry	*dentry)
 {
 	struct inode	*inode = dentry->d_inode;
-	bhv_vnode_t	*dvp = vn_from_inode(dir);
 	bhv_vattr_t	vattr;
 	int		error;
 
-	error = bhv_vop_rmdir(dvp, dentry, NULL);
+	error = xfs_rmdir(XFS_I(dir), dentry);
 	if (likely(!error)) {
 		xfs_validate_fields(inode, &vattr);
 		xfs_validate_fields(dir, &vattr);
@@ -513,15 +493,13 @@ xfs_vn_rename(
 	struct dentry	*ndentry)
 {
 	struct inode	*new_inode = ndentry->d_inode;
-	bhv_vnode_t	*fvp;	/* from directory */
 	bhv_vnode_t	*tvp;	/* target directory */
 	bhv_vattr_t	vattr;
 	int		error;
 
-	fvp = vn_from_inode(odir);
 	tvp = vn_from_inode(ndir);
 
-	error = bhv_vop_rename(fvp, odentry, tvp, ndentry, NULL);
+	error = xfs_rename(XFS_I(odir), odentry, tvp, ndentry);
 	if (likely(!error)) {
 		if (new_inode)
 			xfs_validate_fields(new_inode, &vattr);
@@ -542,7 +520,6 @@ xfs_vn_follow_link(
 	struct dentry		*dentry,
 	struct nameidata	*nd)
 {
-	bhv_vnode_t		*vp = vn_from_inode(dentry->d_inode);
 	char			*link;
 	int			error = -ENOMEM;
 
@@ -550,7 +527,7 @@ xfs_vn_follow_link(
 	if (!link)
 		goto out_err;
 
-	error = -bhv_vop_readlink(vp, link);
+	error = -xfs_readlink(XFS_I(dentry->d_inode), link);
 	if (unlikely(error))
 		goto out_kfree;
 
@@ -583,7 +560,7 @@ xfs_vn_permission(
 	int		mode,
 	struct nameidata *nd)
 {
-	return -bhv_vop_access(vn_from_inode(inode), mode << 6, NULL);
+	return -xfs_access(XFS_I(inode), mode << 6, NULL);
 }
 #else
 #define xfs_vn_permission NULL
@@ -596,11 +573,10 @@ xfs_vn_getattr(
 	struct kstat	*stat)
 {
 	struct inode	*inode = dentry->d_inode;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	bhv_vattr_t	vattr = { .va_mask = XFS_AT_STAT };
 	int		error;
 
-	error = bhv_vop_getattr(vp, &vattr, ATTR_LAZY, NULL);
+	error = xfs_getattr(XFS_I(inode), &vattr, ATTR_LAZY);
 	if (likely(!error)) {
 		stat->size = i_size_read(inode);
 		stat->dev = inode->i_sb->s_dev;
@@ -628,7 +604,6 @@ xfs_vn_setattr(
 {
 	struct inode	*inode = dentry->d_inode;
 	unsigned int	ia_valid = attr->ia_valid;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	bhv_vattr_t	vattr = { 0 };
 	int		flags = 0;
 	int		error;
@@ -672,9 +647,9 @@ xfs_vn_setattr(
 		flags |= ATTR_NONBLOCK;
 #endif
 
-	error = bhv_vop_setattr(vp, &vattr, flags, NULL);
+	error = xfs_setattr(XFS_I(inode), &vattr, flags, NULL);
 	if (likely(!error))
-		__vn_revalidate(vp, &vattr);
+		__vn_revalidate(vn_from_inode(inode), &vattr);
 	return -error;
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h	2007-08-23 18:58:43.000000000 +0200
@@ -31,4 +31,10 @@ struct xfs_inode;
 extern void xfs_ichgtime(struct xfs_inode *, int);
 extern void xfs_ichgtime_fast(struct xfs_inode *, struct inode *, int);
 
+#define xfs_vtoi(vp) \
+	((struct xfs_inode *)vn_to_inode(vp)->i_private)
+
+#define XFS_I(inode) \
+	((struct xfs_inode *)(inode)->i_private)
+
 #endif /* __XFS_IOPS_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 18:58:43.000000000 +0200
@@ -413,7 +413,7 @@ xfs_readlink_by_handle(
 	if (!link)
 		goto out_iput;
 
-	error = -bhv_vop_readlink(vp, link);
+	error = -xfs_readlink(XFS_I(inode), link);
 	if (error)
 		goto out_kfree;
 	error = do_readlink(hreq.ohandle, olen, link);
@@ -497,8 +497,8 @@ xfs_attrlist_by_handle(
 		goto out_vn_rele;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = bhv_vop_attr_list(vp, kbuf, al_hreq.buflen, al_hreq.flags,
-					cursor, NULL);
+	error = xfs_attr_list(XFS_I(inode), kbuf, al_hreq.buflen,
+					al_hreq.flags, cursor);
 	if (error)
 		goto out_kfree;
 
@@ -515,7 +515,7 @@ xfs_attrlist_by_handle(
 
 STATIC int
 xfs_attrmulti_attr_get(
-	bhv_vnode_t		*vp,
+	struct inode		*inode,
 	char			*name,
 	char			__user *ubuf,
 	__uint32_t		*len,
@@ -530,7 +530,7 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return ENOMEM;
 
-	error = bhv_vop_attr_get(vp, name, kbuf, len, flags, NULL);
+	error = xfs_attr_get(XFS_I(inode), name, kbuf, len, flags, NULL);
 	if (error)
 		goto out_kfree;
 
@@ -544,7 +544,7 @@ xfs_attrmulti_attr_get(
 
 STATIC int
 xfs_attrmulti_attr_set(
-	bhv_vnode_t		*vp,
+	struct inode		*inode,
 	char			*name,
 	const char		__user *ubuf,
 	__uint32_t		len,
@@ -553,9 +553,9 @@ xfs_attrmulti_attr_set(
 	char			*kbuf;
 	int			error = EFAULT;
 
-	if (IS_RDONLY(&vp->v_inode))
+	if (IS_RDONLY(inode))
 		return -EROFS;
-	if (IS_IMMUTABLE(&vp->v_inode) || IS_APPEND(&vp->v_inode))
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return EPERM;
 	if (len > XATTR_SIZE_MAX)
 		return EINVAL;
@@ -567,7 +567,7 @@ xfs_attrmulti_attr_set(
 	if (copy_from_user(kbuf, ubuf, len))
 		goto out_kfree;
 			
-	error = bhv_vop_attr_set(vp, name, kbuf, len, flags, NULL);
+	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
 
  out_kfree:
 	kfree(kbuf);
@@ -576,15 +576,15 @@ xfs_attrmulti_attr_set(
 
 STATIC int
 xfs_attrmulti_attr_remove(
-	bhv_vnode_t		*vp,
+	struct inode		*inode,
 	char			*name,
 	__uint32_t		flags)
 {
-	if (IS_RDONLY(&vp->v_inode))
+	if (IS_RDONLY(inode))
 		return -EROFS;
-	if (IS_IMMUTABLE(&vp->v_inode) || IS_APPEND(&vp->v_inode))
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return EPERM;
-	return bhv_vop_attr_remove(vp, name, flags, NULL);
+	return xfs_attr_remove(XFS_I(inode), name, flags);
 }
 
 STATIC int
@@ -640,17 +640,17 @@ xfs_attrmulti_by_handle(
 
 		switch (ops[i].am_opcode) {
 		case ATTR_OP_GET:
-			ops[i].am_error = xfs_attrmulti_attr_get(vp,
+			ops[i].am_error = xfs_attrmulti_attr_get(inode,
 					attr_name, ops[i].am_attrvalue,
 					&ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
-			ops[i].am_error = xfs_attrmulti_attr_set(vp,
+			ops[i].am_error = xfs_attrmulti_attr_set(inode,
 					attr_name, ops[i].am_attrvalue,
 					ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_REMOVE:
-			ops[i].am_error = xfs_attrmulti_attr_remove(vp,
+			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
 					attr_name, ops[i].am_flags);
 			break;
 		default:
@@ -1182,7 +1182,7 @@ xfs_ioc_xattr(
 	case XFS_IOC_FSGETXATTR: {
 		vattr->va_mask = XFS_AT_XFLAGS | XFS_AT_EXTSIZE | \
 				 XFS_AT_NEXTENTS | XFS_AT_PROJID;
-		error = bhv_vop_getattr(vp, vattr, 0, NULL);
+		error = xfs_getattr(ip, vattr, 0);
 		if (unlikely(error)) {
 			error = -error;
 			break;
@@ -1215,7 +1215,7 @@ xfs_ioc_xattr(
 		vattr->va_extsize = fa.fsx_extsize;
 		vattr->va_projid  = fa.fsx_projid;
 
-		error = bhv_vop_setattr(vp, vattr, attr_flags, NULL);
+		error = xfs_setattr(ip, vattr, attr_flags, NULL);
 		if (likely(!error))
 			__vn_revalidate(vp, vattr);	/* update flags */
 		error = -error;
@@ -1225,7 +1225,7 @@ xfs_ioc_xattr(
 	case XFS_IOC_FSGETXATTRA: {
 		vattr->va_mask = XFS_AT_XFLAGS | XFS_AT_EXTSIZE | \
 				 XFS_AT_ANEXTENTS | XFS_AT_PROJID;
-		error = bhv_vop_getattr(vp, vattr, 0, NULL);
+		error = xfs_getattr(ip, vattr, 0);
 		if (unlikely(error)) {
 			error = -error;
 			break;
@@ -1271,7 +1271,7 @@ xfs_ioc_xattr(
 		vattr->va_xflags = xfs_merge_ioc_xflags(flags,
 							xfs_ip2xflags(ip));
 
-		error = bhv_vop_setattr(vp, vattr, attr_flags, NULL);
+		error = xfs_setattr(ip, vattr, attr_flags, NULL);
 		if (likely(!error))
 			__vn_revalidate(vp, vattr);	/* update flags */
 		error = -error;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 18:58:43.000000000 +0200
@@ -37,6 +37,7 @@
 #include "xfs_error.h"
 #include "xfs_rw.h"
 #include "xfs_iomap.h"
+#include "xfs_vnodeops.h"
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
@@ -231,7 +232,8 @@ xfs_end_bio_unwritten(
 	size_t			size = ioend->io_size;
 
 	if (likely(!ioend->io_error)) {
-		bhv_vop_bmap(vp, offset, size, BMAPI_UNWRITTEN, NULL, NULL);
+		xfs_bmap(xfs_vtoi(vp), offset, size,
+				BMAPI_UNWRITTEN, NULL, NULL);
 		xfs_setfilesize(ioend);
 	}
 	xfs_destroy_ioend(ioend);
@@ -304,7 +306,8 @@ xfs_map_blocks(
 	bhv_vnode_t		*vp = vn_from_inode(inode);
 	int			error, nmaps = 1;
 
-	error = bhv_vop_bmap(vp, offset, count, flags, mapp, &nmaps);
+	error = xfs_bmap(xfs_vtoi(vp), offset, count,
+				flags, mapp, &nmaps);
 	if (!error && (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)))
 		VMODIFY(vp);
 	return -error;
@@ -1322,7 +1325,6 @@ __xfs_get_blocks(
 	int			direct,
 	bmapi_flags_t		flags)
 {
-	bhv_vnode_t		*vp = vn_from_inode(inode);
 	xfs_iomap_t		iomap;
 	xfs_off_t		offset;
 	ssize_t			size;
@@ -1332,7 +1334,7 @@ __xfs_get_blocks(
 	offset = (xfs_off_t)iblock << inode->i_blkbits;
 	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
 	size = bh_result->b_size;
-	error = bhv_vop_bmap(vp, offset, size,
+	error = xfs_bmap(XFS_I(inode), offset, size,
 			     create ? flags : BMAPI_READ, &iomap, &niomap);
 	if (error)
 		return -error;
@@ -1480,13 +1482,13 @@ xfs_vm_direct_IO(
 {
 	struct file	*file = iocb->ki_filp;
 	struct inode	*inode = file->f_mapping->host;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	xfs_iomap_t	iomap;
 	int		maps = 1;
 	int		error;
 	ssize_t		ret;
 
-	error = bhv_vop_bmap(vp, offset, 0, BMAPI_DEVICE, &iomap, &maps);
+	error = xfs_bmap(XFS_I(inode), offset, 0,
+				BMAPI_DEVICE, &iomap, &maps);
 	if (error)
 		return -error;
 
@@ -1527,12 +1529,13 @@ xfs_vm_bmap(
 	sector_t		block)
 {
 	struct inode		*inode = (struct inode *)mapping->host;
-	bhv_vnode_t		*vp = vn_from_inode(inode);
+	struct xfs_inode	*ip = XFS_I(inode);
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
-	bhv_vop_rwlock(vp, VRWLOCK_READ);
-	bhv_vop_flush_pages(vp, (xfs_off_t)0, -1, 0, FI_REMAPF);
-	bhv_vop_rwunlock(vp, VRWLOCK_READ);
+	vn_trace_entry(vn_from_inode(inode), __FUNCTION__,
+			(inst_t *)__return_address);
+	xfs_rwlock(ip, VRWLOCK_READ);
+	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
+	xfs_rwunlock(ip, VRWLOCK_READ);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2007-08-23 18:58:43.000000000 +0200
@@ -25,6 +25,9 @@
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
 #include "xfs_export.h"
+#include "xfs_vnodeops.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
 
 static struct dentry dotdot = { .d_name.name = "..", .d_name.len = 2, };
 
@@ -161,12 +164,11 @@ xfs_fs_get_parent(
 	struct dentry		*child)
 {
 	int			error;
-	bhv_vnode_t		*vp, *cvp;
+	bhv_vnode_t		*cvp;
 	struct dentry		*parent;
 
 	cvp = NULL;
-	vp = vn_from_inode(child->d_inode);
-	error = bhv_vop_lookup(vp, &dotdot, &cvp, 0, NULL, NULL);
+	error = xfs_lookup(XFS_I(child->d_inode), &dotdot, &cvp);
 	if (unlikely(error))
 		return ERR_PTR(-error);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2007-08-23 18:58:43.000000000 +0200
@@ -43,6 +43,7 @@
 #include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_dfrag.h"
+#include "xfs_vnodeops.h"
 
 #define  _NATIVE_IOC(cmd, type) \
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
@@ -443,7 +444,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_bulkreq);
-		return xfs_ioc_bulkstat_compat(XFS_BHVTOI(VNHEAD(vp))->i_mount,
+		return xfs_ioc_bulkstat_compat(XFS_I(inode)->i_mount,
 				cmd, (void*)arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
@@ -457,7 +458,7 @@ xfs_compat_ioctl(
 		return -ENOIOCTLCMD;
 	}
 
-	error = bhv_vop_ioctl(vp, inode, file, mode, cmd, (void __user *)arg);
+	error = xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
 	VMODIFY(vp);
 
 	return error;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 18:58:43.000000000 +0200
@@ -257,8 +257,9 @@ xfs_read(
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		if (VN_CACHED(vp))
-			ret = bhv_vop_flushinval_pages(vp, ctooff(offtoct(*offset)),
-						 -1, FI_REMAPF_LOCKED);
+			ret = xfs_flushinval_pages(ip,
+					ctooff(offtoct(*offset)),
+					-1, FI_REMAPF_LOCKED);
 		mutex_unlock(&inode->i_mutex);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -809,7 +810,8 @@ retry:
 			WARN_ON(need_i_mutex == 0);
 			xfs_inval_cached_trace(io, pos, -1,
 					ctooff(offtoct(pos)), -1);
-			error = bhv_vop_flushinval_pages(vp, ctooff(offtoct(pos)),
+			error = xfs_flushinval_pages(xip,
+					ctooff(offtoct(pos)),
 					-1, FI_REMAPF_LOCKED);
 			if (error)
 				goto out_unlock_internal;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 18:58:43.000000000 +0200
@@ -16,6 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
+#include "xfs_vnodeops.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
 
 uint64_t vn_generation;		/* vnode generation number */
 DEFINE_SPINLOCK(vnumber_lock);
@@ -90,9 +93,6 @@ vn_initialize(
 
 	ASSERT(VN_CACHED(vp) == 0);
 
-	/* Initialize the first behavior and the behavior chain head. */
-	vn_bhv_head_init(VN_BHV_HEAD(vp), "vnode");
-
 	atomic_set(&vp->v_iocount, 0);
 
 #ifdef	XFS_VNODE_TRACE
@@ -152,7 +152,7 @@ __vn_revalidate(
 
 	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
 	vattr->va_mask = XFS_AT_STAT | XFS_AT_XFLAGS;
-	error = bhv_vop_getattr(vp, vattr, 0, NULL);
+	error = xfs_getattr(xfs_vtoi(vp), vattr, 0);
 	if (likely(!error)) {
 		vn_revalidate_core(vp, vattr);
 		VUNMODIFY(vp);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 18:58:43.000000000 +0200
@@ -46,6 +46,7 @@
 #include "xfs_attr.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
+#include "xfs_vnodeops.h"
 #include "xfs_version.h"
 
 #include <linux/namei.h>
@@ -203,16 +204,15 @@ void
 xfs_initialize_vnode(
 	bhv_desc_t		*bdp,
 	bhv_vnode_t		*vp,
-	bhv_desc_t		*inode_bhv,
+	struct xfs_inode	*ip,
 	int			unlock)
 {
-	xfs_inode_t		*ip = XFS_BHVTOI(inode_bhv);
 	struct inode		*inode = vn_to_inode(vp);
 
-	if (!inode_bhv->bd_vobj) {
+	if (!ip->i_vnode) {
 		vp->v_vfsp = bhvtovfs(bdp);
-		bhv_desc_init(inode_bhv, ip, vp, &xfs_vnodeops);
-		bhv_insert(VN_BHV_HEAD(vp), inode_bhv);
+		ip->i_vnode = vp;
+		inode->i_private = ip;
 	}
 
 	/*
@@ -411,17 +411,21 @@ xfs_fs_write_inode(
 	struct inode		*inode,
 	int			sync)
 {
-	bhv_vnode_t		*vp = vn_from_inode(inode);
 	int			error = 0, flags = FLUSH_INODE;
 
-	if (vp) {
-		vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	vn_trace_entry(vn_from_inode(inode), __FUNCTION__,
+			(inst_t *)__return_address);
+	if (sync)
+		flags |= FLUSH_SYNC;
+	error = xfs_inode_flush(XFS_I(inode), flags);
+	if (error == EAGAIN) {
 		if (sync)
-			flags |= FLUSH_SYNC;
-		error = bhv_vop_iflush(vp, flags);
-		if (error == EAGAIN)
-			error = sync? bhv_vop_iflush(vp, flags | FLUSH_LOG) : 0;
+			error = xfs_inode_flush(XFS_I(inode),
+						       flags | FLUSH_LOG);
+		else
+			error = 0;
 	}
+
 	return -error;
 }
 
@@ -442,18 +446,18 @@ xfs_fs_clear_inode(
 	 * This can happen because xfs_iget_core calls xfs_idestroy if we
 	 * find an inode with di_mode == 0 but without IGET_CREATE set.
 	 */
-	if (VNHEAD(vp))
-		bhv_vop_inactive(vp, NULL);
+	if (XFS_I(inode))
+		xfs_inactive(XFS_I(inode));
 
 	VN_LOCK(vp);
 	vp->v_flag &= ~VMODIFIED;
 	VN_UNLOCK(vp, 0);
 
-	if (VNHEAD(vp))
-		if (bhv_vop_reclaim(vp))
+	if (XFS_I(inode))
+		if (xfs_reclaim(XFS_I(inode)))
 			panic("%s: cannot reclaim 0x%p\n", __FUNCTION__, vp);
 
-	ASSERT(VNHEAD(vp) == NULL);
+	ASSERT(XFS_I(inode) == NULL);
 
 #ifdef XFS_VNODE_TRACE
 	ktrace_free(vp->v_trace);
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2007-08-23 18:58:43.000000000 +0200
@@ -32,6 +32,7 @@
 #include "xfs_btree.h"
 #include "xfs_acl.h"
 #include "xfs_attr.h"
+#include "xfs_vnodeops.h"
 
 #include <linux/capability.h>
 #include <linux/posix_acl_xattr.h>
@@ -241,7 +242,7 @@ xfs_acl_vget(
 			bhv_vattr_t	va;
 
 			va.va_mask = XFS_AT_MODE;
-			error = bhv_vop_getattr(vp, &va, 0, sys_cred);
+			error = xfs_getattr(xfs_vtoi(vp), &va, 0);
 			if (error)
 				goto out;
 			xfs_acl_sync_mode(va.va_mode, xfs_acl);
@@ -265,9 +266,10 @@ xfs_acl_vremove(
 	VN_HOLD(vp);
 	error = xfs_acl_allow_set(vp, kind);
 	if (!error) {
-		error = bhv_vop_attr_remove(vp, kind == _ACL_TYPE_DEFAULT?
+		error = xfs_attr_remove(xfs_vtoi(vp),
+						kind == _ACL_TYPE_DEFAULT?
 						SGI_ACL_DEFAULT: SGI_ACL_FILE,
-						ATTR_ROOT, sys_cred);
+						ATTR_ROOT);
 		if (error == ENOATTR)
 			error = 0;	/* 'scool */
 	}
@@ -380,7 +382,7 @@ xfs_acl_allow_set(
 	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
 		return EROFS;
 	va.va_mask = XFS_AT_UID;
-	error = bhv_vop_getattr(vp, &va, 0, NULL);
+	error = xfs_getattr(xfs_vtoi(vp), &va, 0);
 	if (error)
 		return error;
 	if (va.va_uid != current->fsuid && !capable(CAP_FOWNER))
@@ -614,7 +616,8 @@ xfs_acl_get_attr(
 
 	ASSERT((flags & ATTR_KERNOVAL) ? (aclp == NULL) : 1);
 	flags |= ATTR_ROOT;
-	*error = bhv_vop_attr_get(vp, kind == _ACL_TYPE_ACCESS ?
+	*error = xfs_attr_get(xfs_vtoi(vp),
+					kind == _ACL_TYPE_ACCESS ?
 					SGI_ACL_FILE : SGI_ACL_DEFAULT,
 					(char *)aclp, &len, flags, sys_cred);
 	if (*error || (flags & ATTR_KERNOVAL))
@@ -652,9 +655,10 @@ xfs_acl_set_attr(
 		INT_SET(newace->ae_perm, ARCH_CONVERT, ace->ae_perm);
 	}
 	INT_SET(newacl->acl_cnt, ARCH_CONVERT, aclp->acl_cnt);
-	*error = bhv_vop_attr_set(vp, kind == _ACL_TYPE_ACCESS ?
+	*error = xfs_attr_set(xfs_vtoi(vp),
+				kind == _ACL_TYPE_ACCESS ?
 				SGI_ACL_FILE: SGI_ACL_DEFAULT,
-				(char *)newacl, len, ATTR_ROOT, sys_cred);
+				(char *)newacl, len, ATTR_ROOT);
 	_ACL_FREE(newacl);
 }
 
@@ -676,7 +680,7 @@ xfs_acl_vtoacl(
 		if (!error) {
 			/* Got the ACL, need the mode... */
 			va.va_mask = XFS_AT_MODE;
-			error = bhv_vop_getattr(vp, &va, 0, sys_cred);
+			error = xfs_getattr(xfs_vtoi(vp), &va, 0);
 		}
 
 		if (error)
@@ -774,7 +778,7 @@ xfs_acl_setmode(
 	 * mode.  The m:: bits take precedence over the g:: bits.
 	 */
 	va.va_mask = XFS_AT_MODE;
-	error = bhv_vop_getattr(vp, &va, 0, sys_cred);
+	error = xfs_getattr(xfs_vtoi(vp), &va, 0);
 	if (error)
 		return error;
 
@@ -808,7 +812,7 @@ xfs_acl_setmode(
 	if (gap && nomask)
 		va.va_mode |= gap->ae_perm << 3;
 
-	return bhv_vop_setattr(vp, &va, 0, sys_cred);
+	return xfs_setattr(xfs_vtoi(vp), &va, 0, sys_cred);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2007-08-23 18:58:43.000000000 +0200
@@ -49,6 +49,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_acl.h"
 #include "xfs_rw.h"
+#include "xfs_vnodeops.h"
 
 /*
  * xfs_attr.c
@@ -2512,7 +2513,7 @@ STATIC int
 attr_generic_set(
 	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
 {
-	return -bhv_vop_attr_set(vp, name, data, size, xflags, NULL);
+	return -xfs_attr_set(xfs_vtoi(vp), name, data, size, xflags);
 }
 
 STATIC int
@@ -2521,7 +2522,8 @@ attr_generic_get(
 {
 	int	error, asize = size;
 
-	error = bhv_vop_attr_get(vp, name, data, &asize, xflags, NULL);
+	error = xfs_attr_get(xfs_vtoi(vp), name, data,
+				    &asize, xflags, NULL);
 	if (!error)
 		return asize;
 	return -error;
@@ -2531,7 +2533,7 @@ STATIC int
 attr_generic_remove(
 	bhv_vnode_t *vp, char *name, int xflags)
 {
-	return -bhv_vop_attr_remove(vp, name, xflags, NULL);
+	return -xfs_attr_remove(xfs_vtoi(vp), name, xflags);
 }
 
 STATIC int
@@ -2586,7 +2588,7 @@ attr_generic_list(
 	attrlist_cursor_kern_t	cursor = { 0 };
 	int			error;
 
-	error = bhv_vop_attr_list(vp, data, size, xflags, &cursor, NULL);
+	error = xfs_attr_list(xfs_vtoi(vp), data, size, xflags, &cursor);
 	if (error > 0)
 		return -error;
 	*result = -error;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2007-08-23 18:58:43.000000000 +0200
@@ -53,6 +53,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_buf_item.h"
 #include "xfs_filestream.h"
+#include "xfs_vnodeops.h"
 
 
 #ifdef DEBUG
@@ -5868,7 +5869,8 @@ xfs_getbmap(
 	if (whichfork == XFS_DATA_FORK &&
 		(ip->i_delayed_blks || ip->i_size > ip->i_d.di_size)) {
 		/* xfs_fsize_t last_byte = xfs_file_last_byte(ip); */
-		error = bhv_vop_flush_pages(vp, (xfs_off_t)0, -1, 0, FI_REMAPF);
+		error = xfs_flush_pages(ip, (xfs_off_t)0,
+					       -1, 0, FI_REMAPF);
 	}
 
 	ASSERT(whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0);
Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2007-08-23 18:58:43.000000000 +0200
@@ -42,6 +42,7 @@
 #include "xfs_dfrag.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
+#include "xfs_vnodeops.h"
 
 /*
  * Syssgi interface for swapext
@@ -199,7 +200,8 @@ xfs_swap_extents(
 
 	if (VN_CACHED(tvp) != 0) {
 		xfs_inval_cached_trace(&tip->i_iocore, 0, -1, 0, -1);
-		error = bhv_vop_flushinval_pages(tvp, 0, -1, FI_REMAPF_LOCKED);
+		error = xfs_flushinval_pages(tip, 0, -1,
+				FI_REMAPF_LOCKED);
 		if (error)
 			goto error0;
 	}
@@ -265,7 +267,7 @@ xfs_swap_extents(
 	 * fields change.
 	 */
 
-	bhv_vop_toss_pages(vp, 0, -1, FI_REMAPF);
+	xfs_tosspages(ip, 0, -1, FI_REMAPF);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
 	if ((error = xfs_trans_reserve(tp, 0,
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-08-23 18:58:43.000000000 +0200
@@ -49,6 +49,7 @@
 #include "xfs_quota.h"
 #include "xfs_acl.h"
 #include "xfs_filestream.h"
+#include "xfs_vnodeops.h"
 
 kmem_zone_t *xfs_ifork_zone;
 kmem_zone_t *xfs_inode_zone;
@@ -1267,7 +1268,7 @@ xfs_ialloc(
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup inode ops and unlock */
-	bhv_vfs_init_vnode(XFS_MTOVFS(tp->t_mountp), vp, XFS_ITOBHV(ip), 1);
+	bhv_vfs_init_vnode(XFS_MTOVFS(tp->t_mountp), vp, ip, 1);
 
 	*ipp = ip;
 	return 0;
@@ -1489,9 +1490,11 @@ xfs_itruncate_start(
 			 last_byte);
 	if (last_byte > toss_start) {
 		if (flags & XFS_ITRUNC_DEFINITE) {
-			bhv_vop_toss_pages(vp, toss_start, -1, FI_REMAPF_LOCKED);
+			xfs_tosspages(ip, toss_start,
+					-1, FI_REMAPF_LOCKED);
 		} else {
-			error = bhv_vop_flushinval_pages(vp, toss_start, -1, FI_REMAPF_LOCKED);
+			error = xfs_flushinval_pages(ip, toss_start,
+					-1, FI_REMAPF_LOCKED);
 		}
 	}
 
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2007-08-23 18:58:43.000000000 +0200
@@ -586,11 +586,8 @@ xfs_rename(
 	/*
 	 * Let interposed file systems know about removed links.
 	 */
-	if (target_ip_dropped) {
-		bhv_vop_link_removed(XFS_ITOV(target_ip), target_dir_vp,
-					target_link_zero);
+	if (target_ip_dropped)
 		IRELE(target_ip);
-	}
 
 	IRELE(src_ip);
 
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-23 18:58:43.000000000 +0200
@@ -54,6 +54,8 @@
 #include "xfs_mru_cache.h"
 #include "xfs_filestream.h"
 #include "xfs_fsops.h"
+#include "xfs_vnodeops.h"
+
 
 STATIC int	xfs_sync(bhv_desc_t *, int, cred_t *);
 
@@ -1191,12 +1193,13 @@ xfs_sync_inodes(
 			if (flags & SYNC_CLOSE) {
 				/* Shutdown case. Flush and invalidate. */
 				if (XFS_FORCED_SHUTDOWN(mp))
-					bhv_vop_toss_pages(vp, 0, -1, FI_REMAPF);
+					xfs_tosspages(ip, 0, -1,
+							     FI_REMAPF);
 				else
-					error = bhv_vop_flushinval_pages(vp, 0,
-								-1, FI_REMAPF);
+					error = xfs_flushinval_pages(ip,
+							0, -1, FI_REMAPF);
 			} else if ((flags & SYNC_DELWRI) && VN_DIRTY(vp)) {
-				error = bhv_vop_flush_pages(vp, (xfs_off_t)0,
+				error = xfs_flush_pages(ip, 0,
 							-1, fflag, FI_NONE);
 			}
 
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-23 18:58:43.000000000 +0200
@@ -592,7 +592,7 @@ xfs_setattr(
 		if (!code &&
 		    (ip->i_size != ip->i_d.di_size) &&
 		    (vap->va_size > ip->i_d.di_size)) {
-			code = bhv_vop_flush_pages(XFS_ITOV(ip),
+			code = xfs_flush_pages(ip,
 					ip->i_d.di_size, vap->va_size,
 					XFS_B_ASYNC, FI_NONE);
 		}
@@ -864,10 +864,6 @@ xfs_setattr(
 	 * racing calls to vop_vnode_change.
 	 */
 	mandlock_after = MANDLOCK(vp, ip->i_d.di_mode);
-	if (mandlock_before != mandlock_after) {
-		bhv_vop_vnode_change(vp, VCHANGE_FLAGS_ENF_LOCKING,
-				 mandlock_after);
-	}
 
 	xfs_iunlock(ip, lock_flags);
 
@@ -1541,7 +1537,7 @@ xfs_release(
 		 * be exposed to that problem.
 		 */
 		if (VUNTRUNCATE(vp) && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
-			bhv_vop_flush_pages(vp, 0, -1, XFS_B_ASYNC, FI_NONE);
+			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
 	}
 
 #ifdef HAVE_REFCACHE
@@ -2005,12 +2001,6 @@ xfs_create(
 	XFS_QM_DQRELE(mp, udqp);
 	XFS_QM_DQRELE(mp, gdqp);
 
-	/*
-	 * Propagate the fact that the vnode changed after the
-	 * xfs_inode locks have been released.
-	 */
-	bhv_vop_vnode_change(vp, VCHANGE_FLAGS_TRUNCATED, 3);
-
 	*vpp = vp;
 
 	/* Fallthrough to std_return with error = 0  */
@@ -2509,11 +2499,6 @@ xfs_remove(
 
 	vn_trace_exit(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 
-	/*
-	 * Let interposed file systems know about removed links.
-	 */
-	bhv_vop_link_removed(XFS_ITOV(ip), dir_vp, link_zero);
-
 	IRELE(ip);
 
 /*	Fall through to std_return with error = 0 */
@@ -3143,11 +3128,6 @@ xfs_rmdir(
 	}
 
 
-	/*
-	 * Let interposed file systems know about removed links.
-	 */
-	bhv_vop_link_removed(XFS_ITOV(cdp), dir_vp, last_cdp_link);
-
 	IRELE(cdp);
 
 	/* Fall through to std_return with error = 0 or the errno
@@ -3728,7 +3708,8 @@ xfs_reclaim(
 		XFS_MOUNT_ILOCK(mp);
 		spin_lock(&ip->i_flags_lock);
 		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		vn_bhv_remove(VN_BHV_HEAD(vp), XFS_ITOBHV(ip));
+		vn_to_inode(vp)->i_private = NULL;
+		ip->i_vnode = NULL;
 		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
 		XFS_MOUNT_IUNLOCK(mp);
@@ -4210,7 +4191,8 @@ xfs_free_file_space(
 	if (VN_CACHED(vp) != 0) {
 		xfs_inval_cached_trace(&ip->i_iocore, ioffset, -1,
 				ctooff(offtoct(ioffset)), -1);
-		error = bhv_vop_flushinval_pages(vp, ctooff(offtoct(ioffset)),
+		error = xfs_flushinval_pages(ip,
+				ctooff(offtoct(ioffset)),
 				-1, FI_REMAPF_LOCKED);
 		if (error)
 			goto out_unlock_iolock;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 18:58:43.000000000 +0200
@@ -41,7 +41,6 @@ typedef struct bhv_vnode {
 	bhv_vflags_t	v_flag;			/* vnode flags (see above) */
 	bhv_vfs_t	*v_vfsp;		/* ptr to containing VFS */
 	bhv_vnumber_t	v_number;		/* in-core vnode number */
-	bhv_head_t	v_bh;			/* behavior head */
 	spinlock_t	v_lock;			/* VN_LOCK/VN_UNLOCK */
 	atomic_t	v_iocount;		/* outstanding I/O count */
 #ifdef XFS_VNODE_TRACE
@@ -57,34 +56,6 @@ typedef struct bhv_vnode {
 #define VN_ISCHR(vp)	S_ISCHR((vp)->v_inode.i_mode)
 #define VN_ISBLK(vp)	S_ISBLK((vp)->v_inode.i_mode)
 
-#define VNODE_POSITION_BASE	BHV_POSITION_BASE	/* chain bottom */
-#define VNODE_POSITION_TOP	BHV_POSITION_TOP	/* chain top */
-#define VNODE_POSITION_INVALID	BHV_POSITION_INVALID	/* invalid pos. num */
-
-typedef enum {
-	VN_BHV_UNKNOWN,		/* not specified */
-	VN_BHV_XFS,		/* xfs */
-	VN_BHV_DM,		/* data migration */
-	VN_BHV_QM,		/* quota manager */
-	VN_BHV_IO,		/* IO path */
-	VN_BHV_END		/* housekeeping end-of-range */
-} vn_bhv_t;
-
-#define VNODE_POSITION_XFS	(VNODE_POSITION_BASE)
-#define VNODE_POSITION_DM	(VNODE_POSITION_BASE+10)
-#define VNODE_POSITION_QM	(VNODE_POSITION_BASE+20)
-#define VNODE_POSITION_IO	(VNODE_POSITION_BASE+30)
-
-/*
- * Macros for dealing with the behavior descriptor inside of the vnode.
- */
-#define BHV_TO_VNODE(bdp)	((bhv_vnode_t *)BHV_VOBJ(bdp))
-#define BHV_TO_VNODE_NULL(bdp)	((bhv_vnode_t *)BHV_VOBJNULL(bdp))
-
-#define VN_BHV_HEAD(vp)			((bhv_head_t *)(&((vp)->v_bh)))
-#define vn_bhv_head_init(bhp,name)	bhv_head_init(bhp,name)
-#define vn_bhv_remove(bhp,bdp)		bhv_remove(bhp,bdp)
-
 /*
  * Vnode to Linux inode mapping.
  */
@@ -110,7 +81,7 @@ typedef enum bhv_vrwlock {
 } bhv_vrwlock_t;
 
 /*
- * Return values for bhv_vop_inactive.  A return value of
+ * Return values for xfs_inactive.  A return value of
  * VN_INACTIVE_NOCACHE implies that the file system behavior
  * has disassociated its state and bhv_desc_t from the vnode.
  */
@@ -118,201 +89,6 @@ typedef enum bhv_vrwlock {
 #define	VN_INACTIVE_NOCACHE	1
 
 /*
- * Values for the cmd code given to vop_vnode_change.
- */
-typedef enum bhv_vchange {
-	VCHANGE_FLAGS_FRLOCKS		= 0,
-	VCHANGE_FLAGS_ENF_LOCKING	= 1,
-	VCHANGE_FLAGS_TRUNCATED		= 2,
-	VCHANGE_FLAGS_PAGE_DIRTY	= 3,
-	VCHANGE_FLAGS_IOEXCL_COUNT	= 4
-} bhv_vchange_t;
-
-typedef int	(*vop_open_t)(bhv_desc_t *, struct cred *);
-typedef ssize_t (*vop_read_t)(bhv_desc_t *, struct kiocb *,
-				const struct iovec *, unsigned int,
-				loff_t *, int, struct cred *);
-typedef ssize_t (*vop_write_t)(bhv_desc_t *, struct kiocb *,
-				const struct iovec *, unsigned int,
-				loff_t *, int, struct cred *);
-typedef ssize_t (*vop_sendfile_t)(bhv_desc_t *, struct file *,
-				loff_t *, int, size_t, read_actor_t,
-				void *, struct cred *);
-typedef ssize_t (*vop_splice_read_t)(bhv_desc_t *, struct file *, loff_t *,
-				struct pipe_inode_info *, size_t, int, int,
-				struct cred *);
-typedef ssize_t (*vop_splice_write_t)(bhv_desc_t *, struct pipe_inode_info *,
-				struct file *, loff_t *, size_t, int, int,
-				struct cred *);
-typedef int	(*vop_ioctl_t)(bhv_desc_t *, struct inode *, struct file *,
-				int, unsigned int, void __user *);
-typedef int	(*vop_getattr_t)(bhv_desc_t *, struct bhv_vattr *, int,
-				struct cred *);
-typedef int	(*vop_setattr_t)(bhv_desc_t *, struct bhv_vattr *, int,
-				struct cred *);
-typedef int	(*vop_access_t)(bhv_desc_t *, int, struct cred *);
-typedef int	(*vop_lookup_t)(bhv_desc_t *, bhv_vname_t *, bhv_vnode_t **,
-				int, bhv_vnode_t *, struct cred *);
-typedef int	(*vop_create_t)(bhv_desc_t *, bhv_vname_t *, struct bhv_vattr *,
-				bhv_vnode_t **, struct cred *);
-typedef int	(*vop_remove_t)(bhv_desc_t *, bhv_vname_t *, struct cred *);
-typedef int	(*vop_link_t)(bhv_desc_t *, bhv_vnode_t *, bhv_vname_t *,
-				struct cred *);
-typedef int	(*vop_rename_t)(bhv_desc_t *, bhv_vname_t *, bhv_vnode_t *,
-				bhv_vname_t *, struct cred *);
-typedef int	(*vop_mkdir_t)(bhv_desc_t *, bhv_vname_t *, struct bhv_vattr *,
-				bhv_vnode_t **, struct cred *);
-typedef int	(*vop_rmdir_t)(bhv_desc_t *, bhv_vname_t *, struct cred *);
-typedef int	(*vop_readdir_t)(bhv_desc_t *, void *dirent, size_t bufsize,
-				 xfs_off_t *offset, filldir_t filldir);
-typedef int	(*vop_symlink_t)(bhv_desc_t *, bhv_vname_t *, struct bhv_vattr*,
-				char *, bhv_vnode_t **, struct cred *);
-typedef int	(*vop_readlink_t)(bhv_desc_t *, char *);
-typedef int	(*vop_fsync_t)(bhv_desc_t *, int, struct cred *,
-				xfs_off_t, xfs_off_t);
-typedef int	(*vop_inactive_t)(bhv_desc_t *, struct cred *);
-typedef int	(*vop_fid2_t)(bhv_desc_t *, struct fid *);
-typedef int	(*vop_release_t)(bhv_desc_t *);
-typedef int	(*vop_rwlock_t)(bhv_desc_t *, bhv_vrwlock_t);
-typedef void	(*vop_rwunlock_t)(bhv_desc_t *, bhv_vrwlock_t);
-typedef	int	(*vop_frlock_t)(bhv_desc_t *, int, struct file_lock *,int,
-				xfs_off_t, struct cred *);
-typedef int	(*vop_bmap_t)(bhv_desc_t *, xfs_off_t, ssize_t, int,
-				struct xfs_iomap *, int *);
-typedef int	(*vop_reclaim_t)(bhv_desc_t *);
-typedef int	(*vop_attr_get_t)(bhv_desc_t *, const char *, char *, int *,
-				int, struct cred *);
-typedef	int	(*vop_attr_set_t)(bhv_desc_t *, const char *, char *, int,
-				int, struct cred *);
-typedef	int	(*vop_attr_remove_t)(bhv_desc_t *, const char *,
-				int, struct cred *);
-typedef	int	(*vop_attr_list_t)(bhv_desc_t *, char *, int, int,
-				struct attrlist_cursor_kern *, struct cred *);
-typedef void	(*vop_link_removed_t)(bhv_desc_t *, bhv_vnode_t *, int);
-typedef void	(*vop_vnode_change_t)(bhv_desc_t *, bhv_vchange_t, __psint_t);
-typedef void	(*vop_ptossvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-typedef int	(*vop_pflushinvalvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-typedef int	(*vop_pflushvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t,
-				uint64_t, int);
-typedef int	(*vop_iflush_t)(bhv_desc_t *, int);
-
-
-typedef struct bhv_vnodeops {
-	bhv_position_t  vn_position;    /* position within behavior chain */
-	vop_open_t		vop_open;
-	vop_read_t		vop_read;
-	vop_write_t		vop_write;
-	vop_sendfile_t		vop_sendfile;
-	vop_splice_read_t	vop_splice_read;
-	vop_splice_write_t	vop_splice_write;
-	vop_ioctl_t		vop_ioctl;
-	vop_getattr_t		vop_getattr;
-	vop_setattr_t		vop_setattr;
-	vop_access_t		vop_access;
-	vop_lookup_t		vop_lookup;
-	vop_create_t		vop_create;
-	vop_remove_t		vop_remove;
-	vop_link_t		vop_link;
-	vop_rename_t		vop_rename;
-	vop_mkdir_t		vop_mkdir;
-	vop_rmdir_t		vop_rmdir;
-	vop_readdir_t		vop_readdir;
-	vop_symlink_t		vop_symlink;
-	vop_readlink_t		vop_readlink;
-	vop_fsync_t		vop_fsync;
-	vop_inactive_t		vop_inactive;
-	vop_fid2_t		vop_fid2;
-	vop_rwlock_t		vop_rwlock;
-	vop_rwunlock_t		vop_rwunlock;
-	vop_frlock_t		vop_frlock;
-	vop_bmap_t		vop_bmap;
-	vop_reclaim_t		vop_reclaim;
-	vop_attr_get_t		vop_attr_get;
-	vop_attr_set_t		vop_attr_set;
-	vop_attr_remove_t	vop_attr_remove;
-	vop_attr_list_t		vop_attr_list;
-	vop_link_removed_t	vop_link_removed;
-	vop_vnode_change_t	vop_vnode_change;
-	vop_ptossvp_t		vop_tosspages;
-	vop_pflushinvalvp_t	vop_flushinval_pages;
-	vop_pflushvp_t		vop_flush_pages;
-	vop_release_t		vop_release;
-	vop_iflush_t		vop_iflush;
-} bhv_vnodeops_t;
-
-/*
- * Virtual node operations, operating from head bhv.
- */
-#define VNHEAD(vp)	((vp)->v_bh.bh_first)
-#define VOP(op, vp)	(*((bhv_vnodeops_t *)VNHEAD(vp)->bd_ops)->op)
-#define bhv_vop_open(vp, cr)		VOP(vop_open, vp)(VNHEAD(vp),cr)
-#define bhv_vop_read(vp,file,iov,segs,offset,ioflags,cr)		\
-		VOP(vop_read, vp)(VNHEAD(vp),file,iov,segs,offset,ioflags,cr)
-#define bhv_vop_write(vp,file,iov,segs,offset,ioflags,cr)		\
-		VOP(vop_write, vp)(VNHEAD(vp),file,iov,segs,offset,ioflags,cr)
-#define bhv_vop_sendfile(vp,f,off,ioflags,cnt,act,targ,cr)		\
-		VOP(vop_sendfile, vp)(VNHEAD(vp),f,off,ioflags,cnt,act,targ,cr)
-#define bhv_vop_splice_read(vp,f,o,pipe,cnt,fl,iofl,cr)			\
-		VOP(vop_splice_read, vp)(VNHEAD(vp),f,o,pipe,cnt,fl,iofl,cr)
-#define bhv_vop_splice_write(vp,f,o,pipe,cnt,fl,iofl,cr)		\
-		VOP(vop_splice_write, vp)(VNHEAD(vp),f,o,pipe,cnt,fl,iofl,cr)
-#define bhv_vop_bmap(vp,of,sz,rw,b,n)					\
-		VOP(vop_bmap, vp)(VNHEAD(vp),of,sz,rw,b,n)
-#define bhv_vop_getattr(vp, vap,f,cr)					\
-		VOP(vop_getattr, vp)(VNHEAD(vp), vap,f,cr)
-#define	bhv_vop_setattr(vp, vap,f,cr)					\
-		VOP(vop_setattr, vp)(VNHEAD(vp), vap,f,cr)
-#define	bhv_vop_access(vp, mode,cr)	VOP(vop_access, vp)(VNHEAD(vp), mode,cr)
-#define	bhv_vop_lookup(vp,d,vpp,f,rdir,cr)				\
-		VOP(vop_lookup, vp)(VNHEAD(vp),d,vpp,f,rdir,cr)
-#define bhv_vop_create(dvp,d,vap,vpp,cr)				\
-		VOP(vop_create, dvp)(VNHEAD(dvp),d,vap,vpp,cr)
-#define bhv_vop_remove(dvp,d,cr)	VOP(vop_remove, dvp)(VNHEAD(dvp),d,cr)
-#define	bhv_vop_link(dvp,fvp,d,cr)	VOP(vop_link, dvp)(VNHEAD(dvp),fvp,d,cr)
-#define	bhv_vop_rename(fvp,fnm,tdvp,tnm,cr)				\
-		VOP(vop_rename, fvp)(VNHEAD(fvp),fnm,tdvp,tnm,cr)
-#define	bhv_vop_mkdir(dp,d,vap,vpp,cr)					\
-		VOP(vop_mkdir, dp)(VNHEAD(dp),d,vap,vpp,cr)
-#define	bhv_vop_rmdir(dp,d,cr)	 	VOP(vop_rmdir, dp)(VNHEAD(dp),d,cr)
-#define	bhv_vop_readdir(vp,dirent,bufsize,offset,filldir)		\
-		VOP(vop_readdir, vp)(VNHEAD(vp),dirent,bufsize,offset,filldir)
-#define	bhv_vop_symlink(dvp,d,vap,tnm,vpp,cr)				\
-		VOP(vop_symlink, dvp)(VNHEAD(dvp),d,vap,tnm,vpp,cr)
-#define	bhv_vop_readlink(vp,link)					\
-		VOP(vop_readlink, vp)(VNHEAD(vp), link)
-#define	bhv_vop_fsync(vp,f,cr,b,e)	VOP(vop_fsync, vp)(VNHEAD(vp),f,cr,b,e)
-#define bhv_vop_inactive(vp,cr)		VOP(vop_inactive, vp)(VNHEAD(vp),cr)
-#define bhv_vop_release(vp)		VOP(vop_release, vp)(VNHEAD(vp))
-#define bhv_vop_fid2(vp,fidp)		VOP(vop_fid2, vp)(VNHEAD(vp),fidp)
-#define bhv_vop_rwlock(vp,i)		VOP(vop_rwlock, vp)(VNHEAD(vp),i)
-#define bhv_vop_rwlock_try(vp,i)	VOP(vop_rwlock, vp)(VNHEAD(vp),i)
-#define bhv_vop_rwunlock(vp,i)		VOP(vop_rwunlock, vp)(VNHEAD(vp),i)
-#define bhv_vop_frlock(vp,c,fl,flags,offset,fr)				\
-		VOP(vop_frlock, vp)(VNHEAD(vp),c,fl,flags,offset,fr)
-#define bhv_vop_reclaim(vp)		VOP(vop_reclaim, vp)(VNHEAD(vp))
-#define bhv_vop_attr_get(vp, name, val, vallenp, fl, cred)		\
-		VOP(vop_attr_get, vp)(VNHEAD(vp),name,val,vallenp,fl,cred)
-#define	bhv_vop_attr_set(vp, name, val, vallen, fl, cred)		\
-		VOP(vop_attr_set, vp)(VNHEAD(vp),name,val,vallen,fl,cred)
-#define	bhv_vop_attr_remove(vp, name, flags, cred)			\
-		VOP(vop_attr_remove, vp)(VNHEAD(vp),name,flags,cred)
-#define	bhv_vop_attr_list(vp, buf, buflen, fl, cursor, cred)		\
-		VOP(vop_attr_list, vp)(VNHEAD(vp),buf,buflen,fl,cursor,cred)
-#define bhv_vop_link_removed(vp, dvp, linkzero)				\
-		VOP(vop_link_removed, vp)(VNHEAD(vp), dvp, linkzero)
-#define bhv_vop_vnode_change(vp, cmd, val)				\
-		VOP(vop_vnode_change, vp)(VNHEAD(vp), cmd, val)
-#define bhv_vop_toss_pages(vp, first, last, fiopt)			\
-		VOP(vop_tosspages, vp)(VNHEAD(vp), first, last, fiopt)
-#define bhv_vop_flushinval_pages(vp, first, last, fiopt)		\
-		VOP(vop_flushinval_pages, vp)(VNHEAD(vp),first,last,fiopt)
-#define bhv_vop_flush_pages(vp, first, last, flags, fiopt)		\
-		VOP(vop_flush_pages, vp)(VNHEAD(vp),first,last,flags,fiopt)
-#define bhv_vop_ioctl(vp, inode, filp, fl, cmd, arg)			\
-		VOP(vop_ioctl, vp)(VNHEAD(vp),inode,filp,fl,cmd,arg)
-#define bhv_vop_iflush(vp, flags)	VOP(vop_iflush, vp)(VNHEAD(vp), flags)
-
-/*
  * Flags for read/write calls - same values as IRIX
  */
 #define IO_ISAIO	0x00001		/* don't wait for completion */
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops_bhv.c	2007-08-23 18:58:28.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,438 +0,0 @@
-
-#include "xfs_linux.h"
-#include "xfs_vnodeops.h"
-
-#include "xfs_bmap_btree.h"
-#include "xfs_inode.h"
-
-STATIC int
-xfs_bhv_open(
-	bhv_desc_t	*bdp,
-	cred_t		*credp)
-{
-	return xfs_open(XFS_BHVTOI(bdp));
-}
-
-STATIC int
-xfs_bhv_getattr(
-	bhv_desc_t	*bdp,
-	bhv_vattr_t	*vap,
-	int		flags,
-	cred_t		*credp)
-{
-	return xfs_getattr(XFS_BHVTOI(bdp), vap, flags);
-}
-
-int
-xfs_bhv_setattr(
-	bhv_desc_t		*bdp,
-	bhv_vattr_t		*vap,
-	int			flags,
-	cred_t			*credp)
-{
-	return xfs_setattr(XFS_BHVTOI(bdp), vap, flags, credp);
-}
-
-STATIC int
-xfs_bhv_access(
-	bhv_desc_t	*bdp,
-	int		mode,
-	cred_t		*credp)
-{
-	return xfs_access(XFS_BHVTOI(bdp), mode, credp);
-}
-
-STATIC int
-xfs_bhv_readlink(
-	bhv_desc_t	*bdp,
-	char		*link)
-{
-	return xfs_readlink(XFS_BHVTOI(bdp), link);
-}
-
-STATIC int
-xfs_bhv_fsync(
-	bhv_desc_t	*bdp,
-	int		flag,
-	cred_t		*credp,
-	xfs_off_t	start,
-	xfs_off_t	stop)
-{
-	return xfs_fsync(XFS_BHVTOI(bdp), flag, start, stop);
-}
-
-STATIC int
-xfs_bhv_release(
-	bhv_desc_t	*bdp)
-{
-	return xfs_release(XFS_BHVTOI(bdp));
-}
-
-STATIC int
-xfs_bhv_inactive(
-	bhv_desc_t	*bdp,
-	cred_t		*credp)
-{
-	return xfs_inactive(XFS_BHVTOI(bdp));
-}
-
-STATIC int
-xfs_bhv_lookup(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	bhv_vnode_t		**vpp,
-	int			flags,
-	bhv_vnode_t		*rdir,
-	cred_t			*credp)
-{
-	return xfs_lookup(XFS_BHVTOI(dir_bdp), dentry, vpp);
-}
-
-STATIC int
-xfs_bhv_create(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	bhv_vattr_t		*vap,
-	bhv_vnode_t		**vpp,
-	cred_t			*credp)
-{
-	return xfs_create(XFS_BHVTOI(dir_bdp), dentry, vap, vpp, credp);
-}
-
-STATIC int
-xfs_bhv_remove(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	cred_t			*credp)
-{
-	return xfs_remove(XFS_BHVTOI(dir_bdp), dentry);
-}
-
-STATIC int
-xfs_bhv_link(
-	bhv_desc_t		*target_dir_bdp,
-	bhv_vnode_t		*src_vp,
-	bhv_vname_t		*dentry,
-	cred_t			*credp)
-{
-	return xfs_link(XFS_BHVTOI(target_dir_bdp), src_vp, dentry);
-}
-
-STATIC int
-xfs_bhv_mkdir(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	bhv_vattr_t		*vap,
-	bhv_vnode_t		**vpp,
-	cred_t			*credp)
-{
-	return xfs_mkdir(XFS_BHVTOI(dir_bdp), dentry, vap, vpp, credp);
-}
-
-STATIC int
-xfs_bhv_rmdir(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	cred_t			*credp)
-{
-	return xfs_rmdir(XFS_BHVTOI(dir_bdp), dentry);
-}
-
-STATIC int
-xfs_bhv_readdir(
-	bhv_desc_t	*dir_bdp,
-	void		*dirent,
-	size_t		bufsize,
-	xfs_off_t	*offset,
-	filldir_t	filldir)
-{
-	return xfs_readdir(XFS_BHVTOI(dir_bdp), dirent, bufsize, offset, filldir);
-}
-
-STATIC int
-xfs_bhv_symlink(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	bhv_vattr_t		*vap,
-	char			*target_path,
-	bhv_vnode_t		**vpp,
-	cred_t			*credp)
-{
-	return xfs_symlink(XFS_BHVTOI(dir_bdp), dentry, vap, target_path, vpp, credp);
-}
-
-STATIC int
-xfs_bhv_fid2(
-	bhv_desc_t	*bdp,
-	fid_t		*fidp)
-{
-	return xfs_fid2(XFS_BHVTOI(bdp), fidp);
-}
-
-STATIC int
-xfs_bhv_rwlock(
-	bhv_desc_t	*bdp,
-	bhv_vrwlock_t	locktype)
-{
-	return xfs_rwlock(XFS_BHVTOI(bdp), locktype);
-}
-
-STATIC void
-xfs_bhv_rwunlock(
-	bhv_desc_t	*bdp,
-	bhv_vrwlock_t	locktype)
-{
-	xfs_rwunlock(XFS_BHVTOI(bdp), locktype);
-}
-
-STATIC int
-xfs_bhv_inode_flush(
-	bhv_desc_t	*bdp,
-	int		flags)
-{
-	return xfs_inode_flush(XFS_BHVTOI(bdp), flags);
-}
-
-STATIC int
-xfs_bhv_reclaim(
-	bhv_desc_t	*bdp)
-{
-	return xfs_reclaim(XFS_BHVTOI(bdp));
-}
-
-STATIC int
-xfs_bhv_rename(
-	bhv_desc_t	*src_dir_bdp,
-	bhv_vname_t	*src_vname,
-	bhv_vnode_t	*target_dir_vp,
-	bhv_vname_t	*target_vname,
-	cred_t		*credp)
-{
-	return xfs_rename(XFS_BHVTOI(src_dir_bdp), src_vname,
-			target_dir_vp, target_vname);
-}
-
-STATIC int
-xfs_bhv_attr_get(
-	bhv_desc_t	*bdp,
-	const char	*name,
-	char		*value,
-	int		*valuelenp,
-	int		flags,
-	cred_t		*cred)
-{
-	return xfs_attr_get(XFS_BHVTOI(bdp), name, value, valuelenp,
-			flags, cred);
-}
-
-STATIC int
-xfs_bhv_attr_set(
-	bhv_desc_t	*bdp,
-	const char	*name,
-	char		*value,
-	int		valuelen,
-	int		flags,
-	cred_t		*cred)
-{
-	return xfs_attr_set(XFS_BHVTOI(bdp), name, value, valuelen,
-			flags);
-}
-
-STATIC int
-xfs_bhv_attr_remove(
-	bhv_desc_t	*bdp,
-	const char	*name,
-	int		flags,
-	cred_t		*cred)
-{
-	return xfs_attr_remove(XFS_BHVTOI(bdp), name, flags);
-}
-
-STATIC int
-xfs_bhv_attr_list(
-	bhv_desc_t	*bdp,
-	char		*buffer,
-	int		bufsize,
-	int		flags,
-	struct attrlist_cursor_kern *cursor,
-	cred_t		*cred)
-{
-	return xfs_attr_list(XFS_BHVTOI(bdp), buffer, bufsize, flags,
-			cursor);
-}
-
-STATIC int
-xfs_bhv_ioctl(
-	bhv_desc_t		*bdp,
-	struct inode		*inode,
-	struct file		*filp,
-	int			ioflags,
-	unsigned int		cmd,
-	void			__user *arg)
-{
-	return xfs_ioctl(XFS_BHVTOI(bdp), filp, ioflags, cmd, arg);
-}
-
-STATIC ssize_t
-xfs_bhv_read(
-	bhv_desc_t		*bdp,
-	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned int		segs,
-	loff_t			*offset,
-	int			ioflags,
-	cred_t			*credp)
-{
-	return xfs_read(XFS_BHVTOI(bdp), iocb, iovp, segs,
-			offset, ioflags);
-}
-
-STATIC ssize_t
-xfs_bhv_sendfile(
-	bhv_desc_t		*bdp,
-	struct file		*filp,
-	loff_t			*offset,
-	int			ioflags,
-	size_t			count,
-	read_actor_t		actor,
-	void			*target,
-	cred_t			*credp)
-{
-	return xfs_sendfile(XFS_BHVTOI(bdp), filp, offset, ioflags,
-			count, actor, target);
-}
-
-STATIC ssize_t
-xfs_bhv_splice_read(
-	bhv_desc_t		*bdp,
-	struct file		*infilp,
-	loff_t			*ppos,
-	struct pipe_inode_info	*pipe,
-	size_t			count,
-	int			flags,
-	int			ioflags,
-	cred_t			*credp)
-{
-	return xfs_splice_read(XFS_BHVTOI(bdp), infilp, ppos, pipe,
-			count, flags, ioflags);
-}
-
-STATIC ssize_t
-xfs_bhv_splice_write(
-	bhv_desc_t		*bdp,
-	struct pipe_inode_info	*pipe,
-	struct file		*outfilp,
-	loff_t			*ppos,
-	size_t			count,
-	int			flags,
-	int			ioflags,
-	cred_t			*credp)
-{
-	return xfs_splice_write(XFS_BHVTOI(bdp), pipe, outfilp, ppos,
-			count, flags, ioflags);
-}
-
-STATIC ssize_t
-xfs_bhv_write(
-	bhv_desc_t		*bdp,
-	struct kiocb		*iocb,
-	const struct iovec	*iovp,
-	unsigned int		nsegs,
-	loff_t			*offset,
-	int			ioflags,
-	cred_t			*credp)
-{
-	return xfs_write(XFS_BHVTOI(bdp), iocb, iovp, nsegs, offset,
-			ioflags);
-}
-
-STATIC int
-xfs_bhv_bmap(bhv_desc_t	*bdp,
-	xfs_off_t	offset,
-	ssize_t		count,
-	int		flags,
-	struct xfs_iomap *iomapp,
-	int		*niomaps)
-{
-	return xfs_bmap(XFS_BHVTOI(bdp), offset, count, flags,
-			iomapp, niomaps);
-}
-
-STATIC void
-fs_tosspages(
-	bhv_desc_t	*bdp,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	xfs_tosspages(XFS_BHVTOI(bdp), first, last, fiopt);
-}
-
-STATIC int
-fs_flushinval_pages(
-	bhv_desc_t	*bdp,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	return xfs_flushinval_pages(XFS_BHVTOI(bdp), first, last,
-			fiopt);
-}
-
-STATIC int
-fs_flush_pages(
-	bhv_desc_t	*bdp,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	uint64_t	flags,
-	int		fiopt)
-{
-	return xfs_flush_pages(XFS_BHVTOI(bdp), first, last, flags,
-			fiopt);
-}
-
-bhv_vnodeops_t xfs_vnodeops = {
-	BHV_IDENTITY_INIT(VN_BHV_XFS,VNODE_POSITION_XFS),
-	.vop_open		= xfs_bhv_open,
-	.vop_read		= xfs_bhv_read,
-#ifdef HAVE_SENDFILE
-	.vop_sendfile		= xfs_bhv_sendfile,
-#endif
-#ifdef HAVE_SPLICE
-	.vop_splice_read	= xfs_bhv_splice_read,
-	.vop_splice_write	= xfs_bhv_splice_write,
-#endif
-	.vop_write		= xfs_bhv_write,
-	.vop_ioctl		= xfs_bhv_ioctl,
-	.vop_getattr		= xfs_bhv_getattr,
-	.vop_setattr		= xfs_bhv_setattr,
-	.vop_access		= xfs_bhv_access,
-	.vop_lookup		= xfs_bhv_lookup,
-	.vop_create		= xfs_bhv_create,
-	.vop_remove		= xfs_bhv_remove,
-	.vop_link		= xfs_bhv_link,
-	.vop_rename		= xfs_bhv_rename,
-	.vop_mkdir		= xfs_bhv_mkdir,
-	.vop_rmdir		= xfs_bhv_rmdir,
-	.vop_readdir		= xfs_bhv_readdir,
-	.vop_symlink		= xfs_bhv_symlink,
-	.vop_readlink		= xfs_bhv_readlink,
-	.vop_fsync		= xfs_bhv_fsync,
-	.vop_inactive		= xfs_bhv_inactive,
-	.vop_fid2		= xfs_bhv_fid2,
-	.vop_rwlock		= xfs_bhv_rwlock,
-	.vop_rwunlock		= xfs_bhv_rwunlock,
-	.vop_bmap		= xfs_bhv_bmap,
-	.vop_reclaim		= xfs_bhv_reclaim,
-	.vop_attr_get		= xfs_bhv_attr_get,
-	.vop_attr_set		= xfs_bhv_attr_set,
-	.vop_attr_remove	= xfs_bhv_attr_remove,
-	.vop_attr_list		= xfs_bhv_attr_list,
-	.vop_link_removed	= (vop_link_removed_t)fs_noval,
-	.vop_vnode_change	= (vop_vnode_change_t)fs_noval,
-	.vop_tosspages		= fs_tosspages,
-	.vop_flushinval_pages	= fs_flushinval_pages,
-	.vop_flush_pages	= fs_flush_pages,
-	.vop_release		= xfs_bhv_release,
-	.vop_iflush		= xfs_bhv_inode_flush,
-};
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-08-23 18:58:43.000000000 +0200
@@ -257,7 +257,7 @@ typedef struct xfs_inode {
 	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct list_head	i_reclaim;	/* reclaim list */
-	struct bhv_desc		i_bhv_desc;	/* inode behavior descriptor*/
+	struct bhv_vnode	*i_vnode;	/* vnode backpointer */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 
@@ -465,12 +465,8 @@ xfs_iflags_test(xfs_inode_t *ip, unsigne
 #define	XFS_ITRUNC_DEFINITE	0x1
 #define	XFS_ITRUNC_MAYBE	0x2
 
-#define	XFS_ITOV(ip)		BHV_TO_VNODE(XFS_ITOBHV(ip))
-#define	XFS_ITOV_NULL(ip)	BHV_TO_VNODE_NULL(XFS_ITOBHV(ip))
-#define	XFS_ITOBHV(ip)		((struct bhv_desc *)(&((ip)->i_bhv_desc)))
-#define	XFS_BHVTOI(bhvp)	((xfs_inode_t *)((char *)(bhvp) - \
-				(char *)&(((xfs_inode_t *)0)->i_bhv_desc)))
-#define BHV_IS_XFS(bdp)		(BHV_OPS(bdp) == &xfs_vnodeops)
+#define	XFS_ITOV(ip)		((ip)->i_vnode)
+#define	XFS_ITOV_NULL(ip)	((ip)->i_vnode)
 
 /*
  * For multiple groups support: if S_ISGID bit is set in the parent
@@ -557,8 +553,6 @@ void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
 void		xfs_lock_inodes(xfs_inode_t **, int, int, uint);
 
-xfs_inode_t	*xfs_vtoi(struct bhv_vnode *vp);
-
 void		xfs_synchronize_atime(xfs_inode_t *);
 
 xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
Index: linux-2.6-xfs/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile-linux-2.6	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile-linux-2.6	2007-08-23 18:58:43.000000000 +0200
@@ -79,7 +79,6 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_utils.o \
 				   xfs_vfsops.o \
 				   xfs_vnodeops.o \
-				   xfs_vnodeops_bhv.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \
 				   xfs_qmops.o
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 18:58:43.000000000 +0200
@@ -28,6 +28,7 @@ struct fid;
 struct cred;
 struct seq_file;
 struct super_block;
+struct xfs_inode;
 struct xfs_mount_args;
 
 typedef struct kstatfs	bhv_statvfs_t;
@@ -131,7 +132,7 @@ typedef int	(*vfs_vget_t)(bhv_desc_t *, 
 typedef int	(*vfs_dmapiops_t)(bhv_desc_t *, caddr_t);
 typedef int	(*vfs_quotactl_t)(bhv_desc_t *, int, int, caddr_t);
 typedef void	(*vfs_init_vnode_t)(bhv_desc_t *,
-				struct bhv_vnode *, bhv_desc_t *, int);
+				struct bhv_vnode *, struct xfs_inode *, int);
 typedef void	(*vfs_force_shutdown_t)(bhv_desc_t *, int, char *, int);
 typedef void	(*vfs_freeze_t)(bhv_desc_t *);
 typedef	struct inode * (*vfs_get_inode_t)(bhv_desc_t *, xfs_ino_t, int);
@@ -206,7 +207,7 @@ extern int vfs_vget(bhv_desc_t *, struct
 extern int vfs_dmapiops(bhv_desc_t *, caddr_t);
 extern int vfs_quotactl(bhv_desc_t *, int, int, caddr_t);
 extern struct inode *vfs_get_inode(bhv_desc_t *, xfs_ino_t, int);
-extern void vfs_init_vnode(bhv_desc_t *, struct bhv_vnode *, bhv_desc_t *, int);
+extern void vfs_init_vnode(bhv_desc_t *, struct bhv_vnode *, struct xfs_inode *, int);
 extern void vfs_force_shutdown(bhv_desc_t *, int, char *, int);
 extern void vfs_freeze(bhv_desc_t *);
 
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-08-23 18:58:43.000000000 +0200
@@ -342,7 +342,7 @@ finish_inode:
 	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
 	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
 	 */
-	bhv_vfs_init_vnode(XFS_MTOVFS(mp), vp, XFS_ITOBHV(ip), 1);
+	bhv_vfs_init_vnode(XFS_MTOVFS(mp), vp, ip, 1);
 
 	return 0;
 }
@@ -536,7 +536,8 @@ xfs_ireclaim(xfs_inode_t *ip)
 	 */
 	vp = XFS_ITOV_NULL(ip);
 	if (vp) {
-		vn_bhv_remove(VN_BHV_HEAD(vp), XFS_ITOBHV(ip));
+		vn_to_inode(vp)->i_private = NULL;
+		ip->i_vnode = NULL;
 	}
 
 	/*
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2007-08-23 18:58:43.000000000 +0200
@@ -77,7 +77,7 @@ struct block_device;
 extern __uint64_t xfs_max_file_offset(unsigned int);
 
 extern struct inode *xfs_get_inode(bhv_desc_t *, xfs_ino_t, int);
-extern void xfs_initialize_vnode(bhv_desc_t *, bhv_vnode_t *, bhv_desc_t *, int);
+extern void xfs_initialize_vnode(bhv_desc_t *, bhv_vnode_t *, struct xfs_inode *, int);
 
 extern void xfs_flush_inode(struct xfs_inode *);
 extern void xfs_flush_device(struct xfs_inode *);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 18:58:43.000000000 +0200
@@ -200,7 +200,7 @@ void
 vfs_init_vnode(
 	struct bhv_desc		*bdp,
 	struct bhv_vnode	*vp,
-	struct bhv_desc		*bp,
+	struct xfs_inode	*ip,
 	int			unlock)
 {
 	struct bhv_desc		*next = bdp;
@@ -208,7 +208,7 @@ vfs_init_vnode(
 	ASSERT(next);
 	while (! (bhvtovfsops(next))->vfs_init_vnode)
 		next = BHV_NEXT(next);
-	((*bhvtovfsops(next)->vfs_init_vnode)(next, vp, bp, unlock));
+	((*bhvtovfsops(next)->vfs_init_vnode)(next, vp, ip, unlock));
 }
 
 void
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-23 18:58:43.000000000 +0200
@@ -575,11 +575,11 @@ xfs_dm_bulkall_iget_one(
 	dm_ip_to_handle(vn_to_inode(vp), &handle);
 	xfs_dm_handle_to_xstat(xbuf, xstat_sz, &handle, sizeof(handle));
 
-	/* Drop ILOCK_SHARED for call to bhv_vop_attr_get */
+	/* Drop ILOCK_SHARED for call to xfs_attr_get */
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	memset(&xbuf->dx_attrdata, 0, sizeof(dm_vardata_t));
-	error = bhv_vop_attr_get(vp, attr_name, attr_buf,
+	error = xfs_attr_get(ip, attr_name, attr_buf,
 				 &value_len, ATTR_ROOT, sys_cred);
 	VN_RELE(vp);
 
@@ -1736,7 +1736,6 @@ xfs_dm_get_destroy_dmattr(
 	int		value_len;
 	char		*value;
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -1752,7 +1751,7 @@ xfs_dm_get_destroy_dmattr(
 		(char *)attrnamep->an_chars, DM_ATTR_NAME_SIZE + 1);
 	dkattrname.dan_chars[sizeof(dkattrname.dan_chars) - 1] = '\0';
 
-	/* bhv_vop_attr_get will not return anything if the buffer is too small,
+	/* xfs_attr_get will not return anything if the buffer is too small,
 	   and we don't know how big to make the buffer, so this may take
 	   two tries to get it right.  The initial try must use a buffer of
 	   at least XFS_BUG_KLUDGE bytes to prevent buffer overflow because
@@ -1764,7 +1763,7 @@ xfs_dm_get_destroy_dmattr(
 	if (value == NULL)
 		return(-ENOMEM);
 
-	error = bhv_vop_attr_get(vp, dkattrname.dan_chars, value, &value_len,
+	error = xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value, &value_len,
 					ATTR_ROOT, sys_cred);
 	if (error == ERANGE) {
 		kfree(value);
@@ -1773,7 +1772,7 @@ xfs_dm_get_destroy_dmattr(
 		if (value == NULL)
 			return(-ENOMEM);
 
-		error = bhv_vop_attr_get(vp, dkattrname.dan_chars, value,
+		error = xfs_attr_get(XFS_I(inode), dkattrname.dan_chars, value,
 					&value_len, ATTR_ROOT, sys_cred);
 	}
 	if (error) {
@@ -1970,7 +1969,7 @@ xfs_dm_get_dirattrs_rvp(
 	mutex_lock(&inode->i_mutex);
 	error = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		error = -bhv_vop_readdir(vp, cb, dp->i_size,
+		error = -xfs_readdir(dp, cb, dp->i_size,
 					 (xfs_off_t *)&loc, dm_filldir);
 	}
 	mutex_unlock(&inode->i_mutex);
@@ -2017,7 +2016,6 @@ xfs_dm_get_dmattr(
 	int		value_len;
 	int		alloc_size;
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2050,7 +2048,7 @@ xfs_dm_get_dmattr(
 
 	value_len = alloc_size;		/* in/out parameter */
 
-	error = bhv_vop_attr_get(vp, name.dan_chars, value, &value_len,
+	error = xfs_attr_get(XFS_I(inode), name.dan_chars, value, &value_len,
 					ATTR_ROOT, NULL);
 	DM_EA_XLATE_ERR(error);
 
@@ -2202,7 +2200,6 @@ xfs_dm_getall_dmattr(
 	int		total_size;
 	int		list_size = 8192;	/* should be big enough */
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2243,8 +2240,8 @@ xfs_dm_getall_dmattr(
 		   more or if we encounter an error, then finish up.
 		*/
 
-		error = bhv_vop_attr_list(vp, (char *)attrlist, list_size,
-						ATTR_ROOT, &cursor, NULL);
+		error = xfs_attr_list(XFS_I(inode), (char *)attrlist, list_size,
+						ATTR_ROOT, &cursor);
 		DM_EA_XLATE_ERR(error);
 
 		if (error || attrlist->al_count == 0)
@@ -2302,7 +2299,7 @@ xfs_dm_getall_dmattr(
 
 			value_len = entry->a_valuelen;
 
-			error = bhv_vop_attr_get(vp, entry->a_name,
+			error = xfs_attr_get(XFS_I(inode), entry->a_name,
 						(void *)(ulist + 1), &value_len,
 						ATTR_ROOT, NULL);
 			DM_EA_XLATE_ERR(error);
@@ -2665,7 +2662,6 @@ xfs_dm_remove_dmattr(
 {
 	dm_dkattrname_t name;
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2677,8 +2673,8 @@ xfs_dm_remove_dmattr(
 
 	/* Remove the attribute from the object. */
 
-	error = bhv_vop_attr_remove(vp, name.dan_chars, setdtime ?
-				ATTR_ROOT : (ATTR_ROOT|ATTR_KERNOTIME), NULL);
+	error = xfs_attr_remove(XFS_I(inode), name.dan_chars, setdtime ?
+				ATTR_ROOT : (ATTR_ROOT|ATTR_KERNOTIME));
 	DM_EA_XLATE_ERR(error);
 
 	if (error == ENOATTR)
@@ -2725,7 +2721,6 @@ xfs_dm_set_dmattr(
 	char		*value;
 	int		alloc_size;
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2748,9 +2743,9 @@ xfs_dm_set_dmattr(
 	if (copy_from_user( value, bufp, buflen)) {
 		error = EFAULT;
 	} else {
-		error = bhv_vop_attr_set(vp, name.dan_chars, value, buflen,
+		error = xfs_attr_set(XFS_I(inode), name.dan_chars, value, buflen,
 					setdtime ? ATTR_ROOT :
-					(ATTR_ROOT|ATTR_KERNOTIME), NULL);
+					(ATTR_ROOT|ATTR_KERNOTIME));
 		DM_EA_XLATE_ERR(error);
 	}
 	kmem_free(value, alloc_size);
@@ -2849,7 +2844,7 @@ xfs_dm_set_fileattr(
 		vat.va_size = stat.fa_size;
 	}
 
-	error = bhv_vop_setattr(vp, &vat, ATTR_DMI, NULL);
+	error = xfs_setattr(XFS_I(inode), &vat, ATTR_DMI, NULL);
 	if (!error)
 		vn_revalidate(vp);	/* update Linux inode flags */
 	return(-error); /* Return negative error to DMAPI */
@@ -3003,7 +2998,7 @@ xfs_dm_sync_by_handle(
 	/* We need to protect against concurrent writers.. */
 	ret = filemap_fdatawrite(inode->i_mapping);
 	down_rw_sems(inode, DM_FLAGS_IMUX);
-	err = bhv_vop_fsync(vp, FSYNC_WAIT, NULL, (xfs_off_t)0,(xfs_off_t)-1);
+	err = xfs_fsync(XFS_I(inode), FSYNC_WAIT, 0, -1);
 	if (!ret)
 		ret = err;
 	up_rw_sems(inode, DM_FLAGS_IMUX);
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_bhv.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_bhv.c	2007-08-23 18:58:43.000000000 +0200
@@ -72,14 +72,14 @@ xfs_dm_mount(
 	error = bhv_vfs_root(vfsp, &rootvp);
 	if (error)
 		return error;
-	if (bhv_lookup_range(VN_BHV_HEAD(rootvp),
-			     VNODE_POSITION_XFS, VNODE_POSITION_XFS)) {
-		vfsp->vfs_flag |= VFS_DMI;
-		error = dm_send_mount_event(vfsp->vfs_super,
-				DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-				vn_to_inode(rootvp),
-				DM_RIGHT_NULL, args->mtpt, args->fsname);
-	}
+
+
+	vfsp->vfs_flag |= VFS_DMI;
+	error = dm_send_mount_event(vfsp->vfs_super,
+			DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
+			vn_to_inode(rootvp),
+			DM_RIGHT_NULL, args->mtpt, args->fsname);
+
 	VN_RELE(rootvp);
 	if (error)
 		error = -error; /* DMAPI returns negative errs */
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-23 16:57:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-23 18:58:43.000000000 +0200
@@ -44,6 +44,7 @@
 #include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_inode_item.h"
+#include "xfs_vnodeops.h"
 #include <dmapi.h>
 #include <dmapi_kern.h>
 #include "xfs_dm.h"
@@ -84,11 +85,11 @@ xfs_dm_fh_to_inode(
 
 STATIC int
 xfs_dm_inode_to_fh(
-	struct inode		*ip,
+	struct inode		*inode,
 	dm_fid_t		*dmfid,
 	dm_fsid_t		*dmfsid)
 {
-	bhv_vnode_t	*vp = vn_from_inode(ip);
+	bhv_vnode_t	*vp = vn_from_inode(inode);
 	int		error;
 	fid_t		fid;
 
@@ -96,7 +97,7 @@ xfs_dm_inode_to_fh(
 
 	if (vp->v_vfsp->vfs_altfsid == NULL)
 		return -EINVAL;
-	error = bhv_vop_fid2(vp, &fid);
+	error = xfs_fid2(XFS_I(inode), &fid);
 	if (error)
 		return -error; /* Return negative error to DMAPI */
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 18:58:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 18:58:43.000000000 +0200
@@ -298,6 +298,13 @@ EXPORT_SYMBOL(xfs_read_buf);
 EXPORT_SYMBOL(xfs_rwlock);
 EXPORT_SYMBOL(xfs_rwunlock);
 EXPORT_SYMBOL(xfs_setattr);
+EXPORT_SYMBOL(xfs_fid2);
+EXPORT_SYMBOL(xfs_attr_get);
+EXPORT_SYMBOL(xfs_attr_set);
+EXPORT_SYMBOL(xfs_fsync);
+EXPORT_SYMBOL(xfs_attr_remove);
+EXPORT_SYMBOL(xfs_attr_list);
+EXPORT_SYMBOL(xfs_readdir);
 EXPORT_SYMBOL(xfs_setsize_buftarg);
 EXPORT_SYMBOL(xfs_syncsub);
 EXPORT_SYMBOL(xfs_sync_inodes);
@@ -326,8 +333,6 @@ EXPORT_SYMBOL(xfs_truncate_file);
 EXPORT_SYMBOL(xfs_unmount_flush);
 EXPORT_SYMBOL(xfs_unmountfs_writesb);
 EXPORT_SYMBOL(xfs_vfsops);
-EXPORT_SYMBOL(xfs_vnodeops);
-EXPORT_SYMBOL(xfs_vtoi);
 EXPORT_SYMBOL(xfs_write_clear_setuid);
 EXPORT_SYMBOL(xfs_dinode_from_disk);
 EXPORT_SYMBOL(xfs_sb_from_disk);
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-23 18:58:43.000000000 +0200
@@ -1796,9 +1796,6 @@ static void printbhv(bhv_desc_t *bdp)
 static void	printvnode(bhv_vnode_t *vp, unsigned long addr)
 {
 	kdb_printf("vnode: 0x%lx\n", addr);
-	kdb_printf(" v_bh 0x%p\n", &vp->v_bh);
-
-	printbhv(VNHEAD(vp));
 
 	printflags((__psunsigned_t)vp->v_flag, tab_vflags, "flag =");
 	kdb_printf("\n");
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-23 18:52:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-23 18:58:43.000000000 +0200
@@ -66,7 +66,6 @@ struct xfs_swapext;
 struct xfs_mru_cache;
 
 extern struct bhv_vfsops xfs_vfsops;
-extern struct bhv_vnodeops xfs_vnodeops;
 
 #define	AIL_LOCK_T		lock_t
 #define	AIL_LOCKINIT(x,y)	spinlock_init(x,y)
