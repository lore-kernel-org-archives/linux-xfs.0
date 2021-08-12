Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09838C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD8460C3E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhHLXcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237906AbhHLXco (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D230A60C3E;
        Thu, 12 Aug 2021 23:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811138;
        bh=PCk0mtdnCFrnDRg1ZNbr1QhIl88ZcTddDKbJTpmfBHQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rrwzeS/LpSbyfHJGrGYqNfn43gcci7i455Xnkq3FUVeW6Kbldx0tps+8+K9nbPEPQ
         XHbXBVUPCNP2GME+jqbXBJPza29ja/m4+w4QpSgCqIpzlgaGSnX01bNnDMl0DpYoum
         JUrYwmH7Ql7UEEiP53pvDbB766SREWVRAFZMQQ9ZLnShQgMb5rwdJhshAJ0ztcjxSR
         kSPXvlciaJfsWwKO7+wf72qoG2125b2n4lCyrwGFOB2iMbvh6SuZoL27g3Oquuh1xa
         3RoPX/9hBNcoLvA92vCw5xizNKGeki/LVybSw8g7PEZ+l0auXvFnssfsgqPkuDESvN
         +ILI2dOnhU9+w==
Subject: [PATCH 10/10] xfs: constify btree function parameters that are not
 modified
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:32:18 -0700
Message-ID: <162881113855.1695493.8066313723197135778.stgit@magnolia>
In-Reply-To: <162881108307.1695493.3416792932772498160.stgit@magnolia>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Constify the rest of the btree functions that take structure and union
pointers and are not supposed to modify them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   70 +++++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_btree.h |   21 ++++++++------
 2 files changed, 47 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bc15d90ff7a2..758f3dc9c1ff 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -225,10 +225,10 @@ xfs_btree_check_sptr(
  */
 static int
 xfs_btree_check_ptr(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	int			index,
-	int			level)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				index,
+	int				level)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
@@ -935,9 +935,9 @@ xfs_btree_readahead(
 
 STATIC int
 xfs_btree_ptr_to_daddr(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	xfs_daddr_t		*daddr)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	xfs_daddr_t			*daddr)
 {
 	xfs_fsblock_t		fsbno;
 	xfs_agblock_t		agbno;
@@ -1012,8 +1012,8 @@ xfs_btree_setbuf(
 
 bool
 xfs_btree_ptr_is_null(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return ptr->l == cpu_to_be64(NULLFSBLOCK);
@@ -1059,10 +1059,10 @@ xfs_btree_get_sibling(
 
 void
 xfs_btree_set_sibling(
-	struct xfs_btree_cur	*cur,
-	struct xfs_btree_block	*block,
-	union xfs_btree_ptr	*ptr,
-	int			lr)
+	struct xfs_btree_cur		*cur,
+	struct xfs_btree_block		*block,
+	const union xfs_btree_ptr	*ptr,
+	int				lr)
 {
 	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
 
@@ -1229,10 +1229,10 @@ xfs_btree_set_refs(
 
 int
 xfs_btree_get_buf_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	struct xfs_btree_block	**block,
-	struct xfs_buf		**bpp)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	struct xfs_btree_block		**block,
+	struct xfs_buf			**bpp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_daddr_t		d;
@@ -1257,11 +1257,11 @@ xfs_btree_get_buf_block(
  */
 STATIC int
 xfs_btree_read_buf_block(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr,
-	int			flags,
-	struct xfs_btree_block	**block,
-	struct xfs_buf		**bpp)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				flags,
+	struct xfs_btree_block		**block,
+	struct xfs_buf			**bpp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_daddr_t		d;
@@ -1289,10 +1289,10 @@ xfs_btree_read_buf_block(
  */
 void
 xfs_btree_copy_keys(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_key	*dst_key,
-	union xfs_btree_key	*src_key,
-	int			numkeys)
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_key		*dst_key,
+	const union xfs_btree_key	*src_key,
+	int				numkeys)
 {
 	ASSERT(numkeys >= 0);
 	memcpy(dst_key, src_key, numkeys * cur->bc_ops->key_len);
@@ -1713,10 +1713,10 @@ xfs_btree_decrement(
 
 int
 xfs_btree_lookup_get_block(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	int			level,	/* level in the btree */
-	union xfs_btree_ptr	*pp,	/* ptr to btree block */
-	struct xfs_btree_block	**blkp) /* return btree block */
+	struct xfs_btree_cur		*cur,	/* btree cursor */
+	int				level,	/* level in the btree */
+	const union xfs_btree_ptr	*pp,	/* ptr to btree block */
+	struct xfs_btree_block		**blkp) /* return btree block */
 {
 	struct xfs_buf		*bp;	/* buffer pointer for btree block */
 	xfs_daddr_t		daddr;
@@ -4886,12 +4886,12 @@ xfs_btree_has_record_helper(
 /* Is there a record covering a given range of keys? */
 int
 xfs_btree_has_record(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_irec	*low,
-	union xfs_btree_irec	*high,
-	bool			*exists)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_irec	*low,
+	const union xfs_btree_irec	*high,
+	bool				*exists)
 {
-	int			error;
+	int				error;
 
 	error = xfs_btree_query_range(cur, low, high,
 			&xfs_btree_has_record_helper, NULL);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 830702bdd6d6..4eaf8517f850 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -503,10 +503,11 @@ union xfs_btree_key *xfs_btree_high_key_addr(struct xfs_btree_cur *cur, int n,
 union xfs_btree_ptr *xfs_btree_ptr_addr(struct xfs_btree_cur *cur, int n,
 		struct xfs_btree_block *block);
 int xfs_btree_lookup_get_block(struct xfs_btree_cur *cur, int level,
-		union xfs_btree_ptr *pp, struct xfs_btree_block **blkp);
+		const union xfs_btree_ptr *pp, struct xfs_btree_block **blkp);
 struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
 		int level, struct xfs_buf **bpp);
-bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur, union xfs_btree_ptr *ptr);
+bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr);
 int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
 				const union xfs_btree_ptr *a,
 				const union xfs_btree_ptr *b);
@@ -517,8 +518,9 @@ void xfs_btree_get_keys(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, union xfs_btree_key *key);
 union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 		union xfs_btree_key *key);
-int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
-		union xfs_btree_irec *high, bool *exists);
+int xfs_btree_has_record(struct xfs_btree_cur *cur,
+		const union xfs_btree_irec *low,
+		const union xfs_btree_irec *high, bool *exists);
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
 struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 
@@ -541,10 +543,11 @@ xfs_btree_islastblock(
 
 void xfs_btree_set_ptr_null(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *ptr);
-int xfs_btree_get_buf_block(struct xfs_btree_cur *cur, union xfs_btree_ptr *ptr,
-		struct xfs_btree_block **block, struct xfs_buf **bpp);
+int xfs_btree_get_buf_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, struct xfs_btree_block **block,
+		struct xfs_buf **bpp);
 void xfs_btree_set_sibling(struct xfs_btree_cur *cur,
-		struct xfs_btree_block *block, union xfs_btree_ptr *ptr,
+		struct xfs_btree_block *block, const union xfs_btree_ptr *ptr,
 		int lr);
 void xfs_btree_init_block_cur(struct xfs_btree_cur *cur,
 		struct xfs_buf *bp, int level, int numrecs);
@@ -552,7 +555,7 @@ void xfs_btree_copy_ptrs(struct xfs_btree_cur *cur,
 		union xfs_btree_ptr *dst_ptr,
 		const union xfs_btree_ptr *src_ptr, int numptrs);
 void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
-		union xfs_btree_key *dst_key, union xfs_btree_key *src_key,
-		int numkeys);
+		union xfs_btree_key *dst_key,
+		const union xfs_btree_key *src_key, int numkeys);
 
 #endif	/* __XFS_BTREE_H__ */

