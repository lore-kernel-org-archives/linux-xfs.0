Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43354457D1
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319620; cv=none; b=XwbgZkWTcVdw7TVv+cvWzXzTJvTI8Y2fph42sWXHO3f4DFR9aMXMf1F25hbEo1tNY3ovgmPaKcG31+XycWoBuJgcBnGxeQULx9RLII+DPIMDiscdLPQYt+c8+lR/KxR/Mxv06UbYpG0BcYMnM6XvIxAvwNMyM2O7MIhI4sOtWtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319620; c=relaxed/simple;
	bh=I/MqvfEKHwRP56jiYTdS5qOkAskNXEPJUTvH5DI8KRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwLS3mAMWUCJnhxBMOsD8nREk93FM3+Z2+KUuJYNH1rgBjjbL+TfxXC3JXGYLC9/V3cLfqXe8hJ82qXqMnD/KugOuGBYngDBCAKplDBmPbr+ZfxS3lUGZZk2hM7rUXieaztGh7PcST0pdW/2YiNqUsIg3IHaHikWMXlwIlNPcAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5YuDRGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5YuDRGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B761F000E9;
	Wed, 29 Jul 2026 10:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319619;
	bh=bqgD7wm1kEc3oFtooDI0XUwnSzjOJdwjAt+qC18VexY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5YuDRGKO3E3RoLDbz6F57LcnkKXfKBwIPobpXZIH7+Y3C2VAuVlhM2Ai/wTczleS
	 YPG3AzRv7Gt74SZGjXpwTMvq50yyasUuGvpgH39bj5VWUzQkgqr38Z2WFZa8bifBnA
	 8/ZrkfQ56mc5bzFQls40orRvl/0+zeqps+pk7/edTwdVqQgOpM/MdBVFXlB+SXXusF
	 XhGMU4JWl/8O3MRkMwVLZ6T+bDRqSdjs3y0G8Na8o7MRIzEPp8czxtmZPRJ8GEDn8y
	 QGMAZzkU3bX+A8zYaf66gvBxL2TmvyNbUNbwzLs9/dDDc2w0bhHWisxJlqAJm5OwKn
	 Ynzw9ayNxwEyA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 21/33] xfs: plumb struct xfs_trans *tp into xfs_reflink_end_cow_extent
Date: Wed, 29 Jul 2026 20:02:05 +1000
Message-ID: <20260729100629.1943710-22-dgc@kernel.org>
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

Add a struct xfs_trans *tp parameter to xfs_reflink_end_cow_extent().
When a non-NULL transaction is provided, use it directly for the
COW extent remapping and return the error to the caller without
managing the transaction or lock lifecycle.

When tp is NULL, the existing behaviour is preserved.

All callers currently pass NULL, so there is no functional change.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e40f7afc2c7b..b175a549ee55 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -889,15 +889,19 @@ xfs_reflink_end_cow_extent_locked(
  */
 STATIC int
 xfs_reflink_end_cow_extent(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		*offset_fsb,
 	xfs_fileoff_t		end_fsb)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
 	unsigned int		resblks;
+	bool			local_tp = false;
 	int			error;
 
+	if (tp)
+		goto end_cow;
+
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
@@ -905,8 +909,12 @@ xfs_reflink_end_cow_extent(
 		return error;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
+	local_tp = true;
 
+end_cow:
 	error = xfs_reflink_end_cow_extent_locked(tp, ip, offset_fsb, end_fsb);
+	if (!local_tp)
+		return error;
 	if (error)
 		xfs_trans_cancel(tp);
 	else
@@ -966,7 +974,8 @@ xfs_reflink_end_cow(
 	 * blocks will be remapped.
 	 */
 	while (end_fsb > offset_fsb && !error)
-		error = xfs_reflink_end_cow_extent(ip, &offset_fsb, end_fsb);
+		error = xfs_reflink_end_cow_extent(NULL, ip, &offset_fsb,
+				end_fsb);
 
 	if (error)
 		trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
-- 
2.55.0

