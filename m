Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAC31514E8
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924758; cv=none; b=RfQVLQ3PoeivXPlyMy15z5BKHf73o74QoYMkSWHkZGqf5dlZwc9E8RrD1D4inxSxAqjHA1jsA0D2np2OgZaTjIBQp9P5RD4NeS52LPjH/Gk7s/kpXFgUksA6OtMb2B5xRc4nVrqFpEXafpgRXwW2jkF4QzssbwlWf8NVRunrgfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924758; c=relaxed/simple;
	bh=ejSBMiWtHgsYCdPnsi1I0ZFGA6jsZyTznMX8M57BmfA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNNOgxQTVFjZjxz6CvUUyySgdueCO0DEljDVQPyOHZoEH+PRszFVOOse4xGFxwL0vUQMZ+JiAR0g76AJoaT8MJwhdjsGU+zdN+P9D2TNoc1qTz3yyFC3hr5JHIX3bIgc5gW627QnX0jfOhSLUzOXLcsVEUFi256J38fLUKwW85Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Op2RWOE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Op2RWOE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0ABC2BD10;
	Thu, 20 Jun 2024 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924758;
	bh=ejSBMiWtHgsYCdPnsi1I0ZFGA6jsZyTznMX8M57BmfA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Op2RWOE9yTSOIgO/+vMkdgLNuP3V4VPdfJMVG6k7CU36+QoWxAnp/PjxRnxp+gi3u
	 la+ux4oVanaqnIXGngFS3H88EG3ZxjNaTfqbLxWVoitMdXaIBcqC2D3UnISZ7cNNS9
	 2gyBKDHh+KnvxGMtH0OU302kaRK7BZmiZHmoZuDZnS/RLUVvwJb1P928PRG7PQ8EA5
	 nHMDpvW1hz5OoAsp6PYLy1DKWLafIyZjz5/L48WowTgRJZ/qVTH4D1/J33yTwd5eTS
	 wGDi0Ol0KFeDWjRtmcGuNA5h3lCDMLv8VL4qFpmHwFCvdCcj9UNRV9zxXS/Apyjh51
	 G6rrG8sFFbF6Q==
Date: Thu, 20 Jun 2024 16:05:57 -0700
Subject: [PATCH 5/9] xfs: reuse xfs_extent_free_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418783.3183906.3362620376087264484.stgit@frogsfrogsfrogs>
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

Reuse xfs_extent_free_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 352a053e071c3..71eaec38dc79b 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -437,6 +437,17 @@ xfs_extent_free_put_group(
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
@@ -487,8 +498,7 @@ xfs_extent_free_finish_item(
 	extp->ext_len = xefi->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	xfs_extent_free_put_group(xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
+	xfs_extent_free_cancel_item(item);
 	return error;
 }
 
@@ -500,17 +510,6 @@ xfs_extent_free_abort_intent(
 	xfs_efi_release(EFI_ITEM(intent));
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
 /*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
@@ -550,8 +549,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = xefi->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	xfs_extent_free_put_group(xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
+	xfs_extent_free_cancel_item(&xefi->xefi_list);
 	return error;
 }
 

