Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C65737F301
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370838; cv=none; b=DOjBLdpkbxICF4DnwHYxdCJCIcNo59UWhlTEbgEBoHF/q9pjYUNYEt/Br0bC/Y1WD+r4vS2O6gAmrXp0znTquxd6kl8mkomle5RQbIsDg6ZjMa5Mw3st/HyVFTLAieOAgsBQd74snir0OBM/TJ//KFxF6B0W5JB2l7ltzHFfF9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370838; c=relaxed/simple;
	bh=cl6J8rK6ZvvwyFDezztex/ZLLgd6S1GnLGzrf1y44sU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dujalj9qH5J9hnc5cpKp3b25XhGtcWMaecuR6NuVQXTFXGGDuUQG4jDv+l4UwxIvjP1xT/NvaH+H8WQxAycZCa+T1yeHzaeBECsaAruaV7NAXo0vFjUWpMATcBkw6Uw4QJkt/umpzP3AjkWRiPzMPMFCklKS4A7MZ9WGtWvH1eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChMy5L4r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChMy5L4r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AMR2Gh3ijKCx6zzl6mgDAbLJsKcscKTciuWniD98+sg=;
	b=ChMy5L4rZA4PAX7PuJsFIfLZ3AthX73yyFXKL20mFK/QVj+SuMmzGfPUrl84p3h5C7mFQy
	RwLRdSADvqF/NAqx/sEnt8zdCZOm30osZ7E3ZjS/Ad/ldHlYKBU+g3qJwIvAELXDxPJPsx
	9YaxB15r3Gpe0OUePjfQdKuB75cBtUU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-Sx4GRhTfN-qHKJgp10ikHQ-1; Wed,
 02 Sep 2026 13:40:33 -0400
X-MC-Unique: Sx4GRhTfN-qHKJgp10ikHQ-1
X-Mimecast-MFC-AGG-ID: Sx4GRhTfN-qHKJgp10ikHQ_1788370833
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D60DD195DE0C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:32 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7799C1800767
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/4] xfs: calculate AGFL max to support multiple-alloc transactions
Date: Wed,  2 Sep 2026 13:40:24 -0400
Message-ID: <20260902174025.284387-4-bfoster@redhat.com>
In-Reply-To: <20260902174025.284387-1-bfoster@redhat.com>
References: <20260902174025.284387-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Rework xfs_alloc_min_freelist() to return an (optional) max value
along with the historical min freelist value. The max value
includes an extra level in the btree based calculation to account
for btree splits in the first allocation of a multi-alloc sequence.

This value reflects the worst case AGFL requirement that can be
expected across multiple allocations within a single AG and single
transaction. For example, consider the case of allocating an inode
chunk and then an inobt block on inode record insertion.

While here, rename the need variable in xfs_alloc_fix_freelist() for
clarity with upcoming changes.

Note that no callers calculate the max AGFL value as of yet. No
functional changes in this patch.

