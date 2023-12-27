Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C640389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGh3sdw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6DAC433C8;
	Mon,  1 Jan 2024 00:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069505;
	bh=vi8EwOohvCKe6L/UMonB9ipugdMGiXeWnn0W1zVWJVI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hGh3sdw8n967E6kei0fKrrH4QQJ51CNJfVM3EobVn6zqZUD3GxLI+4kBUihffMDTN
	 4hSoDR8yIREYsbEAQBO6rGKTWtM0jFaS5u/o/FfomLdttoPHaChAyJHeClTM2V0/VJ
	 pXsdQez1vif5kUmptksercHgSYZIZFKHkTBczVSJpeDXJUhBdXBPsGj317Vf+Fx6Gj
	 wP5lb0Y4QSaPifmHidAQFTanCJURet0R3Ate1p7Xy1gbx18pMgTyb7EaXiUm8yhYJt
	 OUDjHyJtWwmQf+uqobRWyU+KF2l/E06avTNvPnr0mnitVv0FvBK5zRs+p/Yn0ZuMSs
	 vJZY5Z12I3LBA==
Date: Sun, 31 Dec 2023 16:38:24 +9900
Subject: [PATCH 1/5] xfs: track deferred ops statistics
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019577.1820520.10283388638932874687.stgit@frogsfrogsfrogs>
In-Reply-To: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
References: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
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
 include/xfs_trans.h |    4 ++++
 libxfs/xfs_defer.c  |   14 ++++++++++++++
 2 files changed, 18 insertions(+)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 630bc85ce37..4b4c26b5561 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -82,6 +82,10 @@ typedef struct xfs_trans {
 	long			t_frextents_delta;/* superblock freextents chg*/
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_dfops;	/* deferred operations */
+
+	unsigned int	t_dfops_nr;
+	unsigned int	t_dfops_nr_max;
+	unsigned int	t_dfops_finished;
 } xfs_trans_t;
 
 void	xfs_trans_init(struct xfs_mount *);
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4a1139913b9..2e32939024d 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -611,6 +611,8 @@ xfs_defer_finish_one(
 	/* Done with the dfp, free it. */
 	list_del(&dfp->dfp_list);
 	kmem_cache_free(xfs_defer_pending_cache, dfp);
+	tp->t_dfops_nr--;
+	tp->t_dfops_finished++;
 out:
 	if (ops->finish_cleanup)
 		ops->finish_cleanup(tp, state, error);
@@ -673,6 +675,9 @@ xfs_defer_finish_noroll(
 
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
+		(*tp)->t_dfops_nr_max = max((*tp)->t_dfops_nr,
+					    (*tp)->t_dfops_nr_max);
+
 		if (has_intents < 0) {
 			error = has_intents;
 			goto out_shutdown;
@@ -714,6 +719,7 @@ xfs_defer_finish_noroll(
 	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	(*tp)->t_dfops_nr = 0;
 	xfs_defer_cancel(*tp);
 	return error;
 }
@@ -761,6 +767,7 @@ xfs_defer_cancel(
 	trace_xfs_defer_cancel(tp, _RET_IP_);
 	xfs_defer_trans_abort(tp, &tp->t_dfops);
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
+	tp->t_dfops_nr = 0;
 }
 
 /*
@@ -824,6 +831,7 @@ xfs_defer_alloc(
 	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+	tp->t_dfops_nr++;
 
 	return dfp;
 }
@@ -936,6 +944,12 @@ xfs_defer_move(
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

