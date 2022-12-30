Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A3BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiLaAOF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiLaAOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:14:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFE060EF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:14:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DA9C61CE2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B55C433D2;
        Sat, 31 Dec 2022 00:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445642;
        bh=ixUczhRFkCSf/o7Psq2jzdLhB67MxxLZHOXQSXcGUo8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HWttPI8j1qrX9qD18bH7CRaa5Tw6hxeg9gQqQBHjeAs2hIMH1Gs+Uf7ubZMuvScSx
         FMAJTVxBocGF+piHjJ3N4d2YdwvU7lSh47yfWpiXlKSE8VRLjYimf+SPk9QK095s2N
         BpOWilOw7KV9DuQkzY2tyO7OF/tTTVDOpZqugzKnxLoJ/Hd2l0WLdITjYByou6cGe1
         q245jdFpH9TYRCkl+MBYAeDJoC4Rb8IFRR1ZOthIcWvPDUcycDWKzPvpKqFHbrllTz
         Hivjkq4AacI6Df0YOHk1tn4cexLPJ9N8BS7q7wWOpkujZBZvSfwe6+xquQpPN0ZAfh
         BqSGwEsGXg36g==
Subject: [PATCH 2/5] xfs: repair the rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:45 -0800
Message-ID: <167243866589.712315.13232550282179091617.stgit@magnolia>
In-Reply-To: <167243866562.712315.18184440339100962213.stgit@magnolia>
References: <167243866562.712315.18184440339100962213.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rebuild the reverse mapping btree from all primary metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h       |    8 ++++++++
 libxfs/xfs_rmap.c       |   22 +++++++++++++++-------
 libxfs/xfs_rmap.h       |    2 ++
 libxfs/xfs_rmap_btree.c |   13 ++++++++++++-
 5 files changed, 80 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4533db87668..59c9d53bf31 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6399,3 +6399,46 @@ xfs_bunmapi_range(
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
index 1201ee024c1..bbda4a77cb6 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -274,4 +274,12 @@ extern struct kmem_cache	*xfs_bmap_intent_cache;
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
index 0816f103f1c..18d9dd480b0 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -211,13 +211,12 @@ xfs_rmap_btrec_to_irec(
 			irec);
 }
 
-/* Simple checks for rmap records. */
-xfs_failaddr_t
-xfs_rmap_check_irec(
-	struct xfs_btree_cur		*cur,
+inline xfs_failaddr_t
+xfs_rmap_check_perag_irec(
+	struct xfs_perag		*pag,
 	const struct xfs_rmap_irec	*irec)
 {
-	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_mount		*mp = pag->pag_mount;
 	bool				is_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
@@ -232,8 +231,8 @@ xfs_rmap_check_irec(
 			return __this_address;
 	} else {
 		/* check for valid extent range, including overflow */
-		if (!xfs_verify_agbext(cur->bc_ag.pag, irec->rm_startblock,
-						       irec->rm_blockcount))
+		if (!xfs_verify_agbext(pag, irec->rm_startblock,
+					    irec->rm_blockcount))
 			return __this_address;
 	}
 
@@ -268,6 +267,15 @@ xfs_rmap_check_irec(
 	return NULL;
 }
 
+/* Simple checks for rmap records. */
+xfs_failaddr_t
+xfs_rmap_check_irec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*irec)
+{
+	return xfs_rmap_check_perag_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_rmap_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index ced605d6932..b7ad51055e1 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -195,6 +195,8 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+xfs_failaddr_t xfs_rmap_check_perag_irec(struct xfs_perag *pag,
+		const struct xfs_rmap_irec *irec);
 xfs_failaddr_t xfs_rmap_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *irec);
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 928f61053b0..574f2dda5c0 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -340,7 +340,18 @@ xfs_rmapbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
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
+				pag->pagf_alt_levels[XFS_BTNUM_RMAPi]);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;

