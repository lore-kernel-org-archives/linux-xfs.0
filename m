Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09MD0A4027469 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 16:13:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF29217C957B
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 14:12:59 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vh5iNVM9rYLCOD8F for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2009 14:12:59 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LLPb9-0003tk-Fr
	for xfs@oss.sgi.com; Fri, 09 Jan 2009 22:12:59 +0000
Message-Id: <20090109221259.292773000@bombadil.infradead.org>
References: <20090109221104.237540000@bombadil.infradead.org>
Date: Fri, 09 Jan 2009 17:11:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: fix dentry aliasing issues in open_by_handle
Content-Disposition: inline; filename=xfs-fix-open-by-handle
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Open by handle just grabs an inode by handle and then creates itself
a dentry for it.  While this works for regular files it is horribly
broken for directories, where the VFS locking relies on the fact that
there is only just one single dentry for a given inode, and that
these are always connected to the root of the filesystem so that
it's locking algorithms work (see Documentations/filesystems/Locking)

Remove all the existing open by handle code and replace it with a small
wrapper around the exportfs code which deals with all these issues.
At the same time we also make the checks for a valid handle strict
enough to reject all not perfectly well formed handles - given that
we never hand out others that's okay and simplifies the code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-12-30 09:29:46.787493310 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-12-30 09:37:24.840514983 +0100
@@ -50,12 +50,14 @@
 #include "xfs_vnodeops.h"
 #include "xfs_quota.h"
 #include "xfs_inode_item.h"
+#include "xfs_export.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/pagemap.h>
+#include <linux/exportfs.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -164,97 +166,69 @@ xfs_find_handle(
 	return 0;
 }
 
-
 /*
- * Convert userspace handle data into inode.
- *
- * We use the fact that all the fsop_handlereq ioctl calls have a data
- * structure argument whose first component is always a xfs_fsop_handlereq_t,
- * so we can pass that sub structure into this handy, shared routine.
- *
- * If no error, caller must always iput the returned inode.
+ * No need to do permission checks on the various pathname components
+ * as the handle operations are privileged.
  */
 STATIC int
