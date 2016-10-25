Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46575 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcJYXGR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:06:17 -0400
Subject: [PATCH 25/39] man: document the inode cowextsize flags & fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:06:14 -0700
Message-ID: <147743677455.11035.16363741138480682509.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Document the new copy-on-write extent size fields and inode flags
available in struct fsxattr.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 9e7f138..6e5027c 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -150,6 +150,15 @@ value returned indicates that a preferred extent size was previously
 set on the file, a
 .B fsx_extsize
 of zero indicates that the defaults for that filesystem will be used.
+A
+.B fsx_cowextsize
+value returned indicates that a preferred copy on write extent size was
+previously set on the file, whereas a
+.B fsx_cowextsize
+of zero indicates that the defaults for that filesystem will be used.
+The current default for
+.B fsx_cowextsize
+is 128 blocks.
 Currently the meaningful bits for the
 .B fsx_xflags
 field are:
@@ -229,6 +238,19 @@ created and written into the directory.
 If the filesystem lives on directly accessible persistent memory, reads and
 writes to this file will go straight to the persistent memory, bypassing the
 page cache.
+A file cannot be reflinked and have the
+.BR XFS_XFLAG_DAX
+set at the same time.
+That is to say that DAX files cannot share blocks.
+.TP
+.SM "Bit 16 (0x10000) \- XFS_XFLAG_COWEXTSIZE"
+Copy on Write Extent size bit - if a CoW extent size value is set on the file,
+the allocator will allocate extents for staging a copy on write operation
+in multiples of the set size for this file (see
+.B XFS_IOC_FSSETXATTR
+below).
+If the CoW extent size is set on a directory, then new file and directories
+created in the directory will inherit the parent's CoW extent size value.
 .TP
 .SM "Bit 31 (0x80000000) \- XFS_XFLAG_HASATTR"
 The file has extended attributes associated with it.
@@ -251,7 +273,8 @@ The final argument points to a variable of type
 .BR "struct fsxattr" ,
 but only the following fields are used in this call:
 .BR fsx_xflags ,
-.B fsx_extsize
+.BR fsx_extsize ,
+.BR fsx_cowextsize ,
 and
 .BR fsx_projid .
 The
@@ -261,6 +284,9 @@ when the file is empty, except in the case of a directory where
 the extent size can be set at any time (this value is only used
 for regular file allocations, so should only be set on a directory
 in conjunction with the XFS_XFLAG_EXTSZINHERIT flag).
+The copy on write extent size,
+.BR fsx_cowextsize ,
+can be set at any time.
 
 .TP
 .B XFS_IOC_GETBMAP

