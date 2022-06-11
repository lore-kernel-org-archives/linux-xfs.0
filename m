Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FCBCCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiFKB1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348760AbiFKB1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:23 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 325BF3FB131
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9E22D10E721A
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APo-51
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNS-3v
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 36/50] xfs: convert trim to use for_each_perag_range
Date:   Sat, 11 Jun 2022 11:26:45 +1000
Message-Id: <20220611012659.3418072-37-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=PynOkrAUnEEYtSWtPP4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To convert it to using active perag references and hence make it
shrink safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c | 50 ++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index bfc829c07f03..afc4c78b9eed 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -21,23 +21,20 @@
 
 STATIC int
 xfs_trim_extents(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen,
 	uint64_t		*blocks_trimmed)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
 	struct xfs_agf		*agf;
-	struct xfs_perag	*pag;
 	int			error;
 	int			i;
 
-	pag = xfs_perag_get(mp, agno);
-
 	/*
 	 * Force out the log.  This means any transactions that might have freed
 	 * space before we take the AGF buffer lock are now on disk, and the
@@ -47,7 +44,7 @@ xfs_trim_extents(
 
 	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
 	if (error)
-		goto out_put_perag;
+		return error;
 	agf = agbp->b_addr;
 
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
@@ -71,10 +68,10 @@ xfs_trim_extents(
 
 		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
 		if (error)
-			goto out_del_cursor;
+			break;
 		if (XFS_IS_CORRUPT(mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto out_del_cursor;
+			break;
 		}
 		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
 
@@ -83,15 +80,15 @@ xfs_trim_extents(
 		 * the format the range/len variables are supplied in by
 		 * userspace.
 		 */
-		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+		dbno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, fbno);
 		dlen = XFS_FSB_TO_BB(mp, flen);
 
 		/*
 		 * Too small?  Give up.
 		 */
 		if (dlen < minlen) {
-			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
-			goto out_del_cursor;
+			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			break;
 		}
 
 		/*
@@ -100,7 +97,7 @@ xfs_trim_extents(
 		 * down partially overlapping ranges for now.
 		 */
 		if (dbno + dlen < start || dbno > end) {
-			trace_xfs_discard_exclude(mp, agno, fbno, flen);
+			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
 
@@ -109,32 +106,30 @@ xfs_trim_extents(
 		 * discard and try again the next time.
 		 */
 		if (xfs_extent_busy_search(mp, pag, fbno, flen)) {
-			trace_xfs_discard_busy(mp, agno, fbno, flen);
+			trace_xfs_discard_busy(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
 
-		trace_xfs_discard_extent(mp, agno, fbno, flen);
+		trace_xfs_discard_extent(mp, pag->pag_agno, fbno, flen);
 		error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
 		if (error)
-			goto out_del_cursor;
+			break;
 		*blocks_trimmed += flen;
 
 next_extent:
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
-			goto out_del_cursor;
+			break;
 
 		if (fatal_signal_pending(current)) {
 			error = -ERESTARTSYS;
-			goto out_del_cursor;
+			break;
 		}
 	}
 
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
 	xfs_buf_relse(agbp);
-out_put_perag:
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -152,11 +147,12 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
+	struct xfs_perag	*pag;
 	unsigned int		granularity =
 		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end, minlen;
-	xfs_agnumber_t		start_agno, end_agno, agno;
+	xfs_agnumber_t		agno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
@@ -193,18 +189,18 @@ xfs_ioc_trim(
 	end = start + BTOBBT(range.len) - 1;
 
 	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
-
-	start_agno = xfs_daddr_to_agno(mp, start);
-	end_agno = xfs_daddr_to_agno(mp, end);
+		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
 
-	for (agno = start_agno; agno <= end_agno; agno++) {
-		error = xfs_trim_extents(mp, agno, start, end, minlen,
+	agno = xfs_daddr_to_agno(mp, start);
+	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
+		error = xfs_trim_extents(pag, start, end, minlen,
 					  &blocks_trimmed);
 		if (error) {
 			last_error = error;
-			if (error == -ERESTARTSYS)
+			if (error == -ERESTARTSYS) {
+				xfs_perag_rele(pag);
 				break;
+			}
 		}
 	}
 
-- 
2.35.1

