Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:49941 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727782AbfFMK02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 06:26:28 -0400
From: Alvin@linux.alibaba.com
Subject: [PATCH] Fix the inconsistency between the code and the manual page of mkfs.xfs.
Date: Thu, 13 Jun 2019 18:26:20 +0800
Message-Id: <1560421580-22920-1-git-send-email-Alvin@linux.alibaba.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, sandeen@redhat.com
Cc: caspar@linux.alibaba.com, Alvin Zheng <Alvin@linux.alibaba.com>

From: Alvin Zheng <Alvin@linux.alibaba.com>

Signed-off-by: Alvin Zheng <Alvin@linux.alibaba.com>
---
 man/man8/mkfs.xfs.8 | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b8c78c..bf2ad54 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -115,9 +115,12 @@ When specifying parameters in units of sectors or filesystem blocks, the
 .B \-s
 option or the
 .B \-b
-option first needs to be added to the command line.
-Failure to specify the size of the units will result in illegal value errors
-when parameters are quantified in those units.
+option can be used to specify the size of the sector or block. The 
+.B \-s
+option and the
+.B \-b
+should be placed before any options in units of sectors or blocks. If the size of the block
+or sector is not specified, the default size (block: 4KiB, sector: 512B) will be used.
 .PP
 Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
@@ -136,9 +139,10 @@ The filesystem block size is specified with a
 in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and the
 maximum is 65536 (64 KiB).
 .IP
-To specify any options on the command line in units of filesystem blocks, this
-option must be specified first so that the filesystem block size is
-applied consistently to all options.
+If a non-default filesystem block size is specified, the option
+must be specified before any options that use filesystem block size
+units so that the non-default filesystem block size is applied
+consistently to all options.
 .IP
 Although
 .B mkfs.xfs
@@ -895,9 +899,10 @@ is 512 bytes. The minimum value for sector size is
 must be a power of 2 size and cannot be made larger than the
 filesystem block size.
 .IP
-To specify any options on the command line in units of sectors, this
-option must be specified first so that the sector size is
-applied consistently to all options.
+If a non-default sector size is specified, the option
+must be specified before any options that use sector size
+units so that the non-default sector size is applied
+consistently to all options.
 .RE
 .TP
 .BI \-L " label"
-- 
1.8.3.1
