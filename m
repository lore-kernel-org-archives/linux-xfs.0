Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0953144D020
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319633; cv=none; b=P9wyOrJmdOawhTJs1L8frsSrlJfIuUDxcA5tWkw7X9QRDc5Ooe2VtWmKOH9FHSN/Yb2L/UIIgR1OHfToV7LqMu5qH/9GekZpb4dl5ugTk4UR8EQbGIOlYCwGpVgWdBz7pyWhX8L6Y8QobWVTlmgsD2WRZ1E2fzy9J0WIS8fnp8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319633; c=relaxed/simple;
	bh=rxQz98OGMz3r0An7czblqIMaqA+aY83V8uA9mPbaHX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5B5PDSsqeR8YRhTvrg34y5CmpMIPAZzhw0ZApxUocQOG/zYCOZAXpA5MAKEUAyyGBJHEHDPyxmOTIch6k49QwTuWhkSSQJW/Rk0Bn4jhzSyVuFvPc3CmK9gS0GnjiF13SuhimiOLqyl9glbugQ1oFi/jja9jpMWwAwxbziAKRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7OBAhFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7OBAhFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC8F1F000E9;
	Wed, 29 Jul 2026 10:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319631;
	bh=AvIG8zn+E/E7f6GA/f5ZboRnKgz9DNBlWZVFTJL3U8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7OBAhFvJ45ohwzSthn/gLQLpKP/RH9bAc9+RpvvHJSmb1ZcSJ8UGW1o/zocbHi7G
	 2rQiOBkG446OsRsTKWACyPf3QpP8NvslMgWat8nnE9e9lc6T4grS9MG5fSxAomA93Z
	 GW3mKu+ZyOdzGk84p368s4+Rwi43sEFMhLCVyyyJWTB2bwzxZs5bfHpHWm5N7xmZkw
	 n4iVoU6jelr7q1fnOUIg+E7TkgAFscxBIgk7XkdqgQmbdfWsG6qOjk51/tyY+k9FTW
	 /N88zUg91nlCGVfwY8rNnlq9+bRTxzNAW8tDtU0cP7dFNWUJMvPgLJvISbeVCLGHTr
	 QJgKt4OBRUaKQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 31/33] xfs: clean up xfs_direct_write_cow_iomap_begin after restructure
Date: Wed, 29 Jul 2026 20:02:15 +1000
Message-ID: <20260729100629.1943710-32-dgc@kernel.org>
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

Now that xfs_direct_write_iomap_begin() handles all locking,
transaction allocation, extent reading, and retry logic, clean up
xfs_direct_write_cow_iomap_begin() to remove the dead transitional
code.

Remove the needs_tp parameter and all the internal lock management,
transaction allocation, retry loop, and local_tp handling. The
function now assumes the caller holds the ILOCK and has already
determined that COW is needed via imap_needs_cow().

Lift the imap_needs_cow() check from cow_iomap_begin up to
xfs_direct_write_iomap_begin(), replacing the xfs_is_cow_inode()
check after the xfs_bmapi_read(). This is safe because
imap_needs_cow() checks xfs_is_cow_inode() internally as its first
test.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 115 +++++++--------------------------------------
 1 file changed, 16 insertions(+), 99 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d58ecc05a4d1..4b2860e80d9f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -892,116 +892,44 @@ xfs_bmap_hw_atomic_write_possible(
 
 /*
  * Handle COW extent allocation and iomap setup for direct writes to reflinked
- * files.
+ * files. The caller holds the ILOCK and has already determined that COW is
+ * needed via imap_needs_cow().
  *
- * Transitional tpp handling:
- *	!tpp = do everything internally using local_tp
- *	tpp & !*tpp = caller did locking, wants -EAGAIN if transaction required
- *	tpp && *tpp = caller did locking and transaction allocation
+ * On return, args->nimaps indicates what the caller should do next:
+ *   nimaps == 0: COW was handled, iomap/srcmap are filled in.
+ *                Caller should commit args->tp, unlock, and return.
+ *   nimaps > 0:  Extent is not shared. Caller should continue with the
+ *                normal IO path using the imap.
  *
- * The caller passes in an imap and nimaps that the COW allocation will fill
- * with the data fork extent mapping. On return, *nimaps indicates whether the
- * caller needs to continue with the normal IO path:
- *
- *   *nimaps == 0: COW was handled, iomap/srcmap are filled in, ILOCK released.
- *                 Caller should return 0 immediately.
- *   *nimaps > 0:  Extent is not shared, imap is valid, ILOCK is still held.
- *                 Caller should continue with the normal IO path.
+ * Returns -EAGAIN if a transaction is needed but args->tp is NULL.
  */
 static int
 xfs_direct_write_cow_iomap_begin(
-	struct xfs_direct_write_args *args,
-	bool			needs_tp)
+	struct xfs_direct_write_args *args)
 {
 	struct xfs_inode	*ip = args->ip;
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*local_tp = NULL;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, args->offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, args->offset,
 					args->length);
 	int			error;
 	u64			seq;
 
