Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 22:47:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l565lAWt019909
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 22:47:12 -0700
Message-ID: <46664AE7.7070600@sgi.com>
Date: Wed, 06 Jun 2007 15:49:27 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: [REVIEW 2/2] - setting realtime and extent size hint flags via fcntl(XFS_IOC_FSSETXATTR)
Content-Type: multipart/mixed;
 boundary="------------050606040702010003040602"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------050606040702010003040602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch updates the xfsctl(XFS_IOC_FSSETXATTR) and 
xfsctl(XFS_IOC_RESVSP64)
man page.

Regards,
Vlad

--------------050606040702010003040602
Content-Type: text/plain;
 name*0="update_XFS_IOC_FSSETXATTR_and_XFS_IOC_RESVSP64_xfsctl_man_page"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="update_XFS_IOC_FSSETXATTR_and_XFS_IOC_RESVSP64_xfsctl_man_pa";
 filename*1="ge"

Index: xfs-cmds/xfsprogs/man/man3/xfsctl.3
===================================================================
--- xfs-cmds.orig/xfsprogs/man/man3/xfsctl.3
+++ xfs-cmds/xfsprogs/man/man3/xfsctl.3
@@ -251,11 +251,17 @@ and
 .BR fsx_extsize .
 The
 .B fsx_xflags
-realtime file bit and the file's extent size may be changed only
+realtime file bit
+.B XFS_XFLAG_REALTIME,
+extent hint bit
+.B XFS_XFLAG_EXTSIZE
+and the file's extent size may be changed only
 when the file is empty, except in the case of a directory where
 the extent size can be set at any time (this value is only used
 for regular file allocations, so should only be set on a directory
 in conjunction with the XFS_XFLAG_EXTSZINHERIT flag).
+The extent size has to be aligned to the filesystem block size or
+when the XFS_XFLAG_REALTIME flag is set to the realtime extent size.
 
 .TP
 .B XFS_IOC_GETBMAP
@@ -325,7 +331,15 @@ The blocks are allocated, but not zeroed
 If the XFS filesystem is configured to flag unwritten file extents,
 performance will be negatively affected when writing to preallocated space,
 since extra filesystem transactions are required to convert extent flags on
-the range of the file written.
+the range of the file written. The
+.B l_len
+field is rounded to the filesystem block size.
+For realtime files the
+.B l_len
+field is rounded to the realtime extent size. If the extent hint is set, the
+.B l_len
+is rounded to the extent hint size.
+
 If
 .IR xfs_info (8)
 reports unwritten=1, then the filesystem was made to flag unwritten extents.

--------------050606040702010003040602--
