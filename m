Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:47074 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbfAQHCd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jan 2019 02:02:33 -0500
From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] xfs: remove duplicated xfs_defer.h
Date: Thu, 17 Jan 2019 15:02:17 +0800
Message-ID: <20190117070217.12432-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/xfs/xfs_trans_bmap.c     | 1 -
 fs/xfs/xfs_trans_extfree.c  | 1 -
 fs/xfs/xfs_trans_refcount.c | 1 -
 fs/xfs/xfs_trans_rmap.c     | 1 -
 4 files changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index 11cff44..e1c7d55 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -17,7 +17,6 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
-#include "xfs_defer.h"
 
 /*
  * This routine is called to allocate a "bmap update done"
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 0710434..8ee7a3f 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -18,7 +18,6 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
-#include "xfs_defer.h"
 
 /*
  * This routine is called to allocate an "extent free done"
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
index 6c947ff..8d73472 100644
--- a/fs/xfs/xfs_trans_refcount.c
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -16,7 +16,6 @@
 #include "xfs_refcount_item.h"
 #include "xfs_alloc.h"
 #include "xfs_refcount.h"
-#include "xfs_defer.h"
 
 /*
  * This routine is called to allocate a "refcount update done"
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index a428909..5c7936b 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -16,7 +16,6 @@
 #include "xfs_rmap_item.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
-#include "xfs_defer.h"
 
 /* Set the map extent flags for this reverse mapping. */
 static void
-- 
2.7.0
