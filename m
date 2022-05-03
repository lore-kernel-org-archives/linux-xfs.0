Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0551C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiECWjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237198AbiECWiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:38:51 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A78FABC83
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:35:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A1DCF10E6247
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 08:35:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-007gGI-4R
        for linux-xfs@vger.kernel.org; Wed, 04 May 2022 08:17:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-000mGU-3U
        for linux-xfs@vger.kernel.org;
        Wed, 04 May 2022 08:17:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] xfs: add log item flags to indicate intents
Date:   Wed,  4 May 2022 08:17:23 +1000
Message-Id: <20220503221728.185449-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503221728.185449-1-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6271ae24
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
        a=SNIHMcCwxNbLk-RHDm4A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently have a couple of helper functions that try to infer
whether the log item is an intent or intent done item from the
combinations of operations it supports.  This is incredibly fragile
and not very efficient as it requires checking specific combinations
of ops.

We need to be able to identify intent and intent done items quickly
and easily in upcoming patches, so simply add intent and intent done
type flags to the log item ops flags. These are static flags to
begin with, so intent items should have been typed like this from
the start.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c     |  4 +++-
 fs/xfs/xfs_extfree_item.c  |  4 +++-
 fs/xfs/xfs_refcount_item.c |  4 +++-
 fs/xfs/xfs_rmap_item.c     |  4 +++-
 fs/xfs/xfs_trans.h         | 25 +++++++++++++------------
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 2c8b686e2a11..0e0aae83308c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -204,7 +204,8 @@ xfs_bud_item_release(
 }
 
 static const struct xfs_item_ops xfs_bud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
 	.iop_release	= xfs_bud_item_release,
@@ -588,6 +589,7 @@ xfs_bui_item_relog(
 }
 
 static const struct xfs_item_ops xfs_bui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 0e50f2c9348e..21a159f9d8c5 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -307,7 +307,8 @@ xfs_efd_item_release(
 }
 
 static const struct xfs_item_ops xfs_efd_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
 	.iop_release	= xfs_efd_item_release,
@@ -688,6 +689,7 @@ xfs_efi_item_relog(
 }
 
 static const struct xfs_item_ops xfs_efi_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 10474fe389e1..71225d094e03 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -210,7 +210,8 @@ xfs_cud_item_release(
 }
 
 static const struct xfs_item_ops xfs_cud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
 	.iop_release	= xfs_cud_item_release,
@@ -602,6 +603,7 @@ xfs_cui_item_relog(
 }
 
 static const struct xfs_item_ops xfs_cui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 6c0b56ebdbe1..6ecbc37e4b8d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -233,7 +233,8 @@ xfs_rud_item_release(
 }
 
 static const struct xfs_item_ops xfs_rud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
 	.iop_release	= xfs_rud_item_release,
@@ -632,6 +633,7 @@ xfs_rui_item_relog(
 }
 
 static const struct xfs_item_ops xfs_rui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 87e940b5366e..f68e74e46026 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -80,28 +80,29 @@ struct xfs_item_ops {
 			struct xfs_trans *tp);
 };
 
-/* Is this log item a deferred action intent? */
+/*
+ * Log item ops flags
+ */
+/*
+ * Release the log item when the journal commits instead of inserting into the
+ * AIL for writeback tracking and/or log tail pinning.
+ */
+#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
+#define XFS_ITEM_INTENT			(1 << 1)
+#define XFS_ITEM_INTENT_DONE		(1 << 2)
+
 static inline bool
 xlog_item_is_intent(struct xfs_log_item *lip)
 {
-	return lip->li_ops->iop_recover != NULL &&
-	       lip->li_ops->iop_match != NULL;
+	return lip->li_ops->flags & XFS_ITEM_INTENT;
 }
 
-/* Is this a log intent-done item? */
 static inline bool
 xlog_item_is_intent_done(struct xfs_log_item *lip)
 {
-	return lip->li_ops->iop_unpin == NULL &&
-	       lip->li_ops->iop_push == NULL;
+	return lip->li_ops->flags & XFS_ITEM_INTENT_DONE;
 }
 
-/*
- * Release the log item as soon as committed.  This is for items just logging
- * intents that never need to be written back in place.
- */
-#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
-
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 			  int type, const struct xfs_item_ops *ops);
 
-- 
2.35.1

