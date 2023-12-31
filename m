Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B11EBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W21o1mok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D626BC433C7;
	Sun, 31 Dec 2023 21:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058260;
	bh=e32rGNCbi7lzpC3TsJMu1xBBLHceRPSymumfYuPhXf8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W21o1mok5nd5Aw7XRAB73bX3lNZh+6EMNdVApnD16vve1uhUwxY2DlkrEgJ048AqD
	 u2uaySQGljDrbgtqwF5ADV5bGsn/GUa3kD2S6qVcehKPWL6uQoN0ZBtf+AJDF1ktep
	 1+ZVqxqeipRbRmRiCrm/ywqFr1KeGWIPq0pV4yQXmqdPaL83NvgIcyGMRK4c9QRH41
	 9NrG3EjqUj6NXUMApT+A3L5Flm73IkgsGXCXVZ9oJ7Oz23vYbqXonIARuhaU1fBMVK
	 E5NnyZZJRFd2EhY+CYkX+DziZqtnnjdV8oSA2X0kqPftcYaCve2jCTXG0vmWSyiqcI
	 g1u5LoQQsdAcA==
Date: Sun, 31 Dec 2023 13:31:00 -0800
Subject: [PATCH 07/10] xfs: reuse xfs_rmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404849347.1764703.5052665893187641728.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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

Reuse xfs_rmap_update_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 80433d6b2f9a3..9ce11e27cb9fd 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -357,6 +357,17 @@ xfs_rmap_update_put_group(
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
@@ -370,8 +381,7 @@ xfs_rmap_update_finish_item(
 
 	error = xfs_rmap_finish_one(tp, ri, state);
 
-	xfs_rmap_update_put_group(ri);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
+	xfs_rmap_update_cancel_item(item);
 	return error;
 }
 
@@ -383,17 +393,6 @@ xfs_rmap_update_abort_intent(
 	xfs_rui_release(RUI_ITEM(intent));
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
 /* Is this recovered RUI ok? */
 static inline bool
 xfs_rui_validate_map(

