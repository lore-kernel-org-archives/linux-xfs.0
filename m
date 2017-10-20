Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35826 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753053AbdJTLQG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:16:06 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 5/5] fs, xfs: convert xfs_rui_log_item.rui_refcount from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 14:07:58 +0300
Message-Id: <1508497678-10508-6-git-send-email-elena.reshetova@intel.com>
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

The variable xfs_rui_log_item.rui_refcount is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/xfs/xfs_rmap_item.c | 6 +++---
 fs/xfs/xfs_rmap_item.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index f3b139c..f914829f 100644
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
@@ -243,8 +243,8 @@ void
 xfs_rui_release(
 	struct xfs_rui_log_item	*ruip)
 {
-	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
-	if (atomic_dec_and_test(&ruip->rui_refcount)) {
+	ASSERT(refcount_read(&ruip->rui_refcount) > 0);
+	if (refcount_dec_and_test(&ruip->rui_refcount)) {
 		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_rui_item_free(ruip);
 	}
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 340c968..1e425a9 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -64,7 +64,7 @@ struct kmem_zone;
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

