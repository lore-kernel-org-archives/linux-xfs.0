Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEECCCA490
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbiGZJVp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiGZJVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C70313AF;
        Tue, 26 Jul 2022 02:21:42 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x91so17012880ede.1;
        Tue, 26 Jul 2022 02:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CCffWIrprOFDupXIPfG9sGLjBjjQFE32u5DFhNY/LA4=;
        b=TqwdFOaZbPLCw1guFk4YIbl4/jE7ZsAKli10zahfs5mdu1oHAO5pITBZqPCSfAyxHo
         T5FaUZyUSPn8O03WfbghGao5QQbxcQdOI6tnNNfiKIXlW9h90nK/8wykVqZCCJEOrN1C
         sc1f4enXLPafSyh/72A0XsjGUZ2VO2/9NLf/xP9P1UYXandeLT7DC/xm+3AWV3UERhxy
         2fZ9Gq0t8tv3bQGuDaXPmYwhXPzXRw7ndCbvcGH2UIfxFjTsWvfnF0KBPC7EWJ7HLGfb
         uH7D9T1gNd4TCZypublS522psm5KRmreE5oCZppPgJPwojZ72MdK8QhFyDOtLZgxQ49B
         3OkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CCffWIrprOFDupXIPfG9sGLjBjjQFE32u5DFhNY/LA4=;
        b=cIYRau1M9mLUJ8xEPUyY639OhRwVA3pOOGuUoz8JNBqZIoOlxI9Z84QgbV9v0pryLo
         gEi2CksUfVfgQ/biczWRObU9Zk1yY11bdTzkhThKrqzEBbAVShJxAs2FYMiXprFCFQsO
         MyUo0/qT9seLAfr3dzlU48HbgOAgI15teTkImKuQHWfcEOOdaHCdTong5rhBYEZJb257
         jBHKnRrlRTm49J0OWduVKa5R4UkRxMg2iG06I4v4nxtUCINZj4lx6No7YiyUM9zVsd3G
         LhoDqbkJkZVk9uOGuIkxggKtXc07zFU70R9CXMjYEORdkdgMf6lxeX09/f3UbeZLgMtd
         XQDQ==
X-Gm-Message-State: AJIora+Hu8oPgOPJEtl/3dux3CpZTly1FKsvnd9+339lTRiPRYf1xFWt
        I1K5pXRB5KfAaM0Gafth/qA=
X-Google-Smtp-Source: AGRyM1uioseJyqirfLD78wJ3seu/8b02z/xd1d4Elklb/31HwBEz/Q+jOShPQj0D6fnpLZETjZGc9A==
X-Received: by 2002:a05:6402:1d54:b0:43b:e20b:4ff1 with SMTP id dz20-20020a0564021d5400b0043be20b4ff1mr14574724edb.385.1658827296551;
        Tue, 26 Jul 2022 02:21:36 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:35 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 6/9] xfs: hold buffer across unpin and potential shutdown processing
Date:   Tue, 26 Jul 2022 11:21:22 +0200
Message-Id: <20220726092125.3899077-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
References: <20220726092125.3899077-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 84d8949e770745b16a7e8a68dcb1d0f3687bdee9 upstream.

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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_buf_item.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5d6535370f87..452af57731ed 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -393,17 +393,8 @@ xfs_buf_item_pin(
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
@@ -420,12 +411,26 @@ xfs_buf_item_unpin(
 
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
@@ -468,13 +473,13 @@ xfs_buf_item_unpin(
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
2.25.1

