Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35826 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753052AbdJTLP7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:15:59 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/5] fs, xfs: convert xfs_efi_log_item.efi_refcount from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 14:07:55 +0300
Message-Id: <1508497678-10508-3-git-send-email-elena.reshetova@intel.com>
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

The variable xfs_efi_log_item.efi_refcount is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/xfs/xfs_extfree_item.c | 6 +++---
 fs/xfs/xfs_extfree_item.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 44f8c54..dfe2bcb 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -220,7 +220,7 @@ xfs_efi_init(
 	efip->efi_format.efi_nextents = nextents;
 	efip->efi_format.efi_id = (uintptr_t)(void *)efip;
 	atomic_set(&efip->efi_next_extent, 0);
-	atomic_set(&efip->efi_refcount, 2);
+	refcount_set(&efip->efi_refcount, 2);
 
 	return efip;
 }
@@ -290,8 +290,8 @@ void
 xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
-	ASSERT(atomic_read(&efip->efi_refcount) > 0);
-	if (atomic_dec_and_test(&efip->efi_refcount)) {
+	ASSERT(refcount_read(&efip->efi_refcount) > 0);
+	if (refcount_dec_and_test(&efip->efi_refcount)) {
 		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index a32c794..fadf736 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -64,7 +64,7 @@ struct kmem_zone;
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
-	atomic_t		efi_refcount;
+	refcount_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
-- 
2.7.4

