Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:18 -0400
Subject: [PATCH 4/9] man: link to the SCRUB_METADATA ioctl manpage from
 xfsctl.3
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 09:51:13 -0700
Message-ID: <156104947386.1174403.3374265373047115552.stgit@magnolia>
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

Link to the scrub ioctl documentation from xfsctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 94a6ad4b..78fad975 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -411,6 +411,12 @@ See
 .BR ioctl_xfs_fsbulkstat (2)
 for more information.
 
+.TP
+.B XFS_IOC_SCRUB_METADATA
+See
+.BR ioctl_xfs_scrub_metadata (2)
+for more information.
+
 .PP
 .nf
 .B XFS_IOC_THAW
@@ -436,6 +442,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_fsgetxattr (2),
 .BR ioctl_xfs_fsop_geometry (2),
 .BR ioctl_xfs_fsbulkstat (2),
+.BR ioctl_xfs_scrub_metadata (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),
