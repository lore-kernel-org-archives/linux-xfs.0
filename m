Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0777D7FD
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cug9YoKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC725C433C7;
	Mon,  1 Jan 2024 00:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067596;
	bh=7Tp0d2OoYZM9hYsKIRu0U/UGBJWBqqaWJgmb7aIQofo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cug9YoKlzhhslKw0y4UX0r6/YTSQYJvYYu/iCfpnlpvewafdvRUYrLj0rSaQavb+t
	 2H2RVDBg9KYIqv6dZ9bKJf9Z/upPL5r+mX3k29G6J6fmxtX0zuj2vCD5lOIrVlz7qW
	 7yBsJkqwr3GmGw3Y+2EEOu3X0PB14XcEAQ3ZsVv3M81C+3fxN8JnfR9JI+MXWxcu2Y
	 eAK+clWEhMKPjT9IU06hvHynCRwjcPSe6wPGK7JRkr5K068byxUv4R/zdsB5m1JwmJ
	 9Dd/cAWjGubLlp8ErhVzyDjMLHLzQs8LwngnRbxukjMIMe1H6TRRTWu/dI1VEF+p+3
	 ovZbQugpj3ZMA==
Date: Sun, 31 Dec 2023 16:06:36 +9900
Subject: [PATCH 5/8] xfs: reuse xfs_extent_free_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014109.1814860.2267098574114907765.stgit@frogsfrogsfrogs>
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

Reuse xfs_extent_free_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 5fa54962267..b159f22c1c0 100644
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
 		error = xfs_free_agfl_block(tp, xefi->xefi_pag->pag_agno,
 				agbno, agbp, &oinfo);
 
-	xfs_extent_free_put_group(xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
+	xfs_extent_free_cancel_item(item);
 	return error;
 }
 

