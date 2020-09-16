Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CAEC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 19:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8CF4208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 19:49:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qnP2kKby"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgIPTsl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 15:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbgIPRhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:37:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026FFC061D7E
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fa1so1435549pjb.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y9zkRLd0L0cttBLuXglZLeM62+SW72bWkugftszNajg=;
        b=qnP2kKbyoXNtnwTyyKQeqgmBc86wK4IGgJ6BDv6qupP+dFOo0T4K+ypxnRvqMmzGA6
         pihsIzScxuhjQJPuwqEYlaXogg3zUDuBdnpQ6Wzq7fCdIwjGZgdflv4VsRlBYWtx53BM
         L1SOcCBeNqfZt5d2NH00Qgt9fmxJ53roBTIFU+g2mi9wBivAEUbh17emFK3twCnoUJvh
         lhLVt94xXDtjxAgy7pnlmHVY1CiK96F1XBqvbPaVCJ4gzn+NVTFqk9Ze/wipCgP7sPO5
         1Z81spnKvZOPqbR0SAdnWFnGwQJyXUUizC5R+OX6djH9XWdlb9I1+59BfhcsdVyJCwMC
         A7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y9zkRLd0L0cttBLuXglZLeM62+SW72bWkugftszNajg=;
        b=UBIC8IGhIWQ8xfsutm6z9ynQE65h0w3AQLtFC64iyIqENJzyp9ZPQmAg+ewqCW4bgs
         q8ENhR+ZSlBLb+HRAbM+ILn9lbsYse+aQITe+KE5AT396hk3C6mMojKFdImEw9qE27vh
         M5nGvQdYasVjVWFbAmxhsAKT0UAGJX9bYRi6qaPplBBx1FOsE2YUBA8tC9zZzW1OOKMB
         nQ8AzAxWt9gFOrgiZdlsmJWmkizvXoMvrfKOeRbCxpxPaeVSdpcYx3PeuULqqqZIuXYA
         GjOcblDB3Mmjjc2OfwqlS9yCyxDEdZEfMJhQ/WpskraZ2Ml3+UlS2VJVn3NG6JhyZnC2
         0iIg==
X-Gm-Message-State: AOAM532Jy4EQQREOfxGoXO75zPDIYLzK8trhXNesIszWachch4TWJAN0
        lq+uaIpjEZAtTvtDvOOaKvICvmE691/5
X-Google-Smtp-Source: ABdhPJyJv++JZS2E4odJAGdSnY6qUSVnJjsZfjIvOYWbDyV+GD7hIVqZAUpFHjrGUnufb8tQafa0lw==
X-Received: by 2002:a17:902:8a93:b029:d1:e5e7:be7a with SMTP id p19-20020a1709028a93b02900d1e5e7be7amr5623042plo.84.1600255164054;
        Wed, 16 Sep 2020 04:19:24 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:23 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: add the XFS_ITEM_LOG_INTENT flag to mark the log intent item
Date:   Wed, 16 Sep 2020 19:19:08 +0800
Message-Id: <1600255152-16086-6-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

This patch add the XFS_ITEM_LOG_INTENT flag to mark the log intent
item, so maybe we can simplify the judgement of log intent item.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_bmap_item.c     |  1 +
 fs/xfs/xfs_extfree_item.c  |  1 +
 fs/xfs/xfs_log_recover.c   | 15 ++++-----------
 fs/xfs/xfs_refcount_item.c |  1 +
 fs/xfs/xfs_rmap_item.c     |  1 +
 fs/xfs/xfs_trans.h         |  3 ++-
 6 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 2e49f48666f1..86485dcc9813 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -560,6 +560,7 @@ xfs_bui_item_match(
 }
 
 static const struct xfs_item_ops xfs_bui_item_ops = {
+	.flags		= XFS_ITEM_LOG_INTENT,
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f2c6cb67262e..44242b2ac8c7 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -650,6 +650,7 @@ xfs_efi_item_match(
 }
 
 static const struct xfs_item_ops xfs_efi_item_ops = {
+	.flags		= XFS_ITEM_LOG_INTENT,
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1ca35b53d3b9..32eeed4f8661 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2475,13 +2475,6 @@ xlog_finish_defer_ops(
 	return xfs_trans_commit(tp);
 }
 
-/* Is this log item a deferred action intent? */
-static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
-{
-	return lip->li_ops->iop_recover != NULL &&
-	       lip->li_ops->iop_match != NULL;
-}
-
 /*
  * When this is called, all of the log intent items which did not have
  * corresponding log done items should be in the AIL.  What we do now
@@ -2535,10 +2528,10 @@ xlog_recover_process_intents(
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
 		 */
-		if (!xlog_item_is_intent(lip)) {
+		if (!(lip->li_ops->flags & XFS_ITEM_LOG_INTENT)) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
+				ASSERT(!(lip->li_ops->flags & XFS_ITEM_LOG_INTENT));
 #endif
 			break;
 		}
@@ -2595,10 +2588,10 @@ xlog_recover_cancel_intents(
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
 		 */
-		if (!xlog_item_is_intent(lip)) {
+		if (!(lip->li_ops->flags & XFS_ITEM_LOG_INTENT)) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
+				ASSERT(!(lip->li_ops->flags & XFS_ITEM_LOG_INTENT));
 #endif
 			break;
 		}
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 551bcc93acdd..a4d470af5f7b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -575,6 +575,7 @@ xfs_cui_item_match(
 }
 
 static const struct xfs_item_ops xfs_cui_item_ops = {
+	.flags		= XFS_ITEM_LOG_INTENT,
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 427f90ef4509..335c76307383 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -591,6 +591,7 @@ xfs_rui_item_match(
 }
 
 static const struct xfs_item_ops xfs_rui_item_ops = {
+	.flags		= XFS_ITEM_LOG_INTENT,
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index b92138b13c40..53cb5c5eda02 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -85,7 +85,8 @@ struct xfs_item_ops {
  * intents that never need to be written back in place.
  */
 #define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
-#define XFS_ITEM_LOG_DONE		(1 << 1)	/* log done item */
+#define XFS_ITEM_LOG_INTENT		(1 << 1)	/* log intent item */
+#define XFS_ITEM_LOG_DONE		(1 << 2)	/* log done item */
 
 #define XFS_ITEM_LOG_DONE_FLAG	(XFS_ITEM_RELEASE_WHEN_COMMITTED | \
 				 XFS_ITEM_LOG_DONE)
-- 
2.20.0

