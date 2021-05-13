Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AC8C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 10:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2719E61439
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 10:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhEMKwg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 May 2021 06:52:36 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:36558 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhEMKwg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 May 2021 06:52:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UYkXVSS_1620903080;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UYkXVSS_1620903080)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 May 2021 18:51:25 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] xfs: Remove redundant assignment to busy
Date:   Thu, 13 May 2021 18:51:18 +0800
Message-Id: <1620903078-58184-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Variable busy is set to false, but this value is never read as it is
overwritten or not used later on, hence it is a redundant assignment
and can be removed.

Clean up the following clang-analyzer warning:

fs/xfs/libxfs/xfs_alloc.c:1679:2: warning: Value stored to 'busy' is
never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 82b7cbb..ae46fe6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1676,7 +1676,6 @@ struct xfs_alloc_cur {
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
-	busy = false;
 
 	/*
 	 * Look for an entry >= maxlen+alignment-1 blocks.
-- 
1.8.3.1

