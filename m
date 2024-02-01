Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327D885289
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816975; cv=none; b=TCRJuoyHAkwDnOoUulExLC2kFiBo3zOcRM8km2VWnlOs/0o2O0bt3svE+tU0BEcjZ6JqeZf6FpxQ4WCKRzzF0iK/Jvdn2xwv3+T0HIE94vb1fe7hYK+On6yq/Mc6J37OoNptQTSPfAFeajzK0GBcqP623JzQIgmG9bCi6xrSbHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816975; c=relaxed/simple;
	bh=wCkUU05aOyAFaBoGL1ex1c0vgLWUcP7KofB8+JYKqTY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTxLWWIGJT3qUES6eiXlP4Z4eP6TkVCa6NntmwOOb7S+hITz7Pq6Dvm6gg9djc1I4HIr4De8eNBfnvsdm4UkWzZaI+Ef69DuTZSuIVHTc1b6hWJ/u/Vzd4IQx7wSUVjkaTpids2wQYaE3HU0z7j5co6/iYWB1Rd7M9SpUova60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siXsj6Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siXsj6Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D77C433F1;
	Thu,  1 Feb 2024 19:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816975;
	bh=wCkUU05aOyAFaBoGL1ex1c0vgLWUcP7KofB8+JYKqTY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=siXsj6RnEUgywO3xQ+EltpH1DpR0o20EjYcU5CKGR5ul2G4VKAjSZVZ+UNPUIgcQd
	 /caJwEnkuzvOWospyOGC5czWEeSeNIGF3Dv4EJi2kK4/p9UdpEs2q0hOE2sCVRE0YH
	 MYB7AbWEbpd7xgL275gbnvP05SLEdVdIW1Ho2llIJOUGjkulJvBLQOLTFUhmfToTNz
	 sR/ULNHV4OGCvihT1LQOtTaByhKxPDrsZOI8sgKnTVzbXDXwNp2j9vPBLPJJA9CO/6
	 lOaVsdnhDT4beExRlsjme3S+rd5xiB5hA8HtQZuGEeG9UZjC1lLIH6BS/EIBbBAD21
	 rBbvtxVmIlKfQ==
Date: Thu, 01 Feb 2024 11:49:34 -0800
Subject: [PATCH 15/27] xfs: remove xfs_bmbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335027.1605438.4521488811231990374.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap_btree.c |   19 -------------------
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 --
 fs/xfs/scrub/bmap_repair.c     |    8 +++++++-
 3 files changed, 7 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index c338c5be4c67a..1104bf4098e2e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -598,25 +598,6 @@ xfs_bmbt_block_maxrecs(
 	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
 }
 
-/*
- * Allocate a new bmap btree cursor for reloading an inode block mapping data
- * structure.  Note that callers can use the staged cursor to reload extents
- * format inode forks if they rebuild the iext tree and commit the staged
- * cursor immediately.
- */
-struct xfs_btree_cur *
-xfs_bmbt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xfs_inode	*ip,
-	struct xbtree_ifakeroot	*ifake)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_bmbt_init_cursor(mp, NULL, ip, XFS_STAGING_FORK);
-	xfs_btree_stage_ifakeroot(cur, ifake);
-	return cur;
-}
-
 /*
  * Swap in the new inode fork root.  Once we pass this point the newly rebuilt
  * mappings are in place and we have to kill off any old btree blocks.
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index e93aa42e2bf5b..de1b73f1225ca 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -107,8 +107,6 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
-struct xfs_btree_cur *xfs_bmbt_stage_cursor(struct xfs_mount *mp,
-		struct xfs_inode *ip, struct xbtree_ifakeroot *ifake);
 void xfs_bmbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, int whichfork);
 
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index a4bb89fdd5106..1e656fab5e41a 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -639,7 +639,13 @@ xrep_bmap_build_new_fork(
 	rb->new_bmapbt.bload.get_records = xrep_bmap_get_records;
 	rb->new_bmapbt.bload.claim_block = xrep_bmap_claim_block;
 	rb->new_bmapbt.bload.iroot_size = xrep_bmap_iroot_size;
-	bmap_cur = xfs_bmbt_stage_cursor(sc->mp, sc->ip, ifake);
+
+	/*
+	 * Allocate a new bmap btree cursor for reloading an inode block mapping
+	 * data structure.
+	 */
+	bmap_cur = xfs_bmbt_init_cursor(sc->mp, NULL, sc->ip, XFS_STAGING_FORK);
+	xfs_btree_stage_ifakeroot(bmap_cur, ifake);
 
 	/*
 	 * Figure out the size and format of the new fork, then fill it with

