Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6B113FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688190; cv=none; b=ufNVh+uscD9kyslezyEt4hCE4F8SEkSnDoU7ODwUamiBEQGoVc+bFAgJ182e/ZJy9OwbzYPBEHBzjKna6Pz8mWNHXISlcd5immc2XCStvzCUYphLXbkrJesSVWQVtPUtXQLBYBKR5RxAYRhjRwmCBF8LyJ2MN1MwztZ0A2MryE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688190; c=relaxed/simple;
	bh=JOFGf5VeFqItQHKYEQTXz0wd3I2J8Qi420CpjlVI17o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nYSxLiy9qaqnI6T0tx4UNRQf2vJD4MRGmK+URZA+62WLbGR4UL6zY6EoOURScani+/ea8RC+Cg5qKBvDyLtGMRRWY55j9q1k7ATzYNRxr/GWzNLnyLQ0Y/Qu1ltAnSv8beDU/XSoSD5SizjACToxWDCyb72jWvjczutRb6F2vzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdVUJPf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdVUJPf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8155C4CED2;
	Tue, 31 Dec 2024 23:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688190;
	bh=JOFGf5VeFqItQHKYEQTXz0wd3I2J8Qi420CpjlVI17o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cdVUJPf3dYJ9EefsZ0TEZwgB+oZ0OZg0XV0My5EXVikghnjSh26gSyhB65sM0z81S
	 FSKfA0RxH0+rUfl2IuUon7ek768w2qUq94iy2SvBtUwzp8R+1Ya+pSAacHcoH5aoRG
	 NSVYdThQJYjMt4CjnZgsq6kMYRY2M+aCUCeyq9ib4ZitL3S1EFrwBGmY6aruDK5Xxp
	 Jjsu/xjPcEJZQ/ImGvfO8eEpi2/6ecr48DvG3s2/JjM5v8CG343wdm/VicAo4HrzOG
	 NH4qC1us4iASmHpdbg+UBwxXjvkzEEFI+HdUyaGzSdDARnQnyvV7kVWA9xTjTlZjRD
	 5NAOKlweIQtOg==
Date: Tue, 31 Dec 2024 15:36:30 -0800
Subject: [PATCH 1/5] xfs: track deferred ops statistics
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568753338.2704399.11715419585933680375.stgit@frogsfrogsfrogs>
In-Reply-To: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
References: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |   18 +++++++++++++++++-
 fs/xfs/xfs_trace.h        |   19 +++++++++++++++++++
 fs/xfs/xfs_trans.c        |    3 +++
 fs/xfs/xfs_trans.h        |    7 +++++++
 4 files changed, 46 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5b377cbbb1f7e0..236409a3333ea6 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -618,6 +618,8 @@ xfs_defer_finish_one(
 	/* Done with the dfp, free it. */
 	list_del(&dfp->dfp_list);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
+	tp->t_dfops_nr--;
+	tp->t_dfops_finished++;
 out:
 	if (ops->finish_cleanup)
 		ops->finish_cleanup(tp, state, error);
@@ -680,6 +682,9 @@ xfs_defer_finish_noroll(
 
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
+		(*tp)->t_dfops_nr_max = max((*tp)->t_dfops_nr,
+					    (*tp)->t_dfops_nr_max);
+
 		if (has_intents < 0) {
 			error = has_intents;
 			goto out_shutdown;
@@ -721,6 +726,7 @@ xfs_defer_finish_noroll(
 	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	(*tp)->t_dfops_nr = 0;
 	xfs_defer_cancel(*tp);
 	return error;
 }
@@ -768,6 +774,7 @@ xfs_defer_cancel(
 	trace_xfs_defer_cancel(tp, _RET_IP_);
 	xfs_defer_trans_abort(tp, &tp->t_dfops);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
+	tp->t_dfops_nr = 0;
 }
 
 /*
@@ -853,8 +860,10 @@ xfs_defer_add(
 	}
 
 	dfp = xfs_defer_find_last(tp, ops);
-	if (!dfp || !xfs_defer_can_append(dfp, ops))
+	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
 		dfp = xfs_defer_alloc(&tp->t_dfops, ops);
+		tp->t_dfops_nr++;
+	}
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
@@ -879,6 +888,7 @@ xfs_defer_add_barrier(
 		return;
 
 	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
+	tp->t_dfops_nr++;
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
@@ -939,6 +949,12 @@ xfs_defer_move(
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
index 8d86a1e038cd5c..0352f432421598 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2880,6 +2880,25 @@ TRACE_EVENT(xfs_btree_free_block,
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
index f53f82456288e5..269cd4583a033d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -71,6 +71,9 @@ xfs_trans_free(
 	xfs_extent_busy_sort(&tp->t_busy);
 	xfs_extent_busy_clear(&tp->t_busy, false);
 
+	if (tp->t_dfops_finished > 0)
+		trace_xfs_defer_stats(tp);
+
 	trace_xfs_trans_free(tp, _RET_IP_);
 	xfs_trans_clear_context(tp);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 71c2e82e4dadff..cb037a669754eb 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -153,6 +153,13 @@ typedef struct xfs_trans {
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

