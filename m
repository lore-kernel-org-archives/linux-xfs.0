Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932318AbeFGMl0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 08:41:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6179873C6
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jun 2018 12:41:25 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A1552026DEF
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jun 2018 12:41:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: allow delwri requeue of wait listed buffers
Date: Thu,  7 Jun 2018 08:41:25 -0400
Message-Id: <20180607124125.38700-3-bfoster@redhat.com>
In-Reply-To: <20180607124125.38700-1-bfoster@redhat.com>
References: <20180607124125.38700-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If a delwri queue occurs of a buffer that was previously submitted
from a delwri queue but has not yet been removed from a wait list,
the queue sets _XBF_DELWRI_Q without changing the state of ->b_list.
This occurs, for example, if another thread beats the submitter
thread to the buffer lock after I/O completion. Once the submitter
acquires the lock, it removes the buffer from the wait list and
leaves a buffer with _XBF_DELWRI_Q set but not populated on a list.
This results in a lost buffer submission and in turn can result in
assert failures due to _XBF_DELWRI_Q being set on buffer reclaim or
filesystem lockups if the buffer happens to cover an item in the
AIL.

This problem has been reproduced by repeated iterations of xfs/305
on high CPU count (28xcpu) systems with limited memory (~1GB). Dirty
dquot reclaim races with an xfsaild push of a separate dquot backed
by the same buffer such that the buffer sits on the reclaim wait
list at the time xfsaild attempts to queue it. Since the latter
dquot has been flush locked but the underlying buffer not submitted
for I/O, the dquot pins the AIL and causes the filesystem to
livelock.

To address this problem, allow a delwri queue of a wait listed
buffer to steal the buffer from the wait list and add it to the
associated delwri queue. This is fundamentally safe because the
purpose of the wait list is to provide synchronous I/O. The buffer
lock of each wait listed buffer is cycled to ensure that I/O has
completed. If another thread acquires the buffer lock first, then
the I/O has completed and the submitter lock cycle is a formality.

