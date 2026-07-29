Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3D944DB64
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319630; cv=none; b=hW/zY0llgj/MqdaW4WG7d8fhTA9G/Hvow4NiZzNr65av2+AmczeTSJ43uGPxMnM0VxyV0+xVwhTG0aTCIsiZAhC+0fe7Q0eXAlHGfu+axVVd8+hsxyhINKjMf9uhyxl7qIfGhLOWT7Z42Wd3AVfgAcl0WccSeWRgtAAcDJRwLxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319630; c=relaxed/simple;
	bh=W/8a70cWA3Ln0/1EId1/jRzSsf998tB7ddY4ZYUq5ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUMFPmiIb896XQve58hJ++mnpc4DhEhq1irbvlab6PrxP2xQ4Ytz0sJA5LNM01sBSDipZpFZTswVtgdP5VgeoyNZzugT4XOp6dGn0iNFSPkW5WlbeLq+AdIKKCQk8UfW0ZfKBs7wOuoC1UGt1tfzvrdDrNO1HX82mFz46wnBq98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jO/kJ5Q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jO/kJ5Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E96C1F000E9;
	Wed, 29 Jul 2026 10:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319628;
	bh=Cg8f0KAdgMkW9zueHwMUOmK61FevI5etiHY5f6l/Io0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jO/kJ5Q7x7lklMh17lDggGSu6zrPJvJm4z04YHOxQFJowFodwsKoFTmKIUoo6Nrf8
	 GkUuwlCJ3uksSuMPmfi23S+BlvXcBP6q1qqobS0vm2rvryTfFaQeHKUZ2//F3uSH4h
	 5FNZ7p63nAd2Whd25Y9sDjdmM+HcqINjkq0eSNxXV3R3pwDBEZ6Pue5M6pBNCZRs6F
	 bhMG6BOo4KAKN8sYlf9t8yZQiPZAz2xLY7OIsf3VRRE5lWuXNBTh394wWKxKNIlafh
	 AhG/Cl+GGR3cgHKIUUdCILH5HpbpCH1YMmaZ3cQWPxQ0/gynSIV2dHIGnZX8Fh3/eU
	 cJOqBghki3Psg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 28/33] xfs: introduce struct xfs_direct_write_args for direct write call chain
Date: Wed, 29 Jul 2026 20:02:12 +1000
Message-ID: <20260729100629.1943710-29-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce struct xfs_direct_write_args to pass context through the
direct write extent allocation call chain instead of long lists of
individual parameters. The struct carries the transaction pointer,
inode, block allocation range (offset_fsb/count_fsb), IO byte range
(offset/length for tracing), iomap flags, data and COW fork extent
mappings, shared state, convert_now flag, and iomap/srcmap output
pointers.

Convert all functions in the direct write allocation chain:
xfs_iomap_write_direct(), xfs_direct_write_cow_iomap_begin(),
xfs_reflink_allocate_cow(), xfs_reflink_fill_cow_hole(), and
xfs_reflink_fill_delalloc().

