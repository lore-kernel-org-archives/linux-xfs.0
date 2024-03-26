Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C021353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424551; cv=none; b=j7AP6Yzl9OdRKQvxqQN0m4m2JaShssCPN8qeDS4WkUzkePPiYUIpy6WvRNtXPMKMMCHT0Chx0zHHUTdD1l6U4V08KGdknuWIMTfUw0HOooUq1iS2//sPlvuDzXIS9Gsj+hsfb79m67jCOvqqSl2TyLhVg1Tt8sfhCl75wJiJG40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424551; c=relaxed/simple;
	bh=KFBPsoicEZ9zo1ns1+UynZuEu7BURZ/knhAVprouUWs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rRosJ/aD82ZJR91mMJq857525XSBZOMrq8smTXFVs5XzlUwaEuFdSiIMEZFga0OOM2fUWVVvPwV4zEJXwnIwPtPfj4iiHpzfZJlLRwCP/taPbpuNpeALj5CsVaSEal0SajoqvuNqBQxdG7M0Kr7gxyx0vckzllXOv1EH342g1hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j40xNYIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j40xNYIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155AFC433F1;
	Tue, 26 Mar 2024 03:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424551;
	bh=KFBPsoicEZ9zo1ns1+UynZuEu7BURZ/knhAVprouUWs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j40xNYINBWb3s+kIeKJNkXxQA8mkz/G35brOoM60PwB5rOoFQHe2EndKUN+tqDjHx
	 BtIb8prZZsPnvrqeDH6jHH+1BX0+KP1kB6ETdaXMn6AZNtYjhQKRhcqxCZ4rAqZahh
	 Nz+kuBu7dANxebUYNYuLRG1ujTFIa4O1+H47urI0uZlaHOORL91aJCaTnXQWlejdkB
	 x6cBehatC+F3w3UeMTgGsr7oayTAmVZN+wupU4s7J3byGoqtLHLOwtQyEkg7eUYtm4
	 7d09QktTcgwbCxeU79Z89+IJDtygHNWKfF6CMDqZagP+MpKGvL9xwsfzrfcpAwtKtN
	 yE98ZOlzGPueg==
Date: Mon, 25 Mar 2024 20:42:30 -0700
Subject: [PATCH 054/110] xfs: remove xfs_allocbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132162.2215168.8550976954997684872.stgit@frogsfrogsfrogs>
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
index 769733ec2ee3..9a2968906c42 100644
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
index 13d2310cfa36..bd7878b68931 100644
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
index 45df893ef6bb..1c910862535f 100644
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
index 38f3f7b8feac..d5fa4eafb633 100644
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

