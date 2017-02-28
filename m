Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45839 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/12] block: advertize max atomic write limit
Date: Tue, 28 Feb 2017 06:57:34 -0800
Message-Id: <20170228145737.19016-10-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 22 ++++++++++++++++++++++
 block/blk-sysfs.c      | 12 ++++++++++++
 include/linux/blkdev.h |  9 +++++++++
 3 files changed, 43 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 529e55f52a03..9279542472fb 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -93,6 +93,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->virt_boundary_mask = 0;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
 	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
+	lim->max_atomic_write_sectors = 0;
 	lim->max_dev_sectors = 0;
 	lim->chunk_sectors = 0;
 	lim->max_write_same_sectors = 0;
@@ -129,6 +130,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
+	lim->max_atomic_write_sectors = 0;
 	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
 	lim->max_dev_sectors = UINT_MAX;
@@ -258,6 +260,24 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
 /**
+ * blk_queue_max_atomic_write_sectors - maximum sectors written atomically
+ * @q:  the request queue for the device
+ * @max_hw_sectors:  max hardware sectors in the usual 512b unit
+ *
+ * Description:
+ *    Enables a low level driver to advertise that it supports writing
+ *    multi-sector I/O atomically.  If the driver has any requirements
+ *    in addition to the maximum size it should not set this field to
+ *    indicate that it supports multi-sector atomic writes.
+ **/
+void blk_queue_max_atomic_write_sectors(struct request_queue *q,
+		unsigned int max_atomic_write_sectors)
+{
+	q->limits.max_atomic_write_sectors = max_atomic_write_sectors;
+}
+EXPORT_SYMBOL_GPL(blk_queue_max_atomic_write_sectors);
+
+/**
  * blk_queue_chunk_sectors - set size of the chunk for this queue
  * @q:  the request queue for the device
  * @chunk_sectors:  chunk sectors in the usual 512b unit
@@ -541,6 +561,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
+	/* no support for stacking atomic writes */
+	t->max_atomic_write_sectors = 0;
 	t->max_write_same_sectors = min(t->max_write_same_sectors,
 					b->max_write_same_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1dbce057592d..2f39009731f6 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -249,6 +249,12 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_max_atomic_write_sectors_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(queue_max_atomic_write_sectors(q) << 1, page);
+}
+
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
 queue_show_##name(struct request_queue *q, char *page)			\
@@ -540,6 +546,11 @@ static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_max_atomic_write_sectors_entry = {
+	.attr = {.name = "max_atomic_write_sectors_kb", .mode = S_IRUGO },
+	.show = queue_max_atomic_write_sectors_show,
+};
+
 static struct queue_sysfs_entry queue_max_segments_entry = {
 	.attr = {.name = "max_segments", .mode = S_IRUGO },
 	.show = queue_max_segments_show,
@@ -695,6 +706,7 @@ static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
+	&queue_max_atomic_write_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
 	&queue_max_segments_entry.attr,
 	&queue_max_integrity_segments_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1ca8e8fd1078..c43d952557f9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -323,6 +323,7 @@ struct queue_limits {
 	unsigned int		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
+	unsigned int		max_atomic_write_sectors;
 	unsigned int		max_discard_sectors;
 	unsigned int		max_hw_discard_sectors;
 	unsigned int		max_write_same_sectors;
@@ -1135,6 +1136,8 @@ extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
+extern void blk_queue_max_atomic_write_sectors(struct request_queue *,
+		unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
@@ -1371,6 +1374,12 @@ static inline unsigned int queue_max_hw_sectors(struct request_queue *q)
 	return q->limits.max_hw_sectors;
 }
 
+static inline unsigned int queue_max_atomic_write_sectors(
+		struct request_queue *q)
+{
+	return q->limits.max_atomic_write_sectors;
+}
+
 static inline unsigned short queue_max_segments(struct request_queue *q)
 {
 	return q->limits.max_segments;
-- 
2.11.0

