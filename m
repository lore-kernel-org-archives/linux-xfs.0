Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbdFCNTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:19:12 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/25] xfs: fix up quotacheck buffer list error handling
Date: Sat,  3 Jun 2017 15:18:22 +0200
Message-Id: <20170603131836.26661-12-hch@lst.de>
In-Reply-To: <20170603131836.26661-1-hch@lst.de>
References: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 20e8a063786050083fe05b4f45be338c60b49126 upstream.

The quotacheck error handling of the delwri buffer list assumes the
resident buffers are locked and doesn't clear the _XBF_DELWRI_Q flag
on the buffers that are dequeued. This can lead to assert failures
on buffer release and possibly other locking problems.

Move this code to a delwri queue cancel helper function to
encapsulate the logic required to properly release buffers from a
delwri queue. Update the helper to clear the delwri queue flag and
call it from quotacheck.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 24 ++++++++++++++++++++++++
 fs/xfs/xfs_buf.h |  1 +
 fs/xfs/xfs_qm.c  |  7 +------
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d7a67d7fbc7f..88f4086308c0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1052,6 +1052,8 @@ void
 xfs_buf_unlock(
 	struct xfs_buf		*bp)
 {
+	ASSERT(xfs_buf_islocked(bp));
+
 	XB_CLEAR_OWNER(bp);
 	up(&bp->b_sema);
 
@@ -1790,6 +1792,28 @@ xfs_alloc_buftarg(
 }
 
 /*
+ * Cancel a delayed write list.
+ *
+ * Remove each buffer from the list, clear the delwri queue flag and drop the
+ * associated buffer reference.
+ */
+void
+xfs_buf_delwri_cancel(
+	struct list_head	*list)
+{
+	struct xfs_buf		*bp;
+
+	while (!list_empty(list)) {
+		bp = list_first_entry(list, struct xfs_buf, b_list);
+
+		xfs_buf_lock(bp);
+		bp->b_flags &= ~_XBF_DELWRI_Q;
+		list_del_init(&bp->b_list);
+		xfs_buf_relse(bp);
+	}
+}
+
+/*
  * Add a buffer to the delayed write list.
  *
  * This queues a buffer for writeout if it hasn't already been.  Note that
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1c2e52b2d926..24da7ed1c787 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -330,6 +330,7 @@ extern void *xfs_buf_offset(struct xfs_buf *, size_t);
 extern void xfs_buf_stale(struct xfs_buf *bp);
 
 /* Delayed Write Buffer Routines */
+extern void xfs_buf_delwri_cancel(struct list_head *);
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
 extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b669b123287b..8b9a9f15f022 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1384,12 +1384,7 @@ xfs_qm_quotacheck(
 	mp->m_qflags |= flags;
 
  error_return:
-	while (!list_empty(&buffer_list)) {
-		struct xfs_buf *bp =
-			list_first_entry(&buffer_list, struct xfs_buf, b_list);
-		list_del_init(&bp->b_list);
-		xfs_buf_relse(bp);
-	}
+	xfs_buf_delwri_cancel(&buffer_list);
 
 	if (error) {
 		xfs_warn(mp,
-- 
2.11.0

