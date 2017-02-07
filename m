Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43096 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdBGRQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2017 12:16:24 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cb9NJ-0006e1-7y
        for linux-xfs@vger.kernel.org; Tue, 07 Feb 2017 17:16:18 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] xfs: improve busy extent sorting
Date: Tue,  7 Feb 2017 18:15:00 +0100
Message-Id: <20170207171501.4268-5-hch@lst.de>
In-Reply-To: <20170207171501.4268-1-hch@lst.de>
References: <20170207171501.4268-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Sort busy extents by the full block number instead of just the AGNO so
that we can issue consecutive discard requests that the block layer could
merge (although we'll need additional block layer fixes for fast devices).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extent_busy.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 4d850e27095e..ab062610234e 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -656,9 +656,17 @@ xfs_extent_busy_wait_all(
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
+	s32 diff;
+
+	diff = b1->agno - b2->agno;
+	if (!diff)
+		diff = b1->bno - b2->bno;
+	return diff;
 }
-- 
2.11.0

