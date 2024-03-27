Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2266D1B94D
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505279; cv=none; b=Rp6wqLMzNooCdrOBx6vJJF1Q0MZAbzuLj2VLQPwICZJRnknQL5h6qnTGzC2fEMd9O3Ip7bLTCx62zSn3uHRBd84PoTIk5+SEDGFImRgjKhoFIf6NDolhUnkMgWSdty/1VtQk0DFsO3MDFwFT4O7Qh0mRfVRLksmhUaw6+ear1L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505279; c=relaxed/simple;
	bh=0psk16qIjfFOCINZ5mwTJH02R5VLLeF+J/c5RWC4ys8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KHwv5yAXOo7IW+ac1g+MEh5BVImvYrO5LNJCSgS7KtSZ4Oe6FzILMws2kHvwGwhtBVq/NZxsOnSLQo/bdeY7NVLuUydjR+wsCCVexPS6yE0/G0UabzCUSMEPUTxE/UGRZrNc4Ug2fQO3Sj6+hyWOXxmyxewP5Aw9BkGzSkz+eIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crCYNLK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crCYNLK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F7C433F1;
	Wed, 27 Mar 2024 02:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505279;
	bh=0psk16qIjfFOCINZ5mwTJH02R5VLLeF+J/c5RWC4ys8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=crCYNLK9QKAB3+L8QiluRMFqQLrOmIHV8DFRcotZGag9aVCxhj3t8RmxxRGWqHGgl
	 jjplSQbUD5ztFPQ+APGM23+VqK9jgM8ZaRO7TSqjuP3i4Jq57dGj5tQGpiJkzZgzcY
	 zbZcBGuStNq8+JQBb8qsxRX13CbpwwuTGKsTdRJa5y3q7eQ36dt/Wp+wJXmrKh8g4o
	 VdDd4fT68mO7vMpg5RIitZTimg5/xUDHxC9Ac6h3Enl91R9JU+KTxbmx3shtvJugQ0
	 nGwRRAlD1ccLSt2c6sVBkWa41hSM5Y+deLkVeYGDiiUSnCD/2gpSkg81Xb4Ut50eG6
	 c6577mgqkwrcA==
Date: Tue, 26 Mar 2024 19:07:58 -0700
Subject: [PATCH 1/1] xfs: fix severe performance problems when fstrimming a
 subset of an AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
In-Reply-To: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 fs/xfs/xfs_discard.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 169 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 268bb734dc0a8..ee7a8759091eb 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -157,9 +157,9 @@ xfs_trim_gather_extents(
 	uint64_t		*blocks_trimmed)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
-	struct xfs_trans	*tp;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
+	struct xfs_trans	*tp;
 	int			error;
 	int			i;
 	int			batch = 100;
@@ -292,6 +292,160 @@ xfs_trim_gather_extents(
 	return error;
 }
 
+/* Trim the free space in this AG by block number. */
+static inline int
+xfs_trim_gather_bybno(
+	struct xfs_perag	*pag,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	struct xfs_alloc_rec_incore *tcur,
+	struct xfs_busy_extents	*extents,
+	uint64_t		*blocks_trimmed)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_trans	*tp;
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	xfs_daddr_t		end_daddr;
+	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agblock_t		start_agbno;
+	xfs_agblock_t		end_agbno;
+	xfs_extlen_t		minlen_fsb = XFS_BB_TO_FSB(mp, minlen);
+	int			i;
+	int			batch = 100;
+	int			error;
+
+	start = max(start, XFS_AGB_TO_DADDR(mp, agno, 0));
+	start_agbno = xfs_daddr_to_agbno(mp, start);
+
+	end_daddr = XFS_AGB_TO_DADDR(mp, agno, pag->block_count);
+	end = min(end, end_daddr - 1);
+	end_agbno = xfs_daddr_to_agbno(mp, end);
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
+	if (error)
+		goto out_trans_cancel;
+
+	cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
+
+	/*
+	 * If this is our first time, look for any extent crossing start_agbno.
+	 * Otherwise, continue at the next extent after wherever we left off.
+	 */
+	if (tcur->ar_startblock == NULLAGBLOCK) {
+		error = xfs_alloc_lookup_le(cur, start_agbno, 0, &i);
+		if (error)
+			goto out_del_cursor;
+
+		/*
+		 * If we didn't find anything at or below start_agbno,
+		 * increment the cursor to see if there's another record above
+		 * it.
+		 */
+		if (!i)
+			error = xfs_btree_increment(cur, 0, &i);
+	} else {
+		error = xfs_alloc_lookup_ge(cur, tcur->ar_startblock, 0, &i);
+	}
+	if (error)
+		goto out_del_cursor;
+	if (!i) {
+		/* nothing left in the AG, we are done */
+		tcur->ar_blockcount = 0;
+		goto out_del_cursor;
+	}
+
+	/* Loop the entire range that was asked for. */
+	while (i) {
+		xfs_agblock_t	fbno;
+		xfs_extlen_t	flen;
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			break;
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		if (--batch <= 0) {
+			/*
+			 * Update the cursor to point at this extent so we
+			 * restart the next batch from this extent.
+			 */
+			tcur->ar_startblock = fbno;
+			tcur->ar_blockcount = flen;
+			break;
+		}
+
+		/* Exit on extents entirely outside of the range. */
+		if (fbno >= end_agbno) {
+			tcur->ar_blockcount = 0;
+			break;
+		}
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
+		xfs_extent_busy_insert_discard(pag, fbno, flen,
+				&extents->extent_list);
+		*blocks_trimmed += flen;
+next_extent:
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			break;
+
+		/*
+		 * If there's no more records in the tree, we are done. Set the
+		 * cursor block count to 0 to indicate to the caller that there
+		 * are no more extents to search.
+		 */
+		if (i == 0)
+			tcur->ar_blockcount = 0;
+	}
+
+	/*
+	 * If there was an error, release all the gathered busy extents because
+	 * we aren't going to issue a discard on them any more.
+	 */
+	if (error)
+		xfs_extent_busy_clear(mp, &extents->extent_list, false);
+
+out_del_cursor:
+	xfs_btree_del_cursor(cur, error);
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
 static bool
 xfs_trim_should_stop(void)
 {
@@ -315,8 +469,15 @@ xfs_trim_extents(
 		.ar_blockcount = pag->pagf_longest,
 		.ar_startblock = NULLAGBLOCK,
 	};
+	struct xfs_mount	*mp = pag->pag_mount;
+	bool			by_len = true;
 	int			error = 0;
 
+	/* Are we only trimming part of this AG? */
+	if (start > XFS_AGB_TO_DADDR(mp, pag->pag_agno, 0) ||
+	    end < XFS_AGB_TO_DADDR(mp, pag->pag_agno, pag->block_count - 1))
+		by_len = false;
+
 	do {
 		struct xfs_busy_extents	*extents;
 
@@ -330,8 +491,13 @@ xfs_trim_extents(
 		extents->owner = extents;
 		INIT_LIST_HEAD(&extents->extent_list);
 
-		error = xfs_trim_gather_extents(pag, start, end, minlen,
-				&tcur, extents, blocks_trimmed);
+		if (by_len)
+			error = xfs_trim_gather_extents(pag, start, end,
+					minlen, &tcur, extents,
+					blocks_trimmed);
+		else
+			error = xfs_trim_gather_bybno(pag, start, end, minlen,
+					&tcur, extents, blocks_trimmed);
 		if (error) {
 			kfree(extents);
 			break;

