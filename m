Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D00FBA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJFFbqC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F42C433C8;
	Sun, 31 Dec 2023 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055319;
	bh=tSj0x0mNi4ljVjtnt2ZTdpoiIjkNWJi0+4eAbAOGNgg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HJFFbqC48BlGNe1MEKu34raNYzrbR2p2Yc/bEbJCgKAo0ilBwDV2ioUuNrUiZLmxb
	 N7pSCIm+zo5clUYED4Wb/W9IZmy9Vu7NSKUg1hohvMByRKw61knlwbx0R3f7m4k1i2
	 Q91G2ThRA/2RsHTehDwIxzHNTw6fXkiPgXyZI7lsnzz9i1JSybOM4Z8bXnD2IBR5BB
	 IVmSbNynsCOTD33UDgjGj/Gz8wn+NLxFvSetPtBoWIeUj/qbLdigBx/2qg8yNx41xE
	 NObzI5HXRwbOrc6HhDEak5JzUjTE15dJbhUlMWJg2La6XuI44OWF+n7iK1TMmAbX72
	 sreQlRmXfnYtQ==
Date: Sun, 31 Dec 2023 12:41:58 -0800
Subject: [PATCH 1/1] xfs: fix severe performance problems when fstrimming a
 subset of an AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404838409.1754382.929239865348180142.stgit@frogsfrogsfrogs>
In-Reply-To: <170404838392.1754382.3493272901639286885.stgit@frogsfrogsfrogs>
References: <170404838392.1754382.3493272901639286885.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_discard.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 2ec6b99188a28..d235f60c166c6 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -286,6 +286,154 @@ xfs_trim_gather_extents(
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
+	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
+	if (error)
+		return error;
+
+	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_BNO);
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
+	xfs_buf_relse(agbp);
+	return error;
+}
+
 static bool
 xfs_trim_should_stop(void)
 {
@@ -309,8 +457,15 @@ xfs_trim_extents(
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
 
@@ -324,8 +479,13 @@ xfs_trim_extents(
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

