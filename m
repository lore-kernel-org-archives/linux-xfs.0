Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4809E18052
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990031; cv=none; b=ZuEmAw4vFfsxlKO81V7lehFSjyaJFP+PJaK21Dho7vrbANGox4uZNEjxMoCKLEQib/RUwNk8CMzu3ecc6Puu3tKr60o8U5sWC536L++/3xysOXJA20LQxNlYuTJeHFh9JP+ALdXouExBi3vE8T9pz4PzwWwrzyjV1x4Xm0DNhww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990031; c=relaxed/simple;
	bh=ysOYdj7SJ0TcgzIM7t4KJH5hggQmaN4qBjOrMfGz70o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+HXy5VFkxVo/0+MjxJJoYgmnhJGOyjYP+ppWznlTWx/50xPu2ZVX6znTEB7OrYEVMk9TRnI1TE8z/ZjrvrfpIJbYg5ASxeIE/riVzDLrdAC9+5O35A+41WieMuWOAvNxA4tXRWhVGDRFNbQIVelkLUT6J0/e9RGYgJzGrKFi40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYvhUsvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYvhUsvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B93C4CED3;
	Mon, 23 Dec 2024 21:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990031;
	bh=ysOYdj7SJ0TcgzIM7t4KJH5hggQmaN4qBjOrMfGz70o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TYvhUsvbCHmqsU3bjYRdMZxFXII9zRr+Sc7APIArmtyZgbWZKvmehBqjNg+xk1f/K
	 f9BYleNQU1V7eH9PtmGDGDWLE3V/ZejC5RDwk0pPUuq8Y7hUFut1aPi0GEKygFcjaG
	 Ivgc6D3HGkyEavlOJ8Cwc/Orvv+Ev5rT4RUaYlr/shR/7+9zkxhpCoiSkDuBKHz3dX
	 L9d7zTx+e7aYQ1qTKLqbGFVhbdZBrBiCAQI5d3lSDuDgc8DWnxPHgFZXIJOJvJeixn
	 OL2Jorr5ALkClDgpJ2fO0AmhAjLAx+3FydWD/YXL9ceSXHWlKc8muZj/4pon33s1nT
	 hrSz/VHQ7Cf0Q==
Date: Mon, 23 Dec 2024 13:40:30 -0800
Subject: [PATCH 13/36] xfs: split xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940146.2293042.2594553624248150640.stgit@frogsfrogsfrogs>
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

Source kernel commit: 201c5fa342af75adaf762fd6c63380bb8001762d

Factor out a xfs_perag_alloc helper that allocates a single perag
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c |  121 ++++++++++++++++++++++++++++++++-----------------------
 libxfs/xfs_ag.h |    4 +-
 2 files changed, 72 insertions(+), 53 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index a6b5a7d71bbf80..8809d76d496ae9 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -270,6 +270,10 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
+/*
+ * Update the perag of the previous tail AG if it has been changed during
+ * recovery (i.e. recovery of a growfs).
+ */
 int
 xfs_update_last_ag_size(
 	struct xfs_mount	*mp,
@@ -287,69 +291,57 @@ xfs_update_last_ag_size(
 	return 0;
 }
 
-int
-xfs_initialize_perag(
+static int
+xfs_perag_alloc(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		old_agcount,
-	xfs_agnumber_t		new_agcount,
-	xfs_rfsblock_t		dblocks,
-	xfs_agnumber_t		*maxagi)
+	xfs_agnumber_t		index,
+	xfs_agnumber_t		agcount,
+	xfs_rfsblock_t		dblocks)
 {
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		index;
 	int			error;
 
-	for (index = old_agcount; index < new_agcount; index++) {
-		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
-		if (!pag) {
-			error = -ENOMEM;
-			goto out_unwind_new_pags;
-		}
-		pag->pag_agno = index;
-		pag->pag_mount = mp;
+	pag = kzalloc(sizeof(*pag), GFP_KERNEL);
+	if (!pag)
+		return -ENOMEM;
 
-		error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
-		if (error) {
-			WARN_ON_ONCE(error == -EBUSY);
-			goto out_free_pag;
-		}
+	pag->pag_agno = index;
+	pag->pag_mount = mp;
+
+	error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
+	if (error) {
+		WARN_ON_ONCE(error == -EBUSY);
+		goto out_free_pag;
+	}
 
 #ifdef __KERNEL__
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
 #endif /* __KERNEL__ */
 
-		error = xfs_buf_cache_init(&pag->pag_bcache);
-		if (error)
-			goto out_remove_pag;
+	error = xfs_buf_cache_init(&pag->pag_bcache);
+	if (error)
+		goto out_remove_pag;
 
-		/* Active ref owned by mount indicates AG is online. */
-		atomic_set(&pag->pag_active_ref, 1);
+	/* Active ref owned by mount indicates AG is online. */
+	atomic_set(&pag->pag_active_ref, 1);
 
-		/*
-		 * Pre-calculated geometry
-		 */
-		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
-				dblocks);
-		pag->min_block = XFS_AGFL_BLOCK(mp);
-		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
-	}
+	/*
+	 * Pre-calculated geometry
+	 */
+	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
+	pag->min_block = XFS_AGFL_BLOCK(mp);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
 
-	index = xfs_set_inode_alloc(mp, new_agcount);
-
-	if (maxagi)
-		*maxagi = index;
-
-	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
 	return 0;
 
 out_remove_pag:
@@ -357,8 +349,35 @@ xfs_initialize_perag(
 	pag = xa_erase(&mp->m_perags, index);
 out_free_pag:
 	kfree(pag);
+	return error;
+}
+
+int
+xfs_initialize_perag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		orig_agcount,
+	xfs_agnumber_t		new_agcount,
+	xfs_rfsblock_t		dblocks,
+	xfs_agnumber_t		*maxagi)
+{
+	xfs_agnumber_t		index;
+	int			error;
+
+	if (orig_agcount >= new_agcount)
+		return 0;
+
+	for (index = orig_agcount; index < new_agcount; index++) {
+		error = xfs_perag_alloc(mp, index, new_agcount, dblocks);
+		if (error)
+			goto out_unwind_new_pags;
+	}
+
+	*maxagi = xfs_set_inode_alloc(mp, new_agcount);
+	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
+	return 0;
+
 out_unwind_new_pags:
-	xfs_free_perag_range(mp, old_agcount, index);
+	xfs_free_perag_range(mp, orig_agcount, index);
 	return error;
 }
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index e0f567d90debee..8787823ae37f9f 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -142,8 +142,8 @@ __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
-int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
-		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
+int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t orig_agcount,
+		xfs_agnumber_t new_agcount, xfs_rfsblock_t dcount,
 		xfs_agnumber_t *maxagi);
 void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
 		xfs_agnumber_t end_agno);

