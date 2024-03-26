Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEF721353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424645; cv=none; b=V0usgPQrNGUe5h8ISnRnJnWdF0hNjkeaOCXeLLwDRJHLck+933wEWWN3vJoY/nzsh3+p3hLbZZDv0B7IiJVam4TT4e9b0GXK/63hx1an2lSTusEkVXzrK13kLPFaLJg6FGRWgZOIMQR83dyzXIOgSvTPpaKojDqSLx0EzPUTsdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424645; c=relaxed/simple;
	bh=+hZTHuybOmfkAxABRMhqDexbf0DR5zvNrTJVU81ut98=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJad9Pi0IMNyQ3b7iOizUJZAVTFLwXXERNXbiUoCDNe0bbXhvQk4gGOLDNnufgjIhiFb5mCwRmYBe1TGZQAhY7nGQG9e2xhDhJEgZJQZzLIyAn5jr1wUQ0HxoPtmeBOffeu8GLaM+Nak0URyH0m1PKB31KPU0URA3+oNDKtolQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QahLAqTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QahLAqTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11689C433F1;
	Tue, 26 Mar 2024 03:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424645;
	bh=+hZTHuybOmfkAxABRMhqDexbf0DR5zvNrTJVU81ut98=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QahLAqTVT6YY8G8JID5JP/+xkq9oYB3p5eKgMnhhrxeWsMaROwtDkyWaRqkxp+PKK
	 +DRsqPDScf6z/yxmEBhbz7s2OcwUjyBmLBYQCydCehEtrPXvDm44y6x8raB990Raaw
	 GZ0z/5txzHXRPZrDezMkONOPJ/mJ1SCFOAQ3iE5kr6WlFaCPu6CWJcLTG6tIaRCRR0
	 zUL1gI4DrHEPCL11AMslLZP97S9/sE64qUJQsxMVum1uXyVeSHjtFNdQswMJNniPhv
	 z4iKbcOwjliCk+BMno0Bkv44NHJNvv58F+U3+yC8iGLhKqLJUlDp+LiFO7zqBMHppf
	 ZiERgGbpFketw==
Date: Mon, 25 Mar 2024 20:44:04 -0700
Subject: [PATCH 060/110] xfs: remove xfs_rmapbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132245.2215168.12398165456754103552.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1317813290be04bc37196c4adf457712238c7faa

xfs_rmapbt_stage_cursor is currently unused, but future callers can
trivially open code the two calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap_btree.c |   14 --------------
 libxfs/xfs_rmap_btree.h |    2 --
 repair/agbtree.c        |    3 ++-
 3 files changed, 2 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index fabab29e25ce..5fad7f20b9d6 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -526,20 +526,6 @@ xfs_rmapbt_init_cursor(
 	return cur;
 }
 
-/* Create a new reverse mapping btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_rmapbt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xbtree_afakeroot	*afake,
-	struct xfs_perag	*pag)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_rmapbt_init_cursor(mp, NULL, NULL, pag);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Install a new reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 3244715dd111..27536d7e14aa 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -44,8 +44,6 @@ struct xbtree_afakeroot;
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
 				struct xfs_perag *pag);
-struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 int xfs_rmapbt_maxrecs(int blocklen, int leaf);
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 395ced6cffcb..ab97c1d79ba1 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -637,7 +637,8 @@ init_rmapbt_cursor(
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_AG, est_agfreeblocks, btr);
-	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, pag);
+	btr->cur = libxfs_rmapbt_init_cursor(sc->mp, NULL, NULL, pag);
+	libxfs_btree_stage_afakeroot(btr->cur, &btr->newbt.afake);
 
 	btr->bload.get_records = get_rmapbt_records;
 	btr->bload.claim_block = rebuild_claim_block;

