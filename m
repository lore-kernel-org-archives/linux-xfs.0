Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18420 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750713AbdCHJBr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 04:01:47 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/5] fs, xfs: convert xfs_efi_log_item.efi_refcount from atomic_t to refcount_t
Date: Wed,  8 Mar 2017 10:53:36 +0200
Message-Id: <1488963219-11709-3-git-send-email-elena.reshetova@intel.com>
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
 fs/xfs/xfs_extfree_item.c | 4 ++--
 fs/xfs/xfs_extfree_item.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d7bc149..4e0acf0 100644
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
@@ -290,7 +290,7 @@ void
 xfs_efi_release(
 	struct xfs_efi_log_item	*efip)
 {
-	if (atomic_dec_and_test(&efip->efi_refcount)) {
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

