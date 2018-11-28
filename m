Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbeK1Owk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:40 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 1/7] block: add nr_mirrors to request_queue
Date: Tue, 27 Nov 2018 20:49:45 -0700
Message-Id: <1543376991-5764-2-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

From: Bob Liu <bob.liu@oracle.com>

When fs data/metadata checksum mismatch, lower block devices may have other
correct copies. e.g if we did raid1 for protecting fs metadata.
Then fs could try other copies of metadata instead of panic, but fs need be
awared how many mirrors the block devices have and specify which mirror/copy to
retry.

This patch add @nr_mirrors to struct request_queue which is similar as
blk_queue_nonrot(), filesystem can grab device request queue and check the
number of mirrors of this block device.

@nr_mirrors is 0 by default which means no mirrors, drivers e.g raid1 are
responsible for setting the right value.

Also added helper functions for get/set the number of mirrors for a specific
device request queue.

Todo:
* Export nr_mirrors through /sysfs.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 block/blk-core.c       |  3 +++
 block/blk-settings.c   | 18 ++++++++++++++++++
 include/linux/blkdev.h |  3 +++
 3 files changed, 24 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index ce12515f..50779c8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1082,6 +1082,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
 	if (blkcg_init_queue(q))
 		goto fail_ref;
 
+	/* Set queue default mirrors to 0 explicitly. */
+	blk_queue_set_mirrors(q, 0);
+
 	return q;
 
 fail_ref:
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 696c04c..6f4f9c7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -904,6 +904,24 @@ void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
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
+void blk_queue_set_mirrors(struct request_queue *q, unsigned short mirrors)
+{
+	q->nr_mirrors = mirrors;
+}
+EXPORT_SYMBOL(blk_queue_set_mirrors);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4293dc1..fac35da 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -680,6 +680,7 @@ struct request_queue {
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
+	unsigned short		nr_mirrors; /* Default value is zero */
 };
 
 #define QUEUE_FLAG_QUEUED	0	/* uses generic tag queueing */
@@ -1267,6 +1268,8 @@ extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
+extern unsigned short blk_queue_get_mirrors(struct request_queue *q);
+extern void blk_queue_set_mirrors(struct request_queue *q, unsigned short mirrors);
 
 /*
  * Number of physical segments as sent to the device.
-- 
2.7.4
