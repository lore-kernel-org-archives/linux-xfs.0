Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F695C432BE
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C4AF60724
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhIBKAd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:33 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55972 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233325AbhIBKAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:32 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id CF6CE85DA4
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nIp-NJ
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pCu-Ft
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: add log item method to return related intents
Date:   Thu,  2 Sep 2021 19:59:24 +1000
Message-Id: <20210902095927.911100-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=lMP1nMaZ4QnEk-F7aqYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To apply a whiteout to an intent item when an intent done item is
committed, we need to be able to retrieve the intent item from the
the intent done item. Add a log item op method for doing this, and
wire all the intent done items up to it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_item.c     | 8 ++++++++
 fs/xfs/xfs_bmap_item.c     | 8 ++++++++
 fs/xfs/xfs_extfree_item.c  | 8 ++++++++
 fs/xfs/xfs_refcount_item.c | 8 ++++++++
 fs/xfs/xfs_rmap_item.c     | 8 ++++++++
 fs/xfs/xfs_trans.h         | 1 +
 6 files changed, 41 insertions(+)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 572edb7fb2cd..86c8d5d08176 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -480,12 +480,20 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
 	return attrdp;
 }
 
+static struct xfs_log_item *
+xfs_attrd_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &ATTRD_ITEM(lip)->attrd_attrip->attri_item;
+}
+
 static const struct xfs_item_ops xfs_attrd_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
 			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_attrd_item_size,
 	.iop_format	= xfs_attrd_item_format,
 	.iop_release    = xfs_attrd_item_release,
+	.iop_intent	= xfs_attrd_item_intent,
 };
 
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 5244d85b1ba4..0b06159cfd1b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -201,12 +201,20 @@ xfs_bud_item_release(
 	kmem_cache_free(xfs_bud_zone, budp);
 }
 
+static struct xfs_log_item *
+xfs_bud_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &BUD_ITEM(lip)->bud_buip->bui_item;
+}
+
 static const struct xfs_item_ops xfs_bud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
 			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
 	.iop_release	= xfs_bud_item_release,
+	.iop_intent	= xfs_bud_item_intent,
 };
 
 static struct xfs_bud_log_item *
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f689530aaa75..87cba4a71883 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -306,12 +306,20 @@ xfs_efd_item_release(
 	xfs_efd_item_free(efdp);
 }
 
+static struct xfs_log_item *
+xfs_efd_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &EFD_ITEM(lip)->efd_efip->efi_item;
+}
+
 static const struct xfs_item_ops xfs_efd_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
 			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
 	.iop_release	= xfs_efd_item_release,
+	.iop_intent	= xfs_efd_item_intent,
 };
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b426e98d7f4f..de739884e857 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -207,12 +207,20 @@ xfs_cud_item_release(
 	kmem_cache_free(xfs_cud_zone, cudp);
 }
 
+static struct xfs_log_item *
+xfs_cud_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &CUD_ITEM(lip)->cud_cuip->cui_item;
+}
+
 static const struct xfs_item_ops xfs_cud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
 			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
 	.iop_release	= xfs_cud_item_release,
+	.iop_intent	= xfs_cud_item_intent,
 };
 
 static struct xfs_cud_log_item *
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index df3e61c1bf69..8d57529d9ddd 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -230,12 +230,20 @@ xfs_rud_item_release(
 	kmem_cache_free(xfs_rud_zone, rudp);
 }
 
+static struct xfs_log_item *
+xfs_rud_item_intent(
+	struct xfs_log_item	*lip)
+{
+	return &RUD_ITEM(lip)->rud_ruip->rui_item;
+}
+
 static const struct xfs_item_ops xfs_rud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
 			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
 	.iop_release	= xfs_rud_item_release,
+	.iop_intent	= xfs_rud_item_intent,
 };
 
 static struct xfs_rud_log_item *
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index ab6e0bc1df1a..a6d7b3309bd7 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -78,6 +78,7 @@ struct xfs_item_ops {
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
 			struct xfs_trans *tp);
+	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
 };
 
 /*
-- 
2.31.1

