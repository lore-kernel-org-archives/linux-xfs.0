Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FBDC4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 00:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9910423716
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 00:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgLQAjp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 19:39:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgLQAjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Dec 2020 19:39:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH0VcRV065475;
        Thu, 17 Dec 2020 00:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Ng0KnyVSohLPDQbckdEgFhFWDLMAqdYmdeh9ZGkujE0=;
 b=voc+5xIp1YV2r5kLDwB8igcImEDHt8gLbSIh+kTL9eDOrcmkL4IVqJTjVtO6/W/p58ES
 QnyM2uRUgWkbcpoG6e1jOS+qF2lYIC0dfsIwY1WU634K2+fcZwoOhsHfXydRV1XQINZs
 vq7JZNvJWPsTOHp3qW/LUoq0k2L1O3pvLdZ0ldj5kXkXpyn4tOtnYw5yKIAn+vK5YXiJ
 Z5gdv3oTml3Jlk35yKdxh+FrEkWrRbV9nvZz0rUYPXIPNwj5FylNxj3DwAWnevh/sbgv
 k20Otqm3kX2Ow0foIwbf1C2EfNBDdpRkSmUGX16ct15sqyTu4x15MEOAvg9KO4dqEyad Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35cn9rk2v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 00:38:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH0UTnh031717;
        Thu, 17 Dec 2020 00:38:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35d7syjv8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 00:38:57 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BH0cuvi019821;
        Thu, 17 Dec 2020 00:38:56 GMT
