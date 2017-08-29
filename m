Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40488 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751906AbdH2XvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:05 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002eA-H5
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005XN-Fd
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 42/42] mkfs: tidy up definitions
Date: Wed, 30 Aug 2017 09:50:52 +1000
Message-Id: <20170829235052.21050-43-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Put all the internal macro definitions at the top of the file so
they can be easily found and remove teh ones that aren't used
anymore.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c01dc11882d9..bec12d473099 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -22,6 +22,23 @@
 #include "libxcmd.h"
 
 
+
+#define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
+#define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
+#define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
+
+/*
+ * Use this macro before we have superblock and mount structure to
+ * convert from basic blocks to filesystem blocks.
+ */
+#define	DTOBT(d, bl)	((xfs_rfsblock_t)((d) >> ((bl) - BBSHIFT)))
+
+/*
+ * amount (in bytes) we zero at the beginning and end of the device to
+ * remove traces of other filesystems, raid superblocks, etc.
+ */
+#define WHACK_SIZE (128 * 1024)
+
 /*
  * XXX: The configured block and sector sizes are defined as global variables so
  * that they don't need to be passed to getnum/cvtnum().
@@ -862,30 +879,6 @@ struct mkfs_default_params {
 	struct fsxattr		fsx;
 };
 
-#define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
-#define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
-#define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
-
-/*
- * Use this macro before we have superblock and mount structure
- */
-#define	DTOBT(d, bl)	((xfs_rfsblock_t)((d) >> ((bl) - BBSHIFT)))
-
-/*
- * Use this for block reservations needed for mkfs's conditions
- * (basically no fragmentation).
- */
-#define	MKFS_BLOCKRES_INODE	\
-	((uint)(mp->m_ialloc_blks + (mp->m_in_maxlevels - 1)))
-#define	MKFS_BLOCKRES(rb)	\
-	((uint)(MKFS_BLOCKRES_INODE + XFS_DA_NODE_MAXDEPTH + \
-	(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1) + (rb)))
-
-/* amount (in bytes) we zero at the beginning and end of the device to
- * remove traces of other filesystems, raid superblocks, etc.
- */
-#define WHACK_SIZE (128 * 1024)
-
 static void __attribute__((noreturn))
 usage( void )
 {
-- 
2.13.3

