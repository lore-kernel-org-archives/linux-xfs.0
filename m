Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F283144AB90
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319607; cv=none; b=TxtRf7Vu2byBxGsY0EFjpokZzTO/e5bA+XMyo/lscP9bgROgExyyx9BolxsqZplTs+3msDOcGBqG0QwHug2p1cNFcuad0em4UsiXVHqbtGEsaMl+cI7spy54akw5PjdlPMUjQwVhcYoijtBRN4ycRRvxBpyTgrFh9qODs4DfSWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319607; c=relaxed/simple;
	bh=6uMhhvgh3q3VR3L/Rh1v/e15ChiBmPTMzDS/rSNMmJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw8+ghbMl5E2J/p/FAD7FuiyjPsDswgBIoPYAnMFVesKHLPNsMhJ1vvBmS/O1Yj5gSM7mrG1CLheFYBfxiqen5ER4eifz1vnw4WwpBmOhAXrl2/zAIMKFQdlw3GalTlvMUz/0jPIrzNZd2sp0MeynvyOZI7A8AcP20ASyNseBFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYz2Om0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYz2Om0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DF81F00A3D;
	Wed, 29 Jul 2026 10:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319605;
	bh=5YueZeJC5gLFYQL8RXCjUyRN1rcWtMqZ/EMY5iqDSSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYz2Om0aWV9K6S/cGFMBR+shgKrb4Y3anF73mhdj/VSvMA7CRIGSyut7ZN0yNxhwP
	 WjiRtEqW3RjXkarPTtUgHriRyStMFkYui+XKb31qgsdkIU2TnwJjzB9R8NTMxXMAO/
	 JX6W682axRlKU9z9eBWz3mHklhg6iuTQus2YvGu4ZJEvwNS7iVyWkToleCjAX4PUw8
	 JpAJYZ8B+x86omhK1tKOaWCWTWQWLzimCvOxvfqMa/YCumWETBczuTS15HRQdbcfba
	 IEi6AnYp+Lj3tpGpCLmPukLUp67hcwbnw8tWSPWk0mG/Tx/E6p30muJMM97/HT8vqV
	 XU7cq6/UE4AAg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 09/33] xfs: remove internal transaction allocation from xfs_reflink_fill_cow_hole
Date: Wed, 29 Jul 2026 20:01:53 +1000
Message-ID: <20260729100629.1943710-10-dgc@kernel.org>
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

