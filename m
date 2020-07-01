Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB54C433E5
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E7A2078A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1W8hXIt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732562AbgGAQv2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31661 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732557AbgGAQvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gEZXTaYMhY7js03Kqs/HmZoIhYoqhW3gtmDpQ/uE3ZI=;
        b=I1W8hXIt5GYAApKycsArbZk8/djluhv1ipNj/K7QG9zeoY+gSFYGD8wcxXKnMVbTpTI7LZ
        FKjLdqlknn2RXByVOlEGl9R1s8j6maDAGh12S6cAK+Ys0CYVvX8vY8nP4pAQGYKelzsQ0r
        bPjne6az4I1+ZzjGSNtekdHqojFcOWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-WKakSgtXMIKPBh7oEqLLFA-1; Wed, 01 Jul 2020 12:51:21 -0400
X-MC-Unique: WKakSgtXMIKPBh7oEqLLFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 917FF800C64
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:20 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C66B5C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 08/10] xfs: buffer relogging support prototype
Date:   Wed,  1 Jul 2020 12:51:14 -0400
Message-Id: <20200701165116.47344-9-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Implement buffer relogging support. There is currently no use case
for buffer relogging. This is for testing and experimental purposes
and serves as an example to demonstrate the ability to relog
arbitrary items in the future, if necessary.

Add helpers to manage relogged buffers, update the buffer log item
push handler to support relogged BLIs and add a log item relog
callback to properly join buffers to the relog transaction. Note
that buffers associated with higher level log items (i.e., inodes
and dquots) are skipped.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c       |  4 +++
 fs/xfs/xfs_buf_item.c  | 60 ++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans.h     |  5 +++-
 fs/xfs/xfs_trans_buf.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 20b748f7e186..eec482204336 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -16,6 +16,8 @@
 #include "xfs_log.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
 
 static kmem_zone_t *xfs_buf_zone;
 
