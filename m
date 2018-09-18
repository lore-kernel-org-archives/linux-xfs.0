Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12595 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726258AbeIRHid (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 03:38:33 -0400
From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] xfs: remove duplicated include from alloc.c
Date: Tue, 18 Sep 2018 10:07:34 +0800
Message-ID: <20180918020734.23180-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, dchinner@redhat.com, bfoster@redhat.com
Cc: linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

Remove duplicated include xfs_alloc.h

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/xfs/scrub/alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 036b5c7..376bcb5 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -17,7 +17,6 @@
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
-#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-- 
2.7.0
