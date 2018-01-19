Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753841AbeASOJE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jan 2018 09:09:04 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6F845F174
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:04 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC1875D6B7
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2018 14:09:03 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/4] Get rid of xfs_buf_t typedef
Date: Fri, 19 Jan 2018 15:08:45 +0100
Message-Id: <20180119140847.22934-3-cmaiolino@redhat.com>
In-Reply-To: <20180119140847.22934-1-cmaiolino@redhat.com>
References: <20180119140847.22934-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Took advantage from my rework on bp->b_fspriv to get rid of the
xfs_buf_t typedef.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c     |  32 +++++-----
 fs/xfs/libxfs/xfs_bmap.c      |   8 +--
 fs/xfs/libxfs/xfs_btree.c     |  22 +++----
 fs/xfs/libxfs/xfs_btree.h     |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c    |  16 ++---
 fs/xfs/libxfs/xfs_inode_buf.c |   4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c  |  22 +++----
 fs/xfs/xfs_buf.c              | 139 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf.h              |  18 +++---
 fs/xfs/xfs_buf_item.c         |   8 +--
 fs/xfs/xfs_dquot.c            |  22 +++----
 fs/xfs/xfs_fsops.c            |   2 +-
 fs/xfs/xfs_inode.c            |  16 ++---
 fs/xfs/xfs_itable.c           |   2 +-
 fs/xfs/xfs_log.c              |  17 +++---
 fs/xfs/xfs_log_recover.c      |  40 ++++++------
 fs/xfs/xfs_qm.c               |   8 +--
 fs/xfs/xfs_rtalloc.c          |  20 +++---
 fs/xfs/xfs_rtalloc.h          |   4 +-
 fs/xfs/xfs_symlink.c          |  22 +++----
 fs/xfs/xfs_trans.c            |   2 +-
 fs/xfs/xfs_trans.h            |   2 +-
 fs/xfs/xfs_trans_buf.c        |  22 +++----
 23 files changed, 225 insertions(+), 225 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 50ba989481cc..b41999fcbbe0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -590,7 +590,7 @@ static void
 xfs_agfl_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	xfs_failaddr_t		fa;
 
