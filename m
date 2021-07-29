Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04EDC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A83960F4B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhG2Sod (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhG2Soa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 024DB60249;
        Thu, 29 Jul 2021 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584267;
        bh=ttGyJmTEIdyynRdCZASYxB4BgIxqS/f/oQgcp8sSabY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZbU73AVSKlOuch4jq9QiZcd0XfC2zWg2Xrom5pss82hUGA951iRq5emEFa1pWFPCn
         OUzau0xipYs1dnv6yQHPw6EcIw65arFfCrGlDKO63aeHwtZuaTmUVl2Rhmeimk5wjI
         i0TxLXABdwp7bGysFEg/ZI7oufN+naPO1DxBogxf1B9ZqNuUyvIrTp15KJ7dqpyNPS
         bLrCxCdqjpqk4X3h+ThcNA8AM+XimXpcPURHuUrt41IZfyJ53db7273mFagN0Sfe+B
         XV3HrBEZnXctB34k6AWtEgDVMZnap83iwYsD94408flsBS80ASefHABidJPc3dt/L8
         9xRShlxDqvlOg==
Subject: [PATCH 06/20] xfs: throttle inodegc queuing on backlog
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:26 -0700
Message-ID: <162758426670.332903.7504844999802581902.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Track the number of inodes in each AG that are queued for inactivation,
then use that information to decide if we're going to make threads that
has queued an inode for inactivation wait for the background thread.
The purpose of this high water mark is to establish a maximum bound on
the backlog of work that can accumulate on a non-frozen filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    1 +
 fs/xfs/libxfs/xfs_ag.h |    3 ++-
 fs/xfs/xfs_icache.c    |   16 ++++++++++++++++
 fs/xfs/xfs_trace.h     |   24 ++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ee9ec0c50bec..125a4b1f5be5 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -193,6 +193,7 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		ASSERT(pag->pag_ici_needs_inactive == 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..ad0d3480a4a2 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -83,7 +83,8 @@ struct xfs_perag {
 
 	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
-	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned int	pag_ici_needs_inactive;	/* inodes queued for inactivation */
+	unsigned int	pag_ici_reclaimable;	/* reclaimable inodes */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
 	/* buffer cache index */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 82f0db311ef9..abd95f16b697 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -35,6 +35,12 @@
 /* Inode can be inactivated. */
 #define XFS_ICI_INODEGC_TAG	2
 
+/*
+ * Upper bound on the number of inodes in each AG that can be queued for
+ * inactivation at any given time, to avoid monopolizing the workqueue.
+ */
+#define XFS_INODEGC_MAX_BACKLOG	(1024 * XFS_INODES_PER_CHUNK)
+
 /*
  * The goal for walking incore inodes.  These can correspond with incore inode
  * radix tree tags when convenient.  Avoid existing XFS_IWALK namespace.
@@ -259,6 +265,8 @@ xfs_perag_set_inode_tag(
 
 	if (tag == XFS_ICI_RECLAIM_TAG)
 		pag->pag_ici_reclaimable++;
+	else if (tag == XFS_ICI_INODEGC_TAG)
+		pag->pag_ici_needs_inactive++;
 
 	if (was_tagged)
 		return;
@@ -306,6 +314,8 @@ xfs_perag_clear_inode_tag(
 
 	if (tag == XFS_ICI_RECLAIM_TAG)
 		pag->pag_ici_reclaimable--;
+	else if (tag == XFS_ICI_INODEGC_TAG)
+		pag->pag_ici_needs_inactive--;
 
 	if (radix_tree_tagged(&pag->pag_ici_root, tag))
 		return;
@@ -364,6 +374,12 @@ xfs_inodegc_want_throttle(
 	if (current->reclaim_state != NULL)
 		return false;
 
+	/* Enforce an upper bound on how many inodes can queue up. */
+	if (pag->pag_ici_needs_inactive > XFS_INODEGC_MAX_BACKLOG) {
+		trace_xfs_inodegc_throttle_backlog(pag);
+		return true;
+	}
+
 	/* Throttle if memory reclaim anywhere has triggered us. */
 	if (atomic_read(&mp->m_inodegc_reclaim) > 0) {
 		trace_xfs_inodegc_throttle_mempressure(mp);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaebb070d859..b4dfa7e7e700 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -249,6 +249,30 @@ TRACE_EVENT(xfs_inodegc_throttle_mempressure,
 		  __entry->votes)
 );
 
+DECLARE_EVENT_CLASS(xfs_inodegc_backlog_class,
+	TP_PROTO(struct xfs_perag *pag),
+	TP_ARGS(pag),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, needs_inactive)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->needs_inactive = pag->pag_ici_needs_inactive;
+	),
+	TP_printk("dev %d:%d agno %u needs_inactive %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->needs_inactive)
+);
+#define DEFINE_INODEGC_BACKLOG_EVENT(name)	\
+DEFINE_EVENT(xfs_inodegc_backlog_class, name,	\
+	TP_PROTO(struct xfs_perag *pag),	\
+	TP_ARGS(pag))
+DEFINE_INODEGC_BACKLOG_EVENT(xfs_inodegc_throttle_backlog);
+
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
 	TP_ARGS(mp, agno),

