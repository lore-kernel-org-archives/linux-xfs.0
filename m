Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA813C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjEZBkT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjEZBkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11781A8
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F1D564C02
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25C3C433EF;
        Fri, 26 May 2023 01:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065214;
        bh=Zmo/8i3xQpjFnjh4q+f5KMjsjzc+/Ku45hl5UOI2uVw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ZqzcCVd9sWAeFyeYohTI1DZSIQDVn6qk2lojWzwjIgYARRZAPVawuLAVxqCNp9/Ly
         D3RP/MZ+a6f5WoZYSEekxlehedMBdoV6ZgkEn8IX2FzetBbnuFBtan8rAuE8rBN4Yr
         kvSbiK22+oSY6aTMJxg348K6V7TnrHkQMw+Zrg34/ob7FvIRq6IjZ4VZkWCrVrAHYg
         ih55rSL86MLK2EWANSNcx2/9MiJ8d9V/jbhWRh+SQrU461LlbvC8mTv9frS8q2zmBL
         YfoWaXufRouu5D90K2VxBjJ2CTTiP8srY2fvc8uC7ZkE6G4uWkMjtExKlG46aC4O+a
         wtTK4f1NNshzQ==
Date:   Thu, 25 May 2023 18:40:14 -0700
Subject: [PATCH 3/4] xfs: fix severe performance problems when fstrimming a
 subset of an AG
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069762.3738451.10460404869606942744.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069715.3738451.3754446921976634655.stgit@frogsfrogsfrogs>
References: <168506069715.3738451.3754446921976634655.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS issues discard IOs while holding the free space btree and the AGF
buffers locked.  If the discard IOs are slow, this can lead to long
stalls for every other thread trying to access that AG.  On a 10TB high
performance flash storage device with a severely fragmented free space
btree in every AG, this results in many threads tripping the hangcheck
warnings while waiting for the AGF.  This happens even after we've run
fstrim a few times and waited for the nvme namespace utilization
counters to stabilize.

Strace for the entire 100TB looks like:
ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>

Reducing the size of the FITRIM requests to a single AG at a time
produces lower times for each individual call, but even this isn't quite
acceptable, because the lock hold times are still high enough to cause
stall warnings:

Strace for the first 4x 1TB AGs looks like (2):
ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>

The fstrim code has to synchronize discards with block allocations, so
we must hold the AGF lock while issuing discard IOs.  Breaking up the
calls into smaller start/len segments ought to reduce the lock hold time
and allow other threads a chance to make progress.  Unfortunately, the
current fstrim implementation handles this poorly because it walks the
entire free space by length index (cntbt) and it's not clear if we can
cycle the AGF periodically to reduce latency because there's no
less-than btree lookup.

The first solution I thought of was to limit latency by scanning parts
of an AG at a time, but this doesn't solve the stalling problem when the
free space is heavily fragmented because each sub-AG scan has to walk
the entire cntbt to find free space that fits within the given range.
In fact, this dramatically increases the runtime!  This itself is a
problem, because sub-AG fstrim runtime is unnecessarily high.

For sub-AG scans, create a second implementation that will walk the
bnobt and perform the trims in block number order.  Since the cursor has
an obviously monotonically increasing value, it is easy to cycle the AGF
periodically to allow other threads to do work.  This implementation
avoids the worst problems of the original code, though it lacks the
desirable attribute of freeing the biggest chunks first.

