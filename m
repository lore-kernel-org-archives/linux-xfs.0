Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46858 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbeKKKXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Nov 2018 05:23:12 -0500
From: hmsjwzb <weizhefix@gmail.com>
Subject: [PATCH] Fix coding style issue in xfs_acl.c and xfs_aops.c
Date: Sun, 11 Nov 2018 08:36:03 +0800
Message-Id: <20181111003603.7598-1-weizhefix@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: hmsjwzb <weizhefix@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Possible unwrapped commit description (prefer a maximum 75 chars per line)

Signed-off-by: hmsjwzb <weizhefix@gmail.com>
---
 fs/xfs/xfs_acl.c  |  4 +--
 fs/xfs/xfs_aops.c | 73 ++++++++++++++++++++++++-----------------------
 2 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 8039e35147dd..5c779c161727 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -19,8 +19,8 @@
 
 /*
  * Locking scheme:
- *  - all ACL updates are protected by inode->i_mutex, which is taken before
- *    calling into this file.
+ *  - all ACL updates are protected by inode->i_mutex,
+ *    which is taken before calling into this file.
  */
 
 STATIC struct posix_acl *
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9984e0..1a6cb88ffdb7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -81,8 +81,8 @@ xfs_finish_page_writeback(
 
 /*
  * We're now finished for good with this ioend structure.  Update the page
- * state, release holds on bios, and finally free up memory.  Do not use the
- * ioend after this.
+ * state, release holds on bios, and finally free up memory.
+ * Do not use the ioend after this.
  */
 STATIC void
 xfs_destroy_ioend(
@@ -464,18 +464,18 @@ xfs_map_blocks(
 }
 
 /*
- * Submit the bio for an ioend. We are passed an ioend with a bio attached to
- * it, and we submit that bio. The ioend may be used for multiple bio
- * submissions, so we only want to allocate an append transaction for the ioend
- * once. In the case of multiple bio submission, each bio will take an IO
- * reference to the ioend to ensure that the ioend completion is only done once
- * all bios have been submitted and the ioend is really done.
+ * Submit the bio for an ioend. We are passed an ioend with a bio attached
+ * to it, and we submit that bio. The ioend may be used for multiple bio
+ * submissions, so we only want to allocate an append transaction for the
+ * ioend once. In the case of multiple bio submission, each bio will take
+ * an IO reference to the ioend to ensure that the ioend completion is only
+ * done once all bios have been submitted and the ioend is really done.
  *
- * If @fail is non-zero, it means that we have a situation where some part of
- * the submission process has failed after we have marked paged for writeback
- * and unlocked them. In this situation, we need to fail the bio and ioend
- * rather than submit it to IO. This typically only happens on a filesystem
- * shutdown.
+ * If @fail is non-zero, it means that we have a situation where some part
+ * of the submission process has failed after we have marked paged for
+ * writeback and unlocked them. In this situation, we need to fail the bio
+ * and ioend rather than submit it to IO. This typically only happens
+ * on a filesystem shutdown.
  */
 STATIC int
 xfs_submit_ioend(
@@ -583,8 +583,8 @@ xfs_chain_bio(
 }
 
 /*
- * Test to see if we have an existing ioend structure that we could append to
- * first, otherwise finish off the current ioend and start another.
+ * Test to see if we have an existing ioend structure that we could append
+ * to first, otherwise finish off the current ioend and start another.
  */
 STATIC void
 xfs_add_to_ioend(
@@ -637,15 +637,16 @@ xfs_vm_invalidatepage(
 }
 
 /*
- * If the page has delalloc blocks on it, we need to punch them out before we
- * invalidate the page.  If we don't, we leave a stale delalloc mapping on the
- * inode that can trip up a later direct I/O read operation on the same region.
+ * If the page has delalloc blocks on it, we need to punch them out before
+ * we invalidate the page.  If we don't, we leave a stale delalloc mapping
+ * on the inode that can trip up a later direct I/O read operation on
+ * the same region.
  *
- * We prevent this by truncating away the delalloc regions on the page.  Because
- * they are delalloc, we can do this without needing a transaction. Indeed - if
- * we get ENOSPC errors, we have to be able to do this truncation without a
- * transaction as there is no space left for block reservation (typically why we
- * see a ENOSPC in writeback).
+ * We prevent this by truncating away the delalloc regions on the page.
+ * Because they are delalloc, we can do this without needing a transaction.
+ * Indeed - if we get ENOSPC errors, we have to be able to do this
+ * truncation without a transaction as there is no space left for block
+ * reservation (typically why we see a ENOSPC in writeback).
  */
 STATIC void
 xfs_aops_discard_page(
@@ -674,20 +675,20 @@ xfs_aops_discard_page(
 }
 
 /*
- * We implement an immediate ioend submission policy here to avoid needing to
- * chain multiple ioends and hence nest mempool allocations which can violate
- * forward progress guarantees we need to provide. The current ioend we are
- * adding blocks to is cached on the writepage context, and if the new block
- * does not append to the cached ioend it will create a new ioend and cache that
- * instead.
+ * We implement an immediate ioend submission policy here to avoid needing
+ * to chain multiple ioends and hence nest mempool allocations which can
+ * violate forward progress guarantees we need to provide. The current
+ * ioend we are adding blocks to is cached on the writepage context,
+ * and if the new block does not append to the cached ioend it will create
+ * a new ioend and cache that instead.
  *
- * If a new ioend is created and cached, the old ioend is returned and queued
- * locally for submission once the entire page is processed or an error has been
- * detected.  While ioends are submitted immediately after they are completed,
- * batching optimisations are provided by higher level block plugging.
- *
- * At the end of a writeback pass, there will be a cached ioend remaining on the
- * writepage context that the caller will need to submit.
+ * If a new ioend is created and cached, the old ioend is returned and
+ * queued locally for submission once the entire page is processed or an
+ * error has been detected.  While ioends are submitted immediately
+ * after they are completed, batching optimisations are provided by higher
+ * level block plugging.
+ * At the end of a writeback pass, there will be a cached ioend remaining
+ * on the writepage context that the caller will need to submit.
  */
 static int
 xfs_writepage_map(
-- 
2.17.1
