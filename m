Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF54BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF8A861108
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhINCmz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236205AbhINCmz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 933D9610D1;
        Tue, 14 Sep 2021 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587298;
        bh=PaUMx2sjrZfxt+NE1vXH1nIfbT/9eOniQEOhn1MQyok=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BCIDnXvJiPmks3hNUPLo0+GC6n4a8CEAxjGZ29JLN887Q92S0BRY4XrlUDRXxwTr9
         bmKo78bYNpj3fG9yaiXt3vefHnDqT/YeHT5y3XMtOSSbr7kqNIvBre0nzNLN/apAYb
         rt6np7s0fYplg2G0Uvow1e3QMi3/LZrI9CAuDqXi0juK0M0VLOief1/X0ZzVQVJfzu
         NOn4GrFWEY3DzNzNHsh2P0X8cCfgbGtsCdVWDW/6/10qyn8UVAIe46rHwiE/hSJVMp
         tvJAXwnYyNvqlQSDcIBDVYmbjnZUezF/2UM50s4f+Xzv4OdSdx1afelsdZez+W2U7t
         Sj+V4LZj9VRbg==
Subject: [PATCH 18/43] xfs: constify btree function parameters that are not
 modified
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:38 -0700
Message-ID: <163158729834.1604118.5825865157562723641.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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
index fa3ba314..be4b8fa3 100644
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

