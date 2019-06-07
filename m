Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT3h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:29:37 -0400
Subject: [PATCH 5/9] libxfs: break out the INUMBERS manpage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Jun 2019 12:29:32 -0700
Message-ID: <155993577237.2343530.1326868231083603392.stgit@magnolia>
In-Reply-To: <155993574034.2343530.12919951702156931143.stgit@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate manual page for the INUMBERS ioctl so we can document
how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_fsinumbers.2 |  115 +++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3               |   34 +-----------
 2 files changed, 119 insertions(+), 30 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fsinumbers.2


diff --git a/man/man2/ioctl_xfs_fsinumbers.2 b/man/man2/ioctl_xfs_fsinumbers.2
new file mode 100644
index 00000000..86cdf4d9
--- /dev/null
+++ b/man/man2/ioctl_xfs_fsinumbers.2
@@ -0,0 +1,115 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-FSINUMBERS 2 2019-04-16 "XFS"
+.SH NAME
+ioctl_xfs_fsinumbers \- extract a list of valid inode numbers from an XFS filesystem
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_FSINUMBERS, struct xfs_fsop_bulkreq *" arg );
+.SH DESCRIPTION
+Query a list of valid inode numbers from an XFS filesystem.
+It is intended to be called iteratively to obtain the entire set of inodes.
+These ioctls use
+.B struct xfs_fsop_bulkreq
+to set up a bulk transfer with the kernel:
+.PP
+.in +4n
+.nf
+struct xfs_fsop_bulkreq {
+	__u64   *lastip;
+	__s32   count;
+	void    *ubuffer;
+	__s32   *ocount;
+};
+.fi
+.in
+.PP
+.I lastip
+points to a value that will receive the number of the "last inode".
+This should be set to one less than the number of the first inode for which the
+caller wants information, or zero to start with the first inode in the
+filesystem.
+After the call, this value will be set to the number of the last inode for
+which information is supplied.
+This field will not be updated if
+.I ocount
+is NULL.
+.PP
+.I count
+is the number of inodes to examine.
+.PP
+.I ocount
+points to a value that will receive the number of records returned.
+An output value of zero means that there are no more inodes left to enumerate.
+If this value is NULL, then neither
+.I ocount
+nor
+.I lastip
+will be updated.
+.PP
+.I ubuffer
+points to a memory buffer where information will be copied.
+This buffer must be an array of
+.B struct xfs_inogrp
+which is described below.
+The array must have at least
+.I count
+elements.
+.PP
+.in +4n
+.nf
+struct xfs_inogrp {
+	__u64   xi_startino;
+	__s32   xi_alloccount;
+	__u64   xi_allocmask;
+}
+.fi
+.in
+.PP
+.I xi_startino
+is the number of this inode numbers record.
+Each inode numbers record will correspond roughly to a record in the inode
+btree, though this is not guaranteed.
+.PP
+.I xi_alloccount
+is the number of bits that are set in
+.IR xi_allocmask .
+.PP
+.I xi_allocmask
+is the mask of inodes that are in use for this inode.
+The bitmask is 64 bits long, and the least significant bit corresponds to inode
+.BR xi_startino .
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFAULT
+The kernel was not able to copy into the userspace buffer.
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+One of the arguments was not valid.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B ENOMEM
+There was insufficient memory to perform the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index cdf0fcfc..148119a9 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -368,36 +368,9 @@ can be any open file in the XFS filesystem in question.
 .PP
 .TP
 .B XFS_IOC_FSINUMBERS
-This interface is used to extract a list of valid inode numbers from an
-XFS filesystem.
-It is intended to be called iteratively, to obtain the entire set of inodes.
-The information is passed in and out via a structure of type
-.B xfs_fsop_bulkreq_t
-pointed to by the final argument.
-.B lastip
-is a pointer to a variable containing the last inode number returned,
-initially it should be zero.
-.B icount
-is the size of the array of structures specified by
-.BR ubuffer .
-.B ubuffer
-is the address of an array of structures, of type
-.BR xfs_inogrp_t .
-This structure has the following elements:
-.B xi_startino
-(starting inode number),
-.B xi_alloccount
-(count of bits set in xi_allocmask), and
-.B xi_allocmask
-(mask of allocated inodes in this group).
-The bitmask is 64 bits long, and the least significant bit corresponds to inode
-.B xi_startino.
-Each bit is set if the corresponding inode is in use.
-.B ocount
-is a pointer to a count of returned values, filled in by the call.
-An output
-.B ocount
-value of zero means that the inode table has been exhausted.
+See
+.BR ioctl_xfs_fsinumbers (2)
+for more information.
 
 .TP
 .B XFS_IOC_FSGEOMETRY
@@ -442,6 +415,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_fsgetxattr (2),
 .BR ioctl_xfs_fsop_geometry (2),
 .BR ioctl_xfs_fsbulkstat (2),
+.BR ioctl_xfs_fsinumbers (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),
