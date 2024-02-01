Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A4485648
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816818; cv=none; b=l9hsTfIOuU186iCkTcGGsM2EZ8DJVNrKXkFt9YIWEYeLxi0N7ttNc/JPLT9o/WebB7IxtlUbyFCbQsP4uueCZ329eJsUJjsVsCGXRrqFSGJ7U6kYUPgb4l66ygZG4qcYhAUX0+pl4sGmPCCc3cG6zuwchrGfxdZ+oaPpZZmglH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816818; c=relaxed/simple;
	bh=QdVM/2tRch8lYiLM860JoEWGvJwIjdDRJ7wBgT5AwjY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJycNsjDRL5nhgnpEnBi2YGJ15yFS4dw2VojrtnraM+fCfqPOXvu3Ocol9AFb037qV5AyG21IajSdWVkLDzFBDmUT7CVuH3ZIlydVHKoJefwQYQsFfzH+QKU2ZZ6nOngIxJNatOyE5P4EFLOjz+sEnE5mnwqKmk5VFopW0kUO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IU3gBKO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IU3gBKO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C7CC433F1;
	Thu,  1 Feb 2024 19:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816818;
	bh=QdVM/2tRch8lYiLM860JoEWGvJwIjdDRJ7wBgT5AwjY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IU3gBKO2PIFj5zhKFAliQ952La7yW+yhoo6TVvGi8lyca7IM3es4lAosRMqN8c07e
	 Ri6x6OXWCW7F4vXGO6UJcSFKgyETPGU267PigJF/wlPauBhwrw+h8dyOnFuaXzBP2H
	 tK73buCX09jiPo3VUKhUxCetnyTM33aBIFabDdAX09qGXlPGyggu1Me3Wf7RIaqaGo
	 mE1QeMcimj5O6p64sDI5QB9IiojXGwV/WYE8miMKQFzXwPR5WoxXwy/ubJWcq/E8EP
	 jWE1o1pIdiyL09eZ31swOyqo1/R63bWTDC+bM/7OnlU2tUg9xJ4j6NL6e2sodbxdr1
	 FL3rIMlgMoYdQ==
Date: Thu, 01 Feb 2024 11:46:58 -0800
Subject: [PATCH 05/27] xfs: remove xfs_allocbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334868.1605438.3526834023885589458.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_alloc_btree.c |   15 ---------------
 fs/xfs/libxfs/xfs_alloc_btree.h |    3 ---
 fs/xfs/scrub/alloc_repair.c     |   11 +++++++----
 3 files changed, 7 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 847674658d675..99859803bb0b8 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -548,21 +548,6 @@ xfs_allocbt_init_cursor(
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
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 45df893ef6bb0..1c910862535f7 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
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
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 45edda096869c..544c53d450ce2 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -735,10 +735,13 @@ xrep_abt_build_new_trees(
 	ra->new_cntbt.bload.claim_block = xrep_abt_claim_block;
 
 	/* Allocate cursors for the staged btrees. */
-	bno_cur = xfs_allocbt_stage_cursor(sc->mp, &ra->new_bnobt.afake,
-			pag, XFS_BTNUM_BNO);
-	cnt_cur = xfs_allocbt_stage_cursor(sc->mp, &ra->new_cntbt.afake,
-			pag, XFS_BTNUM_CNT);
+	bno_cur = xfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
+			XFS_BTNUM_BNO);
+	xfs_btree_stage_afakeroot(bno_cur, &ra->new_bnobt.afake);
+
+	cnt_cur = xfs_allocbt_init_cursor(sc->mp, NULL, NULL, pag,
+			XFS_BTNUM_CNT);
+	xfs_btree_stage_afakeroot(cnt_cur, &ra->new_cntbt.afake);
 
 	/* Last chance to abort before we start committing fixes. */
 	if (xchk_should_terminate(sc, &error))

