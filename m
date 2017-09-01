Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36451 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbdIAQjn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 12:39:43 -0400
Date: Fri, 1 Sep 2017 09:39:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] mkfs: add documentation for forgotten mkfs flags
Message-ID: <20170901163938.GE3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Add documentation for some undocumented mkfs -d and -l flags.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index b2bc223..33831c9 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -367,6 +367,25 @@ values.
 This option disables automatic geometry detection and creates the filesystem
 without stripe geometry alignment even if the underlying storage device provides
 this information.
+.TP
+.BI rtinherit= value
+If set, all inodes created by
+.B mkfs.xfs
+will be created with the realtime flag set.
+Directories will pass on this flag to newly created children.
+.TP
+.BI projinherit= value
+All inodes created by
+.B mkfs.xfs
+will be assigned this project quota id.
+Directories will pass on the project id to newly created children.
+.TP
+.BI extszinherit= value
+All inodes created by
+.B mkfs.xfs
+will have this extent size hint applied.
+The value must be provided in units of filesystem blocks.
+Directories will pass on this hint to newly created children.
 .RE
 .TP
 .B \-f
@@ -508,6 +527,9 @@ log section of the filesystem. The valid
 are:
 .RS 1.2i
 .TP
+.BI agnum= value
+If the log is internal, allocate it in this AG.
+.TP
 .BI internal[= value ]
 This is used to specify that the log section is a piece of the data
 section instead of being another device or logical volume. The
