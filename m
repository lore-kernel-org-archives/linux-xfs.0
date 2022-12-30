Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD76C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiL3XZQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbiL3XY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:24:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C51B1E3ED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58B01B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135E1C433EF;
        Fri, 30 Dec 2022 23:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442621;
        bh=3WffTUoGIjeDPc7Tu6IWu3HeNjuEt6ZNkw0dGzjZFoE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eZPGueg6XlqwayP85KHqPF/2NtBYwP9fqhDkReyszA68yoGQQtxCeQd8Js6RQbgyn
         grErQEMNa1qfzZV+CsOpf9eh5oeRqd7z1MXOKKds6loEQ/hUGopQWZUS2M0Wjqcbkc
         noE50lB8zXfKROKYc6yc79NPtjX4s3HTaPd0drEtLxeEoBCPFHYkugP9twB1B9/EDI
         WElMIiWmVNniLL7SjI4lXEvRL12cYjNC535KHM3XGPQSaMNHK+xl83lFaySfkjIyj7
         n6dfMzyY99TJ9bjndfyUuhzA3WggSKdEllWx3viIMc2jCNdOFglLe3ZkS02+HrWpRx
         Y6ZUV8miopGdA==
Subject: [PATCH 5/6] xfs: move btree bulkload record initialization to
 ->get_record implementations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:31 -0800
Message-ID: <167243835179.692312.7013769737680138785.stgit@magnolia>
In-Reply-To: <167243835101.692312.6690367712200502185.stgit@magnolia>
References: <167243835101.692312.6690367712200502185.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 29e3f8ccb185..369965cacc8c 100644
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
index d6dea3f0088c..82a3a8ef0f12 100644
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

