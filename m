Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219E344B692
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319616; cv=none; b=ap8JsZScfWuxVAXB7Y/VcmLvx32so4bDqanvRzmSxTo7nW3/dO1eBmQC/qicEmSIO3BVxBkShb8rIT2gzIWiV22bI+WZX+o9A8UwrggmsnCwS9v1ls4peQsDNHJo3oRG0PGnBRRbyyrgQ3DED5R6aTYucFFogO3Q4WokKsiuWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319616; c=relaxed/simple;
	bh=N7BGK8E4WD+0cNsbkJ060PtH9n31u1HyHv5ISr64M0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6cCiLUgyESvk87v/d0VkNIJ0N5PnMrgSKUFrl/25IkavcBkD3sqP9DXQ8qGQsjZsgkfoUTxsYtWn49cIwZ0qnrDJkMa5iFo4XPv8t0x06CmI1bSdvYng1fUPS3XpXQnSsWrCvYZdpmBrGK6atdRmCS/RynHZywqlDPtHEd92kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7uD9hfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7uD9hfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510EC1F000E9;
	Wed, 29 Jul 2026 10:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319615;
	bh=YRfF1CI4/RkY+qXaXVPd+yRlY89ZXW+sOZVZWLsLSWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7uD9hfvvu61xSLLZht+cuN7zaT2gkOr9FCGoPTmL9hrr7dzj1bqP2E0cdmXxOm0P
	 quKCLrkEJ+gyBiixrylWj1/UtNrHb2YNXjR3u9mHqwyGnO0G+pVdEBosoFfPtMZKa4
	 K8FADCRNNw/UP7xoqHhWLIa5mEjW0M/phHjbVHA7CP1Fw2yH2BhclSHElFV3UricW1
	 lNeIMEiHhNzn2dWxgMd/UnMcp6NSr4Dikd72yhHSCecwtJ4//JMJiHOh7Qs87SiZIK
	 nX6wOrbIezGKQo7uT5J8ttCGQb3zC3vHlCDlUuVVN3KM0DccsoK97izMe4BlwgQmr4
	 jJyV8toYv9Ctg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 17/33] xfs: remove dead internal transaction path from xfs_bmapi_convert_one_delalloc
Date: Wed, 29 Jul 2026 20:02:01 +1000
Message-ID: <20260729100629.1943710-18-dgc@kernel.org>
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

