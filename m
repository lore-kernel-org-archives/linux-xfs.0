Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFFBC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 00:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiKPA7N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 19:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiKPA7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 19:59:10 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43AFB86B;
        Tue, 15 Nov 2022 16:59:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VUv04qu_1668560345;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VUv04qu_1668560345)
          by smtp.aliyun-inc.com;
          Wed, 16 Nov 2022 08:59:06 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] xfs: Fix some kernel-doc comments
Date:   Wed, 16 Nov 2022 08:59:04 +0800
Message-Id: <20221116005904.54375-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs/xfs/xfs_log.c:3601 xlog_verify_tail_lsn() warn: inconsistent indenting

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3079
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/xfs/xfs_log.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0141d9907d31..4d031ed3f3c1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3598,21 +3598,21 @@ xlog_verify_tail_lsn(
 	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
 	int		blocks;
 
-    if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
-	blocks =
-	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
-	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    } else {
-	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
-
-	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
-		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
-
-	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
-	if (blocks < BTOBB(iclog->ic_offset) + 1)
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    }
+	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
+		blocks =
+			log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
+		if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
+			xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
+	} else {
+		ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
+
+		if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
+			xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
+
+		blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
+		if (blocks < BTOBB(iclog->ic_offset) + 1)
+			xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
+	}
 }
 
 /*
-- 
2.20.1.7.g153144c

