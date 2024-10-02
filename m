Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274781C2E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832114; cv=none; b=Om2vaQM57AT7Sqbv8YLt7Y636Vp2H+uOgxaS7UH2Iwkh7RmPEOUrzUtnVnH3KoWGrG24uWd7j/s8Jyhhd5INYYPfcFfLpGxsrhH8JWuOQhfhr/d6ZFPSz89F994dn7xgpZ+hiGn6shSYGpwW8lTWmSXBxQLnTyZOafkkGPfjgiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832114; c=relaxed/simple;
	bh=+vQNiwRf6PlrdMFfUjeRkfMnbpGue/Czf6gRwZzLJz8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k7OtOQ2LVi51NAmcK4M2z5+4C033XgHUPsoGJw1NuM9nQoCJFP/LTJpSZvH2P8cHJve/+2gYen5RX4Pfq5A32NfN4jZuzoece33WMoNMwDvU/I5oD0fVch/BiNTKDs6EiPPig39HvaWwoUL+6eTWypjtOWyxcI/4rQXOtayOc7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xrxe2oMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xrxe2oMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47AEC4CEC6;
	Wed,  2 Oct 2024 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832113;
	bh=+vQNiwRf6PlrdMFfUjeRkfMnbpGue/Czf6gRwZzLJz8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xrxe2oMqpA9yi1WdnsVxceNhNwZj66PZkFOqMbsfpsIX3h8u0AzeMYYM5nCfNGrZu
	 vZmZAHkxTJw9aJSS+AOxJe7tLv4rhLGtiuyyoSy5yeWKb5jsS+2sbaA4HfX2hg5BxN
	 vSjjSFTYFT9mgYkkqeCETwB8bXdfh00ovyHe/Yfu9YQjZ76u8TquGLY0B46jiCEmD5
	 IY2YvWb/qfkWLqnkvaNT8TuSs5hN1zBiFt1YH8E9hn0O2UPWVwD01z+JZLIwn8y/Hc
	 +U2jyWhjMW0tD90iAQyfvBW2v38xGYZUvNCiiUMQNtAfB1WH+PvtAopUGps2XtlybQ
	 1P/j+kq/kOFEA==
Date: Tue, 01 Oct 2024 18:21:53 -0700
Subject: [PATCH 54/64] xfs: reuse xfs_refcount_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102595.4036371.5644862752921995440.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 8aef79928b3ddd8c10a3235f982933addc15a977

Reuse xfs_refcount_update_cancel_item to put the AG/RTG and free the
item in a few places that currently open code the logic.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 53902d775..8cf360567 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -381,6 +381,17 @@ xfs_refcount_update_put_group(
 	xfs_perag_intent_put(ri->ri_pag);
 }
 
+/* Cancel a deferred refcount update. */
+STATIC void
+xfs_refcount_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+
+	xfs_refcount_update_put_group(ri);
+	kmem_cache_free(xfs_refcount_intent_cache, ri);
+}
+
 /* Process a deferred refcount update. */
 STATIC int
 xfs_refcount_update_finish_item(
@@ -401,8 +412,7 @@ xfs_refcount_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_refcount_update_put_group(ri);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
+	xfs_refcount_update_cancel_item(item);
 	return error;
 }
 
@@ -413,17 +423,6 @@ xfs_refcount_update_abort_intent(
 {
 }
 
-/* Cancel a deferred refcount update. */
-STATIC void
-xfs_refcount_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_refcount_intent	*ri = ci_entry(item);
-
-	xfs_refcount_update_put_group(ri);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
-}
-
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.name		= "refcount",
 	.create_intent	= xfs_refcount_update_create_intent,

