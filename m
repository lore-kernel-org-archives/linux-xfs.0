Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D71C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 13:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD81613E6
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 13:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhEKNyM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 09:54:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231426AbhEKNyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 09:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620741180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAHojY8enyEKHmuTsnKhXp4uixdAInKJzsiy3mlAy4Q=;
        b=Xr6fPC2HANm+ub7vwRFL3TVrN6GhvOBx8sP8INPrF8QuQaUWaArMTCOduI+ma7FFPpfjOb
        XJHuIEG4BVrrGXFrvBiKw+A4qzvg0i2r6E54lDUPABjoOzHfJjY6SkGWWHgsZaiMO+HpmW
        TwN3druZ2NngnwtU+2xEcKnptEfwt2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-RAm-hYcgPSmhc6d-ZtZaaw-1; Tue, 11 May 2021 09:52:59 -0400
X-MC-Unique: RAm-hYcgPSmhc6d-ZtZaaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2327880ED9D
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 13:52:58 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-80.rdu2.redhat.com [10.10.113.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC9E313470
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 13:52:57 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: hold buffer across unpin and potential shutdown processing
Date:   Tue, 11 May 2021 09:52:56 -0400
Message-Id: <20210511135257.878743-2-bfoster@redhat.com>
In-Reply-To: <20210511135257.878743-1-bfoster@redhat.com>
References: <20210511135257.878743-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The special processing used to simulate a buffer I/O failure on fs
shutdown has a difficult to reproduce race that can result in a use
after free of the associated buffer. Consider a buffer that has been
committed to the on-disk log and thus is AIL resident. The buffer
lands on the writeback delwri queue, but is subsequently locked,
committed and pinned by another transaction before submitted for
I/O. At this point, the buffer is stuck on the delwri queue as it
cannot be submitted for I/O until it is unpinned. A log checkpoint
I/O failure occurs sometime later, which aborts the bli. The unpin
handler is called with the aborted log item, drops the bli reference
count, the pin count, and falls into the I/O failure simulation
path.

The potential problem here is that once the pin count falls to zero
in ->iop_unpin(), xfsaild is free to retry delwri submission of the
buffer at any time, before the unpin handler even completes. If
delwri queue submission wins the race to the buffer lock, it
observes the shutdown state and simulates the I/O failure itself.
This releases both the bli and delwri queue holds and frees the
buffer while xfs_buf_item_unpin() sits on xfs_buf_lock() waiting to
run through the same failure sequence. This problem is rare and
requires many iterations of fstest generic/019 (which simulates disk
I/O failures) to reproduce.

To avoid this problem, grab a hold on the buffer before the log item
is unpinned if the associated item has been aborted and will require
a simulated I/O failure. The hold is already required for the
simulated I/O failure, so the ordering simply guarantees the unpin
handler access to the buffer before it is unpinned and thus
processed by the AIL. This particular ordering is required so long
as the AIL does not acquire a reference on the bli, which is the
long term solution to this problem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index fb69879e4b2b..7ff31788512b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -475,17 +475,8 @@ xfs_buf_item_pin(
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log
- * item which was previously pinned with a call to xfs_buf_item_pin().
- *
- * Also drop the reference to the buf item for the current transaction.
- * If the XFS_BLI_STALE flag is set and we are the last reference,
- * then free up the buf log item and unlock the buffer.
- *
- * If the remove flag is set we are called from uncommit in the
- * forced-shutdown path.  If that is true and the reference count on
- * the log item is going to drop to zero we need to free the item's
- * descriptor in the transaction.
+ * This is called to unpin the buffer associated with the buf log item which
+ * was previously pinned with a call to xfs_buf_item_pin().
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -502,12 +493,26 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
+	/*
+	 * Drop the bli ref associated with the pin and grab the hold required
+	 * for the I/O simulation failure in the abort case. We have to do this
+	 * before the pin count drops because the AIL doesn't acquire a bli
+	 * reference. Therefore if the refcount drops to zero, the bli could
+	 * still be AIL resident and the buffer submitted for I/O (and freed on
+	 * completion) at any point before we return. This can be removed once
+	 * the AIL properly holds a reference on the bli.
+	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-
+	if (freed && !stale && remove)
+		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	if (freed && stale) {
+	 /* nothing to do but drop the pin count if the bli is active */
+	if (!freed)
+		return;
+
+	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
@@ -550,13 +555,13 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (freed && remove) {
+	} else if (remove) {
 		/*
 		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure.
+		 * an async I/O failure. We acquired the hold for this case
+		 * before the buffer was unpinned.
 		 */
 		xfs_buf_lock(bp);
-		xfs_buf_hold(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
 	}
-- 
2.26.3

