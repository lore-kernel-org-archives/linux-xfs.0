Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jul 2007 14:13:56 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6TLDpbm004497
	for <xfs@oss.sgi.com>; Sun, 29 Jul 2007 14:13:52 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6TLDsA5012944
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 29 Jul 2007 23:13:54 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6TLDsO8012942
	for xfs@oss.sgi.com; Sun, 29 Jul 2007 23:13:54 +0200
Date: Sun, 29 Jul 2007 23:13:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] stop using uio in the readlink code
Message-ID: <20070729211354.GB12824@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Simplify the readlink code to get rid of the last user of uio.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-07-13 19:17:50.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-07-29 13:59:48.000000000 +0200
@@ -542,50 +542,26 @@ xfs_vn_follow_link(
 	struct dentry		*dentry,
 	struct nameidata	*nd)
 {
-	bhv_vnode_t		*vp;
-	uio_t			*uio;
-	iovec_t			iov;
-	int			error;
+	bhv_vnode_t		*vp = vn_from_inode(dentry->d_inode);
 	char			*link;
-
-	ASSERT(dentry);
-	ASSERT(nd);
+	int			error = -ENOMEM;
 
 	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
-	if (!link) {
-		nd_set_link(nd, ERR_PTR(-ENOMEM));
-		return NULL;
-	}
-
-	uio = kmalloc(sizeof(uio_t), GFP_KERNEL);
-	if (!uio) {
-		kfree(link);
-		nd_set_link(nd, ERR_PTR(-ENOMEM));
-		return NULL;
-	}
+	if (!link)
+		goto out_err;
 
-	vp = vn_from_inode(dentry->d_inode);
-
-	iov.iov_base = link;
-	iov.iov_len = MAXPATHLEN;
-
-	uio->uio_iov = &iov;
-	uio->uio_offset = 0;
-	uio->uio_segflg = UIO_SYSSPACE;
-	uio->uio_resid = MAXPATHLEN;
-	uio->uio_iovcnt = 1;
-
-	error = bhv_vop_readlink(vp, uio, 0, NULL);
-	if (unlikely(error)) {
-		kfree(link);
-		link = ERR_PTR(-error);
-	} else {
-		link[MAXPATHLEN - uio->uio_resid] = '\0';
-	}
-	kfree(uio);
+	error = -bhv_vop_readlink(vp, link);
+	if (unlikely(error))
+		goto out_kfree;
 
 	nd_set_link(nd, link);
 	return NULL;
+
+ out_kfree:
+	kfree(link);
+ out_err:
+	nd_set_link(nd, ERR_PTR(error));
+	return NULL;
 }
 
 STATIC void
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-07-28 19:13:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-07-29 13:59:48.000000000 +0200
@@ -18,7 +18,6 @@
 #ifndef __XFS_VNODE_H__
 #define __XFS_VNODE_H__
 
-struct uio;
 struct file;
 struct bhv_vfs;
 struct bhv_vattr;
@@ -168,8 +167,7 @@ typedef int	(*vop_readdir_t)(bhv_desc_t 
 				 xfs_off_t *offset, filldir_t filldir);
 typedef int	(*vop_symlink_t)(bhv_desc_t *, bhv_vname_t *, struct bhv_vattr*,
 				char *, bhv_vnode_t **, struct cred *);
-typedef int	(*vop_readlink_t)(bhv_desc_t *, struct uio *, int,
-				struct cred *);
+typedef int	(*vop_readlink_t)(bhv_desc_t *, char *);
 typedef int	(*vop_fsync_t)(bhv_desc_t *, int, struct cred *,
 				xfs_off_t, xfs_off_t);
 typedef int	(*vop_inactive_t)(bhv_desc_t *, struct cred *);
