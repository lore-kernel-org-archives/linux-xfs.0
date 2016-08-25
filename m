Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91B017D6C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:34:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 582DB304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:06 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hkTFxHpOOMLOFlz3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:34:04 -0700 (PDT)
Subject: [PATCH 19/71] xfs: adjust refcount when unmapping file blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:34:00 -0700
Message-ID: <147216804032.867.105965788553400078.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

When we're unmapping blocks from a reflinked file, decrease the
refcount of the affected blocks and free the extents that are no
longer in use.

v2: Use deferred ops system to avoid deadlocks and running out of
transaction reservation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 042d7bf..5e0c9ec 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -48,6 +48,7 @@
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
 #include "xfs_ag_resv.h"
+#include "xfs_refcount.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -5062,9 +5063,16 @@ xfs_bmap_del_extent(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
