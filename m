Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ4nsfn029974 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 22:49:54 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63601159E75F
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 20:49:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id QlPMsPiLsDAnkIJF for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 20:49:27 -0800 (PST)
Message-Id: <20081119044910.489906118@sandeen.net>
References: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:12 -0600
From: sandeen@sandeen.net
Subject: [patch 11/11] Reorder xfs_ioctl32.c for some tidiness
Content-Disposition: inline; filename=compat_ioctl_tidy
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

Put things in IMHO a more readable order, now
that it's all done; add some comments.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -634,6 +634,7 @@ xfs_compat_ioctl(
 	int		error;
 
 	switch (cmd) {
+	/* No size or alignment issues with any of these on any arch */
 	case XFS_IOC_DIOINFO:
 	case XFS_IOC_FSGEOMETRY:
 	case XFS_IOC_FSGETXATTR:
@@ -655,14 +656,18 @@ xfs_compat_ioctl(
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
 		break;
-
-	case XFS_IOC_GETXFLAGS_32:
-	case XFS_IOC_SETXFLAGS_32:
-	case XFS_IOC_GETVERSION_32:
-		cmd = _NATIVE_IOC(cmd, long);
+#ifndef BROKEN_X86_ALIGNMENT /* handled fine if no alignment issues */
+	case XFS_IOC_ALLOCSP:
+	case XFS_IOC_FREESP:
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_ALLOCSP64:
+	case XFS_IOC_FREESP64:
+	case XFS_IOC_RESVSP64:
+	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_FSGEOMETRY_V1:
 		break;
-#ifdef BROKEN_X86_ALIGNMENT
-	/* xfs_flock_t has wrong u32 vs u64 alignment */
+#else	/* BROKEN_X86_ALIGNMENT */
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
 	case XFS_IOC_ALLOCSP64_32:
@@ -674,9 +679,6 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_flock_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
 		break;
-	case XFS_IOC_FSGEOMETRY_V1_32:
-		return xfs_ioc_fsgeometry_v1_compat(XFS_I(inode)->i_mount,
-						    (void __user*)arg);
 	case XFS_IOC_FSGROWFSDATA_32:
 		arg = xfs_ioctl32_growfs_data_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_growfs_data);
@@ -684,28 +686,21 @@ xfs_compat_ioctl(
 	case XFS_IOC_FSGROWFSRT_32:
 		arg = xfs_ioctl32_growfs_rt_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_growfs_rt);
+	case XFS_IOC_FSGEOMETRY_V1_32:
+		return xfs_ioc_fsgeometry_v1_compat(XFS_I(inode)->i_mount,
+						    (void __user*)arg);
 	break;
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
+	/* long varies in size, but xfs only ever copies out 32 bits */
+	case XFS_IOC_GETXFLAGS_32:
+	case XFS_IOC_SETXFLAGS_32:
+	case XFS_IOC_GETVERSION_32:
+		cmd = _NATIVE_IOC(cmd, long);
+		break;
 	case XFS_IOC_SWAPEXT_32:
 		arg = xfs_ioctl32_swapext_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_swapext);
 		break;
-	case XFS_IOC_FSBULKSTAT_32:
-	case XFS_IOC_FSBULKSTAT_SINGLE_32:
-	case XFS_IOC_FSINUMBERS_32:
-		return xfs_ioc_bulkstat_compat(XFS_I(inode)->i_mount,
-				cmd, (void __user*)arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32:
@@ -714,6 +709,11 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_fshandle_copyin(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
 		break;
+	case XFS_IOC_FSBULKSTAT_32:
+	case XFS_IOC_FSBULKSTAT_SINGLE_32:
+	case XFS_IOC_FSINUMBERS_32:
+		return xfs_ioc_bulkstat_compat(XFS_I(inode)->i_mount,
+				cmd, (void __user*)arg);
 	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
 		return xfs_attrlist_by_handle_compat((void __user*)arg, inode);
 	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
