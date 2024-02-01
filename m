Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5485E12FB04
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816631; cv=none; b=RG5Dzznzzby/HyqcBRofc08M2i8VTLjAHDrjnPbJnajE4TIJfiFSagv6ikkeBwyb5G86YDmm8IbCCl21NWfAx/55+h4H9pcb8H0NQDgwGNEjdf+fcsEbMugD5ay+cWG8rY72i3jSeXoyFtj90RPOObEPv6JmE1vWnHtbR6jZk1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816631; c=relaxed/simple;
	bh=SxXkleIimzCb7ClKj9ZOqmz2UWHJS51k7SFjxzvN+wc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=McBpXP6noV4Z5OEbPiOBt83mG5NekT2jZEtpqwXs9oevktxnUMOcuQFKNTYBakTW9WVkOhOjUlVxYJDdil8RATucxanw5GIPhkXf3JAw+c1wX6HhjVt/DNFEbDmWXX1Kxd1DFamQphJlXOdlEQL1r8kwTAyFG2imjUe38RkgDYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qygB9sCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qygB9sCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE64AC433C7;
	Thu,  1 Feb 2024 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816630;
	bh=SxXkleIimzCb7ClKj9ZOqmz2UWHJS51k7SFjxzvN+wc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qygB9sCI7aOHh8RNSO0CQqgtiXo3Jp3iz2UgSBhl0ZDpkX2oKLoSOoYissRYSBxHU
	 UqkEqMDO6o5wfgwtcdAM6mVAzOGvRJ9W02xDuTuxVoHtecer9AMcteTKAZdt/CaLjq
	 P8BgEfq1Q2QHUKfA29E9Ra3+efX4VLu/orVTZycfVVTEXeEuhTGffQgMbKfQv66exo
	 DEI9kcEH/G86jrDz+rTgywb6hknGCeyxKnNlKHSp7ZO8mT3w2EzsWZ9Ugsmp88zsO3
	 55TQ03uCvhn7Gfb+ORtQVBU131oiHxh1nTMOv+n61WHI4+6uprLbHtLBjyuL41teAC
	 uQK60nDUSahmA==
Date: Thu, 01 Feb 2024 11:43:50 -0800
Subject: [PATCH 16/23] xfs: move lru refs to the btree ops structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334200.1604831.1088026041883582329.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the btree buffer LRU refcount to the btree ops structure so that we
can eliminate the last bc_btnum switch in the generic btree code.  We're
about to create repair-specific btree types, and we don't want that
stuff cluttering up libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    4 ++++
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 ++
 fs/xfs/libxfs/xfs_btree.c          |   24 ++----------------------
 fs/xfs/libxfs/xfs_btree.h          |    3 +++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    4 ++++
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 ++
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 ++
 7 files changed, 19 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a983c4fe83902..045c7954ef1b1 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -458,6 +458,8 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
+
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
@@ -483,6 +485,8 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
+
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index fa116c2d13aef..43dc9fa6b26f9 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -530,6 +530,8 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
 
+	.lru_refs		= XFS_BMAP_BTREE_REF,
+
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.update_cursor		= xfs_bmbt_update_cursor,
 	.alloc_block		= xfs_bmbt_alloc_block,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a42d293e91bfd..8777047725b92 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1284,32 +1284,12 @@ xfs_btree_buf_to_ptr(
 	}
 }
 
-STATIC void
+static inline void
 xfs_btree_set_refs(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		xfs_buf_set_ref(bp, XFS_ALLOC_BTREE_REF);
-		break;
-	case XFS_BTNUM_INO:
-	case XFS_BTNUM_FINO:
-		xfs_buf_set_ref(bp, XFS_INO_BTREE_REF);
-		break;
-	case XFS_BTNUM_BMAP:
-		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
-		break;
-	case XFS_BTNUM_RMAP:
-		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
-		break;
-	case XFS_BTNUM_REFC:
-		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
-		break;
-	default:
-		ASSERT(0);
-	}
+	xfs_buf_set_ref(bp, cur->bc_ops->lru_refs);
 }
 
 int
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 7d24681bf0994..892d1b9b5b1e9 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -120,6 +120,9 @@ struct xfs_btree_ops {
 	size_t	key_len;
 	size_t	rec_len;
 
+	/* LRU refcount to set on each btree buffer created */
+	unsigned int		lru_refs;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 69086fdc3be6f..a2a8c15a6c9e7 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -402,6 +402,8 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
+	.lru_refs		= XFS_INO_BTREE_REF,
+
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
 	.alloc_block		= xfs_inobt_alloc_block,
@@ -424,6 +426,8 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
+	.lru_refs		= XFS_INO_BTREE_REF,
+
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
 	.alloc_block		= xfs_finobt_alloc_block,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 36e7b26d5e3b2..eaed9517e7956 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -321,6 +321,8 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 
+	.lru_refs		= XFS_REFC_BTREE_REF,
+
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
 	.alloc_block		= xfs_refcountbt_alloc_block,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 086576626f5b9..8abe90c25f71f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -478,6 +478,8 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,
 	.alloc_block		= xfs_rmapbt_alloc_block,

