Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:39 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/20] xfs: merge xfs_bud_init into xfs_trans_get_bud
Date: Thu, 13 Jun 2019 20:02:56 +0200
Message-Id: <20190613180300.30447-17-hch@lst.de>
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

There is no good reason to keep these two functions separate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_item.c  | 14 ++++++--------
 fs/xfs/xfs_bmap_item.h  |  2 --
 fs/xfs/xfs_trans_bmap.c | 16 ----------------
 3 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e20ec733c8ae..341b1e231178 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -212,22 +212,20 @@ static const struct xfs_item_ops xfs_bud_item_ops = {
 	.iop_release	= xfs_bud_item_release,
 };
 
-/*
- * Allocate and initialize an bud item with the given number of extents.
- */
 struct xfs_bud_log_item *
-xfs_bud_init(
-	struct xfs_mount		*mp,
+xfs_trans_get_bud(
+	struct xfs_trans		*tp,
 	struct xfs_bui_log_item		*buip)
-
 {
-	struct xfs_bud_log_item	*budp;
+	struct xfs_bud_log_item		*budp;
 
 	budp = kmem_zone_zalloc(xfs_bud_zone, KM_SLEEP);
-	xfs_log_item_init(mp, &budp->bud_item, XFS_LI_BUD, &xfs_bud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
+			  &xfs_bud_item_ops);
 	budp->bud_buip = buip;
 	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
 
+	xfs_trans_add_item(tp, &budp->bud_item);
 	return budp;
 }
 
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 89e043a88bb8..ad479cc73de8 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -75,8 +75,6 @@ extern struct kmem_zone	*xfs_bui_zone;
 extern struct kmem_zone	*xfs_bud_zone;
 
 struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
-struct xfs_bud_log_item *xfs_bud_init(struct xfs_mount *,
-		struct xfs_bui_log_item *);
 void xfs_bui_item_free(struct xfs_bui_log_item *);
 void xfs_bui_release(struct xfs_bui_log_item *);
 int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index e1c7d55b32c3..c6f5b217d17c 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -18,22 +18,6 @@
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
 
-/*
- * This routine is called to allocate a "bmap update done"
- * log item.
- */
-struct xfs_bud_log_item *
-xfs_trans_get_bud(
-	struct xfs_trans		*tp,
-	struct xfs_bui_log_item		*buip)
-{
-	struct xfs_bud_log_item		*budp;
-
-	budp = xfs_bud_init(tp->t_mountp, buip);
-	xfs_trans_add_item(tp, &budp->bud_item);
-	return budp;
-}
-
 /*
  * Finish an bmap update and log it to the BUD. Note that the
  * transaction is marked dirty regardless of whether the bmap update
-- 
2.20.1
