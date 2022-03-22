Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A73CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 00:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiCVATA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 20:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiCVAS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 20:18:59 -0400
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96103DE905;
        Mon, 21 Mar 2022 17:16:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V7sYEL4_1647907898;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V7sYEL4_1647907898)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Mar 2022 08:11:39 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] xfs: clean up some inconsistent indenting
Date:   Tue, 22 Mar 2022 08:11:37 +0800
Message-Id: <20220322001137.96594-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eliminate the follow smatch warning:
fs/xfs/xfs_log.c:3702 xlog_verify_tail_lsn() warn: inconsistent
indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/xfs/xfs_log.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a8034c0afdf2..5c8843026468 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3699,21 +3699,21 @@ xlog_verify_tail_lsn(
 	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
 	int		blocks;
 
-    if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
-	blocks =
-	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
+	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
+		blocks = log->l_logBBsize -
+			(log->l_prev_block - BLOCK_LSN(tail_lsn));
 	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
 		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    } else {
-	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
+	} else {
+		ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
 
-	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
-		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
+		if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
+			xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
 
-	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
-	if (blocks < BTOBB(iclog->ic_offset) + 1)
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    }
+		blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
+		if (blocks < BTOBB(iclog->ic_offset) + 1)
+			xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
+	}
 }
 
 /*
-- 
2.20.1.7.g153144c

