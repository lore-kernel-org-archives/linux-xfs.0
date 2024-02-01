Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D468563F
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816850; cv=none; b=RG0Ptiurq/+DNUoUN8P4acVaKlmMjRCCqB52VGkIgPT9pG9fcRvvjpjtiy/Bppt4N/QfwChpk9uyP7F8Cb0Q5sRUoqPxhcZvM2J3IoNFYktl3T0A7If8HLeb0JpgvB7bXOzPO6ryBqGt7Urbnc5YCLHueM9VTELCoXgnFGE8TCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816850; c=relaxed/simple;
	bh=/LG5eQ395Wj2Hkx1MVYE5cqIMRRcOUZfgbcmQNwPZoc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHrs8pq49fDodsH18QTD9shypX33RQILVkrEUQYKygrYEPaND8EF64is37xs6Qf7wlWakFkQuglx0GbsavUJBhCcA8POZtxWzmdEhNeKNa/jND1z1Q+DjfaK7uz5U0lbwBK6Vc+jvXyXaD5EECXl+Wgz0Mzz1+kdpkXODQL2pcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGE2J/ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGE2J/ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C68C43390;
	Thu,  1 Feb 2024 19:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816849;
	bh=/LG5eQ395Wj2Hkx1MVYE5cqIMRRcOUZfgbcmQNwPZoc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dGE2J/ZKadwL8z865aaSmBtgLtuU1BlHJ9byVVMGaPw+/ZD5JURbnHpLtF9LEImUM
	 YH9l7AbnAABc8fYugp83X906MZ/gcI3q5nEl8tFVKhx+iOjYCH43sHhUhFTgQ6EmMH
	 re7WFJ+PiG5MNFJNGbozKysYdFzimkDDEk14RCIsVnyQQ24b2YuTl8A0av2yLquQcT
	 AU7GzbV5VymYFm/CwrK7UOc7dVaLvWyoPhyQ40fXj+6D6XgErcMCagYLNvszQ8kEF9
	 MCBrAJtqL31iE+ysoj70TSAPNZwP08jAQLgv6mGw1FqU0T38JKALI9+PpO8NVBV+Ee
	 X47yz7MEtDMjg==
Date: Thu, 01 Feb 2024 11:47:29 -0800
Subject: [PATCH 07/27] xfs: remove xfs_inobt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334900.1605438.8415709613161445766.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |   14 --------------
 fs/xfs/libxfs/xfs_ialloc_btree.h |    2 --
 fs/xfs/scrub/ialloc_repair.c     |    9 +++++----
 3 files changed, 5 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 48bfea0e2a200..b45a2e5813133 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -489,20 +489,6 @@ xfs_inobt_init_cursor(
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
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 3262c3fe5ebee..40f0fc0e8da37 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -48,8 +48,6 @@ struct xfs_perag;
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
-struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_perag *pag,
-		struct xbtree_afakeroot *afake, xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index e94f108000825..04e186d8c7386 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -663,8 +663,8 @@ xrep_ibt_build_new_trees(
 	ri->new_inobt.bload.claim_block = xrep_ibt_claim_block;
 	ri->new_inobt.bload.get_records = xrep_ibt_get_records;
 
-	ino_cur = xfs_inobt_stage_cursor(sc->sa.pag, &ri->new_inobt.afake,
-			XFS_BTNUM_INO);
+	ino_cur = xfs_inobt_init_cursor(sc->sa.pag, NULL, NULL, XFS_BTNUM_INO);
+	xfs_btree_stage_afakeroot(ino_cur, &ri->new_inobt.afake);
 	error = xfs_btree_bload_compute_geometry(ino_cur, &ri->new_inobt.bload,
 			xfarray_length(ri->inode_records));
 	if (error)
@@ -684,8 +684,9 @@ xrep_ibt_build_new_trees(
 		ri->new_finobt.bload.claim_block = xrep_fibt_claim_block;
 		ri->new_finobt.bload.get_records = xrep_fibt_get_records;
 
-		fino_cur = xfs_inobt_stage_cursor(sc->sa.pag,
-				&ri->new_finobt.afake, XFS_BTNUM_FINO);
+		fino_cur = xfs_inobt_init_cursor(sc->sa.pag, NULL, NULL,
+				XFS_BTNUM_FINO);
+		xfs_btree_stage_afakeroot(fino_cur, &ri->new_finobt.afake);
 		error = xfs_btree_bload_compute_geometry(fino_cur,
 				&ri->new_finobt.bload, ri->finobt_recs);
 		if (error)

