Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104452BAE2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389549; cv=none; b=sSfK7IfroQenCvoe1x5DKaxqz0Hrgw5loNrxMucRYxMcetUav85XLMLEaK+wzfkvs20m+onAzFabGC8hArm1DPJ5Xni2UyKIxC0qy/zy3bro7DQkUlXHpzLmZgsEfyoKoqx9L91TzeDiat2I62/RNu5tb+unUr9MHdcAPUUgQmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389549; c=relaxed/simple;
	bh=W6M+P8fkleLbz8fQcMEBAYz3x5P3s48rstaA3sjDe9M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9SX/cCWxrphU8da6jx9hs7d7TIO2ERQMqCHaXlD4jThhbAQUGeWW9iX09AUlZ2CV2/PG+YvF3F688zQjqSUJZbOONs6HD1JCTSvAf/QrLiAfWbntD4JIMuuDPEnmY4kBx/KpqWN1j/4aY/PhmaR5DiJIy2srImCISLS7n9braQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0wJkBLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0wJkBLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA505C072AA;
	Wed, 17 Apr 2024 21:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389548;
	bh=W6M+P8fkleLbz8fQcMEBAYz3x5P3s48rstaA3sjDe9M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a0wJkBLwLYpqgNNE3Z/U5c2AocKq4gzw4P6Pl7dFC19Xb4Lln/Q+PfJyZMMyjoy8m
	 6Cmc3eTqB7CCccJy0hMhHVb0FGZmU679GIw0FwQxb3/bg/bbHlyg3GFZbkLqyao6At
	 zmaGjI3zF63kE8OXFQVtcLfJ+bVAp3D7XUnw8OWOZ4O96bvN9RIrUh2ZLZKJf0Pks2
	 xlrS/ctNGfGZxCjAbBzHExnDxfOwI2AbiapMC75WtBOosLlTxBJ0m6XDUZqjllk0Ui
	 AtG8i179H6Voj6veqHhdfzKPfYAaCSI4LM8Q9nHVY0Epr/BVrHY6mcc6gIuuIgg/cs
	 xOI2Hf63SvJrg==
Date: Wed, 17 Apr 2024 14:32:28 -0700
Subject: [PATCH 41/67] xfs: create a ranged query function for refcount btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842955.1853449.8343134463959417742.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_refcount.c |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.h |   10 ++++++++++
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

