Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE61A259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441568; cv=none; b=P4uTQ+x/ELvcO3PPgQCe5Ynlh9lIn3i8z6UVnvx3VBUNSy+/gyCi1Do/PlDrSNFkkAb4OJocXCWBbIFqDgUD2t1LHC7qz1tHInmOMV6koUmbChmHPDdItQyb+9laK0+YexiKwofgO1l5dKpZahwL7fUva6u1WnT7Gvy8BZNe2Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441568; c=relaxed/simple;
	bh=42W+AolI0ftc5reGb8c0lD9PqRogdfZSn40yDFPbKRA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4xayhk4WAn05f4S/JLTzyxfMMhvL1XmNRNlDzHFLbAmGPsFipdI2UG4AYCmOeTYiYhbh6+8ODF4I1KxcQpDW7rHp8/wTKWolq07zSxXrtDTpTmE3dyG56qchECOB8+Z+Xm0URfQfRflgjQ7M3LsPHwK9yYoaviZUL9II9qkE3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lg9L/Lvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lg9L/Lvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFA5C2BD10;
	Mon,  3 Jun 2024 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441568;
	bh=42W+AolI0ftc5reGb8c0lD9PqRogdfZSn40yDFPbKRA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lg9L/LvrdqUEulaxuJV6aVvYsx1K7g42neUXOM3AyLfVUyp/t5occWt6nCWXPa1aQ
	 EUgABFO3Sz3L+4Uc/G8YN0bE1Z0pT4kzyRwgW885y3pVMBXaY6s9FhW3yB57kvnvG3
	 EusPXCtNnjNYEJahEUb4EL8s/HcDD6W/KGeleHQsUZ9o1dn6aZv0cZQ6C11de7l48T
	 PgZVAAi71V6e+RfblJdmti7bjZBVH0NlXndY9DlStNVIzr3XH8qrtc6kfm+VBd8c4N
	 m0B866xCiVjwxvnjx4sxIyiWxKmS0Co7v8PGVmgyHAYx9tSt386f/NrgljIkwpP0GV
	 xIUHs2oKUtImw==
Date: Mon, 03 Jun 2024 12:06:08 -0700
Subject: [PATCH 054/111] xfs: remove xfs_allocbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040185.1443973.3456393964927383080.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 91796b2eef8bd725873bec326a7be830a68a11ff

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

