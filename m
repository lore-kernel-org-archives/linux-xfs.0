Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA21A3DB85
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqbY71lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B682C433C8;
	Fri, 24 Nov 2023 23:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869771;
	bh=4sKTkP+YNq5eOURvDatsZRtR0+/T81bjeEfvrGKbisQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SqbY71lJAnirR/y0R4L+y3BRbYA5sagaaiy8PiKRVat+D4P8YlwdVrSiEMwXwjaPj
	 E+zy6MpYauNJSTICVehFW4rbNIwC4/nZ08caLggq/XSpTP9nS/F4xZx13LIg5CawxT
	 xZ0LDHXJKqsprWS7wag/d6H13OoUz4zexB9gmpmGa/AlLFae5ZPkVkbcSzMvtTA9SD
	 wS/8fPoXTNop5h7EDjQtsrd25nk0bW1JK8BeZZPjWYOIp0KYt20qwbUp7KlTL+htOp
	 o+msq7yysJnBUXYk0Lwh6OFFf8KzSbCKXXzvHlxGFXM+zZbbutakX/ZpYVHxhEtYv0
	 4G8o2/mJAax1A==
Date: Fri, 24 Nov 2023 15:49:30 -0800
Subject: [PATCH 3/4] xfs: move btree bulkload record initialization to
 ->get_record implementations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086926625.2770816.4294476046504213562.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_btree_staging.c |   17 +++++++----------
 fs/xfs/libxfs/xfs_btree_staging.h |   15 ++++++++++-----
 2 files changed, 17 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 29e3f8ccb1852..369965cacc8c5 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -434,22 +434,19 @@ STATIC int
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
@@ -787,7 +784,7 @@ xfs_btree_bload(
 		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
 				nr_this_block);
 
-		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_record,
+		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_records,
 				block, priv);
 		if (ret)
 			goto out;
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index d6dea3f0088c6..82a3a8ef0f125 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -50,7 +50,9 @@ void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
 		int whichfork, const struct xfs_btree_ops *ops);
 
 /* Bulk loading of staged btrees. */
-typedef int (*xfs_btree_bload_get_record_fn)(struct xfs_btree_cur *cur, void *priv);
+typedef int (*xfs_btree_bload_get_records_fn)(struct xfs_btree_cur *cur,
+		unsigned int idx, struct xfs_btree_block *block,
+		unsigned int nr_wanted, void *priv);
 typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *ptr, void *priv);
 typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
@@ -58,11 +60,14 @@ typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
 
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

