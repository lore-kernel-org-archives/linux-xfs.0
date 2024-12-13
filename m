Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0852D17BA6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051559; cv=none; b=NaNtNl8rBY5LqCZ74LkwRZJD0BLcaONX2hl0nzZdhpYWZCp7HUYiTGv43DAtqQzdj3xu0kbXS1EqjIuKRLJNOXABju0ItKwpex9iPWBJPbK3QuadGHaJduh0l0+sj3NumS8nhS4TIhTJ/sIBmscc9U6Q0kb0USNIIJ0lVsnyVp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051559; c=relaxed/simple;
	bh=2cNStEX28HtkB7X84Ft1KrLc74XXm6iA9jyfy3nCZc4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pe9ZfYLFcdw/hQtyEmz4K92bSxsdDi0SsFFjrjm1wNIA1T+v747yOXt9HTtPPPYYA+jb4ughULBt+mjqYbtRQvRUHC/wRk9ORQlZucziw6OKEv6zYbJJCTLPkFiwZaCmj0pCi3cMKL/tkgLn92LL5yn6JUDSHufdB5FXzpz3Deg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCpzxI4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCpzxI4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787BBC4CECE;
	Fri, 13 Dec 2024 00:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051557;
	bh=2cNStEX28HtkB7X84Ft1KrLc74XXm6iA9jyfy3nCZc4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MCpzxI4IvIbC5Ae5ceFpgNQ5/9SWD4TBzuh+CH7YmpLK6bxhieu/OG3DD2ozOS2yk
	 gRQEk4hRKhNtss1LrvxH7fZM3I4og0+Z6cK2/XW75++txukW6rCWP7U8qzr0bUpRUw
	 KtQDs2BXeNI+OZVaqSGvPnxLFIogOhJQV50qda/0WTuHGpC8+xAU5a0iixV/vqCVxo
	 AxQ0FZyoIA0qVpdfYw8oGqRe2wDo/9c0YTFicmaH4c1Yz8Tnlkr/sMF9SHiU31Z6i1
	 Zq74m0Fz6grAbk2SxW7ifQoRiRWeoapJFMAl3nSXxBZjjMqc8xd615QqOY0G6q/F+h
	 8uxrOcbLXoN2Q==
Date: Thu, 12 Dec 2024 16:59:16 -0800
Subject: [PATCH 5/8] xfs: tidy up xfs_bmap_broot_realloc a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122246.1180922.12746792857754358632.stgit@frogsfrogsfrogs>
In-Reply-To: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist out the code that migrates broot pointers during a resize
operation to avoid code duplication and streamline the caller.  Also
use the correct bmbt pointer type for the sizeof operation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   43 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 22cf2059d54dd4..908d7b050e9ce0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -516,6 +516,22 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
+static inline void
+xfs_bmbt_move_ptrs(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*broot,
+	short			old_size,
+	size_t			new_size,
+	unsigned int		numrecs)
+{
+	void			*dptr;
+	void			*sptr;
+
+	sptr = xfs_bmap_broot_ptr_addr(mp, broot, 1, old_size);
+	dptr = xfs_bmap_broot_ptr_addr(mp, broot, 1, new_size);
+	memmove(dptr, sptr, numrecs * sizeof(xfs_bmbt_ptr_t));
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records.  Move the
  * records and pointers in if_broot to fit the new size.  When shrinking this
@@ -541,8 +557,7 @@ xfs_bmap_broot_realloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	char			*np;
-	char			*op;
+	struct xfs_btree_block	*broot;
 	unsigned int		new_size;
 	unsigned int		old_size = ifp->if_broot_bytes;
 
@@ -577,15 +592,11 @@ xfs_bmap_broot_realloc(
 		 * they are kept butted up against the btree block header.
 		 */
 		old_numrecs = xfs_bmbt_maxrecs(mp, old_size, false);
-		xfs_broot_realloc(ifp, new_size);
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     old_size);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     (int)new_size);
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+		broot = xfs_broot_realloc(ifp, new_size);
+		ASSERT(xfs_bmap_bmdr_space(broot) <=
 			xfs_inode_fork_size(ip, whichfork));
-		memmove(np, op, old_numrecs * (uint)sizeof(xfs_fsblock_t));
-		return ifp->if_broot;
+		xfs_bmbt_move_ptrs(mp, broot, old_size, new_size, old_numrecs);
+		return broot;
 	}
 
 	/*
@@ -599,15 +610,11 @@ xfs_bmap_broot_realloc(
 	 * not butted up against the btree block header, then reallocating
 	 * broot.
 	 */
-	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1, old_size);
-	np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-					     (int)new_size);
-	memmove(np, op, new_numrecs * (uint)sizeof(xfs_fsblock_t));
-
-	xfs_broot_realloc(ifp, new_size);
-	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+	xfs_bmbt_move_ptrs(mp, ifp->if_broot, old_size, new_size, new_numrecs);
+	broot = xfs_broot_realloc(ifp, new_size);
+	ASSERT(xfs_bmap_bmdr_space(broot) <=
 	       xfs_inode_fork_size(ip, whichfork));
-	return ifp->if_broot;
+	return broot;
 }
 
 static struct xfs_btree_block *

