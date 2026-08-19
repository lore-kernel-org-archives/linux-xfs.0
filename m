Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0EF279DCA
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098506; cv=none; b=WB2+nAFv+k76S8CVraeCaWEdGu4u/AJUfC7TLEci/fe2Y11Or2PfXNjzblxOXsoDEvbn+V7WNTT4rpfYgsi2pw+0IY3lEcEyCeT9WDsMCVwflzbTDJsdKm9iaQE/tF/3xdAGP7JdqtnZ70mxxheUadfn7Ri+xfzcnrPU7x5NESQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098506; c=relaxed/simple;
	bh=wR101CR7uhZgoQqa3KXXU7Vqvv3VILePgexz/HdS8Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngndxVHiiUrCmv9teXnznSdqRQr2GuZk71W7YkgtmIuL5MbhXJzbcwQJF4zgiUc8FRS5AoEffScggZyQk9OsCU/UlX4uscgJqObqTrVdFBQ627YMwik/ums511nFRqE7KdIFJ43hYyp/NkPJGgqUfHgVSZvDgCEop8otRqfnbaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AL6J6g4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AL6J6g4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B311F00A3F;
	Wed, 19 Aug 2026 00:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098502;
	bh=ZfF9XZjIG5554MSsYt5Rg4xc1sstfOHRgP7dlcsU8SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AL6J6g4RApQ38zO/6RrtDyRNXrwnyOitXVl/jnpjs/ZxWi5xloBK9oKXqbjiDyR2b
	 GIXLPPUYAc7lrzEZK5Xa5fpzMfuUujLX0SaTjNSJI/7GSTqGIJC6m4E1XkBvN96XAD
	 opf77bl12ycdEipPW/1NsnlFYJMGDd2meMrvqK2il3USxdFIVo5r0QyAh6JwbcgmOg
	 RVZ+l2u+hDG/Bdn0fs1aYZWE95DKGQhpHLYUBFAOAIh4mo8EEHf9qn4aSCXJmtPwL6
	 ilpZxFnJaLIXlcfq0Vf2L2spBg119kqxY3ISY3Qi795DLDn09dzyODwnE7FLQWb4Cz
	 k3mINHrKfkOKw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 12/38] xfs: add transaction retry infrastructure to xfs_direct_write_cow_iomap_begin
Date: Wed, 19 Aug 2026 10:12:15 +1000
Message-ID: <20260819001442.1451892-13-dgc@kernel.org>
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

Add the infrastructure for handling COW extent allocation retries with
a pre-allocated transaction in xfs_direct_write_cow_iomap_begin().

When xfs_reflink_allocate_cow() returns -EAGAIN (indicating it needs
a transaction to proceed), the function drops the ILOCK, allocates a
zero-block transaction via xfs_trans_alloc_inode() (which reacquires
the ILOCK), and jumps to retry: to re-read the imap via
xfs_bmapi_read() since the extent tree may have changed while the
ILOCK was not held.

The initial xfs_ilock_for_iomap() call is done once before the retry
label since we always enter with ILOCK_EXCL and xfs_trans_alloc_inode()
re-acquires ILOCK_EXCL on the retry path.

The old relock label and shared-to-exclusive lock upgrade logic is
removed as it is unnecessary - this function always takes ILOCK_EXCL.

Nothing returns -EAGAIN from xfs_reflink_allocate_cow() yet, so there
is no functional change.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 66 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e4e64412b431..017355372a44 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -876,6 +876,7 @@ xfs_direct_write_cow_iomap_begin(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	cmap;
+	struct xfs_trans	*tp = NULL;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
 	bool			shared = false;
@@ -884,41 +885,78 @@ xfs_direct_write_cow_iomap_begin(
 
 	*lockmode = XFS_ILOCK_EXCL;
 
-relock:
 	error = xfs_ilock_for_iomap(ip, flags, lockmode);
 	if (error)
 		return error;
 
-	/*
-	 * The reflink iflag could have changed since the earlier unlocked
-	 * check, check if it again and relock if needed.
-	 */
-	if (xfs_is_cow_inode(ip) && *lockmode == XFS_ILOCK_SHARED) {
-		xfs_iunlock(ip, *lockmode);
-		*lockmode = XFS_ILOCK_EXCL;
-		goto relock;
-	}
-
+retry:
 	*nimaps = 1;
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, imap,
 			       nimaps, 0);
 	if (error)
 		goto out_unlock;
 
-	if (!imap_needs_cow(ip, flags, imap, *nimaps))
+	if (!imap_needs_cow(ip, flags, imap, *nimaps)) {
+		/*
+		 * Extent is not shared - return the imap and ILOCK to the
+		 * caller for normal IO path processing.
+		 */
+		if (tp) {
+			xfs_trans_cancel(tp);
+			tp = NULL;
+		}
 		return 0;
+	}
 
 	error = -EAGAIN;
 	if (flags & IOMAP_NOWAIT)
 		goto out_unlock;
 
 	/* may drop and re-acquire the ilock */
-	error = xfs_reflink_allocate_cow(NULL, ip, imap, &cmap, &shared,
+	error = xfs_reflink_allocate_cow(tp, ip, imap, &cmap, &shared,
 			lockmode,
 			(flags & IOMAP_DIRECT) || IS_DAX(VFS_I(ip)));
+	if (error == -EAGAIN) {
+		/*
+		 * COW allocation needs a transaction. Drop the ILOCK and
+		 * allocate a transaction, which will re-acquire the ILOCK.
+		 * Then retry the imap lookup since the extent tree may have
+		 * changed while the ILOCK was not held.
+		 */
+		xfs_filblks_t		resaligned;
+		unsigned int		dblocks, rblocks;
+
+		ASSERT(!tp);
+
+		xfs_iunlock(ip, *lockmode);
+
+		resaligned = xfs_aligned_fsb_count(offset_fsb,
+				end_fsb - offset_fsb, xfs_get_cowextsz_hint(ip));
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+			rblocks = resaligned;
+		} else {
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+			rblocks = 0;
+		}
+
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+				dblocks, rblocks, false, &tp);
+		if (error)
+			return error;
+
+		goto retry;
+	}
 	if (error)
 		goto out_unlock;
 
+	if (tp) {
+		error = xfs_trans_commit(tp);
+		tp = NULL;
+		if (error)
+			goto out_unlock;
+	}
+
 	if (!shared)
 		return 0;
 
@@ -948,6 +986,8 @@ xfs_direct_write_cow_iomap_begin(
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
 
 out_unlock:
+	if (tp)
+		xfs_trans_cancel(tp);
 	if (*lockmode)
 		xfs_iunlock(ip, *lockmode);
 	return error;
-- 
2.55.0

