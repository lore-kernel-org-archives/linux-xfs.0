Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C5FBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKv4YhEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213ABC433C7;
	Sun, 31 Dec 2023 21:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058057;
	bh=Y1LWVPL1nPeE4qoUKc8pf7a7GyjMgwDNpWXN3vbT/Xw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XKv4YhEZzSk5djXGRGk+obRKdRAGhSCACnBbgKfmRxdbm+62hlB7eTYXR6woalsZ4
	 2fRg4xY+V5NfPRTI377Jh1Lkt9OnzNIK+5mV9seVZaUc2qlv0H7Zo5tK7iQCBcK0u2
	 oExvt6CV09PO9GFfFKETfvSLf0jSeTfpOlOqX9rBfcDY212AhBd89Jv92yV/OCYH5U
	 O+ZDES0jTMM/hpBkcdRtAX+24SFqIA+hWiq5G55TmYZgmKQqHXn74AgXLrnbAxPfVR
	 XDArBPoj+CnJEWuUG0jxsWhQBoRS/rEez8RzDP92ibY6hAeJE/5C63rRkL0Z0a07MZ
	 c0M6HQO8ni6Uw==
Date: Sun, 31 Dec 2023 13:27:36 -0800
Subject: [PATCH 5/9] xfs: reuse xfs_extent_free_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848417.1764329.4025148745846475029.stgit@frogsfrogsfrogs>
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

Reuse xfs_extent_free_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d86ec1d5e468a..9d141b9876572 100644
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
 

