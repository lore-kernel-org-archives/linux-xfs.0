Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F8B238159
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098496; cv=none; b=EBdBZZwhLrdiWn3j7gMZfJIz4u5cq1h1Ftw5CuBPgESdKkEuv35MgrlJQYPPXIcOD2J9QnLu0eUI7dKVUJobavoV04YUMS/6w2JvRflf1nDgYi0BsphwgPb3Ec7PWB7TzLd/o0CcwDY8DB8sJUs9eUSCJMTtfvC5mclLWWJvpjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098496; c=relaxed/simple;
	bh=HhaCK6Qe0WdghHktyYQXq0i4Kyx9jo5ANVupac3tLsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbJBK3uz4EzvttuVsd2Kc83VootqztfpYTuJkTMLx/QFH025DDJIU72hMe4s3V6Z+b38MlMj5iOKs1kNgm400M8N4FkU3nYRraLpeYzSe++f9CVs5eBSS0CFNslixpzxM24HwRC23ttgA5cYNSV8LAUYiCs5sutpZ+0e5WjI8Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNCHFMm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNCHFMm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A31F00A3D;
	Wed, 19 Aug 2026 00:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098494;
	bh=yKauP/cVyoC/zoxdhCXdC73CVwNniRHLgYz/+dFfkC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNCHFMm1pQicYVDskzHJbJNFHRDKdGldpb/4VfPJCdYeJdZxqzcL0oz6RtOvfhy20
	 RzuKZZjtevaODgZhpiCm9J/gWKql8B6RfzsoPLaq2Xtg2SU5GlvQvLfXh36IbmsrE8
	 rPokn4MxLSq9aANlDYT+BANQEZ+a8Hb71KVPkrAmJIQgIgSyxLk5L2bmO5Jgwzgbxr
	 5+ign8k4mMpwJSfeezTUmUO4V9b6swBM6vB9ecjG0BcCicWvBK/qIVk+oziqKYl1kF
	 VmnZ9L37cqEN0mcLR8FLhemxkOWfdKb6J4cL50hDPACHPNWYyutkJhxZY2lUxUMVl3
	 sQEV4beFQ+QRw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 05/38] xfs: factor xfs_trans_reserve_blocks() from xfs_trans_reserve()
Date: Wed, 19 Aug 2026 10:12:08 +1000
Message-ID: <20260819001442.1451892-6-dgc@kernel.org>
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

Rename xfs_trans_reserve_more() to xfs_trans_reserve_blocks() and
refactor xfs_trans_reserve() to call it instead of open coding the
block reservation. Add the inverse xfs_trans_unreserve_blocks() for
callers that need to give back reservations. This provides a common
helper for both the initial transaction reservation and the
reserve-more-later pattern used by online repair and the iomap
paths.

Update xfs_trans_reserve_more_inode() to use the new helpers and
convert all remaining xfs_trans_reserve_more() callers in scrub.

Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/scrub/cow_repair.c      |   4 +-
 fs/xfs/scrub/quota_repair.c    |   2 +-
 fs/xfs/scrub/rtbitmap_repair.c |   2 +-
 fs/xfs/scrub/tempfile.c        |   2 +-
 fs/xfs/xfs_trans.c             | 136 ++++++++++++++-------------------
 fs/xfs/xfs_trans.h             |   4 +-
 6 files changed, 67 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 8dd9c0266e21..ee2a362d9bb2 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -435,7 +435,7 @@ xrep_cow_alloc(
 	};
 	int			error;
 
-	error = xfs_trans_reserve_more(sc->tp, del->br_blockcount, 0);
+	error = xfs_trans_reserve_blocks(sc->tp, del->br_blockcount, 0);
 	if (error)
 		return error;
 
