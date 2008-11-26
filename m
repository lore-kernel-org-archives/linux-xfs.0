Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3KVfl000849 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:20:31 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7B0C15FCD9E
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:20:30 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id R2wOCVL0s6MVHgJP for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 19:20:30 -0800 (PST)
Message-Id: <20081126032029.414794702@sandeen.net>
References: <20081126032005.639750968@sandeen.net>
Date: Tue, 25 Nov 2008 21:20:17 -0600
From: sandeen@sandeen.net
Subject: [patch 12/12] Reorder xfs_ioctl32.c for some tidiness
Content-Disposition: inline; filename=compat_ioctl_tidy2
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

Put things in IMHO a more readable order, now
that it's all done; add some comments.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:32.471064582 -0600
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-11-24 17:00:33.095064454 -0600
@@ -16,11 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include <linux/compat.h>
-#include <linux/init.h>
 #include <linux/ioctl.h>
-#include <linux/syscalls.h>
-#include <linux/types.h>
-#include <linux/fs.h>
 #include <asm/uaccess.h>
 #include "xfs.h"
 #include "xfs_fs.h"
@@ -132,7 +128,7 @@ xfs_inumbers_fmt_compat(
 
 #else
 #define xfs_inumbers_fmt_compat xfs_inumbers_fmt
-#endif
+#endif	/* BROKEN_X86_ALIGNMENT */
 
 STATIC int
 xfs_ioctl32_bstime_copyin(
@@ -618,6 +614,7 @@ xfs_compat_ioctl(
 
 	xfs_itrace_entry(XFS_I(inode));
 	switch (cmd) {
+	/* No size or alignment issues on any arch */
 	case XFS_IOC_DIOINFO:
 	case XFS_IOC_FSGEOMETRY:
 	case XFS_IOC_FSGETXATTR:
@@ -630,35 +627,28 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSCOUNTS:
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
-	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSLOG:
-	case XFS_IOC_FSGROWFSRT:
 	case XFS_IOC_FREEZE:
 	case XFS_IOC_THAW:
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
-		break;
-
-	case XFS_IOC_GETXFLAGS_32:
-	case XFS_IOC_SETXFLAGS_32:
-	case XFS_IOC_GETVERSION_32:
-		cmd = _NATIVE_IOC(cmd, long);
-		break;
-	case XFS_IOC_SWAPEXT: {
-		struct xfs_swapext	  sxp;
-		struct compat_xfs_swapext __user *sxu = arg;
-
-		/* Bulk copy in up to the sx_stat field, then grab bstat */
-		if (copy_from_user(&sxp, sxu,
-				   offsetof(xfs_swapext_t, sx_stat)) ||
-		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
-			return -XFS_ERROR(EFAULT);
-		error = xfs_swapext(&sxp);
-		return -error;
-	}
-#ifdef BROKEN_X86_ALIGNMENT
-	/* xfs_flock_t has wrong u32 vs u64 alignment */
+		return xfs_ioctl(ip, filp, ioflags, cmd, arg);
+#ifndef BROKEN_X86_ALIGNMENT
+	/* These are handled fine if no alignment issues */
+	case XFS_IOC_ALLOCSP:
+	case XFS_IOC_FREESP:
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_ALLOCSP64:
+	case XFS_IOC_FREESP64:
+	case XFS_IOC_RESVSP64:
+	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_FSGEOMETRY_V1:
+	case XFS_IOC_FSGROWFSDATA:
+	case XFS_IOC_FSGROWFSRT:
+		return xfs_ioctl(ip, filp, ioflags, cmd, arg);
+#else
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
 	case XFS_IOC_ALLOCSP64_32:
@@ -692,18 +682,25 @@ xfs_compat_ioctl(
 		error = xfs_growfs_rt(mp, &in);
 		return -error;
 	}
-#else /* These are handled fine if no alignment issues */
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64:
-	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64:
-	case XFS_IOC_FSGEOMETRY_V1:
-		break;
 #endif
+	/* long changes size, but xfs only copiese out 32 bits */
+	case XFS_IOC_GETXFLAGS_32:
+	case XFS_IOC_SETXFLAGS_32:
+	case XFS_IOC_GETVERSION_32:
+		cmd = _NATIVE_IOC(cmd, long);
+		return xfs_ioctl(ip, filp, ioflags, cmd, arg);
+	case XFS_IOC_SWAPEXT: {
+		struct xfs_swapext	  sxp;
+		struct compat_xfs_swapext __user *sxu = arg;
+
+		/* Bulk copy in up to the sx_stat field, then copy bstat */
+		if (copy_from_user(&sxp, sxu,
+				   offsetof(struct xfs_swapext, sx_stat)) ||
+		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
+			return -XFS_ERROR(EFAULT);
+		error = xfs_swapext(&sxp);
+		return -error;
+	}
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
@@ -741,9 +738,6 @@ xfs_compat_ioctl(
 	default:
 		return -XFS_ERROR(ENOIOCTLCMD);
 	}
-
-	error = xfs_ioctl(ip, filp, ioflags, cmd, arg);
-	return error;
 }
 
 long

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
