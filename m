Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7530C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EFAD61211
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhIXB14 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243749AbhIXB1z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:27:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56EDE60D42;
        Fri, 24 Sep 2021 01:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446783;
        bh=wSd7Bbu6OZDOCo1tgQqh7XWTxvD86GvInu7P6EJYv9I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RRNkoaZcGcquvC10CDRkT02PmQryBpOp2DyVnZfhK5+ZSDxaC3FbogNxheIbT0G4/
         VKYyHZuCt+4nIWq69VXcY2QIuJWFRLFBV5zzs7L96dVoie8l001tFBb0k7KvS/fwp+
         0ihc1BAtvUag1q2v3ry2m762HAeAZAQcZBnaw9+ExBPG2/v1385zPvXHIYVhcLFbMM
         HoU5hEDRKYH3nQkeXjb3mSKK/7a8JWFeDraOpI8c04kT7X3GG5nEQFm1A92Nnfx41N
         3guZk254YEP3DMk/HJpXsa7yz6ICvxGBrfKh0sw+DTfLt1ngANsR1lKJZwXtsIIJ8L
         7WadOTrrAfJRQ==
Subject: [PATCH 02/15] xfs: remove xfs_btree_cur_t typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:26:23 -0700
Message-ID: <163244678304.2701302.16833273677179625688.stgit@magnolia>
In-Reply-To: <163244677169.2701302.12882919857957905332.stgit@magnolia>
References: <163244677169.2701302.12882919857957905332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Get rid of this old typedef before we start changing other things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

