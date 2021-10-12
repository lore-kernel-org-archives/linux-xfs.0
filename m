Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1A1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CF960EB6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbhJLXe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234169AbhJLXe6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:34:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C9EF60ED4;
        Tue, 12 Oct 2021 23:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081576;
        bh=xIxgn0LFOJwHz4W92pNB2OQeNrfhXlpB/xkQp4rb+7Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ldrxS2nArEdEacA1D0NiABwL6lTWF2v+Cn1S2Mkx9cwuZ04edO1RqNJiVnXTHIg9l
         Ljbx9UhzLMjQOZetAmMvT0AffkNufLS30SFOv1Dz86BRX/vfPJORjiEPc7+T19lUCc
         RSr2tfXQdCf0pRNRZszTfw7iDKRRFeXpAX7rRjxEa8khisADSVr1XPZSTidNKSy2pj
         XTgRac0H72e4P1GrTnsnFv8RcOMVyfciXMHjBB5gtbVoJgJpgZwol/OV2iD66T8v0W
         6LYNSRsFT2fV91f7Yb6OJh6Fik0WNeIUpRVoIQh9u9LBLKutYS7H+c1zN5mvCtPwfF
         Bjj9rqdZAZPdA==
Subject: [PATCH 04/15] xfs: dynamically allocate btree scrub context structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:32:55 -0700
Message-ID: <163408157576.4151249.1044656167414078424.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
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
btree types.  Right-size the lastkey array so that we stop wasting the
first array element.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |   23 ++++++++++++-----------
 fs/xfs/scrub/btree.h |   11 ++++++++++-
 2 files changed, 22 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index d5e1ca521fc4..6d4eba85ef77 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -189,9 +189,9 @@ xchk_btree_key(
 
 	/* If this isn't the first key, are they in order? */
 	if (cur->bc_ptrs[level] > 1 &&
-	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
+	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level - 1], key))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
-	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
+	memcpy(&bs->lastkey[level - 1], key, cur->bc_ops->key_len);
 
 	if (level + 1 >= cur->bc_nlevels)
 		return;
@@ -631,17 +631,24 @@ xchk_btree(
 	union xfs_btree_ptr		*pp;
 	union xfs_btree_rec		*recp;
 	struct xfs_btree_block		*block;
-	int				level;
 	struct xfs_buf			*bp;
 	struct check_owner		*co;
 	struct check_owner		*n;
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
@@ -653,12 +660,6 @@ xchk_btree(
 	/* Initialize scrub state */
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
index 7671108f9f85..62c3091ef20f 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -39,9 +39,18 @@ struct xchk_btree {
 
 	/* internal scrub state */
 	union xfs_btree_rec		lastrec;
-	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
 	struct list_head		to_check;
+
+	/* this element must come last! */
+	union xfs_btree_key		lastkey[];
 };
+
+static inline size_t
+xchk_btree_sizeof(unsigned int nlevels)
+{
+	return struct_size((struct xchk_btree *)NULL, lastkey, nlevels - 1);
+}
+
 int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		xchk_btree_rec_fn scrub_fn, const struct xfs_owner_info *oinfo,
 		void *private);

