Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D91C7CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 11:31:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07B02AC002
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 09:31:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZybdY1nAjZATpnC0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 09:31:04 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id D11B54A54A
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 16:31:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-33.bos.redhat.com [10.18.41.33])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7MGV3SY002095
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 12:31:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: close xfs_wait_buftarg() race with buffer lookups
Date: Mon, 22 Aug 2016 12:31:01 -0400
Message-Id: <1471883461-27407-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_wait_buftarg() is invoked on unmount and filesystem freeze to drain and
free the buffer LRU. We have reports of filesystem freeze hangs with the
following call chain:

  ->xfs_wait_buftarg()
    ->xfs_log_quiesce()
      ->xfs_quiesce_attr()
        ->xfs_fs_freeze()
          ...

This hang can reproduced with a long enough running fsstress instance
running in parallel with a tight freeze/unfreeze loop. The cause of the
hang is racing b_hold updates between xfs_wait_buftarg() and
_xfs_buf_lookup(). Specifically, buftarg wait path checks whether a
buffer has a >1 b_hold count to determine whether to skip the buffer.
If b_hold == 1, xfs_wait_buftarg_rele() proceeds to prepare the buffer
for the final removal and ultimately calls xfs_buf_rele() to drop the
LRU reference.

The problem is that _xfs_buf_find() can acquire a b_hold reference any
time after xfs_buftarg_wait_rele() has decided it has the only remaining
reference. If this occurs, xfs_wait_buftarg() drops the LRU reference,
but the xfs_buf_rele() instance doesn't actually remove the buffer from
the LRU due to the _xfs_buf_find() hold. At this point b_hold == 1, yet
the buffer is held via the _xfs_buf_find() codepath and still remains on
the LRU. Both call chains will ultimately call xfs_buf_rele() on a
buffer with b_hold == 1. This can have several user facing side effects
such as use after free errors or the freed buffer remaining on the LRU
indefinitely with an underflowed or garbage b_hold count value.

Update xfs_buftarg_wait_rele() to properly synchronize the LRU drain
against buffer lookups. Atomically decrement and lock the perag
associated with the buffer to lock out buffer lookups before
xfs_wait_buftarg() determines whether the LRU holds the final reference.
Open code freeing of the buffer so we can remove it from the perag
rbtree before the perag lock is dropped and guarantee it cannot be
looked up once freeing is imminent. Also update xfs_buftarg_wait_rele()
to drop and reacquire the lru_lock in the correct order to avoid
deadlocks with LRU insertion.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

A couple notes... first is that are several different ways to close this
race. I opted for this approach because xfs_wait_buftarg() is the
slow/less frequent path.

Second, I believe we still have an independent freeze hang upstream due
to an issue with how we use drain_workqueue(). Specifically, I see the
following warning from kernel/workqueue.c:__queue_work():

	if (unlikely(wq->flags & __WQ_DRAINING) &&
	    WARN_ON_ONCE(!is_chained_work(wq)))
		return;

... followed by a hang. I suspect this is due to the ioend work being
dropped and thus never completing the I/O, but I haven't dug into it
yet. For now, I'm testing for hangs with this fix and the above
commented out.

Brian

 fs/xfs/xfs_buf.c | 52 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 607cc29..ce9c419 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1570,24 +1570,48 @@ xfs_buftarg_wait_rele(
 {
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
 	struct list_head	*dispose = arg;
+	struct xfs_perag	*pag = bp->b_pag;
+	int			release;
+
+	/*
+	 * Drop lru_lock to avoid deadlocks with LRU insertion. The required
+	 * lock order to safely isolate a buffer is pag_buf_lock -> b_lock
+	 * -> lru_lock.
+	 */
+	spin_unlock(lru_lock);
 
-	if (atomic_read(&bp->b_hold) > 1) {
+	/*
+	 * Atomically decrement and lock the perag to synchronize against buffer
+	 * lookups. We unconditionally decrement because a check for b_hold == 1
+	 * alone is not sufficient. _xfs_buf_find() can acquire a reference
+	 * immediately after the check.
+	 */
+	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
+	if (!release) {
 		/* need to wait, so skip it this pass */
 		trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
-		return LRU_SKIP;
+		goto skip_buf;
 	}
-	if (!spin_trylock(&bp->b_lock))
-		return LRU_SKIP;
+	if (!spin_trylock(&bp->b_lock)) {
+		spin_unlock(&pag->pag_buf_lock);
+		goto skip_buf;
+	}
+	spin_lock(lru_lock);
+
+	/* remove from the rbtree to prevent further lookups */
+	rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
+	spin_unlock(&pag->pag_buf_lock);
 
-	/*
-	 * clear the LRU reference count so the buffer doesn't get
-	 * ignored in xfs_buf_rele().
-	 */
-	atomic_set(&bp->b_lru_ref, 0);
 	bp->b_state |= XFS_BSTATE_DISPOSE;
 	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lock);
 	return LRU_REMOVED;
+
+skip_buf:
+	/* skipping the buf, put back the LRU hold */
+	atomic_inc(&bp->b_hold);
+	spin_lock(lru_lock);
+	return LRU_SKIP;
 }
 
 void
@@ -1629,7 +1653,15 @@ xfs_wait_buftarg(
 				xfs_alert(btp->bt_mount,
 "Please run xfs_repair to determine the extent of the problem.");
 			}
-			xfs_buf_rele(bp);
+
+			/*
+			 * The buffer has already been removed from the rbtree
+			 * and had the last reference dropped. Drop the perag
+			 * reference and free it.
+			 */
+			ASSERT(atomic_read(&bp->b_hold) == 0);
+			xfs_perag_put(bp->b_pag);
+			xfs_buf_free(bp);
 		}
 		if (loop++ != 0)
 			delay(100);
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
