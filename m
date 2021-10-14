Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17839C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3F5A61019
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhJNUT2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhJNUT2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C354661027;
        Thu, 14 Oct 2021 20:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242642;
        bh=NJBOqEgduRbYcHTL6jNX3Tx05FEzBJTMRjpbH+6Nx60=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=scdjg2MHu3W8gaGSJWUbgx781O2nF0uymsRLO2Q00sJi7s+LONZid7lz29zbifTFq
         YvJkBlKet0qcjeOb1w0UBezAxfzXVOJQ//i9TXblahdMdTRl9vp08Y9W9FeNGyZYCZ
         0v4Di5SMlTcbaqAqKEFr0gw3AUCSQpnvc18iZpUp9oxnWg3r9HdhGa1uSRf1u4kGm6
         suFqLg6VVWmw6HLxKS/uh+vuHQXxR0eugjxnDmXLYg68F42QKItY5WQ1DMKrsblmKU
         xWNiPkMnflpmL68Wau2Fm1TW57UIW7l9mPWd+nuKvpQc42KIm668HsfRvhsis2nUx/
         sdHF/gOJmD1Hw==
Subject: [PATCH 05/17] xfs: dynamically allocate btree scrub context structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:22 -0700
Message-ID: <163424264249.756780.1871555838190156050.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
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
btree types.  Right-size the lastkey array to match the number of *node*
levels in the tree so that we stop wasting space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |   23 ++++++++++++-----------
 fs/xfs/scrub/btree.h |   15 ++++++++++++++-
 2 files changed, 26 insertions(+), 12 deletions(-)


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
index 7671108f9f85..da61a53a0b61 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -39,9 +39,22 @@ struct xchk_btree {
 
 	/* internal scrub state */
 	union xfs_btree_rec		lastrec;
-	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
 	struct list_head		to_check;
+
+	/* this element must come last! */
+	union xfs_btree_key		lastkey[];
 };
+
+/*
+ * Calculate the size of a xchk_btree structure.  There are nlevels-1 slots for
+ * keys because we track leaf records separately in lastrec.
+ */
+static inline size_t
+xchk_btree_sizeof(unsigned int nlevels)
+{
+	return struct_size((struct xchk_btree *)NULL, lastkey, nlevels - 1);
+}
+
 int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		xchk_btree_rec_fn scrub_fn, const struct xfs_owner_info *oinfo,
 		void *private);

