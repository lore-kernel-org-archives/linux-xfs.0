Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2A714F13F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924743; cv=none; b=JZKtfW2vp6NhVmI+uXx/c9U5ZXMpPKMHZpP6YPSHCgU/svsyLoeInsBM6X8XVmjjoIIuHc0udsG6u5o2fuoCJa/SXsCcahw6/N51Ds+peSLVq5ww676qlW9TOi/Jzb4bD25A9/FYuwNeYFzv7m6lnWmjNJjIZwAtzLfj4qIdGBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924743; c=relaxed/simple;
	bh=6S74cZOJm8OQ9Sgz0/QT761vORmuQ+YV10D4fU/d5Vo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cozmWWAGnSXIHWUQXtEsW4UPM/ZEQLk4STBYu/ma0QQht/eAzRmnH7ywVhTFhVPQBk/0XgM6zyWEmdVMdtI11yugxQpQ3KBi/+VpKkyQR5EI12bZPLK1Izt3oQC2hhmiPkhX3ZAE7KqhFtMemY9uiUQaLx+QQbdgBkcIavNpD/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BX2NYwZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BX2NYwZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954CAC4AF07;
	Thu, 20 Jun 2024 23:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924742;
	bh=6S74cZOJm8OQ9Sgz0/QT761vORmuQ+YV10D4fU/d5Vo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BX2NYwZqkXsMOp1D0u3ElxpEAdEkWOPKHgDzz3czDHjfOf5a/oWlcyI9L0S6PJ6FF
	 k3wEMeNOhE3z/RdZAFenMwElMJwD7NgINUS8DYXwZ2StuX3rFKKSDDTSs7ZsMWCRc7
	 ki8a1stSQnfUHFSikYPmO+aEF5peWfGxm5kZ8tbo+u2hiNlGR1+o+l2hGLZrQsvGlS
	 zaYx71zTyDwCMcAwZ6T1w878Ygwa0DMctr56jshW1hFoJDfK4A9u6SrYjMHFTYzCfo
	 zxXIGYRrmPnUjpPA+i7jPLkdeebwAONKgGSHEVjCMycSXw2dxMQ07ZEvoH9WKRz8hk
	 +Ckz/KfQs1uNA==
Date: Thu, 20 Jun 2024 16:05:42 -0700
Subject: [PATCH 4/9] xfs: add a xefi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418766.3183906.13253402160489040768.stgit@frogsfrogsfrogs>
In-Reply-To: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the
xfs_extent_free_item structure and use it so shorten assignments
and avoid the need for extra local variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 349d78b3f38aa..352a053e071c3 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -303,6 +303,11 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_intent	= xfs_efd_item_intent,
 };
 
+static inline struct xfs_extent_free_item *xefi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_extent_free_item, xefi_list);
+}
+
 /*
  * Fill the EFD with all extents from the EFI when we need to roll the
  * transaction and continue with a new EFI.
@@ -338,11 +343,8 @@ xfs_extent_free_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_extent_free_item	*ra;
-	struct xfs_extent_free_item	*rb;
-
-	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
-	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
+	struct xfs_extent_free_item	*ra = xefi_entry(a);
+	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
 	return ra->xefi_pag->pag_agno - rb->xefi_pag->pag_agno;
 }
@@ -444,7 +446,7 @@ xfs_extent_free_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_owner_info		oinfo = { };
-	struct xfs_extent_free_item	*xefi;
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
@@ -452,7 +454,6 @@ xfs_extent_free_finish_item(
 	xfs_agblock_t			agbno;
 	int				error = 0;
 
-	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 
 	oinfo.oi_owner = xefi->xefi_owner;
@@ -504,9 +505,7 @@ STATIC void
 xfs_extent_free_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_extent_free_item	*xefi;
-
-	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
 	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
@@ -526,14 +525,13 @@ xfs_agfl_free_finish_item(
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
-	struct xfs_extent_free_item	*xefi;
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 	struct xfs_extent		*extp;
 	struct xfs_buf			*agbp;
 	int				error;
 	xfs_agblock_t			agbno;
 	uint				next_extent;
 
-	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 	ASSERT(xefi->xefi_blockcount == 1);
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;

