Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7EDC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 08:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EAB1207DA
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 08:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iFr4x1Fo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbgEWIs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 04:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387471AbgEWIs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 04:48:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A188AC061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 01:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oeIEXPWg7rQ6tw6EVyHEjVzRy32xAa6fGxbIUgMuPaE=; b=iFr4x1FoVvLyNhta62VXDp5ozn
        hm9W4rkNO9FfBTWzOZ1l1nSQliYlN4O3Ax9KAq24ff5mjTgBinTcGZtZ2PrIKyoxVht+9jP6gRlc5
        99k5fIM2Wv4k8r6psiMch5AcQWQbm3TRiNiyU3A2mvPztgA/3A+7icS2H0S4IcLzePtvTMfTQg1uC
        iQ1j8nimA51Q6W3g9reCnl/7WgsogOwvDOH18CqHRMGByzWsR0n/XmKGizoL3REOgyO7uz+biBSmA
        ILBcET4E0JKG2n7gPV0QryMM/qTGHdhKNlSLlCeKO//wiRG8ifQxShfxH094VpikQuWKMMjQcvAui
        Scx926KA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcPpT-0000lz-Gz; Sat, 23 May 2020 08:48:27 +0000
Date:   Sat, 23 May 2020 01:48:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/24] xfs: mark inode buffers in cache
Message-ID: <20200523084827.GB31566@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
> 
> This is largely a rearrangement of the code at this point - no IO
> completion functionality changes at this point, just how the
> code is run is modified.

So I've looked over the whole series where this leads, and I really like
killing off li_cb and sorting out the mess around b_iodone.  But I think
the series ends up moving too much out of xfs_buf.c.  I'd rather keep
a minimal b_write_done callback rather than the checking of the inode
and dquote flags, and keep most of the logic in xfs_buf.c.  This is the
patch I cooked up on top of your series to show what I mean - it removes
the need for both flags and kills about 100 lines of code:


diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index e5f58a4b13eee..4220fee1c9ddb 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -169,7 +169,7 @@ xfs_trans_log_inode(
 		xfs_buf_hold(bp);
 		spin_lock(&iip->ili_lock);
 		iip->ili_item.li_buf = bp;
-		bp->b_flags |= _XBF_INODES;
+		bp->b_write_done = xfs_iflush_done;
 		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
 		xfs_trans_brelse(tp, bp);
 	}
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5fc83637f7aff..b1c3d8076d52d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1172,11 +1172,7 @@ xfs_buf_wait_unpin(
 	set_current_state(TASK_RUNNING);
 }
 
-/*
- *	Buffer Utility Routines
- */
-
-void
+static void
 xfs_buf_ioend(
 	struct xfs_buf	*bp)
 {
@@ -1198,38 +1194,41 @@ xfs_buf_ioend(
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
-		xfs_buf_ioend_finish(bp);
-		return;
-	}
-
-	if (!bp->b_error) {
-		bp->b_flags &= ~XBF_WRITE_FAIL;
-		bp->b_flags |= XBF_DONE;
-	}
-
-	/*
-	 * If this is a log recovery buffer, we aren't doing transactional IO
-	 * yet so we need to let it handle IO completions.
-	 */
-	if (bp->b_flags & _XBF_LOGRCVY) {
+	} else if (unlikely(bp->b_flags & _XBF_LOGRCVY)) {
 		xlog_recover_iodone(bp);
-		return;
-	}
-
-	/* inodes always have a callback on write */
-	if (bp->b_flags & _XBF_INODES) {
-		xfs_buf_inode_iodone(bp);
-		return;
-	}
+	} else {
+		/*
+		 * If there is an error, process it. Some errors require us to
+		 * run callbacks after failure processing is done so we detect
+		 * that and take appropriate action.
+		 */
+		if (bp->b_error) {
+			if (xfs_buf_iodone_callback_error(bp))
+				return;
+		} else {
+			bp->b_flags &= ~XBF_WRITE_FAIL;
+			bp->b_flags |= XBF_DONE;
+		}
 
-	/* dquots always have a callback on write */
-	if (bp->b_flags & _XBF_DQUOTS) {
-		xfs_buf_dquot_iodone(bp);
-		return;
+		/*
+		 * Successful IO or permanent error. Either way, we can clear
+		 * the retry state here in preparation for the next error that
+		 * may occur.
+		 */
+		bp->b_last_error = 0;
+		bp->b_retries = 0;
+		bp->b_first_retry_time = 0;
+
+		if (bp->b_write_done)
+			bp->b_write_done(bp);
+		if (bp->b_log_item)
+			xfs_buf_item_done(bp);
 	}
 
-	/* dirty buffers always need to be removed from the AIL */
-	xfs_buf_dirty_iodone(bp);
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_relse(bp);
+	else
+		complete(&bp->b_iowait);
 }
 
 static void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a127d56d5eff0..a060d8bfeb515 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -32,9 +32,7 @@ struct xfs_buf;
 #define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
 
 /* buffer type flags for write callbacks */
