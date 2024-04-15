Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC33D2E852
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225387; cv=none; b=G6eBo/3Wo0pYmJ3Z69yQ105NPIMadVXt+ZJOotfxi+GI+d0TmL7EUctoAwshMWXTbNa/sxJxNqFyNh8oFDYPGAPZcXcogbfugReUYZU4j8XbIBJBkDjpbXrDCFVQPzD4RPsFppu2j5MgyKlS+FZav6U9pLQHawsLnJuFRZgCWTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225387; c=relaxed/simple;
	bh=CybGthTsPxukKaxOBOKvKYgiMZ9Qa3d3g7X/oP+wTPI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iMeJmw2x7w0tlps4ftzFhnsHcRlS0810rsZKhgfn3NGPD7MmdNrTa3j1p/Q2gRPQZS8OfoTxgnYbqWxy4+7jzLa6pF3cjiRPTjEMlWcIksjxkKMEMH2ez1yc2qgnTrgVk/Eydbj7vgxoyEnQJht1BzB04RsZPbReThByXb4q4ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qc5HGtzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qc5HGtzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DB6C113CC;
	Mon, 15 Apr 2024 23:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225386;
	bh=CybGthTsPxukKaxOBOKvKYgiMZ9Qa3d3g7X/oP+wTPI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qc5HGtzds0h6gKigvNLsQyp/DSjXDw/fFJm4Y/5kOtosxbQQEaULrPtu3kblXZjLR
	 GnG3M5gtAZfDcTPdf74s4hxHBHvz+9QGjKaKk1J3tP5lRrXKMIO3TN7rQIVUzXyGi7
	 5lmBqbpfEo2KF8fyLNCEbjMfDa9gqSVxTGI4ddoTISKxf3fJExec7zQs+79q9bL06z
	 XOCM4A4CjJr3z5ZnWRkMldHRbIcAEyICIpIu9GlKO6Iiaq2jkxAoJT0FT2Trj1u4bV
	 WrAK+KUyNdjy05gjORjqjmqy4BTaFjQ6IVzn/1REWXufH+6vL7ASPkIlmJbQZtEww1
	 sW8C8dOZSNcFw==
Date: Mon, 15 Apr 2024 16:56:26 -0700
Subject: [PATCH 1/1] xfs: fix performance problems when fstrimming a subset of
 a fragmented AG
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171322385788.91801.9266824102480292155.stgit@frogsfrogsfrogs>
In-Reply-To: <171322385769.91801.8743955175385878183.stgit@frogsfrogsfrogs>
References: <171322385769.91801.8743955175385878183.stgit@frogsfrogsfrogs>
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

On a 10TB filesystem where the free space in each AG is heavily
fragmented, I noticed some very high runtimes on a FITRIM call for the
entire filesystem.  xfs_scrub likes to report progress information on
each phase of the scrub, which means that a strace for the entire
filesystem:

ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>

shows that scrub is uncommunicative for the entire duration.  Reducing
the size of the FITRIM requests to a single AG at a time produces lower
times for each individual call, but even this isn't quite acceptable,
because the time between progress reports are still very high:

Strace for the first 4x 1TB AGs looks like (2):
ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>

I then had the idea to limit the length parameter of each call to a
smallish amount (~11GB) so that we could report progress relatively
quickly, but much to my surprise, each FITRIM call still took ~68
seconds!

Unfortunately, the by-length fstrim implementation handles this poorly
because it walks the entire free space by length index (cntbt), which is
a very inefficient way to walk a subset of the blocks of an AG.

Therefore, create a second implementation that will walk the bnobt and
perform the trims in block number order.  This implementation avoids the
worst problems of the original code, though it lacks the desirable
attribute of freeing the biggest chunks first.

On the other hand, this second implementation will be much easier to
constrain the system call latency, and makes it much easier to report
fstrim progress to anyone who's running xfs_scrub.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com
---
 fs/xfs/xfs_discard.c |  153 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 93 insertions(+), 60 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 268bb734dc0a..25fe3b932b5a 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -145,14 +145,18 @@ xfs_discard_extents(
 	return error;
 }
 
