Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E391D47F3C9
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201687; cv=none; b=X0D9vt9AO7J9QP1/XuWVDg/dGT+lslzzsx7QlS+bp+NFNUd5KYLWQA+ieTAg0LvRnRj2DCmTMsmCZHfGhJpXiS5jiwWiuMbDBFfZWhgI/xeApy1UpNLyAyjx3h3znJxmmHzySf9VFCWFv6FAwVERyWdhk+VlrBCCiN9dJeZNC48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201687; c=relaxed/simple;
	bh=0VK9Lpy1BvOP+Q8uOBXkxHURUQ7bsa98e/N9yf7EYgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBPb/Y/hnVJESgC3JWyM8HZMmFoteOAUcU4k+0xUPZZy/jwZbEKfUKoJmHg0Ll+B9V3JrK1Uy8wSadWNExal3gfxlqAzeLi4xi1QRPpFZeq3h69f4V4wCKJd74E9cVOeWlrcNKiQYW2UhGpjmC6IDvSiisrxoJq5n3jDjj7CNjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cd3kCbr8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cd3kCbr8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791201684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u6skVeddM4uZRvlxPXBb3NK1MXyhaBmPKfzAwVozs6c=;
	b=cd3kCbr8cFt0kjsW9eNeOePMOTZH3pFCwQYWpqQc3vmOPDMMqwMjIqMDq7+ztaKF501JZj
	s+io1GW6DS3q/HGGR++TPE1AGzp+AngbrSkOehzL6Zk6FonYlTRyQROgRjgPh6sJ/arSoH
	aYsxPRRbIpDTSjcrn61rFX26s+rGcaA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-FNJn5_8tMdOrpxpBwQHOaA-1; Mon,
 05 Oct 2026 08:01:23 -0400
X-MC-Unique: FNJn5_8tMdOrpxpBwQHOaA-1
X-Mimecast-MFC-AGG-ID: FNJn5_8tMdOrpxpBwQHOaA_1791201682
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F23FA1802166;
	Mon,  5 Oct 2026 12:01:21 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 763A71956087;
	Mon,  5 Oct 2026 12:01:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v5 3/4] xfs: calculate AGFL max to support multiple-alloc transactions
Date: Mon,  5 Oct 2026 08:01:17 -0400
Message-ID: <20261005120118.229086-4-bfoster@redhat.com>
In-Reply-To: <20261005120118.229086-1-bfoster@redhat.com>
References: <20261005120118.229086-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c  | 35 ++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_alloc.h  |  4 ++--
 fs/xfs/libxfs/xfs_bmap.c   |  5 +++--
 fs/xfs/libxfs/xfs_ialloc.c |  4 +++-
 4 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b2525c58051b..af63926cc9ee 100644
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
index ae91f63455c5..d6be6734bd90 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3149,6 +3149,7 @@ xfs_bmap_longest_free_extent(
 	xfs_extlen_t		*blen)
 {
 	xfs_extlen_t		longest;
+	unsigned int		min_free;
 	int			error = 0;
 
 	if (!xfs_perag_initialised_agf(pag)) {
@@ -3158,8 +3159,8 @@ xfs_bmap_longest_free_extent(
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
index e31611cabd4d..e705f681ed44 100644
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

