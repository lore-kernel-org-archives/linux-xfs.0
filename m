Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBABB8F5B
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831973; cv=none; b=A0pU0uPf2X6l1CdEG9Zj4VxKnT5D4yJM3p7bYnTfhEPPW4+WkA0PClIASIbGX2yk8Q7TnxVRMEbBiYhV98MvQiuWonj/6Tjdc2g7KUP7gEZTwUjZ/sN94bKNy0Xp16LvQVWUZygDYfkM/BLrugxxGmouPtmC7+46NBWt0K+vfIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831973; c=relaxed/simple;
	bh=QzfWBjambAxJ5M+5l8fY9WHDKH+UtaQ18rgG5rF2bDg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AORDNX3y1DYaqH/lhc3J70zbfniJrgt5bGw8JG8MCmV1ZbGI8Ea/MO2kkMSFBwCMNSibYQdo7aE6zXXKknGGmFSCpjIJGbh5tKqRI6xAn5BLLgn7ZMkpFnNPYHBaC7fCwXhS86Yx6hr+XrYLowZLdFvTEt0tH46SZ2BbfsJKFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Of370okd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Of370okd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E844C4CEC6;
	Wed,  2 Oct 2024 01:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831973;
	bh=QzfWBjambAxJ5M+5l8fY9WHDKH+UtaQ18rgG5rF2bDg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Of370okdfPl271gOSSEEvwdxMQdfltdp/K9DGHlTw9pnTre5NKbpm29XOlIvVIC6u
	 Cz7xiCn6ZmDqkV/8jcV84eVA04MX11I0/sHvHbP220ByW+Gee1mQ+eXbkc64IPs9tk
	 Q8c323B9Lg0YZ1ZkcKzShrontnmiNgyJKP9Qmubf7GXtRyPebqVKM334HfKnrTmC05
	 JIu2ARHFaXz3zh1XxLQg6TDb9U9Z6C3PKlzw2nM/ovFYijgT7XwKSknLyr+YmrKn3E
	 tKlQnrUWd6/PW0SVizbZp1ThaoEk8wZ1u85NelMti0CE8syX2v47Z/oZu7LE2F3BQI
	 dzDfvPtUHFclw==
Date: Tue, 01 Oct 2024 18:19:32 -0700
Subject: [PATCH 45/64] xfs: reuse xfs_rmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102460.4036371.13684319040610907365.stgit@frogsfrogsfrogs>
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

Source kernel commit: 37f9d1db03ba0511403c5d25ba0baaddf5208ba7

Reuse xfs_rmap_update_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 013ce0304..f8b27c55c 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -260,6 +260,17 @@ xfs_rmap_update_put_group(
 	xfs_perag_intent_put(ri->ri_pag);
 }
 
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_rmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*ri = ri_entry(item);
+
+	xfs_rmap_update_put_group(ri);
+	kmem_cache_free(xfs_rmap_intent_cache, ri);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_rmap_update_finish_item(
@@ -273,8 +284,7 @@ xfs_rmap_update_finish_item(
 
 	error = xfs_rmap_finish_one(tp, ri, state);
 
-	xfs_rmap_update_put_group(ri);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
+	xfs_rmap_update_cancel_item(item);
 	return error;
 }
 
@@ -285,17 +295,6 @@ xfs_rmap_update_abort_intent(
 {
 }
 
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_rmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_rmap_intent		*ri = ri_entry(item);
-
-	xfs_rmap_update_put_group(ri);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
-}
-
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.name		= "rmap",
 	.create_intent	= xfs_rmap_update_create_intent,

