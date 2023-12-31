Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F971BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X87OayEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDF1C433C7;
	Sun, 31 Dec 2023 20:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054099;
	bh=/CE5EY8AE0xs96Ne/z06u8PYFEbe/0vnQvWdW3Ehbwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X87OayEYE0Jfgc0N+xK0Sr7tHAkc9pHO0SIxJ/WD1h7gN9u8PNGJpcStgR2zDSKfJ
	 DUFQXxtoTLwZL5LZ6JofavRk1dgLCrrZ5OsMzz+aUpgn8wyM2ODpxK9TjsIo+5xmuK
	 rtQT7P8z6IP5g8xv5K7DuTctA+3mAFJfmdOz+4D4LIkghT9j/suGOSoNyxHMpWRhKp
	 3UP8MHTyfri7WeAZw5+PzXQhcPOvJN6LbBjsWQGp6XqKLQyL9A5srSjqj/SZTGh4yC
	 VUJqi5CAkKgVpVmy1Sf/37JMecYZ1zyF+sae+OolgPVqlDQ2Btbz9SZMSMP5bH/cTH
	 boC8HxtCQ82sw==
Date: Sun, 31 Dec 2023 12:21:38 -0800
Subject: [PATCH 5/7] xfs: reuse xfs_bmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831504.1749708.16128807281068864794.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_bmap_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 2a6afda6cb8ed..86c543282de73 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -343,6 +343,17 @@ xfs_bmap_update_put_group(
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
+/* Cancel a deferred bmap update. */
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
 /* Process a deferred bmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
@@ -360,8 +371,7 @@ xfs_bmap_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
+	xfs_bmap_update_cancel_item(item);
 	return error;
 }
 
@@ -373,17 +383,6 @@ xfs_bmap_update_abort_intent(
 	xfs_bui_release(BUI_ITEM(intent));
 }
 
-/* Cancel a deferred bmap update. */
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
 /* Is this recovered BUI ok? */
 static inline bool
 xfs_bui_validate(

