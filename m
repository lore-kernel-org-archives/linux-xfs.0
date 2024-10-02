Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2155227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831849; cv=none; b=YW513ntBfiw0rwF7Qx3vX/A+soMYDZRuseNC8gGnLg1BvdfVHkr3FL/GDqK7A2uRYvC7YJzmrUAL0IoJJNm5XNLCoelHE1LeIL9E7gfSJEBC7nd3qbEoogwTiNIR+FfQ7j6fqjs+9eOoVEvh7auGhXLEXL1JrFPLMTYu7pzlQd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831849; c=relaxed/simple;
	bh=gq7IqJKl7UUG+cu8chodVymbLKDyMggwicuYDS5rzGw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=al1MRuNYhQFeOAKu+brlEJsuSAjq6ol4uFyNKjTaIscHJSQfE7OSAeL111hXAFW5Llrpd5gQAsZ2SHiWDr2Db4QJzujFEllrwYbI8xR+wdoUt1ZgXs938BBJanjH4fMwE7bt+uSLkB8D8c6T7lNcO0Al/aFhHVgrwS14o8bovFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FT0xC1We; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FT0xC1We"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E60DC4CEC6;
	Wed,  2 Oct 2024 01:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831848;
	bh=gq7IqJKl7UUG+cu8chodVymbLKDyMggwicuYDS5rzGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FT0xC1WeH61oPMUM1K6LKsnFsGf80TfLA8HOdduo5qU0C7uL8J8bGw7jceALBcxLU
	 5j0Ly1Z8bCi43+hDudnrspQhmG8KQy5Uan8i/vSSKu2tGmbdVc2FyFAAaqkQIWe8Xh
	 6wxmHUqYKaH5IZTst82Wrlcu7vnmT6R/VxSTuEmZEw6BklkmXUl2+Our9cEPjw3Ejk
	 cQzGveV/0XnWy3TsZ66i4K/3PAQpIR4IK8ra+UfXDg57EBmPSk24B9bFdRmbeOPCC9
	 EUsuYWA8WtwCh6E1MEwoC8tP1lRwMtDxgvuWvGM90laPOUFg+Up3DPrPC619ZCvm5Z
	 yAwtLQOroArMQ==
Date: Tue, 01 Oct 2024 18:17:28 -0700
Subject: [PATCH 37/64] xfs: reuse xfs_extent_free_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102338.4036371.12919469651521958895.stgit@frogsfrogsfrogs>
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

Source kernel commit: 61665fae4e4302f2a48de56749640a9f1a4c2ec5

Reuse xfs_extent_free_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 8cb27912f..dd88e75e9 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -92,6 +92,17 @@ xfs_extent_free_put_group(
 	xfs_perag_intent_put(xefi->xefi_pag);
 }
 
+/* Cancel a free extent. */
+STATIC void
+xfs_extent_free_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_extent_free_item	*xefi = xefi_entry(item);
+
+	xfs_extent_free_put_group(xefi);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
+}
+
 /* Process a free extent. */
 STATIC int
 xfs_extent_free_finish_item(
@@ -123,11 +134,8 @@ xfs_extent_free_finish_item(
 	 * Don't free the XEFI if we need a new transaction to complete
 	 * processing of it.
 	 */
-	if (error == -EAGAIN)
-		return error;
-
-	xfs_extent_free_put_group(xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
+	if (error != -EAGAIN)
+		xfs_extent_free_cancel_item(item);
 	return error;
 }
 
@@ -138,17 +146,6 @@ xfs_extent_free_abort_intent(
 {
 }
 
-/* Cancel a free extent. */
-STATIC void
-xfs_extent_free_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_extent_free_item	*xefi = xefi_entry(item);
-
-	xfs_extent_free_put_group(xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
-}
-
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.name		= "extent_free",
 	.create_intent	= xfs_extent_free_create_intent,
@@ -185,8 +182,7 @@ xfs_agfl_free_finish_item(
 		error = xfs_free_ag_extent(tp, agbp, xefi->xefi_pag->pag_agno,
 				agbno, 1, &oinfo, XFS_AG_RESV_AGFL);
 
-	xfs_extent_free_put_group(xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
+	xfs_extent_free_cancel_item(item);
 	return error;
 }
 