+struct xfs_trim_cur {
+	xfs_agblock_t	start;
+	xfs_extlen_t	count;
+	xfs_agblock_t	end;
+	xfs_extlen_t	minlen;
+	bool		by_bno;
+};
 
 static int
 xfs_trim_gather_extents(
 	struct xfs_perag	*pag,
-	xfs_daddr_t		start,
-	xfs_daddr_t		end,
-	xfs_daddr_t		minlen,
-	struct xfs_alloc_rec_incore *tcur,
+	struct xfs_trim_cur	*tcur,
 	struct xfs_busy_extents	*extents,
 	uint64_t		*blocks_trimmed)
 {
@@ -179,21 +183,26 @@ xfs_trim_gather_extents(
 	if (error)
 		goto out_trans_cancel;
 
-	cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-
-	/*
-	 * Look up the extent length requested in the AGF and start with it.
-	 */
-	if (tcur->ar_startblock == NULLAGBLOCK)
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
-	else
-		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
-				tcur->ar_blockcount, &i);
+	if (tcur->by_bno) {
+		/* sub-AG discard request always starts at tcur->start */
+		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
+		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
+		if (!error && !i)
+			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
+	} else if (tcur->start == 0) {
+		/* first time through a by-len starts with max length */
+		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
+		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
+	} else {
+		/* nth time through a by-len starts where we left off */
+		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
+		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
+	}
 	if (error)
 		goto out_del_cursor;
 	if (i == 0) {
 		/* nothing of that length left in the AG, we are done */
-		tcur->ar_blockcount = 0;
+		tcur->count = 0;
 		goto out_del_cursor;
 	}
 
@@ -204,8 +213,6 @@ xfs_trim_gather_extents(
 	while (i) {
 		xfs_agblock_t	fbno;
 		xfs_extlen_t	flen;
-		xfs_daddr_t	dbno;
-		xfs_extlen_t	dlen;
 
 		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
 		if (error)
@@ -221,37 +228,45 @@ xfs_trim_gather_extents(
 			 * Update the cursor to point at this extent so we
 			 * restart the next batch from this extent.
 			 */
-			tcur->ar_startblock = fbno;
-			tcur->ar_blockcount = flen;
-			break;
-		}
-
-		/*
-		 * use daddr format for all range/len calculations as that is
-		 * the format the range/len variables are supplied in by
-		 * userspace.
-		 */
-		dbno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, fbno);
-		dlen = XFS_FSB_TO_BB(mp, flen);
-
-		/*
-		 * Too small?  Give up.
-		 */
-		if (dlen < minlen) {
-			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
-			tcur->ar_blockcount = 0;
+			tcur->start = fbno;
+			tcur->count = flen;
 			break;
 		}
 
 		/*
 		 * If the extent is entirely outside of the range we are
-		 * supposed to discard skip it.  Do not bother to trim
-		 * down partially overlapping ranges for now.
+		 * supposed to skip it.  Do not bother to trim down partially
+		 * overlapping ranges for now.
 		 */
-		if (dbno + dlen < start || dbno > end) {
+		if (fbno + flen < tcur->start) {
 			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
+		if (fbno > tcur->end) {
+			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
+			if (tcur->by_bno) {
+				tcur->count = 0;
+				break;
+			}
+			goto next_extent;
+		}
+
+		/* Trim the extent returned to the range we want. */
+		if (fbno < tcur->start) {
+			flen -= tcur->start - fbno;
+			fbno = tcur->start;
+		}
+		if (fbno + flen > tcur->end + 1)
+			flen = tcur->end - fbno + 1;
+
+		/* Too small?  Give up. */
+		if (flen < tcur->minlen) {
+			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			if (tcur->by_bno)
+				goto next_extent;
+			tcur->count = 0;
+			break;
+		}
 
 		/*
 		 * If any blocks in the range are still busy, skip the
@@ -266,7 +281,10 @@ xfs_trim_gather_extents(
 				&extents->extent_list);
 		*blocks_trimmed += flen;
 next_extent:
-		error = xfs_btree_decrement(cur, 0, &i);
+		if (tcur->by_bno)
+			error = xfs_btree_increment(cur, 0, &i);
+		else
+			error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			break;
 
@@ -276,7 +294,7 @@ xfs_trim_gather_extents(
 		 * is no more extents to search.
 		 */
 		if (i == 0)
-			tcur->ar_blockcount = 0;
+			tcur->count = 0;
 	}
 
 	/*
@@ -306,17 +324,22 @@ xfs_trim_should_stop(void)
 static int
 xfs_trim_extents(
 	struct xfs_perag	*pag,
-	xfs_daddr_t		start,
-	xfs_daddr_t		end,
-	xfs_daddr_t		minlen,
+	xfs_agblock_t		start,
+	xfs_agblock_t		end,
+	xfs_extlen_t		minlen,
 	uint64_t		*blocks_trimmed)
 {
-	struct xfs_alloc_rec_incore tcur = {
-		.ar_blockcount = pag->pagf_longest,
-		.ar_startblock = NULLAGBLOCK,
+	struct xfs_trim_cur	tcur = {
+		.start		= start,
+		.count		= pag->pagf_longest,
+		.end		= end,
+		.minlen		= minlen,
 	};
 	int			error = 0;
 
+	if (start != 0 || end != pag->block_count)
+		tcur.by_bno = true;
+
 	do {
 		struct xfs_busy_extents	*extents;
 
@@ -330,8 +353,8 @@ xfs_trim_extents(
 		extents->owner = extents;
 		INIT_LIST_HEAD(&extents->extent_list);
 
-		error = xfs_trim_gather_extents(pag, start, end, minlen,
-				&tcur, extents, blocks_trimmed);
+		error = xfs_trim_gather_extents(pag, &tcur, extents,
+				blocks_trimmed);
 		if (error) {
 			kfree(extents);
 			break;
@@ -354,7 +377,7 @@ xfs_trim_extents(
 		if (xfs_trim_should_stop())
 			break;
 
-	} while (tcur.ar_blockcount != 0);
+	} while (tcur.count != 0);
 
 	return error;
 
@@ -378,8 +401,10 @@ xfs_ioc_trim(
 	unsigned int		granularity =
 		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
 	struct fstrim_range	range;
-	xfs_daddr_t		start, end, minlen;
-	xfs_agnumber_t		agno;
+	xfs_daddr_t		start, end;
+	xfs_extlen_t		minlen;
+	xfs_agnumber_t		start_agno, end_agno;
+	xfs_agblock_t		start_agbno, end_agbno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
@@ -399,7 +424,8 @@ xfs_ioc_trim(
 		return -EFAULT;
 
 	range.minlen = max_t(u64, granularity, range.minlen);
-	minlen = BTOBB(range.minlen);
+	minlen = XFS_B_TO_FSB(mp, range.minlen);
+
 	/*
 	 * Truncating down the len isn't actually quite correct, but using
 	 * BBTOB would mean we trivially get overflows for values
@@ -413,15 +439,21 @@ xfs_ioc_trim(
 		return -EINVAL;
 
 	start = BTOBB(range.start);
-	end = start + BTOBBT(range.len) - 1;
+	end = min_t(xfs_daddr_t, start + BTOBBT(range.len),
+		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) - 1;
 
-	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
+	start_agno = xfs_daddr_to_agno(mp, start);
+	start_agbno = xfs_daddr_to_agbno(mp, start);
+	end_agno = xfs_daddr_to_agno(mp, end);
+	end_agbno = xfs_daddr_to_agbno(mp, end);
 
-	agno = xfs_daddr_to_agno(mp, start);
-	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
-		error = xfs_trim_extents(pag, start, end, minlen,
-					  &blocks_trimmed);
+	for_each_perag_range(mp, start_agno, end_agno, pag) {
+		xfs_agblock_t	agend = pag->block_count;
+
+		if (start_agno == end_agno)
+			agend = end_agbno;
+		error = xfs_trim_extents(pag, start_agbno, agend, minlen,
+				&blocks_trimmed);
 		if (error)
 			last_error = error;
 
@@ -429,6 +461,7 @@ xfs_ioc_trim(
 			xfs_perag_rele(pag);
 			break;
 		}
+		start_agbno = 0;
 	}
 
 	if (last_error)

