Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EF2C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 02:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357159AbiD0C0M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiD0C0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 22:26:12 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B65BF14B65D
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 19:23:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 061E410E5EFB
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:23:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-004yyH-Ue
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 12:23:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-002uvD-Th
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 12:23:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: add log item method to return related intents
Date:   Wed, 27 Apr 2022 12:22:57 +1000
Message-Id: <20220427022259.695399-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427022259.695399-1-david@fromorbit.com>
References: <20220427022259.695399-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6268a906
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=S1N-PUcTW3_U964qLncA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To apply a whiteout to an intent item when an intent done item is
committed, we need to be able to retrieve the intent item from the
the intent done item. Add a log item op method for doing this, and
wire all the intent done items up to it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     | 8 ++++++++
 fs/xfs/xfs_extfree_item.c  | 8 ++++++++
 fs/xfs/xfs_refcount_item.c | 8 ++++++++
 fs/xfs/xfs_rmap_item.c     | 8 ++++++++
 fs/xfs/xfs_trans.h         | 1 +
 5 files changed, 33 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3b968b31911b..e1b0e321d604 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -201,12 +201,20 @@ xfs_bud_item_release(
 	kmem_cache_free(xfs_bud_cache, budp);
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
index 96735f23d12d..032db5269e97 100644
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
index b523ce2c775b..a2213b5ee344 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -207,12 +207,20 @@ xfs_cud_item_release(
 	kmem_cache_free(xfs_cud_cache, cudp);
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
index b269e68407b9..053eb135380c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -230,12 +230,20 @@ xfs_rud_item_release(
 	kmem_cache_free(xfs_rud_cache, rudp);
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
index f68e74e46026..d72a5995d33e 100644
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
2.35.1

