Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A642CCB4
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442241; cv=none; b=ex1Y6rTqHY9cKQjHVDia5OrpAqsMxk2zAyS6uH89oN/LvPrn7u8TpFEXeXHld0uycN438288Wucn9PRscMwjoL9KHLQDNUG+lXuo+OiNtAjvQY/zazj/bibbYeB25QchMjGOMXkA1CsV9uc+nOc5bcsIOge1CNY99TvP2GVpdic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442241; c=relaxed/simple;
	bh=QY60VXishXzicFlOnQN2HiWGMxMhL/7Pn6cBoljIpvo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KG9uooVSxhtpn6VNmRbLqN8fr1o7t/1xREp7xjA5Y948Pr9lfa4VCwNercmqCoCnWPJDz4AJLMR+2HZ9qtr2vcIa1Hd7I9FE+z+jwSQGNf6WU0FezHhAhsSnx1v16YyqiSsZeo/GU7Oz3eLLBGrtck7U8tMhaOzDOBceYDMFSlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJ3smKfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJ3smKfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BB6C2BD10;
	Mon,  3 Jun 2024 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442240;
	bh=QY60VXishXzicFlOnQN2HiWGMxMhL/7Pn6cBoljIpvo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dJ3smKfSy4mzbiUm4wKBWfXrufK4N8+cI2NCCxvqVuXQkaeWSCzQtZGBSYc3iBWWR
	 UN6riHq5sd+hsk28UFOCh+5qCZ3UewUUZTSEmEq7hPScswjQ75bghCQyWa0LNninwK
	 c3ANcT78KJpEqxlBVrMxpho/TC0/OVxTJeI/5rykOyMStnehQ2AAlX/PMgC+5QzzSc
	 zu04OLxhlMib7URodhZsDmsOnYHD4iPBZn0FwHcR1xqxDzcQ1gM+B6MH4IrxWT94AT
	 12Lp9e4IRKRJ+B1xDKyvybpwFj7YSCIziFA75LvzAnXtkWtohuZtb7jwM+9jJH5a20
	 2YWv1FAyQyyyw==
Date: Mon, 03 Jun 2024 12:17:20 -0700
Subject: [PATCH 097/111] xfs: repair the rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040823.1443973.9329680286307304088.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 32080a9b9b2ef8f4089e8e28a2c307334431757e

Rebuild the reverse mapping btree from all primary metadata.  This first
patch establishes the bare mechanics of finding records and putting
together a new ondisk tree; more complex pieces are needed to make it
work properly.

Link: Documentation/filesystems/xfs-online-fsck-design.rst
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_ag.h         |    1 +
 libxfs/xfs_bmap.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h       |    8 ++++++++
 libxfs/xfs_rmap.c       |   12 ++++++------
 libxfs/xfs_rmap.h       |    2 +-
 libxfs/xfs_rmap_btree.c |   13 ++++++++++++-
 6 files changed, 71 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 29bfa6273..e019b79db 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -90,6 +90,7 @@ struct xfs_perag {
 	uint8_t		pagf_repair_bno_level;
 	uint8_t		pagf_repair_cnt_level;
 	uint8_t		pagf_repair_refcount_level;
+	uint8_t		pagf_repair_rmap_level;
 #endif
 
 	spinlock_t	pag_state_lock;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 85f1deac2..a82a41249 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6373,3 +6373,46 @@ xfs_bunmapi_range(
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
index f6b73f1ba..10b858652 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -280,4 +280,12 @@ extern struct kmem_cache	*xfs_bmap_intent_cache;
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
index 2d96cb60c..a0b4280fe 100644
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
index 3c98d9d50..58c67896d 100644
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
index 2b7504f7a..956cdc2fd 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -340,7 +340,18 @@ xfs_rmapbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_rmap_level)
+		unsigned int	maxlevel = pag->pagf_rmap_level;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the free space btrees, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				pag->pagf_repair_rmap_level);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;

