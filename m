Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3119C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D1A6113A
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhIRBat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhIRBat (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B9B860FBF;
        Sat, 18 Sep 2021 01:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928566;
        bh=Ojnq2Ke6G6+ibnwYJkseQ1hCQ0Oh4pLqAJ0daN6wf+s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RKpubasQsWR7WfC2/wZ3Q2WKD2jHOcDJZg4k87SmE+Hmde7GhMaaXW4zmggUNzDTf
         eoTpNU4NtROOsXCCI3yGKpKafzatB8RAvWbq4MjQYlzmwZY/Lhzlh20JDUdREKgQVr
         6cr9nBIw86aFRt3lbbLz9Le1qIhuLHi5a66Vi32sCQSSbISAq26iIqQLcIgvVLI0tS
         qgMWRJ8+Xl0CJ2RrLZTVtChFRDglf8KUv0dhETiF8r2ficQvfUzZOtnqI8Y4W6j5eX
         5TeolOyPTKIXTkGQszJ59y6Dx3+5ETjjspGhQye8TKypQ0/KL5eyBlJ9zLr9MQzvEa
         Bgw9lbpVcrvRw==
Subject: [PATCH 03/14] xfs: dynamically allocate btree scrub context structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:26 -0700
Message-ID: <163192856634.416199.12496831484611764326.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reorganize struct xchk_btree so that we can dynamically size the context
structure to fit the type of btree cursor that we have.  This will
enable us to use memory more efficiently once we start adding very tall
btree types.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |   38 +++++++++++++++++---------------------
 fs/xfs/scrub/btree.h |   16 +++++++++++++---
 2 files changed, 30 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 26dcb4691e31..7b7762ae22e5 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -141,9 +141,10 @@ xchk_btree_rec(
 	trace_xchk_btree_rec(bs->sc, cur, 0);
 
 	/* If this isn't the first record, are they in order? */
-	if (!bs->firstrec && !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
+	if (bs->levels[0].has_lastkey &&
+	    !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
 		xchk_btree_set_corrupt(bs->sc, cur, 0);
-	bs->firstrec = false;
+	bs->levels[0].has_lastkey = true;
 	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
 
 	if (cur->bc_nlevels == 1)
@@ -188,11 +189,11 @@ xchk_btree_key(
 	trace_xchk_btree_key(bs->sc, cur, level);
 
 	/* If this isn't the first key, are they in order? */
-	if (!bs->firstkey[level] &&
-	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
+	if (bs->levels[level].has_lastkey &&
+	    !cur->bc_ops->keys_inorder(cur, &bs->levels[level].lastkey, key))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
-	bs->firstkey[level] = false;
-	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
+	bs->levels[level].has_lastkey = true;
+	memcpy(&bs->levels[level].lastkey, key, cur->bc_ops->key_len);
 
 	if (level + 1 >= cur->bc_nlevels)
 		return;
@@ -632,38 +633,33 @@ xchk_btree(
 	union xfs_btree_ptr		*pp;
 	union xfs_btree_rec		*recp;
 	struct xfs_btree_block		*block;
-	int				level;
 	struct xfs_buf			*bp;
 	struct check_owner		*co;
 	struct check_owner		*n;
-	int				i;
+	size_t				cur_sz;
+	int				level;
 	int				error = 0;
 
 	/*
 	 * Allocate the btree scrub context from the heap, because this
-	 * structure can get rather large.
+	 * structure can get rather large.  Don't let a caller feed us a
+	 * totally absurd size.
 	 */
-	bs = kmem_zalloc(sizeof(struct xchk_btree), KM_NOFS | KM_MAYFAIL);
+	cur_sz = xchk_btree_sizeof(cur->bc_nlevels);
+	if (cur_sz > PAGE_SIZE) {
+		xchk_btree_set_corrupt(sc, cur, 0);
+		return 0;
+	}
+	bs = kmem_zalloc(cur_sz, KM_NOFS | KM_MAYFAIL);
 	if (!bs)
 		return -ENOMEM;
 	bs->cur = cur;
 	bs->scrub_rec = scrub_fn;
 	bs->oinfo = oinfo;
-	bs->firstrec = true;
 	bs->private = private;
 	bs->sc = sc;
-
-	/* Initialize scrub state */
-	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
-		bs->firstkey[i] = true;
 	INIT_LIST_HEAD(&bs->to_check);
 
-	/* Don't try to check a tree with a height we can't handle. */
-	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
-		xchk_btree_set_corrupt(sc, cur, 0);
-		goto out;
-	}
-
 	/*
 	 * Load the root of the btree.  The helper function absorbs
 	 * error codes for us.
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index d5c0b0cbc505..7f8c54d8020e 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -29,6 +29,11 @@ typedef int (*xchk_btree_rec_fn)(
 	struct xchk_btree		*bs,
 	const union xfs_btree_rec	*rec);
 
+struct xchk_btree_levels {
+	union xfs_btree_key		lastkey;
+	bool				has_lastkey;
+};
+
 struct xchk_btree {
 	/* caller-provided scrub state */
 	struct xfs_scrub		*sc;
@@ -39,12 +44,17 @@ struct xchk_btree {
 
 	/* internal scrub state */
 	union xfs_btree_rec		lastrec;
-	bool				firstrec;
-	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
-	bool				firstkey[XFS_BTREE_MAXLEVELS];
 	struct list_head		to_check;
+	struct xchk_btree_levels	levels[];
 };
 
+static inline size_t
+xchk_btree_sizeof(unsigned int levels)
+{
+	return sizeof(struct xchk_btree) +
+				(levels * sizeof(struct xchk_btree_levels));
+}
+
 int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		xchk_btree_rec_fn scrub_fn, const struct xfs_owner_info *oinfo,
 		void *private);

