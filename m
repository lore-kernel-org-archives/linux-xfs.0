Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:3085 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751407AbeDRELM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 00:11:12 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] blk: add blk_queue_fua() helper function
Date: Wed, 18 Apr 2018 14:08:27 +1000
Message-Id: <20180418040828.18165-4-david@fromorbit.com>
In-Reply-To: <20180418040828.18165-1-david@fromorbit.com>
References: <20180418040828.18165-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

From: Dave Chinner <dchinner@redhat.com>

So we can check FUA support status from the iomap direct IO code.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 include/linux/blkdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9af3e0f430bc..c362aadfe036 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -737,6 +737,7 @@ bool blk_queue_flag_test_and_clear(unsigned int flag, struct request_queue *q);
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 #define blk_queue_preempt_only(q)				\
 	test_bit(QUEUE_FLAG_PREEMPT_ONLY, &(q)->queue_flags)
+#define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 
 extern int blk_set_preempt_only(struct request_queue *q);
 extern void blk_clear_preempt_only(struct request_queue *q);
-- 
2.16.1

