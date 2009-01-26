Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7Wjwh203719 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B443E185E8EA
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0LrC04Qx5eoppeHj for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLww-00033m-CP
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:02 +0000
Message-Id: <20090126073202.277472000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/17] xfs: cleanup xfs_find_handle
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_find_handle
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

Remove the superflous igrab by keeping a reference on the path/file all the
time and clean up various bits of surrounding code.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2009-01-21 21:03:27.828295110 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2009-01-24 18:41:24.547427865 +0100
@@ -78,92 +78,74 @@ xfs_find_handle(
 	int			hsize;
 	xfs_handle_t		handle;
 	struct inode		*inode;
+	struct file		*file = NULL;
+	struct path		path;
+	int			error;
+	struct xfs_inode	*ip;
 
-	memset((char *)&handle, 0, sizeof(handle));
-
-	switch (cmd) {
-	case XFS_IOC_PATH_TO_FSHANDLE:
-	case XFS_IOC_PATH_TO_HANDLE: {
-		struct path path;
-		int error = user_lpath((const char __user *)hreq->path, &path);
+	if (cmd == XFS_IOC_FD_TO_HANDLE) {
+		file = fget(hreq->fd);
+		if (!file)
+			return -EBADF;
+		inode = file->f_path.dentry->d_inode;
+	} else {
+		error = user_lpath((const char __user *)hreq->path, &path);
 		if (error)
 			return error;
-
-		ASSERT(path.dentry);
-		ASSERT(path.dentry->d_inode);
-		inode = igrab(path.dentry->d_inode);
-		path_put(&path);
-		break;
+		inode = path.dentry->d_inode;
 	}
+	ip = XFS_I(inode);
 
-	case XFS_IOC_FD_TO_HANDLE: {
-		struct file	*file;
-
-		file = fget(hreq->fd);
-		if (!file)
-		    return -EBADF;
+	/*
+	 * We can only generate handles for inodes residing on a XFS filesystem,
+	 * and only for regular files, directories or symbolic links.
+	 */
+	error = -EINVAL;
+	if (inode->i_sb->s_magic != XFS_SB_MAGIC)
+		goto out_put;
 
-		ASSERT(file->f_path.dentry);
-		ASSERT(file->f_path.dentry->d_inode);
-		inode = igrab(file->f_path.dentry->d_inode);
-		fput(file);
-		break;
-	}
+	error = -EBADF;
+	if (!S_ISREG(inode->i_mode) &&
+	    !S_ISDIR(inode->i_mode) &&
+	    !S_ISLNK(inode->i_mode))
+		goto out_put;
 
-	default:
-		ASSERT(0);
-		return -XFS_ERROR(EINVAL);
-	}
 
-	if (inode->i_sb->s_magic != XFS_SB_MAGIC) {
-		/* we're not in XFS anymore, Toto */
-		iput(inode);
-		return -XFS_ERROR(EINVAL);
-	}
+	memcpy(&handle.ha_fsid, ip->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
 
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFREG:
-	case S_IFDIR:
-	case S_IFLNK:
-		break;
-	default:
-		iput(inode);
-		return -XFS_ERROR(EBADF);
-	}
-
-	/* now we can grab the fsid */
-	memcpy(&handle.ha_fsid, XFS_I(inode)->i_mount->m_fixedfsid,
-			sizeof(xfs_fsid_t));
-	hsize = sizeof(xfs_fsid_t);
-
-	if (cmd != XFS_IOC_PATH_TO_FSHANDLE) {
-		xfs_inode_t	*ip = XFS_I(inode);
+	if (cmd == XFS_IOC_PATH_TO_FSHANDLE) {
+		/*
+		 * This handle only contains an fsid, zero the rest.
+		 */
+		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
+		hsize = sizeof(xfs_fsid_t);
+	} else {
 		int		lock_mode;
 
-		/* need to get access to the xfs_inode to read the generation */
 		lock_mode = xfs_ilock_map_shared(ip);
-
-		/* fill in fid section of handle from inode */
 		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 					sizeof(handle.ha_fid.fid_len);
 		handle.ha_fid.fid_pad = 0;
 		handle.ha_fid.fid_gen = ip->i_d.di_gen;
 		handle.ha_fid.fid_ino = ip->i_ino;
-
 		xfs_iunlock_map_shared(ip, lock_mode);
 
 		hsize = XFS_HSIZE(handle);
 	}
 
-	/* now copy our handle into the user buffer & write out the size */
+	error = -EFAULT;
 	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
-	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32))) {
-		iput(inode);
-		return -XFS_ERROR(EFAULT);
-	}
+	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32)))
+		goto out_put;
 
-	iput(inode);
-	return 0;
+	error = 0;
+
+ out_put:
+	if (cmd == XFS_IOC_FD_TO_HANDLE)
+		fput(file);
+	else
+		path_put(&path);
+	return error;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
