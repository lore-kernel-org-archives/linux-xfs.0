Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D8A257844
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098508; cv=none; b=YD16+szYRO7oQPc/RqjL9hDDByoLtXm+rWYBQ+S6crk7VBwfgJ+pL5Mxn8Bf34ceVuGjaIfi4TLiqilb9U5jt+x1ie8euA68dzxrlfrIfdZzegObBHdWvJCoTJ7+O5ejCpjMDKEjFNM3UnnPHNcu1a745Qn3GMyObwnBxXZTv58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098508; c=relaxed/simple;
	bh=6uMhhvgh3q3VR3L/Rh1v/e15ChiBmPTMzDS/rSNMmJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSeuVo6T2CjfKK+V4nOuszwQ99CnQkpT9wsPMAyNYRyjONf/nLVIqJ95aNHm4Ugm4WlJvGIn37wSVLvS2EcrVoX6Cpp8tmnHZR1ioepMNlhYn9QG8FbzP+nLU8vRuPKFQsjqxSTbuH1j4AHfPUdZrCGD17HlUBhIwp5oUBz9Z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiKO8Mon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiKO8Mon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838F51F00A3A;
	Wed, 19 Aug 2026 00:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098505;
	bh=5YueZeJC5gLFYQL8RXCjUyRN1rcWtMqZ/EMY5iqDSSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiKO8Mon4CViFSAyQQpCkgWkQZZNtrDsNa0YWNvPgQLuVE3fVVpC85V+MWp1sLKTQ
	 ybZEwEg9VF6N+HJ35S2N1G3Hdl4CG0vdnS+nWfzZtRtC4SVikpVtRaIbOUJnYqcuSM
	 0VwT3O8rtl8EQn0OYXbT/0LTi9Jv1FmSKHCZJosKxuti2OrgGl8QHMxf1Iz6D28QYT
	 Kc1N0l1WtAGJUOLSqvTotKyWSqzRw9W672nGSZ7TRuz5HyUUEaAmV2PeLovRNuMhgH
	 el+MvMIrrC70DN13N3/2dmwTUuip/12JT3YXiq1Gaafo6MbQiR8vls+GCS8bvnd5py
	 dL7ftbVp45gOw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 14/38] xfs: remove internal transaction allocation from xfs_reflink_fill_cow_hole
Date: Wed, 19 Aug 2026 10:12:17 +1000
Message-ID: <20260819001442.1451892-15-dgc@kernel.org>
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

Now that xfs_reflink_fill_cow_hole() is always called with a valid
caller-supplied transaction, remove the dead internal transaction
allocation path.

This removes the ILOCK drop/reacquire cycle that was previously
needed to allocate a transaction, as the caller now handles
transaction allocation before calling into this function. The
COW extent allocation via xfs_bmapi_write() is now performed
entirely under the caller's ILOCK hold, eliminating the window
where the extent tree could change due to the lock being cycled.

The lockmode parameter is also removed as the function no longer
modifies the lock state.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 75 +++-----------------------------------------
 1 file changed, 5 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 56ad76b0f6b9..a3b4343fd882 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -435,75 +435,20 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
 	bool			*shared,
-	uint			*lockmode,
 	bool			convert_now)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*local_tp = NULL;
-	xfs_filblks_t		resaligned;
-	unsigned int		seq_before = READ_ONCE(ip->i_df.if_seq);
-	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
 	bool			found;
 
-	/*
-	 * If the caller supplied a transaction, use it directly. The caller
-	 * is responsible for commit/cancel and holds the ILOCK.
-	 *
-	 * Otherwise, we need to drop the ILOCK and allocate a transaction
-	 * ourselves, which will re-acquire the ILOCK.
-	 */
-	if (tp)
-		goto allocate;
-
-	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
-		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
-		rblocks = resaligned;
-	} else {
-		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
-		rblocks = 0;
-	}
-
-	xfs_iunlock(ip, *lockmode);
-	*lockmode = 0;
-
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
-			rblocks, false, &local_tp);
-	if (error)
-		return error;
-
-	*lockmode = XFS_ILOCK_EXCL;
-	tp = local_tp;
-
-	/*
-	 * The data fork mapping may have changed while we dropped the ILOCK
-	 * (a racing O_DIRECT writer under IOLOCK_SHARED can complete a full
-	 * CoW cycle including xfs_reflink_end_cow(), which remaps this offset
-	 * and drops the refcount of the old shared block).  Re-read it so the
-	 * shared-status recheck below and the caller's in-place iomap both
-	 * operate on the current mapping rather than a stale physical block.
-	 */
-	if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
-		nimaps = 1;
-		error = xfs_bmapi_read(ip, imap->br_startoff,
-				imap->br_blockcount, imap, &nimaps, 0);
-		if (error)
-			goto out_trans_cancel;
-	}
+	ASSERT(tp);
 
-allocate:
 	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
 	if (error || !*shared)
-		goto out_trans_cancel;
+		return error;
 
-	if (found) {
-		if (local_tp)
-			xfs_trans_cancel(local_tp);
+	if (found)
 		goto convert;
-	}
 
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
@@ -512,22 +457,12 @@ xfs_reflink_fill_cow_hole(
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
 			&nimaps);
 	if (error)
-		goto out_trans_cancel;
+		return error;
 
 	xfs_inode_set_cowblocks_tag(ip);
-	if (local_tp) {
-		error = xfs_trans_commit(local_tp);
-		if (error)
-			return error;
-	}
 
 convert:
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
-
-out_trans_cancel:
-	if (local_tp)
-		xfs_trans_cancel(local_tp);
-	return error;
 }
 
 static int
@@ -651,7 +586,7 @@ xfs_reflink_allocate_cow(
 		if (!tp)
 			return -EAGAIN;
 		return xfs_reflink_fill_cow_hole(tp, ip, imap, cmap, shared,
-				lockmode, convert_now);
+				convert_now);
 	}
 
 	/*
-- 
2.55.0

