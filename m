Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ4nJDv029919 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:49:19 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18CC6159E761
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:49:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id GMKOSJwF5Kii0jcz for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 20:49:11 -0800 (PST)
Message-Id: <20081119044908.158054231@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:03 -0600
From: sandeen@sandeen.net
Subject: [patch 02/11] Fix the compat XFS_IOC_FSGEOMETRY_V1 ioctl
Content-Disposition: inline; filename=fix_compat_fsgeometry_v1
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

This ioctl copies kernel data to the user, so we
must have a compat helper to copy it out to the
32-bit structure; the current code had it backward,
and translated the 32-bit arg to 64-bit, and called
the native ioctl, which copied it back as if it were
talking to 64-bit userspace.  Because the 64-bit arg
has padding on the end on intel, I think this risked
corruption in userspace..

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -44,6 +44,7 @@
 #include "xfs_error.h"
 #include "xfs_dfrag.h"
 #include "xfs_vnodeops.h"
+#include "xfs_fsops.h"
 #include "xfs_ioctl32.h"
 
 #define  _NATIVE_IOC(cmd, type) \
@@ -68,15 +69,22 @@ xfs_ioctl32_flock_copyin(unsigned long a
 	return (unsigned long)p;
 }
 
-STATIC unsigned long
-xfs_ioctl32_geom_v1_copyin(unsigned long arg)
+/* This handles a copy-out, where the 32-bit user struct lacks padding */
+STATIC int
+xfs_ioc_fsgeometry_v1_compat(
+	xfs_mount_t		*mp,
+	void			__user *arg)
 {
-	compat_xfs_fsop_geom_v1_t __user *p32 = (void __user *)arg;
-	xfs_fsop_geom_v1_t __user *p = compat_alloc_user_space(sizeof(*p));
+	xfs_fsop_geom_v1_t	fsgeo;
+	int			error;
 
-	if (copy_in_user(p, p32, sizeof(*p32)))
+	error = xfs_fs_geometry(mp, (xfs_fsop_geom_t *)&fsgeo, 3);
+	if (error)
+		return -error;
+
+	if (copy_to_user(arg, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
 		return -XFS_ERROR(EFAULT);
-	return (unsigned long)p;
+	return 0;
 }
 
 STATIC int
@@ -300,9 +308,8 @@ xfs_compat_ioctl(
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
 		break;
 	case XFS_IOC_FSGEOMETRY_V1_32:
-		arg = xfs_ioctl32_geom_v1_copyin(arg);
-		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_geom_v1);
-		break;
+		return xfs_ioc_fsgeometry_v1_compat(XFS_I(inode)->i_mount,
+						    (void __user*)arg);
 
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