The tradeoff to this approach is that the submitter loses the
ability to check error state of stolen buffers. This is technically
already possible as once the lock is released there is no guarantee
another thread has not interfered with the buffer error state by the
time the submitter reacquires the lock. Further, most critical error
handling occurs in the iodone callbacks in completion context of the
specific buffer since the delwri submitter has no idea which buffer
failed in the first place. Finally, the stolen buffer case should be
relatively rare and limited to races when under the highly parallel
and low memory conditions described above.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 78 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 912cbbf44db7..ca0520b173c6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1917,6 +1917,8 @@ xfs_buf_delwri_queue(
 	struct xfs_buf		*bp,
 	struct list_head	*list)
 {
+	bool			wait = (bp->b_flags & _XBF_DELWRI_W);
+
 	ASSERT(xfs_buf_islocked(bp));
 	ASSERT(!(bp->b_flags & XBF_READ));
 
@@ -1926,23 +1928,37 @@ xfs_buf_delwri_queue(
 	 * case.
 	 */
 	if (bp->b_flags & _XBF_DELWRI_Q) {
+		ASSERT(!wait);
 		trace_xfs_buf_delwri_queued(bp, _RET_IP_);
 		return false;
 	}
 
 	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
 
+	/*
+	 * If the buffer is on a wait list, the I/O has completed and the
+	 * current thread beat the waiter to the lock. Drop the buffer from the
+	 * wait list and requeue it. The waiter will either see that DELWRI_W is
+	 * cleared or skip waiting on the buffer. The wait list reference is
+	 * reused for the delwri queue.
+	 */
+	if (wait) {
+		bp->b_flags &= ~_XBF_DELWRI_W;
+		list_del_init(&bp->b_list);
+	}
+
 	/*
 	 * If a buffer gets written out synchronously or marked stale while it
 	 * is on a delwri list we lazily remove it. To do this, the other party
 	 * clears the  _XBF_DELWRI_Q flag but otherwise leaves the buffer alone.
-	 * It remains referenced and on the list.  In a rare corner case it
-	 * might get readded to a delwri list after the synchronous writeout, in
-	 * which case we need just need to re-add the flag here.
+	 * It remains referenced and on the list. In a rare corner case it might
+	 * get readded to a delwri list after the synchronous writeout, in which
+	 * case we need just need to re-add the flag here.
 	 */
 	bp->b_flags |= _XBF_DELWRI_Q;
 	if (list_empty(&bp->b_list)) {
-		atomic_inc(&bp->b_hold);
+		if (!wait)
+			atomic_inc(&bp->b_hold);
 		list_add_tail(&bp->b_list, list);
 	}
 
@@ -2082,14 +2098,27 @@ xfs_buf_delwri_submit(
 
 	/* Wait for IO to complete. */
 	while (!list_empty(&wait_list)) {
+		bool release = false;
+
 		bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
-		/* locking the buffer will wait for async IO completion. */
+		/*
+		 * Lock the buffer to wait for async I/O completion. Note that
+		 * somebody else could have requeued the buffer in the meantime.
+		 * That means some buffers might drop from the wait list, but
+		 * that requires the buffer lock and thus means the I/O had
+		 * completed first.
+		 */
 		xfs_buf_lock(bp);
-		bp->b_flags &= ~_XBF_DELWRI_W;
-		list_del_init(&bp->b_list);
+		if (bp->b_flags & _XBF_DELWRI_W) {
+			bp->b_flags &= ~_XBF_DELWRI_W;
+			list_del_init(&bp->b_list);
+			release = true;
+		}
 		error2 = bp->b_error;
-		xfs_buf_relse(bp);
+		xfs_buf_unlock(bp);
+		if (release)
+			xfs_buf_rele(bp);
 		if (!error)
 			error = error2;
 	}
@@ -2120,38 +2149,31 @@ xfs_buf_delwri_pushbuf(
 	LIST_HEAD		(submit_list);
 	int			error;
 
-	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-
 	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
 
 	/*
-	 * Isolate the buffer to a new local list so we can submit it for I/O
-	 * independently from the rest of the original list.
+	 * Make sure the buffer sits on a queue and isolate it to a new local
+	 * list so we can submit it independently from the original list.
 	 */
 	xfs_buf_lock(bp);
+	if (!(bp->b_flags & _XBF_DELWRI_Q) || bp->b_flags & _XBF_DELWRI_W) {
+		xfs_buf_unlock(bp);
+		return 0;
+	}
 	list_move(&bp->b_list, &submit_list);
 	xfs_buf_unlock(bp);
 
 	/*
-	 * Delwri submission clears the DELWRI_Q buffer flag and returns with
-	 * the buffer on the wait list with an associated reference. Rather than
-	 * bounce the buffer from a local wait list back to the original list
-	 * after I/O completion, reuse the original list as the wait list.
+	 * Delwri submission moves the buffer over to the wait list. Reuse the
+	 * original list so there's no need to declare a local wait list.
+	 *
+	 * The buffer most likely still resides on the wait list by the time the
+	 * lock is reacquired. Requeue it just in case somebody else beat us to
+	 * the lock and changed the state.
 	 */
 	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
-
-	/*
-	 * The buffer is now under I/O and wait listed as during typical delwri
-	 * submission. Lock the buffer to wait for I/O completion. Rather than
-	 * remove the buffer from the wait list and release the reference, we
-	 * want to return with the buffer queued to the original list. The
-	 * buffer already sits on the original list with a wait list reference,
-	 * however. If we let the queue inherit that wait list reference, all we
-	 * need to do is reset the DELWRI_Q flag.
-	 */
 	xfs_buf_lock(bp);
-	error = bp->b_error;
-	bp->b_flags |= _XBF_DELWRI_Q;
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_unlock(bp);
 
 	return error;
-- 
2.17.1

