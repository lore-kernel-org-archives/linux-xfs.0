Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150231.s3cs5lgohxywzj4h@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx1.redhat.com ([209.132.183.28]:44686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbdBXTxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Feb 2017 14:53:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid quotacheck deadlock
Date: Fri, 24 Feb 2017 14:53:20 -0500
Message-Id: <1487966001-63263-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Martin Svec <martin.svec@zoner.cz>

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
---
 fs/xfs/xfs_buf.c   | 37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |  1 +
 fs/xfs/xfs_qm.c    | 28 +++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h |  1 +
 4 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e566510..e97cf56 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2011,6 +2011,43 @@ xfs_buf_delwri_submit(
 	return error;
 }
 
+int
+xfs_buf_delwri_pushbuf(
+	struct xfs_buf		*bp,
+	struct list_head	*buffer_list)
+{
+	LIST_HEAD		(submit_list);
+	int			error;
+
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+
+	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
+
+	/*
+	 * Move the buffer to an empty list and submit. Pass the original list
+	 * as the wait list so delwri submission moves the buf back to it before
+	 * it is submitted (and thus before it is unlocked). This means the
+	 * buffer cannot be placed on another list while we wait for it.
+	 */
+	list_move(&bp->b_list, &submit_list);
+	xfs_buf_unlock(bp);
+
+	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
+
+	/*
+	 * Lock the buffer to wait for I/O completion. It's already held on the
+	 * original list, so all we have to do is reset the delwri queue flag
+	 * that was cleared by delwri submission.
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
index 8a9d3a9..cd74216 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -334,6 +334,7 @@ extern void xfs_buf_stale(struct xfs_buf *bp);
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
 extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
+extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
 
 /* Buffer Daemon Setup Routines */
 extern int xfs_buf_init(void);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 4ff993c..3815ed3 100644
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
+
+		/* delwri_pushbuf drops the buf lock */
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
index fb7555e..c8d28a9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -365,6 +365,7 @@ DEFINE_BUF_EVENT(xfs_buf_iowait_done);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
 DEFINE_BUF_EVENT(xfs_buf_delwri_split);
+DEFINE_BUF_EVENT(xfs_buf_delwri_pushbuf);
 DEFINE_BUF_EVENT(xfs_buf_get_uncached);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
 DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
-- 
2.7.4

