Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909A6C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357716AbiATATK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345095AbiATATK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39523C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:19:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED595B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B20C004E1;
        Thu, 20 Jan 2022 00:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637947;
        bh=MekQ3l3vBvJxhR8FIuoc1Lfrjl1DgAupiGQOlsOssM8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jmPf4xiZqfzgA3jhArnc0fVtqAs2KdDJN3t7J8lgGhRwaWqPYA6gKgUKaGnT8/N+3
         MR/5cakM5uzOef5No/n9dHFyDY6SLm/QjghzMer6Omys7402Q9lRaJyNIrRigVO36y
         if2SWz52qflkX2JHRSVEIbVGcPP7jS9lHIfTsPE9PEB/EXlinBlLiqIa6bSWhnUd2k
         83wPiVBx70AV8gsz2Z/G1WtRC7fkVP/XEAyaoA8KhL7V4OU0gwSS3DN/+QKm4xNGsG
         wjrfbvV0/nUyr2chwy4XDZPqdsMrHVVvYgLgqJ6stWFPNpB75rPt8Bq+rSaQKMpz/a
         49V1fcwZDtSrg==
Subject: [PATCH 19/45] xfs: constify btree function parameters that are not
 modified
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:07 -0800
Message-ID: <164263794741.860211.3436180486241603079.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 32816fd7920b32c24e1720ce387482fb430959fc

Constify the rest of the btree functions that take structure and union
pointers and are not supposed to modify them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   70 ++++++++++++++++++++++++++--------------------------
 libxfs/xfs_btree.h |   21 +++++++++-------
 2 files changed, 47 insertions(+), 44 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 448f6c0d..1cf3d813 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -222,10 +222,10 @@ xfs_btree_check_sptr(
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
@@ -932,9 +932,9 @@ xfs_btree_readahead(
 
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
@@ -1009,8 +1009,8 @@ xfs_btree_setbuf(
 
 bool
 xfs_btree_ptr_is_null(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return ptr->l == cpu_to_be64(NULLFSBLOCK);
@@ -1056,10 +1056,10 @@ xfs_btree_get_sibling(
 
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
 
@@ -1226,10 +1226,10 @@ xfs_btree_set_refs(
 
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
@@ -1254,11 +1254,11 @@ xfs_btree_get_buf_block(
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
@@ -1286,10 +1286,10 @@ xfs_btree_read_buf_block(
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
@@ -1710,10 +1710,10 @@ xfs_btree_decrement(
 
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
@@ -4887,12 +4887,12 @@ xfs_btree_has_record_helper(
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 830702bd..4eaf8517 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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