@@ -467,7 +467,7 @@ xrep_cow_alloc_rt(
 	xfs_extlen_t		len;
 	int			error;
 
-	error = xfs_trans_reserve_more(sc->tp, 0, maxrtx);
+	error = xfs_trans_reserve_blocks(sc->tp, 0, maxrtx);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 487bd4f68ebb..759a5d5b2379 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -66,7 +66,7 @@ xrep_quota_item_fill_bmap_hole(
 	xfs_trans_ijoin(sc->tp, sc->ip, 0);
 
 	/* Map a block into the file. */
-	error = xfs_trans_reserve_more(sc->tp, XFS_QM_DQALLOC_SPACE_RES(mp),
+	error = xfs_trans_reserve_blocks(sc->tp, XFS_QM_DQALLOC_SPACE_RES(mp),
 			0);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 442a17bf9720..61f33e558ba4 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -546,7 +546,7 @@ xrep_rtbitmap(
 		if (delta > UINT_MAX)
 			return -EOPNOTSUPP;
 
-		error = xfs_trans_reserve_more(sc->tp, delta, 0);
+		error = xfs_trans_reserve_blocks(sc->tp, delta, 0);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 98820003b929..6bffaf9bc1e8 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -818,7 +818,7 @@ xrep_tempexch_trans_reserve(
 	if (error)
 		return error;
 
-	error = xfs_trans_reserve_more(sc->tp, tx->req.resblks, 0);
+	error = xfs_trans_reserve_blocks(sc->tp, tx->req.resblks, 0);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1b36cf12d4e3..609b0fe3d4d3 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -131,6 +131,53 @@ xfs_trans_dup(
 	return ntp;
 }
 
+/*
+ * Reserve disk blocks and RT extents for a transaction. On success the
+ * requested blocks are decremented from the global free space counters and
+ * added to the transaction's block reservation. On failure, no space is
+ * reserved and the transaction is not modified, and callers must be able to
+ * cancel the transaction without shutting down the filesystem.
+ */
+int
+xfs_trans_reserve_blocks(
+	struct xfs_trans	*tp,
+	unsigned int		blocks,
+	unsigned int		rtextents)
+{
+	bool			rsvd = tp->t_flags & XFS_TRANS_RESERVE;
+
+	if (blocks && xfs_dec_fdblocks(tp->t_mountp, blocks, rsvd))
+		return -ENOSPC;
+	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents)) {
+		if (blocks)
+			xfs_add_fdblocks(tp->t_mountp, blocks);
+		return -ENOSPC;
+	}
+	tp->t_blk_res += blocks;
+	tp->t_rtx_res += rtextents;
+	return 0;
+}
+
+/*
+ * Give back block and RT extent reservations to the free space counters.
+ * This is the inverse of xfs_trans_reserve_blocks().
+ */
+void
+xfs_trans_unreserve_blocks(
+	struct xfs_trans	*tp,
+	unsigned int		blocks,
+	unsigned int		rtextents)
+{
+	if (blocks) {
+		xfs_add_fdblocks(tp->t_mountp, blocks);
+		tp->t_blk_res -= blocks;
+	}
+	if (rtextents) {
+		xfs_add_frextents(tp->t_mountp, rtextents);
+		tp->t_rtx_res -= rtextents;
+	}
+}
+
 /*
  * This is called to reserve free disk blocks and log space for the given
  * transaction before allocating any resources within the transaction.
@@ -149,22 +196,13 @@ xfs_trans_reserve(
 	uint			rtextents)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	int			error = 0;
-	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	int			error;
 
 	ASSERT(resp->tr_logres > 0);
 
-	/*
-	 * Attempt to reserve the needed disk blocks by decrementing the number
-	 * needed from the number available.  This will fail if the count would
-	 * go below zero.
-	 */
-	if (blocks > 0) {
-		error = xfs_dec_fdblocks(mp, blocks, rsvd);
-		if (error != 0)
-			return -ENOSPC;
-		tp->t_blk_res += blocks;
-	}
+	error = xfs_trans_reserve_blocks(tp, blocks, rtextents);
+	if (error)
+		return error;
 
 	/*
 	 * Reserve the log space needed for this transaction.
@@ -173,39 +211,15 @@ xfs_trans_reserve(
 		tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
 	error = xfs_log_reserve(mp, resp->tr_logres, resp->tr_logcount,
 			&tp->t_ticket, (tp->t_flags & XFS_TRANS_PERM_LOG_RES));
-	if (error)
-		goto undo_blocks;
+	if (error) {
+		xfs_trans_unreserve_blocks(tp, blocks, rtextents);
+		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
+		return error;
+	}
 
 	tp->t_log_res = resp->tr_logres;
 	tp->t_log_count = resp->tr_logcount;
-
-	/*
-	 * Attempt to reserve the needed realtime extents by decrementing the
-	 * number needed from the number available.  This will fail if the
-	 * count would go below zero.
-	 */
-	if (rtextents > 0) {
-		error = xfs_dec_frextents(mp, rtextents);
-		if (error) {
-			error = -ENOSPC;
-			goto undo_log;
-		}
-		tp->t_rtx_res += rtextents;
-	}
-
 	return 0;
-
-undo_log:
-	xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
-	tp->t_ticket = NULL;
-	tp->t_log_res = 0;
-	tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
-undo_blocks:
-	if (blocks > 0) {
-		xfs_add_fdblocks(mp, blocks);
-		tp->t_blk_res = 0;
-	}
-	return error;
 }
 
 static struct xfs_trans *
@@ -1115,38 +1129,9 @@ xfs_trans_alloc_inode(
 	return error;
 }
 
-/*
- * Try to reserve more blocks for a transaction.
- *
- * This is for callers that need to attach resources to a transaction, scan
- * those resources to determine the space reservation requirements, and then
- * modify the attached resources.  In other words, online repair.  This can
- * fail due to ENOSPC, so the caller must be able to cancel the transaction
- * without shutting down the fs.
- */
-int
-xfs_trans_reserve_more(
-	struct xfs_trans	*tp,
-	unsigned int		blocks,
-	unsigned int		rtextents)
-{
-	bool			rsvd = tp->t_flags & XFS_TRANS_RESERVE;
-
-	if (blocks && xfs_dec_fdblocks(tp->t_mountp, blocks, rsvd))
-		return -ENOSPC;
-	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents)) {
-		if (blocks)
-			xfs_add_fdblocks(tp->t_mountp, blocks);
-		return -ENOSPC;
-	}
-	tp->t_blk_res += blocks;
-	tp->t_rtx_res += rtextents;
-	return 0;
-}
-
 /*
  * Try to reserve more blocks and file quota for a transaction.  Same
- * conditions of usage as xfs_trans_reserve_more.
+ * conditions of usage as xfs_trans_reserve_blocks.
  */
 int
 xfs_trans_reserve_more_inode(
@@ -1162,7 +1147,7 @@ xfs_trans_reserve_more_inode(
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve_more(tp, dblocks, rtx);
+	error = xfs_trans_reserve_blocks(tp, dblocks, rtx);
 	if (error)
 		return error;
 
@@ -1178,10 +1163,7 @@ xfs_trans_reserve_more_inode(
 		return 0;
 
 	/* Quota failed, give back the new reservation. */
-	xfs_add_fdblocks(mp, dblocks);
-	tp->t_blk_res -= dblocks;
-	xfs_add_frextents(mp, rtx);
-	tp->t_rtx_res -= rtx;
+	xfs_trans_unreserve_blocks(tp, dblocks, rtx);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index eb83c5dac032..de77b617bccf 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -167,7 +167,9 @@ typedef struct xfs_trans {
 int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			uint blocks, uint rtextents, uint flags,
 			struct xfs_trans **tpp);
-int		xfs_trans_reserve_more(struct xfs_trans *tp,
+int		xfs_trans_reserve_blocks(struct xfs_trans *tp,
+			unsigned int blocks, unsigned int rtextents);
+void		xfs_trans_unreserve_blocks(struct xfs_trans *tp,
 			unsigned int blocks, unsigned int rtextents);
 struct xfs_trans *xfs_trans_alloc_empty(struct xfs_mount *mp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
-- 
2.55.0

