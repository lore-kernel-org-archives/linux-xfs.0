Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:19086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726059AbfF0Hd4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jun 2019 03:33:56 -0400
From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] xfs: remove duplicated include
Date: Thu, 27 Jun 2019 15:33:23 +0800
Message-ID: <20190627073323.45516-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, hch@lst.de, dchinner@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/xfs/xfs_extfree_item.c | 1 -
 fs/xfs/xfs_filestream.c   | 1 -
 fs/xfs/xfs_pnfs.c         | 1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 99fd40eb..e515506 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -13,7 +13,6 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
-#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_extfree_item.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index b1869ae..a6d228c 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -21,7 +21,6 @@
 #include "xfs_trace.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trans.h"
-#include "xfs_shared.h"
 
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 2d95355..6018e1c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -17,7 +17,6 @@
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_iomap.h"
-#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_pnfs.h"
 
-- 
2.7.4
