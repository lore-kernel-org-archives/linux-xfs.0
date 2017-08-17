Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbdHQHjW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 03:39:22 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] xfsprogs: add sectsize/sectlog to the man page
Date: Thu, 17 Aug 2017 09:38:44 +0200
Message-Id: <20170817073844.1351-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, Jan Tulak <jtulak@redhat.com>

The man page is missing description of these options.
Add it.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 man/man8/mkfs.xfs.8 | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index b2bc223b..8ee64660 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -297,6 +297,24 @@ suboption is used only to make a filesystem image. If the
 .I value
 is omitted then 1 is assumed.
 .TP
+.BI sectsize= value
+This is used to specify the sector size for data section. The size is specified
+as a value in bytes. The minimum value is 512 bytes; the maximum is 32768
+(32 KiB). The sector size must be a power of 2 and cannot be made larger than
+the filesystem block size. The default size is 512 bytes. This option is
+mutually exclusive with
+.B \-d sectlog
+option.
+.TP
+.BI sectlog= value
+This is used to specify the sector size for data section. The size is specified
+as a base two logarithm. The minimum value is 512 bytes; the maximum is 32768
+(32 KiB). The sector size must be a power of 2 and cannot be made larger than
+the filesystem block size. The default size is 512 bytes. This option is
+mutually exclusive with
+.B \-d sectsize
+option.
+.TP
 .BI size= value
 This is used to specify the size of the data section. This suboption
 is required if
-- 
2.13.3

