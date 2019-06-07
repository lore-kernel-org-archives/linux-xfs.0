Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:29:30 -0400
Subject: [PATCH 4/9] libxfs: link to the scrub ioctl from xfsctl.3
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Jun 2019 12:29:26 -0700
Message-ID: <155993576618.2343530.17591105410246159765.stgit@magnolia>
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

Link to the scrub ioctl documentation from xfsctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 94a6ad4b..cdf0fcfc 100644
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
