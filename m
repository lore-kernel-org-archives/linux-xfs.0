Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6437C185E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229302; cv=none; b=q8wYp4vCTJ6Gwj0Xx34GlcKXg3+4f/dsX+akKbV+R/xnVWdDBgDVI5pCVApbe1Ub8UiYQBAKL0g3csKPUvArC8FT5AMTAbdHfMRzLrIGwnpvTgNeImaQ1hFh5SwFkLkdO5xLVkQMCxiw4RDJENCUhghejG0WdZUuqhUoCaVz7ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229302; c=relaxed/simple;
	bh=m3iG23jPfN+2jGmxV3hvXNApBsJ6jMco+r+2IfAZuQQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZLEdp2WUeerwlha6QaI2XaCHEb3Jl6ITIGYsK3IIhscsaTlk/5/UqT5o64rO1UF99R0iOvPnZf8inzkJLbD3HfzfyUrms9YbKaw6dFvOCV7kmcafMNvK1IKC+gIyv8e+mpCxlrhWsSMvil6eBtAeUx5PXvQ+vqXu/uiHHU9lXdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKcuXJ8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKcuXJ8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D39C3277B;
	Tue, 16 Apr 2024 01:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229302;
	bh=m3iG23jPfN+2jGmxV3hvXNApBsJ6jMco+r+2IfAZuQQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mKcuXJ8PRI/9R1pN5ikn9DesrhBHbnhaWdUbX9khceyGBXxyrp3Zu6/nLAm77epCq
	 82aDMQGiWaIXyVV6Fk0loEzIhmv2fee7zErAkpMeSTcGFZZPq1Lk2uuV9ZalNrRa45
	 aqwn1Kh5Fp7EZDvx7LkmEQQ6sVvpR8j9LwFpFsBVPHlkNtsFMcgCH9cPQzeGJkQyul
	 nEoxyBnYMgmdmNzGPk1wF7JOVsrk0e3rfJ3TdBkFxWeuu1effBiSrvv8MlX/Ec/Fzs
	 XLMGCT5fdI8axmofzGi/mQal7Ijtlfc499xpUwlBQeZU9k6wQFq+ZSm4kTRzyDd7Sz
	 NijyI6KKpnrJA==
Date: Mon, 15 Apr 2024 18:01:41 -0700
Subject: [PATCH 2/4] libxfs: add a bi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322884124.214718.3562041695530689827.stgit@frogsfrogsfrogs>
In-Reply-To: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
References: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
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
 libxfs/defer_item.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 680a72664746..d19322a0b255 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -439,6 +439,11 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 
 /* Inode Block Mapping */
 
+static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_bmap_intent, bi_list);
+}
+
 /* Sort bmap intents by inode. */
 static int
 xfs_bmap_update_diff_items(
@@ -446,11 +451,9 @@ xfs_bmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_bmap_intent	*ba;
-	const struct xfs_bmap_intent	*bb;
+	struct xfs_bmap_intent		*ba = bi_entry(a);
+	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	ba = container_of(a, struct xfs_bmap_intent, bi_list);
-	bb = container_of(b, struct xfs_bmap_intent, bi_list);
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
@@ -527,10 +530,9 @@ xfs_bmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_bmap_intent		*bi;
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 	int				error;
 
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
 	error = xfs_bmap_finish_one(tp, bi);
 	if (!error && bi->bi_bmap.br_blockcount > 0) {
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
@@ -554,9 +556,7 @@ STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_bmap_intent		*bi;
-
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);

