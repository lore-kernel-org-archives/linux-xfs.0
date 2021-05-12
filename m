Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3736C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD7C61412
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhELObh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 10:31:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230446AbhELObf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 10:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620829827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HatySM4rC2bpY4D46RqhQoYsTcO2zeHNqk5Sud7tD4U=;
        b=HG4jFN1K9WOLiZyPAjvYw5pwbMfIZhRxjkBaSfsohPjbaQXbPsNQaRqnhqDrH87ZHDkKFT
        5pGd6i1WLP31+satvWwU0ieS9LfRFfxpxVYUV6DaHZj4iivUzlxgrIKXJ0fav8mU01+CN6
        6OXyP0NpeVW405YxMEFDNdbUM3CkwUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-oo1OgA7YPCqKfiytW7uw0A-1; Wed, 12 May 2021 10:30:25 -0400
X-MC-Unique: oo1OgA7YPCqKfiytW7uw0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 680FD800D62
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 14:30:24 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-80.rdu2.redhat.com [10.10.113.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FBBE63BA7
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 14:30:24 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 2/2] xfs: remove dead stale buf unpin handling code
Date:   Wed, 12 May 2021 10:30:23 -0400
Message-Id: <20210512143023.929429-1-bfoster@redhat.com>
In-Reply-To: <20210511135257.878743-3-bfoster@redhat.com>
References: <20210511135257.878743-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This code goes back to a time when transaction commits wrote
directly to iclogs. The associated log items were pinned, written to
the log, and then "uncommitted" if some part of the log write had
failed. This uncommit sequence called an ->iop_unpin_remove()
handler that was eventually folded into ->iop_unpin() via the remove
parameter. The log subsystem has since changed significantly in that
transactions commit to the CIL instead of direct to iclogs, though
log items must still be aborted in the event of an eventual log I/O
error. However, the context for a log item abort is now asynchronous
from transaction commit, which means the committing transaction has
been freed by this point in time and the transaction uncommit
sequence of events is no longer relevant.

Further, since stale buffers remain locked at transaction commit
through unpin, we can be certain that the buffer is not associated
with any transaction when the unpin callback executes. Remove this
unused hunk of code and replace it with an assertion that the buffer
is disassociated from transaction context.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7ff31788512b..672112064dac 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -517,28 +517,11 @@ xfs_buf_item_unpin(
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(list_empty(&lip->li_trans));
+		ASSERT(!bp->b_transp);
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
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
-		}
-
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
-- 
2.26.3

