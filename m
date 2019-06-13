Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:37 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/20] xfs: merge xfs_rud_init into xfs_trans_get_rud
Date: Thu, 13 Jun 2019 20:02:55 +0200
Message-Id: <20190613180300.30447-16-hch@lst.de>
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
 fs/xfs/xfs_rmap_item.c  | 14 ++++++--------
 fs/xfs/xfs_rmap_item.h  |  2 --
 fs/xfs/xfs_trans_rmap.c | 12 ------------
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c2f6acdc593d..7f903de481df 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -238,22 +238,20 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_release	= xfs_rud_item_release,
 };
 
-/*
- * Allocate and initialize an rud item with the given number of extents.
- */
 struct xfs_rud_log_item *
-xfs_rud_init(
-	struct xfs_mount		*mp,
+xfs_trans_get_rud(
+	struct xfs_trans		*tp,
 	struct xfs_rui_log_item		*ruip)
-
 {
-	struct xfs_rud_log_item	*rudp;
+	struct xfs_rud_log_item		*rudp;
 
 	rudp = kmem_zone_zalloc(xfs_rud_zone, KM_SLEEP);
-	xfs_log_item_init(mp, &rudp->rud_item, XFS_LI_RUD, &xfs_rud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
+			  &xfs_rud_item_ops);
 	rudp->rud_ruip = ruip;
 	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
 
+	xfs_trans_add_item(tp, &rudp->rud_item);
 	return rudp;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 7e482baa27f5..8708e4a5aa5c 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -78,8 +78,6 @@ extern struct kmem_zone	*xfs_rui_zone;
 extern struct kmem_zone	*xfs_rud_zone;
 
 struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
-struct xfs_rud_log_item *xfs_rud_init(struct xfs_mount *,
-		struct xfs_rui_log_item *);
 int xfs_rui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 5c7936b1be13..863e3281daaa 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -60,18 +60,6 @@ xfs_trans_set_rmap_flags(
 	}
 }
 
-struct xfs_rud_log_item *
-xfs_trans_get_rud(
-	struct xfs_trans		*tp,
-	struct xfs_rui_log_item		*ruip)
-{
-	struct xfs_rud_log_item		*rudp;
-
-	rudp = xfs_rud_init(tp->t_mountp, ruip);
-	xfs_trans_add_item(tp, &rudp->rud_item);
-	return rudp;
-}
-
 /*
  * Finish an rmap update and log it to the RUD. Note that the transaction is
  * marked dirty regardless of whether the rmap update succeeds or fails to
-- 
2.20.1
