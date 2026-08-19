Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B572BEFF6
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098517; cv=none; b=Zczcq9QwpwxK+KGSu2wmQZGjw0kSsc0w+gZF2HZDYMJsPwi1xyjx9XPcdTB0TVkV2vFRPgQ58ihFKHE0pIg9M3jYzmSOd5ypAKqeQbVfCvY3Brjb8O2eCAzHbssA76pRresquDOWm8+u8juaquOpTl5GGMhz1IHD6lGCnyD/ORw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098517; c=relaxed/simple;
	bh=N7BGK8E4WD+0cNsbkJ060PtH9n31u1HyHv5ISr64M0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=algqY6Vzk5MHKR6goY8M1nihcSgf5HVxy9k6YyO8OWbu10u8VnirQW9QyFomNBiIDi24Ij33nETdxykRDTli1WvKaR9jihd37M2cle1XOTBvIy6pIB2OgC3Spik/NAWYZSQR0dsPjsbO59G0QZIXZl6x0QEv/SZhWSnkJhU4BNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHm4dbZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHm4dbZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4C11F00A3D;
	Wed, 19 Aug 2026 00:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098516;
	bh=YRfF1CI4/RkY+qXaXVPd+yRlY89ZXW+sOZVZWLsLSWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHm4dbZtM4TjGJIK4b/lT7x8m3LRJI0qiZiokI8+1U5Xnu+EfZQDoVm5z5pRzx5yv
	 OuMVY78/Prf8B2Wh5Q5jeufxd3n+vSDVSS+fSZaCDt5FKHfVPZfDRX8N+AOhE4C4T/
	 K9sx2tJl8RvhNwwpfFzs2Ns4bKab+XIqKM0nH6cRcmIKa0m09IlJHn4c31ccv6fcxd
	 lf0mBc3c3SJpHA82QY35JFY7igt8qQzRj98bUStBWJP7FDMKHqsgSSX7ctnm8rKK4/
	 Cp7IJqB8y+OkP2NZi84aFstoJLFE0S/fJ7hdCxw5zyPm6pIeM6OQ8RMrk97ehy3if1
	 thwAiw0B98kBw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 22/38] xfs: remove dead internal transaction path from xfs_bmapi_convert_one_delalloc
Date: Wed, 19 Aug 2026 10:12:25 +1000
Message-ID: <20260819001442.1451892-23-dgc@kernel.org>
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

Now that xfs_bmapi_convert_one_delalloc() is always called with a
valid caller-supplied transaction from xfs_bmapi_convert_delalloc(),
remove the dead internal transaction allocation path.

The function is now a pure helper that converts one delalloc extent
using the caller's transaction and returns errors directly without
managing the transaction or lock lifecycle.

The success and error finish paths are collapsed into a single
out_finish label since both call xfs_bmapi_finish() and return error.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 41 +++++-----------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4eaf67b51c8d..181333d3dee6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4363,28 +4363,13 @@ xfs_bmapi_convert_one_delalloc(
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	struct xfs_bmalloca	bma = { NULL };
 	uint16_t		flags = 0;
-	struct xfs_trans	*local_tp = NULL;
 	int			error;
 
+	ASSERT(tp);
+
 	if (whichfork == XFS_COW_FORK)
 		flags |= IOMAP_F_SHARED;
 
-	if (!tp) {
-		/*
-		 * Space for the extent and indirect blocks was reserved when
-		 * the delalloc extent was created so there's no need to do so
-		 * here.
-		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
-					XFS_TRANS_RESERVE, &local_tp);
-		if (error)
-			return error;
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(local_tp, ip, 0);
-		tp = local_tp;
-	}
-
 	/*
 	 * Look up the extent before extending the extent count so that we
 	 * don't dirty the transaction if there is nothing to convert. A
@@ -4398,8 +4383,7 @@ xfs_bmapi_convert_one_delalloc(
 		 * might have moved the extent to the data fork in the meantime.
 		 */
 		WARN_ON_ONCE(whichfork != XFS_COW_FORK);
-		error = -EAGAIN;
-		goto out_trans_cancel;
+		return -EAGAIN;
 	}
 
 	/*
@@ -4411,13 +4395,13 @@ xfs_bmapi_convert_one_delalloc(
 				xfs_iomap_inode_sequence(ip, flags));
 		if (seq)
 			*seq = READ_ONCE(ifp->if_seq);
-		goto out_trans_cancel;
+		return 0;
 	}
 
 	error = xfs_iext_count_extend(tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
-		goto out_trans_cancel;
+		return error;
 
 	bma.tp = tp;
 	bma.ip = ip;
@@ -4471,23 +4455,8 @@ xfs_bmapi_convert_one_delalloc(
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
-	if (error)
-		goto out_finish;
-
-	xfs_bmapi_finish(&bma, whichfork, 0);
-	if (local_tp) {
-		error = xfs_trans_commit(local_tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-	return error;
-
 out_finish:
 	xfs_bmapi_finish(&bma, whichfork, error);
-out_trans_cancel:
-	if (local_tp) {
-		xfs_trans_cancel(local_tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
 	return error;
 }
 
-- 
2.55.0