On the other hand, this second implementation will be much easier to
constrain the locking latency, and makes it much easier to report fstrim
progress to anyone who's running xfs_scrub.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |  144 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 131 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index ce77451b00ef..9cddfa005105 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -20,6 +20,121 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 
+/* Trim the free space in this AG by block number. */
+static inline int
+xfs_trim_ag_bybno(
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agbp,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
+	struct xfs_btree_cur	*cur;
+	struct xfs_agf		*agf = agbp->b_addr;
+	xfs_daddr_t		end_daddr;
+	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agblock_t		start_agbno;
+	xfs_agblock_t		end_agbno;
+	xfs_extlen_t		minlen_fsb = XFS_BB_TO_FSB(mp, minlen);
+	int			i;
+	int			error;
+
+	start = max(start, XFS_AGB_TO_DADDR(mp, agno, 0));
+	start_agbno = xfs_daddr_to_agbno(mp, start);
+
+	end_daddr = XFS_AGB_TO_DADDR(mp, agno, be32_to_cpu(agf->agf_length));
+	end = min(end, end_daddr - 1);
+	end_agbno = xfs_daddr_to_agbno(mp, end);
+
+	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_BNO);
+
+	error = xfs_alloc_lookup_le(cur, start_agbno, 0, &i);
+	if (error)
+		goto out_del_cursor;
+
+	/*
+	 * If we didn't find anything at or below start_agbno, increment the
+	 * cursor to see if there's another record above it.
+	 */
+	if (!i) {
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto out_del_cursor;
+	}
+
+	/* Loop the entire range that was asked for. */
+	while (i) {
+		xfs_agblock_t	fbno;
+		xfs_extlen_t	flen;
+		xfs_daddr_t	dbno;
+		xfs_extlen_t	dlen;
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			goto out_del_cursor;
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto out_del_cursor;
+		}
+
+		/* Skip extents entirely outside of the range. */
+		if (fbno >= end_agbno)
+			break;
+		if (fbno + flen < start_agbno)
+			goto next_extent;
+
+		/* Trim the extent returned to the range we want. */
+		if (fbno < start_agbno) {
+			flen -= start_agbno - fbno;
+			fbno = start_agbno;
+		}
+		if (fbno + flen > end_agbno + 1)
+			flen = end_agbno - fbno + 1;
+
+		/* Ignore too small. */
+		if (flen < minlen_fsb) {
+			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
+			goto next_extent;
+		}
+
+		/*
+		 * If any blocks in the range are still busy, skip the
+		 * discard and try again the next time.
+		 */
+		if (xfs_extent_busy_search(mp, pag, fbno, flen)) {
+			trace_xfs_discard_busy(mp, agno, fbno, flen);
+			goto next_extent;
+		}
+
+		trace_xfs_discard_extent(mp, agno, fbno, flen);
+
+		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+		dlen = XFS_FSB_TO_BB(mp, flen);
+		error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
+		if (error)
+			goto out_del_cursor;
+		*blocks_trimmed += flen;
+
+next_extent:
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto out_del_cursor;
+
+		if (fatal_signal_pending(current)) {
+			error = -ERESTARTSYS;
+			goto out_del_cursor;
+		}
+	}
+
+out_del_cursor:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
 /* Trim the free space in this AG by length. */
 static inline int
 xfs_trim_ag_bylen(
@@ -78,20 +193,11 @@ xfs_trim_ag_bylen(
 		 * Too small?  Give up.
 		 */
 		if (dlen < minlen) {
-			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno,
+					flen);
 			break;
 		}
 
-		/*
-		 * If the extent is entirely outside of the range we are
-		 * supposed to discard skip it.  Do not bother to trim
-		 * down partially overlapping ranges for now.
-		 */
-		if (dbno + dlen < start || dbno > end) {
-			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
-			goto next_extent;
-		}
-
 		/*
 		 * If any blocks in the range are still busy, skip the
 		 * discard and try again the next time.
@@ -133,6 +239,7 @@ xfs_trim_ag_extents(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_buf		*agbp;
+	struct xfs_agf		*agf;
 	int			error;
 
 	/*
@@ -145,9 +252,20 @@ xfs_trim_ag_extents(
 	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
 	if (error)
 		return error;
+	agf = agbp->b_addr;
+
+	if (start > XFS_AGB_TO_DADDR(mp, pag->pag_agno, 0) ||
+	    end < XFS_AGB_TO_DADDR(mp, pag->pag_agno,
+				   be32_to_cpu(agf->agf_length)) - 1) {
+		/* Only trimming part of this AG */
+		error = xfs_trim_ag_bybno(pag, agbp, start, end, minlen,
+				blocks_trimmed);
+	} else {
+		/* Trim this entire AG */
+		error = xfs_trim_ag_bylen(pag, agbp, start, end, minlen,
+				blocks_trimmed);
+	}
 
-	error = xfs_trim_ag_bylen(pag, agbp, start, end, minlen,
-			blocks_trimmed);
 	xfs_buf_relse(agbp);
 	return error;
 }

