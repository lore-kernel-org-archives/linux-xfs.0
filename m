Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbfBMJx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 04:53:28 -0500
From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 1/9] block: add nr_mirrors to request_queue
Date: Wed, 13 Feb 2019 17:50:36 +0800
Message-Id: <20190213095044.29628-2-bob.liu@oracle.com>
In-Reply-To: <20190213095044.29628-1-bob.liu@oracle.com>
References: <20190213095044.29628-1-bob.liu@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, Bob Liu <bob.liu@oracle.com>

When fs data/metadata checksum mismatch, lower block devices may have other
correct copies. e.g if we did raid1 for protecting fs metadata.
Then fs could try other copies of metadata instead of panic, but fs need be
awared how many mirrors the block devices have.

This patch add @nr_mirrors to struct request_queue which is similar as
blk_queue_nonrot(), filesystem can grab device request queue and check the
number of mirrors of this block device.

@nr_mirrors is 1 by default which means only one copy, drivers e.g raid1 are
responsible for setting the right value. The maximum value is
BITS_PER_LONG which is 32 or 64. That should be big enough else retry lantency
may be too high.

Also added helper functions for get/set the number of mirrors for a specific
device request queue.

Todo:
* Export nr_mirrors through /sysfs.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 block/blk-core.c       |  3 +++
 block/blk-settings.c   | 24 ++++++++++++++++++++++++
 include/linux/blkdev.h |  3 +++
 include/linux/types.h  |  3 +++
 4 files changed, 33 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6b78ec56a4f2..b838c6dc5357 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -537,6 +537,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (blkcg_init_queue(q))
 		goto fail_ref;
 
+	/* Set queue default mirrors to 1 explicitly. */
+	blk_queue_set_mirrors(q, 1);
+
 	return q;
 
 fail_ref:
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3e7038e475ee..38e4d7e675e6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -844,6 +844,30 @@ void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
 }
 EXPORT_SYMBOL_GPL(blk_queue_write_cache);
 
+/*
+ * Get the number of read redundant mirrors.
+ */
+unsigned short blk_queue_get_mirrors(struct request_queue *q)
+{
+	return q->nr_mirrors;
+}
+EXPORT_SYMBOL(blk_queue_get_mirrors);
+
+/*
+ * Set the number of read redundant mirrors.
+ */
+bool blk_queue_set_mirrors(struct request_queue *q, unsigned short mirrors)
+{
+	if(q->nr_mirrors >= BLKDEV_MAX_MIRRORS) {
+		printk("blk_queue_set_mirrors: %d exceed max mirrors(%d)\n",
+				mirrors, BLKDEV_MAX_MIRRORS);
+		return false;
+	}
+	q->nr_mirrors = mirrors;
+	return true;
+}
+EXPORT_SYMBOL(blk_queue_set_mirrors);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 338604dff7d0..0191dc4d3f2d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -570,6 +570,7 @@ struct request_queue {
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
+	unsigned long		nr_mirrors; /* Default value is 1 */
 };
 
 #define QUEUE_FLAG_STOPPED	1	/* queue is stopped */
@@ -1071,6 +1072,8 @@ extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
+extern unsigned short blk_queue_get_mirrors(struct request_queue *q);
+extern bool blk_queue_set_mirrors(struct request_queue *q, unsigned short mirrors);
 
 /*
  * Number of physical segments as sent to the device.
diff --git a/include/linux/types.h b/include/linux/types.h
index c2615d6a019e..a29135772f3a 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -7,6 +7,9 @@
 
 #ifndef __ASSEMBLY__
 
+/* max mirrors of blkdev */
+#define BLKDEV_MAX_MIRRORS BITS_PER_LONG
+
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
-- 
2.17.1
