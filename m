Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdDMIFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 04:05:25 -0400
Received: from 212095007060.public.telering.at ([212.95.7.60] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cyZkq-0007WV-9N
        for linux-xfs@vger.kernel.org; Thu, 13 Apr 2017 08:05:24 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10] xfs: introduce xfs_trans_blk_res
Date: Thu, 13 Apr 2017 10:05:08 +0200
Message-Id: <20170413080517.12564-2-hch@lst.de>
In-Reply-To: <20170413080517.12564-1-hch@lst.de>
References: <20170413080517.12564-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is a smaller helper to check the remaining block reservation in a
transaction.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 2 +-
 fs/xfs/xfs_trans.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a280e126491f..3a83927a5334 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -97,7 +97,7 @@ xfs_trans_dup(
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
-	ntp->t_blk_res = tp->t_blk_res - tp->t_blk_res_used;
+	ntp->t_blk_res = xfs_trans_blk_res(tp);
 	tp->t_blk_res = tp->t_blk_res_used;
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 2a9292df6640..e4f041c89846 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -152,6 +152,11 @@ typedef struct xfs_trans {
 #define	xfs_trans_agbtree_delta(tp, d)
 #endif
 
+static inline unsigned int xfs_trans_blk_res(struct xfs_trans *tp)
+{
+	return tp->t_blk_res - tp->t_blk_res_used;
+}
+
 /*
  * XFS transaction mechanism exported interfaces.
  */
-- 
2.11.0

