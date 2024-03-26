Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B97D21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424708; cv=none; b=swr47R9gJh6+4sHYGSXMAj5iqgHg04+KEiYyjwqmC1ecUwMLKCNHGoOsY86DUJ3pCAUesXhddbl1Eja7UaywVlAPLqv5PMzhSD0urWLNjEl27WDBNsTUMVP3CCLzIeUSlBqEYT89vhTT4DK8pGr7m23UaRU8qr4MrLtHVeEZNi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424708; c=relaxed/simple;
	bh=IfH1tZy2HImgN21n0W7lOtK1ItaC04VjgwOpro4iLkA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4HD+jH5TNQcd9xMsRnHZYhotIbyaVm/AsOCwUL5kd/soy+J1dk6cHWoEz0vI0S/O1Z8xHrJPf8+IauLlsHEk1jPAzfsxqHWekM2Bg3yxBt5AX/BtYjHaqmnJbZkpOyYXtZ+4b+MbmGIhY+yhnGPERA8Vn7SecXvTh+Hk8VcN20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nGkLSShX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nGkLSShX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCFDC433C7;
	Tue, 26 Mar 2024 03:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424707;
	bh=IfH1tZy2HImgN21n0W7lOtK1ItaC04VjgwOpro4iLkA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nGkLSShXPbRkBGjIUaggjLWYW1CKwEKpnmXxMgB48xvqpMcqvBEH0SWhjQ1uveAIT
	 i20xD2t+qia8eOxJ69nK8MZ4MmedMkerTMkjQYRxJGm6UHQGIZN3fp5lKULUA9XkS0
	 A3Zab8Y+slFi6C9GDk7yjrGi5HkEmn7WhXZKqQuBFAls0k6Q+Eoo8uQuPEBUpf8aWY
	 vJKN55xGOrFeep0/w0Os0SWQOdZgeY/fD+Dz++oTPHfxiPL1sKpZwMuptWliW7gLGD
	 qiTaOGm/evOUtzwLNSFLH4Pq3KdanaNIqu6NfbfYPQt0wQgz6WxCb7JYaj2/+2bssa
	 X1haweGs9dksQ==
Date: Mon, 25 Mar 2024 20:45:07 -0700
Subject: [PATCH 064/110] xfs: remove xfs_bmbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132300.2215168.8651844184759394290.stgit@frogsfrogsfrogs>
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

Source kernel commit: 02f7ebf5f99c3776bbf048786885eeafeb2f21ca

Just open code the two calls in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bmap_inflate.c        |    8 ++++++--
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_bmap_btree.c  |   19 -------------------
 libxfs/xfs_bmap_btree.h  |    2 --
 repair/bmap_repair.c     |    4 +++-
 5 files changed, 11 insertions(+), 24 deletions(-)


diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index 33b0c954d8f8..c85d5dc0d64a 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -351,7 +351,9 @@ build_new_datafork(
 	/* Set up staging for the new bmbt */
 	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
 	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
-	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
+	bmap_cur = libxfs_bmbt_init_cursor(ip->i_mount, NULL, ip,
+			XFS_STAGING_FORK);
+	libxfs_btree_stage_ifakeroot(bmap_cur, &ifake);
 
 	/*
 	 * Figure out the size and format of the new fork, then fill it with
@@ -405,7 +407,9 @@ estimate_size(
 	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
 	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
 
-	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
+	bmap_cur = libxfs_bmbt_init_cursor(ip->i_mount, NULL, ip,
+			XFS_STAGING_FORK);
+	libxfs_btree_stage_ifakeroot(bmap_cur, &ifake);
 	error = -libxfs_btree_bload_compute_geometry(bmap_cur, &bmap_bload,
 			nextents);
 	libxfs_btree_del_cursor(bmap_cur, error);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 2adf20ce8a41..b0f9d9edb634 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -54,6 +54,7 @@
 #define xfs_bmbt_commit_staged_btree	libxfs_bmbt_commit_staged_btree
 #define xfs_bmbt_disk_get_startoff	libxfs_bmbt_disk_get_startoff
 #define xfs_bmbt_disk_set_all		libxfs_bmbt_disk_set_all
+#define xfs_bmbt_init_cursor		libxfs_bmbt_init_cursor
 #define xfs_bmbt_maxlevels_ondisk	libxfs_bmbt_maxlevels_ondisk
 #define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
 #define xfs_bmbt_stage_cursor		libxfs_bmbt_stage_cursor
@@ -65,6 +66,7 @@
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_btree_rec_addr		libxfs_btree_rec_addr
 #define xfs_btree_stage_afakeroot	libxfs_btree_stage_afakeroot
+#define xfs_btree_stage_ifakeroot	libxfs_btree_stage_ifakeroot
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 0afe541c52cd..828dfb7d4247 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -597,25 +597,6 @@ xfs_bmbt_block_maxrecs(
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
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index e93aa42e2bf5..de1b73f1225c 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -107,8 +107,6 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
-struct xfs_btree_cur *xfs_bmbt_stage_cursor(struct xfs_mount *mp,
-		struct xfs_inode *ip, struct xbtree_ifakeroot *ifake);
 void xfs_bmbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, int whichfork);
 
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 1dbcafb22736..845584f18450 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -475,7 +475,9 @@ xrep_bmap_build_new_fork(
 	 */
 	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
 	bulkload_init_inode(&rb->new_fork_info, sc, rb->whichfork, &oinfo);
-	bmap_cur = libxfs_bmbt_stage_cursor(sc->mp, sc->ip, ifake);
+	bmap_cur = libxfs_bmbt_init_cursor(sc->mp, NULL, sc->ip,
+			XFS_STAGING_FORK);
+	libxfs_btree_stage_ifakeroot(bmap_cur, ifake);
 
 	/*
 	 * Figure out the size and format of the new fork, then fill it with

