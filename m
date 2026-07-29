Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBE544CAC9
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319627; cv=none; b=VGBa1ltPwt39gKhzE2BihxZd/JqfXgZZQmZoLGc3e9FDkhKyUOPXSUwLUwxW6l9OMIPDHYFgYDXuLArtnc2nU4EzKC27vTKTEZ58CRfjWNR4CRfwaF2Ucaekoiv4efDp/p+xKuTq5VoRiA4mn5uawCOo/8zwXOvdm3JAZfG07GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319627; c=relaxed/simple;
	bh=GwPNW276Xt8b/ceTeZbxfNhjX9wh+BfoM6cnjjfNMtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUmi0VZZ6hKp0a1/LWlvonPbBIzmcoUalaVBLbt/+RdFsFvlDK0EtnyhpEDXPbODN/lbmxxcjHR06WRNvWa80/1fUsI+ehR5Q4j9JUOMBNJ9Fkq1Gw5X07e2ZX4KOvs6fpQTfcOuRnh6yLwNjvuRvoaivOiu4WoLs7I7JemgteM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHWQZ1zm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHWQZ1zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60CC1F00A3D;
	Wed, 29 Jul 2026 10:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319626;
	bh=qnlP7T884k1xZqRleTkwsCkNWO40LUp2Rzh0WQFFX28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHWQZ1zm4VBF/Za9vbvORE+nu4LANEpZOQr7aD4LpwQI/fv/tbJrdvf49JelkEREB
	 OS96Rm2a5DLqJXIMtMKZ9fOxSApX8kM0GVymVm/pwrxA/ulSvzibGLzhdIEHON/7kI
	 zTXvI6o0VRuog7WiKLvh9UxPQ1MC1ITg3Pt08ctPO/rfkS4Xj4X+lFuTkcgZ/1XtW/
	 J7J3KRPH/nvy/BxzoTaDmR9jKw1wFQ/S5PpepUo1xzVqfUVmV97VHHil6zLxe1iqIh
	 Y6qKfRhXRhjBUTeGyRsRs8A4+bs3ye17cCwLwfF4AnrunLsqj7AGQqEZPhMP9yX+UM
	 qOzufl+40DIRg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 27/33] xfs: plumb struct xfs_trans **tpp into xfs_direct_write_cow_iomap_begin
Date: Wed, 29 Jul 2026 20:02:11 +1000
Message-ID: <20260729100629.1943710-28-dgc@kernel.org>
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

Add a struct xfs_trans **tpp parameter to
xfs_direct_write_cow_iomap_begin(). When tpp is provided and
xfs_reflink_allocate_cow() returns -EAGAIN (needing a transaction),
return -EAGAIN to the caller so they can allocate a transaction
and retry at a higher level. When tpp is NULL, handle the retry
internally as before using a local transaction.

The caller currently passes NULL, so the function continues to
manage its own transaction internally. No functional change.

