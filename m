Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EC419ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528113; cv=none; b=iibjsDLlJfLEGamdCYhkqCZrkYTnBIeqmvhpuHsn4KlUl2W4XYijElKc2uBedsnhpbwKQgKoSAq1KftgAj3fRZXeYDJdf4P4g+sjqnRw/WeOyNMKhexYdzPM8VbHIN8pOFg0ofU+w61esu+U4XWL1YiSwB3nLzqX650CX7QCtKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528113; c=relaxed/simple;
	bh=2+0NHwJPfZbN3FbvKf+1GSVKoi27sF11Vfu7nE3YvjU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JznEIQSmC1226AdxjNVckjTpyAOsKyWY5Q+cyt2y59BrNmAZAbDdTiqdApAyE41wFx/WKHRkN6ZE2K9aWdgC6O4Ko42yhUszsS7tTqoJkOEcOyjJ1ZcD8JshVM1AZx2ikEAVHGGtXcjol8Jwk/yvd4lYhQRNrAtTcshuxi/QR28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JqgITbuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JqgITbuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E96C4CED1;
	Fri,  6 Dec 2024 23:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528113;
	bh=2+0NHwJPfZbN3FbvKf+1GSVKoi27sF11Vfu7nE3YvjU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JqgITbuTaBO68UiqcACUM8HW4+VQPAj3uOJGFeqtnoZKtP8R19j/sl75EV/Gi16i1
	 AEm7WvUMdASXX0/Au2nUFp0cDGEYLCaB6O3kN4wZgoOfB0vhqprOChiUdqhSTp1ic6
	 tf35yzHtEEKo6BI78NtZaTqX94yS+9nSQZtOC2CZ059oRwJKKZqUWNiIj5sGucQlaM
	 gzUaYZId+NoJeyY12Vkc+16VEQLzlXPwLKrk8eX7Kq3VqugV9+zoGz8t9tNX4F/Ys4
	 vqHOLCRTNKSR23H8fpj9GyJIONO4gKgbSnVl3zDj25B5rd0Pi9dBY15hRWarF2nBp6
	 1RJ/aBLpyq1BQ==
Date: Fri, 06 Dec 2024 15:35:13 -0800
Subject: [PATCH 19/36] xfs: move draining of deferred operations to the
 generic group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747165.121772.8123048951170093788.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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
 

