Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7865430C171
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098530; cv=none; b=a3szCu/jI+cPG+9v4YU6MiXYrr/CF5P+rjjvHorM9/taNKChpiLFIJQo9BR3/G3PTITJ07nwrpCEZVsTTbxCaBuhLhVw09Tp5HvWXJdWB6Xlhh4Nu8NEgeH/FzXu9h3B5JMWVkC9nQJHdFP+HfldVbyb54udfthHO/+beWGTwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098530; c=relaxed/simple;
	bh=kGNndX4+s7WJrzi+uIevo17Xw+Et49yvBUB0s7JIknA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usWCRXpZ/1M2lwdUj4sO1GvEqr8fF6buKzx7/F/BsEQ1QA4VQjVgZ267EOA17uNHFlRv2mvLLtWPSGtytewGiRCTMvKdZMwTLra01yqsSsA5IaHswXXnb7xbux7N0Z3kynTMzj3b5EukHXBgYCIEIJsO1sgAYYQ20njgAVRx/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9TNvgMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9TNvgMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C35D1F000E9;
	Wed, 19 Aug 2026 00:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098529;
	bh=vCU/k7u+cBPxQ/1E5xNgzJuTgTIk4Tws2yoSzsj7f9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9TNvgMdrtHphJ/lkiPUATA2hkIjjT3b1DOx0WSPtzKIW/F/6KYzdTUeiHHL3j3vn
	 iVTWtiY+3IkrE2AlduYbo+TQxTMhL9RKAaduLVPhFT2jERH0csc6VxneTSCYfxrkvg
	 sPCRFPYGt9pMsAQLiMWdkZl5raFrYEf8xBTnEmghGEWQryDBLhczcv00ZnmoxYVjZn
	 xCktCnh1+FuatfRhiz0WYhhYJlFQ7DpeLpdvWXnGce2Kh6cnp4y4xA6uSszpQXO34k
	 HjiSvbnFzX2XxAy7nrT8Y44zCoxWc574+/eFx9WSYOdXMcTE0p7h7Qnwoh22lsSEI9
	 Jwn/IdiA7O+pQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 32/38] xfs: plumb struct xfs_trans **tpp into xfs_direct_write_cow_iomap_begin
Date: Wed, 19 Aug 2026 10:12:35 +1000
Message-ID: <20260819001442.1451892-33-dgc@kernel.org>
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
 fs/xfs/xfs_iomap.c | 69 +++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 347a451ec7cb..160eea8b331c 100644
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
@@ -1026,13 +1042,14 @@ xfs_direct_write_cow_iomap_begin(
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
+	if (local_tp && tp)
+		xfs_trans_cancel(local_tp);
+	if (!tpp)
 		xfs_iunlock(ip, *lockmode);
 	return error;
 }
@@ -1076,9 +1093,9 @@ xfs_direct_write_iomap_begin(
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

