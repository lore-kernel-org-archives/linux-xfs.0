Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74868183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVqw5ING"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D3DC433C8;
	Wed, 13 Dec 2023 22:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702507980;
	bh=/MWzCcBDM6/Nc0iBsfuBwSXge/G8/ECrKutIB+xE8KI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hVqw5INGZRdaE/LcGJ4mWvWdcgYcKHg+OJyT+HdP0izDJDQ36DnacMTPhsAf6BIr4
	 s/PEthUR0dlsGz9e36WEJfV0GKOiebUV9T5dKHKtt0pjXhkUuIf079bXQ68ZzO0Nqg
	 snQTiqj54RaFYLbY3N9xDE4sxoM1aRfWsD1Z+W1m8BvU4Ylk4qQMIdwBTTAYk9O9+i
	 9hA+fGBFH+PGmDydp880pKRST1vP+/kXE+Ti9HeeBELwRv5jJSB2qqCHnnABenFcou
	 9Lh2XOpZmmGwkPzNuJgbI2HnfgwWpQ+3yUJw0gJ1JT+qVs0RLBKtmNpu/NNP907HrZ
	 3AEIqmYfHAE7g==
Date: Wed, 13 Dec 2023 14:53:00 -0800
Subject: [PATCH 5/6] xfs: move btree bulkload record initialization to
 ->get_record implementations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783100.1398986.1858618527900169346.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783010.1398986.18110802036723550055.stgit@frogsfrogsfrogs>
References: <170250783010.1398986.18110802036723550055.stgit@frogsfrogsfrogs>
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

When we're performing a bulk load of a btree, move the code that
actually stores the btree record in the new btree block out of the
generic code and into the individual ->get_record implementations.
This is preparation for being able to store multiple records with a
single indirect call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree_staging.c |   17 +++++++----------
 fs/xfs/libxfs/xfs_btree_staging.h |   15 ++++++++++-----
 2 files changed, 17 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index c8b46ac3923f..cd409a2ee87b 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -440,22 +440,19 @@ STATIC int
 xfs_btree_bload_leaf(
 	struct xfs_btree_cur		*cur,
 	unsigned int			recs_this_block,
-	xfs_btree_bload_get_record_fn	get_record,
+	xfs_btree_bload_get_records_fn	get_records,
 	struct xfs_btree_block		*block,
 	void				*priv)
 {
-	unsigned int			j;
+	unsigned int			j = 1;
 	int				ret;
 
 	/* Fill the leaf block with records. */
-	for (j = 1; j <= recs_this_block; j++) {
-		union xfs_btree_rec	*block_rec;
-
-		ret = get_record(cur, priv);
-		if (ret)
+	while (j <= recs_this_block) {
+		ret = get_records(cur, j, block, recs_this_block - j + 1, priv);
+		if (ret < 0)
 			return ret;
-		block_rec = xfs_btree_rec_addr(cur, j, block);
-		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+		j += ret;
 	}
 
 	return 0;
@@ -798,7 +795,7 @@ xfs_btree_bload(
 		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
 				nr_this_block);
 
-		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_record,
+		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_records,
 				block, priv);
 		if (ret)
 			goto out;
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index 5f638f711246..bd5b3f004823 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -47,7 +47,9 @@ void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
 		int whichfork, const struct xfs_btree_ops *ops);
 
 /* Bulk loading of staged btrees. */
-typedef int (*xfs_btree_bload_get_record_fn)(struct xfs_btree_cur *cur, void *priv);
+typedef int (*xfs_btree_bload_get_records_fn)(struct xfs_btree_cur *cur,
+		unsigned int idx, struct xfs_btree_block *block,
+		unsigned int nr_wanted, void *priv);
 typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *ptr, void *priv);
 typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
@@ -55,11 +57,14 @@ typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
 
 struct xfs_btree_bload {
 	/*
-	 * This function will be called nr_records times to load records into
-	 * the btree.  The function does this by setting the cursor's bc_rec
-	 * field in in-core format.  Records must be returned in sort order.
+	 * This function will be called to load @nr_wanted records into the
+	 * btree.  The implementation does this by setting the cursor's bc_rec
+	 * field in in-core format and using init_rec_from_cur to set the
+	 * records in the btree block.  Records must be returned in sort order.
+	 * The function must return the number of records loaded or the usual
+	 * negative errno.
 	 */
-	xfs_btree_bload_get_record_fn	get_record;
+	xfs_btree_bload_get_records_fn	get_records;
 
 	/*
 	 * This function will be called nr_blocks times to obtain a pointer

