Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932429AbdJJQr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 12:47:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 951CCC058EB1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 16:47:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67E4B5C1A3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 16:47:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: buffer lru reference count error injection tag
Date: Tue, 10 Oct 2017 12:47:56 -0400
Message-Id: <20171010164756.28390-3-bfoster@redhat.com>
In-Reply-To: <20171010164756.28390-1-bfoster@redhat.com>
References: <20171010164756.28390-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS uses a fixed reference count for certain types of buffers in the
internal LRU cache. These reference counts dictate how aggressively
certain buffers are reclaimed vs. others. While the reference counts
implements priority across different buffer types, all buffers
(other than uncached buffers) are typically cached for at least one
reclaim cycle.

We've had at least one bug recently that has been hidden by a
released buffer sitting around in the LRU. Users hitting the problem
were able to reproduce under enough memory pressure to cause
aggressive reclaim in a particular window of time.

To support future xfstests cases, add an error injection tag to
hardcode the buffer reference count to zero. When enabled, this
bypasses caching of associated buffers and facilitates test cases
that depend on this behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c   | 16 ++++++++++++++++
 fs/xfs/xfs_buf.h   |  5 +----
 fs/xfs/xfs_error.c |  3 +++
 fs/xfs/xfs_error.h |  4 +++-
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2f97c12..d481dd2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -42,6 +42,7 @@
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 static kmem_zone_t *xfs_buf_zone;
 
@@ -2129,3 +2130,18 @@ xfs_buf_terminate(void)
 {
 	kmem_zone_destroy(xfs_buf_zone);
 }
+
+void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	/*
+	 * Set the lru reference count to 0 based on the error injection tag.
+	 * This allows userspace to disrupt buffer caching for debug/testing
+	 * purposes.
+	 */
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_LRU_REF))
+		lru_ref = 0;
+
+	atomic_set(&bp->b_lru_ref, lru_ref);
+}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bf71507d..f873bb7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -352,10 +352,7 @@ extern void xfs_buf_terminate(void);
 #define XFS_BUF_ADDR(bp)		((bp)->b_maps[0].bm_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_maps[0].bm_bn = (xfs_daddr_t)(bno))
 
-static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
-{
-	atomic_set(&bp->b_lru_ref, lru_ref);
-}
+void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref);
 
 static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 {
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index eaf86f5..6732b0a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_DROP_WRITES,
 	XFS_RANDOM_LOG_BAD_CRC,
 	XFS_RANDOM_LOG_ITEM_PIN,
+	XFS_RANDOM_BUF_LRU_REF,
 };
 
 struct xfs_errortag_attr {
@@ -163,6 +164,7 @@ XFS_ERRORTAG_ATTR_RW(ag_resv_critical,	XFS_ERRTAG_AG_RESV_CRITICAL);
 XFS_ERRORTAG_ATTR_RW(drop_writes,	XFS_ERRTAG_DROP_WRITES);
 XFS_ERRORTAG_ATTR_RW(log_bad_crc,	XFS_ERRTAG_LOG_BAD_CRC);
 XFS_ERRORTAG_ATTR_RW(log_item_pin,	XFS_ERRTAG_LOG_ITEM_PIN);
+XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -196,6 +198,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(drop_writes),
 	XFS_ERRORTAG_ATTR_LIST(log_bad_crc),
 	XFS_ERRORTAG_ATTR_LIST(log_item_pin),
+	XFS_ERRORTAG_ATTR_LIST(buf_lru_ref),
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 7c4bef3..78a7f43 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -107,7 +107,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
 #define XFS_ERRTAG_LOG_ITEM_PIN				30
-#define XFS_ERRTAG_MAX					31
+#define XFS_ERRTAG_BUF_LRU_REF				31
+#define XFS_ERRTAG_MAX					32
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -143,6 +144,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_RANDOM_DROP_WRITES				1
 #define XFS_RANDOM_LOG_BAD_CRC				1
 #define XFS_RANDOM_LOG_ITEM_PIN				1
+#define XFS_RANDOM_BUF_LRU_REF				2
 
 #ifdef DEBUG
 extern int xfs_errortag_init(struct xfs_mount *mp);
-- 
2.9.5

