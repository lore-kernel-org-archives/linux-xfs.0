Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D7BC43214
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 987A461041
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhIBKAe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:34 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42901 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233585AbhIBKAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:33 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CEB7D104D7CD
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nIj-Kb
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pCl-Cq
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: add log item flags to indicate intents
Date:   Thu,  2 Sep 2021 19:59:21 +1000
Message-Id: <20210902095927.911100-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=EunGAkhl6wQpG8flPxIA:9
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
---
 fs/xfs/xfs_attr_item.c     |  4 +++-
 fs/xfs/xfs_bmap_item.c     |  4 +++-
 fs/xfs/xfs_extfree_item.c  |  4 +++-
 fs/xfs/xfs_refcount_item.c |  4 +++-
 fs/xfs/xfs_rmap_item.c     |  4 +++-
 fs/xfs/xfs_trans.h         | 25 +++++++++++++------------
 6 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index bd4089eb8087..f900001e8f3a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -479,7 +479,8 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
 }
 
 static const struct xfs_item_ops xfs_attrd_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_attrd_item_size,
 	.iop_format	= xfs_attrd_item_format,
 	.iop_release    = xfs_attrd_item_release,
@@ -684,6 +685,7 @@ xfs_attri_item_relog(
 }
 
 static const struct xfs_item_ops xfs_attri_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_attri_item_size,
 	.iop_format	= xfs_attri_item_format,
 	.iop_unpin	= xfs_attri_item_unpin,
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 51ba8ee368ca..8de644a343b5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -202,7 +202,8 @@ xfs_bud_item_release(
 }
 
 static const struct xfs_item_ops xfs_bud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
 	.iop_release	= xfs_bud_item_release,
@@ -584,6 +585,7 @@ xfs_bui_item_relog(
 }
 
 static const struct xfs_item_ops xfs_bui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 046f21338c48..952a46477907 100644
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
@@ -681,6 +682,7 @@ xfs_efi_item_relog(
 }
 
 static const struct xfs_item_ops xfs_efi_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a6e7351ca4f9..38b38a734fd6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -208,7 +208,8 @@ xfs_cud_item_release(
 }
 
 static const struct xfs_item_ops xfs_cud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
 	.iop_release	= xfs_cud_item_release,
@@ -600,6 +601,7 @@ xfs_cui_item_relog(
 }
 
 static const struct xfs_item_ops xfs_cui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8c70a4af80a9..1b3655090113 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -231,7 +231,8 @@ xfs_rud_item_release(
 }
 
 static const struct xfs_item_ops xfs_rud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
+			  XFS_ITEM_INTENT_DONE,
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
 	.iop_release	= xfs_rud_item_release,
@@ -630,6 +631,7 @@ xfs_rui_item_relog(
 }
 
 static const struct xfs_item_ops xfs_rui_item_ops = {
+	.flags		= XFS_ITEM_INTENT,
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 2d1cc1ff93c7..ab6e0bc1df1a 100644
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
2.31.1

