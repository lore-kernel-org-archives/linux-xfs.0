Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFTQvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:42 -0400
Subject: [PATCH 7/9] man: create a separate RESBLKS ioctl manpage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 09:51:36 -0700
Message-ID: <156104949681.1174403.3533354992259074908.stgit@magnolia>
In-Reply-To: <156104944877.1174403.14568482035189263260.stgit@magnolia>
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate manual page for the xfs RESBLKS ioctls so we can
document how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_getresblks.2 |   65 +++++++++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_setresblks.2 |    1 +
 man/man3/xfsctl.3               |   14 +++++++-
 3 files changed, 78 insertions(+), 2 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_getresblks.2
 create mode 100644 man/man2/ioctl_xfs_setresblks.2


diff --git a/man/man2/ioctl_xfs_getresblks.2 b/man/man2/ioctl_xfs_getresblks.2
new file mode 100644
index 00000000..694b4496
--- /dev/null
+++ b/man/man2/ioctl_xfs_getresblks.2
@@ -0,0 +1,65 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-GETRESBLKS 2 2019-06-17 "XFS"
+.SH NAME
+ioctl_xfs_getresblks \- query XFS summary counter information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GET_RESBLKS, struct xfs_fsop_resblks *" arg );
+.br
+.BI "int ioctl(int " fd ", XFS_IOC_SET_RESBLKS, struct xfs_fsop_resblks *" arg );
+.SH DESCRIPTION
+Query or set the free space reservation information.
+These blocks are reserved by the filesystem as a final attempt to prevent
+metadata update failures due to insufficient space.
+Only the system administrator can call these ioctls, because overriding the
+defaults is extremely dangerous and should never be tried by anyone.
+.PP
+The reservation information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_fsop_resblks {
+	__u64  resblks;
+	__u64  resblks_avail;
+};
+.fi
+.in
+.PP
+.I resblks
+is the number of blocks that the filesystem will try to maintain to prevent
+critical out of space situations.
+.PP
+.I resblks_avail
+is the number of reserved blocks remaining.
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+The specified allocation group number is not valid for this filesystem.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B EPERM
+Caller does not have permission to call this ioctl.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man2/ioctl_xfs_setresblks.2 b/man/man2/ioctl_xfs_setresblks.2
new file mode 100644
index 00000000..209bc0a8
--- /dev/null
+++ b/man/man2/ioctl_xfs_setresblks.2
@@ -0,0 +1 @@
+.so man2/ioctl_xfs_getresblks.2
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index ee3188ec..89975a3c 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -396,12 +396,21 @@ See
 .BR ioctl_xfs_fscounts (2)
 for more information.
 
+.TP
+.nf
+.B XFS_IOC_GET_RESBLKS
+.fi
+.TP
+.B XFS_IOC_SET_RESBLKS
+See
+.BR ioctl_xfs_getresblks (2)
+for more information.
+Save yourself a lot of frustration and avoid these ioctls.
+
 .PP
 .nf
 .B XFS_IOC_THAW
 .B XFS_IOC_FREEZE
-.B XFS_IOC_GET_RESBLKS
-.B XFS_IOC_SET_RESBLKS
 .B XFS_IOC_FSGROWFSDATA
 .B XFS_IOC_FSGROWFSLOG
 .fi
@@ -419,6 +428,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_scrub_metadata (2),
 .BR ioctl_xfs_fsinumbers (2),
 .BR ioctl_xfs_fscounts (2),
+.BR ioctl_xfs_getresblks (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),