-	if (needs_tp) {
-		args->lockmode = XFS_ILOCK_EXCL;
-
-		error = xfs_ilock_for_iomap(ip, args->flags, &args->lockmode);
-		if (error)
-			return error;
-
-retry:
-		args->nimaps = 1;
-		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&args->imap, &args->nimaps, 0);
-		if (error)
-			goto out_unlock;
-	}
-
-	if (!imap_needs_cow(ip, args->flags, &args->imap, args->nimaps)) {
-		if (local_tp) {
-			xfs_trans_cancel(local_tp);
-			args->tp = NULL;
-		}
-		return 0;
-	}
-
-	error = -EAGAIN;
-	if (args->flags & IOMAP_NOWAIT)
-		goto out_unlock;
-
 	error = xfs_reflink_allocate_cow(args);
-	if (error == -EAGAIN) {
-		ASSERT(!args->tp);
-
-		if (!needs_tp)
-			goto out_unlock;
-
-		/*
-		 * Handle the retry internally. Drop the ILOCK and allocate a
-		 * zero-block reservation transaction, which will re-acquire
-		 * the ILOCK. We cannot determine what extent type will be
-		 * found once we've regained the ILOCK, so the callees will
-		 * use xfs_trans_reserve_more_inode() directly to reserve any
-		 * blocks they require before they start modifications. This
-		 * allows ENOSPC to be returned and the transaction cancelled
-		 * safely if the block reservation cannot be made.
-		 *
-		 * Retry the imap lookup since the extent tree may have changed
-		 * while the ILOCK was not held.
-		 */
-		xfs_iunlock(ip, args->lockmode);
-
-		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
-				0, 0, false, &args->tp);
-		if (error)
-			return error;
-		local_tp = args->tp;
-
-		goto retry;
-	}
 	if (error)
-		goto out_unlock;
-
-	if (local_tp) {
-		error = xfs_trans_commit(local_tp);
-		args->tp = NULL;
-		if (error)
-			goto out_unlock;
-	}
+		return error;
 
 	if (!args->shared)
 		return 0;
 
 	if ((args->flags & IOMAP_ATOMIC) &&
 	    !xfs_bmap_hw_atomic_write_possible(ip, &args->cmap,
-			offset_fsb, end_fsb)) {
-		error = -ENOPROTOOPT;
-		goto out_unlock;
-	}
+			offset_fsb, end_fsb))
+		return -ENOPROTOOPT;
 
 	/*
 	 * COW extent found and allocated. Set up iomap/srcmap and return
-	 * with *nimaps = 0 to tell the caller the COW path is complete.
+	 * with nimaps = 0 to tell the caller the COW path is complete.
 	 */
 	args->nimaps = 0;
 	args->length = XFS_FSB_TO_B(mp,
@@ -1014,22 +942,11 @@ xfs_direct_write_cow_iomap_begin(
 		error = xfs_bmbt_to_iomap(ip, args->srcmap, &args->imap,
 				args->flags, 0, seq);
 		if (error)
-			goto out_unlock;
+			return error;
 	}
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-	if (needs_tp)
-		xfs_iunlock(ip, args->lockmode);
 	return xfs_bmbt_to_iomap(ip, args->iomap, &args->cmap, args->flags,
 			IOMAP_F_SHARED, seq);
-
-out_unlock:
-	if (local_tp) {
-		if (args->tp)
-			xfs_trans_cancel(local_tp);
-		args->tp = NULL;
-		xfs_iunlock(ip, args->lockmode);
-	}
-	return error;
 }
 
 static int
@@ -1094,8 +1011,8 @@ xfs_direct_write_iomap_begin(
 		if (error)
 			goto out_unlock;
 
-		if (xfs_is_cow_inode(ip)) {
-			error = xfs_direct_write_cow_iomap_begin(&dwa, false);
+		if (imap_needs_cow(ip, flags, &dwa.imap, dwa.nimaps)) {
+			error = xfs_direct_write_cow_iomap_begin(&dwa);
 			if (error == -EAGAIN)
 				goto alloc_trans;
 			if (error)
-- 
2.55.0

