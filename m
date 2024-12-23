Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541551D63DE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990125; cv=none; b=TCFsRF45VrqmUGDtFFZfoibDbe801tsfEFO1pADrKBBPkuojzPsNSMcOMQfNZP2u5o4FDTHCnH9sPZzSrpZZnVemYY1iPWkXBL2MSA5rWlS9y6vPC7+uX1Xw//53KlSQiqvCELj+aZJ4IZ00I0iAgFiMnhQruJEZhDlNZYyltb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990125; c=relaxed/simple;
	bh=9C5RfWkI2Al+F9HcbKSVcfKqeMbH37qINRT2LZy/mas=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NHCqP8QOtloHIxEMzLf3HkMg9kl474B1wzmeU1wQEfcHxihNhG6NI65EikRh2QdhKvARhHm17rsdc3jHDHbHu58DR/Rqzb7pI+doiVizVjSysx0XEohmD7NpH82pBBi/Lu7b3Ombqtnkn6HHHMR3C4JETZbPXm06+UgxG7K6EvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=smI/Tnva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="smI/Tnva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDE8C4CED3;
	Mon, 23 Dec 2024 21:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990124;
	bh=9C5RfWkI2Al+F9HcbKSVcfKqeMbH37qINRT2LZy/mas=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=smI/TnvayzKC3ZrcVHeQSNk5jgD+ftPDbHxR25/jCAmmL/AhsZ9aUKEeVd3m/ErIc
	 QbbvH2hnhHDYdfx2wlM9e2Aa1Cgrh7olE/+RgFEPnDJHSEfMITYfCKfiQu1XRPAER4
	 rL4UiCE4mBPCML71SDRHxOHhPTtfhOhu4iPUNmsQC0icibRBdbtc65gy9YYN6LL90E
	 YrduYhNUWA3naD8eJS9ndV7GtKBKtSI5Y8/fsIcIaXb8SbDuidZf7KJI5Jb31Amr5P
	 ralUC4Pj8uHf9TvlFCxfxs+f4kia1k0q1U9GF0+UkgroVqDu+eDZai6B6VcYzJOcY4
	 +4lecWQm5Y+Wg==
Date: Mon, 23 Dec 2024 13:42:04 -0800
Subject: [PATCH 19/36] xfs: move draining of deferred operations to the
 generic group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940235.2293042.8328305775413138014.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 34cf3a6f3952ecabd54b4fe3d431aa44ce98fe45

Prepare supporting the upcoming realtime groups feature by moving the
deferred operation draining to the generic xfs_group structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c    |    7 ++-----
 libxfs/xfs_ag.h    |    9 ---------
 libxfs/xfs_group.c |    4 ++++
 libxfs/xfs_group.h |    9 +++++++++
 4 files changed, 15 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 20af8b67d86e88..d67e40f49a3fc0 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -110,7 +110,6 @@ xfs_perag_uninit(
 #ifdef __KERNEL__
 	struct xfs_perag	*pag = to_perag(xg);
 
-	xfs_defer_drain_free(&pag->pag_intents_drain);
 	cancel_delayed_work_sync(&pag->pag_blockgc_work);
 	xfs_buf_cache_destroy(&pag->pag_bcache);
 #endif
@@ -232,7 +231,6 @@ xfs_perag_alloc(
 	spin_lock_init(&pag->pagb_lock);
 	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-	xfs_defer_drain_init(&pag->pag_intents_drain);
 	init_waitqueue_head(&pag->pagb_wait);
 	pag->pagb_tree = RB_ROOT;
 	xfs_hooks_init(&pag->pag_rmap_update_hooks);
@@ -240,7 +238,7 @@ xfs_perag_alloc(
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
 	if (error)
-		goto out_defer_drain_free;
+		goto out_free_perag;
 
 	/*
 	 * Pre-calculated geometry
@@ -258,8 +256,7 @@ xfs_perag_alloc(
 
 out_buf_cache_destroy:
 	xfs_buf_cache_destroy(&pag->pag_bcache);
-out_defer_drain_free:
-	xfs_defer_drain_free(&pag->pag_intents_drain);
+out_free_perag:
 	kfree(pag);
 	return error;
 }
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 8271cb72c88387..45f8de06cdbc8a 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -97,15 +97,6 @@ struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
-	/*
-	 * We use xfs_drain to track the number of deferred log intent items
-	 * that have been queued (but not yet processed) so that waiters (e.g.
-	 * scrub) will not lock resources when other threads are in the middle
-	 * of processing a chain of intent items only to find momentary
-	 * inconsistencies.
-	 */
-	struct xfs_defer_drain	pag_intents_drain;
-
 	/* Hook to feed rmapbt updates to an active online repair. */
 	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index c5269cd659f327..dfcebf2e9b30f8 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -159,6 +159,8 @@ xfs_group_free(
 
 	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_ref) != 0);
 
+	xfs_defer_drain_free(&xg->xg_intents_drain);
+
 	if (uninit)
 		uninit(xg);
 
@@ -184,6 +186,7 @@ xfs_group_insert(
 #ifdef __KERNEL__
 	spin_lock_init(&xg->xg_state_lock);
 #endif
+	xfs_defer_drain_init(&xg->xg_intents_drain);
 
 	/* Active ref owned by mount indicates group is online. */
 	atomic_set(&xg->xg_active_ref, 1);
@@ -191,6 +194,7 @@ xfs_group_insert(
 	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
 	if (error) {
 		WARN_ON_ONCE(error == -EBUSY);
+		xfs_defer_drain_free(&xg->xg_intents_drain);
 		return error;
 	}
 
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index d2c61dd1f43e44..ebefbba7d98cc2 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -22,6 +22,15 @@ struct xfs_group {
 	uint16_t		xg_checked;
 	uint16_t		xg_sick;
 	spinlock_t		xg_state_lock;
+
+	/*
+	 * We use xfs_drain to track the number of deferred log intent items
+	 * that have been queued (but not yet processed) so that waiters (e.g.
+	 * scrub) will not lock resources when other threads are in the middle
+	 * of processing a chain of intent items only to find momentary
+	 * inconsistencies.
+	 */
+	struct xfs_defer_drain	xg_intents_drain;
 #endif /* __KERNEL__ */
 };
 

