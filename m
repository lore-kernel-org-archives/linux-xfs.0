Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 10:36:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8HHa3uw029764
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 10:36:04 -0700
Message-ID: <46EEBB02.9050507@sandeen.net>
Date: Mon, 17 Sep 2007 12:36:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS, GETVERSION
References: <46EDDCA7.5030601@sandeen.net>
In-Reply-To: <46EDDCA7.5030601@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

(With rh bug info and attribution for the bug-finder)

---------

In Red Hat bugzilla #291981, Sami Farin notes that 32-bit-compat
lsattr/chattr does not work on xfs.  After investigation, I found:

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
