Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752298AbdLLOVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 09:21:17 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBCEKOd6011524
        for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2017 09:21:17 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ete6v7j99-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2017 09:21:15 -0500
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Tue, 12 Dec 2017 14:21:13 -0000
Subject: [PATCH] xfs: include the XFS magic number in magic.h
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Tue, 12 Dec 2017 09:21:09 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1513088469.3476.48.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

Move the XFS_SB_MAGIC definition to magic.h.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 include/uapi/linux/magic.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1acb584fc5f7..05f7d83e5f88 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_FORMAT_H__
 #define __XFS_FORMAT_H__
 
+#include <linux/magic.h>
+
 /*
  * XFS On Disk Format Definitions
  *
@@ -38,7 +40,6 @@ struct xfs_ifork;
  * Fits into a sector-sized buffer at address 0 of each allocation group.
  * Only the first of these is ever updated except during growfs.
  */
-#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
 #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
 #define	XFS_SB_VERSION_2	2		/* 6.2 - attributes */
 #define	XFS_SB_VERSION_3	3		/* 6.2 - new inode version */
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 1a6fee974116..f6a641826e79 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -67,6 +67,7 @@
 #define TRACEFS_MAGIC          0x74726163
 
 #define V9FS_MAGIC		0x01021997
+#define XFS_SB_MAGIC		0x58465342
 
 #define BDEVFS_MAGIC            0x62646576
 #define DAXFS_MAGIC             0x64646178
-- 
2.7.4

