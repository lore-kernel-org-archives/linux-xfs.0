Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB147ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgzzlxdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27763C433C7;
	Mon,  1 Jan 2024 00:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067581;
	bh=BtXWI/JKI18eNW0L2NjZtE7xTAeLpkSX0rIZxXnduRY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DgzzlxdW/PWIWBalbg1CAvDC14+rkj8tNaRqR+pUEp4GwgIR9OXP9C9TyO0wGr0Pl
	 5u0cNCYHdzazaHLoza5Or88lNZiaG2RkB9jkWftG9zl+UPYvdbWTpTm+eDUG7qVB0C
	 YDC5j1goY1NBe9NEHNSQb/zJOgXhfFkcpmPB6MHUhTo7rkpZSoUS3PQ9Y9bPi2jrKa
	 ndUCzYf9o7RDvJ9ONdyKdu92QsxWKchS4GIwLMPIB3zdR8BnW5WhvPnYKttCZd2hlQ
	 5JdlWS8UuyMbJhCS6qejeifCdVFU4uTwHQA8UjYKkzSkpQcm+87MwevrTSWC5BpYaZ
	 RqU5dah+7H3XQ==
Date: Sun, 31 Dec 2023 16:06:20 +9900
Subject: [PATCH 4/8] xfs: add a xefi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014096.1814860.8871374007628160335.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
References: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the
xfs_extent_free_item structure and use it so shorten assignments and
avoid the need for extra local variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 2958dcb85e5..5fa54962267 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -32,6 +32,11 @@
 
 /* Extent Freeing */
 
+static inline struct xfs_extent_free_item *xefi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_extent_free_item, xefi_list);
+}
+
 /* Sort bmap items by AG. */
 static int
 xfs_extent_free_diff_items(
@@ -39,11 +44,8 @@ xfs_extent_free_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_extent_free_item *ra;
-	const struct xfs_extent_free_item *rb;
-
-	ra = container_of(a, struct xfs_extent_free_item, xefi_list);
-	rb = container_of(b, struct xfs_extent_free_item, xefi_list);
+	struct xfs_extent_free_item	*ra = xefi_entry(a);
+	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
 	return ra->xefi_pag->pag_agno - rb->xefi_pag->pag_agno;
 }
@@ -99,12 +101,10 @@ xfs_extent_free_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_owner_info		oinfo = { };
-	struct xfs_extent_free_item	*xefi;
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 	xfs_agblock_t			agbno;
 	int				error = 0;
 
-	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
-
 	oinfo.oi_owner = xefi->xefi_owner;
 	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
@@ -143,9 +143,7 @@ STATIC void
 xfs_extent_free_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_extent_free_item	*xefi;
-
-	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
 	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
@@ -173,13 +171,11 @@ xfs_agfl_free_finish_item(
 {
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent_free_item	*xefi;
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 	struct xfs_buf			*agbp;
 	int				error;
 	xfs_agblock_t			agbno;
 
-	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
-
 	ASSERT(xefi->xefi_blockcount == 1);
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;

