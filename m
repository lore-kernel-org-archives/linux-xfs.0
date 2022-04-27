Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB007C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 02:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357053AbiD0C0S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357165AbiD0C0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 22:26:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90F0114C3D1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 19:23:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7EC1853735C
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:23:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-004yy9-RE
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 12:23:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-002uuz-Q9
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 12:23:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: add log item flags to indicate intents
Date:   Wed, 27 Apr 2022 12:22:54 +1000
Message-Id: <20220427022259.695399-4-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427022259.695399-1-david@fromorbit.com>
References: <20220427022259.695399-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6268a906
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=SNIHMcCwxNbLk-RHDm4A:9
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
---
 fs/xfs/xfs_bmap_item.c     |  4 +++-
 fs/xfs/xfs_extfree_item.c  |  4 +++-
 fs/xfs/xfs_refcount_item.c |  4 +++-
 fs/xfs/xfs_rmap_item.c     |  4 +++-
 fs/xfs/xfs_trans.h         | 25 +++++++++++++------------
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 593ac29cffc7..ed67c0028a68 100644
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
@@ -586,6 +587,7 @@ xfs_bui_item_relog(
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
index 0d868c93144d..6536eea4c6ea 100644
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
index a22b2d19ef91..c2bb8cfc231e 100644
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

