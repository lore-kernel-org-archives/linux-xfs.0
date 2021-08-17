Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A936C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8101C6102A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhHQXnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236456AbhHQXnT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 535A661008;
        Tue, 17 Aug 2021 23:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243765;
        bh=1YBZKEr8VtrMNtjSJ84sTqAmq/LMUIUzecCTgmXV/kU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EnO6d2K3veGswIvluzH4+/eo3zjfOJPJkaO8MpNbYvN1bp2EB5zh9VIAkWz1e8w/V
         Kf7e7RPFaHtVXMHMU/LRicE+hRahghKhHKkLhO+OSrArpY8Y0UPHsST6n4LK5zJnvq
         /JdP9pymkJBZUeyLtkwJdiVht1dGHeBqIkotGlMrUu9GLh9eX9tf8ZxHPB/kvIE4Qh
         GJTc/jrXDBAyrPbkwZPM00AZxhvJtmTNOfS961v97yhpOk5oJhqRneG8UthOxHnlVU
         IvcKDTq3UKF5szkO2HEV+HFOofiaqlkLpKTKtxkIuL6cYsXT9Hu+fFmAIusvve9zD6
         I7ypg6mb2xBMA==
Subject: [PATCH 06/15] xfs: standardize daddr formatting in ftrace output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:45 -0700
Message-ID: <162924376504.761813.17237311452402341703.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Always print disk addr (i.e. 512 byte block) numbers in hexadecimal and
preceded with the unit "daddr".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d6365a0ee0ff..3944373ad2f6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -397,7 +397,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d bno 0x%llx nblks 0x%x hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx nblks 0x%x hold %d pincount %d "
 		  "lock %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
@@ -465,7 +465,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
 		  "lock %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
@@ -510,7 +510,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
 		  "lock %d error %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
@@ -552,7 +552,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_flags = bip->bli_item.li_flags;
 	),
-	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
+	TP_printk("dev %d:%d daddr 0x%llx len 0x%zx hold %d pincount %d "
 		  "lock %d flags %s recur %d refcount %d bliflags %s "
 		  "liflags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),

