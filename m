Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C752CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548359; cv=none; b=sOb5qd5JSJPiWNlsftxWUTlbkfzfRRdHvRrnt/oWbMT42BzofNuP1dqWbl1DoYdsjTRUvc1JVnCoPIMRQZyRe+UrKbtHUgEYc1+KEB2o4K2e6kRWz2n7Lz/K2frk1kXovH4yNsbhVStBsWtPcXyy3BbGbMvKyEZDzyJMDld0mUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548359; c=relaxed/simple;
	bh=Z5PTxTzZvT5FHq50HAYjqs84TOGr+Llh5TenJ5GDO48=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ed5ZPjgt7iPv/rlnTzKtkx5daUOcOxTqfKa/lxU87uXKjZrqGkcFizoCDySBMRmiPaLnQNIQgKWk6ysFq99COtFSZ/7BafvA8tB3goSAC2GJNFkQAv2+jzwUtm4vEzDvcY7lJcnVXA/n7Uo2TMA75qn5K5F6xXwpUo22A6meGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJ0Nn9WO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJ0Nn9WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E72C4CEC3;
	Mon, 21 Oct 2024 22:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548358;
	bh=Z5PTxTzZvT5FHq50HAYjqs84TOGr+Llh5TenJ5GDO48=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MJ0Nn9WOa7rKbUIPmMAIwRX8L3fmg2gdKa69oRQNhqdFWnJ4vC7CCDjI5DeHgrATA
	 CyUpCHm11QvR/F/GuItKZTZyxUeTbob0+EyCOODJMrOKvlObhvpwtn0gungj8v2jSK
	 n3xWyoSPx28LOBo0v6t/JnLs/CsMxnSNV22BzgxHud/bpsGYh8elOTSPU4BHuOIkL0
	 XXWC3kEM42lzjFrIUfGLkLcAn40w/q7YfvOhdI5ExEWLmmf87X9Lt6dOw83qp3332x
	 ArnGsRCm+UxsFm537Q/+Q/dqn931QtyIH9As/mMN36XkGyIZms/kcySHv7+/6DUw2e
	 DiKOnUPakbBPA==
Date: Mon, 21 Oct 2024 15:05:58 -0700
Subject: [PATCH 27/37] xfs: convert perag lookup to xarray
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783879.34558.17948109160181557361.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 32fa4059fe6776d7db1e9058f360e06b36c9f2ce

Convert the perag lookup from the legacy radix tree to the xarray,
which allows for much nicer iteration and bulk lookup semantics.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 include/xfs_mount.h |    2 +-
 libxfs/init.c       |    2 +-
 libxfs/xfs_ag.c     |   31 ++++++++-----------------------
 3 files changed, 10 insertions(+), 25 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 7571df12fba3f8..e2add8a648f887 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -91,7 +91,7 @@ typedef struct xfs_mount {
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
-	struct radix_tree_root	m_perag_tree;
+	struct xarray		m_perags;
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
diff --git a/libxfs/init.c b/libxfs/init.c
index 6ab5ef54bb69cb..1e45f091dbb5bf 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -662,7 +662,7 @@ libxfs_mount(
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
-	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
+	xa_init(&mp->m_perags);
 	sbp = &mp->m_sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index a63d9c0dc6fe44..516c76790cc0d8 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -44,7 +44,7 @@ xfs_perag_get(
 	struct xfs_perag	*pag;
 
 	rcu_read_lock();
-	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	pag = xa_load(&mp->m_perags, agno);
 	if (pag) {
 		trace_xfs_perag_get(pag, _RET_IP_);
 		ASSERT(atomic_read(&pag->pag_ref) >= 0);
@@ -90,7 +90,7 @@ xfs_perag_grab(
 	struct xfs_perag	*pag;
 
 	rcu_read_lock();
-	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	pag = xa_load(&mp->m_perags, agno);
 	if (pag) {
 		trace_xfs_perag_grab(pag, _RET_IP_);
 		if (!atomic_inc_not_zero(&pag->pag_active_ref))
@@ -193,9 +193,7 @@ xfs_free_perag(
 	xfs_agnumber_t		agno;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, agno);
-		spin_unlock(&mp->m_perag_lock);
+		pag = xa_erase(&mp->m_perags, agno);
 		ASSERT(pag);
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
@@ -284,9 +282,7 @@ xfs_free_unused_perag_range(
 	xfs_agnumber_t		index;
 
 	for (index = agstart; index < agend; index++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, index);
-		spin_unlock(&mp->m_perag_lock);
+		pag = xa_erase(&mp->m_perags, index);
 		if (!pag)
 			break;
 		xfs_buf_cache_destroy(&pag->pag_bcache);
@@ -327,20 +323,11 @@ xfs_initialize_perag(
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 
-		error = radix_tree_preload(GFP_KERNEL | __GFP_RETRY_MAYFAIL);
-		if (error)
-			goto out_free_pag;
-
-		spin_lock(&mp->m_perag_lock);
-		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
-			WARN_ON_ONCE(1);
-			spin_unlock(&mp->m_perag_lock);
-			radix_tree_preload_end();
-			error = -EEXIST;
+		error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
+		if (error) {
+			WARN_ON_ONCE(error == -EBUSY);
 			goto out_free_pag;
 		}
-		spin_unlock(&mp->m_perag_lock);
-		radix_tree_preload_end();
 
 #ifdef __KERNEL__
 		/* Place kernel structure only init below this point. */
@@ -388,9 +375,7 @@ xfs_initialize_perag(
 
 out_remove_pag:
 	xfs_defer_drain_free(&pag->pag_intents_drain);
-	spin_lock(&mp->m_perag_lock);
-	radix_tree_delete(&mp->m_perag_tree, index);
-	spin_unlock(&mp->m_perag_lock);
+	pag = xa_erase(&mp->m_perags, index);
 out_free_pag:
 	kfree(pag);
 out_unwind_new_pags:

