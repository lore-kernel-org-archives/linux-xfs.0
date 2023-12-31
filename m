Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC50C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqJ0m8o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AC7C433C7;
	Sun, 31 Dec 2023 22:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060060;
	bh=HzvgwWrjyOecBSnPXSeGyCcn8JxFlNGUQaAmYh+kc+o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kqJ0m8o60JSGw01Q54/Fr2H9BVyIIkDv4ZC4fokK2wCXEOc0/VwG1oFpsCEDicI0x
	 yHkYy82UebrkIMlWxvoKB6BiGQLaJQFxp53a8SCH3vEhHU46qu3Uzqj0nQqAY0Zm4G
	 PUN90twJV0ZU9c9pOv2tEHLZy9jt1XZuoextpUhV1gxtZhRa0TK/C9yBft77mN5wrs
	 5UZ/kiYhh2KRwmUj0RSJbpoiPF2XhMa4mGtb5ADQkHaVKrifBa07Z9nGurFDmirelh
	 Mt9GZYK/x9OqJE5neecS0aokFn8/B9C5w7iycdlsq7gqhnw8T16nEiZzHxCiz9UdPA
	 8NrF9FysvhIlg==
Date: Sun, 31 Dec 2023 14:00:59 -0800
Subject: [PATCH 1/5] xfs: track deferred ops statistics
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404854737.1769671.8541528862677264303.stgit@frogsfrogsfrogs>
In-Reply-To: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
References: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index cd28b96b49ea9..bf83508edf822 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -617,6 +617,8 @@ xfs_defer_finish_one(
 	/* Done with the dfp, free it. */
 	list_del(&dfp->dfp_list);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
+	tp->t_dfops_nr--;
+	tp->t_dfops_finished++;
 out:
 	if (ops->finish_cleanup)
 		ops->finish_cleanup(tp, state, error);
@@ -679,6 +681,9 @@ xfs_defer_finish_noroll(
 
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
+		(*tp)->t_dfops_nr_max = max((*tp)->t_dfops_nr,
+					    (*tp)->t_dfops_nr_max);
+
 		if (has_intents < 0) {
 			error = has_intents;
 			goto out_shutdown;
@@ -720,6 +725,7 @@ xfs_defer_finish_noroll(
 	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	(*tp)->t_dfops_nr = 0;
 	xfs_defer_cancel(*tp);
 	return error;
 }
@@ -767,6 +773,7 @@ xfs_defer_cancel(
 	trace_xfs_defer_cancel(tp, _RET_IP_);
 	xfs_defer_trans_abort(tp, &tp->t_dfops);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
+	tp->t_dfops_nr = 0;
 }
 
 /*
@@ -830,6 +837,7 @@ xfs_defer_alloc(
 	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+	tp->t_dfops_nr++;
 
 	return dfp;
 }
@@ -942,6 +950,12 @@ xfs_defer_move(
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
index 906e35eef223d..6c99bf56184b0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2711,6 +2711,25 @@ TRACE_EVENT(xfs_btree_free_block,
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
index 008380482777b..eb7d4272aef28 100644
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
index 2046ee06fe88f..6017efe354adc 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -151,6 +151,13 @@ typedef struct xfs_trans {
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