-xfs_vget_fsop_handlereq(
-	xfs_mount_t		*mp,
-	struct inode		*parinode,	/* parent inode pointer    */
-	xfs_fsop_handlereq_t	*hreq,
-	struct inode		**inode)
-{
-	void			__user *hanp;
-	size_t			hlen;
-	xfs_fid_t		*xfid;
-	xfs_handle_t		*handlep;
+handle_acceptable(
+	void			*context,
+	struct dentry		*dentry)
+{
+	return 1;
+}
+
+/*
+ * Convert userspace handle data into a dentry.
+ */
+struct dentry *
+xfs_handle_to_dentry(
+	struct file		*parfilp,
+	void __user		*uhandle,
+	u32			hlen)
+{
 	xfs_handle_t		handle;
-	xfs_inode_t		*ip;
-	xfs_ino_t		ino;
-	__u32			igen;
-	int			error;
+	struct xfs_fid64	fid;
 
 	/*
 	 * Only allow handle opens under a directory.
 	 */
-	if (!S_ISDIR(parinode->i_mode))
-		return XFS_ERROR(ENOTDIR);
+	if (!S_ISDIR(parfilp->f_path.dentry->d_inode->i_mode))
+		return ERR_PTR(-ENOTDIR);
 
-	hanp = hreq->ihandle;
-	hlen = hreq->ihandlen;
-	handlep = &handle;
-
-	if (hlen < sizeof(handlep->ha_fsid) || hlen > sizeof(*handlep))
-		return XFS_ERROR(EINVAL);
-	if (copy_from_user(handlep, hanp, hlen))
-		return XFS_ERROR(EFAULT);
-	if (hlen < sizeof(*handlep))
-		memset(((char *)handlep) + hlen, 0, sizeof(*handlep) - hlen);
-	if (hlen > sizeof(handlep->ha_fsid)) {
-		if (handlep->ha_fid.fid_len !=
-		    (hlen - sizeof(handlep->ha_fsid) -
-		            sizeof(handlep->ha_fid.fid_len)) ||
-		    handlep->ha_fid.fid_pad)
-			return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * Crack the handle, obtain the inode # & generation #
-	 */
-	xfid = (struct xfs_fid *)&handlep->ha_fid;
-	if (xfid->fid_len == sizeof(*xfid) - sizeof(xfid->fid_len)) {
-		ino  = xfid->fid_ino;
-		igen = xfid->fid_gen;
-	} else {
-		return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * Get the XFS inode, building a Linux inode to go with it.
-	 */
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
-	if (error)
-		return error;
-	if (ip == NULL)
-		return XFS_ERROR(EIO);
-	if (ip->i_d.di_gen != igen) {
-		xfs_iput_new(ip, XFS_ILOCK_SHARED);
-		return XFS_ERROR(ENOENT);
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (hlen != sizeof(xfs_handle_t))
+		return ERR_PTR(-EINVAL);
+	if (copy_from_user(&handle, uhandle, hlen))
+		return ERR_PTR(-EFAULT);
+	if (handle.ha_fid.fid_len !=
+	    sizeof(handle.ha_fid) - sizeof(handle.ha_fid.fid_len))
+		return ERR_PTR(-EINVAL);
+
+	memset(&fid, 0, sizeof(struct fid));
+	fid.ino = handle.ha_fid.fid_ino;
+	fid.gen = handle.ha_fid.fid_gen;
+
+	return exportfs_decode_fh(parfilp->f_path.mnt, (struct fid *)&fid, 3,
+			FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
+			handle_acceptable, NULL);
+}
 
-	*inode = VFS_I(ip);
-	return 0;
+STATIC struct dentry *
+xfs_handlereq_to_dentry(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	return xfs_handle_to_dentry(parfilp, hreq->ihandle, hreq->ihandlen);
 }
 
 int
 xfs_open_by_handle(
-	xfs_mount_t		*mp,
-	xfs_fsop_handlereq_t	*hreq,
 	struct file		*parfilp,
-	struct inode		*parinode)
+	xfs_fsop_handlereq_t	*hreq)
 {
 	const struct cred	*cred = current_cred();
 	int			error;
-	int			new_fd;
+	int			fd;
 	int			permflag;
 	struct file		*filp;
 	struct inode		*inode;
@@ -263,19 +237,21 @@ xfs_open_by_handle(
 	if (!capable(CAP_SYS_ADMIN))
 		return -XFS_ERROR(EPERM);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, hreq, &inode);
-	if (error)
-		return -error;
+	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	inode = dentry->d_inode;
 
 	/* Restrict xfs_open_by_handle to directories & regular files. */
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
-		iput(inode);
-		return -XFS_ERROR(EINVAL);
+		error = -XFS_ERROR(EPERM);
+		goto out_dput;
 	}
 
 #if BITS_PER_LONG != 32
 	hreq->oflags |= O_LARGEFILE;
 #endif
+
 	/* Put open permission in namei format. */
 	permflag = hreq->oflags;
 	if ((permflag+1) & O_ACCMODE)
@@ -285,50 +261,45 @@ xfs_open_by_handle(
 
 	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
 	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
-		iput(inode);
-		return -XFS_ERROR(EPERM);
+		error = -XFS_ERROR(EPERM);
+		goto out_dput;
 	}
 
 	if ((permflag & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
-		iput(inode);
-		return -XFS_ERROR(EACCES);
+		error = -XFS_ERROR(EACCES);
+		goto out_dput;
 	}
 
 	/* Can't write directories. */
-	if ( S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
-		iput(inode);
-		return -XFS_ERROR(EISDIR);
-	}
-
-	if ((new_fd = get_unused_fd()) < 0) {
-		iput(inode);
-		return new_fd;
+	if (S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
+		error = -XFS_ERROR(EISDIR);
+		goto out_dput;
 	}
 
-	dentry = d_obtain_alias(inode);
-	if (IS_ERR(dentry)) {
-		put_unused_fd(new_fd);
-		return PTR_ERR(dentry);
+	fd = get_unused_fd();
+	if (fd < 0) {
+		error = fd;
+		goto out_dput;
 	}
 
-	/* Ensure umount returns EBUSY on umounts while this file is open. */
-	mntget(parfilp->f_path.mnt);
-
-	/* Create file pointer. */
-	filp = dentry_open(dentry, parfilp->f_path.mnt, hreq->oflags, cred);
+	filp = dentry_open(dentry, mntget(parfilp->f_path.mnt),
+			   hreq->oflags, cred);
 	if (IS_ERR(filp)) {
-		put_unused_fd(new_fd);
-		return -XFS_ERROR(-PTR_ERR(filp));
+		put_unused_fd(fd);
+		return PTR_ERR(filp);
 	}
 
 	if (inode->i_mode & S_IFREG) {
-		/* invisible operation should not change atime */
 		filp->f_flags |= O_NOATIME;
 		filp->f_mode |= FMODE_NOCMTIME;
 	}
 
-	fd_install(new_fd, filp);
-	return new_fd;
+	fd_install(fd, filp);
+	return fd;
+
+ out_dput:
+	dput(dentry);
+	return error;
 }
 
 /*
@@ -359,11 +330,10 @@ do_readlink(
 
 int
 xfs_readlink_by_handle(
-	xfs_mount_t		*mp,
-	xfs_fsop_handlereq_t	*hreq,
-	struct inode		*parinode)
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
 {
-	struct inode		*inode;
+	struct dentry		*dentry;
 	__u32			olen;
 	void			*link;
 	int			error;
@@ -371,26 +341,28 @@ xfs_readlink_by_handle(
 	if (!capable(CAP_SYS_ADMIN))
 		return -XFS_ERROR(EPERM);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, hreq, &inode);
-	if (error)
-		return -error;
+	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 
 	/* Restrict this handle operation to symlinks only. */
-	if (!S_ISLNK(inode->i_mode)) {
+	if (!S_ISLNK(dentry->d_inode->i_mode)) {
 		error = -XFS_ERROR(EINVAL);
-		goto out_iput;
+		goto out_dput;
 	}
 
 	if (copy_from_user(&olen, hreq->ohandlen, sizeof(__u32))) {
 		error = -XFS_ERROR(EFAULT);
-		goto out_iput;
+		goto out_dput;
 	}
 
 	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
-	if (!link)
-		goto out_iput;
+	if (!link) {
+		error = -XFS_ERROR(ENOMEM);
+		goto out_dput;
+	}
 
-	error = -xfs_readlink(XFS_I(inode), link);
+	error = -xfs_readlink(XFS_I(dentry->d_inode), link);
 	if (error)
 		goto out_kfree;
 	error = do_readlink(hreq->ohandle, olen, link);
@@ -399,32 +371,31 @@ xfs_readlink_by_handle(
 
  out_kfree:
 	kfree(link);
- out_iput:
-	iput(inode);
+ out_dput:
+	dput(dentry);
 	return error;
 }
 
 STATIC int
 xfs_fssetdm_by_handle(
-	xfs_mount_t		*mp,
-	void			__user *arg,
-	struct inode		*parinode)
+	struct file		*parfilp,
+	void			__user *arg)
 {
 	int			error;
 	struct fsdmidata	fsd;
 	xfs_fsop_setdm_handlereq_t dmhreq;
-	struct inode		*inode;
+	struct dentry		*dentry;
 
 	if (!capable(CAP_MKNOD))
 		return -XFS_ERROR(EPERM);
 	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &dmhreq.hreq, &inode);
-	if (error)
-		return -error;
+	dentry = xfs_handlereq_to_dentry(parfilp, &dmhreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
+	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
 		error = -XFS_ERROR(EPERM);
 		goto out;
 	}
@@ -434,24 +405,23 @@ xfs_fssetdm_by_handle(
 		goto out;
 	}
 
-	error = -xfs_set_dmattrs(XFS_I(inode), fsd.fsd_dmevmask,
+	error = -xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
 				 fsd.fsd_dmstate);
 
  out:
-	iput(inode);
+	dput(dentry);
 	return error;
 }
 
 STATIC int
 xfs_attrlist_by_handle(
-	xfs_mount_t		*mp,
 	void			__user *arg,
-	struct inode		*parinode)
+	struct file		*parfilp)
 {
-	int			error;
+	int			error = -ENOMEM;
 	attrlist_cursor_kern_t	*cursor;
 	xfs_fsop_attrlist_handlereq_t al_hreq;
-	struct inode		*inode;
+	struct dentry		*dentry;
 	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -467,16 +437,16 @@ xfs_attrlist_by_handle(
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -XFS_ERROR(EINVAL);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &al_hreq.hreq, &inode);
-	if (error)
-		goto out;
+	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 
 	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
 	if (!kbuf)
-		goto out_vn_rele;
+		goto out_dput;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_attr_list(XFS_I(inode), kbuf, al_hreq.buflen,
+	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
 					al_hreq.flags, cursor);
 	if (error)
 		goto out_kfree;
@@ -486,10 +456,9 @@ xfs_attrlist_by_handle(
 
  out_kfree:
 	kfree(kbuf);
- out_vn_rele:
-	iput(inode);
- out:
-	return -error;
+ out_dput:
+	dput(dentry);
+	return error;
 }
 
 int
@@ -564,15 +533,13 @@ xfs_attrmulti_attr_remove(
 
 STATIC int
 xfs_attrmulti_by_handle(
-	xfs_mount_t		*mp,
-	void			__user *arg,
 	struct file		*parfilp,
-	struct inode		*parinode)
+	void			__user *arg)
 {
 	int			error;
 	xfs_attr_multiop_t	*ops;
 	xfs_fsop_attrmulti_handlereq_t am_hreq;
-	struct inode		*inode;
+	struct dentry		*dentry;
 	unsigned int		i, size;
 	char			*attr_name;
 
@@ -581,19 +548,19 @@ xfs_attrmulti_by_handle(
 	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq(mp, parinode, &am_hreq.hreq, &inode);
-	if (error)
-		goto out;
+	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 
 	error = E2BIG;
 	size = am_hreq.opcount * sizeof(xfs_attr_multiop_t);
 	if (!size || size > 16 * PAGE_SIZE)
-		goto out_vn_rele;
+		goto out_dput;
 
 	error = ENOMEM;
 	ops = kmalloc(size, GFP_KERNEL);
 	if (!ops)
-		goto out_vn_rele;
+		goto out_dput;
 
 	error = EFAULT;
 	if (copy_from_user(ops, am_hreq.ops, size))
@@ -615,25 +582,28 @@ xfs_attrmulti_by_handle(
 
 		switch (ops[i].am_opcode) {
 		case ATTR_OP_GET:
-			ops[i].am_error = xfs_attrmulti_attr_get(inode,
-					attr_name, ops[i].am_attrvalue,
-					&ops[i].am_length, ops[i].am_flags);
+			ops[i].am_error = xfs_attrmulti_attr_get(
+					dentry->d_inode, attr_name,
+					ops[i].am_attrvalue, &ops[i].am_length,
+					ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
 			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_set(inode,
-					attr_name, ops[i].am_attrvalue,
-					ops[i].am_length, ops[i].am_flags);
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					dentry->d_inode, attr_name,
+					ops[i].am_attrvalue, ops[i].am_length,
+					ops[i].am_flags);
 			mnt_drop_write(parfilp->f_path.mnt);
 			break;
 		case ATTR_OP_REMOVE:
 			ops[i].am_error = mnt_want_write(parfilp->f_path.mnt);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
-					attr_name, ops[i].am_flags);
+			ops[i].am_error = xfs_attrmulti_attr_remove(
+					dentry->d_inode, attr_name,
+					ops[i].am_flags);
 			mnt_drop_write(parfilp->f_path.mnt);
 			break;
 		default:
@@ -647,9 +617,8 @@ xfs_attrmulti_by_handle(
 	kfree(attr_name);
  out_kfree_ops:
 	kfree(ops);
- out_vn_rele:
-	iput(inode);
- out:
+ out_dput:
+	dput(dentry);
 	return -error;
 }
 
@@ -1440,23 +1409,23 @@ xfs_file_ioctl(
 
 		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
 			return -XFS_ERROR(EFAULT);
-		return xfs_open_by_handle(mp, &hreq, filp, inode);
+		return xfs_open_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_FSSETDM_BY_HANDLE:
-		return xfs_fssetdm_by_handle(mp, arg, inode);
+		return xfs_fssetdm_by_handle(filp, arg);
 
 	case XFS_IOC_READLINK_BY_HANDLE: {
 		xfs_fsop_handlereq_t	hreq;
 
 		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
 			return -XFS_ERROR(EFAULT);
-		return xfs_readlink_by_handle(mp, &hreq, inode);
+		return xfs_readlink_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
-		return xfs_attrlist_by_handle(mp, arg, inode);
+		return xfs_attrlist_by_handle(arg, filp);
 
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
+		return xfs_attrmulti_by_handle(filp, arg);
 
 	case XFS_IOC_SWAPEXT: {
 		struct xfs_swapext	sxp;
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-30 09:29:07.512648632 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-30 09:30:16.267493085 +0100
@@ -34,16 +34,13 @@ xfs_find_handle(
 
 extern int
 xfs_open_by_handle(
-	xfs_mount_t		*mp,
-	xfs_fsop_handlereq_t	*hreq,
 	struct file		*parfilp,
-	struct inode		*parinode);
+	xfs_fsop_handlereq_t	*hreq);
 
 extern int
 xfs_readlink_by_handle(
-	xfs_mount_t		*mp,
-	xfs_fsop_handlereq_t	*hreq,
-	struct inode		*parinode);
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq);
 
 extern int
 xfs_attrmulti_attr_get(
@@ -67,6 +64,12 @@ xfs_attrmulti_attr_remove(
 	char			*name,
 	__uint32_t		flags);
 
+extern struct dentry *
+xfs_handle_to_dentry(
+	struct file		*parfilp,
+	void __user		*uhandle,
+	u32			hlen);
+
 extern long
 xfs_file_ioctl(
 	struct file		*filp,
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-12-30 09:29:07.519618655 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-12-30 09:30:16.271523207 +0100
@@ -340,96 +340,24 @@ xfs_compat_handlereq_copyin(
 	return 0;
 }
 
-/*
- * Convert userspace handle data into inode.
- *
- * We use the fact that all the fsop_handlereq ioctl calls have a data
- * structure argument whose first component is always a xfs_fsop_handlereq_t,
- * so we can pass that sub structure into this handy, shared routine.
- *
- * If no error, caller must always iput the returned inode.
- */
-STATIC int
-xfs_vget_fsop_handlereq_compat(
-	xfs_mount_t		*mp,
-	struct inode		*parinode,	/* parent inode pointer    */
-	compat_xfs_fsop_handlereq_t	*hreq,
-	struct inode		**inode)
+STATIC struct dentry *
+xfs_compat_handlereq_to_dentry(
+	struct file		*parfilp,
+	compat_xfs_fsop_handlereq_t *hreq)
 {
-	void			__user *hanp;
-	size_t			hlen;
-	xfs_fid_t		*xfid;
-	xfs_handle_t		*handlep;
-	xfs_handle_t		handle;
-	xfs_inode_t		*ip;
-	xfs_ino_t		ino;
-	__u32			igen;
-	int			error;
-
-	/*
-	 * Only allow handle opens under a directory.
-	 */
-	if (!S_ISDIR(parinode->i_mode))
-		return XFS_ERROR(ENOTDIR);
-
-	hanp = compat_ptr(hreq->ihandle);
-	hlen = hreq->ihandlen;
-	handlep = &handle;
-
-	if (hlen < sizeof(handlep->ha_fsid) || hlen > sizeof(*handlep))
-		return XFS_ERROR(EINVAL);
-	if (copy_from_user(handlep, hanp, hlen))
-		return XFS_ERROR(EFAULT);
-	if (hlen < sizeof(*handlep))
-		memset(((char *)handlep) + hlen, 0, sizeof(*handlep) - hlen);
-	if (hlen > sizeof(handlep->ha_fsid)) {
-		if (handlep->ha_fid.fid_len !=
-		    (hlen - sizeof(handlep->ha_fsid) -
-			    sizeof(handlep->ha_fid.fid_len)) ||
-		    handlep->ha_fid.fid_pad)
-			return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * Crack the handle, obtain the inode # & generation #
-	 */
-	xfid = (struct xfs_fid *)&handlep->ha_fid;
-	if (xfid->fid_len == sizeof(*xfid) - sizeof(xfid->fid_len)) {
-		ino  = xfid->fid_ino;
-		igen = xfid->fid_gen;
-	} else {
-		return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * Get the XFS inode, building a Linux inode to go with it.
-	 */
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
-	if (error)
-		return error;
-	if (ip == NULL)
-		return XFS_ERROR(EIO);
-	if (ip->i_d.di_gen != igen) {
-		xfs_iput_new(ip, XFS_ILOCK_SHARED);
-		return XFS_ERROR(ENOENT);
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	*inode = VFS_I(ip);
-	return 0;
+	return xfs_handle_to_dentry(parfilp,
+			compat_ptr(hreq->ihandle), hreq->ihandlen);
 }
 
 STATIC int
 xfs_compat_attrlist_by_handle(
-	xfs_mount_t		*mp,
-	void			__user *arg,
-	struct inode		*parinode)
+	struct file		*parfilp,
+	void			__user *arg)
 {
 	int			error;
 	attrlist_cursor_kern_t	*cursor;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
-	struct inode		*inode;
+	struct dentry		*dentry;
 	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -446,17 +374,17 @@ xfs_compat_attrlist_by_handle(
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -XFS_ERROR(EINVAL);
 
-	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &al_hreq.hreq,
-					       &inode);
-	if (error)
-		goto out;
+	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 
+	error = -ENOMEM;
 	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
 	if (!kbuf)
-		goto out_vn_rele;
+		goto out_dput;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_attr_list(XFS_I(inode), kbuf, al_hreq.buflen,
+	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
 					al_hreq.flags, cursor);
 	if (error)
 		goto out_kfree;
@@ -466,22 +394,20 @@ xfs_compat_attrlist_by_handle(
 
  out_kfree:
 	kfree(kbuf);
- out_vn_rele:
-	iput(inode);
- out:
-	return -error;
+ out_dput:
+	dput(dentry);
+	return error;
 }
 
 STATIC int
 xfs_compat_attrmulti_by_handle(
-	xfs_mount_t				*mp,
-	void					__user *arg,
-	struct inode				*parinode)
+	struct file				*parfilp,
+	void					__user *arg)
 {
 	int					error;
 	compat_xfs_attr_multiop_t		*ops;
 	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
-	struct inode				*inode;
+	struct dentry				*dentry;
 	unsigned int				i, size;
 	char					*attr_name;
 
@@ -491,20 +417,19 @@ xfs_compat_attrmulti_by_handle(
 			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &am_hreq.hreq,
-					       &inode);
-	if (error)
-		goto out;
+	dentry = xfs_compat_handlereq_to_dentry(parfilp, &am_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 
 	error = E2BIG;
 	size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
 	if (!size || size > 16 * PAGE_SIZE)
-		goto out_vn_rele;
+		goto out_dput;
 
 	error = ENOMEM;
 	ops = kmalloc(size, GFP_KERNEL);
 	if (!ops)
-		goto out_vn_rele;
+		goto out_dput;
 
 	error = EFAULT;
 	if (copy_from_user(ops, compat_ptr(am_hreq.ops), size))
@@ -527,20 +452,21 @@ xfs_compat_attrmulti_by_handle(
 
 		switch (ops[i].am_opcode) {
 		case ATTR_OP_GET:
-			ops[i].am_error = xfs_attrmulti_attr_get(inode,
-					attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_get(
+					dentry->d_inode, attr_name,
 					compat_ptr(ops[i].am_attrvalue),
 					&ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
-			ops[i].am_error = xfs_attrmulti_attr_set(inode,
-					attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					dentry->d_inode, attr_name,
 					compat_ptr(ops[i].am_attrvalue),
 					ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_REMOVE:
-			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
-					attr_name, ops[i].am_flags);
+			ops[i].am_error = xfs_attrmulti_attr_remove(
+					dentry->d_inode, attr_name,
+					ops[i].am_flags);
 			break;
 		default:
 			ops[i].am_error = EINVAL;
@@ -553,22 +479,20 @@ xfs_compat_attrmulti_by_handle(
 	kfree(attr_name);
  out_kfree_ops:
 	kfree(ops);
- out_vn_rele:
-	iput(inode);
- out:
+ out_dput:
+	dput(dentry);
 	return -error;
 }
 
 STATIC int
 xfs_compat_fssetdm_by_handle(
-	xfs_mount_t		*mp,
-	void			__user *arg,
-	struct inode		*parinode)
+	struct file		*parfilp,
+	void			__user *arg)
 {
 	int			error;
 	struct fsdmidata	fsd;
 	compat_xfs_fsop_setdm_handlereq_t dmhreq;
-	struct inode		*inode;
+	struct dentry		*dentry;
 
 	if (!capable(CAP_MKNOD))
 		return -XFS_ERROR(EPERM);
@@ -576,12 +500,11 @@ xfs_compat_fssetdm_by_handle(
 			   sizeof(compat_xfs_fsop_setdm_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
-	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &dmhreq.hreq,
-					       &inode);
-	if (error)
-		return -error;
+	dentry = xfs_compat_handlereq_to_dentry(parfilp, &dmhreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
+	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
 		error = -XFS_ERROR(EPERM);
 		goto out;
 	}
@@ -591,11 +514,11 @@ xfs_compat_fssetdm_by_handle(
 		goto out;
 	}
 
-	error = -xfs_set_dmattrs(XFS_I(inode), fsd.fsd_dmevmask,
+	error = -xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
 				 fsd.fsd_dmstate);
 
 out:
-	iput(inode);
+	dput(dentry);
 	return error;
 }
 
@@ -724,21 +647,21 @@ xfs_file_compat_ioctl(
 
 		if (xfs_compat_handlereq_copyin(&hreq, arg))
 			return -XFS_ERROR(EFAULT);
-		return xfs_open_by_handle(mp, &hreq, filp, inode);
+		return xfs_open_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_READLINK_BY_HANDLE_32: {
 		struct xfs_fsop_handlereq	hreq;
 
 		if (xfs_compat_handlereq_copyin(&hreq, arg))
 			return -XFS_ERROR(EFAULT);
-		return xfs_readlink_by_handle(mp, &hreq, inode);
+		return xfs_readlink_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
-		return xfs_compat_attrlist_by_handle(mp, arg, inode);
+		return xfs_compat_attrlist_by_handle(filp, arg);
 	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
-		return xfs_compat_attrmulti_by_handle(mp, arg, inode);
+		return xfs_compat_attrmulti_by_handle(filp, arg);
 	case XFS_IOC_FSSETDM_BY_HANDLE_32:
-		return xfs_compat_fssetdm_by_handle(mp, arg, inode);
+		return xfs_compat_fssetdm_by_handle(filp, arg);
 	default:
 		return -XFS_ERROR(ENOIOCTLCMD);
 	}

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
