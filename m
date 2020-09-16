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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827A7C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 21:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2719020731
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 21:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tdOJbkUD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgIPVAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 17:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgIPQaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 12:30:24 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB50EC061D7D
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u9so3010601plk.4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RwtKAe+FGeUhXF1OHlO+nvfWrMOhVBKfylbTs13kDUE=;
        b=tdOJbkUDkoYfbI5V3ijGRoJW076n5wVa1jJAHAd85EuxMfCVubg2g08EUZIysSw5au
         X33M6+Mqp9PM0Bl0loYvTiIhh7itetmNqObUUuQKP34MOkhiV6oYR0sNIbUqAz5dLLzc
         aDVEbUPc+F2u0g4h8t5/RiOihDE16gdgOt+8cMbafEM6e9T4ogxoMUJYCUbYkCGlGKmN
         RjE/KkdmPI+s5CadP7tpyY00R3iLP4LtCYUbU31IUPUTbLE9iQdNCW1e/HhOrunGZESZ
         82PFV6/PblJWFTZRzoqL3ootuYk3mHqXpxPgrDH+FIbk/td7QoeSk97l+qhYI5y7LME7
         L8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RwtKAe+FGeUhXF1OHlO+nvfWrMOhVBKfylbTs13kDUE=;
        b=p/kkLIcL3zPanSQpCc01i4LLruIxhZ9OJLhqPVCytWj6Q7yMk7yT4KeAi0H6C2YWwQ
         UOmNMb875kBhzfVd0ot8Cizpd+frn2MpC1ZWODERpmDgjSKlZ3L8U0sQ5oxLZaskWzqk
         FmXFSxHjpsfBX1EwzCdBHgGJ4wPFqv2wTfkvVuoiKYjOAO68eYt7ljnYKFccwlMO19nx
         5JzDY2JZeT+wo5fNBs7uggCxMN2HlSD4+z1Zw7961Y5Lqc45HTGauq8qzd2YRciBaP20
         3YdN7RsuMu6FbNIn0lqnLhNtmFmkKJIBifq4T0KoZ8SNYzF+zi8pvc1t3n5QjwUGgp20
         aD3Q==
X-Gm-Message-State: AOAM530KPnl8yMhAeYKIn9PJ6dnE1+u/GYF4iJLOkB1GPLQ1Y2ZjZL2o
        XszJH2QfP+/IWnNTSAMESRw8xrzwfA==
X-Google-Smtp-Source: ABdhPJy7sUM2Ted7YIiKEAetNAdnt0Z7fdgRuQkwfF+utAxf6GiPG4qNgjPSUPKFgBytmf0vSiPXDA==
X-Received: by 2002:a17:90a:e02:: with SMTP id v2mr3481007pje.6.1600255163040;
        Wed, 16 Sep 2020 04:19:23 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:22 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: do the assert for all the log done items in xfs_trans_cancel
Date:   Wed, 16 Sep 2020 19:19:07 +0800
Message-Id: <1600255152-16086-5-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We should do the assert for all the log done items if they appear
here. This patch also add the XFS_ITEM_LOG_DONE flag to check if
the item is a log done item.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 fs/xfs/xfs_trans.c         | 2 +-
 fs/xfs/xfs_trans.h         | 4 ++++
 6 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ec3691372e7c..2e49f48666f1 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -202,7 +202,7 @@ xfs_bud_item_release(
 }
 
 static const struct xfs_item_ops xfs_bud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_LOG_DONE_FLAG,
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
 	.iop_release	= xfs_bud_item_release,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6cb8cd11072a..f2c6cb67262e 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -307,7 +307,7 @@ xfs_efd_item_release(
 }
 
 static const struct xfs_item_ops xfs_efd_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_LOG_DONE_FLAG,
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
 	.iop_release	= xfs_efd_item_release,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ca93b6488377..551bcc93acdd 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -208,7 +208,7 @@ xfs_cud_item_release(
 }
 
 static const struct xfs_item_ops xfs_cud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_LOG_DONE_FLAG,
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
 	.iop_release	= xfs_cud_item_release,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dc5b0753cd51..427f90ef4509 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -231,7 +231,7 @@ xfs_rud_item_release(
 }
 
 static const struct xfs_item_ops xfs_rud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_LOG_DONE_FLAG,
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
 	.iop_release	= xfs_rud_item_release,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4257fdb03778..d33d0ba6f3bd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1050,7 +1050,7 @@ xfs_trans_cancel(
 		struct xfs_log_item *lip;
 
 		list_for_each_entry(lip, &tp->t_items, li_trans)
-			ASSERT(!(lip->li_type == XFS_LI_EFD));
+			ASSERT(!(lip->li_ops->flags & XFS_ITEM_LOG_DONE));
 	}
 #endif
 	xfs_trans_unreserve_and_mod_sb(tp);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7fb82eb92e65..b92138b13c40 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -85,6 +85,10 @@ struct xfs_item_ops {
  * intents that never need to be written back in place.
  */
 #define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
+#define XFS_ITEM_LOG_DONE		(1 << 1)	/* log done item */
+
+#define XFS_ITEM_LOG_DONE_FLAG	(XFS_ITEM_RELEASE_WHEN_COMMITTED | \
+				 XFS_ITEM_LOG_DONE)
 
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 			  int type, const struct xfs_item_ops *ops);
-- 
2.20.0

