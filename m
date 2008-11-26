Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3KVbf000848 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:20:31 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72C8F15FCD9D
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:20:30 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id YCN6XkfAY8o04pW5 for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:20:30 -0800 (PST)
Message-Id: <20081126032029.248653456@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:16 -0600
From: sandeen@sandeen.net
Subject: [patch 11/12] Hook up compat XFS_IOC_FSSETDM_BY_HANDLE ioctl handler
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

Add a compat handler for XFS_IOC_FSSETDM_BY_HANDLE.

I haven't tested this, lacking dmapi tools to do so
(unless xfsqa magically gets this somehow?)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:31.867064829 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:24.877001309 -0600
@@ -564,6 +564,46 @@ xfs_compat_attrmulti_by_handle(
 	return -error;
 }
 
+STATIC int
+xfs_compat_fssetdm_by_handle(
+	xfs_mount_t		*mp,
+	void			__user *arg,
+	struct inode		*parinode)
+{
+	int			error;
+	struct fsdmidata	fsd;
+	compat_xfs_fsop_setdm_handlereq_t dmhreq;
+	struct inode		*inode;
+
+	if (!capable(CAP_MKNOD))
+		return -XFS_ERROR(EPERM);
+	if (copy_from_user(&dmhreq, arg,
+			   sizeof(compat_xfs_fsop_setdm_handlereq_t)))
+		return -XFS_ERROR(EFAULT);
+
+	error = xfs_vget_fsop_handlereq_compat(mp, parinode, &dmhreq.hreq,
+					       &inode);
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
 	xfs_inode_t	*ip,
@@ -587,7 +627,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
-/*	case XFS_IOC_FSSETDM_BY_HANDLE: not handled */
 	case XFS_IOC_FSCOUNTS:
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
@@ -697,6 +736,8 @@ xfs_compat_ioctl(
 		return xfs_compat_attrlist_by_handle(mp, arg, inode);
 	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
 		return xfs_compat_attrmulti_by_handle(mp, arg, inode);
+	case XFS_IOC_FSSETDM_BY_HANDLE_32:
+		return xfs_compat_fssetdm_by_handle(mp, arg, inode);
 	default:
 		return -XFS_ERROR(ENOIOCTLCMD);
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:00:31.868065182 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:00:32.484001157 -0600
@@ -155,6 +155,15 @@ typedef struct compat_xfs_fsop_attrmulti
 #define XFS_IOC_ATTRMULTI_BY_HANDLE_32 \
 	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
 
+typedef struct compat_xfs_fsop_setdm_handlereq {
+	struct compat_xfs_fsop_handlereq hreq;	/* handle information   */
+	/* ptr to struct fsdmidata */
+	compat_uptr_t			data;	/* DMAPI data   */
+} compat_xfs_fsop_setdm_handlereq_t;
+
+#define XFS_IOC_FSSETDM_BY_HANDLE_32 \
+	_IOW('X', 121, struct compat_xfs_fsop_setdm_handlereq)
+
 #ifdef BROKEN_X86_ALIGNMENT
 /* on ia32 l_start is on a 32-bit boundary */
 typedef struct compat_xfs_flock64 {

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
