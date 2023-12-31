Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C97C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwiTTX7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EB1C433C8;
	Sun, 31 Dec 2023 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061061;
	bh=rqtO6wjte4bwHze/nOsJ/VWnpAoKCFVZZV8xohEOi4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mwiTTX7WKr1qdPSC+GE5ow7kTmu6Dnky6bY2k7xvsRojvYTxVJvOYOnbgXva3BByK
	 QxohUlsfLLfYEMyGGIQzQb7rAEWHdUTqligLPL4dhj+KC8suNNJj7TdUqg53z+NmXI
	 LOlyDFItUuUeKXP7JL1jqJIhjBd7+tGtLWvkSd9SufMRVoapo2X9OdKALGZnCAKWr0
	 VMPup0ySjdZyTr+3xqHnlshSVc9MdC3OINXl8HlAHpXYtiIX8TN/lZ/OcpBK+OhyfE
	 UgeYbjZki6Kat+JU7G9HnixpDicvj6P7ttmfMwVKtM/9WnpRrDWeJZy+gzYvvZWaRr
	 Wl/GmQ4ZPRemQ==
Date: Sun, 31 Dec 2023 14:17:40 -0800
Subject: [PATCH 2/4] xfs: repair the rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993269.1794784.6959184673572898629.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993240.1794784.3257777351086453063.stgit@frogsfrogsfrogs>
References: <170404993240.1794784.3257777351086453063.stgit@frogsfrogsfrogs>
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

Rebuild the reverse mapping btree from all primary metadata.  This first
patch establishes the bare mechanics of finding records and putting
together a new ondisk tree; more complex pieces are needed to make it
work properly.

Link: https://docs.kernel.org/filesystems/xfs-online-fsck-design.html#case-study-rebuilding-reverse-mapping-records
Link: https://docs.kernel.org/filesystems/xfs-online-fsck-design.html#case-study-reaping-after-repairing-reverse-mapping-btrees
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h       |    8 ++++++++
 libxfs/xfs_rmap.c       |   12 ++++++------
 libxfs/xfs_rmap.h       |    2 +-
 libxfs/xfs_rmap_btree.c |   13 ++++++++++++-
 5 files changed, 70 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b764b7f79c4..cfc4350d18e 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6356,3 +6356,46 @@ xfs_bunmapi_range(
 out:
 	return error;
 }
+
+struct xfs_bmap_query_range {
+	xfs_bmap_query_range_fn	fn;
+	void			*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_bmap_query_range_helper(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
+{
+	struct xfs_bmap_query_range	*query = priv;
+	struct xfs_bmbt_irec		irec;
+	xfs_failaddr_t			fa;
+
+	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+	fa = xfs_bmap_validate_extent(cur->bc_ino.ip, cur->bc_ino.whichfork,
+			&irec);
+	if (fa) {
+		xfs_btree_mark_sick(cur);
+		return xfs_bmap_complain_bad_rec(cur->bc_ino.ip,
+				cur->bc_ino.whichfork, fa, &irec);
+	}
+
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all bmaps. */
+int
+xfs_bmap_query_all(
+	struct xfs_btree_cur		*cur,
+	xfs_bmap_query_range_fn		fn,
+	void				*priv)
+{
+	struct xfs_bmap_query_range	query = {
+		.priv			= priv,
+		.fn			= fn,
+	};
+
+	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 4b83f6148e0..9dd631bc2dc 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -278,4 +278,12 @@ extern struct kmem_cache	*xfs_bmap_intent_cache;
 int __init xfs_bmap_intent_init_cache(void);
 void xfs_bmap_intent_destroy_cache(void);
 
+typedef int (*xfs_bmap_query_range_fn)(
+	struct xfs_btree_cur	*cur,
+	struct xfs_bmbt_irec	*rec,
+	void			*priv);
+
+int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
+		void *priv);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 0b462d17838..cec1c4e6efe 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -214,10 +214,10 @@ xfs_rmap_btrec_to_irec(
 /* Simple checks for rmap records. */
 xfs_failaddr_t
 xfs_rmap_check_irec(
-	struct xfs_btree_cur		*cur,
+	struct xfs_perag		*pag,
 	const struct xfs_rmap_irec	*irec)
 {
-	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_mount		*mp = pag->pag_mount;
 	bool				is_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
@@ -232,8 +232,8 @@ xfs_rmap_check_irec(
 			return __this_address;
 	} else {
 		/* check for valid extent range, including overflow */
-		if (!xfs_verify_agbext(cur->bc_ag.pag, irec->rm_startblock,
-						       irec->rm_blockcount))
+		if (!xfs_verify_agbext(pag, irec->rm_startblock,
+					    irec->rm_blockcount))
 			return __this_address;
 	}
 
@@ -306,7 +306,7 @@ xfs_rmap_get_rec(
 
 	fa = xfs_rmap_btrec_to_irec(rec, irec);
 	if (!fa)
-		fa = xfs_rmap_check_irec(cur, irec);
+		fa = xfs_rmap_check_irec(cur->bc_ag.pag, irec);
 	if (fa)
 		return xfs_rmap_complain_bad_rec(cur, fa, irec);
 
@@ -2441,7 +2441,7 @@ xfs_rmap_query_range_helper(
 
 	fa = xfs_rmap_btrec_to_irec(rec, &irec);
 	if (!fa)
-		fa = xfs_rmap_check_irec(cur, &irec);
+		fa = xfs_rmap_check_irec(cur->bc_ag.pag, &irec);
 	if (fa)
 		return xfs_rmap_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 3c98d9d50af..58c67896d12 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -195,7 +195,7 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
-xfs_failaddr_t xfs_rmap_check_irec(struct xfs_btree_cur *cur,
+xfs_failaddr_t xfs_rmap_check_irec(struct xfs_perag *pag,
 		const struct xfs_rmap_irec *irec);
 
 int xfs_rmap_has_records(struct xfs_btree_cur *cur, xfs_agblock_t bno,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index e894a22e087..6924f7e49d9 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -340,7 +340,18 @@ xfs_rmapbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
+		unsigned int	maxlevel = pag->pagf_levels[XFS_BTNUM_RMAPi];
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the free space btrees, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				pag->pagf_repair_levels[XFS_BTNUM_RMAPi]);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;

