Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Sep 2007 19:50:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8H2nsuw028355
	for <xfs@oss.sgi.com>; Sun, 16 Sep 2007 19:49:57 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 8667A18003EF4
	for <xfs@oss.sgi.com>; Sun, 16 Sep 2007 20:47:22 -0500 (CDT)
Message-ID: <46EDDCA7.5030601@sandeen.net>
Date: Sun, 16 Sep 2007 20:47:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

XFS_IOC_GETVERSION, XFS_IOC_GETXFLAGS and XFS_IOC_SETXFLAGS all
take a "long" which changes size between 32 and 64 bit platforms.

So, the ioctl cmds that come in from a 32-bit app aren't as expected, 
for example on GETXFLAGS,

	unknown cmd fd(3) cmd(80046601){t:'f';sz:4}

due to the size mismatch.

So, use instead the 32-bit version of the commands for compat ioctls,
and other than that it doesn't take any more manipulation.

Also, for both native and compat versions, just define them to
the values as defined in fs.h

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6.22.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ linux-2.6.22/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -376,9 +376,6 @@ xfs_compat_ioctl(
 	switch (cmd) {
 	case XFS_IOC_DIOINFO:
 	case XFS_IOC_FSGEOMETRY:
-	case XFS_IOC_GETVERSION:
-	case XFS_IOC_GETXFLAGS:
-	case XFS_IOC_SETXFLAGS:
 	case XFS_IOC_FSGETXATTR:
 	case XFS_IOC_FSSETXATTR:
 	case XFS_IOC_FSGETXATTRA:
@@ -404,6 +401,11 @@ xfs_compat_ioctl(
 	case XFS_IOC_ERROR_CLEARALL:
 		break;
 
+	case XFS_IOC32_GETXFLAGS:
+	case XFS_IOC32_SETXFLAGS:
+	case XFS_IOC32_GETVERSION:
+		cmd = _NATIVE_IOC(cmd, long);
+		break;
 #ifdef BROKEN_X86_ALIGNMENT
 	/* xfs_flock_t has wrong u32 vs u64 alignment */
 	case XFS_IOC_ALLOCSP_32:
Index: linux-2.6.22/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.22.orig/fs/xfs/xfs_fs.h
+++ linux-2.6.22/fs/xfs/xfs_fs.h
@@ -436,9 +436,13 @@ typedef struct xfs_handle {
 /*
  * ioctl commands that are used by Linux filesystems
  */
-#define XFS_IOC_GETXFLAGS	_IOR('f', 1, long)
-#define XFS_IOC_SETXFLAGS	_IOW('f', 2, long)
-#define XFS_IOC_GETVERSION	_IOR('v', 1, long)
+#define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
+#define XFS_IOC_SETXFLAGS	FS_IOC_SETFLAGS
+#define XFS_IOC_GETVERSION	FS_IOC_GETVERSION
+/* 32-bit compat counterparts */
+#define XFS_IOC32_GETXFLAGS	FS_IOC32_GETFLAGS
+#define XFS_IOC32_SETXFLAGS	FS_IOC32_SETFLAGS
+#define XFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
 
 /*

  * ioctl commands that replace IRIX fcntl()'s
