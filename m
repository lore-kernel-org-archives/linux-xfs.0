Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B295C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 12:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39F42611CE
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 12:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhECMTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 08:19:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhECMTN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 May 2021 08:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620044299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1M3TL/ENh7inMcV/3kFYJgopO+Di9gLXwMh5L/FD00Q=;
        b=BG190kGI4ui9iLVliTcgI4fb1O16TLBkWqQKiZwFYN/xCvB7J+cKD4guX40i6KelYcO6B4
        KzznDHliJWYJLdD98HFHLOPkrPvlbsgbcGaWhzA61JVQc7g6YRhij+0hBH72/q7+gyMKgJ
        1mOo+LyRsX+/8868QbmxW778B5g0Gpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-op_efiVXPcOiqa4rpwvqCA-1; Mon, 03 May 2021 08:18:17 -0400
X-MC-Unique: op_efiVXPcOiqa4rpwvqCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5745803622
        for <linux-xfs@vger.kernel.org>; Mon,  3 May 2021 12:18:16 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9C3B60C4A
        for <linux-xfs@vger.kernel.org>; Mon,  3 May 2021 12:18:16 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC] xfs: hold buffer across unpin and potential shutdown processing
Date:   Mon,  3 May 2021 08:18:16 -0400
Message-Id: <20210503121816.561340-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

To avoid this problem, hold the buffer across the unpin sequence in
xfs_buf_item_unpin(). This is a bit unfortunate in that the new hold
is unconditional while really only necessary for a rare, fatal error
scenario, but it guarantees the buffer still exists in the off
chance that the handler attempts to access it.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is a patch I've had around for a bit for a very rare corner case I
was able to reproduce in some past testing. I'm sending this as RFC
because I'm curious if folks have any thoughts on the approach. I'd be
Ok with this change as is, but I think there are alternatives available
too. We could do something fairly simple like bury the hold in the
remove (abort) case only, or perhaps consider checking IN_AIL state
before the pin count drops and base on that (though that seems a bit
more fragile to me). Thoughts?

Brian

 fs/xfs/xfs_buf_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index fb69879e4b2b..a1ad6901eb15 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -504,6 +504,7 @@ xfs_buf_item_unpin(
 
 	freed = atomic_dec_and_test(&bip->bli_refcount);
 
+	xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
@@ -560,6 +561,7 @@ xfs_buf_item_unpin(
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
 	}
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
-- 
2.26.3

