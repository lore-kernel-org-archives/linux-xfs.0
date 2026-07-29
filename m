Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1D04457B3
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319603; cv=none; b=HltQgKVE1OM73LOfOA2K+XGp7mfcvStxDvIgmuH9R23Eb4HShHohU1dwTAK3N7r3LYZE/6/3ChYjG/Xapfwj6DzNmw67mburgW0Wh36LOZoku88Oa58upF3rPv64V3q3D17OB/SCJHELJKq934cTHNQsTVrQSMTX5TF5AD6AfeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319603; c=relaxed/simple;
	bh=yXosaQdYWHNoS9T+651iClK6yBt1AZMNZZmaFIHxbcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUAzesAvzCN70RYyqzQoEAXVe/OScO4128EqCRtzapKLXWHYWuJIClMxpqcHS+XgiMPzk9KFoel2SKhZNXiBRe2uXOEE8eI/KgbAYpbsC2bPUEZK5s+U4XcHyPbiks10ms5fqQx9nerZl9UQFiqAK7/Z5HHdH2BOpQCSNZ0N2gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AqIO4YeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqIO4YeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3E61F00A3A;
	Wed, 29 Jul 2026 10:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319602;
	bh=JyEKnxbE5SrplNDLr4kSLgWP4ckr+8VIzNV6N2SBgpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqIO4YeC4v3l1LbJkNcg1TubdO0loAr+D/Q9Y2sPnaxPv6lS56vs+XWxqGrosGUfj
	 7J5mYqc6cgBxK7oAhasWzfB/b0IzT/c/DvwTJLPnDkaEtbMzFyVkfLsQ+XIP7ZdZh/
	 OIJuWBq1gI01QiKRpOoYm4mzlSkjf5bDO6mTwKs3xADxTKvaS6kn1ZUKPI7McYYuLj
	 sUdHT17SbwfXKojyFAZwy90zVAmKRBbiHrtWQSG0TkhhVvOaLY181jDjsKxaHanH6a
	 zPMS6g3FAJjcdE0hbJeIxaIAIMLFYoxucczJAlWuFmo/w0bp786TbIXbpyGCWaWJDR
	 7Fv+gLVA0CSow==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 06/33] xfs: teach xfs_reflink_fill_cow_hole() to use a caller-supplied transaction
Date: Wed, 29 Jul 2026 20:01:50 +1000
Message-ID: <20260729100629.1943710-7-dgc@kernel.org>
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

When xfs_reflink_fill_cow_hole() is called with a non-NULL transaction
pointer, use it directly for the COW extent allocation instead of
dropping the ILOCK and allocating a new transaction internally.

When a caller-supplied transaction is used:
- The ILOCK drop/reacquire cycle is skipped entirely
- The caller is responsible for committing or cancelling the transaction
- xfs_find_trim_cow_extent() is still called to re-validate the COW
  fork state

When tp is NULL, the existing behaviour is preserved: the function
drops the ILOCK, allocates a transaction (which re-acquires the ILOCK),
and handles commit/cancel internally.

No callers pass a non-NULL transaction yet, so there is no functional
change.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1fa899048b24..1ad0569ecdd1 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -439,7 +439,7 @@ xfs_reflink_fill_cow_hole(
 	bool			convert_now)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*local_tp;
+	struct xfs_trans	*local_tp = NULL;
 	xfs_filblks_t		resaligned;
 	unsigned int		seq_before = READ_ONCE(ip->i_df.if_seq);
 	unsigned int		dblocks = 0, rblocks = 0;
@@ -447,6 +447,16 @@ xfs_reflink_fill_cow_hole(
 	int			error;
 	bool			found;
 
+	/*
+	 * If the caller supplied a transaction, use it directly. The caller
+	 * is responsible for commit/cancel and holds the ILOCK.
+	 *
+	 * Otherwise, we need to drop the ILOCK and allocate a transaction
+	 * ourselves, which will re-acquire the ILOCK.
+	 */
+	if (tp)
+		goto allocate;
+
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -466,6 +476,7 @@ xfs_reflink_fill_cow_hole(
 		return error;
 
 	*lockmode = XFS_ILOCK_EXCL;
+	tp = local_tp;
 
 	/*
 	 * The data fork mapping may have changed while we dropped the ILOCK
@@ -483,18 +494,20 @@ xfs_reflink_fill_cow_hole(
 			goto out_trans_cancel;
 	}
 
+allocate:
 	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
 	if (error || !*shared)
 		goto out_trans_cancel;
 
 	if (found) {
-		xfs_trans_cancel(local_tp);
+		if (local_tp)
+			xfs_trans_cancel(local_tp);
 		goto convert;
 	}
 
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
-	error = xfs_bmapi_write(local_tp, ip, imap->br_startoff,
+	error = xfs_bmapi_write(tp, ip, imap->br_startoff,
 			imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
 			&nimaps);
@@ -502,15 +515,18 @@ xfs_reflink_fill_cow_hole(
 		goto out_trans_cancel;
 
 	xfs_inode_set_cowblocks_tag(ip);
-	error = xfs_trans_commit(local_tp);
-	if (error)
-		return error;
+	if (local_tp) {
+		error = xfs_trans_commit(local_tp);
+		if (error)
+			return error;
+	}
 
 convert:
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 
 out_trans_cancel:
-	xfs_trans_cancel(local_tp);
+	if (local_tp)
+		xfs_trans_cancel(local_tp);
 	return error;
 }
 
-- 
2.55.0

