Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E53533080
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347128; cv=none; b=UZThZ0A7soscpuK1os9nUDkw6MAWLIrC45FA2Ypcq1Om3JENTQqzY44j9IXPu/o7or2Nnwcy9hoS7vArhK320gQ6WOK9E2xEbQGmG9/k5ZIoktldH2DqBjTBgThCbEYrbf9gDssEfNc9ZCJ7seMAonf6EO3YvL69jvdf/SVTo/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347128; c=relaxed/simple;
	bh=A9oC72A8bN0azR3mWWOniLVxwhnwbGwnsHC6FFp7eK8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q85Md26mHJSxz82zha/uiW2iy6zdInerDGhU4LBUzPbs2NrfZaV9KFe5VndgUWRbS05QuAT+nUYKjTtlQMPlm5kVOG6jn2uL75/btZRuaCfcSmKawpl7966NPenzmVyuhSlUKgBGQXTn0bn7tov1ZkFxjeqTfTBz73WFP4eVdHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TnJOUV18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnJOUV18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63171C2BD11;
	Wed, 22 May 2024 03:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347128;
	bh=A9oC72A8bN0azR3mWWOniLVxwhnwbGwnsHC6FFp7eK8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TnJOUV18kGdUzFS6CVY9EwAj2nPR0PNlPBlf8spKPPn/n0/JGmdjkOBf7XeG1BJ3w
	 Btxr00LBfbN9TYPOfc2jiPADEAh2QHzjMl5GYP/zIHN1Z+9P2t967dMg3V9XwaLWQx
	 f9T6cYYLDi5ZLpKJBMn/DnWCn5awt+TWZBXwYpS6BRzCvx2tmXBIuM+ewZfD9Hcp3f
	 r08Vv1Wchiq+WtQb1NRJxRzvmzW+9BCr6l0bOWFsW8YMvjh4L0J7JphidDveaZkMLe
	 f4ntkLhJha++m15uDj9AdtCDBzv96XMZeA0BpVIC+nl5gkB6gq14Sg/m3VBYYxhJOL
	 b73+OC/n7iFOA==
Date: Tue, 21 May 2024 20:05:27 -0700
Subject: [PATCH 064/111] xfs: remove xfs_bmbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532658.2478931.12667990325939912565.stgit@frogsfrogsfrogs>
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
index 33b0c954d..c85d5dc0d 100644
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
index 2adf20ce8..b0f9d9edb 100644
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
index 0afe541c5..828dfb7d4 100644
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
index e93aa42e2..de1b73f12 100644
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
index 1dbcafb22..845584f18 100644
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

