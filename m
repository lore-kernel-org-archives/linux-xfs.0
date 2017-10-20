Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35826 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbdJTLP5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:15:57 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 1/5] fs, xfs: convert xfs_bui_log_item.bui_refcount from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 14:07:54 +0300
Message-Id: <1508497678-10508-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
References: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>

atomic_t variables are currently used to implement reference
counters with the following properties:
 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided
refcount_t type and API that prevents accidental counter overflows
and underflows. This is important since overflows and underflows
can lead to use-after-free situation and be exploitable.

The variable xfs_bui_log_item.bui_refcount is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/xfs/xfs_bmap_item.c | 6 +++---
 fs/xfs/xfs_bmap_item.h | 2 +-
 fs/xfs/xfs_linux.h     | 1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index dd136f7..0f2e3d8 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -201,7 +201,7 @@ xfs_bui_init(
 	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
 	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
 	atomic_set(&buip->bui_next_extent, 0);
-	atomic_set(&buip->bui_refcount, 2);
+	refcount_set(&buip->bui_refcount, 2);
 
 	return buip;
 }
@@ -217,8 +217,8 @@ void
 xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
-	ASSERT(atomic_read(&buip->bui_refcount) > 0);
-	if (atomic_dec_and_test(&buip->bui_refcount)) {
+	ASSERT(refcount_read(&buip->bui_refcount) > 0);
+	if (refcount_dec_and_test(&buip->bui_refcount)) {
 		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_bui_item_free(buip);
 	}
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index c867daa..7048b14 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -61,7 +61,7 @@ struct kmem_zone;
  */
 struct xfs_bui_log_item {
 	struct xfs_log_item		bui_item;
-	atomic_t			bui_refcount;
+	refcount_t			bui_refcount;
 	atomic_t			bui_next_extent;
 	unsigned long			bui_flags;	/* misc flags */
 	struct xfs_bui_log_format	bui_format;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index dcd1292..0def85f 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 #include <linux/uuid.h>
+#include <linux/refcount.h>
 
 /*
  * Kernel specific type declarations for XFS
-- 
2.7.4

