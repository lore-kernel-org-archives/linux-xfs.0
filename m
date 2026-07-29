Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB1F44B692
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319608; cv=none; b=o8UY5//JunhhKm/9YyIp3IaSpqw15eLjXnmgD8TdJYsiXkdgKMUmNeWtnvg9PoXVb1tDxBsF8JJkrjpmDJPN79E81R8D3iTUDf1jqzva67e+Z2DLkXxO/i1sz2uvQytyGXJONltbQvpRN8IvlEjCFey+cOt+PRddgTBdnv6EpP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319608; c=relaxed/simple;
	bh=mt0Rzo2XtQ8zVv8XQSw9zfH7RNJ8JokhugsFNw7w4QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ga0ctFDRINyTR/IZVZGIEyoOn33I1zRBkQ/U3KG92o0AYhKFng5GDr2lC1RL+x3Pyg3fmkLcJx+Rvj14xdBWeFqGGm//kk/B+Urp14HTPSXDlmbkL7I9y/5dpV8shBciI5PMGNFkmdqyH3bCSv1KC2s2zBXSiLblRh63wZgYdig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Krlpj4Tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Krlpj4Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE031F00A3A;
	Wed, 29 Jul 2026 10:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319606;
	bh=CnNtvh6ij/qD7aH44/wIQ7pXaa+R36xoRfax0ilKS5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Krlpj4TtOzh9IwIQ6qPgFR1/g8HwE7GD83T/hx3WTQwcKMfO5aRrSU372mgdQqqng
	 j169yYOAf8YuTmgkNjvgYyZgCmYq88bWCcJzpgRAQbYGHpOCll9AagrSRY5ZHZUuH4
	 /Udqg/VHBlzGfcUf06jVcUNP1lkRfLi3bQJ8I8d/hV1g7fPWlg1Rrs7WzyD5vaBkko
	 bYlvZxr53ZxOK+meMNxT504G3eh5i9KsmstaennWW/FQQreKs+Tja526ZtQIvp3irT
	 QaHlkYdsKzN9nY/OrdTI8kOCAgLBnw7/XPKUSEUdHqKD7PCozMfhnqtBhfgYDxXGMT
	 /m0g4sYOdsGeA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 10/33] xfs: use zero-block transaction with xfs_trans_reserve_more_inode for COW holes
Date: Wed, 29 Jul 2026 20:01:54 +1000
Message-ID: <20260729100629.1943710-11-dgc@kernel.org>
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

Change the COW transaction allocation strategy to use a zero-block
reservation at the top level and defer block reservation to the
callee that knows the actual extent state.

When xfs_reflink_allocate_cow() returns -EAGAIN, the ILOCK must be
dropped to allocate a transaction. Because the extent tree can change
while the ILOCK is not held, we cannot determine what extent type
will be found once we've regained the ILOCK. The callees will use
xfs_trans_reserve_more_inode() directly to reserve any blocks they
require before they start modifications. This allows ENOSPC to be
returned and the transaction cancelled safely if the block reservation
cannot be made.

In xfs_reflink_fill_cow_hole(), add an xfs_trans_reserve_more_inode()
call before xfs_bmapi_write() to reserve the blocks needed for the
COW extent allocation. The reservation is computed from the current
imap which is stable under the ILOCK. An ASSERT verifies the
transaction has not been dirtied, confirming it is safe to cancel
on ENOSPC.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c   | 28 +++++++++++-----------------
 fs/xfs/xfs_reflink.c | 25 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 017355372a44..777048e6a2ca 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -919,29 +919,23 @@ xfs_direct_write_cow_iomap_begin(
 	if (error == -EAGAIN) {
 		/*
 		 * COW allocation needs a transaction. Drop the ILOCK and
-		 * allocate a transaction, which will re-acquire the ILOCK.
-		 * Then retry the imap lookup since the extent tree may have
-		 * changed while the ILOCK was not held.
+		 * allocate a zero-block reservation transaction, which will
+		 * re-acquire the ILOCK. We cannot determine what extent type
+		 * will be found once we've regained the ILOCK, so the callees
+		 * will use xfs_trans_reserve_more_inode() directly to reserve
+		 * any blocks they require before they start modifications.
+		 * This allows ENOSPC to be returned and the transaction
+		 * cancelled safely if the block reservation cannot be made.
+		 *
+		 * Retry the imap lookup since the extent tree may have changed
+		 * while the ILOCK was not held.
 		 */
-		xfs_filblks_t		resaligned;
-		unsigned int		dblocks, rblocks;
-
 		ASSERT(!tp);
 
 		xfs_iunlock(ip, *lockmode);
 
-		resaligned = xfs_aligned_fsb_count(offset_fsb,
-				end_fsb - offset_fsb, xfs_get_cowextsz_hint(ip));
-		if (XFS_IS_REALTIME_INODE(ip)) {
-			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
-			rblocks = resaligned;
-		} else {
-			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
-			rblocks = 0;
-		}
-
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
-				dblocks, rblocks, false, &tp);
+				0, 0, false, &tp);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a3b4343fd882..373ce9fea2a8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -437,6 +437,9 @@ xfs_reflink_fill_cow_hole(
 	bool			*shared,
 	bool			convert_now)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_filblks_t		resaligned;
+	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
 	bool			found;
@@ -450,6 +453,28 @@ xfs_reflink_fill_cow_hole(
 	if (found)
 		goto convert;
 
+	/*
+	 * Reserve blocks for the COW extent allocation. The transaction was
+	 * allocated with a zero-block reservation because the caller could
+	 * not determine the block reservation required until the extent
+	 * state was known under the ILOCK. The transaction has not been
+	 * dirtied yet, so on ENOSPC it can safely be cancelled by the caller.
+	 */
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
+			imap->br_blockcount, xfs_get_cowextsz_hint(ip));
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+		rblocks = resaligned;
+	} else {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+	}
+
+	error = xfs_trans_reserve_more_inode(tp, ip, dblocks, rblocks, false);
+	if (error)
+		return error;
+
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff,
-- 
2.55.0

