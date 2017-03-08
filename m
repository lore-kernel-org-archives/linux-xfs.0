Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34911 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753425AbdCHOeR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 09:34:17 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 4/5] fs, xfs: convert xfs_cui_log_item.cui_refcount from atomic_t to refcount_t
Date: Wed,  8 Mar 2017 10:53:38 +0200
Message-Id: <1488963219-11709-5-git-send-email-elena.reshetova@intel.com>
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
 fs/xfs/xfs_refcount_item.c | 4 ++--
 fs/xfs/xfs_refcount_item.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 6e4c744..61bc570 100644
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
@@ -221,7 +221,7 @@ void
 xfs_cui_release(
 	struct xfs_cui_log_item	*cuip)
 {
-	if (atomic_dec_and_test(&cuip->cui_refcount)) {
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