@@ -625,9 +625,9 @@ xfs_alloc_read_agfl(
 	xfs_mount_t	*mp,		/* mount point structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* buffer for the ag free block array */
+	struct xfs_buf	**bpp)		/* buffer for the ag free block array */
 {
-	xfs_buf_t	*bp;		/* return value */
+	struct xfs_buf	*bp;		/* return value */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
@@ -1594,7 +1594,7 @@ xfs_alloc_ag_vextent_small(
 			      xfs_alloc_allow_busy_reuse(args->datatype));
 
 			if (xfs_alloc_is_userdata(args->datatype)) {
-				xfs_buf_t	*bp;
+				struct xfs_buf	*bp;
 
 				bp = xfs_btree_get_bufs(args->mp, args->tp,
 					args->agno, fbno, 0);
@@ -1670,7 +1670,7 @@ xfs_alloc_ag_vextent_small(
 STATIC int
 xfs_free_ag_extent(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*agbp,
+	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
@@ -2229,12 +2229,12 @@ xfs_alloc_fix_freelist(
 int				/* error */
 xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
+	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
 	int		btreeblk) /* destination is a AGF btree */
 {
 	xfs_agf_t	*agf;	/* a.g. freespace structure */
-	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
+	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	__be32		*agfl_bno;
 	int		error;
@@ -2294,7 +2294,7 @@ xfs_alloc_get_freelist(
 void
 xfs_alloc_log_agf(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*bp,	/* buffer for a.g. freelist header */
+	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	int		fields)	/* mask of fields to be logged (XFS_AGF_...) */
 {
 	int	first;		/* first byte offset */
@@ -2340,7 +2340,7 @@ xfs_alloc_pagf_init(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	int			flags)	/* XFS_ALLOC_FLAGS_... */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 
 	if ((error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp)))
@@ -2356,8 +2356,8 @@ xfs_alloc_pagf_init(
 int					/* error */
 xfs_alloc_put_freelist(
 	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
-	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
+	struct xfs_buf		*agbp,	/* buffer for a.g. freelist header */
+	struct xfs_buf		*agflbp,/* buffer for a.g. free block array */
 	xfs_agblock_t		bno,	/* block being freed */
 	int			btreeblk) /* block came from a AGF btree */
 {
@@ -2468,10 +2468,10 @@ xfs_agf_verify(
 
 static void
 xfs_agf_read_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	xfs_failaddr_t	fa;
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
@@ -2485,9 +2485,9 @@ xfs_agf_read_verify(
 
 static void
 xfs_agf_write_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 140744700b07..651eb4639713 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -334,7 +334,7 @@ xfs_bmap_check_leaf_extents(
 {
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_buf_t		*bp;	/* buffer for "block" */
+	struct xfs_buf		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
 	xfs_extnum_t		i=0, j;	/* index into the extents list */
 	xfs_ifork_t		*ifp;	/* fork structure */
@@ -600,7 +600,7 @@ xfs_bmap_btree_to_extents(
 	/* REFERENCED */
 	struct xfs_btree_block	*cblock;/* child btree block */
 	xfs_fsblock_t		cbno;	/* child block number */
-	xfs_buf_t		*cbp;	/* child block's buffer */
+	struct xfs_buf		*cbp;	/* child block's buffer */
 	int			error;	/* error return value */
 	xfs_ifork_t		*ifp;	/* inode fork data */
 	xfs_mount_t		*mp;	/* mount point structure */
@@ -662,7 +662,7 @@ xfs_bmap_extents_to_btree(
 	int			whichfork)	/* data or attr fork */
 {
 	struct xfs_btree_block	*ablock;	/* allocated (child) bt block */
-	xfs_buf_t		*abp;		/* buffer for ablock */
+	struct xfs_buf		*abp;		/* buffer for ablock */
 	xfs_alloc_arg_t		args;		/* allocation arguments */
 	xfs_bmbt_rec_t		*arp;		/* child record pointer */
 	struct xfs_btree_block	*block;		/* btree root block */
@@ -829,7 +829,7 @@ xfs_bmap_local_to_extents(
 	int		flags;		/* logging flags returned */
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 	xfs_alloc_arg_t	args;		/* allocation arguments */
-	xfs_buf_t	*bp;		/* buffer for extent block */
+	struct xfs_buf	*bp;		/* buffer for extent block */
 	struct xfs_bmbt_irec rec;
 	struct xfs_iext_cursor icur;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2b2be1d6c00d..cc501b7d1fc5 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -398,7 +398,7 @@ xfs_btree_dup_cursor(
 	xfs_btree_cur_t	*cur,		/* input cursor */
 	xfs_btree_cur_t	**ncur)		/* output cursor */
 {
-	xfs_buf_t	*bp;		/* btree block's buffer pointer */
+	struct xfs_buf	*bp;		/* btree block's buffer pointer */
 	int		error;		/* error return value */
 	int		i;		/* level number of btree block */
 	xfs_mount_t	*mp;		/* mount structure for filesystem */
@@ -686,14 +686,14 @@ xfs_btree_get_block(
  * Get a buffer for the block, return it with no data read.
  * Long-form addressing.
  */
-xfs_buf_t *				/* buffer for fsbno */
+struct xfs_buf *			/* buffer for fsbno */
 xfs_btree_get_bufl(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_fsblock_t	fsbno,		/* file system block number */
 	uint		lock)		/* lock flags for get_buf */
 {
-	xfs_daddr_t		d;		/* real disk block address */
+	xfs_daddr_t	d;		/* real disk block address */
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
@@ -704,7 +704,7 @@ xfs_btree_get_bufl(
  * Get a buffer for the block, return it with no data read.
  * Short-form addressing.
  */
-xfs_buf_t *				/* buffer for agno/agbno */
+struct xfs_buf *			/* buffer for agno/agbno */
 xfs_btree_get_bufs(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
@@ -712,7 +712,7 @@ xfs_btree_get_bufs(
 	xfs_agblock_t	agbno,		/* allocation group block number */
 	uint		lock)		/* lock flags for get_buf */
 {
-	xfs_daddr_t		d;		/* real disk block address */
+	xfs_daddr_t	d;		/* real disk block address */
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
@@ -729,7 +729,7 @@ xfs_btree_islastblock(
 	int			level)	/* level to check */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	block = xfs_btree_get_block(cur, level, &bp);
 	xfs_btree_check_block(cur, block, level, bp);
@@ -749,7 +749,7 @@ xfs_btree_firstrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -779,7 +779,7 @@ xfs_btree_lastrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -1031,7 +1031,7 @@ STATIC void
 xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
-	xfs_buf_t		*bp)	/* new buffer to set */
+	struct xfs_buf		*bp)	/* new buffer to set */
 {
 	struct xfs_btree_block	*b;	/* btree block */
 
@@ -1696,7 +1696,7 @@ xfs_btree_decrement(
 	int			*stat)		/* success/failure */
 {
 	struct xfs_btree_block	*block;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;		/* error return value */
 	int			lev;
 	union xfs_btree_ptr	ptr;
@@ -3230,7 +3230,7 @@ xfs_btree_make_block_unfull(
 
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 1) {
-	    	struct xfs_inode *ip = cur->bc_private.b.ip;
+		struct xfs_inode *ip = cur->bc_private.b.ip;
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 2f13b8676f41..31df5935d6ab 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -478,7 +478,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
  * over to the generic tracing functionality, which is some effort.
  *
  * i,j = integer (32 bit)
- * b = btree block buffer (xfs_buf_t)
+ * b = btree block buffer (struct xfs_buf)
  * p = btree ptr
  * r = btree record
  * k = btree key
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c01ed9cfc5ae..1580912fe5a2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -604,7 +604,7 @@ xfs_inobt_insert_sprec(
 STATIC int				/* error code or 0 */
 xfs_ialloc_ag_alloc(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*agbp,		/* alloc group buffer */
+	struct xfs_buf	*agbp,		/* alloc group buffer */
 	int		*alloc)
 {
 	xfs_agi_t	*agi;		/* allocation group header */
@@ -2127,9 +2127,9 @@ xfs_difree_finobt(
  */
 int
 xfs_difree(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_defer_ops	*dfops,		/* extents to free */
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_ino_t		inode,	/* inode to be freed */
+	struct xfs_defer_ops	*dfops,	/* extents to free */
 	struct xfs_icluster	*xic)	/* cluster info if deleted */
 {
 	/* REFERENCED */
@@ -2425,7 +2425,7 @@ xfs_ialloc_compute_maxlevels(
 void
 xfs_ialloc_log_agi(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*bp,		/* allocation group header buffer */
+	struct xfs_buf	*bp,		/* allocation group header buffer */
 	int		fields)		/* bitmask of fields to log */
 {
 	int			first;		/* first byte number */
@@ -2555,9 +2555,9 @@ xfs_agi_read_verify(
 
 static void
 xfs_agi_write_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	xfs_failaddr_t		fa;
 
@@ -2653,7 +2653,7 @@ xfs_ialloc_pagi_init(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno)		/* allocation group number */
 {
-	xfs_buf_t	*bp = NULL;
+	struct xfs_buf	*bp = NULL;
 	int		error;
 
 	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 4035b5d5f6fd..ae1f58e19e49 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -40,7 +40,7 @@
 void
 xfs_inobp_check(
 	xfs_mount_t	*mp,
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	int		i;
 	int		j;
@@ -542,7 +542,7 @@ xfs_iread(
 	xfs_inode_t	*ip,
 	uint		iget_flags)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_dinode_t	*dip;
 	xfs_failaddr_t	fa;
 	int		error;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 3fb29a5ea915..f6b94eb191c8 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -76,9 +76,9 @@ xfs_rtbuf_get(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
-	xfs_buf_t	**bpp)		/* output: buffer for the block */
+	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
-	xfs_buf_t	*bp;		/* block buffer, result */
+	struct xfs_buf	*bp;		/* block buffer, result */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
 	int		nmap = 1;
@@ -118,7 +118,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
@@ -293,7 +293,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -464,11 +464,11 @@ xfs_rtmodify_summary_int(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	xfs_buf_t	*bp;		/* buffer for the summary block */
+	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
 	xfs_fsblock_t	sb;		/* summary fsblock */
 	int		so;		/* index into the summary file */
@@ -528,7 +528,7 @@ xfs_rtmodify_summary(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
@@ -550,7 +550,7 @@ xfs_rtmodify_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
@@ -701,7 +701,7 @@ xfs_rtfree_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_extlen_t	len,		/* length to free */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
@@ -784,7 +784,7 @@ xfs_rtcheck_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -980,7 +980,7 @@ xfs_rtfree_extent(
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp = NULL;	/* summary file block buffer */
+	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
 
 	mp = tp->t_mountp;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1981ef77040d..07dccb05e782 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -179,8 +179,8 @@ xfs_buf_stale(
 
 static int
 xfs_buf_get_maps(
-	struct xfs_buf		*bp,
-	int			map_count)
+	struct xfs_buf	*bp,
+	int		map_count)
 {
 	ASSERT(bp->b_maps == NULL);
 	bp->b_map_count = map_count;
@@ -277,8 +277,8 @@ _xfs_buf_alloc(
  */
 STATIC int
 _xfs_buf_get_pages(
-	xfs_buf_t		*bp,
-	int			page_count)
+	struct xfs_buf	*bp,
+	int		page_count)
 {
 	/* Make sure that we have a page list */
 	if (bp->b_pages == NULL) {
@@ -301,7 +301,7 @@ _xfs_buf_get_pages(
  */
 STATIC void
 _xfs_buf_free_pages(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	if (bp->b_pages != bp->b_page_array) {
 		kmem_free(bp->b_pages);
@@ -312,13 +312,13 @@ _xfs_buf_free_pages(
 /*
  *	Releases the specified buffer.
  *
- * 	The modification state of any associated pages is left unchanged.
- * 	The buffer must not be on any hash - use xfs_buf_rele instead for
- * 	hashed and refcounted buffers
+ *	The modification state of any associated pages is left unchanged.
+ *	The buffer must not be on any hash - use xfs_buf_rele instead for
+ *	hashed and refcounted buffers
  */
 void
 xfs_buf_free(
-	xfs_buf_t		*bp)
+	struct xfs_buf	*bp)
 {
 	trace_xfs_buf_free(bp, _RET_IP_);
 
@@ -348,15 +348,15 @@ xfs_buf_free(
  */
 STATIC int
 xfs_buf_allocate_memory(
-	xfs_buf_t		*bp,
-	uint			flags)
-{
-	size_t			size;
-	size_t			nbytes, offset;
-	gfp_t			gfp_mask = xb_to_gfp(flags);
-	unsigned short		page_count, i;
-	xfs_off_t		start, end;
-	int			error;
+	struct xfs_buf	*bp,
+	uint		flags)
+{
+	size_t		size;
+	size_t		nbytes, offset;
+	gfp_t		gfp_mask = xb_to_gfp(flags);
+	unsigned short	page_count, i;
+	xfs_off_t	start, end;
+	int		error;
 
 	/*
 	 * for buffers that are contained within a single page, just allocate
@@ -448,8 +448,8 @@ xfs_buf_allocate_memory(
  */
 STATIC int
 _xfs_buf_map_pages(
-	xfs_buf_t		*bp,
-	uint			flags)
+	struct xfs_buf	*bp,
+	uint		flags)
 {
 	ASSERT(bp->b_flags & _XBF_PAGES);
 	if (bp->b_page_count == 1) {
@@ -552,16 +552,16 @@ xfs_buf_hash_destroy(
  *	a given range of an inode.  The buffer is returned
  *	locked.	No I/O is implied by this call.
  */
-xfs_buf_t *
+struct xfs_buf *
 _xfs_buf_find(
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
-	xfs_buf_t		*new_bp)
+	struct xfs_buf		*new_bp)
 {
 	struct xfs_perag	*pag;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	xfs_daddr_t		eofs;
 	int			i;
@@ -712,8 +712,8 @@ xfs_buf_get_map(
 
 STATIC int
 _xfs_buf_read(
-	xfs_buf_t		*bp,
-	xfs_buf_flags_t		flags)
+	struct xfs_buf	*bp,
+	xfs_buf_flags_t	flags)
 {
 	ASSERT(!(flags & XBF_WRITE));
 	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
@@ -728,7 +728,7 @@ _xfs_buf_read(
 	return xfs_buf_submit_wait(bp);
 }
 
-xfs_buf_t *
+struct xfs_buf *
 xfs_buf_read_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
@@ -827,8 +827,8 @@ xfs_buf_read_uncached(
  */
 void
 xfs_buf_set_empty(
-	struct xfs_buf		*bp,
-	size_t			numblks)
+	struct xfs_buf	*bp,
+	size_t		numblks)
 {
 	if (bp->b_pages)
 		_xfs_buf_free_pages(bp);
@@ -858,16 +858,16 @@ mem_to_page(
 
 int
 xfs_buf_associate_memory(
-	xfs_buf_t		*bp,
-	void			*mem,
-	size_t			len)
+	struct xfs_buf	*bp,
+	void		*mem,
+	size_t		len)
 {
-	int			rval;
-	int			i = 0;
-	unsigned long		pageaddr;
-	unsigned long		offset;
-	size_t			buflen;
-	int			page_count;
+	int		rval;
+	int		i = 0;
+	unsigned long	pageaddr;
+	unsigned long	offset;
+	size_t		buflen;
+	int		page_count;
 
 	pageaddr = (unsigned long)mem & PAGE_MASK;
 	offset = (unsigned long)mem - pageaddr;
@@ -898,7 +898,7 @@ xfs_buf_associate_memory(
 	return 0;
 }
 
-xfs_buf_t *
+struct xfs_buf *
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
 	size_t			numblks,
@@ -954,7 +954,7 @@ xfs_buf_get_uncached(
  */
 void
 xfs_buf_hold(
-	xfs_buf_t		*bp)
+	struct xfs_buf	*bp)
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
 	atomic_inc(&bp->b_hold);
@@ -966,7 +966,7 @@ xfs_buf_hold(
  */
 void
 xfs_buf_rele(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_perag	*pag = bp->b_pag;
 	bool			release;
@@ -1054,9 +1054,9 @@ xfs_buf_rele(
  */
 int
 xfs_buf_trylock(
-	struct xfs_buf		*bp)
+	struct xfs_buf	*bp)
 {
-	int			locked;
+	int		locked;
 
 	locked = down_trylock(&bp->b_sema) == 0;
 	if (locked) {
@@ -1079,7 +1079,7 @@ xfs_buf_trylock(
  */
 void
 xfs_buf_lock(
-	struct xfs_buf		*bp)
+	struct xfs_buf	*bp)
 {
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
@@ -1093,7 +1093,7 @@ xfs_buf_lock(
 
 void
 xfs_buf_unlock(
-	struct xfs_buf		*bp)
+	struct xfs_buf	*bp)
 {
 	ASSERT(xfs_buf_islocked(bp));
 
@@ -1105,7 +1105,7 @@ xfs_buf_unlock(
 
 STATIC void
 xfs_buf_wait_unpin(
-	xfs_buf_t		*bp)
+	struct xfs_buf	*bp)
 {
 	DECLARE_WAITQUEUE	(wait, current);
 
@@ -1165,8 +1165,7 @@ static void
 xfs_buf_ioend_work(
 	struct work_struct	*work)
 {
-	struct xfs_buf		*bp =
-		container_of(work, xfs_buf_t, b_ioend_work);
+	struct xfs_buf	*bp = container_of(work, struct xfs_buf, b_ioend_work);
 
 	xfs_buf_ioend(bp);
 }
@@ -1181,9 +1180,9 @@ xfs_buf_ioend_async(
 
 void
 __xfs_buf_ioerror(
-	xfs_buf_t		*bp,
-	int			error,
-	xfs_failaddr_t		failaddr)
+	struct xfs_buf	*bp,
+	int		error,
+	xfs_failaddr_t	failaddr)
 {
 	ASSERT(error <= 0 && error >= -1000);
 	bp->b_error = error;
@@ -1192,8 +1191,8 @@ __xfs_buf_ioerror(
 
 void
 xfs_buf_ioerror_alert(
-	struct xfs_buf		*bp,
-	const char		*func)
+	struct xfs_buf	*bp,
+	const char	*func)
 {
 	xfs_alert(bp->b_target->bt_mount,
 "metadata I/O error: block 0x%llx (\"%s\") error %d numblks %d",
@@ -1202,9 +1201,9 @@ xfs_buf_ioerror_alert(
 
 int
 xfs_bwrite(
-	struct xfs_buf		*bp)
+	struct xfs_buf	*bp)
 {
-	int			error;
+	int		error;
 
 	ASSERT(xfs_buf_islocked(bp));
 
@@ -1222,9 +1221,9 @@ xfs_bwrite(
 
 static void
 xfs_buf_bio_end_io(
-	struct bio		*bio)
+	struct bio	*bio)
 {
-	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
+	struct xfs_buf	*bp = (struct xfs_buf *)bio->bi_private;
 
 	/*
 	 * don't overwrite existing errors - otherwise we can lose errors on
@@ -1545,10 +1544,10 @@ xfs_buf_submit_wait(
 
 void *
 xfs_buf_offset(
-	struct xfs_buf		*bp,
-	size_t			offset)
+	struct xfs_buf	*bp,
+	size_t		offset)
 {
-	struct page		*page;
+	struct page	*page;
 
 	if (bp->b_addr)
 		return bp->b_addr + offset;
@@ -1563,13 +1562,13 @@ xfs_buf_offset(
  */
 void
 xfs_buf_iomove(
-	xfs_buf_t		*bp,	/* buffer to process		*/
-	size_t			boff,	/* starting buffer offset	*/
-	size_t			bsize,	/* length to copy		*/
-	void			*data,	/* data address			*/
-	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
+	struct xfs_buf	*bp,	/* buffer to process		*/
+	size_t		boff,	/* starting buffer offset	*/
+	size_t		bsize,	/* length to copy		*/
+	void		*data,	/* data address			*/
+	xfs_buf_rw_t	mode)	/* read/write/zero flag		*/
 {
-	size_t			bend;
+	size_t		bend;
 
 	bend = boff + bsize;
 	while (boff < bend) {
@@ -1731,7 +1730,7 @@ xfs_buftarg_shrink_scan(
 				     xfs_buftarg_isolate, &dispose);
 
 	while (!list_empty(&dispose)) {
-		struct xfs_buf *bp;
+		struct xfs_buf	*bp;
 		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
 		list_del_init(&bp->b_lru);
 		xfs_buf_rele(bp);
@@ -1767,8 +1766,8 @@ xfs_free_buftarg(
 
 int
 xfs_setsize_buftarg(
-	xfs_buftarg_t		*btp,
-	unsigned int		sectorsize)
+	xfs_buftarg_t	*btp,
+	unsigned int	sectorsize)
 {
 	/* Set up metadata sector size info */
 	btp->bt_meta_sectorsize = sectorsize;
@@ -1925,7 +1924,7 @@ xfs_buf_cmp(
 {
 	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
 	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
-	xfs_daddr_t		diff;
+	xfs_daddr_t	diff;
 
 	diff = ap->b_maps[0].bm_bn - bp->b_maps[0].bm_bn;
 	if (diff < 0)
@@ -2122,7 +2121,7 @@ xfs_buf_delwri_pushbuf(
 int __init
 xfs_buf_init(void)
 {
-	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
+	xfs_buf_zone = kmem_zone_init_flags(sizeof(struct xfs_buf), "xfs_buf",
 						KM_ZONE_HWALIGN, NULL);
 	if (!xfs_buf_zone)
 		goto out;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 5b5b4861c729..90f09e89cda2 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -143,7 +143,7 @@ struct xfs_buf_ops {
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
 };
 
-typedef struct xfs_buf {
+struct xfs_buf {
 	/*
 	 * first cacheline holds all the fields needed for an uncontended cache
 	 * hit to be fully processed. The semaphore straddles the cacheline
@@ -214,7 +214,7 @@ typedef struct xfs_buf {
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
-} xfs_buf_t;
+};
 
 /* Finding and Reading Buffers */
 struct xfs_buf *_xfs_buf_find(struct xfs_buftarg *target,
@@ -303,13 +303,13 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
-extern void xfs_buf_free(xfs_buf_t *);
-extern void xfs_buf_rele(xfs_buf_t *);
+extern void xfs_buf_free(struct xfs_buf *);
+extern void xfs_buf_rele(struct xfs_buf *);
 
 /* Locking and Unlocking Buffers */
-extern int xfs_buf_trylock(xfs_buf_t *);
-extern void xfs_buf_lock(xfs_buf_t *);
-extern void xfs_buf_unlock(xfs_buf_t *);
+extern int xfs_buf_trylock(struct xfs_buf *);
+extern void xfs_buf_lock(struct xfs_buf *);
+extern void xfs_buf_unlock(struct xfs_buf *);
 #define xfs_buf_islocked(bp) \
 	((bp)->b_sema.count <= 0)
 
@@ -322,7 +322,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
 extern void xfs_buf_submit(struct xfs_buf *bp);
 extern int xfs_buf_submit_wait(struct xfs_buf *bp);
-extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
+extern void xfs_buf_iomove(struct xfs_buf *, size_t, size_t, void *,
 				xfs_buf_rw_t);
 #define xfs_buf_zero(bp, off, len) \
 	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
@@ -362,7 +362,7 @@ static inline int xfs_buf_ispinned(struct xfs_buf *bp)
 	return atomic_read(&bp->b_pin_count);
 }
 
-static inline void xfs_buf_relse(xfs_buf_t *bp)
+static inline void xfs_buf_relse(struct xfs_buf *bp)
 {
 	xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8afcfa3ed976..977a2ccc32f3 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -406,7 +406,7 @@ xfs_buf_item_unpin(
 	int			remove)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
-	xfs_buf_t		*bp = bip->bli_buf;
+	struct xfs_buf		*bp = bip->bli_buf;
 	struct xfs_ail		*ailp = lip->li_ailp;
 	int			stale = bip->bli_flags & XFS_BLI_STALE;
 	int			freed;
@@ -959,7 +959,7 @@ xfs_buf_item_free(
  */
 void
 xfs_buf_item_relse(
-	xfs_buf_t	*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
@@ -986,8 +986,8 @@ xfs_buf_item_relse(
  */
 void
 xfs_buf_attach_iodone(
-	xfs_buf_t	*bp,
-	void		(*cb)(xfs_buf_t *, xfs_log_item_t *),
+	struct xfs_buf	*bp,
+	void		(*cb)(struct xfs_buf *, xfs_log_item_t *),
 	xfs_log_item_t	*lip)
 {
 	xfs_log_item_t	*head_lip;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 43572f8a1b8e..a891d67bcbc9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -221,16 +221,16 @@ xfs_qm_adjust_dqtimers(
  */
 STATIC void
 xfs_qm_init_dquot_blk(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_buf_t	*bp)
+	xfs_trans_t		*tp,
+	xfs_mount_t		*mp,
+	xfs_dqid_t		id,
+	uint			type,
+	struct xfs_buf		*bp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	xfs_dqblk_t	*d;
-	xfs_dqid_t	curid;
-	int		i;
+	xfs_dqblk_t		*d;
+	xfs_dqid_t		curid;
+	int			i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -298,13 +298,13 @@ xfs_qm_dqalloc(
 	xfs_dquot_t	*dqp,
 	xfs_inode_t	*quotip,
 	xfs_fileoff_t	offset_fsb,
-	xfs_buf_t	**O_bpp)
+	struct xfs_buf	**O_bpp)
 {
 	xfs_fsblock_t	firstblock;
 	struct xfs_defer_ops dfops;
 	xfs_bmbt_irec_t map;
 	int		nmaps, error;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_trans_t	*tp = *tpp;
 
 	ASSERT(tp != NULL);
@@ -409,7 +409,7 @@ xfs_qm_dqtobp(
 	xfs_trans_t		**tpp,
 	xfs_dquot_t		*dqp,
 	xfs_disk_dquot_t	**O_ddpp,
-	xfs_buf_t		**O_bpp,
+	struct xfs_buf		**O_bpp,
 	uint			flags)
 {
 	struct xfs_bmbt_irec	map;
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 84d73835c614..37b7dcba5918 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -83,7 +83,7 @@ xfs_growfs_data_private(
 	xfs_extlen_t		agsize;
 	xfs_extlen_t		tmpsize;
 	xfs_alloc_rec_t		*arec;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			bucket;
 	int			dpct;
 	int			error, saved_error = 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 663b546f2bcd..54277beb2a3d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -749,7 +749,7 @@ xfs_ialloc(
 	xfs_nlink_t	nlink,
 	dev_t		rdev,
 	prid_t		prid,
-	xfs_buf_t	**ialloc_context,
+	struct xfs_buf	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
 	struct xfs_mount *mp = tp->t_mountp;
@@ -963,7 +963,7 @@ xfs_dir_ialloc(
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	xfs_buf_t	*ialloc_context = NULL;
+	struct xfs_buf	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
 	uint		tflags;
@@ -1954,8 +1954,8 @@ xfs_iunlink(
 	xfs_mount_t	*mp = tp->t_mountp;
 	xfs_agi_t	*agi;
 	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
+	struct xfs_buf	*agibp;
+	struct xfs_buf	*ibp;
 	xfs_agino_t	agino;
 	short		bucket_index;
 	int		offset;
@@ -2032,12 +2032,12 @@ xfs_iunlink_remove(
 	xfs_mount_t	*mp;
 	xfs_agi_t	*agi;
 	xfs_dinode_t	*dip;
-	xfs_buf_t	*agibp;
-	xfs_buf_t	*ibp;
+	struct xfs_buf	*agibp;
+	struct xfs_buf	*ibp;
 	xfs_agnumber_t	agno;
 	xfs_agino_t	agino;
 	xfs_agino_t	next_agino;
-	xfs_buf_t	*last_ibp;
+	struct xfs_buf	*last_ibp;
 	xfs_dinode_t	*last_dip = NULL;
 	short		bucket_index;
 	int		offset, last_offset = 0;
@@ -2211,7 +2211,7 @@ xfs_ifree_cluster(
 	int			i, j;
 	int			ioffset;
 	xfs_daddr_t		blkno;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	xfs_inode_t		*ip;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index d58310514423..cf0bab028e19 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -346,7 +346,7 @@ xfs_bulkstat(
 	char			__user *ubuffer, /* buffer with inode stats */
 	int			*done)	/* 1 if there are more stats to get */
 {
-	xfs_buf_t		*agbp;	/* agi header buffer */
+	struct xfs_buf		*agbp;	/* agi header buffer */
 	xfs_agino_t		agino;	/* inode # in allocation group */
 	xfs_agnumber_t		agno;	/* allocation group number */
 	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 047df85528b0..3df424328ae3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1240,7 +1240,8 @@ xlog_space_left(
  * happens with the buffer after the write completes.
  */
 static void
-xlog_iodone(xfs_buf_t *bp)
+xlog_iodone(
+	struct xfs_buf		*bp)
 {
 	struct xlog_in_core	*iclog = bp->b_fspriv;
 	struct xlog		*l = iclog->ic_log;
@@ -1411,7 +1412,7 @@ xlog_alloc_log(
 	xlog_rec_header_t	*head;
 	xlog_in_core_t		**iclogp;
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			i;
 	int			error = -ENOMEM;
 	uint			log2_size = 0;
@@ -1823,7 +1824,7 @@ xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		i;
 	uint		count;		/* byte count of bwrite */
 	uint		count_init;	/* initial count before roundup */
@@ -1848,10 +1849,10 @@ xlog_sync(
 	}
 	roundoff = count - count_init;
 	ASSERT(roundoff >= 0);
-	ASSERT((v2 && log->l_mp->m_sb.sb_logsunit > 1 && 
+	ASSERT((v2 && log->l_mp->m_sb.sb_logsunit > 1 &&
                 roundoff < log->l_mp->m_sb.sb_logsunit)
-		|| 
-		(log->l_mp->m_sb.sb_logsunit <= 1 && 
+		||
+		(log->l_mp->m_sb.sb_logsunit <= 1 &&
 		 roundoff < BBTOB(1)));
 
 	/* move grant heads by roundoff in sync */
@@ -1859,7 +1860,7 @@ xlog_sync(
 	xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
 
 	/* put cycle number in every block */
-	xlog_pack_data(log, iclog, roundoff); 
+	xlog_pack_data(log, iclog, roundoff);
 
 	/* real byte length */
 	size = iclog->ic_offset;
@@ -2604,7 +2605,7 @@ xlog_state_clean_log(
 			 */
 			if (!changed &&
 			   (be32_to_cpu(iclog->ic_header.h_num_logops) ==
-			   		XLOG_COVER_OPS)) {
+					XLOG_COVER_OPS)) {
 				changed = 1;
 			} else {
 				/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7864a298f7eb..14bf1bdcd3bc 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -108,7 +108,7 @@ xlog_verify_bp(
  * to map to a range of nbblks basic blocks at any valid (basic
  * block) offset within the log.
  */
-STATIC xfs_buf_t *
+STATIC struct xfs_buf *
 xlog_get_bp(
 	struct xlog	*log,
 	int		nbblks)
@@ -154,7 +154,7 @@ xlog_get_bp(
 
 STATIC void
 xlog_put_bp(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	xfs_buf_free(bp);
 }
@@ -467,7 +467,7 @@ xlog_find_verify_cycle(
 {
 	xfs_daddr_t	i, j;
 	uint		cycle;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_daddr_t	bufblks;
 	char		*buf = NULL;
 	int		error = 0;
@@ -534,7 +534,7 @@ xlog_find_verify_log_record(
 	int			extra_bblks)
 {
 	xfs_daddr_t		i;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	char			*offset = NULL;
 	xlog_rec_header_t	*head = NULL;
 	int			error = 0;
@@ -641,7 +641,7 @@ xlog_find_head(
 	struct xlog	*log,
 	xfs_daddr_t	*return_head_blk)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	char		*offset;
 	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
 	int		num_scan_bblks;
@@ -1380,7 +1380,7 @@ xlog_find_tail(
 {
 	xlog_rec_header_t	*rhead;
 	char			*offset = NULL;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 	xfs_daddr_t		rhead_blk;
 	xfs_lsn_t		tail_lsn;
@@ -1529,12 +1529,12 @@ xlog_find_zeroed(
 	struct xlog	*log,
 	xfs_daddr_t	*blk_no)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	char		*offset;
-	uint	        first_cycle, last_cycle;
+	uint		first_cycle, last_cycle;
 	xfs_daddr_t	new_blk, last_blk, start_blk;
-	xfs_daddr_t     num_scan_bblks;
-	int	        error, log_bbnum = log->l_logBBsize;
+	xfs_daddr_t	num_scan_bblks;
+	int		error, log_bbnum = log->l_logBBsize;
 
 	*blk_no = 0;
 
@@ -1659,7 +1659,7 @@ xlog_write_log_records(
 	int		tail_block)
 {
 	char		*offset;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		balign, ealign;
 	int		sectbb = log->l_sectBBsize;
 	int		end_block = start_block + blocks;
@@ -2802,7 +2802,7 @@ xlog_recover_buffer_pass2(
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 	xfs_mount_t		*mp = log->l_mp;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 	uint			buf_flags;
 	xfs_lsn_t		lsn;
@@ -2995,7 +2995,7 @@ xlog_recover_inode_pass2(
 {
 	struct xfs_inode_log_format	*in_f;
 	xfs_mount_t		*mp = log->l_mp;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	xfs_dinode_t		*dip;
 	int			len;
 	char			*src;
@@ -3308,7 +3308,7 @@ xlog_recover_dquot_pass2(
 	xfs_lsn_t			current_lsn)
 {
 	xfs_mount_t		*mp = log->l_mp;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_disk_dquot	*ddq, *recddq;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -5016,7 +5016,7 @@ xlog_recover_clear_agi_bucket(
 {
 	xfs_trans_t	*tp;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	int		offset;
 	int		error;
 
@@ -5123,7 +5123,7 @@ xlog_recover_process_iunlinks(
 	xfs_mount_t	*mp;
 	xfs_agnumber_t	agno;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	xfs_agino_t	agino;
 	int		bucket;
 	int		error;
@@ -5322,7 +5322,7 @@ xlog_do_recovery_pass(
 	xfs_daddr_t		blk_no, rblk_no;
 	xfs_daddr_t		rhead_blk;
 	char			*offset;
-	xfs_buf_t		*hbp, *dbp;
+	struct xfs_buf		*hbp, *dbp;
 	int			error = 0, h_size, h_len;
 	int			error2 = 0;
 	int			bblks, split_bblks;
@@ -5670,7 +5670,7 @@ xlog_do_recover(
 {
 	struct xfs_mount *mp = log->l_mp;
 	int		error;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_sb_t	*sbp;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -5900,8 +5900,8 @@ xlog_recover_check_summary(
 {
 	xfs_mount_t	*mp;
 	xfs_agf_t	*agfp;
-	xfs_buf_t	*agfbp;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agfbp;
+	struct xfs_buf	*agibp;
 	xfs_agnumber_t	agno;
 	uint64_t	freeblks;
 	uint64_t	itotal;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6b9f44df7918..ccffb6358cf5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -835,10 +835,10 @@ xfs_qm_qino_alloc(
 
 STATIC void
 xfs_qm_reset_dqcounts(
-	xfs_mount_t	*mp,
-	xfs_buf_t	*bp,
-	xfs_dqid_t	id,
-	uint		type)
+	xfs_mount_t		*mp,
+	struct xfs_buf		*bp,
+	xfs_dqid_t		id,
+	uint			type)
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 488719d43ca8..5357646854cf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -50,7 +50,7 @@ xfs_rtget_summary(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
@@ -68,7 +68,7 @@ xfs_rtany_summary(
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	int		*stat)		/* out: any good extents here? */
 {
@@ -114,7 +114,7 @@ xfs_rtcopy_summary(
 	xfs_trans_t	*tp)		/* transaction pointer */
 {
 	xfs_rtblock_t	bbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* summary buffer */
+	struct xfs_buf	*bp;		/* summary buffer */
 	int		error;		/* error return value */
 	int		log;		/* summary level number (log length) */
 	xfs_suminfo_t	sum;		/* summary data */
@@ -154,7 +154,7 @@ xfs_rtallocate_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_extlen_t	len,		/* length to allocate */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
@@ -236,7 +236,7 @@ xfs_rtallocate_extent_block(
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -348,7 +348,7 @@ xfs_rtallocate_extent_exact(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -427,7 +427,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -621,7 +621,7 @@ xfs_rtallocate_extent_size(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -882,7 +882,7 @@ xfs_growfs_rt(
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
 	xfs_rtblock_t	bmbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* temporary buffer */
+	struct xfs_buf	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
 	xfs_rfsblock_t	nrblocks;	/* new number of realtime blocks */
@@ -1101,7 +1101,7 @@ xfs_rtallocate_extent(
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp;		/* summary file block buffer */
+	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3f30f846d7f2..870e14de2bcd 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -122,10 +122,10 @@ int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_extlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_rtblock_t bbno, int delta,
-			     xfs_buf_t **rbpp, xfs_fsblock_t *rsb,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fsblock_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 2e9e793a8f9d..8ce22719c820 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -186,7 +186,7 @@ xfs_symlink(
 	const char		*cur_chunk;
 	int			byte_cnt;
 	int			n;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -411,17 +411,17 @@ STATIC int
 xfs_inactive_symlink_rmt(
 	struct xfs_inode *ip)
 {
-	xfs_buf_t	*bp;
-	int		done;
-	int		error;
-	xfs_fsblock_t	first_block;
+	struct xfs_buf		*bp;
+	int			done;
+	int			error;
+	xfs_fsblock_t		first_block;
 	struct xfs_defer_ops	dfops;
-	int		i;
-	xfs_mount_t	*mp;
-	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
-	int		nmaps;
-	int		size;
-	xfs_trans_t	*tp;
+	int			i;
+	xfs_mount_t		*mp;
+	xfs_bmbt_irec_t		mval[XFS_SYMLINK_MAPS];
+	int			nmaps;
+	int			size;
+	xfs_trans_t		*tp;
 
 	mp = ip->i_mount;
 	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 86f92df32c42..7d67b7274bff 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -434,7 +434,7 @@ xfs_trans_apply_sb_deltas(
 	xfs_trans_t	*tp)
 {
 	xfs_dsb_t	*sbp;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		whole = 0;
 
 	bp = xfs_trans_getsb(tp, tp->t_mountp, 0);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 815b53d20e26..571fe499a48f 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -82,7 +82,7 @@ struct xfs_item_ops {
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
-	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
+	void (*iop_error)(xfs_log_item_t *, struct xfs_buf *);
 };
 
 void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 74563cd2970c..5359c4bd95e8 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -138,7 +138,7 @@ xfs_trans_get_buf_map(
 	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 
 	if (!tp)
@@ -187,13 +187,13 @@ xfs_trans_get_buf_map(
  * buffer is a private buffer which we keep a pointer to in the
  * mount structure.
  */
-xfs_buf_t *
+struct xfs_buf *
 xfs_trans_getsb(
 	xfs_trans_t		*tp,
 	struct xfs_mount	*mp,
 	int			flags)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 
 	/*
@@ -355,7 +355,7 @@ xfs_trans_read_buf_map(
 void
 xfs_trans_brelse(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip;
 	int			freed;
@@ -460,7 +460,7 @@ xfs_trans_brelse(
 void
 xfs_trans_bhold(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
@@ -481,7 +481,7 @@ xfs_trans_bhold(
 void
 xfs_trans_bhold_release(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
@@ -605,7 +605,7 @@ xfs_trans_log_buf(
 void
 xfs_trans_binval(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	int			i;
@@ -660,7 +660,7 @@ xfs_trans_binval(
 void
 xfs_trans_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
@@ -684,7 +684,7 @@ xfs_trans_inode_buf(
 void
 xfs_trans_stale_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
@@ -709,7 +709,7 @@ xfs_trans_stale_inode_buf(
 void
 xfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
@@ -802,7 +802,7 @@ xfs_trans_buf_copy_type(
 void
 xfs_trans_dquot_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			type)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
-- 
2.14.3