@@ -280,8 +278,8 @@ typedef struct bhv_vnodeops {
 		VOP(vop_readdir, vp)(VNHEAD(vp),dirent,bufsize,offset,filldir)
 #define	bhv_vop_symlink(dvp,d,vap,tnm,vpp,cr)				\
 		VOP(vop_symlink, dvp)(VNHEAD(dvp),d,vap,tnm,vpp,cr)
-#define	bhv_vop_readlink(vp,uiop,fl,cr)					\
-		VOP(vop_readlink, vp)(VNHEAD(vp),uiop,fl,cr)
+#define	bhv_vop_readlink(vp,link)					\
+		VOP(vop_readlink, vp)(VNHEAD(vp), link)
 #define	bhv_vop_fsync(vp,f,cr,b,e)	VOP(vop_fsync, vp)(VNHEAD(vp),f,cr,b,e)
 #define bhv_vop_inactive(vp,cr)		VOP(vop_inactive, vp)(VNHEAD(vp),cr)
 #define bhv_vop_release(vp)		VOP(vop_release, vp)(VNHEAD(vp))
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-07-28 19:13:58.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-07-29 14:11:13.000000000 +0200
@@ -951,6 +951,53 @@ xfs_access(
  */
 #define SYMLINK_MAPS 2
 
+STATIC int
+xfs_readlink_bmap(
+	xfs_inode_t	*ip,
+	char		*link)
+{
+	xfs_mount_t	*mp = ip->i_mount;
+	int		pathlen = ip->i_d.di_size;
+	int             nmaps = SYMLINK_MAPS;
+	xfs_bmbt_irec_t mval[SYMLINK_MAPS];
+	xfs_daddr_t	d;
+	int		byte_cnt;
+	int		n;
+	xfs_buf_t	*bp;
+	int		error = 0;
+
+	error = xfs_bmapi(NULL, ip, 0, XFS_B_TO_FSB(mp, pathlen), 0, NULL, 0,
+			mval, &nmaps, NULL, NULL);
+	if (error)
+		goto out;
+
+	for (n = 0; n < nmaps; n++) {
+		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+
+		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0);
+		error = XFS_BUF_GETERROR(bp);
+		if (error) {
+			xfs_ioerror_alert("xfs_readlink",
+				  ip->i_mount, bp, XFS_BUF_ADDR(bp));
+			xfs_buf_relse(bp);
+			goto out;
+		}
+		if (pathlen < byte_cnt)
+			byte_cnt = pathlen;
+		pathlen -= byte_cnt;
+
+		memcpy(link, XFS_BUF_PTR(bp), byte_cnt);
+		xfs_buf_relse(bp);
+	}
+
+	link[ip->i_d.di_size] = '\0';
+	error = 0;
+
+ out:
+	return error;
+}
+
 /*
  * xfs_readlink
  *
@@ -958,29 +1005,14 @@ xfs_access(
 STATIC int
 xfs_readlink(
 	bhv_desc_t	*bdp,
-	uio_t		*uiop,
-	int		ioflags,
-	cred_t		*credp)
+	char		*link)
 {
-	xfs_inode_t     *ip;
-	int		count;
-	xfs_off_t	offset;
+	xfs_inode_t     *ip = XFS_BHVTOI(bdp);
+	xfs_mount_t	*mp = ip->i_mount;
 	int		pathlen;
-	bhv_vnode_t	*vp;
 	int		error = 0;
-	xfs_mount_t	*mp;
-	int             nmaps;
-	xfs_bmbt_irec_t mval[SYMLINK_MAPS];
-	xfs_daddr_t	d;
-	int		byte_cnt;
-	int		n;
-	xfs_buf_t	*bp;
-
-	vp = BHV_TO_VNODE(bdp);
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
 
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
+	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -988,68 +1020,24 @@ xfs_readlink(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFLNK);
+	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
 
-	offset = uiop->uio_offset;
-	count = uiop->uio_resid;
-
-	if (offset < 0) {
-		error = XFS_ERROR(EINVAL);
-		goto error_return;
-	}
-	if (count <= 0) {
-		error = 0;
-		goto error_return;
-	}
-
-	/*
-	 * See if the symlink is stored inline.
-	 */
-	pathlen = (int)ip->i_d.di_size;
+	pathlen = ip->i_d.di_size;
+	if (!pathlen)
+		goto out;
 
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		error = xfs_uio_read(ip->i_df.if_u1.if_data, pathlen, uiop);
-	}
-	else {
-		/*
-		 * Symlink not inline.  Call bmap to get it in.
-		 */
-		nmaps = SYMLINK_MAPS;
-
-		error = xfs_bmapi(NULL, ip, 0, XFS_B_TO_FSB(mp, pathlen),
-				  0, NULL, 0, mval, &nmaps, NULL, NULL);
-
-		if (error) {
-			goto error_return;
-		}
-
-		for (n = 0; n < nmaps; n++) {
-			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
-			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-			bp = xfs_buf_read(mp->m_ddev_targp, d,
-				      BTOBB(byte_cnt), 0);
-			error = XFS_BUF_GETERROR(bp);
-			if (error) {
-				xfs_ioerror_alert("xfs_readlink",
-					  ip->i_mount, bp, XFS_BUF_ADDR(bp));
-				xfs_buf_relse(bp);
-				goto error_return;
-			}
-			if (pathlen < byte_cnt)
-				byte_cnt = pathlen;
-			pathlen -= byte_cnt;
-
-			error = xfs_uio_read(XFS_BUF_PTR(bp), byte_cnt, uiop);
-			xfs_buf_relse (bp);
-		}
-
+		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
+		link[pathlen] = '\0';
+	} else {
+		error = xfs_readlink_bmap(ip, link);
 	}
 
