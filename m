Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([54.37.238.230]:40416 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbeJET0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 15:26:20 -0400
From: Adam Borowski <kilobyte@angband.pl>
Date: Fri,  5 Oct 2018 14:27:41 +0200
Message-Id: <20181005122741.5100-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH] xfs: move the define for superblock magic to uapi
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>

Needed by users of fstatfs().

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 include/uapi/linux/magic.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 059bc44c27e8..837863c57e8c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -14,6 +14,7 @@
  * xfs_da_format.h, which log and log item formats are defined in
  * xfs_log_format.h. Everything else goes here.
  */
+#include <linux/magic.h>
 
 struct xfs_mount;
 struct xfs_trans;
@@ -26,7 +27,7 @@ struct xfs_ifork;
  * Fits into a sector-sized buffer at address 0 of each allocation group.
  * Only the first of these is ever updated except during growfs.
  */
-#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
+#define	XFS_SB_MAGIC		XFS_SUPER_MAGIC /* 0x58465342 = 'XFSB' */
 #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
 #define	XFS_SB_VERSION_2	2		/* 6.2 - attributes */
 #define	XFS_SB_VERSION_3	3		/* 6.2 - new inode version */
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 1a6fee974116..96c24478d8ce 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -29,6 +29,7 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
+#define XFS_SUPER_MAGIC		0x58465342	/* "XFSB" */
 #define PSTOREFS_MAGIC		0x6165676C
 #define EFIVARFS_MAGIC		0xde5e81e4
 #define HOSTFS_SUPER_MAGIC	0x00c0ffee
-- 
2.19.0
