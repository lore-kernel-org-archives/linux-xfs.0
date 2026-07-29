Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CB344CAC9
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319631; cv=none; b=po9ySRyWhZg6HWjzset/BNfR4uhNDUsDV6cVNZ/AeIZqRRu98S1VwHc9JX59gZEtuGWmD+3iPub/CzXwBwibhwSstolLHhm+hsQBo/W/wWYfInp9WlNOM05NpXKgmLRpzbXXSOp//UW40V0xjDhAyTCR2aUuZBHhRV5JB4fJ9SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319631; c=relaxed/simple;
	bh=6Iz1IAaieJ46/uYxnwnisaOyYrnLIcw6Ol1nmacWRIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gznpJwttEMAoD1vPaqeiWTXZCd8qFFgBFUWoj6kQpHHNQ6QRqRGAFxrLLjNT7tdEUEEJmMcHhPODieixrTuy72usinwpuz/YVsV9dWgO3K0UeG0n4rqpXhXg9Go3pd0rsyeRWXh/uF/gKpXkPyYqysmNrfDzl4kaa7uNZWr+QJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1RrHDCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1RrHDCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D9E1F00A3A;
	Wed, 29 Jul 2026 10:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319630;
	bh=q+ak6jzECc51nMPOYuPFnDxpy+hv3i5rSgYtcGof4Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1RrHDCPmUofvPfymoTqsZmD+j1c45GNiPhNQEa0zJI8FMl2fnZmXm2gCT4+PMU+N
	 0nAEjWjSogGMp5LyeV5gtH2erBJbLyI7Ud10gT7a2/m95LTmBL3ZFc+iyAh7BVY545
	 h3L80DmO5xzUYhm48UNpuAVOTSY0aR03hEyvIMpsT1ft8f/YKlH2yJiNP0W8l+DQVq
	 lpStzEBDFLd35PwwoKfNWzKtaUU0PO2C1+yigG2CjoPDOU0c1/KX0vYVS+vNYzgfK4
	 BR0U0qsg8q4Q5733q1a0sS75lAX4NjRSKQS4lY/8DgpogMv1GOlhMibSA/l0gFCNeE
	 dKiJ/N6TWs/bg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 30/33] xfs: restructure xfs_direct_write_iomap_begin with unified retry loop
Date: Wed, 29 Jul 2026 20:02:14 +1000
Message-ID: <20260729100629.1943710-31-dgc@kernel.org>
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

Replace the split COW/non-COW structure in xfs_direct_write_iomap_begin()
with a unified do {} while (dwa.tp) loop that handles both COW extent
allocation and data fork allocation atomically under a single ILOCK
hold.

The loop structure:
  - xfs_ilock_for_iomap() is called once before the loop
  - xfs_bmapi_read() at the top of each iteration reads fresh state
  - COW check calls xfs_direct_write_cow_iomap_begin() with
    needs_tp=false, which returns -EAGAIN if a transaction is needed
  - If allocation is needed (needs_alloc) but no transaction, falls
    through to alloc_trans
  - If a transaction is available, calls xfs_iomap_write_direct()
    with the transaction, commits, and returns
  - Overwrite path cancels unused tp and returns the mapping
  - alloc_trans at the tail: ASSERT(!tp), checks NOWAIT/OVERWRITE,
    drops the ILOCK, allocates a zero-block transaction via
    xfs_trans_alloc_inode() (which reacquires ILOCK_EXCL), and
    loops back to re-read the extent tree

