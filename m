Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E66C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 15 May 2022 13:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiEONMI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 09:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbiEONMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 09:12:00 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A0ADF67;
        Sun, 15 May 2022 06:11:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VDAXoyj_1652620302;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VDAXoyj_1652620302)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 15 May 2022 21:11:56 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] xfs: Remove duplicate include
Date:   Sun, 15 May 2022 21:11:40 +0800
Message-Id: <20220515131140.31281-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clean up the following includecheck warning:

./fs/xfs/xfs_attr_item.c: xfs_inode.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/xfs/xfs_attr_item.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e8ac88d9fd14..bf9a01b083b8 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -22,7 +22,6 @@
 #include "xfs_attr.h"
 #include "xfs_attr_item.h"
 #include "xfs_trace.h"
-#include "xfs_inode.h"
 #include "xfs_trans_space.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
-- 
2.20.1.7.g153144c

