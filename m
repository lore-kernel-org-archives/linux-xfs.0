Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0C676026
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098536; cv=none; b=qgeowChJn9GBqGGZESEDDxqlq0Oyc/lOha4pCFOjRDc4Klf/YmGyWqsnw5cb7FvKDG+cDRGguw5E3qcTf+CDLnf5LMkWEiqm8mG5uOn2lWY9qDATPphd78KxGTCDlf/8sTmmfj+LmPB2nk8SIMt/woACxQxtv5BqFBka9JFWMTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098536; c=relaxed/simple;
	bh=snl6rHbyopMvzvucD7o9k04njJbr9fa8szKecAbWnQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWoFfNXUY4CCJ96SH0Q4R44M0bhlUMq69jKswdBC8pxusknMj6aCr9MI+oNljBCGUI+wHJ34x2BGUnbMhMp1Sfk/WUCz0wtembJ3LVAJ4Rc9sP27a5k1jQVS3A4UkqAoJqr78nZfWGBeX1Gnu0yXSdNXG8JJHHM5EVxf9/TyERU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmLhyHgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmLhyHgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B051F000E9;
	Wed, 19 Aug 2026 00:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098534;
	bh=2wsSgXDb9dXtqyDfHWKMSSYxOwIkh/gGEdzTv9la/Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmLhyHgbFP9tBYiFFa8wtYvfLEZ2JSIF8zjMzi2d4ZQ7AKnqK+66FLXmvBJrc436z
	 Szux1f64Kv8VdPRC4DBfpqwpb6hvDpEC25bj69iXUAmeoQi9wQ9UJdPjCYHkyOqi2T
	 5yMRPcsQbHMMEwtggNcFg3+n0jr5lnlZGXt+RoEn7EnIr5HqAkImgI+pV673yWIg9N
	 miYJgRLwtAeaYIIYGg6HjlmCIGVU3vW8sxRJLlowCMf83zMiAagzoq85Xqj3Dt9VcV
	 C4YUYFE3a/Kx9c6xxBrAx5Qi/ctVV9gUupLExmcdXNloPWoXAynvtDBJHjl5bqs3C4
	 Iow7BWl4wml6w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 36/38] xfs: clean up xfs_direct_write_cow_iomap_begin after restructure
Date: Wed, 19 Aug 2026 10:12:39 +1000
Message-ID: <20260819001442.1451892-37-dgc@kernel.org>
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
 fs/xfs/xfs_iomap.c | 113 +++++++--------------------------------------
 1 file changed, 16 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 77f71fdd125a..4b2860e80d9f 100644
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
@@ -1014,20 +942,11 @@ xfs_direct_write_cow_iomap_begin(
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
-	if (local_tp && args->tp)
-		xfs_trans_cancel(local_tp);
-	if (needs_tp)
-		xfs_iunlock(ip, args->lockmode);
-	return error;
 }
 
 static int
@@ -1092,8 +1011,8 @@ xfs_direct_write_iomap_begin(
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