This is preparation for moving the transaction allocation and
retry logic up to xfs_direct_write_iomap_begin() so that a single
unified retry loop handles both COW and non-COW allocation paths.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 70 +++++++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 347a451ec7cb..314a885bf9f3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -902,6 +902,11 @@ xfs_bmap_hw_atomic_write_possible(
  * Handle COW extent allocation and iomap setup for direct writes to reflinked
  * files.
  *
+ * Transitional tpp handling:
+ *	!tpp = do everything internally using local_tp
+ *	tpp & !*tpp = caller did locking, wants -EAGAIN if transaction required
+ *	tpp && *tpp = caller did locking and transaction allocation
+ *
  * The caller passes in an imap and nimaps that the COW allocation will fill
  * with the data fork extent mapping. On return, *nimaps indicates whether the
  * caller needs to continue with the normal IO path:
@@ -913,6 +918,7 @@ xfs_bmap_hw_atomic_write_possible(
  */
 static int
 xfs_direct_write_cow_iomap_begin(
+	struct xfs_trans	**tpp,
 	struct xfs_inode	*ip,
 	loff_t			offset,
 	loff_t			length,
@@ -927,34 +933,37 @@ xfs_direct_write_cow_iomap_begin(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	cmap;
 	struct xfs_trans	*tp = NULL;
+	struct xfs_trans	*local_tp = NULL;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
 	bool			shared = false;
 	int			error;
 	u64			seq;
 
-	*lockmode = XFS_ILOCK_EXCL;
+	if (!tpp) {
+		*lockmode = XFS_ILOCK_EXCL;
 
-	error = xfs_ilock_for_iomap(ip, flags, lockmode);
-	if (error)
-		return error;
+		error = xfs_ilock_for_iomap(ip, flags, lockmode);
+		if (error)
+			return error;
 
 retry:
-	*nimaps = 1;
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, imap,
-			       nimaps, 0);
-	if (error)
-		goto out_unlock;
+		*nimaps = 1;
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, imap,
+				       nimaps, 0);
+		if (error)
+			goto out_unlock;
+	} else if (*tpp) {
+		tp = *tpp;
+	}
 
 	if (!imap_needs_cow(ip, flags, imap, *nimaps)) {
 		/*
 		 * Extent is not shared - return the imap and ILOCK to the
 		 * caller for normal IO path processing.
 		 */
-		if (tp) {
-			xfs_trans_cancel(tp);
-			tp = NULL;
-		}
+		if (local_tp)
+			xfs_trans_cancel(local_tp);
 		return 0;
 	}
 
@@ -962,13 +971,21 @@ xfs_direct_write_cow_iomap_begin(
 	if (flags & IOMAP_NOWAIT)
 		goto out_unlock;
 
-	/* may drop and re-acquire the ilock */
 	error = xfs_reflink_allocate_cow(&tp, ip, imap, &cmap, &shared,
 			lockmode,
 			(flags & IOMAP_DIRECT) || IS_DAX(VFS_I(ip)));
 	if (error == -EAGAIN) {
+		ASSERT(!tp);
+
 		/*
-		 * COW allocation needs a transaction. Drop the ILOCK and
+		 * If the caller can handle the retry, return -EAGAIN so
+		 * they can allocate a transaction and call again.
+		 */
+		if (tpp)
+			goto out_unlock;
+
+		/*
+		 * Otherwise handle the retry internally. Drop the ILOCK and
 		 * allocate a zero-block reservation transaction, which will
 		 * re-acquire the ILOCK. We cannot determine what extent type
 		 * will be found once we've regained the ILOCK, so the callees
@@ -980,22 +997,21 @@ xfs_direct_write_cow_iomap_begin(
 		 * Retry the imap lookup since the extent tree may have changed
 		 * while the ILOCK was not held.
 		 */
-		ASSERT(!tp);
-
 		xfs_iunlock(ip, *lockmode);
 
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
 				0, 0, false, &tp);
 		if (error)
 			return error;
+		local_tp = tp;
 
 		goto retry;
 	}
 	if (error)
 		goto out_unlock;
 
-	if (tp) {
-		error = xfs_trans_commit(tp);
+	if (local_tp) {
+		error = xfs_trans_commit(local_tp);
 		tp = NULL;
 		if (error)
 			goto out_unlock;
@@ -1026,14 +1042,16 @@ xfs_direct_write_cow_iomap_begin(
 			goto out_unlock;
 	}
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-	xfs_iunlock(ip, *lockmode);
+	if (!tpp)
+		xfs_iunlock(ip, *lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
 
 out_unlock:
-	if (tp)
-		xfs_trans_cancel(tp);
-	if (*lockmode)
+	if (local_tp) {
+		if (tp)
+			xfs_trans_cancel(local_tp);
 		xfs_iunlock(ip, *lockmode);
+	}
 	return error;
 }
 
@@ -1076,9 +1094,9 @@ xfs_direct_write_iomap_begin(
 		iomap_flags |= IOMAP_F_ATOMIC_BIO;
 
 	if (xfs_is_cow_inode(ip)) {
-		error = xfs_direct_write_cow_iomap_begin(ip, offset, length,
-				flags, iomap, srcmap, &imap, &nimaps,
-				&lockmode, iomap_flags);
+		error = xfs_direct_write_cow_iomap_begin(NULL, ip, offset,
+				length, flags, iomap, srcmap, &imap,
+				&nimaps, &lockmode, iomap_flags);
 		if (error)
 			return error;
 		if (!nimaps)
-- 
2.55.0

