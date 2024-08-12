Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E1615445E
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 06:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723444375; cv=none; b=nz950LC2CNTdIQPbDGJoQNmXGP2aBxc/OEhXpKb+IK3CiMTMjfG/pFHu66r7aFZKBiDFUpqXZH1eHBWQi+uAlbgoMPbRv3rJw8nwTxGKAUCQ80Smz0So9qSZVH9M9xPJt7SXeomLZX1KsW9P5eIxE4FVZ8LTZKxdsD6IAsXpag4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723444375; c=relaxed/simple;
	bh=TT0wn12QQoMP02iBVXXsD0XxsRPEVIERyeavF5ayv2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hn4eAvPxKZyW/UIQ/FhTKEcSl+wLH11MWyEn6BIsHELs9+8Gmo5IFXv4JsF/PSypisIm6M6RJSgYt692AIs+C25qPDvT+nYpnc+ldYMw8MQJbpzDNILkYeqy92b/SPkGGXwgKFTOEtXEC4A/7+ppTkpaDOVALJJXQechSbR8Ux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FwIlS1l0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FwIlS1l0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JNH+9KDGAfvUlD+jN+opZ2Q+8YcI93Y/Pb31vyKlMxs=; b=FwIlS1l0W01TxvlrvseIhYhuHw
	vz6yqbvKT81r/BqNH8ygUeW4eR5OWqKNxAC3PV0N92AZseyMVKoUuDt4in8heAx6vEZ481wS8lDEu
	QhQ9rq0XoT/dYvFKO/DK+GDTDHoMB6qjHL5G3AkJ3QgW/M8YEeGC22wV4GfUg8AmbN60BVBuEzMJK
	uG5YPnx5arvTxCYWz6jT4xGZGSNgMWP5u7meS5UPSfe8UHLfS1noRWrXYgztP1H1O4VWAcS7gaI2f
	AX6GzWNldGvsfOwIgb71kvDEW//aBiIYNFMh+NuFp6bsIL+wKq9XtHSIVi2wF6eqdKz15F02199BM
	my2C1JUQ==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdObs-0000000H1fb-3Z5o;
	Mon, 12 Aug 2024 06:32:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: convert perag lookup to xarray
Date: Mon, 12 Aug 2024 08:32:30 +0200
Message-ID: <20240812063243.3806779-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812063243.3806779-1-hch@lst.de>
References: <20240812063243.3806779-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: ab6159870e68c198e4990faa8f82f348657d73f9

Convert the perag lookup from the legacy radix tree to the xarray,
which allows for much nicer iteration and bulk lookup semantics.

Note that this removes the helpers for tagged get and grab and the
for_each* wrappers built around them and instead uses the xa_for_each*
iteration helpers directly in xfs_icache.c, which simplifies the code
nicely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h |  2 +-
 libxfs/init.c       |  2 +-
 libxfs/xfs_ag.c     | 81 +++++----------------------------------------
 libxfs/xfs_ag.h     | 11 ------
 4 files changed, 10 insertions(+), 86 deletions(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index a9525e4e0..4289e4be2 100644
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
index 90a539e04..85149c7a9 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -664,7 +664,7 @@ libxfs_mount(
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
-	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
+	xa_init(&mp->m_perags);
 	sbp = &mp->m_sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 47522d0fc..58ca12f6e 100644
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
@@ -54,31 +54,6 @@ xfs_perag_get(
 	return pag;
 }
 
-/*
- * search from @first to find the next perag with the given tag set.
- */
-struct xfs_perag *
-xfs_perag_get_tag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		first,
-	unsigned int		tag)
-{
-	struct xfs_perag	*pag;
-	int			found;
-
-	rcu_read_lock();
-	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-					(void **)&pag, first, 1, tag);
-	if (found <= 0) {
-		rcu_read_unlock();
-		return NULL;
-	}
-	trace_xfs_perag_get_tag(pag, _RET_IP_);
-	atomic_inc(&pag->pag_ref);
-	rcu_read_unlock();
-	return pag;
-}
-
 /* Get a passive reference to the given perag. */
 struct xfs_perag *
 xfs_perag_hold(
@@ -115,38 +90,13 @@ xfs_perag_grab(
 	struct xfs_perag	*pag;
 
 	rcu_read_lock();
-	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	pag = xa_load(&mp->m_perags, agno);
 	if (pag) {
 		trace_xfs_perag_grab(pag, _RET_IP_);
 		if (!atomic_inc_not_zero(&pag->pag_active_ref))
 			pag = NULL;
 	}
-	rcu_read_unlock();
-	return pag;
-}
 
-/*
- * search from @first to find the next perag with the given tag set.
- */
-struct xfs_perag *
-xfs_perag_grab_tag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		first,
-	int			tag)
-{
-	struct xfs_perag	*pag;
-	int			found;
-
-	rcu_read_lock();
-	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-					(void **)&pag, first, 1, tag);
-	if (found <= 0) {
-		rcu_read_unlock();
-		return NULL;
-	}
-	trace_xfs_perag_grab_tag(pag, _RET_IP_);
-	if (!atomic_inc_not_zero(&pag->pag_active_ref))
-		pag = NULL;
 	rcu_read_unlock();
 	return pag;
 }
