Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8BCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 20:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E515364EB2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 20:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBRUQ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 15:16:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhBRUQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 15:16:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613679302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cqE6mCOJx17psd+MblLfldlUCwWefvHJ0t+9a6B3Boo=;
        b=TqIvVN73hXjN4aoT9Ccnb8/xy4MmkrR1NZ3qIOyNT5vYo7RxIJvacqvaGWrZqOArUQcXbP
        EXKeeLBjkLjeQn5lq2MF+h7gNOUvYwfTKZka61jOeoLhoxZX76dKwH+Bp411NgBXck+bA4
        a98V3bLyNUr2516LQm3utdN830EFNhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-p2Pr1cBzNR-9-azdWHRnCA-1; Thu, 18 Feb 2021 15:15:00 -0500
X-MC-Unique: p2Pr1cBzNR-9-azdWHRnCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40FD2100A8E9;
        Thu, 18 Feb 2021 20:14:59 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE8B060C61;
        Thu, 18 Feb 2021 20:14:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org
Subject: [PATCH] xfs: don't call into blockgc scan with freeze protection
Date:   Thu, 18 Feb 2021 15:14:58 -0500
Message-Id: <20210218201458.718889-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fstest xfs/167 produced a lockdep splat that complained about a
nested transaction acquiring freeze protection during an eofblocks
scan. Drop freeze protection around the block reclaim scan in the
transaction allocation code to avoid this problem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 44f72c09c203..c32c62d3b77a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -261,6 +261,7 @@ xfs_trans_alloc(
 {
 	struct xfs_trans	*tp;
 	int			error;
+	bool			retried = false;
 
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting up
@@ -288,19 +289,27 @@ xfs_trans_alloc(
 	INIT_LIST_HEAD(&tp->t_dfops);
 	tp->t_firstblock = NULLFSBLOCK;
 
+retry:
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
-	if (error == -ENOSPC) {
+	if (error == -ENOSPC && !retried) {
 		/*
 		 * We weren't able to reserve enough space for the transaction.
 		 * Flush the other speculative space allocations to free space.
 		 * Do not perform a synchronous scan because callers can hold
 		 * other locks.
 		 */
+		retried = true;
+		if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+			sb_end_intwrite(mp->m_super);
 		error = xfs_blockgc_free_space(mp, NULL);
-		if (!error)
-			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
-	}
-	if (error) {
+		if (error) {
+			kmem_cache_free(xfs_trans_zone, tp);
+			return error;
+		}
+		if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+			sb_start_intwrite(mp->m_super);
+		goto retry;
+	} else if (error) {
 		xfs_trans_cancel(tp);
 		return error;
 	}
-- 
2.26.2

