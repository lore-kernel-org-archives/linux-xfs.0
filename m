Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18420 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751907AbdCHJBx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 04:01:53 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 1/5] fs, xfs: convert xfs_bui_log_item.bui_refcount from atomic_t to refcount_t
Date: Wed,  8 Mar 2017 10:53:35 +0200
Message-Id: <1488963219-11709-2-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/xfs/xfs_bmap_item.c | 4 ++--
 fs/xfs/xfs_bmap_item.h | 2 +-
 fs/xfs/xfs_linux.h     | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9bf57c7..33104ad 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -199,7 +199,7 @@ xfs_bui_init(
 	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
 	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
 	atomic_set(&buip->bui_next_extent, 0);
-	atomic_set(&buip->bui_refcount, 2);
+	refcount_set(&buip->bui_refcount, 2);
 
 	return buip;
 }
@@ -215,7 +215,7 @@ void
 xfs_bui_release(
 	struct xfs_bui_log_item	*buip)
 {
-	if (atomic_dec_and_test(&buip->bui_refcount)) {
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
index 7a989de..09b0396 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -19,6 +19,7 @@
 #define __XFS_LINUX__
 
 #include <linux/types.h>
+#include <linux/refcount.h>
 
 /*
  * Kernel specific type declarations for XFS
-- 
2.7.4

