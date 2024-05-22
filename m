Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7238874418
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347911; cv=none; b=CoSU+uiNET0RQ7GfXJ5a6UPSZ7WvGMO5tsHiNSvSgtlkHfj2Xf9m+DDI1wd29Av2WudCTKc0UM1v2mxOuFybjPmyRT2sA4O8TP/Ikfq8WeQm+SVE5ZOgrKzbdeSyr+aLPowNxgjQROepjfClH5sbc3t7RFi9v4B4jthc/jApSYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347911; c=relaxed/simple;
	bh=FBZsnHOr5AIGIligEInAW7rw/9Eb39Hij/cOw/OLVYI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJ6ZnV3TagDoZ2mMHtxuzbhaAat/aZpK4zUMURzU5fo2++WTrkiio8XI4bgXIBJI9tcUDgCOGYIXeZ0COGwRp1TaMBcUy7iWM+W5AHaLjC8v7Q4e0TfnJhgE7b37JpMgHefWu8a89ScU5uiy+8ldeRTtEC8TPV5I+8cBIBLuxLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANJkXii7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANJkXii7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCD1C2BD11;
	Wed, 22 May 2024 03:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347911;
	bh=FBZsnHOr5AIGIligEInAW7rw/9Eb39Hij/cOw/OLVYI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ANJkXii7vNAWOoT4dfY0LXFsu1sGNO3s6cgQJ7UUuSHkp/yYkL+F+E6MdcI/Yk/0G
	 PhTSK5eSE9tytNueBKfzZU9CYEsxnIuFGGWdkBxyPLgIRkGvQmN1UfDPs7roE0HRH9
	 OWCitrUxcotVrPbPKNi6wmqEbvYf4QW3yOsf1g3mYsirnryEsFY7oUBA3LJ8MxaO+D
	 y35SJBnlM5cF2j0nvFIeBrlUoh84FdlLHiI22k+OdjJQLXfwX4bjjgg9AuSwhNBep4
	 4t1kK4cM79/zEisVa6Tw5BMqCf9mz3GU2pIWYuWV36bwynEqcJFFxsoypBoDv8aAaD
	 P/k2M8GGcQoFw==
Date: Tue, 21 May 2024 20:18:30 -0700
Subject: [PATCH 3/4] libxfs: reuse xfs_bmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533740.2482547.7411542352290551212.stgit@frogsfrogsfrogs>
In-Reply-To: <171634533692.2482547.7100831050962784521.stgit@frogsfrogsfrogs>
References: <171634533692.2482547.7100831050962784521.stgit@frogsfrogsfrogs>
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

Reuse xfs_bmap_update_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d19322a0b..36811c7fe 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -522,6 +522,17 @@ xfs_bmap_update_put_group(
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_bmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bi = bi_entry(item);
+
+	xfs_bmap_update_put_group(bi);
+	kmem_cache_free(xfs_bmap_intent_cache, bi);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
@@ -539,8 +550,7 @@ xfs_bmap_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
+	xfs_bmap_update_cancel_item(item);
 	return error;
 }
 
@@ -551,17 +561,6 @@ xfs_bmap_update_abort_intent(
 {
 }
 
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_bmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_bmap_intent		*bi = bi_entry(item);
-
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
-}
-
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.name		= "bmap",
 	.create_intent	= xfs_bmap_update_create_intent,

