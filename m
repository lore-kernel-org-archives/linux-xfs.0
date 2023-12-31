Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A74CBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1reS6k3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7600BC433C7;
	Sun, 31 Dec 2023 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054083;
	bh=3FlUvj2LjGq8OKkTcmTsz7aH5CPgG6KUwKV21mmE774=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B1reS6k3vcEYZB9uOt34hocadKiaFNL7KnNM5dubrSybeMQniJRo1LwgmJT0ZkT++
	 TqUae3njPmFIm5pRmfl+trRUK6SX/JY8mWWJxwEDceKiZOyVO3+bviHIBYHRFMz78K
	 K+kJJjJD0ZRsXaTiZCki5Hyq3qAYOUJ+bb97M9U9bajxsV2TbcLFV/WRwebX9ar0AX
	 Zik+ZjYJt9uafbKVd3xZkF7O91Ygde0m1Ahl/csWgiZJ5FHgnX/KFgv4iEtLndnHo3
	 E3ha44dLODwgVTZ4owTrEdL98FDqb8rWs4qAHQoJFlXz5LE9qsKqSHAGIG+0xgIcWq
	 QWLAslT1bQPew==
Date: Sun, 31 Dec 2023 12:21:23 -0800
Subject: [PATCH 4/7] xfs: add a bi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831489.1749708.9412724534892167170.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the bmap_intent
structure and use it so shorten assignments and avoid the need for extra
local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6faa9b9da95a3..2a6afda6cb8ed 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -221,6 +221,11 @@ static const struct xfs_item_ops xfs_bud_item_ops = {
 	.iop_intent	= xfs_bud_item_intent,
 };
 
+static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_bmap_intent, bi_list);
+}
+
 /* Sort bmap intents by inode. */
 static int
 xfs_bmap_update_diff_items(
@@ -228,11 +233,9 @@ xfs_bmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_bmap_intent		*ba;
-	struct xfs_bmap_intent		*bb;
+	struct xfs_bmap_intent		*ba = bi_entry(a);
+	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	ba = container_of(a, struct xfs_bmap_intent, bi_list);
-	bb = container_of(b, struct xfs_bmap_intent, bi_list);
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
@@ -348,11 +351,9 @@ xfs_bmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_bmap_intent		*bi;
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 	int				error;
 
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
-
 	error = xfs_bmap_finish_one(tp, bi);
 	if (!error && bi->bi_bmap.br_blockcount > 0) {
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
@@ -377,9 +378,7 @@ STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_bmap_intent		*bi;
-
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);

