Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61327C433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 23:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D95B610A0
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 23:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhECX0h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 19:26:37 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:50673 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhECX0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 May 2021 19:26:37 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id D671E1B0592;
        Tue,  4 May 2021 09:25:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ldhwZ-002Abq-GJ; Tue, 04 May 2021 09:25:39 +1000
Date:   Tue, 4 May 2021 09:25:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <20210503232539.GI63242@dread.disaster.area>
References: <20210503121816.561340-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503121816.561340-1-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ssRHpC4-NrAn0sLu64wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 03, 2021 at 08:18:16AM -0400, Brian Foster wrote:
> The special processing used to simulate a buffer I/O failure on fs
> shutdown has a difficult to reproduce race that can result in a use
> after free of the associated buffer. Consider a buffer that has been
> committed to the on-disk log and thus is AIL resident. The buffer
> lands on the writeback delwri queue, but is subsequently locked,
> committed and pinned by another transaction before submitted for
> I/O. At this point, the buffer is stuck on the delwri queue as it
> cannot be submitted for I/O until it is unpinned. A log checkpoint
> I/O failure occurs sometime later, which aborts the bli. The unpin
> handler is called with the aborted log item, drops the bli reference
> count, the pin count, and falls into the I/O failure simulation
> path.
> 
> The potential problem here is that once the pin count falls to zero
> in ->iop_unpin(), xfsaild is free to retry delwri submission of the
> buffer at any time, before the unpin handler even completes. If
> delwri queue submission wins the race to the buffer lock, it
> observes the shutdown state and simulates the I/O failure itself.
> This releases both the bli and delwri queue holds and frees the
> buffer while xfs_buf_item_unpin() sits on xfs_buf_lock() waiting to
> run through the same failure sequence. This problem is rare and
> requires many iterations of fstest generic/019 (which simulates disk
> I/O failures) to reproduce.

You've described the race but not the failure that occurs? I'm going
to guess this is a use-after-free situation or something similar,
but I'm not immediately sure...

> To avoid this problem, hold the buffer across the unpin sequence in
> xfs_buf_item_unpin(). This is a bit unfortunate in that the new hold
> is unconditional while really only necessary for a rare, fatal error
> scenario, but it guarantees the buffer still exists in the off
> chance that the handler attempts to access it.

Ok, so essentially the problem here is that in the case of a
non-stale buffer we can enter xfs_buf_item_unpin() with an unlocked,
buffer that only the bli holds a reference to, and that bli
reference to the can be dropped by a racing IO completion that calls
xfs_buf_item_done()?

i.e. the problem here is that we've dropped the bip->bli_refcount
before we've locked the buffer and taken a reference to it for
the fail path?

OK, I see that xfs_buf_item_done() (called from ioend processing)
simply frees the buf log item and doesn't care about the bli
refcount at all. So the first ioend caller will free the buf log
item regardless of whether there are other references to it at all.

IOWs, once we unpin the buffer, the bli attached to the buffer and
being tracked in the AIL has -zero- references to the bli and so it
gets freed unconditionally on IO completion.

That seems to the be the problem here - the bli is not reference
counted while it is the AIL....

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This is a patch I've had around for a bit for a very rare corner case I
> was able to reproduce in some past testing. I'm sending this as RFC
> because I'm curious if folks have any thoughts on the approach. I'd be
> Ok with this change as is, but I think there are alternatives available
> too. We could do something fairly simple like bury the hold in the
> remove (abort) case only, or perhaps consider checking IN_AIL state
> before the pin count drops and base on that (though that seems a bit
> more fragile to me). Thoughts?
> 
> Brian
> 
>  fs/xfs/xfs_buf_item.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index fb69879e4b2b..a1ad6901eb15 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -504,6 +504,7 @@ xfs_buf_item_unpin(
>  
>  	freed = atomic_dec_and_test(&bip->bli_refcount);
>  
> +	xfs_buf_hold(bp);
>  	if (atomic_dec_and_test(&bp->b_pin_count))
>  		wake_up_all(&bp->b_waiters);
>  
> @@ -560,6 +561,7 @@ xfs_buf_item_unpin(
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
>  	}
> +	xfs_buf_rele(bp);
>  }

Ok, so we take an extra reference for the xfs_buf_ioend_fail()
path because we've exposed the code running here to the bli
reference to the buffer being dropped at any point after the wakeup
due to IO completion being run by another party.

Yup, seems like the bli_refcount scope needs to be expanded here.

Seems to me that we need to change how and where we drop the buf log
item reference count so the reference to the buffer it owns isn't
dropped until -after- we process the IO failure case.

Something like the patch below (completely untested!), perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: extend bli_refcount to cover the AIL and IO

From: Dave Chinner <dchinner@redhat.com>

