Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ4nvS8029996 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:49:58 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96E94159E3E3
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:49:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id ZJ5BhYuZlilrJPHA for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 20:49:27 -0800 (PST)
Message-Id: <20081119044910.323857277@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:11 -0600
From: sandeen@sandeen.net
Subject: [patch 10/11] Hook up compat XFS_IOC_FSSETDM_BY_HANDLE ioctl handler
Content-Disposition: inline; filename=compat_ioctl_dmidata
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
Cc: hch@infradead.org

Add a compat handler for XFS_IOC_FSSETDM_BY_HANDLE.

I haven't tested this, lacking dmapi tools to do so
(unless xfsqa magically gets this somehow?)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -585,6 +585,44 @@ xfs_attrmulti_by_handle_compat(
 	return -error;
 }
 
+STATIC int
+compat_xfs_fssetdm_by_handle(
+	void			__user *arg,
+	struct inode		*parinode)
+{
+	int			error;
+	struct fsdmidata	fsd;
+	compat_xfs_fsop_setdm_handlereq_t dmhreq;
+	struct inode		*inode;
+	xfs_mount_t		*mp = XFS_I(parinode)->i_mount;
+
+	if (!capable(CAP_MKNOD))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&dmhreq, arg, sizeof(compat_xfs_fsop_setdm_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &dmhreq.hreq, &inode);
+	if (error)
+		return -error;
+
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
+		error = -XFS_ERROR(EPERM);
+		goto out;
+	}
+
+	if (copy_from_user(&fsd, compat_ptr(dmhreq.data), sizeof(fsd))) {
+		error = -XFS_ERROR(EFAULT);
+		goto out;
+	}
+
+	error = -xfs_set_dmattrs(XFS_I(inode), fsd.fsd_dmevmask,
+				 fsd.fsd_dmstate);
+
+out:
+	iput(inode);
+	return error;
+}
+
 STATIC long
 xfs_compat_ioctl(
 	int		mode,
@@ -605,7 +643,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
-/*	case XFS_IOC_FSSETDM_BY_HANDLE: not handled */
 	case XFS_IOC_FSCOUNTS:
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
@@ -681,6 +718,8 @@ xfs_compat_ioctl(
 		return xfs_attrlist_by_handle_compat((void __user*)arg, inode);
 	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
 		return xfs_attrmulti_by_handle_compat((void __user*)arg, inode);
+	case XFS_IOC_FSSETDM_BY_HANDLE_32:
+		return compat_xfs_fssetdm_by_handle((void __user*)arg, inode);
 	default:
 		return -XFS_ERROR(ENOIOCTLCMD);
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
@@ -151,6 +151,15 @@ typedef struct compat_xfs_fsop_attrmulti
 #define XFS_IOC_ATTRMULTI_BY_HANDLE_32 \
 	_IOW ('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
 
+typedef struct compat_xfs_fsop_setdm_handlereq {
+	struct compat_xfs_fsop_handlereq hreq;	/* handle information   */
+	/* ptr to struct fsdmidata */
+	compat_uptr_t			data;	/* DMAPI data   */
+} compat_xfs_fsop_setdm_handlereq_t;
+
+#define XFS_IOC_FSSETDM_BY_HANDLE_32 \
+	_IOW ('X', 121, struct compat_xfs_fsop_setdm_handlereq)
+
 #ifdef BROKEN_X86_ALIGNMENT
 /* on ia32 l_start is on a 32-bit boundary */
 typedef struct compat_xfs_flock64 {

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
