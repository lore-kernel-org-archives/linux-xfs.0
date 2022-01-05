Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B010EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 15:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbiAEPQA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 10:16:00 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:53489 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236858AbiAEPP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 10:15:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V12-5P9_1641395738;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V12-5P9_1641395738)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 23:15:55 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] xfs: Remove redundant assignment of mp
Date:   Wed,  5 Jan 2022 23:15:36 +0800
Message-Id: <20220105151536.39062-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mp is being initialized to log->l_mp but this is never read
as record is overwritten later on. Remove the redundant
assignment.

Cleans up the following clang-analyzer warning:

fs/xfs/xfs_log_recover.c:3543:20: warning: Value stored to 'mp' during
its initialization is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
 -Remove mp = log->l_mp.

 fs/xfs/xfs_log_recover.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8ecb9a8567b7..96c997ed2ec8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3550,8 +3550,6 @@ xlog_recover_check_summary(
 	uint64_t		ifree;
 	int			error;
 
-	mp = log->l_mp;
-
 	freeblks = 0LL;
 	itotal = 0LL;
 	ifree = 0LL;
-- 
2.20.1.7.g153144c