-error_return:
+ out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return error;
 }
 
-
 /*
  * xfs_fsync
  *
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-07-14 16:07:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-07-29 14:28:29.000000000 +0200
@@ -349,19 +349,44 @@ xfs_open_by_handle(
 	return new_fd;
 }
 
+/*
+ * This is a copy from fs/namei.c:vfs_readlink(), except for removing it's
+ * unused first argument.
+ */
+STATIC int
+do_readlink(
+	char __user		*buffer,
+	int			buflen,
+	const char		*link)
+{
+        int len;
+
+	len = PTR_ERR(link);
+	if (IS_ERR(link))
+		goto out;
+
+	len = strlen(link);
+	if (len > (unsigned) buflen)
+		len = buflen;
+	if (copy_to_user(buffer, link, len))
+		len = -EFAULT;
+ out:
+	return len;
+}
+
+
 STATIC int
 xfs_readlink_by_handle(
 	xfs_mount_t		*mp,
 	void			__user *arg,
 	struct inode		*parinode)
 {
-	int			error;
-	struct iovec		aiov;
-	struct uio		auio;
 	struct inode		*inode;
 	xfs_fsop_handlereq_t	hreq;
 	bhv_vnode_t		*vp;
 	__u32			olen;
+	void			*link;
+	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -XFS_ERROR(EPERM);
@@ -374,29 +399,31 @@ xfs_readlink_by_handle(
 
 	/* Restrict this handle operation to symlinks only. */
 	if (!S_ISLNK(inode->i_mode)) {
-		VN_RELE(vp);
-		return -XFS_ERROR(EINVAL);
+		error = -XFS_ERROR(EINVAL);
+		goto out_iput;
 	}
 
 	if (copy_from_user(&olen, hreq.ohandlen, sizeof(__u32))) {
-		VN_RELE(vp);
-		return -XFS_ERROR(EFAULT);
+		error = -XFS_ERROR(EFAULT);
+		goto out_iput;
 	}
-	aiov.iov_len	= olen;
-	aiov.iov_base	= hreq.ohandle;
 
-	auio.uio_iov	= (struct kvec *)&aiov;
-	auio.uio_iovcnt	= 1;
-	auio.uio_offset	= 0;
-	auio.uio_segflg	= UIO_USERSPACE;
-	auio.uio_resid	= olen;
+	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
+	if (!link)
+		goto out_iput;
 
-	error = bhv_vop_readlink(vp, &auio, IO_INVIS, NULL);
-	VN_RELE(vp);
+	error = -bhv_vop_readlink(vp, link);
 	if (error)
-		return -error;
+		goto out_kfree;
+	error = do_readlink(hreq.ohandle, olen, link);
+	if (error)
+		goto out_kfree;
 
-	return (olen - auio.uio_resid);
+ out_kfree:
+	kfree(link);
+ out_iput:
+	iput(inode);
+	return error;
 }
 
 STATIC int
