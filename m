Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46112 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbcJYXEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:05 -0400
Subject: [PATCH 03/39] xfs: define the on-disk refcount btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:03:56 -0700
Message-ID: <147743663655.11035.6044942751505512619.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Start constructing the refcount btree implementation by establishing
the on-disk format and everything needed to read, write, and
manipulate the refcount btree blocks.

[Initialize the in-core mount context.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: allocate the cursor with KM_NOFS to quiet lockdep]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
v2: Calculate a separate maxlevels for the refcount btree.

v3: Enable the tracking of per-cursor stats for refcount btrees.
The refcount update code will use this to guess if it's time to
split a refcountbt update across two transactions to avoid
exhausing the transaction reservation.

xfs_refcountbt_init_cursor can be called under the ilock, so
use KM_NOFS to prevent fs activity with a lock held.  This
should shut up some of the lockdep warnings.
---
 include/libxfs.h |    1 +
 libxfs/init.c    |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index cf59d6c..ec8f6ab 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -79,6 +79,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount_btree.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/init.c b/libxfs/init.c
index 828ae3e..c962d3e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -32,6 +32,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount_btree.h"
 
 #include "libxfs.h"		/* for now */
 
@@ -689,6 +690,7 @@ libxfs_mount(
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_ialloc_compute_maxlevels(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_refcountbt_compute_maxlevels(mp);
 
 	if (sbp->sb_imax_pct) {
 		/* Make sure the maximum inode count is a multiple of the