Received: from localhost (/10.159.128.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 16:38:55 -0800
Date:   Wed, 16 Dec 2020 16:38:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: remove xfs_buf_t typedef
Message-ID: <20201217003854.GD6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Prepare for kernel xfs_buf  alignment by getting rid of the
xfs_buf_t typedef from userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: port the kernel now the 5.11 stuff has stabilized]
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c    |   16 ++++++++--------
 fs/xfs/libxfs/xfs_bmap.c     |    6 +++---
 fs/xfs/libxfs/xfs_btree.c    |   10 +++++-----
 fs/xfs/libxfs/xfs_ialloc.c   |    4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c |   22 +++++++++++-----------
 fs/xfs/xfs_buf.c             |   24 ++++++++++++------------
 fs/xfs/xfs_buf.h             |   14 +++++++-------
 fs/xfs/xfs_buf_item.c        |    4 ++--
 fs/xfs/xfs_fsops.c           |    2 +-
 fs/xfs/xfs_log_recover.c     |    8 ++++----
 fs/xfs/xfs_rtalloc.c         |   20 ++++++++++----------
 fs/xfs/xfs_rtalloc.h         |    4 ++--
 fs/xfs/xfs_symlink.c         |    4 ++--
 fs/xfs/xfs_trans.c           |    2 +-
 fs/xfs/xfs_trans_buf.c       |   16 ++++++++--------
 15 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 15640015be9d..7cb9f064ac64 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -690,9 +690,9 @@ xfs_alloc_read_agfl(
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
@@ -2647,12 +2647,12 @@ xfs_alloc_fix_freelist(
 int				/* error */
 xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
+	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
 	int		btreeblk) /* destination is a AGF btree */
 {
 	struct xfs_agf	*agf = agbp->b_addr;
-	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
+	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	__be32		*agfl_bno;
 	int		error;
@@ -2711,7 +2711,7 @@ xfs_alloc_get_freelist(
 void
 xfs_alloc_log_agf(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*bp,	/* buffer for a.g. freelist header */
+	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	int		fields)	/* mask of fields to be logged (XFS_AGF_...) */
 {
 	int	first;		/* first byte offset */
@@ -2757,7 +2757,7 @@ xfs_alloc_pagf_init(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	int			flags)	/* XFS_ALLOC_FLAGS_... */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
@@ -2772,8 +2772,8 @@ xfs_alloc_pagf_init(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dcf56bcafb8f..bc446418e227 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -321,7 +321,7 @@ xfs_bmap_check_leaf_extents(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_buf_t		*bp;	/* buffer for "block" */
+	struct xfs_buf		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
 	xfs_extnum_t		i=0, j;	/* index into the extents list */
 	int			level;	/* btree level, for checking */
@@ -592,7 +592,7 @@ xfs_bmap_btree_to_extents(
 	struct xfs_btree_block	*rblock = ifp->if_broot;
 	struct xfs_btree_block	*cblock;/* child btree block */
 	xfs_fsblock_t		cbno;	/* child block number */
-	xfs_buf_t		*cbp;	/* child block's buffer */
+	struct xfs_buf		*cbp;	/* child block's buffer */
 	int			error;	/* error return value */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_owner_info	oinfo;
@@ -830,7 +830,7 @@ xfs_bmap_local_to_extents(
 	int		flags;		/* logging flags returned */
 	struct xfs_ifork *ifp;		/* inode fork pointer */
 	xfs_alloc_arg_t	args;		/* allocation arguments */
-	xfs_buf_t	*bp;		/* buffer for extent block */
+	struct xfs_buf	*bp;		/* buffer for extent block */
 	struct xfs_bmbt_irec rec;
 	struct xfs_iext_cursor icur;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 51dbff9b0908..c4d7a9241dc3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -397,7 +397,7 @@ xfs_btree_dup_cursor(
 	xfs_btree_cur_t	*cur,		/* input cursor */
 	xfs_btree_cur_t	**ncur)		/* output cursor */
 {
-	xfs_buf_t	*bp;		/* btree block's buffer pointer */
+	struct xfs_buf	*bp;		/* btree block's buffer pointer */
 	int		error;		/* error return value */
 	int		i;		/* level number of btree block */
 	xfs_mount_t	*mp;		/* mount structure for filesystem */
@@ -701,7 +701,7 @@ xfs_btree_firstrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -731,7 +731,7 @@ xfs_btree_lastrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -993,7 +993,7 @@ STATIC void
 xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
-	xfs_buf_t		*bp)	/* new buffer to set */
+	struct xfs_buf		*bp)	/* new buffer to set */
 {
 	struct xfs_btree_block	*b;	/* btree block */
 
@@ -1636,7 +1636,7 @@ xfs_btree_decrement(
 	int			*stat)		/* success/failure */
 {
 	struct xfs_btree_block	*block;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;		/* error return value */
 	int			lev;
 	union xfs_btree_ptr	ptr;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d58607cda477..69b228fce81a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2459,7 +2459,7 @@ xfs_imap(
 void
 xfs_ialloc_log_agi(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*bp,		/* allocation group header buffer */
+	struct xfs_buf	*bp,		/* allocation group header buffer */
 	int		fields)		/* bitmask of fields to log */
 {
 	int			first;		/* first byte number */
@@ -2680,7 +2680,7 @@ xfs_ialloc_pagi_init(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno)		/* allocation group number */
 {
-	xfs_buf_t	*bp = NULL;
+	struct xfs_buf	*bp = NULL;
 	int		error;
 
 	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 6c1aba16113c..fe3a49575ff3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -56,9 +56,9 @@ xfs_rtbuf_get(
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
@@ -101,7 +101,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
@@ -276,7 +276,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -447,11 +447,11 @@ xfs_rtmodify_summary_int(
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
@@ -517,7 +517,7 @@ xfs_rtmodify_summary(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
@@ -539,7 +539,7 @@ xfs_rtmodify_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
@@ -690,7 +690,7 @@ xfs_rtfree_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_extlen_t	len,		/* length to free */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
@@ -773,7 +773,7 @@ xfs_rtcheck_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -969,7 +969,7 @@ xfs_rtfree_extent(
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp = NULL;	/* summary file block buffer */
+	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
 
 	mp = tp->t_mountp;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e4cf91f4f9f..f8400bbd6473 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -278,7 +278,7 @@ _xfs_buf_alloc(
  */
 STATIC int
 _xfs_buf_get_pages(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	int			page_count)
 {
 	/* Make sure that we have a page list */
@@ -302,7 +302,7 @@ _xfs_buf_get_pages(
  */
 STATIC void
 _xfs_buf_free_pages(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	if (bp->b_pages != bp->b_page_array) {
 		kmem_free(bp->b_pages);
@@ -319,7 +319,7 @@ _xfs_buf_free_pages(
  */
 static void
 xfs_buf_free(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_free(bp, _RET_IP_);
 
@@ -352,7 +352,7 @@ xfs_buf_free(
  */
 STATIC int
 xfs_buf_allocate_memory(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			flags)
 {
 	size_t			size;
@@ -463,7 +463,7 @@ xfs_buf_allocate_memory(
  */
 STATIC int
 _xfs_buf_map_pages(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			flags)
 {
 	ASSERT(bp->b_flags & _XBF_PAGES);
@@ -590,7 +590,7 @@ xfs_buf_find(
 	struct xfs_buf		**found_bp)
 {
 	struct xfs_perag	*pag;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	xfs_daddr_t		eofs;
 	int			i;
@@ -762,7 +762,7 @@ xfs_buf_get_map(
 
 int
 _xfs_buf_read(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	xfs_buf_flags_t		flags)
 {
 	ASSERT(!(flags & XBF_WRITE));
@@ -1005,7 +1005,7 @@ xfs_buf_get_uncached(
  */
 void
 xfs_buf_hold(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
 	atomic_inc(&bp->b_hold);
@@ -1017,7 +1017,7 @@ xfs_buf_hold(
  */
 void
 xfs_buf_rele(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_perag	*pag = bp->b_pag;
 	bool			release;
@@ -1161,7 +1161,7 @@ xfs_buf_unlock(
 
 STATIC void
 xfs_buf_wait_unpin(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	DECLARE_WAITQUEUE	(wait, current);
 
@@ -1373,7 +1373,7 @@ xfs_buf_ioend_work(
 	struct work_struct	*work)
 {
 	struct xfs_buf		*bp =
-		container_of(work, xfs_buf_t, b_ioend_work);
+		container_of(work, struct xfs_buf, b_ioend_work);
 
 	xfs_buf_ioend(bp);
 }
@@ -1388,7 +1388,7 @@ xfs_buf_ioend_async(
 
 void
 __xfs_buf_ioerror(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	int			error,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bfd2907e7bc4..5d91a31298a4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -124,7 +124,7 @@ struct xfs_buf_ops {
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
 };
 
-typedef struct xfs_buf {
+struct xfs_buf {
 	/*
 	 * first cacheline holds all the fields needed for an uncontended cache
 	 * hit to be fully processed. The semaphore straddles the cacheline
@@ -190,7 +190,7 @@ typedef struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
-} xfs_buf_t;
+};
 
 /* Finding and Reading Buffers */
 struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
@@ -253,16 +253,16 @@ int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
-extern void xfs_buf_rele(xfs_buf_t *);
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
 
-static inline void xfs_buf_relse(xfs_buf_t *bp)
+static inline void xfs_buf_relse(struct xfs_buf *bp)
 {
 	xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0356f2e340a1..dc0be2a639cc 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -412,7 +412,7 @@ xfs_buf_item_unpin(
 	int			remove)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
-	xfs_buf_t		*bp = bip->bli_buf;
+	struct xfs_buf		*bp = bip->bli_buf;
 	int			stale = bip->bli_flags & XFS_BLI_STALE;
 	int			freed;
 
@@ -942,7 +942,7 @@ xfs_buf_item_free(
  */
 void
 xfs_buf_item_relse(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ef1d5bb88b93..5870db855e8b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -28,7 +28,7 @@ xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
 	xfs_growfs_data_t	*in)		/* growfs data input struct */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1152c4b3ba96..97f31308de03 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2631,7 +2631,7 @@ xlog_recover_clear_agi_bucket(
 {
 	xfs_trans_t	*tp;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	int		offset;
 	int		error;
 
@@ -2749,7 +2749,7 @@ xlog_recover_process_iunlinks(
 	xfs_mount_t	*mp;
 	xfs_agnumber_t	agno;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	xfs_agino_t	agino;
 	int		bucket;
 	int		error;
@@ -3501,8 +3501,8 @@ xlog_recover_check_summary(
 	struct xlog	*log)
 {
 	xfs_mount_t	*mp;
-	xfs_buf_t	*agfbp;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agfbp;
+	struct xfs_buf	*agibp;
 	xfs_agnumber_t	agno;
 	uint64_t	freeblks;
 	uint64_t	itotal;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ede1baf31413..b4999fb01ff7 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,7 +32,7 @@ xfs_rtget_summary(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
@@ -50,7 +50,7 @@ xfs_rtany_summary(
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	int		*stat)		/* out: any good extents here? */
 {
@@ -104,7 +104,7 @@ xfs_rtcopy_summary(
 	xfs_trans_t	*tp)		/* transaction pointer */
 {
 	xfs_rtblock_t	bbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* summary buffer */
+	struct xfs_buf	*bp;		/* summary buffer */
 	int		error;		/* error return value */
 	int		log;		/* summary level number (log length) */
 	xfs_suminfo_t	sum;		/* summary data */
@@ -144,7 +144,7 @@ xfs_rtallocate_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_extlen_t	len,		/* length to allocate */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
@@ -226,7 +226,7 @@ xfs_rtallocate_extent_block(
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -345,7 +345,7 @@ xfs_rtallocate_extent_exact(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -424,7 +424,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -626,7 +626,7 @@ xfs_rtallocate_extent_size(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -900,7 +900,7 @@ xfs_growfs_rt(
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
 	xfs_rtblock_t	bmbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* temporary buffer */
+	struct xfs_buf	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
 	xfs_rfsblock_t	nrblocks;	/* new number of realtime blocks */
@@ -1151,7 +1151,7 @@ xfs_rtallocate_extent(
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp;		/* summary file block buffer */
+	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 93e77b221355..ed885620589c 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -115,10 +115,10 @@ int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
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
index 8e88a7ca387e..1f43fd7f3209 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -154,7 +154,7 @@ xfs_symlink(
 	const char		*cur_chunk;
 	int			byte_cnt;
 	int			n;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -365,7 +365,7 @@ STATIC int
 xfs_inactive_symlink_rmt(
 	struct xfs_inode *ip)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		done;
 	int		error;
 	int		i;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c94e71f741b6..e72730f85af1 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -465,7 +465,7 @@ xfs_trans_apply_sb_deltas(
 	xfs_trans_t	*tp)
 {
 	xfs_dsb_t	*sbp;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		whole = 0;
 
 	bp = xfs_trans_getsb(tp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 42d63b830cb9..9aced0a00003 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -121,7 +121,7 @@ xfs_trans_get_buf_map(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			error;
 
@@ -401,7 +401,7 @@ xfs_trans_brelse(
 void
 xfs_trans_bhold(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -422,7 +422,7 @@ xfs_trans_bhold(
 void
 xfs_trans_bhold_release(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -538,7 +538,7 @@ xfs_trans_log_buf(
 void
 xfs_trans_binval(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			i;
@@ -593,7 +593,7 @@ xfs_trans_binval(
 void
 xfs_trans_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -618,7 +618,7 @@ xfs_trans_inode_buf(
 void
 xfs_trans_stale_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -643,7 +643,7 @@ xfs_trans_stale_inode_buf(
 void
 xfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -737,7 +737,7 @@ xfs_trans_buf_copy_type(
 void
 xfs_trans_dquot_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			type)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
