Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43031C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059A9221E8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 06:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="omdIszRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIWG7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWG7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:31 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C03C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:31 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z19so14444747pfn.8
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hkwSFp3OZ06QXGPaczCp4QW2hKeAs6v4EaN1CI9ricw=;
        b=omdIszRcv8JW2ldTa73vP57fDq63BDbwL1cWvxg78yRN7FxFsY115ubZbGL7xgJo1K
         1B54MuGDZbAM6/FxOV8WSOhAAHDK/t8PXG2PshCnStSOm/fX8jR4Oj+Gv5S51SZ0AKQg
         n+wXlh2nfE5C1aClRhD5v+FfNJ9KSQaVIGE/DwUSOYTMnWEZpjjCfkhpW9UptOQ/K+gn
         o3hMwuxxz4I5MG7GlIre8gt4bsSyvD8oi02Su+4qlt00LfpaURzb2gYCafIBAMAC1eL+
         mRcbcfmgV0snex74Ex2qMOCszfz6O+yf3G7AHBPU2GyPM5AJlHBVNZ4EiJavEb0DwNjn
         PEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hkwSFp3OZ06QXGPaczCp4QW2hKeAs6v4EaN1CI9ricw=;
        b=n67mZq6zKROlQY993TX9c0nEPWeJY0C7T0pTSDaS+lOGHBckTj1BqaE+q5ZBGP1S2K
         3VOOsB222DG7VngWXN9TFqDThZUeCA5VCJpr569MO+hktiWOQhLMLJTNl6SlnPrSf49R
         BTgMMQDVd2pGXT7oGVZgK105qez0glutInH2h2IWV5o9qeJIhdpHC0GFjroZ87fOc89Q
         /N+G698a8kt3UmDMqT6uTP1cskUod/Xy7NO2Q3c2DqNqLamNYH3qtCf+rYoYeibm4rpL
         2YrCDQJOu+eJrnzlkT+T8Y+mbE/+hvZRDZeagA9yE6iwQ+0bM9WAvR3i8aBhZYPYKRe8
         zfwg==
X-Gm-Message-State: AOAM530uSX20OM7YijHvYf5XG/l23wsE90hmfPD2BvgSttlKjBewEFBL
        qR0YUrQQGPxM+PCI9x2g8Umhw8gyNNxc
X-Google-Smtp-Source: ABdhPJxCFJg15gkMSLRIVaCeDRa5UVinHqvqxX9ZX/w+aoho6bjQGlmRpW0ECT1AKNCC1coVNNCJfw==
X-Received: by 2002:a63:4d02:: with SMTP id a2mr6276836pgb.38.1600844370572;
        Tue, 22 Sep 2020 23:59:30 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:29 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 4/7] xfs: do the assert for all the log done items in xfs_trans_cancel
Date:   Wed, 23 Sep 2020 14:59:15 +0800
Message-Id: <1600844358-16601-5-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We should do the assert for all the log intent-done items if they appear
here. This patch detect intent-done items by the fact that their item ops
don't have iop_unpin and iop_push methods and also move the helper
xlog_item_is_intent to xfs_trans.h.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c |  7 -------
 fs/xfs/xfs_trans.c       |  2 +-
 fs/xfs/xfs_trans.h       | 16 ++++++++++++++++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a17d788921d6..8b437f2c0c35 100644
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
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ca18a040336a..c94e71f741b6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -959,7 +959,7 @@ xfs_trans_cancel(
 		struct xfs_log_item *lip;
 
 		list_for_each_entry(lip, &tp->t_items, li_trans)
-			ASSERT(!(lip->li_type == XFS_LI_EFD));
+			ASSERT(!xlog_item_is_intent_done(lip));
 	}
 #endif
 	xfs_trans_unreserve_and_mod_sb(tp);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f46534b75236..a71b4f443e39 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -78,6 +78,22 @@ struct xfs_item_ops {
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
 
+/* Is this log item a deferred action intent? */
+static inline bool
+xlog_item_is_intent(struct xfs_log_item *lip)
+{
+	return lip->li_ops->iop_recover != NULL &&
+	       lip->li_ops->iop_match != NULL;
+}
+
+/* Is this a log intent-done item? */
+static inline bool
+xlog_item_is_intent_done(struct xfs_log_item *lip)
+{
+	return lip->li_ops->iop_unpin == NULL &&
+	       lip->li_ops->iop_push == NULL;
+}
+
 /*
  * Release the log item as soon as committed.  This is for items just logging
  * intents that never need to be written back in place.
-- 
2.20.0

