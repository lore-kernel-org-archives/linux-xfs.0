Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A53B480DB
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:43:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6CC5F304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uqgS4PcUj0h7spkS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:39 -0700 (PDT)
Subject: [PATCH 122/145] man: document the inode cowextsize flags & fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:43:33 -0700
Message-ID: <146612781384.16048.1828413487089680067.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Document the new copy-on-write extent size fields and inode flags
available in struct fsxattr.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index ef6c992..77506aa 100644
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
@@ -240,6 +249,15 @@ and
 .BR XFS_XFLAG_DAX
 set at the same time, that is to say that DAX files cannot share blocks.
 .TP
+.SM "Bit 17 (0x20000) \- XFS_XFLAG_COWEXTSIZE"
+Copy on Write Extent size bit - if a CoW extent size value is set on the file,
+the allocator will allocate extents for staging a copy on write operation
+in multiples of the set size for this file (see
+.B XFS_IOC_FSSETXATTR
+below).
+If the CoW extent size is set on a directory, then new file and directories
+created in the directory will inherit the parent's CoW extent size value.
+.TP
 .SM "Bit 31 (0x80000000) \- XFS_XFLAG_HASATTR"
 The file has extended attributes associated with it.
 .RE
@@ -261,7 +279,8 @@ The final argument points to a variable of type
 .BR "struct fsxattr" ,
 but only the following fields are used in this call:
 .BR fsx_xflags ,
-.B fsx_extsize
+.BR fsx_extsize ,
+.BR fsx_cowextsize ,
 and
 .BR fsx_projid .
 The
@@ -271,6 +290,9 @@ when the file is empty, except in the case of a directory where
 the extent size can be set at any time (this value is only used
 for regular file allocations, so should only be set on a directory
 in conjunction with the XFS_XFLAG_EXTSZINHERIT flag).
+The copy on write extent size,
+.BR fsx_cowextsize ,
+can be set at any time.
 
 .TP
 .B XFS_IOC_GETBMAP

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
