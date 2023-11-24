Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DB53DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gf1aSoCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30036C433C7;
	Fri, 24 Nov 2023 23:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870037;
	bh=qzc8ECITrXIwA2Qh4pjrJ4pRMTH+jtXUia2zdCJKetg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gf1aSoCRJ4+Zm+I+HTA9k4JuNE3mYBnVo/agzO7tFs5lOJUpIWHogUZW+4MnErywG
	 ECxsMtsKOaD4NDKXL4GtweOJmRF08VUWmrln6C/5qgyBmFyvNkDooZD8kaZTw2bFhC
	 KkiMb7neeaHl6kMdH8ZI2+ngu2nxaUO28q4HSbaoHLZsVVaJgjaaZrZTw2zSEfbDGS
	 O5rZ0lgFCsI2PO0eHgGObwrODu/dARgfNXOkg6B81lWCU1wQIkWD8IBU14lWyfS1EX
	 9EVEI681ZIRREdTYVaKnVcuSS8xWWrqGeCUpWL0XHKncvysofF9lowp7F+OinQspPm
	 KDM+lOixb8vEQ==
Date: Fri, 24 Nov 2023 15:53:56 -0800
Subject: [PATCH 4/5] xfs: create a ranged query function for refcount btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927974.2771366.8544773411756027840.stgit@frogsfrogsfrogs>
In-Reply-To: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
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

Implement ranged queries for refcount records.  The next patch will use
this to scan refcount data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |   10 ++++++++++
 2 files changed, 51 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 5fa1a6f32c17d..b7311122bd489 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -2039,6 +2039,47 @@ xfs_refcount_has_records(
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
+	fa = xfs_refcount_check_irec(cur, &irec);
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
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 2d6fecb258bb1..9563eb91be172 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -129,4 +129,14 @@ extern struct kmem_cache	*xfs_refcount_intent_cache;
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

