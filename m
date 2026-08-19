Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6317B28B4FD
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098509; cv=none; b=M3HtSvA6OxKghakXZfXjXn6IKwWZL4LW3+cgqiwfvyh8fUp2KNjwjRriwrr90iUwQott2ghVEjmj/BwpEqmtylhFitltnleslzCh/YQuq4HX70ON4VGrTZqRZBRLRvhmwgmGxyBeiug4jCZsi+h7m5JP/SdJpgwI0I2yIaNdgAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098509; c=relaxed/simple;
	bh=bLvm+t2hUqOVcTxDmVOrfb1TB999ZIq91l6yWi/mAwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqI2WXSQEnch5ASgbQgJa9SM0xHuiWWZ6Vmpy71ENGwuKcDTloiSB5MPpk3gXZQRgBpkmPUd1uSPIRgvqbOUtl33cvyzThIuyWhY+BiX7QpPT80237tZ/9yNR7xPcImjFaiKxVkLPLZ/J0ejQd2MSoI5x37ZqRNlg1XjniwxQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhrRdbJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhrRdbJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8775E1F00A3E;
	Wed, 19 Aug 2026 00:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098508;
	bh=OvzGHun9hURLtCbiklHneE2rfnLBBLn11jbmVNsOHKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhrRdbJv5KjdX79FiMGvx5On+Va8RyHdn/VT2w6K2gAp8cHXEKKkJ+5mJGX86FZN2
	 mzX9wtKaKrbSa3xQhMz/gNez+GIZnQIJU8KJFYHCUd/jeDHvIRdR0ZGxXp/L//SeMi
	 wxNgPEyC7BQaTjW7tfLKI0KXyGRvspddKrNKPbu4L3mGCUYl2KxlsnF5qxUxREx1p+
	 k37ILS4toOTsf/Q8Zsi2BEA4lHe2s1HKEDhj6R6lZT+Gmf4DbOu3znTJ2wLwlID6m1
	 Yj8GbnMLYgpd85p/BsX5LUsMCdsSYja5WJ6BA+Y997IDg8EJTFyb1MLImSJp9uM/LP
	 aRS/IMvPoSpMA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 16/38] xfs: change *tp to **tpp in COW allocation call chain
Date: Wed, 19 Aug 2026 10:12:19 +1000
Message-ID: <20260819001442.1451892-17-dgc@kernel.org>
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

Change the transaction parameter from struct xfs_trans *tp to
struct xfs_trans **tpp in xfs_reflink_fill_cow_hole(),
xfs_reflink_allocate_cow(), and the header declaration. Update
the caller in xfs_direct_write_cow_iomap_begin() to pass &tp.

This is preparation for xfs_reflink_fill_delalloc() using
xfs_trans_roll_inode() to implement rolling transactions, which
modifies the transaction pointer and requires **tpp semantics.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c   |  2 +-
 fs/xfs/xfs_reflink.c | 19 ++++++++++---------
 fs/xfs/xfs_reflink.h |  2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 777048e6a2ca..2f18a8f62e39 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -913,7 +913,7 @@ xfs_direct_write_cow_iomap_begin(
 		goto out_unlock;
 
 	/* may drop and re-acquire the ilock */
-	error = xfs_reflink_allocate_cow(tp, ip, imap, &cmap, &shared,
+	error = xfs_reflink_allocate_cow(&tp, ip, imap, &cmap, &shared,
 			lockmode,
 			(flags & IOMAP_DIRECT) || IS_DAX(VFS_I(ip)));
 	if (error == -EAGAIN) {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 373ce9fea2a8..6ca99ddf9976 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -430,7 +430,7 @@ xfs_reflink_convert_unwritten(
 
 static int
 xfs_reflink_fill_cow_hole(
-	struct xfs_trans	*tp,
+	struct xfs_trans	**tpp,
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
@@ -444,7 +444,7 @@ xfs_reflink_fill_cow_hole(
 	int			error;
 	bool			found;
 
-	ASSERT(tp);
+	ASSERT(*tpp);
 
 	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
 	if (error || !*shared)
@@ -460,7 +460,7 @@ xfs_reflink_fill_cow_hole(
 	 * state was known under the ILOCK. The transaction has not been
 	 * dirtied yet, so on ENOSPC it can safely be cancelled by the caller.
 	 */
-	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+	ASSERT(!((*tpp)->t_flags & XFS_TRANS_DIRTY));
 
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 			imap->br_blockcount, xfs_get_cowextsz_hint(ip));
@@ -471,13 +471,14 @@ xfs_reflink_fill_cow_hole(
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 	}
 
-	error = xfs_trans_reserve_more_inode(tp, ip, dblocks, rblocks, false);
+	error = xfs_trans_reserve_more_inode(*tpp, ip, dblocks, rblocks,
+			false);
 	if (error)
 		return error;
 
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
-	error = xfs_bmapi_write(tp, ip, imap->br_startoff,
+	error = xfs_bmapi_write(*tpp, ip, imap->br_startoff,
 			imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
 			&nimaps);
@@ -575,7 +576,7 @@ xfs_reflink_fill_delalloc(
 /* Allocate all CoW reservations covering a range of blocks in a file. */
 int
 xfs_reflink_allocate_cow(
-	struct xfs_trans	*tp,
+	struct xfs_trans	**tpp,
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
@@ -608,9 +609,9 @@ xfs_reflink_allocate_cow(
 	 * tell the caller to allocate a transaction and retry.
 	 */
 	if (cmap->br_startoff > imap->br_startoff) {
-		if (!tp)
+		if (!*tpp)
 			return -EAGAIN;
-		return xfs_reflink_fill_cow_hole(tp, ip, imap, cmap, shared,
+		return xfs_reflink_fill_cow_hole(tpp, ip, imap, cmap, shared,
 				convert_now);
 	}
 
@@ -618,7 +619,7 @@ xfs_reflink_allocate_cow(
 	 * CoW fork has a delalloc reservation. Replace it with a real extent.
 	 * There may or may not be a data fork mapping.
 	 */
-	ASSERT(!tp);
+	ASSERT(!*tpp);
 	if (isnullstartblock(cmap->br_startblock) ||
 	    cmap->br_startblock == DELAYSTARTBLOCK)
 		return xfs_reflink_fill_delalloc(ip, imap, cmap, shared,
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 6a984363edbc..3da8374829c3 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -30,7 +30,7 @@ int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
 		bool *shared);
 
-int xfs_reflink_allocate_cow(struct xfs_trans *tp, struct xfs_inode *ip,
+int xfs_reflink_allocate_cow(struct xfs_trans **tpp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap, struct xfs_bmbt_irec *cmap,
 		bool *shared, uint *lockmode, bool convert_now);
 extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
-- 
2.55.0

