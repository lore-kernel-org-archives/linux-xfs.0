Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EEEC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFDA165013
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhCEFLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:11:52 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:36722 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEFLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:11:52 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 18D97ECB205
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00Fbns-5T
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kf-000lYy-UD
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/45] xfs: async blkdev cache flush
Date:   Fri,  5 Mar 2021 16:11:03 +1100
Message-Id: <20210305051143.182133-6-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=SfSGQrjV1alRuBDLQEQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The new checkpoint caceh flush mechanism requires us to issue an
unconditional cache flush before we start a new checkpoint. We don't
want to block for this if we can help it, and we have a fair chunk
of CPU work to do between starting the checkpoint and issuing the
first journal IO.

Hence it makes sense to amortise the latency cost of the cache flush
by issuing it asynchronously and then waiting for it only when we
need to issue the first IO in the transaction.

TO do this, we need async cache flush primitives to submit the cache
flush bio and to wait on it. THe block layer has no such primitives
for filesystems, so roll our own for the moment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bio_io.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_linux.h  |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 17f36db2f792..668f8bd27b4a 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -9,6 +9,42 @@ static inline unsigned int bio_max_vecs(unsigned int count)
 	return bio_max_segs(howmany(count, PAGE_SIZE));
 }
 
+void
+xfs_flush_bdev_async_endio(
+	struct bio	*bio)
+{
+	if (bio->bi_private)
+		complete(bio->bi_private);
+}
+
+/*
+ * Submit a request for an async cache flush to run. If the request queue does
+ * not require flush operations, just skip it altogether. If the caller needsi
+ * to wait for the flush completion at a later point in time, they must supply a
+ * valid completion. This will be signalled when the flush completes.  The
+ * caller never sees the bio that is issued here.
+ */
+void
+xfs_flush_bdev_async(
+	struct bio		*bio,
+	struct block_device	*bdev,
+	struct completion	*done)
+{
+	struct request_queue	*q = bdev->bd_disk->queue;
+
+	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
+		complete(done);
+		return;
+	}
+
+	bio_init(bio, NULL, 0);
+	bio_set_dev(bio, bdev);
+	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
+	bio->bi_private = done;
+	bio->bi_end_io = xfs_flush_bdev_async_endio;
+
+	submit_bio(bio);
+}
 int
 xfs_rw_bdev(
 	struct block_device	*bdev,
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index af6be9b9ccdf..953d98bc4832 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -196,6 +196,8 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 
 int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 		char *data, unsigned int op);
+void xfs_flush_bdev_async(struct bio *bio, struct block_device *bdev,
+		struct completion *done);
 
 #define ASSERT_ALWAYS(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
-- 
2.28.0

