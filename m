Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C0EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Nov 2023 07:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbjKCHbC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Nov 2023 03:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbjKCHbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2023 03:31:01 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2246CD4E;
        Fri,  3 Nov 2023 00:30:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VvYSqY0_1698996640;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VvYSqY0_1698996640)
          by smtp.aliyun-inc.com;
          Fri, 03 Nov 2023 15:30:49 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     chandan.babu@oracle.com
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] xfs: Remove unused function
Date:   Fri,  3 Nov 2023 15:30:40 +0800
Message-Id: <20231103073040.649-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The function are defined in the bitmap.c file, but not called
elsewhere, so delete the unused function.

fs/xfs/scrub/bitmap.c:55:1: warning: unused function 'xbitmap_tree_iter_next'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7137
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/xfs/scrub/bitmap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index e0c89a9a0ca0..ba4b18e40faa 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -48,10 +48,6 @@ static inline struct xbitmap_node *
 xbitmap_tree_iter_first(struct rb_root_cached *root, uint64_t start,
 			uint64_t last);
 
-static inline struct xbitmap_node *
-xbitmap_tree_iter_next(struct xbitmap_node *node, uint64_t start,
-		       uint64_t last);
-
 INTERVAL_TREE_DEFINE(struct xbitmap_node, bn_rbnode, uint64_t,
 		__bn_subtree_last, START, LAST, static inline, xbitmap_tree)
 
-- 
2.20.1.7.g153144c

