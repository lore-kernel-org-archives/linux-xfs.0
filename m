Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02DD21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425224; cv=none; b=Mbt70DxkeirXAYCZbeHqTddK161dC4a8UDoxWxKpYEJAKmPd7ZBvSRjbXZhqdMcKL1vPtM+ttY3FLEhpZGtR4f523OI7ZD7nRPC8mMjnA5UCZRMT6rbix/OfKmrw9IyuhrSBSKtV896dZEDYhGdy/VQB3gS7vMfAP2C4q00Sax4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425224; c=relaxed/simple;
	bh=H9ipaT9r1eQijjv2ufRQXpWOsW7XRgYvVbHKk5qKUQw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGJOdrSVAuCDuMcM8eTPZmtA/MQZrjmjBuGcySrlMxmptOGpwelVN0TL0uwQ4vJMqnQmglH1BuDk6lWUvkwoYNROIA3A1uxq/LVcqY2g2Q9vAMzUotwnUj1nNYzN9W+wMxQfTqy8/qU2/154dTuUSf9UeV6U4rWfAj/XuPhLpkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBRusLUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBRusLUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C449C433F1;
	Tue, 26 Mar 2024 03:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425224;
	bh=H9ipaT9r1eQijjv2ufRQXpWOsW7XRgYvVbHKk5qKUQw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JBRusLUrBD/sZS6UGcjBw0eR90/zOnH0S8fzr+p9EvRnULYWQdf3c3SD5clBUp201
	 /bLr+pvKkPnavsED3l2/j1r6/AJ9eOONJ9qZi6wKVz7IjJZttQtiXtkKJHjyvU9cXP
	 PKzIDDIZ1M11hHPUWWpq6zPJwuDh8sq1XRtsWPJuusT+Dyt1M2bnJLwRWEGxInJa5U
	 GFFZEG3Ro+kE24vpbnWGPDJYKouR023p8lZCpRcTa/t33wPdQfPBf+9BmF7ms7Ey8i
	 GU8PEcsrK5UbsQv8VbXwAt47lXb+kb0Mfa14K1XF7JGGo9XbDCUpQj1+FL8mFeSdNF
	 uHDDjqhF2nY7Q==
Date: Mon, 25 Mar 2024 20:53:44 -0700
Subject: [PATCH 097/110] xfs: repair the rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132776.2215168.10825107193057876451.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_ag.h         |    1 +
 libxfs/xfs_bmap.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h       |    8 ++++++++
 libxfs/xfs_rmap.c       |   12 ++++++------
 libxfs/xfs_rmap.h       |    2 +-
 libxfs/xfs_rmap_btree.c |   13 ++++++++++++-
 6 files changed, 71 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 29bfa6273dec..e019b79dbbe3 100644
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
index 85f1deac2807..a82a41249fd3 100644
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
index f6b73f1bad5f..10b85865204d 100644
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
index 2d96cb60c225..a0b4280fe584 100644
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
index 3c98d9d50afb..58c67896d12c 100644
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
index 2b7504f7a083..956cdc2fd596 100644
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

