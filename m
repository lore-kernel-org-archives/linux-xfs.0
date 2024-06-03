Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F27913B58E
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441631; cv=none; b=he1YFrRZMa4NYL90X4ciSyMgQ6UGvaVx3RWd+0YhaAXNssHHlp5ef39PfzraluPzXXnz2xnD27Ji+tWftw6TubWarQMWTjYRHhsKnT7CnATyI50ulBAT5NWNUALdy1ME9i19CnqtM7Aa7CaCQPVhbx3obLYTt0ByrC+k+tdRWvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441631; c=relaxed/simple;
	bh=akM9+0h9RY0VaT0N7CpejbiiduETxwswVTs5fvgtUJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GtOw0ed+Dn1I+CZXUfnCnBxUWTBdGKwyRhlsWKKurL5i8xrFGCqLg7Zy6lF6ltt9To6jbYINz4NJzNhURF3qnUjbof+arq6jlKDgTsfcl8BKEOyybfk4Kl2bDlidTiTZbnrwQcecV1I8Ba5zdsE1D/SIKzyVH6kUCMuCi1A+x1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDoy1YA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDoy1YA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C489C4DDE6;
	Mon,  3 Jun 2024 19:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441631;
	bh=akM9+0h9RY0VaT0N7CpejbiiduETxwswVTs5fvgtUJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eDoy1YA99pkVX61sSsP7nLXxFwBjuxXe/hWtggtPQl14Fej9P6uwR8VTbr9DsAb7d
	 mFPeIJa3JfX5fSy8oXX92kcJholx6ez7I3aKng4Dclg4EwR1nVEjUHW2RJOSdaRUdi
	 8i0czd9ydJ6twGQrUjLsSGAfOhOb33TCW4bS3+kCi9ALJrUvRS3UePwhqhPvm1jhjN
	 pjqsTLX2sNP8AL8TK8mp6E1sb8qz4vYkEuQjTAcUblMJhkB43H227cavjE2VVb3iG/
	 lbKVNYMys0VqNCjMF94/VOo8ENzJAyaq3t17psmiq4T8DFIBNxRETrTpFCS8yFwNYz
	 VYYzmRU5Qmnig==
Date: Mon, 03 Jun 2024 12:07:10 -0700
Subject: [PATCH 058/111] xfs: remove xfs_refcountbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040245.1443973.9934131959354012917.stgit@frogsfrogsfrogs>
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

Source kernel commit: a5c2194406f322e91b90fb813128541a9b4fed6a

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_refcount_btree.c |   14 --------------
 libxfs/xfs_refcount_btree.h |    2 --
 repair/agbtree.c            |    4 ++--
 3 files changed, 2 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index c1ae76949..760163ca4 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -375,20 +375,6 @@ xfs_refcountbt_init_cursor(
 	return cur;
 }
 
-/* Create a btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_refcountbt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xbtree_afakeroot	*afake,
-	struct xfs_perag	*pag)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_refcountbt_init_cursor(mp, NULL, NULL, pag);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Swap in the new btree root.  Once we pass this point the newly rebuilt btree
  * is in place and we have to kill off all the old btree blocks.
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index d66b37259..1e0ab25f6 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -48,8 +48,6 @@ struct xbtree_afakeroot;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		struct xfs_perag *pag);
-struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 22e31c47a..395ced6cf 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -719,8 +719,8 @@ init_refc_cursor(
 		return;
 
 	init_rebuild(sc, &XFS_RMAP_OINFO_REFC, est_agfreeblocks, btr);
-	btr->cur = libxfs_refcountbt_stage_cursor(sc->mp, &btr->newbt.afake,
-			pag);
+	btr->cur = libxfs_refcountbt_init_cursor(sc->mp, NULL, NULL, pag);
+	libxfs_btree_stage_afakeroot(btr->cur, &btr->newbt.afake);
 
 	btr->bload.get_records = get_refcountbt_records;
 	btr->bload.claim_block = rebuild_claim_block;

