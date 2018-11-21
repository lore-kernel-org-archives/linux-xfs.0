Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7031 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390411AbeKVJge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 04:36:34 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0003ni-FH
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0008FI-Dv
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: make iomap type tracing work
Date: Thu, 22 Nov 2018 09:59:56 +1100
Message-Id: <20181121225958.30947-2-david@fromorbit.com>
In-Reply-To: <20181121225958.30947-1-david@fromorbit.com>
References: <20181121225958.30947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

__print_symbolic does crazy things and stringifies the tables
that are used to map values to strings. Hence if we use enums
for the values, it just doesn't work because XFS_IO_COW != 3,
it's a string.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 494b4338446e..810ad0362431 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -11,13 +11,11 @@ extern struct bio_set xfs_ioend_bioset;
 /*
  * Types of I/O for bmap clustering and I/O completion tracking.
  */
-enum {
-	XFS_IO_HOLE,		/* covers region without any block allocation */
-	XFS_IO_DELALLOC,	/* covers delalloc region */
-	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
-	XFS_IO_OVERWRITE,	/* covers already allocated extent */
-	XFS_IO_COW,		/* covers copy-on-write extent */
-};
+#define XFS_IO_HOLE		0 /* covers region with no block allocation */
+#define XFS_IO_DELALLOC		1 /* covers delalloc region */
+#define XFS_IO_UNWRITTEN	2 /* covers allocated but uninitialized data */
+#define XFS_IO_OVERWRITE	3 /* covers already allocated extent */
+#define XFS_IO_COW		4 /* covers copy-on-write extent */
 
 #define XFS_IO_TYPES \
 	{ XFS_IO_HOLE,			"hole" },	\
-- 
2.19.1
