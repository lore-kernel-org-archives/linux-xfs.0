Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F52FBA49
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnFMRCnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52F9C433C8;
	Wed, 13 Dec 2023 22:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508199;
	bh=IXRmQTHVIV54ApxSzOebC4bHOE0Kwp2wVfbrwZQBOq4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MnFMRCnqhVW6B6scljOhSanu4K99rhA1M3pS1aiXIwhBejnXaw7wl+MIeeE0/wqwX
	 wjSeYIz9cTNd2F5L8UjVsE4YjyUAvkICGpwIgbSTRy/vUk5adZ02FgNDLtX/75hl/v
	 BKgUXvhWdh4ITbmmAaeSAK6R/38RBe8/jh/+sdvEbWbVSBtPPL57NrHl3TmSXTK+to
	 A+P87YPLNf+2xaXQ/uqDsuXTJSA5qdOspZOh9KTMS4CQTXBtL8AYu677QPjMZp3Onf
	 0BdPBd9cc3cHkLNiZjtGeAmfwdj3pVY1oCYkzgiwaHDbJ5+LrUP0K6GSPhpjCsll4p
	 1pEJVcVOjnLYQ==
Date: Wed, 13 Dec 2023 14:56:39 -0800
Subject: [PATCH 4/5] xfs: create a ranged query function for refcount btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250784004.1399452.7496154847746124060.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
References: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount.c |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |   10 ++++++++++
 2 files changed, 51 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index bcfab2fe563f..9fb378f65282 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -2031,6 +2031,47 @@ xfs_refcount_has_records(
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
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 5c207f1c619c..9b56768a590c 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
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

