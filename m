Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42085 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935036AbcI3DHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:07:19 -0400
Subject: [PATCH 15/63] xfs: adjust refcount when unmapping file blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:07:13 -0700
Message-ID: <147520483350.29434.7868883592419394843.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When we're unmapping blocks from a reflinked file, decrease the
refcount of the affected blocks and free the extents that are no
longer in use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Use deferred ops system to avoid deadlocks and running out of
transaction reservation.
---
 fs/xfs/libxfs/xfs_bmap.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9d7f61d..907d7b8d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -48,6 +48,7 @@
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
+#include "xfs_refcount.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -4988,9 +4989,16 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx)
-		xfs_bmap_add_free(mp, dfops, del->br_startblock,
-				del->br_blockcount, NULL);
+	if (do_fx) {
+		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
+			error = xfs_refcount_decrease_extent(mp, dfops, del);
+			if (error)
+				goto done;
+		} else
+			xfs_bmap_add_free(mp, dfops, del->br_startblock,
+					del->br_blockcount, NULL);
+	}
+
 	/*
 	 * Adjust inode # blocks in the file.
 	 */

