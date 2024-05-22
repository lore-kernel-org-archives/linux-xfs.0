Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D93139E
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346972; cv=none; b=DbYVkgSZpDsnFzGhyqQ3BQLWQUvN5ynWh+hMBNUSiIzGzKLYXqtdBxLjAfn+14ASvzU1S4xC+9nVUtx9Dt+FewlNtfnNE8HNdGbJrSO+w211ZaH92cQpcKP16WAt7axVKzThxeXBQUltEKbLPQavvHCdjfFRnxSpIpX8n4jAe34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346972; c=relaxed/simple;
	bh=sEtGw2M8GAwAs9nL7FbcMvc2EUo/c2Bgiyfgp0vRrgU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bbIOc8Qp98N1Km+ijRlaHuKQhRUJ/TOo9nby/lzTpRBeAuIt0TL4jDhUTliu/IaRaQibciSqL282DK6ROkMPIqvtgoisSaxARsEwx4b3oBeQJ7/5fsZl/lys8aiFCEglgUBTSFyilkLj1C/3QYyN1i1gnLqppxu307zxN0VvCtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9obygro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9obygro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19435C2BD11;
	Wed, 22 May 2024 03:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346972;
	bh=sEtGw2M8GAwAs9nL7FbcMvc2EUo/c2Bgiyfgp0vRrgU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f9obygroisbvbro0m1E4oehlDu4P1aAST/fEk0xr4x0MIJaanqvQmChjr9byuO3KE
	 oOHFTQvsvnQb0ShxsdkUDq1CylR/CtenTqmIcuXbMZpWpz2Jqk2f9fJ9u+1A12KzWR
	 V8hJyBFH+57BEsx4pr/2MMGu20NN1xwwZqAmPuxmxHNaW9clzqz2ERCDIFNF6xvYWH
	 9S6kNn9jzd66+kEd+Dw9uymkFynrdvYy0ny3Xu+XFFY/AAln5P+PktJwRrXZOOvLyE
	 3HOsdMzIhbV7+ABQ71KeJgK6gNk+kEloBU8UMuBtMwI26eSUIeQQzqoPlayPPnuAcq
	 eaKwZCqA2YGKQ==
Date: Tue, 21 May 2024 20:02:51 -0700
Subject: [PATCH 054/111] xfs: remove xfs_allocbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532508.2478931.7161111680547508870.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 91796b2eef8bd725873bec326a7be830a68a11ff

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_alloc_btree.c |   15 ---------------
 libxfs/xfs_alloc_btree.h |    3 ---
 repair/agbtree.c         |   11 +++++++----
 4 files changed, 9 insertions(+), 22 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 769733ec2..9a2968906 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -26,6 +26,7 @@
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_calc_size		libxfs_allocbt_calc_size
+#define xfs_allocbt_init_cursor		libxfs_allocbt_init_cursor
 #define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
 #define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
@@ -63,6 +64,7 @@
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_btree_rec_addr		libxfs_btree_rec_addr
+#define xfs_btree_stage_afakeroot	libxfs_btree_stage_afakeroot
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 13d2310cf..bd7878b68 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -546,21 +546,6 @@ xfs_allocbt_init_cursor(
 	return cur;
 }
 
-/* Create a free space btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_allocbt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xbtree_afakeroot	*afake,
-	struct xfs_perag	*pag,
-	xfs_btnum_t		btnum)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_allocbt_init_cursor(mp, NULL, NULL, pag, btnum);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Install a new free space btree root.  Caller is responsible for invalidating
  * and freeing the old btree blocks.
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index 45df893ef..1c9108625 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -50,9 +50,6 @@ struct xbtree_afakeroot;
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_perag *pag, xfs_btnum_t btnum);
-struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
-		xfs_btnum_t btnum);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 38f3f7b8f..d5fa4eafb 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -262,10 +262,13 @@ init_freespace_cursors(
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr_bno);
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr_cnt);
 
-	btr_bno->cur = libxfs_allocbt_stage_cursor(sc->mp,
-			&btr_bno->newbt.afake, pag, XFS_BTNUM_BNO);
-	btr_cnt->cur = libxfs_allocbt_stage_cursor(sc->mp,
-			&btr_cnt->newbt.afake, pag, XFS_BTNUM_CNT);
+	btr_bno->cur = libxfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
+			XFS_BTNUM_BNO);
+	libxfs_btree_stage_afakeroot(btr_bno->cur, &btr_bno->newbt.afake);
+
+	btr_cnt->cur = libxfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
+			XFS_BTNUM_CNT);
+	libxfs_btree_stage_afakeroot(btr_cnt->cur, &btr_cnt->newbt.afake);
 
 	btr_bno->bload.get_records = get_bnobt_records;
 	btr_bno->bload.claim_block = rebuild_claim_block;

