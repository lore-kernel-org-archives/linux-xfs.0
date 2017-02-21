Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6976 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752777AbdBUPtk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 10:49:40 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 7/7] fs, xfs: convert xfs_rui_log_item.rui_refcount from atomic_t to refcount_t
Date: Tue, 21 Feb 2017 17:49:07 +0200
Message-Id: <1487692147-17066-8-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, darrick.wong@oracle.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

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
 fs/xfs/xfs_rmap_item.c | 4 ++--
 fs/xfs/xfs_rmap_item.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 73c8278..5e1664a 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -204,7 +204,7 @@ xfs_rui_init(
 	ruip->rui_format.rui_nextents = nextents;
 	ruip->rui_format.rui_id = (uintptr_t)(void *)ruip;
 	atomic_set(&ruip->rui_next_extent, 0);
-	atomic_set(&ruip->rui_refcount, 2);
+	refcount_set(&ruip->rui_refcount, 2);
 
 	return ruip;
 }
@@ -243,7 +243,7 @@ void
 xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
-	if (atomic_dec_and_test(&ruip->rui_refcount)) {
+	if (refcount_dec_and_test(&ruip->rui_refcount)) {
 		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_rui_item_free(ruip);
 	}
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 340c968..2529a35 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -20,6 +20,8 @@
 #ifndef	__XFS_RMAP_ITEM_H__
 #define	__XFS_RMAP_ITEM_H__
 
+#include <linux/refcount.h>
+
 /*
  * There are (currently) three pairs of rmap btree redo item types: map, unmap,
  * and convert.  The common abbreviations for these are RUI (rmap update
@@ -64,7 +66,7 @@ struct kmem_zone;
  */
 struct xfs_rui_log_item {
 	struct xfs_log_item		rui_item;
-	atomic_t			rui_refcount;
+	refcount_t			rui_refcount;
 	atomic_t			rui_next_extent;
 	unsigned long			rui_flags;	/* misc flags */
 	struct xfs_rui_log_format	rui_format;
-- 
2.7.4

