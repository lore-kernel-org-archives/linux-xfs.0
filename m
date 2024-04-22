Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38179155322
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804010; cv=none; b=aA9I3iiPNHQfeQwCykt9zGRlojVEhBuOGt2xRD3b4gH/RJr4G+p4bmWraXPGXy0e1KLr+ooOoPaFE2/mnl4BDuOi9XgT63bX+uNx2vIYyviWmTlYEMpmrj/PUfRd+Ur3vjnO2rxR1uqB/vPHZJQz0+5fCxLZBzpL7XiTESup6cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804010; c=relaxed/simple;
	bh=i43HAKxlcJG4UIWPwjKagi154EE+Cye0UO+fhVDguQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKWK/ygdrgDms+DZWZ2JcZrehgMXjlhRXAtvEadW4gnPavYLz1HEDo/lWMcjmJ8XpJ+O1ianTKtr8yt9blV2xpEZuBN9yBF+a9OBUQLYuURtuIyd+dAKB55w1+9NF0KeQblM3ye1h9vjH5jt8bSIILhrHn9q/lrDCA0wq+IEELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDb4EzLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDb4EzLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2550BC113CC;
	Mon, 22 Apr 2024 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804010;
	bh=i43HAKxlcJG4UIWPwjKagi154EE+Cye0UO+fhVDguQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDb4EzLBIUh4nDVIyst4iNyLO+6YsYbTFKUPwegpl16uiaVok82j/32pmTewGo6nE
	 W6Z/H+T1LEkaMHiscb0nheBykkGyatgndkfceprEGYRGCCCMY2I11aVfFCz2kpyWcv
	 qT1WuvegeFHMlw9gDle8+j8rdUZYXpJKLWxp7R3TFxDEoMiEcfa6MqBICbwDhT/tux
	 /ckvzMDfUQKMEQeuM+n4Jzn7JzdkHR2JRjAthdYIWx8cRQi7292KbS60r1a0uiIzaF
	 ewqvAIRGO3vaLpz0uWQ2z7iWLn8kxTvuYk3tGTdFSS7mLZax9qaaBCE8Lo1DsizWj4
	 twWkw6p4PhW4w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 41/67] xfs: create a ranged query function for refcount btrees
Date: Mon, 22 Apr 2024 18:26:03 +0200
Message-ID: <20240422163832.858420-43-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: d12bf8bac87a0d93e6e5fab67f399d1e3d3d5767

Implement ranged queries for refcount records.  The next patch will use
this to scan refcount data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_refcount.c | 41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.h | 10 ++++++++++
 2 files changed, 51 insertions(+)

diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 3377fac12..de321ab9d 100644
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
index 5c207f1c6..9b56768a5 100644
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
-- 
2.44.0

