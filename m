Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44215 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbcK2R2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 12:28:31 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] fs: make sb_init_dio_done_wq available outside of direct-io.c
Date: Tue, 29 Nov 2016 18:28:14 +0100
Message-Id: <1480440496-25737-4-git-send-email-hch@lst.de>
In-Reply-To: <1480440496-25737-1-git-send-email-hch@lst.de>
References: <1480440496-25737-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, linux-fsdevel@vger.kernel.org

We want to use the per-sb completion workqueue from the new iomap
direct I/O code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/direct-io.c | 2 +-
 fs/internal.h  | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index fb9aa16..19aa448 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -554,7 +554,7 @@ static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
  * filesystems that don't need it and also allows us to create the workqueue
  * late enough so the we can include s_id in the name of the workqueue.
  */
-static int sb_init_dio_done_wq(struct super_block *sb)
+int sb_init_dio_done_wq(struct super_block *sb)
 {
 	struct workqueue_struct *old;
 	struct workqueue_struct *wq = alloc_workqueue("dio/%s",
diff --git a/fs/internal.h b/fs/internal.h
index f4da334..4fcf517 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -184,3 +184,6 @@ typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
 loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
 		unsigned flags, struct iomap_ops *ops, void *data,
 		iomap_actor_t actor);
+
+/* direct-io.c: */
+int sb_init_dio_done_wq(struct super_block *sb);
-- 
2.1.4

