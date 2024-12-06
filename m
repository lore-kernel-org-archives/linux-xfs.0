Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D6519ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528020; cv=none; b=Kl3vJGO77fAdCkWrCtKEYAkSDixOQCw50HFtyj5lr8WO9xv/IuGKHa3TFMvWc5g96NWCLrTXjOe9q38fsMQnoNiisIdqcPHpR1R2Lillqg5BOTWEFUTv6SPJNNCFNDVRO+7FNeFyTLpQj2QHoKX4G26m75kIMK513u3QJ+7xfV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528020; c=relaxed/simple;
	bh=aaU/ItFh4ML8lKga//9VnJCvPUjNn47R20Qd2exN4TY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IvVYJl+fAkUcbL8qxCBHO/kLho31JC1CJQsRTmzQfYfDOZUNrJyGxzyobznlnKbFq9LlXtyDhG/Z41iQ+5lp/QsYcJw/ccVOqL//MX79PE9hL64/EV4a8nn/AYyhs5yQECPmh2qDo2ruwEMFwr3UjfHytE6mtt3Td0bGUJBk3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OltBgvLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OltBgvLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D077FC4CED1;
	Fri,  6 Dec 2024 23:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528019;
	bh=aaU/ItFh4ML8lKga//9VnJCvPUjNn47R20Qd2exN4TY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OltBgvLWbDKtzeD5jiFX3rN6HSFcdfsXtKKg2z5jf106lH3w+1fVBzcVjSg54KP1I
	 XAnqUO/bBODAiI30YakIBGVT9Djx4LoiZ77fhxzgrLEtyUv+ytq1gF3l05nXB6pnaX
	 sHzniAahWdXMBQi97KpSGt6tiIv+wPUkdObVyKCyTXQTSFDKswWDkRZoo8rA1SAI9V
	 s/Er5MMCFhbNPjw/epJUUPapqcrMbQoh/36sa/N9g7dr3OXhBYPCPj+DnDwX8V51O0
	 t6UTkbYj2tKglHcopFx3RMd/9Suj5m89yw36ad3NZ2ryi5Wywyo6xKm853C2ZbiCNL
	 8zrkdmZeYSSLg==
Date: Fri, 06 Dec 2024 15:33:39 -0800
Subject: [PATCH 13/36] xfs: split xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747080.121772.867951615956948252.stgit@frogsfrogsfrogs>
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

Source kernel commit: 201c5fa342af75adaf762fd6c63380bb8001762d

Factor out a xfs_perag_alloc helper that allocates a single perag
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

