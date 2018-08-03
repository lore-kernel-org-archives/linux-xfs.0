Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:51468 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbeHCKaB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Aug 2018 06:30:01 -0400
From: Huang Chong <huang.chong@zte.com.cn>
Subject: [PATCH] xfs: fix a comment in xfs_log_reserve
Date: Fri, 3 Aug 2018 16:31:33 +0800
Message-Id: <1533285093-193140-1-git-send-email-huang.chong@zte.com.cn>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jiang.biao2@zte.com.cn, huang.chong@zte.com.cn, zhong.weidong@zte.com.cn

From: "Huang Chong" <huang.chong@zte.com.cn>

Fix the comment in xfs_log_reserve to avoid confusing.

Signed-of-by: Huang Chong <huang.chong@zte.com.cn>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5e56f3b..891ffb1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -410,7 +410,7 @@
 }
 
 /*
- * Reserve log space and return a ticket corresponding the reservation.
+ * Reserve log space and return a ticket corresponding to the reservation.
  *
  * Each reservation is going to reserve extra space for a log record header.
  * When writes happen to the on-disk log, we don't subtract the length of the
-- 
1.8.3.1

