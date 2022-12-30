Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F035C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiLaDXj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiLaDXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:23:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B9A12A80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:23:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6480C61D65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25E9C433D2;
        Sat, 31 Dec 2022 03:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457008;
        bh=1HCZAQZPBWAwrp15XljqBcOzkPoGiSx2g1Xz1Aqu6yc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UKfz34b7fEzwyULGDQJihzQPC53LrmPBv6/sO9M1B40TZnhYmYKGjV3PmdWDQ4nj2
         thC01KQXFXkrmnJDDfY9fq71J1Nhqpi7Jfl1pq45l/P6WmHp9e+u8FPCvcmL5zMrpV
         Q3skyZM+YMnz5PAXBLdZT/o9gmoWQkZThGD+bQe0pdTY23fz1cJwFkxsrIDAJRZpuT
         kb2jwtkwQVf/ULJZZFLw2sS3PsgzXJeJ8nxhhO0eMqV/GWa1BCzzE/thQ7RoKe8HOZ
         NGOPwUca3vEOrdS04Imkl5hkJDf4WRfKAHLBh0009Ijgyh+IVBp30sayfF9Xi/qoRL
         hmbWs76lC1B8A==
Subject: [PATCH 1/3] xfs: track deferred ops statistics
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876379.726950.2644941938712571538.stgit@magnolia>
In-Reply-To: <167243876361.726950.2109456102182372814.stgit@magnolia>
References: <167243876361.726950.2109456102182372814.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Track some basic statistics on how hard we're pushing the defer ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |   14 ++++++++++++++
 fs/xfs/xfs_trace.h        |   19 +++++++++++++++++++
 fs/xfs/xfs_trans.c        |    3 +++
 fs/xfs/xfs_trans.h        |    7 +++++++
 4 files changed, 43 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 1aefb4c99e7b..1b13056f6199 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -509,6 +509,8 @@ xfs_defer_finish_one(
 	/* Done with the dfp, free it. */
 	list_del(&dfp->dfp_list);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
+	tp->t_dfops_nr--;
+	tp->t_dfops_finished++;
 out:
 	if (ops->finish_cleanup)
 		ops->finish_cleanup(tp, state, error);
@@ -550,6 +552,9 @@ xfs_defer_finish_noroll(
 
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
+		(*tp)->t_dfops_nr_max = max((*tp)->t_dfops_nr,
+					    (*tp)->t_dfops_nr_max);
+
 		if (has_intents < 0) {
 			error = has_intents;
 			goto out_shutdown;
@@ -580,6 +585,7 @@ xfs_defer_finish_noroll(
 	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	(*tp)->t_dfops_nr = 0;
 	xfs_defer_cancel(*tp);
 	return error;
 }
@@ -620,6 +626,7 @@ xfs_defer_cancel(
 
 	trace_xfs_defer_cancel(tp, _RET_IP_);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
+	tp->t_dfops_nr = 0;
 }
 
 /* Add an item for later deferred processing. */
@@ -656,6 +663,7 @@ xfs_defer_add(
 		dfp->dfp_count = 0;
 		INIT_LIST_HEAD(&dfp->dfp_work);
 		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+		tp->t_dfops_nr++;
 	}
 
 	list_add_tail(li, &dfp->dfp_work);
@@ -674,6 +682,12 @@ xfs_defer_move(
 	struct xfs_trans	*stp)
 {
 	list_splice_init(&stp->t_dfops, &dtp->t_dfops);
+	dtp->t_dfops_nr += stp->t_dfops_nr;
+	dtp->t_dfops_nr_max = stp->t_dfops_nr_max;
+	dtp->t_dfops_finished = stp->t_dfops_finished;
+	stp->t_dfops_nr = 0;
+	stp->t_dfops_nr_max = 0;
+	stp->t_dfops_finished = 0;
 
 	/*
 	 * Low free space mode was historically controlled by a dfops field.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 00716f112f4e..e1a94bfc8a13 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2681,6 +2681,25 @@ TRACE_EVENT(xfs_btree_free_block,
 /* deferred ops */
 struct xfs_defer_pending;
 
+TRACE_EVENT(xfs_defer_stats,
+	TP_PROTO(struct xfs_trans *tp),
+	TP_ARGS(tp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, max)
+		__field(unsigned int, finished)
+	),
+	TP_fast_assign(
+		__entry->dev = tp->t_mountp->m_super->s_dev;
+		__entry->max = tp->t_dfops_nr_max;
+		__entry->finished = tp->t_dfops_finished;
+	),
+	TP_printk("dev %d:%d max %u finished %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->max,
+		  __entry->finished)
+)
+
 DECLARE_EVENT_CLASS(xfs_defer_class,
 	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip),
 	TP_ARGS(tp, caller_ip),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fd389a8582fd..3c293c563cae 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -70,6 +70,9 @@ xfs_trans_free(
 	xfs_extent_busy_sort(&tp->t_busy);
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
+	if (tp->t_dfops_finished > 0)
+		trace_xfs_defer_stats(tp);
+
 	trace_xfs_trans_free(tp, _RET_IP_);
 	xfs_trans_clear_context(tp);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index efa7eace0859..09df8cedee8d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -155,6 +155,13 @@ typedef struct xfs_trans {
 	struct list_head	t_busy;		/* list of busy extents */
 	struct list_head	t_dfops;	/* deferred operations */
 	unsigned long		t_pflags;	/* saved process flags state */
+
+	/* Count of deferred ops attached to transaction. */
+	unsigned int		t_dfops_nr;
+	/* Maximum t_dfops_nr seen in a loop. */
+	unsigned int		t_dfops_nr_max;
+	/* Number of dfops finished. */
+	unsigned int		t_dfops_finished;
 } xfs_trans_t;
 
 /*

