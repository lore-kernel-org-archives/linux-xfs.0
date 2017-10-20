Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35826 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753090AbdJTLQE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:16:04 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 4/5] fs, xfs: convert xfs_cui_log_item.cui_refcount from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 14:07:57 +0300
Message-Id: <1508497678-10508-5-git-send-email-elena.reshetova@intel.com>
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

The variable xfs_cui_log_item.cui_refcount is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/xfs/xfs_refcount_item.c | 6 +++---
 fs/xfs/xfs_refcount_item.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8f2e2fa..004d002 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -205,7 +205,7 @@ xfs_cui_init(
 	cuip->cui_format.cui_nextents = nextents;
 	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
 	atomic_set(&cuip->cui_next_extent, 0);
-	atomic_set(&cuip->cui_refcount, 2);
+	refcount_set(&cuip->cui_refcount, 2);
 
 	return cuip;
 }
@@ -221,8 +221,8 @@ void
 xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
-	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
-	if (atomic_dec_and_test(&cuip->cui_refcount)) {
+	ASSERT(refcount_read(&cuip->cui_refcount) > 0);
+	if (refcount_dec_and_test(&cuip->cui_refcount)) {
 		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_cui_item_free(cuip);
 	}
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index 5b74ddd..abc0377 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -63,7 +63,7 @@ struct kmem_zone;
  */
 struct xfs_cui_log_item {
 	struct xfs_log_item		cui_item;
-	atomic_t			cui_refcount;
+	refcount_t			cui_refcount;
 	atomic_t			cui_next_extent;
 	unsigned long			cui_flags;	/* misc flags */
 	struct xfs_cui_log_format	cui_format;
-- 
2.7.4

