Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54579 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbdIQVHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:14 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/47] xfs: push buffer of flush locked dquot to avoid quotacheck deadlock
Date: Sun, 17 Sep 2017 14:06:28 -0700
Message-Id: <20170917210712.10804-4-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 7912e7fef2aebe577f0b46d3cba261f2783c5695 upstream.

Reclaim during quotacheck can lead to deadlocks on the dquot flush
lock:

 - Quotacheck populates a local delwri queue with the physical dquot
   buffers.
 - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and
   dirties all of the dquots.
 - Reclaim kicks in and attempts to flush a dquot whose buffer is
   already queud on the quotacheck queue. The flush succeeds but
   queueing to the reclaim delwri queue fails as the backing buffer is
   already queued. The flush unlock is now deferred to I/O completion
   of the buffer from the quotacheck queue.
 - The dqadjust bulkstat continues and dirties the recently flushed
   dquot once again.
 - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires
   the flush lock to update the backing buffers with the in-core
   recalculated values. It deadlocks on the redirtied dquot as the
   flush lock was already acquired by reclaim, but the buffer resides
   on the local delwri queue which isn't submitted until the end of
   quotacheck.

This is reproduced by running quotacheck on a filesystem with a
couple million inodes in low memory (512MB-1GB) situations. This is
a regression as of commit 43ff2122e6 ("xfs: on-stack delayed write
buffer lists"), which removed a trylock and buffer I/O submission
from the quotacheck dquot flush sequence.

Quotacheck first resets and collects the physical dquot buffers in a
delwri queue. Then, it traverses the filesystem inodes via bulkstat,
updates the in-core dquots, flushes the corrected dquots to the
backing buffers and finally submits the delwri queue for I/O. Since
the backing buffers are queued across the entire quotacheck
operation, dquot reclaim cannot possibly complete a dquot flush
before quotacheck completes.

Therefore, quotacheck must submit the buffer for I/O in order to
cycle the flush lock and flush the dirty in-core dquot to the
buffer. Add a delwri queue buffer push mechanism to submit an
individual buffer for I/O without losing the delwri queue status and
use it from quotacheck to avoid the deadlock. This restores
quotacheck behavior to as before the regression was introduced.

Reported-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_qm.c    | 28 ++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h |  1 +
 4 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 24940dd3baa8..eca7baecc9f0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2022,6 +2022,66 @@ xfs_buf_delwri_submit(
 	return error;
 }
 
+/*
+ * Push a single buffer on a delwri queue.
+ *
+ * The purpose of this function is to submit a single buffer of a delwri queue
+ * and return with the buffer still on the original queue. The waiting delwri
+ * buffer submission infrastructure guarantees transfer of the delwri queue
+ * buffer reference to a temporary wait list. We reuse this infrastructure to
+ * transfer the buffer back to the original queue.
+ *
+ * Note the buffer transitions from the queued state, to the submitted and wait
+ * listed state and back to the queued state during this call. The buffer
+ * locking and queue management logic between _delwri_pushbuf() and
+ * _delwri_queue() guarantee that the buffer cannot be queued to another list
+ * before returning.
+ */
+int
+xfs_buf_delwri_pushbuf(
+	struct xfs_buf		*bp,
+	struct list_head	*buffer_list)
+{
+	LIST_HEAD		(submit_list);
+	int			error;
+
+	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+
+	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
+
+	/*
+	 * Isolate the buffer to a new local list so we can submit it for I/O
+	 * independently from the rest of the original list.
+	 */
+	xfs_buf_lock(bp);
+	list_move(&bp->b_list, &submit_list);
+	xfs_buf_unlock(bp);
+
+	/*
+	 * Delwri submission clears the DELWRI_Q buffer flag and returns with
+	 * the buffer on the wait list with an associated reference. Rather than
+	 * bounce the buffer from a local wait list back to the original list
+	 * after I/O completion, reuse the original list as the wait list.
+	 */
+	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
+
+	/*
+	 * The buffer is now under I/O and wait listed as during typical delwri
+	 * submission. Lock the buffer to wait for I/O completion. Rather than
+	 * remove the buffer from the wait list and release the reference, we
+	 * want to return with the buffer queued to the original list. The
+	 * buffer already sits on the original list with a wait list reference,
+	 * however. If we let the queue inherit that wait list reference, all we
+	 * need to do is reset the DELWRI_Q flag.
+	 */
+	xfs_buf_lock(bp);
+	error = bp->b_error;
+	bp->b_flags |= _XBF_DELWRI_Q;
+	xfs_buf_unlock(bp);
+
+	return error;
+}
+
 int __init
 xfs_buf_init(void)
 {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index ad514a8025dd..f961b19b9cc2 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -333,6 +333,7 @@ extern void xfs_buf_delwri_cancel(struct list_head *);
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
 extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
+extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
 
 /* Buffer Daemon Setup Routines */
 extern int xfs_buf_init(void);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8b9a9f15f022..8068867a8183 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1247,6 +1247,7 @@ xfs_qm_flush_one(
 	struct xfs_dquot	*dqp,
 	void			*data)
 {
+	struct xfs_mount	*mp = dqp->q_mount;
 	struct list_head	*buffer_list = data;
 	struct xfs_buf		*bp = NULL;
 	int			error = 0;
@@ -1257,7 +1258,32 @@ xfs_qm_flush_one(
 	if (!XFS_DQ_IS_DIRTY(dqp))
 		goto out_unlock;
 
-	xfs_dqflock(dqp);
+	/*
+	 * The only way the dquot is already flush locked by the time quotacheck
+	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
+	 * it for the final time. Quotacheck collects all dquot bufs in the
+	 * local delwri queue before dquots are dirtied, so reclaim can't have
+	 * possibly queued it for I/O. The only way out is to push the buffer to
+	 * cycle the flush lock.
+	 */
+	if (!xfs_dqflock_nowait(dqp)) {
+		/* buf is pinned in-core by delwri list */
+		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
+				      mp->m_quotainfo->qi_dqchunklen);
+		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
+		if (!bp) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+		xfs_buf_unlock(bp);
+
+		xfs_buf_delwri_pushbuf(bp, buffer_list);
+		xfs_buf_rele(bp);
+
+		error = -EAGAIN;
+		goto out_unlock;
+	}
+
 	error = xfs_qm_dqflush(dqp, &bp);
 	if (error)
 		goto out_unlock;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 828f383df121..2df73f3a73c1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -366,6 +366,7 @@ DEFINE_BUF_EVENT(xfs_buf_iowait_done);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
 DEFINE_BUF_EVENT(xfs_buf_delwri_split);
+DEFINE_BUF_EVENT(xfs_buf_delwri_pushbuf);
 DEFINE_BUF_EVENT(xfs_buf_get_uncached);
 DEFINE_BUF_EVENT(xfs_bdstrat_shut);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
-- 
2.14.1

