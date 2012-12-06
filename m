Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB656hun087121 for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 23:06:43 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id eVprUXEtBEwWMJEr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Dec 2012 21:09:05 -0800 (PST)
Subject: Bug#694624: freezes under lying (root) - patch
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B694624.13547703441505@bugs.debian.org>
Message-ID: <50C0258F.6070409@talbragar.com.au>
Date: Thu, 06 Dec 2012 15:56:47 +1100
From: Pat Emblen <talcom@talbragar.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080409060607080403090003"
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
--------------080409060607080403090003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A patch for the man page is (hopefully) attached. I'll warn you that 
this is the first time I've edited a man page or generated a patch, so 
it could be wrong / incomplete.
By the way, I think you may have misinterpreted my tone in previous 
comments, I was trying to make a strong case for the program working in 
the way I expected it to from reading the man page, not trying to tell 
you how it should work in general. Having said that I still personally 
consider a 'safety catch' on the root filesystem would be a good idea.
Thanks,
Pat


--------------080409060607080403090003
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
@@ -1,16 +1,17 @@
 .TH xfs_freeze 8
 .SH NAME
-xfs_freeze \- suspend access to an XFS filesystem
+xfs_freeze \- suspend access to a freezable filesystem
 .SH SYNOPSIS
 .B xfs_freeze \-f
 |
 .B \-u
-.I mount-point
-.fi
-.SH DESCRIPTION
-.B xfs_freeze
-suspends and resumes access to an XFS filesystem (see
-.BR xfs (5)).
+.I path.fi
+.SH DESCRIPTION.B xfs_freezesuspends and resumes access to compatible filesystems.
+The command was originaly specific to the XFS filesystem (see
+.BR xfs (5))but since Linux kernel version 2.6.29, the interface which
+XFS uses to freeze and unfreeze has been elevated to the VFS, so that
+this tool can now be used on many other Linux filesystems.
+The root filesystem is not treated in any special way and may also be frozen.
 .PP
 .B xfs_freeze
 halts new access to the filesystem and creates a stable image on disk.
@@ -19,15 +20,14 @@
 that support the creation of snapshots.
 .PP
 The
-.I mount-point
-argument is the pathname of the directory where the filesystem
-is mounted.
-The filesystem must be mounted to be frozen (see
-.BR mount (8)).
+.I path
+argument is the path to any directory within the mounted filesystem up to and including
+the
+.I mount-point.
 .PP
 The
 .B \-f
-flag requests the specified XFS filesystem to be
+flag requests the specified filesystem to be
 frozen from new modifications.
 When this is selected, all ongoing transactions in the filesystem
 are allowed to complete, new write system calls are halted, other
@@ -55,16 +55,23 @@
 must be supplied to
 .BR xfs_freeze .
 .SH NOTES
-A copy of a frozen XFS filesystem will usually have the same universally
+.BR xfs_freeze
+treats the root filesystem the same as any other filesystem.
+Take great care to verify that the path you specify contains the filesystem
+you intend to freeze and is not for example, an empty mount-point.
+If you inadvertently freeze the root filesystem you should immediately
+unfreeze it with the
+.B \-u
+option. If you attempt any action that tries to write to the frozen filesystem
+your shell can be blocked waiting for the write and in most cases you will
+not be able to open another shell to run the unfreeze command.
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

--------------080409060607080403090003
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------080409060607080403090003--