-#define _XBF_INODES	 (1 << 16)/* inode buffer */
-#define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
-#define _XBF_LOGRCVY	 (1 << 18)/* log recovery buffer */
+#define _XBF_LOGRCVY	(1 << 18)/* log recovery buffer */
 
 /* flags used only internally */
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
@@ -57,8 +55,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
-	{ _XBF_INODES,		"INODES" }, \
-	{ _XBF_DQUOTS,		"DQUOTS" }, \
 	{ _XBF_LOGRCVY,		"LOG_RECOVERY" }, \
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
@@ -156,6 +152,7 @@ typedef struct xfs_buf {
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_ioend_work;
+	void 			(*b_write_done)(struct xfs_buf *bp);
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
@@ -262,23 +259,8 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 #define xfs_buf_islocked(bp) \
 	((bp)->b_sema.count <= 0)
 
-static inline void xfs_buf_relse(xfs_buf_t *bp)
-{
-	xfs_buf_unlock(bp);
-	xfs_buf_rele(bp);
-}
-
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_buf *bp);
-extern void xfs_buf_ioend(struct xfs_buf *bp);
-static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
-{
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-	else
-		complete(&bp->b_iowait);
-}
-
 extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
@@ -343,6 +325,12 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 	return atomic_read(&bp->b_pin_count);
 }
 
