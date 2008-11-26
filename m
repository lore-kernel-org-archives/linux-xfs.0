Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3L1eH000912 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:21:01 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2821B15FDA20
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:20:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id fUIYcegYaHSDlMzg for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:20:59 -0800 (PST)
Message-Id: <20081126032028.057811191@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:10 -0600
From: sandeen@sandeen.net
Subject: [patch 05/12] Add compat handlers for data & rt growfs ioctls
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

The args for XFS_IOC_FSGROWFSDATA and XFS_IOC_FSGROWFSRTA
have padding on the end on intel, so add arg copyin functions,
and then just call the growfs ioctl helpers.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:25.416001918 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:09:28.311001451 -0600
@@ -45,6 +45,8 @@
 #include "xfs_dfrag.h"
 #include "xfs_vnodeops.h"
 #include "xfs_fsops.h"
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
 
@@ -86,6 +88,28 @@ xfs_compat_ioc_fsgeometry_v1(
 }
 
 STATIC int
+xfs_compat_growfs_data_copyin(
+	struct xfs_growfs_data	 *in,
+	compat_xfs_growfs_data_t __user *arg32)
+{
+	if (get_user(in->newblocks, &arg32->newblocks) ||
+	    get_user(in->imaxpct,   &arg32->imaxpct))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
+xfs_compat_growfs_rt_copyin(
+	struct xfs_growfs_rt	 *in,
+	compat_xfs_growfs_rt_t	__user *arg32)
+{
+	if (get_user(in->newblocks, &arg32->newblocks) ||
+	    get_user(in->extsize,   &arg32->extsize))
+		return -XFS_ERROR(EFAULT);
+	return 0;
+}
+
+STATIC int
 xfs_inumbers_fmt_compat(
 	void			__user *ubuffer,
 	const xfs_inogrp_t	*buffer,
@@ -368,6 +392,22 @@ xfs_compat_ioctl(
 	}
 	case XFS_IOC_FSGEOMETRY_V1_32:
 		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
+	case XFS_IOC_FSGROWFSDATA_32: {
+		struct xfs_growfs_data	in;
+
+		if (xfs_compat_growfs_data_copyin(&in, arg))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_growfs_data(mp, &in);
+		return -error;
+	}
+	case XFS_IOC_FSGROWFSRT_32: {
+		struct xfs_growfs_rt	in;
+
+		if (xfs_compat_growfs_rt_copyin(&in, arg))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_growfs_rt(mp, &in);
+		return -error;
+	}
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:00:25.432471112 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-11-24 17:09:26.662001447 -0600
@@ -177,6 +177,20 @@ typedef struct compat_xfs_inogrp {
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
+#define XFS_IOC_FSGROWFSDATA_32 _IOW('X', 110, struct compat_xfs_growfs_data)
+#define XFS_IOC_FSGROWFSRT_32   _IOW('X', 112, struct compat_xfs_growfs_rt)
+
 #endif /* BROKEN_X86_ALIGNMENT */
 
 #endif /* __XFS_IOCTL32_H__ */

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