@@ -254,9 +204,7 @@ xfs_free_perag(
 	xfs_agnumber_t		agno;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, agno);
-		spin_unlock(&mp->m_perag_lock);
+		pag = xa_erase(&mp->m_perags, agno);
 		ASSERT(pag);
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
@@ -345,9 +293,7 @@ xfs_free_unused_perag_range(
 	xfs_agnumber_t		index;
 
 	for (index = agstart; index < agend; index++) {
-		spin_lock(&mp->m_perag_lock);
-		pag = radix_tree_delete(&mp->m_perag_tree, index);
-		spin_unlock(&mp->m_perag_lock);
+		pag = xa_erase(&mp->m_perags, index);
 		if (!pag)
 			break;
 		xfs_buf_cache_destroy(&pag->pag_bcache);
@@ -388,20 +334,11 @@ xfs_initialize_perag(
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
+		error = xa_set(&mp->m_perags, index, pag, GFP_KERNEL);
+		if (error) {
+			WARN_ON_ONCE(error == -EEXIST);
 			goto out_free_pag;
 		}
-		spin_unlock(&mp->m_perag_lock);
-		radix_tree_preload_end();
 
 #ifdef __KERNEL__
 		/* Place kernel structure only init below this point. */
@@ -449,9 +386,7 @@ xfs_initialize_perag(
 
 out_remove_pag:
 	xfs_defer_drain_free(&pag->pag_intents_drain);
-	spin_lock(&mp->m_perag_lock);
-	radix_tree_delete(&mp->m_perag_tree, index);
-	spin_unlock(&mp->m_perag_lock);
+	pag = xa_erase(&mp->m_perags, index);
 out_free_pag:
 	kfree(pag);
 out_unwind_new_pags:
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 35de09a25..b5eee2c78 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -156,15 +156,11 @@ void xfs_free_perag(struct xfs_mount *mp);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
-struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
-		unsigned int tag);
 struct xfs_perag *xfs_perag_hold(struct xfs_perag *pag);
 void xfs_perag_put(struct xfs_perag *pag);
 
 /* Active AG references */
 struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
-struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
-				   int tag);
 void xfs_perag_rele(struct xfs_perag *pag);
 
 /*
@@ -266,13 +262,6 @@ xfs_perag_next(
 	(agno) = 0; \
 	for_each_perag_from((mp), (agno), (pag))
 
-#define for_each_perag_tag(mp, agno, pag, tag) \
-	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
-		(pag) != NULL; \
-		(agno) = (pag)->pag_agno + 1, \
-		xfs_perag_rele(pag), \
-		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
-
 static inline struct xfs_perag *
 xfs_perag_next_wrap(
 	struct xfs_perag	*pag,
-- 
2.43.0

