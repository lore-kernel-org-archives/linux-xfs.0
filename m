Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276DC1292E6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425476; cv=none; b=TOhAOyBIR6P91YM22Hyp1lAExv54kCvx/4Vr3hYT9MWHjFzxKEslG5x3pgzYfj8kZsTiFSFUYxU9mPbLIr/t6/xpHiqDX84ZlRG0Ve8ZDeoPiYXu/7zli3HapSvWtYlirm6zMkoCcO+/ah0vUgiX4cgIdSGFIG9lWTpF0w6Kcw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425476; c=relaxed/simple;
	bh=UEljtf9sIK7el4HmgNludF4tt3Ia9Xw2RVigQ9TeNPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQf1WbxlSV2eG4fS4WGWQbBI76Lk/VmpJlrtd8O8KuyH1iNpsyCZgYYsxmColAZ7Xu1t6ttTI/vk98Wo8RigmV4jwz9lnW1OosqOlC+g/ewNzr/LYZUGwSkZURX3WeZng/NKBvDyTj7eZbh6IIyw43Px1BLY0gHJFtKn6a72mqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vOXK9aDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vOXK9aDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE6BC433F1;
	Tue, 26 Mar 2024 03:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425475;
	bh=UEljtf9sIK7el4HmgNludF4tt3Ia9Xw2RVigQ9TeNPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vOXK9aDpjSv91lICpn7M+brVIWdfkFfakSYxWaXI/Z188DvA9G9RhGpnVXRxLI/jy
	 hTPUdWVl0PHpn7FiNX+SkzFK17R2IsMss1CTwAl189OHZWFQ0WEfvQQaPxHXWyXzJ6
	 nHX0+wYLSEQx2IaDcg1+Lu3ziIpMpu2JGjU8cLlXVJAi+IcoaiuLuJMrxGZ6dPTJdr
	 nnBWTcVnJinnkAdZw0bzTw9b5abnpveiOQIURtV9zqoP3VJtMSiERU/Hf9WLOQ4+QE
	 nWmLdCmn6gkpcJshH57VJKz+8qqZD/G2re2dF5BNcBiW1pOrab/tYmRAJAR6gzzW3A
	 tgCX7ECySisvw==
Date: Mon, 25 Mar 2024 20:57:55 -0700
Subject: [PATCH 3/4] xfs: reuse xfs_bmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133334.2217863.924055077881029544.stgit@frogsfrogsfrogs>
In-Reply-To: <171142133286.2217863.14915428649465069188.stgit@frogsfrogsfrogs>
References: <171142133286.2217863.14915428649465069188.stgit@frogsfrogsfrogs>
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
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d19322a0b255..36811c7fece1 100644
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

