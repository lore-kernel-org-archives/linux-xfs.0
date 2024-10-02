Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585505227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831833; cv=none; b=TbCh/MEhJrg7azn1HEL+D1oaSNFGAWI6Wxjo8fgJXRvYWrn8maOwnI9YVGi15lNNxOhBLhEHDqEMtm+UWJKAICyripiNMgFO69fDz8rj5cAnC7hiC4e3q7lr/clcQXEjM8x5unis8QNvBb/Qjy5QxnH22Qtsqju6MHIVbUIvmlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831833; c=relaxed/simple;
	bh=9zBkSri2gDsGj5K6ZkaoHXVv/VXtLLs7/JZRaS49pLo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBfN6WDN933XvWwasZ3TPf4w1a8CXRDnY/jHK3jvazzQrMrkfvGffV5Sd+M40Cca3Fkn4y+JMcZCt84+jYNm9tMDdkGuubnyNAiiRbkVvX+HaRYfP3nd2Qw6EG4jkHQqb7KGy8Npt9qfKOjdXxOIr+gmxxZYwV7SIQQ6b5iK4gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqBBGHVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqBBGHVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60E1C4CEC6;
	Wed,  2 Oct 2024 01:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831833;
	bh=9zBkSri2gDsGj5K6ZkaoHXVv/VXtLLs7/JZRaS49pLo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TqBBGHVGPFXqEun7yGSkCdVsmGGhJJ5WXwcBq4rXta9ZdTO9UU9/ibmGnYI9PSGAP
	 5y7SpsBIDvPwS1G7dOHlnKcwKYWx0tvOnngw7Y7ylJB19+gfsLE8UXT2tC3ofC7W0y
	 atPGtQ6jV0Ynvvv7uWq7+mExSrrA3TMilp61fexRhFJUIxFic6MZRWcGiSWVm6GBww
	 HoQOtHE9o+BFE2lzA86SPTV+aP3coir7/qFTMD7KokQp3yN7hQ0wqS3SGXLprBVhr0
	 Sx+QydGyAs6r3Q0Un5z3f0rNjopJRVNNs3JD5ZDAohHtPzjnS1c2MIUcOG82FWlKeq
	 rm7REoN4J0UXg==
Date: Tue, 01 Oct 2024 18:17:12 -0700
Subject: [PATCH 36/64] xfs: add a xefi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102323.4036371.17179419501364622946.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 649c0c2b86ee944a1a9962b310b1b97ead12e97a

Add a helper to translate from the item list head to the
xfs_extent_free_item structure and use it so shorten assignments
and avoid the need for extra local variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index fb40a6625..8cb27912f 100644
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