This makes the extent lookup and allocation atomic with respect to
the ILOCK for both COW and non-COW paths.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 218 ++++++++++++++++++++++++++++-----------------
 1 file changed, 135 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b388ded20ffc..d58ecc05a4d1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1077,110 +1077,162 @@ xfs_direct_write_iomap_begin(
 	if (flags & IOMAP_ATOMIC)
 		dwa.iomap_flags |= IOMAP_F_ATOMIC_BIO;
 
-	if (xfs_is_cow_inode(ip)) {
-		error = xfs_direct_write_cow_iomap_begin(&dwa, true);
-		if (error)
-			return error;
-		if (!dwa.nimaps)
-			return 0;
-
-		end_fsb = dwa.imap.br_startoff + dwa.imap.br_blockcount;
-		dwa.length = XFS_FSB_TO_B(mp, end_fsb) - offset;
-	} else {
+	if (xfs_is_cow_inode(ip))
+		dwa.lockmode = XFS_ILOCK_EXCL;
+	else
 		dwa.lockmode = XFS_ILOCK_SHARED;
 
-		error = xfs_ilock_for_iomap(ip, flags, &dwa.lockmode);
-		if (error)
-			return error;
+	error = xfs_ilock_for_iomap(ip, flags, &dwa.lockmode);
+	if (error)
+		return error;
 
+	do {
+		dwa.nimaps = 1;
 		error = xfs_bmapi_read(ip, dwa.offset_fsb,
 				end_fsb - dwa.offset_fsb,
 				&dwa.imap, &dwa.nimaps, 0);
 		if (error)
 			goto out_unlock;
-	}
 
-	needs_alloc = imap_needs_alloc(inode, flags, &dwa.imap, dwa.nimaps);
-
-	if (flags & IOMAP_ATOMIC) {
-		error = -ENOPROTOOPT;
-		/*
-		 * If we allocate less than what is required for the write
-		 * then we may end up with multiple extents, which means that
-		 * REQ_ATOMIC-based cannot be used, so avoid this possibility.
-		 */
-		if (needs_alloc && orig_end_fsb - dwa.offset_fsb > 1)
-			goto out_unlock;
+		if (xfs_is_cow_inode(ip)) {
+			error = xfs_direct_write_cow_iomap_begin(&dwa, false);
+			if (error == -EAGAIN)
+				goto alloc_trans;
+			if (error)
+				goto out_unlock;
+			if (!dwa.nimaps) {
+				/*
+				 * COW iomaps filled in. Commit the
+				 * transaction if one was needed and
+				 * return.
+				 */
+				if (dwa.tp)
+					error = xfs_trans_commit(dwa.tp);
+				xfs_iunlock(ip, dwa.lockmode);
+				return error;
+			}
 
-		if (!xfs_bmap_hw_atomic_write_possible(ip, &dwa.imap,
-				dwa.offset_fsb, orig_end_fsb))
-			goto out_unlock;
-	}
+			end_fsb = dwa.imap.br_startoff +
+					dwa.imap.br_blockcount;
+			dwa.length = XFS_FSB_TO_B(mp, end_fsb) - offset;
+		}
 
-	if (needs_alloc)
-		goto allocate_blocks;
+		needs_alloc = imap_needs_alloc(inode, flags, &dwa.imap,
+				dwa.nimaps);
+
+		if (flags & IOMAP_ATOMIC) {
+			error = -ENOPROTOOPT;
+			/*
+			 * If we allocate less than what is required for the
+			 * write then we may end up with multiple extents,
+			 * which means that REQ_ATOMIC-based cannot be used,
+			 * so avoid this possibility.
+			 */
+			if (needs_alloc &&
+			    orig_end_fsb - dwa.offset_fsb > 1)
+				goto out_unlock;
+			if (!xfs_bmap_hw_atomic_write_possible(ip, &dwa.imap,
+					dwa.offset_fsb, orig_end_fsb))
+				goto out_unlock;
+		}
 
-	/*
-	 * NOWAIT and OVERWRITE I/O needs to span the entire requested I/O with
-	 * a single map so that we avoid partial IO failures due to the rest of
-	 * the I/O range not covered by this map triggering an EAGAIN condition
-	 * when it is subsequently mapped and aborting the I/O.
-	 */
-	if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY)) {
-		error = -EAGAIN;
-		if (!imap_spans_range(&dwa.imap, dwa.offset_fsb, end_fsb))
-			goto out_unlock;
-	}
+		if (needs_alloc) {
+			if (!dwa.tp)
+				goto alloc_trans;
+
+			/*
+			 * Cap the maximum length we map to a sane size to
+			 * keep the chunks of work done where somewhat
+			 * symmetric with the work writeback does.
+			 *
+			 * Note that the values needs to be less than
+			 * 32-bits wide until the lower level functions
+			 * are updated.
+			 */
+			dwa.length = min_t(loff_t, dwa.length,
+					1024 * PAGE_SIZE);
+			end_fsb = xfs_iomap_end_fsb(mp, offset, dwa.length);
+
+			if (offset + dwa.length > XFS_ISIZE(ip))
+				end_fsb = xfs_iomap_eof_align_last_fsb(ip,
+						end_fsb);
+			else if (dwa.nimaps &&
+				 dwa.imap.br_startblock == HOLESTARTBLOCK)
+				end_fsb = min(end_fsb, dwa.imap.br_startoff +
+						dwa.imap.br_blockcount);
+
+			dwa.count_fsb = end_fsb - dwa.offset_fsb;
+
+			error = xfs_iomap_write_direct(&dwa);
+			if (error)
+				goto out_unlock;
 
-	/*
-	 * For overwrite only I/O, we cannot convert unwritten extents without
-	 * requiring sub-block zeroing.  This can only be done under an
-	 * exclusive IOLOCK, hence return -EAGAIN if this is not a written
-	 * extent to tell the caller to try again.
-	 */
-	if (flags & IOMAP_OVERWRITE_ONLY) {
-		error = -EAGAIN;
-		if (dwa.imap.br_state != XFS_EXT_NORM &&
-		    ((offset | dwa.length) & mp->m_blockmask))
-			goto out_unlock;
-	}
+			error = xfs_trans_commit(dwa.tp);
+			xfs_iunlock(ip, dwa.lockmode);
+			return error;
+		}
 
