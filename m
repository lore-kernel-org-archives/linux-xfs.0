Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770C32E06EF
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098534; cv=none; b=PjkazAlC+4OKfYVCM2YD7zzwtnxH3Pdyj8wrK6s4zPQRiVDk5fDME5qz2JzD/Vij6F3PbLu0FbacVA6mgfVcqRFVaHsdYHw8JIuJf2rur+HvFXgaPR0ZVzsa3Yn1/wFIzFccD6YExtXZ3s132/9y1UkFbp5YMLL21YuURmstP8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098534; c=relaxed/simple;
	bh=pBjC/OxL973/fFwcs+IIR1kFjjpZP94jKFHmIhoH2vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCxgc2hZBl9pbzBKMr/6THiZmz6nx89+EGbtIdQL2xsDL4wwHlocaAbkIHNKSROk4V5MSl54P+8CghLK2nE4hxwYHAJarMlKabeHF85aL4YkXYhYjWqr4R2GtQiPLJB64VKCd2++a9V52SmhWLFo/gf2Pk4AjtXPO4vOEEvUiYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTNvRZZa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTNvRZZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE341F00A3A;
	Wed, 19 Aug 2026 00:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098533;
	bh=JTi1OcbA4LY6TeVReX5jiXeAmbWZXQHfCfeBw6QzdDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTNvRZZa8wRe+KWSyBErBDGcy01B6niJQmkGSQ9ukh97PN8HScsfmNu4paCRCe8kt
	 i3cfQyPkA6zHhA/+nvcB5SEdiCeOt3/dJwy2xN1fCot4d3wmqe85Zyc6AMY/K+k+6+
	 u6pkIeTo2KrZVFSkhJq+vB+6PeAxFWVC0+X6Tn9lvQpytV2S5VpWRmwmtcqb+W+Aiy
	 rgkGjN5KEqP+X2i5BfxsbgMi7bidio7RwPsIYSdp5RPj7tCcTYYVC0aW0uJScMlx6Z
	 hEDkodkdr61ZAfdu4irxWjQKEZ1+9x6EmLYQqUSG2bEEZrUvjUSYTST+4N2/kJ2wG+
	 REoKHkezQMr4g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 35/38] xfs: restructure xfs_direct_write_iomap_begin with unified retry loop
Date: Wed, 19 Aug 2026 10:12:38 +1000
Message-ID: <20260819001442.1451892-36-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
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
index 4bf33addb3a4..77f71fdd125a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1075,110 +1075,162 @@ xfs_direct_write_iomap_begin(
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

