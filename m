Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314ADAD5D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295424; cv=none; b=cs58qSxV5APdTm4an3M9ZA6gMA2PwrtOIer0AGCNmYJSswMIwICH1sE40FTGO7oZ7XFBrs+mlLhFPD9JzPoHrsMm1i4vailkEQ1Hr3aJSXyQRxbUVigy8GIvGeRBqDMXFc3keOtHWKKoauuRMgGmmBHdq3iSYEVBl9mwAZ1hrA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295424; c=relaxed/simple;
	bh=ryqDiFrYX1eFWkwPVNgihPlJZdToKoXGovI0bDFM++U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7mPXjzXLpKSFPYvfbgq5Ja30z4+W4n3pHPc6zTVF6LuEszA+bSgLYzngMvTSA2w153vF9ZYJBoPQrNxJ55Tenz73igPNJsEEWgy+O3yOEdbiNMPXq7232Itu4xa/OwC9McOd5jZnw6JgcUa4YCcX1E/22K1mFhEglB9GrMX6SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEqbCgZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEqbCgZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B40C433C7;
	Wed, 13 Mar 2024 02:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295424;
	bh=ryqDiFrYX1eFWkwPVNgihPlJZdToKoXGovI0bDFM++U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fEqbCgZeFdWeETHLRRXMxzn6+vlq05OyntyZsd17PXlVtOD1gMgRSBOKM+6a/obkZ
	 O4CbXw5TTH8v4RJGLXGGdPrjbMeakQ9k0mcGbDxNnJ5dB/cTg33rdmgJjb4OYCOSZf
	 1xmiBEUEqQc0A/ydi9mgPeLXyBbQyK+PxEpzyqCj0J6Gt1cQXo1Plidu8q3mKTHWRL
	 P2oHcjgE+zlXh2B2ryp2cWxWwynEUQjzCwIfnKsUtTs6kZbcCFK+sicmFlQwe7KoHI
	 XgAVb06RxOxI36YUoFClNhcMBZ4Y0cpF5Gxb9uF/Kd3lRrTYi8819uduxvwL4lRZXk
	 JBkxSqs78tlTQ==
Date: Tue, 12 Mar 2024 19:03:43 -0700
Subject: [PATCH 41/67] xfs: create a ranged query function for refcount btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431784.2061787.504878964029441438.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: d12bf8bac87a0d93e6e5fab67f399d1e3d3d5767

Implement ranged queries for refcount records.  The next patch will use
this to scan refcount data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_refcount.c |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.h |   10 ++++++++++
 2 files changed, 51 insertions(+)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 3377fac1283b..de321ab9d91d 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -2030,6 +2030,47 @@ xfs_refcount_has_records(
 	return xfs_btree_has_records(cur, &low, &high, NULL, outcome);
 }
 
+struct xfs_refcount_query_range_info {
+	xfs_refcount_query_range_fn	fn;
+	void				*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_refcount_query_range_helper(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
+{
+	struct xfs_refcount_query_range_info	*query = priv;
+	struct xfs_refcount_irec	irec;
+	xfs_failaddr_t			fa;
+
+	xfs_refcount_btrec_to_irec(rec, &irec);
+	fa = xfs_refcount_check_irec(cur->bc_ag.pag, &irec);
+	if (fa)
+		return xfs_refcount_complain_bad_rec(cur, fa, &irec);
+
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all refcount records between two keys. */
+int
+xfs_refcount_query_range(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*low_rec,
+	const struct xfs_refcount_irec	*high_rec,
+	xfs_refcount_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_brec = { .rc = *low_rec };
+	union xfs_btree_irec		high_brec = { .rc = *high_rec };
+	struct xfs_refcount_query_range_info query = { .priv = priv, .fn = fn };
+
+	return xfs_btree_query_range(cur, &low_brec, &high_brec,
+			xfs_refcount_query_range_helper, &query);
+}
+
 int __init
 xfs_refcount_intent_init_cache(void)
 {
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 5c207f1c619c..9b56768a590c 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -127,4 +127,14 @@ extern struct kmem_cache	*xfs_refcount_intent_cache;
 int __init xfs_refcount_intent_init_cache(void);
 void xfs_refcount_intent_destroy_cache(void);
 
+typedef int (*xfs_refcount_query_range_fn)(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*rec,
+	void				*priv);
+
+int xfs_refcount_query_range(struct xfs_btree_cur *cur,
+		const struct xfs_refcount_irec *low_rec,
+		const struct xfs_refcount_irec *high_rec,
+		xfs_refcount_query_range_fn fn, void *priv);
+
 #endif	/* __XFS_REFCOUNT_H__ */