+static inline void xfs_buf_relse(xfs_buf_t *bp)
+{
+	xfs_buf_unlock(bp);
+	xfs_buf_rele(bp);
+}
+
 static inline int
 xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 {
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d855a2b7486c5..21b0d2f3f1af9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -15,9 +15,6 @@
 #include "xfs_buf_item.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
-#include "xfs_quota.h"
-#include "xfs_dquot_item.h"
-#include "xfs_dquot.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
@@ -30,8 +27,6 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
-static void xfs_buf_item_done(struct xfs_buf *bp);
-
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -986,7 +981,7 @@ xfs_buf_do_callbacks_fail(
 	spin_unlock(&ailp->ail_lock);
 }
 
-static bool
+bool
 xfs_buf_iodone_callback_error(
 	struct xfs_buf		*bp)
 {
@@ -1075,38 +1070,12 @@ xfs_buf_iodone_callback_error(
 	return false;
 }
 
-static inline bool
-xfs_buf_had_callback_errors(
-	struct xfs_buf		*bp)
-{
-
-	/*
-	 * If there is an error, process it. Some errors require us to run
-	 * callbacks after failure processing is done so we detect that and take
-	 * appropriate action.
-	 */
-	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
-		return true;
-
-	/*
-	 * Successful IO or permanent error. Either way, we can clear the
-	 * retry state here in preparation for the next error that may occur.
-	 */
-	bp->b_last_error = 0;
-	bp->b_retries = 0;
-	bp->b_first_retry_time = 0;
-	return false;
-}
-
-static void
+void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!bip)
-		return;
-
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
@@ -1121,52 +1090,3 @@ xfs_buf_item_done(
 	xfs_buf_item_free(bip);
 	xfs_buf_rele(bp);
 }
-
-/*
- * Inode buffer iodone callback function.
- */
-void
-xfs_buf_inode_iodone(
-	struct xfs_buf		*bp)
-{
-	if (xfs_buf_had_callback_errors(bp))
-		return;
-
-	xfs_buf_item_done(bp);
-	xfs_iflush_done(bp);
-	xfs_buf_ioend_finish(bp);
-}
-
-/*
- * Dquot buffer iodone callback function.
- */
-void
-xfs_buf_dquot_iodone(
-	struct xfs_buf		*bp)
-{
-	if (xfs_buf_had_callback_errors(bp))
-		return;
-
-	/* a newly allocated dquot buffer might have a log item attached */
-	xfs_buf_item_done(bp);
-	xfs_dquot_done(bp);
-	xfs_buf_ioend_finish(bp);
-}
-
-/*
- * Dirty buffer iodone callback function.
- *
- * Note that for things like remote attribute buffers, there may not be a buffer
- * log item here, so processing the buffer log item must remain be optional.
- */
-void
-xfs_buf_dirty_iodone(
-	struct xfs_buf		*bp)
-{
-	if (xfs_buf_had_callback_errors(bp))
-		return;
-
-	xfs_buf_item_done(bp);
-	xfs_buf_ioend_finish(bp);
-}
-
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index ecfad1915a86b..4ffeabd3ad967 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -54,11 +54,11 @@ void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-void	xfs_buf_inode_iodone(struct xfs_buf *);
-void	xfs_buf_dquot_iodone(struct xfs_buf *);
-void	xfs_buf_dirty_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
+bool	xfs_buf_iodone_callback_error(struct xfs_buf *bp);
+void	xfs_buf_item_done(struct xfs_buf *bp);
+
 extern kmem_zone_t	*xfs_buf_item_zone;
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 34fc1bcb1eefd..55f34c60340c0 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1085,7 +1085,7 @@ xfs_qm_dqflush_done(
 	xfs_dqfunlock(dqp);
 }
 
-void
+static void
 xfs_dquot_done(
 	struct xfs_buf		*bp)
 {
@@ -1194,7 +1194,7 @@ xfs_qm_dqflush(
 	 * Attach the dquot to the buffer so that we can remove this dquot from
 	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
-	bp->b_flags |= _XBF_DQUOTS;
+	bp->b_write_done = xfs_dquot_done;
 	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
 
 	/*
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index f1924288986d3..fe3e46df604b4 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -174,7 +174,6 @@ void		xfs_qm_dqput(struct xfs_dquot *dqp);
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
-void		xfs_dquot_done(struct xfs_buf *);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0aa823aeafca9..5a1dbcde6e9f0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -269,15 +269,15 @@ void
 xlog_recover_iodone(
 	struct xfs_buf	*bp)
 {
-	if (bp->b_error) {
-		/*
-		 * We're not going to bother about retrying
-		 * this during recovery. One strike!
-		 */
-		if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-			xfs_buf_ioerror_alert(bp, __this_address);
-			xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
-		}
+	/*
+	 * We're not going to bother about retrying this during recovery.
+	 * One strike!
+	 */
+	if (!bp->b_error) {
+		bp->b_flags |= XBF_DONE;
+	} else if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
+		xfs_buf_ioerror_alert(bp, __this_address);
+		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 	}
 
 	/*
@@ -288,7 +288,6 @@ xlog_recover_iodone(
 		xfs_buf_item_relse(bp);
 	ASSERT(bp->b_log_item == NULL);
 	bp->b_flags &= ~_XBF_LOGRCVY;
-	xfs_buf_ioend_finish(bp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 11cd666cd99a6..3a2fe19832d89 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -618,7 +618,6 @@ xfs_trans_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_BUF;
-	bp->b_flags |= _XBF_INODES;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
@@ -643,7 +642,6 @@ xfs_trans_stale_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
-	bp->b_flags |= _XBF_INODES;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
@@ -668,7 +666,6 @@ xfs_trans_inode_alloc_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
-	bp->b_flags |= _XBF_INODES;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
@@ -779,6 +776,5 @@ xfs_trans_dquot_buf(
 		break;
 	}
 
-	bp->b_flags |= _XBF_DQUOTS;
 	xfs_trans_buf_set_type(tp, bp, type);
 }
