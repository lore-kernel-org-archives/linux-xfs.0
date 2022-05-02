Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44682C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 08:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359303AbiEBIYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 04:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383749AbiEBIXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 04:23:55 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 671E1644B
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 01:20:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 94012534BB3
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 18:20:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-0073Tg-ML
        for linux-xfs@vger.kernel.org; Mon, 02 May 2022 18:20:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nlRI4-004WM9-L5
        for linux-xfs@vger.kernel.org;
        Mon, 02 May 2022 18:20:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: detect self referencing btree sibling pointers
Date:   Mon,  2 May 2022 18:20:15 +1000
Message-Id: <20220502082018.1076561-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502082018.1076561-1-david@fromorbit.com>
References: <20220502082018.1076561-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=626f9446
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=h5XfSTf-C_0QDq3dHd0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To catch the obvious graph cycle problem and hence potential endless
looping.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c | 137 ++++++++++++++++++++++++++++----------
 1 file changed, 102 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a8c79e760d8a..991fae6f500a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,6 +51,50 @@ xfs_btree_magic(
 	return magic;
 }
 
+static xfs_failaddr_t
+xfs_btree_check_lblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_fsblock_t		fsb,
+	xfs_fsblock_t		sibling)
+{
+	if (sibling == NULLFSBLOCK)
+		return NULL;
+	if (sibling == fsb)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
+			return __this_address;
+	} else if (!xfs_verify_fsbno(mp, sibling)) {
+		return __this_address;
+	}
+
+	return NULL;
+}
+
+static xfs_failaddr_t
+xfs_btree_check_sblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		sibling)
+{
+	if (sibling == NULLAGBLOCK)
+		return NULL;
+	if (sibling == agbno)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
+			return __this_address;
+	} else if (!xfs_verify_agbno(mp, agno, sibling)) {
+		return __this_address;
+	}
+	return NULL;
+}
+
 /*
  * Check a long btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
@@ -65,6 +109,8 @@ __xfs_btree_check_lblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -83,16 +129,16 @@ __xfs_btree_check_lblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp)
+		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+
+	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /* Check a long btree block header. */
@@ -130,6 +176,9 @@ __xfs_btree_check_sblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_agblock_t		agbno = NULLAGBLOCK;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -146,16 +195,18 @@ __xfs_btree_check_sblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp) {
+		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+		agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
+	}
+
+	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
+				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /* Check a short btree block header. */
@@ -4271,6 +4322,20 @@ xfs_btree_visit_block(
 	if (xfs_btree_ptr_is_null(cur, &rptr))
 		return -ENOENT;
 
+	/*
+	 * We only visit blocks once in this walk, so we have to avoid the
+	 * internal xfs_btree_lookup_get_block() optimisation where it will
+	 * return the same block without checking if the right sibling points
+	 * back to us and creates a cyclic reference in the btree.
+	 */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (be64_to_cpu(rptr.l) ==
+				XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp)))
+			return -EFSCORRUPTED;
+	} else if (be32_to_cpu(rptr.s) ==
+			xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp))) {
+		return -EFSCORRUPTED;
+	}
 	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
 }
 
@@ -4445,20 +4510,21 @@ xfs_btree_lblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_fsblock_t		fsb;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
 
 	/* sibling pointer verification */
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /**
@@ -4499,7 +4565,9 @@ xfs_btree_sblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_agblock_t		agno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
@@ -4507,14 +4575,13 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+				be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /*
-- 
2.35.1

