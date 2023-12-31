Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A31BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mcz1zoMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C37DC433C7;
	Sun, 31 Dec 2023 21:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058041;
	bh=dpJjPEG7qhz3yPCXBrPLeaEP1XcqcItWX4OnQVYforQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Mcz1zoMcNp46JD5uKBX0282auRj3VIb+VJUH3Uy+2yJ+pixFdDMIPop1cecx/UpPa
	 MitUKtZrHpsY0MhdofYB6xSJSXOeiGFmhOSkOBGwYVOR0UxVEmdE4DWxt571EdWvUx
	 FGJkyVcuLtxYYawefEh9o+0lDgCErErH7xbpUwcVzWgmLHbpWV3X4G8r6e5TnB2XqS
	 HE1uF71a/00Uux3c9GBu8Hcdqf+oU/SG6hnCOESinc/N4gwyZH46kJ7yYA3hInAvn8
	 +bpCxAmXEAjrEcSXxbTRy5gYD01c52GGQ1AQHTmkNDO5tuil4/bAr6qA7vxvRj4jum
	 vBWTMV9hVmY8g==
Date: Sun, 31 Dec 2023 13:27:20 -0800
Subject: [PATCH 4/9] xfs: add a xefi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848401.1764329.14466513813180386601.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
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
index a29105583de96..d86ec1d5e468a 100644
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

