Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97998C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 04:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C4D611AD
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 04:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhEDE3D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 May 2021 00:29:03 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44144 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhEDE3D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 May 2021 00:29:03 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 1B63D80B224
        for <linux-xfs@vger.kernel.org>; Tue,  4 May 2021 14:28:07 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ldmfG-002Uip-0X
        for linux-xfs@vger.kernel.org; Tue, 04 May 2021 14:28:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ldmfF-000D43-Ov
        for linux-xfs@vger.kernel.org; Tue, 04 May 2021 14:28:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove XFS_ITEM_RELEASE_WHEN_COMMITTED
Date:   Tue,  4 May 2021 14:28:05 +1000
Message-Id: <20210504042805.50176-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=jgm8W4Q8OQ0DZgSYdGcA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Redundant functionality. Returning NULLCOMMITLSN from
->iop_committed means "release item as there is no further
processing to be done", making this flag entirely redundant.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_dquot_item.c    |  2 +-
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_icreate_item.c  |  2 +-
 fs/xfs/xfs_inode_item.c    |  4 ++--
 fs/xfs/xfs_log.c           | 12 ++++++++++++
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 fs/xfs/xfs_trans.c         |  9 ++-------
 fs/xfs/xfs_trans.h         | 13 ++++++-------
 10 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 2344757ede63..e827ebaf815e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -203,10 +203,10 @@ xfs_bud_item_release(
 }
 
 static const struct xfs_item_ops xfs_bud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
 	.iop_release	= xfs_bud_item_release,
+	.iop_comitted	= xfs_log_item_committed_done,
 };
 
 static struct xfs_bud_log_item *
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 8c1fdf37ee8f..4fcfc9e58ca1 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -282,7 +282,7 @@ xfs_qm_qoffend_logitem_committed(
 
 	kmem_free(lip->li_lv_shadow);
 	kmem_free(qfe);
-	return (xfs_lsn_t)-1;
+	return NULLCOMMITLSN;
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 93223ebb3372..04a117645906 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -307,10 +307,10 @@ xfs_efd_item_release(
 }
 
 static const struct xfs_item_ops xfs_efd_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
 	.iop_release	= xfs_efd_item_release,
+	.iop_comitted	= xfs_log_item_committed_done,
 };
 
 /*
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 9b3994b9c716..f1c5b04c805d 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -67,10 +67,10 @@ xfs_icreate_item_release(
 }
 
 static const struct xfs_item_ops xfs_icreate_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_icreate_item_size,
 	.iop_format	= xfs_icreate_item_format,
 	.iop_release	= xfs_icreate_item_release,
+	.iop_comitted	= xfs_log_item_committed_done,
 };
 
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c1b32680f71c..8122defbf139 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -607,7 +607,7 @@ xfs_inode_item_release(
  * triggers an assert in xfs_inode_free() complaining about freein an inode
  * still in the AIL.
  *
- * To avoid this, just unpin the inode directly and return a LSN of -1 so the
+ * To avoid this, just unpin the inode directly and return NULLCOMMITLSN so the
  * transaction committed code knows that it does not need to do any further
  * processing on the item.
  */
@@ -621,7 +621,7 @@ xfs_inode_item_committed(
 
 	if (xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_inode_item_unpin(lip, 0);
-		return -1;
+		return NULLCOMMITLSN;
 	}
 	return lsn;
 }
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 06041834daa3..0a5ed64f1c7a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1012,6 +1012,18 @@ xfs_log_item_init(
 	INIT_LIST_HEAD(&item->li_trans);
 }
 
+/*
+ * Log items that have no processing required after they are committed use this
+ * as their ->iop_committed method. xfs_trans_committed_bulk() will skip further
+ * processing for objects that return NULLCOMMITLSN to this method.
+ */
+xfs_lsn_t
+xfs_log_item_committed_done(
+	struct xfs_log_item *item)
+{
+	return NULLCOMMITLSN;
+}
+
 /*
  * Wake up processes waiting for log space after we have moved the log tail.
  */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 07ebccbbf4df..6a606a2f9019 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -208,10 +208,10 @@ xfs_cud_item_release(
 }
 
 static const struct xfs_item_ops xfs_cud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
 	.iop_release	= xfs_cud_item_release,
+	.iop_comitted	= xfs_log_item_committed_done,
 };
 
 static struct xfs_cud_log_item *
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 49cebd68b672..1fc580548e72 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -231,10 +231,10 @@ xfs_rud_item_release(
 }
 
 static const struct xfs_item_ops xfs_rud_item_ops = {
-	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
 	.iop_release	= xfs_rud_item_release,
+	.iop_comitted	= xfs_log_item_committed_done,
 };
 
 static struct xfs_rud_log_item *
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bcc978011869..641cfb753999 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -763,18 +763,13 @@ xfs_trans_committed_bulk(
 		if (aborted)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
 
-		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
-			lip->li_ops->iop_release(lip);
-			continue;
-		}
-
 		if (lip->li_ops->iop_committed)
 			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
 		else
 			item_lsn = commit_lsn;
 
-		/* item_lsn of -1 means the item needs no further processing */
-		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
+		/* NULLCOMMITLSN means the item needs no further processing */
+		if (XFS_LSN_CMP(item_lsn, NULLCOMMITLSN) == 0)
 			continue;
 
 		/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9dd745cf77c9..de22b4046ebc 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -63,7 +63,6 @@ struct xfs_log_item {
 	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
 
 struct xfs_item_ops {
-	unsigned flags;
 	void (*iop_size)(struct xfs_log_item *, int *, int *);
 	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
 	void (*iop_pin)(struct xfs_log_item *);
@@ -95,15 +94,15 @@ xlog_item_is_intent_done(struct xfs_log_item *lip)
 	       lip->li_ops->iop_push == NULL;
 }
 
-/*
- * Release the log item as soon as committed.  This is for items just logging
- * intents that never need to be written back in place.
- */
-#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
-
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 			  int type, const struct xfs_item_ops *ops);
 
+/*
+ * Generic ->iop_committed callback to indicate that the log item should not be
+ * referenced by the caller once the callback returns.
+ */
+xfs_lsn_t xfs_log_item_committed_done(struct xfs_log_item *item)
+
 /*
  * Return values for the iop_push() routines.
  */
-- 
2.31.1

