Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCEC1FBCA3
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844733; cv=none; b=deNuKPxijj24r8AjW2f/Uu6m23/G8UWQD+jnRU2UNDkohICEnHNY6EP8C7rLb3431xOKwXtdfdYPLDI1jzAjnSck1/lKc0GvDbSox/jGQWKcSvTz6d2nbO2TJ1RoLt05mDsREHQ37tPEdS7sbVjAI2yNCqDwbCTGQLAm9vRGerM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844733; c=relaxed/simple;
	bh=fR7TVaULaKxGpROPm21iLx3Cdt1npZ998yUAOXI3CiE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CB+yzSPhz9unYja05iUQEU7ubTYRZL8ip+cLaLQAjunYrd3qQulAEQiBqmzhlYiYdzoN0/znRohySV9TLd+sW6Rliu9mn03bskd9iEJgQ1Vi30A8rbwrVK1dKpokySsMzlA3yvivIntCm/x2kz/aYe13imm92HovunFjMpEU7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5YCgeI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5YCgeI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09338C4CECF;
	Tue,  5 Nov 2024 22:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844733;
	bh=fR7TVaULaKxGpROPm21iLx3Cdt1npZ998yUAOXI3CiE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B5YCgeI78YSE2J7i7mHr/eTl6vs85nMoVtsEwzBCuMs/tsRH3xNbYtnuKEHQiufg+
	 izERP4SXailKvOp0oLMq2xUF6GMBZRW3B3ekFn9LE+6cchI1bdPnP4t0okyDzYDfv9
	 uAvr0xkxltxxGrhXVC/8WYAq2spouTKAuS+AadfJ3JDUawJW4NuZlllD1eLYxFfvbY
	 8a+CXeml4zs09c//ohhQkQUlAWQKRnim92AkDmxvbNTv1qfspPOyp/AbNCWUoLi3T3
	 neEyokjZTYRRAunl50kwAxlNhqeHDkmIZHtnj688lWR5iW0M7Pyu4W1IVMcM24VvhJ
	 I2XQ5ydwZKp+A==
Date: Tue, 05 Nov 2024 14:12:12 -0800
Subject: [PATCH 22/23] xfs: split xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394829.1868694.1065842395535841786.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ag.c        |  121 ++++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_ag.h        |    4 +
 fs/xfs/xfs_buf_item_recover.c |    5 +-
 3 files changed, 74 insertions(+), 56 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9de48f3c71235d..3e232b3d4c4262 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -272,6 +272,10 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
+/*
+ * Update the perag of the previous tail AG if it has been changed during
+ * recovery (i.e. recovery of a growfs).
+ */
 int
 xfs_update_last_ag_size(
 	struct xfs_mount	*mp,
@@ -289,69 +293,57 @@ xfs_update_last_ag_size(
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
@@ -359,8 +351,35 @@ xfs_initialize_perag(
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
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index e0f567d90debee..8787823ae37f9f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
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
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 5180cbf5a90b4b..c627ad3a3bbbfd 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -724,9 +724,8 @@ xlog_recover_do_primary_sb_buffer(
 	}
 
 	/*
-	 * Growfs can also grow the last existing AG.  In this case we also need
-	 * to update the length in the in-core perag structure and values
-	 * depending on it.
+	 * If the last AG was grown or shrunk, we also need to update the
+	 * length in the in-core perag structure and values depending on it.
 	 */
 	error = xfs_update_last_ag_size(mp, orig_agcount);
 	if (error)