xfs_direct_write_cow_iomap_begin() takes an additional bool
needs_tp parameter that controls whether the function manages
locking and transaction allocation internally (true for current
callers) or expects the caller to have already set up the
transaction and ILOCK (false, for future restructured callers).

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c   | 217 ++++++++++++++++++++++---------------------
 fs/xfs/xfs_iomap.h   |  25 ++++-
 fs/xfs/xfs_pnfs.c    |  16 +++-
 fs/xfs/xfs_reflink.c | 100 +++++++++-----------
 fs/xfs/xfs_reflink.h |   6 +-
 5 files changed, 190 insertions(+), 174 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 314a885bf9f3..ed80b23115bf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -267,17 +267,9 @@ xfs_iomap_eof_align_last_fsb(
 
 int
 xfs_iomap_write_direct(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		offset_fsb,
-	xfs_fileoff_t		count_fsb,
-	unsigned int		flags,
-	struct xfs_bmbt_irec	*imap,
-	loff_t			offset,
-	loff_t			length,
-	struct iomap		*iomap,
-	u16			iomap_flags)
+	struct xfs_direct_write_args *args)
 {
+	struct xfs_inode	*ip = args->ip;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*local_tp = NULL;
 	xfs_filblks_t		resaligned;
@@ -289,9 +281,9 @@ xfs_iomap_write_direct(
 	int			nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
 	u64			seq;
 
-	ASSERT(count_fsb > 0);
+	ASSERT(args->count_fsb > 0);
 
-	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
+	resaligned = xfs_aligned_fsb_count(args->offset_fsb, args->count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
@@ -301,7 +293,7 @@ xfs_iomap_write_direct(
 		rblocks = 0;
 	}
 
-	if (tp)
+	if (args->tp)
 		error = xfs_qm_dqattach_locked(ip, false);
 	else
 		error = xfs_qm_dqattach(ip);
@@ -321,61 +313,61 @@ xfs_iomap_write_direct(
 	 * the reserve block pool for bmbt block allocation if there is no space
 	 * left but we need to do unwritten extent conversion.
 	 */
-	if (flags & IOMAP_DAX) {
+	if (args->flags & IOMAP_DAX) {
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
-		if (imap->br_state == XFS_EXT_UNWRITTEN) {
+		if (args->imap.br_state == XFS_EXT_UNWRITTEN) {
 			force = true;
 			nr_exts = XFS_IEXT_WRITE_UNWRITTEN_CNT;
 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
 
-	if (tp) {
-		error = xfs_trans_reserve_more_inode(tp, ip, dblocks, rblocks,
-				force);
+	if (args->tp) {
+		error = xfs_trans_reserve_more_inode(args->tp, ip, dblocks,
+				rblocks, force);
 		if (error)
 			return error;
 	} else {
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
-				rblocks, force, &tp);
+				rblocks, force, &args->tp);
 		if (error)
 			return error;
-		local_tp = tp;
+		local_tp = args->tp;
 	}
 
-	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
+	error = xfs_iext_count_extend(args->tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
-	/*
-	 * From this point onwards we overwrite the imap pointer that the
-	 * caller gave to us.
-	 */
 	nimaps = 1;
-	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0,
-				imap, &nimaps);
+	error = xfs_bmapi_write(args->tp, ip, args->offset_fsb, args->count_fsb,
+				bmapi_flags, 0, &args->imap, &nimaps);
 	if (error)
 		goto out_trans_cancel;
 
-	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
+	seq = xfs_iomap_inode_sequence(ip, args->iomap_flags);
 	if (local_tp) {
-		error = xfs_trans_commit(tp);
+		error = xfs_trans_commit(args->tp);
+		args->tp = NULL;
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			return error;
-		if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
+		if (unlikely(!xfs_valid_startblock(ip,
+				args->imap.br_startblock))) {
 			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-			return xfs_alert_fsblock_zero(ip, imap);
+			return xfs_alert_fsblock_zero(ip, &args->imap);
 		}
 	}
 
-	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, imap);
-	return xfs_bmbt_to_iomap(ip, iomap, imap, flags,
-			iomap_flags | IOMAP_F_NEW, seq);
+	trace_xfs_iomap_alloc(ip, args->offset, args->length, XFS_DATA_FORK,
+			&args->imap);
+	return xfs_bmbt_to_iomap(ip, args->iomap, &args->imap, args->flags,
+			args->iomap_flags | IOMAP_F_NEW, seq);
 
 out_trans_cancel:
 	if (local_tp) {
-		xfs_trans_cancel(tp);
+		xfs_trans_cancel(args->tp);
+		args->tp = NULL;
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 	return error;
@@ -918,92 +910,72 @@ xfs_bmap_hw_atomic_write_possible(
  */
 static int
 xfs_direct_write_cow_iomap_begin(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip,
-	loff_t			offset,
-	loff_t			length,
-	unsigned		flags,
-	struct iomap		*iomap,
-	struct iomap		*srcmap,
-	struct xfs_bmbt_irec	*imap,
-	int			*nimaps,
-	unsigned int		*lockmode,
-	u16			iomap_flags)
+	struct xfs_direct_write_args *args,
+	bool			needs_tp)
 {
+	struct xfs_inode	*ip = args->ip;
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	cmap;
-	struct xfs_trans	*tp = NULL;
 	struct xfs_trans	*local_tp = NULL;
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
-	bool			shared = false;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, args->offset);
+	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, args->offset,
+					args->length);
 	int			error;
 	u64			seq;
 
-	if (!tpp) {
-		*lockmode = XFS_ILOCK_EXCL;
+	if (needs_tp) {
+		args->lockmode = XFS_ILOCK_EXCL;
 
-		error = xfs_ilock_for_iomap(ip, flags, lockmode);
+		error = xfs_ilock_for_iomap(ip, args->flags, &args->lockmode);
 		if (error)
 			return error;
 
 retry:
-		*nimaps = 1;
-		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, imap,
-				       nimaps, 0);
+		args->nimaps = 1;
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				&args->imap, &args->nimaps, 0);
 		if (error)
 			goto out_unlock;
-	} else if (*tpp) {
-		tp = *tpp;
 	}
 
-	if (!imap_needs_cow(ip, flags, imap, *nimaps)) {
-		/*
-		 * Extent is not shared - return the imap and ILOCK to the
-		 * caller for normal IO path processing.
-		 */
-		if (local_tp)
+	if (!imap_needs_cow(ip, args->flags, &args->imap, args->nimaps)) {
+		if (local_tp) {
 			xfs_trans_cancel(local_tp);
+			args->tp = NULL;
+		}
 		return 0;
 	}
 
 	error = -EAGAIN;
-	if (flags & IOMAP_NOWAIT)
+	if (args->flags & IOMAP_NOWAIT)
 		goto out_unlock;
 
-	error = xfs_reflink_allocate_cow(&tp, ip, imap, &cmap, &shared,
-			lockmode,
-			(flags & IOMAP_DIRECT) || IS_DAX(VFS_I(ip)));
+	error = xfs_reflink_allocate_cow(args);
 	if (error == -EAGAIN) {
-		ASSERT(!tp);
+		ASSERT(!args->tp);
 
-		/*
-		 * If the caller can handle the retry, return -EAGAIN so
-		 * they can allocate a transaction and call again.
-		 */
-		if (tpp)
+		if (!needs_tp)
 			goto out_unlock;
 
 		/*
-		 * Otherwise handle the retry internally. Drop the ILOCK and
-		 * allocate a zero-block reservation transaction, which will
-		 * re-acquire the ILOCK. We cannot determine what extent type
-		 * will be found once we've regained the ILOCK, so the callees
-		 * will use xfs_trans_reserve_more_inode() directly to reserve
-		 * any blocks they require before they start modifications.
-		 * This allows ENOSPC to be returned and the transaction
-		 * cancelled safely if the block reservation cannot be made.
+		 * Handle the retry internally. Drop the ILOCK and allocate a
+		 * zero-block reservation transaction, which will re-acquire
+		 * the ILOCK. We cannot determine what extent type will be
+		 * found once we've regained the ILOCK, so the callees will
+		 * use xfs_trans_reserve_more_inode() directly to reserve any
+		 * blocks they require before they start modifications. This
+		 * allows ENOSPC to be returned and the transaction cancelled
+		 * safely if the block reservation cannot be made.
 		 *
 		 * Retry the imap lookup since the extent tree may have changed
 		 * while the ILOCK was not held.
 		 */
-		xfs_iunlock(ip, *lockmode);
+		xfs_iunlock(ip, args->lockmode);
 
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
-				0, 0, false, &tp);
+				0, 0, false, &args->tp);
 		if (error)
 			return error;
-		local_tp = tp;
+		local_tp = args->tp;
 
 		goto retry;
 	}
@@ -1012,16 +984,16 @@ xfs_direct_write_cow_iomap_begin(
 
 	if (local_tp) {
 		error = xfs_trans_commit(local_tp);
-		tp = NULL;
+		args->tp = NULL;
 		if (error)
 			goto out_unlock;
 	}
 
-	if (!shared)
+	if (!args->shared)
 		return 0;
 
-	if ((flags & IOMAP_ATOMIC) &&
-	    !xfs_bmap_hw_atomic_write_possible(ip, &cmap,
+	if ((args->flags & IOMAP_ATOMIC) &&
+	    !xfs_bmap_hw_atomic_write_possible(ip, &args->cmap,
 			offset_fsb, end_fsb)) {
 		error = -ENOPROTOOPT;
 		goto out_unlock;
@@ -1031,26 +1003,31 @@ xfs_direct_write_cow_iomap_begin(
 	 * COW extent found and allocated. Set up iomap/srcmap and return
 	 * with *nimaps = 0 to tell the caller the COW path is complete.
 	 */
-	*nimaps = 0;
-	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
-	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK,
-			&cmap);
-	if (imap->br_startblock != HOLESTARTBLOCK) {
+	args->nimaps = 0;
+	args->length = XFS_FSB_TO_B(mp,
+			args->cmap.br_startoff + args->cmap.br_blockcount);
+	trace_xfs_iomap_found(ip, args->offset,
+			args->length - args->offset, XFS_COW_FORK,
+			&args->cmap);
+	if (args->imap.br_startblock != HOLESTARTBLOCK) {
 		seq = xfs_iomap_inode_sequence(ip, 0);
-		error = xfs_bmbt_to_iomap(ip, srcmap, imap, flags, 0, seq);
+		error = xfs_bmbt_to_iomap(ip, args->srcmap, &args->imap,
+				args->flags, 0, seq);
 		if (error)
 			goto out_unlock;
 	}
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-	if (!tpp)
-		xfs_iunlock(ip, *lockmode);
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
+	if (needs_tp)
+		xfs_iunlock(ip, args->lockmode);
+	return xfs_bmbt_to_iomap(ip, args->iomap, &args->cmap, args->flags,
+			IOMAP_F_SHARED, seq);
 
 out_unlock:
 	if (local_tp) {
-		if (tp)
+		if (args->tp)
 			xfs_trans_cancel(local_tp);
-		xfs_iunlock(ip, *lockmode);
+		args->tp = NULL;
+		xfs_iunlock(ip, args->lockmode);
 	}
 	return error;
 }
@@ -1094,14 +1071,26 @@ xfs_direct_write_iomap_begin(
 		iomap_flags |= IOMAP_F_ATOMIC_BIO;
 
 	if (xfs_is_cow_inode(ip)) {
-		error = xfs_direct_write_cow_iomap_begin(NULL, ip, offset,
-				length, flags, iomap, srcmap, &imap,
-				&nimaps, &lockmode, iomap_flags);
+		struct xfs_direct_write_args cow_args = {
+			.ip		= ip,
+			.offset		= offset,
+			.length		= length,
+			.flags		= flags,
+			.iomap_flags	= iomap_flags,
+			.convert_now	= (flags & IOMAP_DIRECT) ||
+					  IS_DAX(inode),
+			.iomap		= iomap,
+			.srcmap		= srcmap,
+		};
+
+		error = xfs_direct_write_cow_iomap_begin(&cow_args, true);
 		if (error)
 			return error;
-		if (!nimaps)
+		if (!cow_args.nimaps)
 			return 0;
 
+		imap = cow_args.imap;
+		lockmode = cow_args.lockmode;
 		end_fsb = imap.br_startoff + imap.br_blockcount;
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
 	} else {
@@ -1190,9 +1179,21 @@ xfs_direct_write_iomap_begin(
 		end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
 	xfs_iunlock(ip, lockmode);
 
-	return xfs_iomap_write_direct(NULL, ip, offset_fsb,
-			end_fsb - offset_fsb, flags, &imap,
-			offset, length, iomap, iomap_flags);
+	{
+		struct xfs_direct_write_args args = {
+			.ip		= ip,
+			.offset_fsb	= offset_fsb,
+			.count_fsb	= end_fsb - offset_fsb,
+			.offset		= offset,
+			.length		= length,
+			.flags		= flags,
+			.iomap_flags	= iomap_flags,
+			.imap		= imap,
+			.iomap		= iomap,
+		};
+
+		return xfs_iomap_write_direct(&args);
+	}
 
 out_unlock:
 	if (lockmode)
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index c883a7175cd0..7dc0b5993bed 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -12,11 +12,26 @@ struct xfs_inode;
 struct xfs_bmbt_irec;
 struct xfs_zone_alloc_ctx;
 
-int xfs_iomap_write_direct(struct xfs_trans *tp, struct xfs_inode *ip,
-		xfs_fileoff_t offset_fsb, xfs_fileoff_t count_fsb,
-		unsigned int flags, struct xfs_bmbt_irec *imap,
-		loff_t offset, loff_t length, struct iomap *iomap,
-		u16 iomap_flags);
+struct xfs_direct_write_args {
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	xfs_fileoff_t		offset_fsb;	/* block range to allocate */
+	xfs_fileoff_t		count_fsb;
+	loff_t			offset;		/* IO byte range for tracing */
+	loff_t			length;
+	unsigned int		flags;
+	u16			iomap_flags;
+	unsigned int		lockmode;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_bmbt_irec	cmap;
+	int			nimaps;
+	bool			shared;
+	bool			convert_now;
+	struct iomap		*iomap;
+	struct iomap		*srcmap;
+};
+
+int xfs_iomap_write_direct(struct xfs_direct_write_args *args);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f9c0e748448e..495e081838d0 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -200,9 +200,19 @@ xfs_fs_map_blocks(
 					       imap.br_blockcount);
 		xfs_iunlock(ip, lock_flags);
 
-		error = xfs_iomap_write_direct(NULL, ip, offset_fsb,
-				end_fsb - offset_fsb, 0, &imap,
-				offset, length, iomap, 0);
+		{
+			struct xfs_direct_write_args args = {
+				.ip		= ip,
+				.offset_fsb	= offset_fsb,
+				.count_fsb	= end_fsb - offset_fsb,
+				.offset		= offset,
+				.length		= length,
+				.imap		= imap,
+				.iomap		= iomap,
+			};
+
+			error = xfs_iomap_write_direct(&args);
+		}
 		if (error)
 			goto out_unlock;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 597300f39611..f0dcc66c91ec 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -430,13 +430,9 @@ xfs_reflink_convert_unwritten(
 
 static int
 xfs_reflink_fill_cow_hole(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*imap,
-	struct xfs_bmbt_irec	*cmap,
-	bool			*shared,
-	bool			convert_now)
+	struct xfs_direct_write_args *args)
 {
+	struct xfs_inode	*ip = args->ip;
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_filblks_t		resaligned;
 	unsigned int		dblocks = 0, rblocks = 0;
@@ -444,10 +440,11 @@ xfs_reflink_fill_cow_hole(
 	int			error;
 	bool			found;
 
-	ASSERT(*tpp);
+	ASSERT(args->tp);
 
-	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
-	if (error || !*shared)
+	error = xfs_find_trim_cow_extent(ip, &args->imap, &args->cmap,
+			&args->shared, &found);
+	if (error || !args->shared)
 		return error;
 
 	if (found)
@@ -460,10 +457,10 @@ xfs_reflink_fill_cow_hole(
 	 * state was known under the ILOCK. The transaction has not been
 	 * dirtied yet, so on ENOSPC it can safely be cancelled by the caller.
 	 */
-	ASSERT(!((*tpp)->t_flags & XFS_TRANS_DIRTY));
+	ASSERT(!(args->tp->t_flags & XFS_TRANS_DIRTY));
 
-	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
-			imap->br_blockcount, xfs_get_cowextsz_hint(ip));
+	resaligned = xfs_aligned_fsb_count(args->imap.br_startoff,
+			args->imap.br_blockcount, xfs_get_cowextsz_hint(ip));
 	if (XFS_IS_REALTIME_INODE(ip)) {
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 		rblocks = resaligned;
@@ -471,36 +468,33 @@ xfs_reflink_fill_cow_hole(
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 	}
 
-	error = xfs_trans_reserve_more_inode(*tpp, ip, dblocks, rblocks,
+	error = xfs_trans_reserve_more_inode(args->tp, ip, dblocks, rblocks,
 			false);
 	if (error)
 		return error;
 
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
-	error = xfs_bmapi_write(*tpp, ip, imap->br_startoff,
-			imap->br_blockcount,
-			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
-			&nimaps);
+	error = xfs_bmapi_write(args->tp, ip, args->imap.br_startoff,
+			args->imap.br_blockcount,
+			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0,
+			&args->cmap, &nimaps);
 	if (error)
 		return error;
 
 	xfs_inode_set_cowblocks_tag(ip);
 
 convert:
-	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
+	return xfs_reflink_convert_unwritten(ip, &args->imap, &args->cmap,
+			args->convert_now);
 }
 
 static int
 xfs_reflink_fill_delalloc(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*imap,
-	struct xfs_bmbt_irec	*cmap,
-	bool			*shared,
-	bool			convert_now)
+	struct xfs_direct_write_args *args)
 {
-	struct xfs_trans	*tp = *tpp;
+	struct xfs_inode	*ip = args->ip;
+	struct xfs_trans	*tp = args->tp;
 	int			nimaps;
 	int			error;
 	bool			found;
@@ -508,25 +502,25 @@ xfs_reflink_fill_delalloc(
 	ASSERT(tp);
 
 	do {
-		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
-				&found);
-		if (error || !*shared)
+		error = xfs_find_trim_cow_extent(ip, &args->imap, &args->cmap,
+				&args->shared, &found);
+		if (error || !args->shared)
 			goto out_error;
 
 		if (found)
 			break;
 
-		ASSERT(isnullstartblock(cmap->br_startblock) ||
-		       cmap->br_startblock == DELAYSTARTBLOCK);
+		ASSERT(isnullstartblock(args->cmap.br_startblock) ||
+		       args->cmap.br_startblock == DELAYSTARTBLOCK);
 
 		/*
 		 * Replace delalloc reservation with an unwritten extent.
 		 */
 		nimaps = 1;
-		error = xfs_bmapi_write(tp, ip, cmap->br_startoff,
-				cmap->br_blockcount,
+		error = xfs_bmapi_write(tp, ip, args->cmap.br_startoff,
+				args->cmap.br_blockcount,
 				XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0,
-				cmap, &nimaps);
+				&args->cmap, &nimaps);
 		if (error)
 			goto out_error;
 
@@ -535,25 +529,22 @@ xfs_reflink_fill_delalloc(
 		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_error;
-	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
+	} while (args->cmap.br_startoff + args->cmap.br_blockcount <=
+			args->imap.br_startoff);
 
-	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
+	error = xfs_reflink_convert_unwritten(ip, &args->imap, &args->cmap,
+			args->convert_now);
 out_error:
-	*tpp = tp;
+	args->tp = tp;
 	return error;
 }
 
 /* Allocate all CoW reservations covering a range of blocks in a file. */
 int
 xfs_reflink_allocate_cow(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*imap,
-	struct xfs_bmbt_irec	*cmap,
-	bool			*shared,
-	uint			*lockmode,
-	bool			convert_now)
+	struct xfs_direct_write_args *args)
 {
+	struct xfs_inode	*ip = args->ip;
 	int			error;
 	bool			found;
 
@@ -563,34 +554,33 @@ xfs_reflink_allocate_cow(
 		xfs_ifork_init_cow(ip);
 	}
 
-	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
-	if (error || !*shared)
+	error = xfs_find_trim_cow_extent(ip, &args->imap, &args->cmap,
+			&args->shared, &found);
+	if (error || !args->shared)
 		return error;
 
 	/* CoW fork has a real extent */
 	if (found)
-		return xfs_reflink_convert_unwritten(ip, imap, cmap,
-				convert_now);
+		return xfs_reflink_convert_unwritten(ip, &args->imap,
+				&args->cmap, args->convert_now);
 
 	/*
 	 * Allocation is now required, so we need a transaction context from
 	 * the caller if it hasn't already supplied one.
 	 */
-	if (!*tpp)
+	if (!args->tp)
 		return -EAGAIN;
 
-	if (cmap->br_startoff > imap->br_startoff)
-		return xfs_reflink_fill_cow_hole(tpp, ip, imap, cmap, shared,
-				convert_now);
+	if (args->cmap.br_startoff > args->imap.br_startoff)
+		return xfs_reflink_fill_cow_hole(args);
 
 	/*
 	 * CoW fork has a delalloc reservation. Replace it with a real extent.
 	 * There may or may not be a data fork mapping.
 	 */
-	if (isnullstartblock(cmap->br_startblock) ||
-	    cmap->br_startblock == DELAYSTARTBLOCK)
-		return xfs_reflink_fill_delalloc(tpp, ip, imap, cmap, shared,
-				convert_now);
+	if (isnullstartblock(args->cmap.br_startblock) ||
+	    args->cmap.br_startblock == DELAYSTARTBLOCK)
+		return xfs_reflink_fill_delalloc(args);
 
 	/* Shouldn't get here. */
 	ASSERT(0);
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 3da8374829c3..57c8a9a018bd 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+struct xfs_direct_write_args;
+
 /*
  * Check whether it is safe to free COW fork blocks from an inode. It is unsafe
  * to do so when an inode has dirty cache or I/O in-flight, even if no shared
@@ -30,9 +32,7 @@ int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
 		bool *shared);
 
-int xfs_reflink_allocate_cow(struct xfs_trans **tpp, struct xfs_inode *ip,
-		struct xfs_bmbt_irec *imap, struct xfs_bmbt_irec *cmap,
-		bool *shared, uint *lockmode, bool convert_now);
+int xfs_reflink_allocate_cow(struct xfs_direct_write_args *args);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 int xfs_reflink_convert_cow_locked(struct xfs_inode *ip,
-- 
2.55.0

