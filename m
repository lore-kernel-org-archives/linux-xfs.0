Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB0F44C653
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319623; cv=none; b=b6NpCdRfhuJyhMVrwg+OYzC2mAFTsOla8ONbxFOTaQtg70iLaLZ9S76dxUAXpMzggR6T98FzyHprSqiYEg1cBiXO8bLjkU3civGD8AepKYhDRAua5nDsDlDpzP7D8p8rbkeT5zuh8J0Ah5BOuY0WgkHdhWvd3GSoDZA0j/rDqTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319623; c=relaxed/simple;
	bh=kaS1kl52R/gpOWaTKHMfa0ePRUYC/5c26Qk61z1fuLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVxC8YegHZlY5kAGusMFwSmCtym9+yzfK1AVpIVJO3gLDLSpgYapGiwTYN8VkzHKK+a3ptdzs6Q2lEiN3B4C7v76mFnUalKrrQjk62X2y3UjpIjcHTx7BdPrR9STjKHCR86ybdViZGqPRVx65Lme0BcrhoHCZIcbrPW24/WQvQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avK4/4Nl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avK4/4Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDA11F000E9;
	Wed, 29 Jul 2026 10:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319621;
	bh=hTvCPt/1Dx7zE2lgd/rhRTibh7sugcdZ61L3TpodT6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avK4/4NlBAH3B3fbHU0lqC2Qdn/7pegoxLxcI7vWPECg2q5UFkI6EeSmlhbOFQF3X
	 9MmZJU9owLae7Zt+fg8GYscpsZx0GZL55Jo/uUKgaqdpwQcv569gB7SMrpnX0bpt4L
	 Am9w+3hZzFJzMb+znWYNgGtfUM1IQaXITXJd95ZNDmJawqcbMXOcVnZlUfNTqrj56+
	 XlyeS1GxiLD/3AgGU3CJOIwzwRymUl8DaU4kcGmN9CgTw3pwBDS+f/nWudixKvqg6M
	 Bn1lKpTIu1yTtjmD1Ta8L+kfGIbR3ZSu8jWz0wL5VznFIqxO45QJ1cLU+bfJHMrOu9
	 mDXvk+vOOPSzQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 23/33] xfs: remove xfs_reflink_end_cow_extent wrapper and rename locked variant
Date: Wed, 29 Jul 2026 20:02:07 +1000
Message-ID: <20260729100629.1943710-24-dgc@kernel.org>
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

Now that xfs_reflink_end_cow() calls xfs_reflink_end_cow_extent_locked()
directly with its rolling transaction, the xfs_reflink_end_cow_extent()
wrapper function is no longer needed. Remove it entirely and rename
xfs_reflink_end_cow_extent_locked() to xfs_reflink_end_cow_extent()
since there is no longer an unlocked variant.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7e62f05499be..597300f39611 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -775,7 +775,7 @@ xfs_reflink_update_quota(
  * requirements as low as possible.
  */
 STATIC int
-xfs_reflink_end_cow_extent_locked(
+xfs_reflink_end_cow_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		*offset_fsb,
@@ -887,42 +887,6 @@ xfs_reflink_end_cow_extent_locked(
  * every remap operation and we'd like to keep the block reservation
  * requirements as low as possible.
  */
-STATIC int
-xfs_reflink_end_cow_extent(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		*offset_fsb,
-	xfs_fileoff_t		end_fsb)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	unsigned int		resblks;
-	bool			local_tp = false;
-	int			error;
-
-	if (tp)
-		goto end_cow;
-
-	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
-			XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-	local_tp = true;
-
-end_cow:
-	error = xfs_reflink_end_cow_extent_locked(tp, ip, offset_fsb, end_fsb);
-	if (!local_tp)
-		return error;
-	if (error)
-		xfs_trans_cancel(tp);
-	else
-		error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
-}
-
 /*
  * Remap parts of a file's data fork after a successful CoW.
  *
@@ -1023,7 +987,7 @@ xfs_reflink_end_atomic_cow(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	while (end_fsb > offset_fsb && !error) {
-		error = xfs_reflink_end_cow_extent_locked(tp, ip, &offset_fsb,
+		error = xfs_reflink_end_cow_extent(tp, ip, &offset_fsb,
 				end_fsb);
 	}
 	if (error) {
-- 
2.55.0

