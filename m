Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAAC4431
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607436; cv=none; b=o1HkSEBQfTARk/peomsVBjxAP+lC4dlbMu0F7fLiZLnAdx/6aPZ4EqJD9EVMhXXBpSgiuouf4FFChfg2LwK4PHQE5hisx9Fss511Wa8LuUfXh4TTFvNx4BHd8MbDpmWdfCjYxIxcxyBiO+1m5n11tSz0c7zVOcaBW302AXMenLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607436; c=relaxed/simple;
	bh=HzM0x5gHcztBUlFNoDO9vebZhRidkqEPhQFen4cmcEg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JLkUfc8j4fVVu/qFxZ6bqcAoiIWS4mFKBV0910S7uFezCKXf98D+kf5uHqfbIgiZFOwWOwg3Yyyyah0B5i+gSTTssw5Ep4a63DCDIqgkYKnOo4lAYxBMcF8pO0SiFYczZUTeKI+u6pSvl97ijzkKqSoeGW/72B55Pgnvz7mFkmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AvACs2F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AvACs2F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5643CC4CEC5;
	Fri, 11 Oct 2024 00:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607436;
	bh=HzM0x5gHcztBUlFNoDO9vebZhRidkqEPhQFen4cmcEg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AvACs2F/l2YXL7f3bytJNaQssf2fuE8KCA3sa5VGreisClJmARgWKI2KLK0dZt3Qe
	 WllVwLrgzXAiHUIltjUfKJLcplfka9sFmLSPa+YXB4+hwHn8BVDW4OuqyYpdZ44KGr
	 q80xGhhWZAPfTZ4ASPs6/9RbWnv2PXnW7RIP4Kw/iJKBKjiJW7bOVaqE+/fWGTfi4l
	 7TOj0SDDtLFgqQJ7a1PG0UNrXYXk5Jt61iPoRgoKdAxplk5PIch9Q75xVaV/MYG37y
	 NU1a1HXXsHmqcvTbblHPbiwyN6YtQ4CqdOS2QpsGi2OSWxnFFo7sphakqTwyJEzJv0
	 w+WQYn07GrhFA==
Date: Thu, 10 Oct 2024 17:43:55 -0700
Subject: [PATCH 24/25] xfs: split xfs_initialize_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640826.4175438.18290410029780454864.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
 fs/xfs/libxfs/xfs_ag.c |  116 ++++++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 3c62478b4b2e58..23d62acc89dc78 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -272,6 +272,67 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
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
@@ -280,7 +341,6 @@ xfs_initialize_perag(
 	xfs_rfsblock_t		dblocks,
 	xfs_agnumber_t		*maxagi)
 {
-	struct xfs_perag	*pag;
 	xfs_agnumber_t		index;
 	int			error;
 
@@ -288,63 +348,15 @@ xfs_initialize_perag(
 		return 0;
 
 	for (index = old_agcount; index < new_agcount; index++) {
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
 	xfs_free_perag_range(mp, old_agcount, index);
 	return error;