@@ -1500,6 +1502,8 @@ __xfs_buf_submit(
 	trace_xfs_buf_submit(bp, _RET_IP_);
 
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
+	ASSERT(!bp->b_log_item ||
+	       !test_bit(XFS_LI_RELOG, &bp->b_log_item->bli_item.li_flags));
 
 	/* on shutdown we stale and complete the buffer immediately */
 	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9e75e8d6042e..eb827a31b47f 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -16,7 +16,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-
+#include "xfs_log_priv.h"
 
 kmem_zone_t	*xfs_buf_item_zone;
 
@@ -141,7 +141,6 @@ xfs_buf_item_size(
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	int			i;
 
-	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		/*
 		 * The buffer is stale, so all we need to log
@@ -157,7 +156,7 @@ xfs_buf_item_size(
 		return;
 	}
 
-	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
+	ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
 
 	if (bip->bli_flags & XFS_BLI_ORDERED) {
 		/*
@@ -418,6 +417,10 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
+	/* cancel relogging on abort before we drop the bli reference */
+	if (remove)
+		xfs_trans_relog_buf_cancel(NULL, bp);
+
 	freed = atomic_dec_and_test(&bip->bli_refcount);
 
 	if (atomic_dec_and_test(&bp->b_pin_count))
@@ -462,6 +465,13 @@ xfs_buf_item_unpin(
 			list_del_init(&bp->b_li_list);
 			bp->b_iodone = NULL;
 		} else {
+			/* racy */
+			ASSERT(!test_bit(XFS_LI_RELOG_QUEUED, &lip->li_flags));
+			if (test_bit(XFS_LI_RELOG, &lip->li_flags)) {
+				atomic_dec(&bp->b_pin_count);
+				xfs_trans_relog_item_cancel(NULL, lip, true);
+			}
+
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 			ASSERT(bp->b_log_item == NULL);
@@ -488,8 +498,6 @@ xfs_buf_item_push(
 	struct xfs_buf		*bp = bip->bli_buf;
 	uint			rval = XFS_ITEM_SUCCESS;
 
-	if (xfs_buf_ispinned(bp))
-		return XFS_ITEM_PINNED;
 	if (!xfs_buf_trylock(bp)) {
 		/*
 		 * If we have just raced with a buffer being pinned and it has
@@ -503,6 +511,15 @@ xfs_buf_item_push(
 		return XFS_ITEM_LOCKED;
 	}
 
+	/* relog bufs are pinned so check relog state first */
+	if (xfs_item_needs_relog(lip))
+		return XFS_ITEM_RELOG;
+
+	if (xfs_buf_ispinned(bp)) {
+		xfs_buf_unlock(bp);
+		return XFS_ITEM_PINNED;
+	}
+
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 
 	trace_xfs_buf_item_push(bip);
@@ -532,6 +549,7 @@ xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
 	struct xfs_log_item	*lip = &bip->bli_item;
+	struct xfs_buf		*bp = bip->bli_buf;
 	bool			aborted;
 	bool			dirty;
 
@@ -557,8 +575,10 @@ xfs_buf_item_put(
 	 * transaction that invalidated a dirty bli and cleared the dirty
 	 * state.
 	 */
-	if (aborted)
+	if (aborted) {
+		xfs_trans_relog_buf_cancel(NULL, bp);
 		xfs_trans_ail_delete(lip, 0);
+	}
 	xfs_buf_item_relse(bip->bli_buf);
 	return true;
 }
@@ -668,6 +688,28 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
+STATIC void
+xfs_buf_item_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	int			res;
+
+	/*
+	 * Grab a reference to the buffer for the transaction before we join
+	 * and dirty it.
+	 */
+	xfs_buf_hold(bip->bli_buf);
+	xfs_trans_bjoin(tp, bip->bli_buf);
+	xfs_trans_dirty_buf(tp, bip->bli_buf);
+
+	res = xfs_relog_calc_res(lip);
+	tp->t_ticket->t_curr_res += res;
+	tp->t_ticket->t_unit_res += res;
+	tp->t_log_res += res;
+}
+
 static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= xfs_buf_item_size,
 	.iop_format	= xfs_buf_item_format,
@@ -677,6 +719,7 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_committing	= xfs_buf_item_committing,
 	.iop_committed	= xfs_buf_item_committed,
 	.iop_push	= xfs_buf_item_push,
+	.iop_relog	= xfs_buf_item_relog,
 };
 
 STATIC void
@@ -930,6 +973,11 @@ STATIC void
 xfs_buf_item_free(
 	struct xfs_buf_log_item	*bip)
 {
+	ASSERT(!test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags));
+#ifdef DEBUG
+	ASSERT(!atomic64_read(&bip->bli_item.li_relog_res));
+#endif
+
 	xfs_buf_item_free_format(bip);
 	kmem_free(bip->bli_item.li_lv_shadow);
 	kmem_cache_free(xfs_buf_item_zone, bip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7f409b0d456a..0262a883969f 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -243,7 +243,7 @@ xfs_relog_calc_res(
 	 * xfs_log_calc_unit_res().
 	 */
 	lip->li_ops->iop_size(lip, &niovecs, &nbytes);
-	ASSERT(niovecs == 1);
+	ASSERT(niovecs == 1 || lip->li_type == XFS_LI_BUF);
 
 	nbytes += niovecs * sizeof(xlog_op_header_t);
 	nbytes = xfs_log_calc_unit_res(lip->li_mountp, nbytes);
@@ -262,6 +262,9 @@ void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
+bool		xfs_trans_relog_buf(struct xfs_trans *, struct xfs_buf *);
+void		xfs_trans_relog_buf_cancel(struct xfs_trans *,
+					   struct xfs_buf *);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 08174ffa2118..b5b552a4bcfb 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -588,6 +588,8 @@ xfs_trans_binval(
 		return;
 	}
 
+	/* return relog res before we reset dirty state */
+	xfs_trans_relog_buf_cancel(tp, bp);
 	xfs_buf_stale(bp);
 
 	bip->bli_flags |= XFS_BLI_STALE;
@@ -787,3 +789,67 @@ xfs_trans_dquot_buf(
 
 	xfs_trans_buf_set_type(tp, bp, type);
 }
+
+/*
+ * Enable automatic relogging on a buffer. This essentially pins a dirty buffer
+ * in-core until relogging is disabled.
+ */
+bool
+xfs_trans_relog_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	enum xfs_blft		blft;
+
+	ASSERT(xfs_buf_islocked(bp));
+
+	if (bip->bli_flags & (XFS_BLI_ORDERED|XFS_BLI_STALE))
+		return false;
+	/*
+	 * Don't bother with queued buffers since we're about to pin it for an
+	 * indeterminate amount of time and we don't want the responsibility of
+	 * failing it if an abort happens to remove it from the AIL.
+	 */
+	if (bp->b_flags & _XBF_DELWRI_Q)
+		return false;
+
+	/*
+	 * Skip buffers with higher level log items. Those items must be
+	 * relogged directly to move in the log.
+	 */
+	blft = xfs_blft_from_flags(&bip->__bli_format);
+	switch (blft) {
+	case XFS_BLFT_DINO_BUF:
+	case XFS_BLFT_UDQUOT_BUF:
+	case XFS_BLFT_PDQUOT_BUF:
+	case XFS_BLFT_GDQUOT_BUF:
+		return false;
+	default:
+		break;
+	}
+
+	/*
+	 * Relog expects a worst case reservation from ->iop_size. Hack that in
+	 * here by logging the entire buffer in this transaction. Also grab a
+	 * buffer pin to prevent it from being written out.
+	 */
+	xfs_buf_item_log(bip, 0, BBTOB(bp->b_length) - 1);
+	atomic_inc(&bp->b_pin_count);
+	xfs_trans_relog_item(tp, &bip->bli_item);
+	return true;
+}
+
+void
+xfs_trans_relog_buf_cancel(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	if (!test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags))
+		return;
+
+	atomic_dec(&bp->b_pin_count);
+	xfs_trans_relog_item_cancel(tp, &bip->bli_item, false);
+}
-- 
2.21.3