Untested.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 207 +++++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 120 insertions(+), 88 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index fb69879e4b2b..a0fa0f16d8c7 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -73,6 +73,32 @@ xfs_buf_item_straddle(
 	return false;
 }
 
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_zone, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf	*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /*
  * This returns the number of log iovecs needed to log the
  * given buf log item.
@@ -502,56 +528,26 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	freed = atomic_dec_and_test(&bip->bli_refcount);
-
+	/*
+	 * We can wake pin waiters safely now because we still hold the
+	 * bli_refcount that was taken when the pin was gained.
+	 */
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	if (freed && stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-
-		trace_xfs_buf_item_unpin_stale(bip);
-
-		if (remove) {
-			/*
-			 * If we are in a transaction context, we have to
-			 * remove the log item from the transaction as we are
-			 * about to release our reference to the buffer.  If we
-			 * don't, the unlock that occurs later in
-			 * xfs_trans_uncommit() will try to reference the
-			 * buffer which we no longer have a hold on.
-			 */
-			if (!list_empty(&lip->li_trans))
-				xfs_trans_del_item(lip);
-
-			/*
-			 * Since the transaction no longer refers to the buffer,
-			 * the buffer should no longer refer to the transaction.
-			 */
-			bp->b_transp = NULL;
+	if (!stale) {
+		if (!remove) {
+			/* Nothing to do but drop the refcount the pin owned. */
+			atomic_dec(&bip->bli_refcount);
+			return;
 		}
 
 		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
-			ASSERT(bp->b_log_item == NULL);
-		}
-		xfs_buf_relse(bp);
-	} else if (freed && remove) {
-		/*
+		 * Fail the IO before we drop the bli refcount. This guarantees
+		 * that a racing writeback completion also failing the buffer
+		 * and running completion will not remove the last reference to
+		 * the bli and free it from under us.
+		 *
 		 * The buffer must be locked and held by the caller to simulate
 		 * an async I/O failure.
 		 */
@@ -559,7 +555,62 @@ xfs_buf_item_unpin(
 		xfs_buf_hold(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		xfs_buf_item_relse(bp);
+		return;
 	}
+
+	/*
+	 * Stale buffer - only process it if this is the last reference to the
+	 * BLI. If this is the last BLI reference, then the buffer will be
+	 * locked and have two references - once from the transaction commit and
+	 * one from the BLI - and we do not unlock and release transaction
+	 * reference until we've finished cleaning up the BLI.
+	 */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		return;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+
+	trace_xfs_buf_item_unpin_stale(bip);
+
+	if (remove) {
+		/*
+		 * If we are in a transaction context, we have to
+		 * remove the log item from the transaction as we are
+		 * about to release our reference to the buffer.  If we
+		 * don't, the unlock that occurs later in
+		 * xfs_trans_uncommit() will try to reference the
+		 * buffer which we no longer have a hold on.
+		 */
+		if (!list_empty(&lip->li_trans))
+			xfs_trans_del_item(lip);
+
+		/*
+		 * Since the transaction no longer refers to the buffer,
+		 * the buffer should no longer refer to the transaction.
+		 */
+		bp->b_transp = NULL;
+	}
+
+	/*
+	 * If we get called here because of an IO error, we may or may
+	 * not have the item on the AIL. xfs_trans_ail_delete() will
+	 * take care of that situation. xfs_trans_ail_delete() drops
+	 * the AIL lock.
+	 */
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+	} else {
+		xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+		xfs_buf_item_relse(bp);
+		ASSERT(bp->b_log_item == NULL);
+	}
+	xfs_buf_relse(bp);
 }
 
 STATIC uint
@@ -720,22 +771,24 @@ xfs_buf_item_committing(
 }
 
 /*
- * This is called to find out where the oldest active copy of the
- * buf log item in the on disk log resides now that the last log
- * write of it completed at the given lsn.
- * We always re-log all the dirty data in a buffer, so usually the
- * latest copy in the on disk log is the only one that matters.  For
- * those cases we simply return the given lsn.
+ * The item is about to be inserted into the AIL. If it is not already in the
+ * AIL, we need to take a reference to the BLI for the AIL. This "AIL reference"
+ * will be held until the item is removed from the AIL.
+ *
+ * This is called to find out where the oldest active copy of the buf log item
+ * in the on disk log resides now that the last log write of it completed at the
+ * given lsn.  We always re-log all the dirty data in a buffer, so usually the
+ * latest copy in the on disk log is the only one that matters.  For those cases
+ * we simply return the given lsn.
  *
- * The one exception to this is for buffers full of newly allocated
- * inodes.  These buffers are only relogged with the XFS_BLI_INODE_BUF
- * flag set, indicating that only the di_next_unlinked fields from the
- * inodes in the buffers will be replayed during recovery.  If the
- * original newly allocated inode images have not yet been flushed
- * when the buffer is so relogged, then we need to make sure that we
- * keep the old images in the 'active' portion of the log.  We do this
- * by returning the original lsn of that transaction here rather than
- * the current one.
+ * The one exception to this is for buffers full of newly allocated inodes.
+ * These buffers are only relogged with the XFS_BLI_INODE_BUF flag set,
+ * indicating that only the di_next_unlinked fields from the inodes in the
+ * buffers will be replayed during recovery.  If the original newly allocated
+ * inode images have not yet been flushed when the buffer is so relogged, then
+ * we need to make sure that we keep the old images in the 'active' portion of
+ * the log.  We do this by returning the original lsn of that transaction here
+ * rather than the current one.
  */
 STATIC xfs_lsn_t
 xfs_buf_item_committed(
@@ -746,6 +799,9 @@ xfs_buf_item_committed(
 
 	trace_xfs_buf_item_committed(bip);
 
+	if (!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags))
+		atomic_inc(&bli->bli_refcount);
+
 	if ((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) && lip->li_lsn != 0)
 		return lip->li_lsn;
 	return lsn;
@@ -1009,36 +1065,12 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_zone, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
@@ -1051,8 +1083,9 @@ xfs_buf_item_done(
 	 * Note that log recovery writes might have buffer items that are not on
 	 * the AIL even when the file system is not shut down.
 	 */
-	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
+	xfs_trans_ail_delete(&bip->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+
+	xfs_buf_item_put(bp);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 50aa0f5ef959..e3ccbf3ca801 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,7 +51,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
