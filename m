Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB091E5718
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416529; cv=none; b=u9Y2dFmILJHUXrm8vepuaBVDkz/De2DLYoYhG68RqfFzvQk95HX4Vvfz2RJRqX1LDl+Q+yeyyQLnwhdJgj1ZZpY47UuxweTiskKY1QmJaR2guV9WpRLOyqYxBWs2BFOfVKI45tzn+FL3XyGY2Zj6IAxckNfISNmG5QNzSKEmks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416529; c=relaxed/simple;
	bh=Qmn9OrxK4wzDuVTLItqmshC7ZRAaMO3p3BfMEhMTcD0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvaMLt7/Pkg6rCyo7ARPp3wlswpjwah3StuKv4jeLUM/AJD5xv9dT745weFVLAvSoXJfTFCqJIyKKOOB2pISy/a7Bc7ACzz6J/yEtKxJTLy/5pTWmhbX+sTgOElhIYRBFpfMNNNbqGwxKDFV+Xr5+Q35RtKULm/uOmc6p8L7+8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g46R6MpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g46R6MpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA373C4CED1;
	Thu, 31 Oct 2024 23:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416528;
	bh=Qmn9OrxK4wzDuVTLItqmshC7ZRAaMO3p3BfMEhMTcD0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g46R6MpGvH8Dnnsu38vfzUDQ1W6DPOQyIwJMGLlcV5eUdTPHaZbD0LVF3dMK4GxqC
	 AwwW5hay1U+FUlmGkEfSwEh9Hs/iQ2q1sFLrcVPSE2lWSRsna7XHVogMxxGq8oQ9N8
	 OgsoGU278z3QS22A5ZBYG9iCSJ6DO40e88BeEUm6q3j4nQlKs1wTIe21hbBMe1vHu2
	 SrhQZcWj+jY2l48hSHx1mZV0OJ2MusxfgwjQDmly11LktAl4yvaDk2M7Uc0Kj9CX31
	 GTRWzfO45qcF+5sExX45dzXja9oWv0q0sKTUvGxZxQ5eVWZXLgubbNXvF88WB67exE
	 jHMav1TiL6fcg==
Date: Thu, 31 Oct 2024 16:15:28 -0700
Subject: [PATCH 26/41] xfs: move the tagged perag lookup helpers to
 xfs_icache.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566314.962545.11718050456087618636.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f48f0a8e00b67028d4492e7656b346fa0d806570

The tagged perag helpers are only used in xfs_icache.c in the kernel code
and not at all in xfsprogs.  Move them to xfs_icache.c in preparation for
switching to an xarray, for which I have no plan to implement the tagged
lookup functions for userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ag.c |   51 ---------------------------------------------------
 libxfs/xfs_ag.h |   11 -----------
 2 files changed, 62 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1b65ba983ad542..a63d9c0dc6fe44 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
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
@@ -125,32 +100,6 @@ xfs_perag_grab(
 	return pag;
 }
 
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
-	rcu_read_unlock();
-	return pag;
-}
-
 void
 xfs_perag_rele(
 	struct xfs_perag	*pag)
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index d62c266c0b44d5..d9cccd093b60e0 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -153,15 +153,11 @@ void xfs_free_perag(struct xfs_mount *mp);
 
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
@@ -263,13 +259,6 @@ xfs_perag_next(
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

