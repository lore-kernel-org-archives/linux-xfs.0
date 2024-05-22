Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B3128EA
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347003; cv=none; b=sy6l438GOQOe+YVVI+mBgQ3kq/Xc0Y3jvDKVbXnHbZEOSUBWGU9qTuC7bz+wBXXBgbTgflP2fai07ctM4eGw7rsOgEQpNjb95rb8XavHNn7xPly+/EFZI9p1Ud1tKKK6CO3R2dHJ+yE4v4UyHWMj7iwjEE20CgKtWQEydTVL9Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347003; c=relaxed/simple;
	bh=SBeD9xdlGQsHPqbbgZK9KCrsvySY6KqpnFIrWM9cWX4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEr7TLn+Q1PljhnsyT69XZF73r6EPCnMKRnF7/EWgAKchz02k5rJ1gG22+R9hb8LNAmhLYrlUKAJMmJVmsqOOjeotDNjvuI5huSiDzi8d1ID4C2fKK6ATSrCLFzaUqLaVD0HTf2q1H4L5uXNJqioYmdIfBsDY5+T8ZeaDGXePSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBBMxf4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBBMxf4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F717C2BD11;
	Wed, 22 May 2024 03:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347003;
	bh=SBeD9xdlGQsHPqbbgZK9KCrsvySY6KqpnFIrWM9cWX4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RBBMxf4haZWswwniQZeEjnxk5krDIOTWAUBGsnr3LvMAu4d8fSZyp1hq+REhSayFQ
	 TztoAVDXwmtNm6V7Il//n/Hax6Pq9qb4Uy52fABxsJKG8+YVB7FYcj1gCSIFRKuzJ7
	 TfH3DoRBEjaPObLHCVqteld8rQVretOYLvSZAo2UXJAx9FWb39eL5z3l/j7ozAl6q3
	 n8/scuMqm/yLrxAMHEJFbbzJOjuNxlb3tzuZFoOxJg84UHyZm0XVWpWP20z9FObJ2X
	 pT6z08XuDS+PrflmgFExaMJfQ1MdddIr9ohsXil+8f89jqSr4caaApidUQIIiGERig
	 E80pSGV329sGg==
Date: Tue, 21 May 2024 20:03:22 -0700
Subject: [PATCH 056/111] xfs: remove xfs_inobt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532538.2478931.3660986756733157261.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6234dee7e6f58676379f3a2d8b0629a6e9a427fd

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h  |    1 +
 libxfs/xfs_ialloc_btree.c |   14 --------------
 libxfs/xfs_ialloc_btree.h |    2 --
 repair/agbtree.c          |    8 +++++---
 4 files changed, 6 insertions(+), 19 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9a2968906..2adf20ce8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -147,6 +147,7 @@
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
 
+#define xfs_inobt_init_cursor		libxfs_inobt_init_cursor
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index aa3f586da..6a34de282 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -488,20 +488,6 @@ xfs_inobt_init_cursor(
 	return cur;
 }
 
-/* Create an inode btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_inobt_stage_cursor(
-	struct xfs_perag	*pag,
-	struct xbtree_afakeroot	*afake,
-	xfs_btnum_t		btnum)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_inobt_init_cursor(pag, NULL, NULL, btnum);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Install a new inobt btree root.  Caller is responsible for invalidating
  * and freeing the old btree blocks.
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 3262c3fe5..40f0fc0e8 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -48,8 +48,6 @@ struct xfs_perag;
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
-struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_perag *pag,
-		struct xbtree_afakeroot *afake, xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
diff --git a/repair/agbtree.c b/repair/agbtree.c
index d5fa4eafb..22e31c47a 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -524,8 +524,9 @@ init_ino_cursors(
 			fino_recs++;
 	}
 
-	btr_ino->cur = libxfs_inobt_stage_cursor(pag, &btr_ino->newbt.afake,
+	btr_ino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
 			XFS_BTNUM_INO);
+	libxfs_btree_stage_afakeroot(btr_ino->cur, &btr_ino->newbt.afake);
 
 	btr_ino->bload.get_records = get_inobt_records;
 	btr_ino->bload.claim_block = rebuild_claim_block;
@@ -544,8 +545,9 @@ _("Unable to compute inode btree geometry, error %d.\n"), error);
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_INOBT, est_agfreeblocks, btr_fino);
-	btr_fino->cur = libxfs_inobt_stage_cursor(pag,
-			&btr_fino->newbt.afake, XFS_BTNUM_FINO);
+	btr_fino->cur = libxfs_inobt_init_cursor(pag, NULL, NULL,
+			XFS_BTNUM_FINO);
+	libxfs_btree_stage_afakeroot(btr_fino->cur, &btr_fino->newbt.afake);
 
 	btr_fino->bload.get_records = get_inobt_records;
 	btr_fino->bload.claim_block = rebuild_claim_block;

