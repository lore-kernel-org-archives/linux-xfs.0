Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C86C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8099220760
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:49:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zf4z8T8O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgGPKtq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:49:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33063 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbgGPKtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 06:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594896585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+287LbwmY5pA23YCdOhL0CX8xTNKVAcret3YyMDrRxs=;
        b=Zf4z8T8OcGdA+grJP2Ff8To20YSpwoQ0DGi/szi7StkFWuPZKHisOktpWNwZERKysLeNga
        zn0qQzCLYToWe/txg7r2HJM+IA13Pks1iK1PkxSOnlFQd5JF3Cl6T4K+ZngTrmvleYvwQL
        Z0bgwDl44Itn7k+7dv2Al9t1e1tdh3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-XAb_el1hOA-SoypgCuGZHw-1; Thu, 16 Jul 2020 06:49:43 -0400
X-MC-Unique: XAb_el1hOA-SoypgCuGZHw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42E0B1DE1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 10:49:42 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED83B6FED1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 10:49:41 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: drain the buf delwri queue before xfsaild idles
Date:   Thu, 16 Jul 2020 06:49:41 -0400
Message-Id: <20200716104941.32014-1-bfoster@redhat.com>
In-Reply-To: <20200715123835.8690-1-bfoster@redhat.com>
References: <20200715123835.8690-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsaild is racy with respect to transaction abort and shutdown in
that the task can idle or exit with an empty AIL but buffers still
on the delwri queue. This was partly addressed by cancelling the
delwri queue before the task exits to prevent memory leaks, but it's
also possible for xfsaild to empty and idle with buffers on the
delwri queue. For example, a transaction that pins a buffer that
also happens to sit on the AIL delwri queue will explicitly remove
the associated log item from the AIL if the transaction aborts. The
side effect of this is an unmount hang in xfs_wait_buftarg() as the
associated buffers remain held by the delwri queue indefinitely.
This is reproduced on repeated runs of generic/531 with an fs format
(-mrmapbt=1 -bsize=1k) that happens to also reproduce transaction
aborts.

Update xfsaild to not idle until both the AIL and associated delwri
queue are empty and update the push code to continue delwri queue
submission attempts even when the AIL is empty. This allows the AIL
to eventually release aborted buffers stranded on the delwri queue
when they are unlocked by the associated transaction. This should
have no significant effect on normal runtime behavior because the
xfsaild currently idles only when the AIL is empty and in practice
the AIL is rarely empty with a populated delwri queue. The items
must be AIL resident to land in the queue in the first place and
generally aren't removed until writeback completes.

Note that the pre-existing delwri queue cancel logic in the exit
path is retained because task stop is external, could technically
come at any point, and xfsaild is still responsible to release its
buffer references before it exits.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v2:
- Move the out_done label up a bit.
v1: https://lore.kernel.org/linux-xfs/20200715123835.8690-1-bfoster@redhat.com/

 fs/xfs/xfs_trans_ail.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index c3be6e440134..0c783d339675 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -448,16 +448,10 @@ xfsaild_push(
 	target = ailp->ail_target;
 	ailp->ail_target_prev = target;
 
+	/* we're done if the AIL is empty or our push has reached the end */
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
-	if (!lip) {
-		/*
-		 * If the AIL is empty or our push has reached the end we are
-		 * done now.
-		 */
-		xfs_trans_ail_cursor_done(&cur);
-		spin_unlock(&ailp->ail_lock);
+	if (!lip)
 		goto out_done;
-	}
 
 	XFS_STATS_INC(mp, xs_push_ail);
 
@@ -539,6 +533,8 @@ xfsaild_push(
 			break;
 		lsn = lip->li_lsn;
 	}
+
+out_done:
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 
@@ -546,7 +542,6 @@ xfsaild_push(
 		ailp->ail_log_flush++;
 
 	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
-out_done:
 		/*
 		 * We reached the target or the AIL is empty, so wait a bit
 		 * longer for I/O to complete and remove pushed items from the
@@ -638,7 +633,8 @@ xfsaild(
 		 */
 		smp_rmb();
 		if (!xfs_ail_min(ailp) &&
-		    ailp->ail_target == ailp->ail_target_prev) {
+		    ailp->ail_target == ailp->ail_target_prev &&
+		    list_empty(&ailp->ail_buf_list)) {
 			spin_unlock(&ailp->ail_lock);
 			freezable_schedule();
 			tout = 0;
-- 
2.21.3

