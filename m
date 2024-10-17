Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7CF1E231F
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191093; cv=none; b=YbCyWQ2jNclVoWq9FXWUuilMS8RDOpOf09BS7MNvkViSfRL6BH3vhrI0jOfI9O/G2SzVoT3a6+vQ/iHlJCQ8TTtT7tLZe7bSHMf1SA3mQ5GU4KmSMpIn/zDu6rPGkGWiQ1+16OhCUS5OmWs8M/W5C+APiNzFH/MgBA4GXLdS+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191093; c=relaxed/simple;
	bh=fe/rqv1CFPb4f1GaWpE80qxvG3WULiEl1+ZyAXsc2vQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aGzJNTvsN8GNebnNtUXeh1w1mqCgVvLj9lHcgdGKzZBYjM+/hH/e2h+9cIk/iFh7BQGThBL1Yr44byB2AQFduGIKKBtdSyD+jpbR0LWRpMfD/AD4+9isWltSX3R067s7cb/fGCp0kUsCIByZpIBd7Id9a09p7M8nhu3wrBFyPW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQNNxaZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQNNxaZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F248DC4CEC3;
	Thu, 17 Oct 2024 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191093;
	bh=fe/rqv1CFPb4f1GaWpE80qxvG3WULiEl1+ZyAXsc2vQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HQNNxaZhphkFgi4eGeDFHN/C4XPAejgJ8Xy5vz7EDHHXPUj/kNi40wfqYr9wJ8odq
	 B2tVerOyMzsGWWvR0LV6eQlOoK4jyJSXvj5/RMHkG1fWtaPHqeNHBt5/wAMc/686hF
	 GuvmPncB/bTAK5XRMyHXJIqioxTRm5uHU5XPAy/EhtyBBxLeTViUPulQsdEijtJmIF
	 ogE8jsVuPSd4ntsqy8EzdqGTjjboo/4aZCu9L3Kp5UhgMkP9cdan7pIVSUazB8PF7S
	 HwTwHS45SsK63a6t/CfEbHpWuwN6+RumFRLtzCt6ej3KWf8XIY4jAZXYkLTMrIQmQ4
	 bOE3rYszNUMTw==
Date: Thu, 17 Oct 2024 11:51:32 -0700
Subject: [PATCH 21/22] xfs: split xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068225.3449971.8749061578521524802.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Factor out a xfs_perag_alloc helper that allocates a single perag
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |  119 +++++++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 6d8a1e42615dec..3e232b3d4c4262 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -293,6 +293,67 @@ xfs_update_last_ag_size(
 	return 0;
 }
 
+static int
+xfs_perag_alloc(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		index,
+	xfs_agnumber_t		agcount,
+	xfs_rfsblock_t		dblocks)
+{
+	struct xfs_perag	*pag;
+	int			error;
+
+	pag = kzalloc(sizeof(*pag), GFP_KERNEL);
+	if (!pag)
+		return -ENOMEM;
+
+	pag->pag_agno = index;
+	pag->pag_mount = mp;
+
+	error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
+	if (error) {
+		WARN_ON_ONCE(error == -EBUSY);
+		goto out_free_pag;
+	}
+
+#ifdef __KERNEL__
+	/* Place kernel structure only init below this point. */
+	spin_lock_init(&pag->pag_ici_lock);
+	spin_lock_init(&pag->pagb_lock);
+	spin_lock_init(&pag->pag_state_lock);
+	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+	xfs_defer_drain_init(&pag->pag_intents_drain);
+	init_waitqueue_head(&pag->pagb_wait);
+	pag->pagb_tree = RB_ROOT;
+	xfs_hooks_init(&pag->pag_rmap_update_hooks);
+#endif /* __KERNEL__ */
+
+	error = xfs_buf_cache_init(&pag->pag_bcache);
+	if (error)
+		goto out_remove_pag;
+
+	/* Active ref owned by mount indicates AG is online. */
+	atomic_set(&pag->pag_active_ref, 1);
+
+	/*
+	 * Pre-calculated geometry
+	 */
+	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
+	pag->min_block = XFS_AGFL_BLOCK(mp);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
+
+	return 0;
+
+out_remove_pag:
+	xfs_defer_drain_free(&pag->pag_intents_drain);
+	pag = xa_erase(&mp->m_perags, index);
+out_free_pag:
+	kfree(pag);
+	return error;
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -301,68 +362,22 @@ xfs_initialize_perag(
 	xfs_rfsblock_t		dblocks,
 	xfs_agnumber_t		*maxagi)
 {
-	struct xfs_perag	*pag;
 	xfs_agnumber_t		index;
 	int			error;
 
+	if (orig_agcount >= new_agcount)
+		return 0;
+
 	for (index = orig_agcount; index < new_agcount; index++) {
-		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
-		if (!pag) {
-			error = -ENOMEM;
+		error = xfs_perag_alloc(mp, index, new_agcount, dblocks);
+		if (error)
 			goto out_unwind_new_pags;
-		}
-		pag->pag_agno = index;
-		pag->pag_mount = mp;
-
-		error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
-		if (error) {
-			WARN_ON_ONCE(error == -EBUSY);
-			goto out_free_pag;
-		}
-
-#ifdef __KERNEL__
-		/* Place kernel structure only init below this point. */
-		spin_lock_init(&pag->pag_ici_lock);
-		spin_lock_init(&pag->pagb_lock);
-		spin_lock_init(&pag->pag_state_lock);
-		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
-		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-		xfs_defer_drain_init(&pag->pag_intents_drain);
-		init_waitqueue_head(&pag->pagb_wait);
-		pag->pagb_tree = RB_ROOT;
-		xfs_hooks_init(&pag->pag_rmap_update_hooks);
-#endif /* __KERNEL__ */
-
-		error = xfs_buf_cache_init(&pag->pag_bcache);
-		if (error)
-			goto out_remove_pag;
-
-		/* Active ref owned by mount indicates AG is online. */
-		atomic_set(&pag->pag_active_ref, 1);
-
-		/*
-		 * Pre-calculated geometry
-		 */
-		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
-				dblocks);
-		pag->min_block = XFS_AGFL_BLOCK(mp);
-		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
 	}
 
-	index = xfs_set_inode_alloc(mp, new_agcount);
-
-	if (maxagi)
-		*maxagi = index;
-
+	*maxagi = xfs_set_inode_alloc(mp, new_agcount);
 	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	return 0;
 
-out_remove_pag:
-	xfs_defer_drain_free(&pag->pag_intents_drain);
-	pag = xa_erase(&mp->m_perags, index);
-out_free_pag:
-	kfree(pag);
 out_unwind_new_pags:
 	xfs_free_perag_range(mp, orig_agcount, index);
 	return error;