-	seq = xfs_iomap_inode_sequence(ip, dwa.iomap_flags);
-	xfs_iunlock(ip, dwa.lockmode);
-	trace_xfs_iomap_found(ip, offset, dwa.length, XFS_DATA_FORK,
-			&dwa.imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &dwa.imap, flags,
-			dwa.iomap_flags, seq);
+		/*
+		 * Overwrite path - no allocation needed. Cancel unused
+		 * transaction if allocated and return the mapping.
+		 */
+		if (dwa.tp) {
+			xfs_trans_cancel(dwa.tp);
+			dwa.tp = NULL;
+		}
 
-allocate_blocks:
-	error = -EAGAIN;
-	if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY))
-		goto out_unlock;
+		/*
+		 * NOWAIT and OVERWRITE I/O needs to span the entire
+		 * requested I/O with a single map so that we avoid
+		 * partial IO failures due to the rest of the I/O range
+		 * not covered by this map triggering an EAGAIN condition
+		 * when it is subsequently mapped and aborting the I/O.
+		 */
+		if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY)) {
+			error = -EAGAIN;
+			if (!imap_spans_range(&dwa.imap, dwa.offset_fsb,
+					end_fsb))
+				goto out_unlock;
+		}
+		/*
+		 * For overwrite only I/O, we cannot convert unwritten
+		 * extents without requiring sub-block zeroing. This
+		 * can only be done under an exclusive IOLOCK, hence
+		 * return -EAGAIN if this is not a written extent to
+		 * tell the caller to try again.
+		 */
+		if (flags & IOMAP_OVERWRITE_ONLY) {
+			error = -EAGAIN;
+			if (dwa.imap.br_state != XFS_EXT_NORM &&
+			    ((offset | dwa.length) & mp->m_blockmask))
+				goto out_unlock;
+		}
 
-	/*
-	 * We cap the maximum length we map to a sane size  to keep the chunks
-	 * of work done where somewhat symmetric with the work writeback does.
-	 * This is a completely arbitrary number pulled out of thin air as a
-	 * best guess for initial testing.
-	 *
-	 * Note that the values needs to be less than 32-bits wide until the
-	 * lower level functions are updated.
-	 */
-	dwa.length = min_t(loff_t, dwa.length, 1024 * PAGE_SIZE);
-	end_fsb = xfs_iomap_end_fsb(mp, offset, dwa.length);
+		seq = xfs_iomap_inode_sequence(ip, dwa.iomap_flags);
+		xfs_iunlock(ip, dwa.lockmode);
+		trace_xfs_iomap_found(ip, offset, dwa.length, XFS_DATA_FORK,
+				&dwa.imap);
+		return xfs_bmbt_to_iomap(ip, iomap, &dwa.imap, flags,
+				dwa.iomap_flags, seq);
 
-	if (offset + dwa.length > XFS_ISIZE(ip))
-		end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
-	else if (dwa.nimaps && dwa.imap.br_startblock == HOLESTARTBLOCK)
-		end_fsb = min(end_fsb, dwa.imap.br_startoff +
-				dwa.imap.br_blockcount);
+alloc_trans:
+		ASSERT(!dwa.tp);
 
-	dwa.count_fsb = end_fsb - dwa.offset_fsb;
-	xfs_iunlock(ip, dwa.lockmode);
+		error = -EAGAIN;
+		if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY))
+			goto out_unlock;
 
-	return xfs_iomap_write_direct(&dwa);
+		xfs_iunlock(ip, dwa.lockmode);
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+				0, 0, false, &dwa.tp);
+		if (error)
+			return error;
+		dwa.lockmode = XFS_ILOCK_EXCL;
+	} while (dwa.tp);
 
 out_unlock:
+	if (dwa.tp)
+		xfs_trans_cancel(dwa.tp);
 	if (dwa.lockmode)
 		xfs_iunlock(ip, dwa.lockmode);
 	return error;
-- 
2.55.0