Assisted-by: LLM
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 35 ++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_alloc.h  |  4 ++--
 fs/xfs/libxfs/xfs_bmap.c   |  5 +++--
 fs/xfs/libxfs/xfs_ialloc.c |  4 +++-
 4 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index dbb85fb6314b..1377c65d694e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2445,7 +2445,7 @@ xfs_alloc_longest_free_extent(
  * multi-allocation transactions.
  */
 static unsigned int
-__xfs_alloc_min_freelist(
+__xfs_alloc_freelist(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	unsigned int		extra_levels)
@@ -2492,12 +2492,21 @@ __xfs_alloc_min_freelist(
 	return min_free;
 }
 
-unsigned int
-xfs_alloc_min_freelist(
+/*
+ * Compute the minimum and maximum length of the AGFL in the given AG. The max
+ * value in this context refers to the max requirement the AG might see in a
+ * multi-alloc transaction. If @pag is NULL, return the largest possible values.
+ */
+void
+xfs_alloc_freelist(
 	struct xfs_mount	*mp,
-	struct xfs_perag	*pag)
+	struct xfs_perag	*pag,
+	unsigned int		*min_free,
+	unsigned int		*max_free)
 {
-	return __xfs_alloc_min_freelist(mp, pag, 0);
+	*min_free = __xfs_alloc_freelist(mp, pag, 0);
+	if (max_free)
+		*max_free = __xfs_alloc_freelist(mp, pag, 1);
 }
 
 /*
@@ -2849,7 +2858,7 @@ xfs_alloc_fix_freelist(
 	struct xfs_buf		*agflbp = NULL;
 	struct xfs_alloc_arg	targs;	/* local allocation arguments */
 	xfs_agblock_t		bno;	/* freelist block */
-	xfs_extlen_t		need;	/* total blocks needed in freelist */
+	xfs_extlen_t		min_free;/* total blocks needed in freelist */
 	int			error = 0;
 
 	/* deferred ops (AGFL block frees) require permanent transactions */
@@ -2877,8 +2886,8 @@ xfs_alloc_fix_freelist(
 		goto out_agbp_relse;
 	}
 
-	need = xfs_alloc_min_freelist(mp, pag);
-	if (!xfs_alloc_space_available(args, need, alloc_flags |
+	xfs_alloc_freelist(mp, pag, &min_free, NULL);
+	if (!xfs_alloc_space_available(args, min_free, alloc_flags |
 			XFS_ALLOC_FLAG_CHECK))
 		goto out_agbp_relse;
 
@@ -2901,8 +2910,8 @@ xfs_alloc_fix_freelist(
 		xfs_agfl_reset(tp, agbp, pag);
 
 	/* If there isn't enough total space or single-extent, reject it. */
-	need = xfs_alloc_min_freelist(mp, pag);
-	if (!xfs_alloc_space_available(args, need, alloc_flags))
+	xfs_alloc_freelist(mp, pag, &min_free, NULL);
+	if (!xfs_alloc_space_available(args, min_free, alloc_flags))
 		goto out_agbp_relse;
 
 	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
@@ -2944,7 +2953,7 @@ xfs_alloc_fix_freelist(
 	else
 		targs.oinfo = XFS_RMAP_OINFO_AG;
 	while (!(alloc_flags & XFS_ALLOC_FLAG_NOSHRINK) &&
-			pag->pagf_flcount > need) {
+			pag->pagf_flcount > min_free) {
 		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
@@ -2978,9 +2987,9 @@ xfs_alloc_fix_freelist(
 		goto out_agbp_relse;
 
 	/* Make the freelist longer if it's too short. */
-	while (pag->pagf_flcount < need) {
+	while (pag->pagf_flcount < min_free) {
 		targs.agbno = 0;
-		targs.maxlen = need - pag->pagf_flcount;
+		targs.maxlen = min_free - pag->pagf_flcount;
 		targs.resv = XFS_AG_RESV_AGFL;
 
 		/* Allocate as many blocks as possible at once. */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 50ef79a1ed41..44a10f4a22a2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -71,8 +71,8 @@ unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
 
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
 		xfs_extlen_t need, xfs_extlen_t reserved);
-unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
-		struct xfs_perag *pag);
+void xfs_alloc_freelist(struct xfs_mount *mp, struct xfs_perag *pag,
+		unsigned int *min_free, unsigned int *max_free);
 int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
 int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..17604e510ffc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3150,6 +3150,7 @@ xfs_bmap_longest_free_extent(
 	xfs_extlen_t		*blen)
 {
 	xfs_extlen_t		longest;
+	unsigned int		min_free;
 	int			error = 0;
 
 	if (!xfs_perag_initialised_agf(pag)) {
@@ -3159,8 +3160,8 @@ xfs_bmap_longest_free_extent(
 			return error;
 	}
 
-	longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(pag_mount(pag), pag),
+	xfs_alloc_freelist(pag_mount(pag), pag, &min_free, NULL);
+	longest = xfs_alloc_longest_free_extent(pag, min_free,
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index edcda77b11ac..56aba1eff8af 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -3074,6 +3074,7 @@ xfs_ialloc_calc_rootino(
 {
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_agblock_t		first_bno;
+	unsigned int		min_free;
 
 	/*
 	 * Pre-calculate the geometry of AG 0.  We know what it looks like
@@ -3092,7 +3093,8 @@ xfs_ialloc_calc_rootino(
 	first_bno += 1;
 
 	/* ...the initial AGFL... */
-	first_bno += xfs_alloc_min_freelist(mp, NULL);
+	xfs_alloc_freelist(mp, NULL, &min_free, NULL);
+	first_bno += min_free;
 
 	/* ...the free inode btree root... */
 	if (xfs_has_finobt(mp))
-- 
2.55.0

