Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ61Bjd004673 for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 00:01:12 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51F25159E6B9
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 21:49:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id hrpJ4ywuBEgFAQq0 for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 21:49:48 -0800 (PST)
Message-Id: <20081119044908.507467044@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:04 -0600
From: sandeen@sandeen.net
Subject: [patch 03/11] Add compat handlers for data & rt growfs ioctls
Content-Disposition: inline; filename=compat_ioctl_growfs
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

The args for XFS_IOC_FSGROWFSDATA and XFS_IOC_FSGROWFSRTA
have padding on the end on intel, so add arg copyin functions,
and then just call the native ioctl.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -87,6 +87,28 @@ xfs_ioc_fsgeometry_v1_compat(
 	return 0;
 }
 
+STATIC unsigned long
+xfs_ioctl32_growfs_data_copyin(unsigned long arg)
+{
+	compat_xfs_growfs_data_t __user *p32 = (void __user *)arg;
+	xfs_growfs_data_t __user *p = compat_alloc_user_space(sizeof(*p));
+
+	if (copy_in_user(p, p32, sizeof(*p32)))
+		return -XFS_ERROR(EFAULT);
+	return (unsigned long)p;
+}
+
+STATIC unsigned long
+xfs_ioctl32_growfs_rt_copyin(unsigned long arg)
+{
+	compat_xfs_growfs_rt_t	__user *p32 = (void __user *)arg;
+	xfs_growfs_rt_t		__user *p = compat_alloc_user_space(sizeof(*p));
+
+	if (copy_in_user(p, p32, sizeof(*p32)))
+		return -XFS_ERROR(EFAULT);
+	return (unsigned long)p;
+}
+
 STATIC int
 xfs_inumbers_fmt_compat(
 	void __user *ubuffer,
@@ -310,7 +332,14 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGEOMETRY_V1_32:
 		return xfs_ioc_fsgeometry_v1_compat(XFS_I(inode)->i_mount,
 						    (void __user*)arg);
-
+	case XFS_IOC_FSGROWFSDATA_32:
+		arg = xfs_ioctl32_growfs_data_copyin(arg);
+		cmd = _NATIVE_IOC(cmd, struct xfs_growfs_data);
+		break;
+	case XFS_IOC_FSGROWFSRT_32:
+		arg = xfs_ioctl32_growfs_rt_copyin(arg);
+		cmd = _NATIVE_IOC(cmd, struct xfs_growfs_rt);
+	break;
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
@@ -322,7 +351,6 @@ xfs_compat_ioctl(
 	case XFS_IOC_UNRESVSP64:
 	case XFS_IOC_FSGEOMETRY_V1:
 		break;
-
 	/* xfs_bstat_t still has wrong u32 vs u64 alignment */
 	case XFS_IOC_SWAPEXT:
 		break;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
@@ -159,6 +159,20 @@ typedef struct compat_xfs_inogrp {
 	__u64		xi_allocmask;	/* mask of allocated inodes	*/
 } __attribute__((packed)) compat_xfs_inogrp_t;
 
+/* These growfs input structures have padding on the end, so must translate */
+typedef struct compat_xfs_growfs_data {
+	__u64		newblocks;	/* new data subvol size, fsblocks */
+	__u32		imaxpct;	/* new inode space percentage limit */
+} __attribute__((packed)) compat_xfs_growfs_data_t;
+
+typedef struct compat_xfs_growfs_rt {
+	__u64		newblocks;	/* new realtime size, fsblocks */
+	__u32		extsize;	/* new realtime extent size, fsblocks */
+} __attribute__((packed)) compat_xfs_growfs_rt_t;
+
+#define XFS_IOC_FSGROWFSDATA_32 _IOW ('X', 110, struct compat_xfs_growfs_data)
+#define XFS_IOC_FSGROWFSRT_32   _IOW ('X', 112, struct compat_xfs_growfs_rt)
+
 #endif /* BROKEN_X86_ALIGNMENT */
 
 #endif /* __XFS_IOCTL32_H__ */

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
