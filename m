Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AE8C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80CFE60FBF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhIRBak (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhIRBai (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:30:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A561A60FBF;
        Sat, 18 Sep 2021 01:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928555;
        bh=DDnPziIv420IU1gibdQ/HA731K4LAOfAh/vbaoZD50M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EYq5TH89PYK7dltUdgOB/7j7KlHyoyIdp2F2afKmmd1cM9yYJAtxWCXvFnmkYS7Ow
         ZL5FrW1ziJyGvWYRgGACob7rARklBHPwpwlweAHXhUI0Knl0Ne/tX3J/Hi+qYj6JJz
         JnL6UMmMxRyDL7btznUHMnnMM2CSxDl/PbAA5APyQ7HXueA3jSvd4gr1yeiWAARvZ0
         LUaQQJFRvSeErfNmi+/jBm66Oul3k/fFIbMHGYSVp3CUqyL3Soj1yND0vXo9Yb47li
         OlBniBpK6uyYo4L+nAh7Db1K3sG91Y1Mib+Bu84I1+bUO2448FEDxZ264vcvI9GpYs
         nsIN45y3jdl1w==
Subject: [PATCH 01/14] xfs: remove xfs_btree_cur_t typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:15 -0700
Message-ID: <163192855540.416199.17796390757325316141.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   12 ++++++------
 fs/xfs/libxfs/xfs_bmap.c  |   12 ++++++------
 fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
 fs/xfs/libxfs/xfs_btree.h |   12 ++++++------
 4 files changed, 24 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 95157f5a5a6c..35fb1dd3be95 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -426,8 +426,8 @@ xfs_alloc_fix_len(
  */
 STATIC int				/* error code */
 xfs_alloc_fixup_trees(
-	xfs_btree_cur_t	*cnt_cur,	/* cursor for by-size btree */
-	xfs_btree_cur_t	*bno_cur,	/* cursor for by-block btree */
+	struct xfs_btree_cur *cnt_cur,	/* cursor for by-size btree */
+	struct xfs_btree_cur *bno_cur,	/* cursor for by-block btree */
 	xfs_agblock_t	fbno,		/* starting block of free extent */
 	xfs_extlen_t	flen,		/* length of free extent */
 	xfs_agblock_t	rbno,		/* starting block of returned extent */
@@ -1200,8 +1200,8 @@ xfs_alloc_ag_vextent_exact(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
 	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
-	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
-	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
+	struct xfs_btree_cur *bno_cur;/* by block-number btree cursor */
+	struct xfs_btree_cur *cnt_cur;/* by count btree cursor */
 	int		error;
 	xfs_agblock_t	fbno;	/* start block of found extent */
 	xfs_extlen_t	flen;	/* length of found extent */
@@ -1658,8 +1658,8 @@ xfs_alloc_ag_vextent_size(
 	xfs_alloc_arg_t	*args)		/* allocation argument structure */
 {
 	struct xfs_agf	*agf = args->agbp->b_addr;
-	xfs_btree_cur_t	*bno_cur;	/* cursor for bno btree */
-	xfs_btree_cur_t	*cnt_cur;	/* cursor for cnt btree */
+	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
+	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
 	int		error;		/* error result */
 	xfs_agblock_t	fbno;		/* start of found freespace */
 	xfs_extlen_t	flen;		/* length of found freespace */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b48230f1a361..499c977cbf56 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -316,7 +316,7 @@ xfs_check_block(
  */
 STATIC void
 xfs_bmap_check_leaf_extents(
-	xfs_btree_cur_t		*cur,	/* btree cursor or null */
+	struct xfs_btree_cur	*cur,	/* btree cursor or null */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	int			whichfork)	/* data or attr fork */
 {
@@ -925,7 +925,7 @@ xfs_bmap_add_attrfork_btree(
 	int			*flags)		/* inode logging flags */
 {
 	struct xfs_btree_block	*block = ip->i_df.if_broot;
-	xfs_btree_cur_t		*cur;		/* btree cursor */
+	struct xfs_btree_cur	*cur;		/* btree cursor */
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* file system mount struct */
 	int			stat;		/* newroot status */
@@ -968,7 +968,7 @@ xfs_bmap_add_attrfork_extents(
 	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			*flags)		/* inode logging flags */
 {
-	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
+	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
 	int			error;		/* error return value */
 
 	if (ip->i_df.if_nextents * sizeof(struct xfs_bmbt_rec) <=
@@ -1988,11 +1988,11 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	int			whichfork,
 	struct xfs_iext_cursor	*icur,
-	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
+	struct xfs_btree_cur	**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	int			*logflagsp) /* inode logging flags */
 {
-	xfs_btree_cur_t		*cur;	/* btree cursor */
+	struct xfs_btree_cur	*cur;	/* btree cursor */
 	int			error;	/* error return value */
 	int			i;	/* temp state */
 	struct xfs_ifork	*ifp;	/* inode fork pointer */
@@ -5045,7 +5045,7 @@ xfs_bmap_del_extent_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
 	struct xfs_iext_cursor	*icur,
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
+	struct xfs_btree_cur	*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
 	int			whichfork, /* data or attr fork */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 298395481713..b0cce0932f02 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -388,14 +388,14 @@ xfs_btree_del_cursor(
  */
 int					/* error */
 xfs_btree_dup_cursor(
-	xfs_btree_cur_t	*cur,		/* input cursor */
-	xfs_btree_cur_t	**ncur)		/* output cursor */
+	struct xfs_btree_cur *cur,		/* input cursor */
+	struct xfs_btree_cur **ncur)		/* output cursor */
 {
 	struct xfs_buf	*bp;		/* btree block's buffer pointer */
 	int		error;		/* error return value */
 	int		i;		/* level number of btree block */
 	xfs_mount_t	*mp;		/* mount structure for filesystem */
-	xfs_btree_cur_t	*new;		/* new cursor value */
+	struct xfs_btree_cur *new;		/* new cursor value */
 	xfs_trans_t	*tp;		/* transaction pointer, can be NULL */
 
 	tp = cur->bc_tp;
@@ -691,7 +691,7 @@ xfs_btree_get_block(
  */
 STATIC int				/* success=1, failure=0 */
 xfs_btree_firstrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
@@ -721,7 +721,7 @@ xfs_btree_firstrec(
  */
 STATIC int				/* success=1, failure=0 */
 xfs_btree_lastrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
@@ -985,7 +985,7 @@ xfs_btree_readahead_ptr(
  */
 STATIC void
 xfs_btree_setbuf(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
 	struct xfs_buf		*bp)	/* new buffer to set */
 {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4eaf8517f850..513ade4a89f8 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -216,7 +216,7 @@ struct xfs_btree_cur_ino {
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
  */
-typedef struct xfs_btree_cur
+struct xfs_btree_cur
 {
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
@@ -243,7 +243,7 @@ typedef struct xfs_btree_cur
 		struct xfs_btree_cur_ag	bc_ag;
 		struct xfs_btree_cur_ino bc_ino;
 	};
-} xfs_btree_cur_t;
+};
 
 /* cursor flags */
 #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
@@ -309,7 +309,7 @@ xfs_btree_check_sptr(
  */
 void
 xfs_btree_del_cursor(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			error);	/* del because of error */
 
 /*
@@ -318,8 +318,8 @@ xfs_btree_del_cursor(
  */
 int					/* error */
 xfs_btree_dup_cursor(
-	xfs_btree_cur_t		*cur,	/* input cursor */
-	xfs_btree_cur_t		**ncur);/* output cursor */
+	struct xfs_btree_cur		*cur,	/* input cursor */
+	struct xfs_btree_cur		**ncur);/* output cursor */
 
 /*
  * Compute first and last byte offsets for the fields given.
@@ -527,7 +527,7 @@ struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 /* Does this cursor point to the last block in the given level? */
 static inline bool
 xfs_btree_islastblock(
-	xfs_btree_cur_t		*cur,
+	struct xfs_btree_cur	*cur,
 	int			level)
 {
 	struct xfs_btree_block	*block;

