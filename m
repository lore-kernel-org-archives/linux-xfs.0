Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFBCC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 12:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C9F20658
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 12:38:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dCDSQCXj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgGOMil (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 08:38:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32905 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727790AbgGOMil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 08:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594816719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SSx8NAFyGmGqKqEUZOTlD2x0R5T2nXpEts1JsENr6qA=;
        b=dCDSQCXjzB9iSmw+59O4SoqJ875Ty/dZ3+M3mkEGxvEzmvaKMcllSa9t2XDhimOI23urEa
        W/Q1lxkGkVHjIANNwfXRe5LklPN56eFd0aczZ+AvrHo+1Ol4bXt7K+EMErKODwzD3v9aZl
        BYAHs5W/qNuH6uVOcyKt1ADuwaMBFyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-t48YnuJaP-mzOKmFq8qUxg-1; Wed, 15 Jul 2020 08:38:37 -0400
X-MC-Unique: t48YnuJaP-mzOKmFq8qUxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C802194094F
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 12:38:36 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 486B661983
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 12:38:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: drain the buf delwri queue before xfsaild idles
Date:   Wed, 15 Jul 2020 08:38:35 -0400
Message-Id: <20200715123835.8690-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
---
 fs/xfs/xfs_trans_ail.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index c3be6e440134..6a6a79791fbb 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -542,11 +542,11 @@ xfsaild_push(
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
 
+out_done:
 	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
 		ailp->ail_log_flush++;
 
 	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
-out_done:
 		/*
 		 * We reached the target or the AIL is empty, so wait a bit
 		 * longer for I/O to complete and remove pushed items from the
@@ -638,7 +638,8 @@ xfsaild(
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

