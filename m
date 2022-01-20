Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC354C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbiATAXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47660 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbiATAXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE90EB81A7D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912F8C004E1;
        Thu, 20 Jan 2022 00:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638214;
        bh=1VJL6Qt9tdetVFKgZavDhxVHk8y9F1zS2tKAe3tIoaM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XDn1vmW0ODX8Fc1Y3309mnh6Jjb7Q2Fa7gLhxZ3Bufj12JS9QoTRLvDLWthISiJXT
         FaqWYXzC98Ue+U1Q1xrdTY5A7bgpAHX0V3zX98C2xhPandtpYPwihW4R/bZyfemrRB
         at5bdWI4kdKp0voiYIB9F0CCYyBwGzyAHTYmIwGqQ7xGqgRYdk1AOlZ8QeFps4/j7h
         wqrEMLfOWx1lz+iCL76yZGKNrqoau9vDo8a/fINLWHgrhhsfwh0Bs4Y3eIpCzEkU5l
         uscfm7yWWZ24KyJENN0Y4vWZ6HPIzwxIUARDG2K27seKNtVQ8mtvWuPRpXYjhTnFEf
         RODhd8RzXd61Q==
Subject: [PATCH 04/48] xfs: remove xfs_btree_cur_t typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:34 -0800
Message-ID: <164263821427.865554.9319767410440989753.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ae127f087dc22b6e37edc870079abf0721a6aed0

Get rid of this old typedef before we start changing other things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |   12 ++++++------
 libxfs/xfs_bmap.c  |   12 ++++++------
 libxfs/xfs_btree.c |   12 ++++++------
 libxfs/xfs_btree.h |   12 ++++++------
 4 files changed, 24 insertions(+), 24 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index c60aeb63..fe050d8e 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -422,8 +422,8 @@ xfs_alloc_fix_len(
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
@@ -1196,8 +1196,8 @@ xfs_alloc_ag_vextent_exact(
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
@@ -1654,8 +1654,8 @@ xfs_alloc_ag_vextent_size(
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
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d5ccce1f..371aedc2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -309,7 +309,7 @@ xfs_check_block(
  */
 STATIC void
 xfs_bmap_check_leaf_extents(
-	xfs_btree_cur_t		*cur,	/* btree cursor or null */
+	struct xfs_btree_cur	*cur,	/* btree cursor or null */
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	int			whichfork)	/* data or attr fork */
 {
@@ -918,7 +918,7 @@ xfs_bmap_add_attrfork_btree(
 	int			*flags)		/* inode logging flags */
 {
 	struct xfs_btree_block	*block = ip->i_df.if_broot;
-	xfs_btree_cur_t		*cur;		/* btree cursor */
+	struct xfs_btree_cur	*cur;		/* btree cursor */
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* file system mount struct */
 	int			stat;		/* newroot status */
@@ -961,7 +961,7 @@ xfs_bmap_add_attrfork_extents(
 	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			*flags)		/* inode logging flags */
 {
-	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
+	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
 	int			error;		/* error return value */
 
 	if (ip->i_df.if_nextents * sizeof(struct xfs_bmbt_rec) <=
@@ -1981,11 +1981,11 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -5038,7 +5038,7 @@ xfs_bmap_del_extent_real(
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_trans_t		*tp,	/* current transaction pointer */
 	struct xfs_iext_cursor	*icur,
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
+	struct xfs_btree_cur	*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
 	int			whichfork, /* data or attr fork */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3d9d0dcc..7097abde 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -385,14 +385,14 @@ xfs_btree_del_cursor(
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
@@ -688,7 +688,7 @@ xfs_btree_get_block(
  */
 STATIC int				/* success=1, failure=0 */
 xfs_btree_firstrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
@@ -718,7 +718,7 @@ xfs_btree_firstrec(
  */
 STATIC int				/* success=1, failure=0 */
 xfs_btree_lastrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
@@ -982,7 +982,7 @@ xfs_btree_readahead_ptr(
  */
 STATIC void
 xfs_btree_setbuf(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
 	struct xfs_buf		*bp)	/* new buffer to set */
 {
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 4eaf8517..513ade4a 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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

