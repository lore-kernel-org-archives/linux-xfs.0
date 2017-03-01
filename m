Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33664 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbdCAJEF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 04:04:05 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 2/5] fs, xfs: convert xfs_efi_log_item.efi_refcount from atomic_t to refcount_t
Date: Wed,  1 Mar 2017 10:47:37 +0200
Message-Id: <1488358060-693-3-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488358060-693-1-git-send-email-elena.reshetova@intel.com>
References: <1488358060-693-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, darrick.wong@oracle.com, david@fromorbit.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

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
 fs/xfs/xfs_extfree_item.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

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
index a32c794..e6da63d 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -18,6 +18,8 @@
 #ifndef	__XFS_EXTFREE_ITEM_H__
 #define	__XFS_EXTFREE_ITEM_H__
 
+#include <linux/refcount.h>
+
 /* kernel only EFI/EFD definitions */
 
 struct xfs_mount;
@@ -64,7 +66,7 @@ struct kmem_zone;
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

