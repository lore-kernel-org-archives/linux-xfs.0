Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56221 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/12] nvme: export the atomic write limit
Date: Tue, 28 Feb 2017 06:57:37 -0800
Message-Id: <20170228145737.19016-13-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 10 ++++++++++
 drivers/nvme/host/nvme.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8a3c3e32a704..e86d07589f18 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -926,6 +926,15 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	ns->pi_type = pi_type;
 	blk_queue_logical_block_size(ns->queue, bs);
 
+	/*
+	 * Advertisze the maximum atomic write size.  Don't bother with the
+	 * per-namespace values due to their alignment constraints.
+	 */
+	if (ns->ctrl->awupf > 1) {
+		blk_queue_max_atomic_write_sectors(ns->queue,
+			(ns->ctrl->awupf + 1) << (ns->lba_shift - 9));
+	}
+
 	if (ns->ms && !blk_get_integrity(disk) && !ns->ext)
 		nvme_init_integrity(ns);
 	if (ns->ms && !(ns->ms == 8 && ns->pi_type) && !blk_get_integrity(disk))
@@ -1232,6 +1241,7 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 
 	ctrl->vid = le16_to_cpu(id->vid);
 	ctrl->oncs = le16_to_cpup(&id->oncs);
+	ctrl->awupf = le16_to_cpu(id->awupf);
 	atomic_set(&ctrl->abort_limit, id->acl + 1);
 	ctrl->vwc = id->vwc;
 	ctrl->cntlid = le16_to_cpup(&id->cntlid);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index aead6d08ed2c..020ffd6f7863 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -143,6 +143,7 @@ struct nvme_ctrl {
 	u32 vs;
 	u32 sgls;
 	u16 kas;
+	u16 awupf;
 	unsigned int kato;
 	bool subsystem;
 	unsigned long quirks;
-- 
2.11.0

