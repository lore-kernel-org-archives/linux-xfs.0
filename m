Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A07C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 08:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKCIWK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 04:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiKCIVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 04:21:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46CC636A
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 01:21:47 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2xRz05cdzRnsK;
        Thu,  3 Nov 2022 16:16:46 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500019.china.huawei.com
 (7.221.188.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 16:21:45 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <djwong@kernel.org>, <dchinner@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <guoxuenan@huawei.com>,
        <houtao1@huawei.com>, <jack.qiu@huawei.com>, <fangwei1@huawei.com>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <leo.lilong@huawei.com>, <zengheng4@huawei.com>
Subject: [PATCH 0/2] xfs: shutdown UAF fixes
Date:   Thu, 3 Nov 2022 16:36:30 +0800
Message-ID: <20221103083632.150458-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi xfs folks:

The following patches fix some race of xfs force shutdown. 

Patch 1 fix uaf in xfs_trans_ail_delete during xlog force shutdown.
In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
xlog_state_shutdown_callbacks"), seems not enough to avoid UAF of AIL
before it being tear down in umount.

Patch 2 fix uaf of super block buffer log item during xlog shut down,
since xfs buf log item can be reloged, super block buffer is most
frequently modified of all xfs_buf, especially when disable lazy-count
feature, during force shutdown we will unpin and release log item, due
to xfs relog mechanism, which may release the log item alread inserted
in CIL.

I reproduce the two problems, /importantly/, adding following patches and
disable lazy-count feature to increase recurrence probability.

Kernel patch for reproduce the issue of patch 1:
```
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 522d450a94b1..b1221d517c00 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -503,6 +503,9 @@ xfs_buf_item_unpin(
         * the AIL properly holds a reference on the bli.
         */
        freed = atomic_dec_and_test(&bip->bli_refcount);
+       if (remove)
+               mdelay(1000);
+
        if (freed && !stale && remove)
                xfs_buf_hold(bp);
        if (atomic_dec_and_test(&bp->b_pin_count))

```

Kernel patch for reproduce the issue of patch 2:
```
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..b1aac4a7576c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,6 +25,9 @@
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
 
+#include <linux/delay.h>
+#include "xfs_log_priv.h"
+
 struct kmem_cache      *xfs_trans_cache;
 
 #if defined(CONFIG_TRACEPOINTS)
@@ -1002,6 +1005,8 @@ __xfs_trans_commit(
                xfs_trans_apply_sb_deltas(tp);
        xfs_trans_apply_dquot_deltas(tp);
 
+       if (xlog_is_shutdown(log))
+               mdelay(1000);
        xlog_cil_commit(log, tp, &commit_seq, regrant);
 
        xfs_trans_free(tp);
```

Guo Xuenan (2):
  xfs: wait xlog ioend workqueue drained before tearing down AIL
  xfs: fix super block buf log item UAF during force shutdown

 fs/xfs/xfs_buf_item.c  | 8 +++++---
 fs/xfs/xfs_trans_ail.c | 3 +++
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.31.1

