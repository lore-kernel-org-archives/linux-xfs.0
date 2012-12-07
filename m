Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7EOfJM226999 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 08:24:41 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id I5KhmXc8XFIUT0MU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 06:27:04 -0800 (PST)
Subject: Bug#694624: PATCH freezes under lying (root)
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B694624.135489030815926@bugs.debian.org>
Message-ID: <50C1FC30.5000708@talbragar.com.au>
Date: Sat, 08 Dec 2012 01:24:48 +1100
From: Pat Emblen <talcom@talbragar.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040909070105090300080902"
Reply-To: Pat Emblen <talcom@talbragar.com.au>, 694624@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: 694624@bugs.debian.org

This is a multi-part message in MIME format.
--------------040909070105090300080902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, here's version 2.
I read the kernel patch info , but I'm mostly running off 
http://www.debian.org/doc/manuals/maint-guide/modify.en.html
Thanks for your help.

Pat



--------------040909070105090300080902
Content-Type: text/x-patch;
 name="update-man-xfs_freeze.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="update-man-xfs_freeze.patch"

Description: Updates to the man page to more accurately describe the
 behaviour of the program.
Forwarded: not-needed
Bug-Debian: http://bugs.debian.org/694624
Author: Patrick Emblen <support@talbragar.com.au>
--- a/man/man8/xfs_freeze.8
+++ b/man/man8/xfs_freeze.8
@@ -1,16 +1,16 @@
 .TH xfs_freeze 8
 .SH NAME
-xfs_freeze \- suspend access to an XFS filesystem
+xfs_freeze \- suspend access to a freezable filesystem
 .SH SYNOPSIS
 .B xfs_freeze \-f
 |
 .B \-u
-.I mount-point
+.I path
 .fi
 .SH DESCRIPTION
 .B xfs_freeze
-suspends and resumes access to an XFS filesystem (see
-.BR xfs (5)).
+suspends and resumes access to compatible filesystems.
+The root filesystem is not treated in any special way and may also be frozen.
 .PP
 .B xfs_freeze
 halts new access to the filesystem and creates a stable image on disk.
@@ -19,15 +19,12 @@
 that support the creation of snapshots.
 .PP
 The
-.I mount-point
-argument is the pathname of the directory where the filesystem
-is mounted.
-The filesystem must be mounted to be frozen (see
-.BR mount (8)).
+.I path
+argument is the path to any directory within the mounted filesystem.
 .PP
 The
 .B \-f
-flag requests the specified XFS filesystem to be
+flag requests the specified filesystem to be
 frozen from new modifications.
 When this is selected, all ongoing transactions in the filesystem
 are allowed to complete, new write system calls are halted, other
@@ -55,16 +52,26 @@
 must be supplied to
 .BR xfs_freeze .
 .SH NOTES
-A copy of a frozen XFS filesystem will usually have the same universally
+The command was originally specific to the XFS filesystem (see
+.BR
+xfs (5))but since Linux kernel version 2.6.29, the interface which
+XFS uses to freeze and unfreeze has been elevated to the VFS, so that
+this tool can now be used on many other Linux filesystems.
+.PP
+.BR xfs_freeze
+treats the root filesystem the same as any other filesystem.
+.B
+Take great care to verify that the path you specify contains the filesystem
+.B
+you intend to freeze and is not for example, an empty mount-point.
+It is usually impossible to logon to a system with a frozen root.
+.PP
+A copy of a frozen filesystem will usually have the same universally
 unique identifier (UUID) as the original, and thus may be prevented from
 being mounted.
-The XFS
+For XFS filesystems, the
 .B nouuid
 mount option can be used to circumvent this issue.
-.PP
-In Linux kernel version 2.6.29, the interface which XFS uses to freeze
-and unfreeze was elevated to the VFS, so that this tool can now be
-used on many other Linux filesystems.
 .SH SEE ALSO
 .BR xfs (5),
 .BR lvm (8),

--------------040909070105090300080902
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------040909070105090300080902--
