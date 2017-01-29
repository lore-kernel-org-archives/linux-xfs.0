Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdA2Sov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Jan 2017 13:44:51 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cXuS9-0001A8-JN
        for linux-xfs@vger.kernel.org; Sun, 29 Jan 2017 18:43:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] xfs: improve busy extent sorting
Date: Sun, 29 Jan 2017 19:43:40 +0100
Message-Id: <1485715421-17182-4-git-send-email-hch@lst.de>
In-Reply-To: <1485715421-17182-1-git-send-email-hch@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Sort busy extents by the full block number instead of just the AGNO so
that we can issue consecutive discard requests that the block layer could
merge (although we'll need additional block layer fixes for fast devices).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 8251359..d64dd4c 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -629,9 +629,13 @@ xfs_extent_busy_flush(
 int
 xfs_extent_busy_ag_cmp(
 	void			*priv,
-	struct list_head	*a,
-	struct list_head	*b)
+	struct list_head	*l1,
+	struct list_head	*l2)
 {
-	return container_of(a, struct xfs_extent_busy, list)->agno -
-		container_of(b, struct xfs_extent_busy, list)->agno;
+	struct xfs_extent_busy	*b1 =
+		container_of(l1, struct xfs_extent_busy, list);
+	struct xfs_extent_busy	*b2 =
+		container_of(l2, struct xfs_extent_busy, list);
+
+	return b1->agno - b2->agno || b1->bno - b2->bno;
 }
-- 
2.1.4

