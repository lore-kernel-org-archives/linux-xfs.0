Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EF5296BAF
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098515; cv=none; b=M6LJ7zJ+EI3IItI8lmw/hOZTyR6rhXyf0J3fMehnOIdMm06+NwEEjqJiYT9hO58FmDDXVWQS/dgz3pTn4QQaD4A/O8O5lSe6ELYuCNw3NONlODxgHg4Ds0saSht4mi0dEzCImDxPqwITlOzwr7SnNu0ijUf1QMIK633c8D2VV7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098515; c=relaxed/simple;
	bh=XIDIKrXMQo56tOAg8KZxc4cudjxH8z2WX4rlSEnq4cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSjebP1nE4SxQBstMFnBRHeL83g639lpUlIgpJ2v9fUGkr+ZXFYMKLUdg/DKdkJiodQO7hBOuWNbGY7v02fnolKwhr2/abXJu7X+XO/jtU+g6T3kvCRTDiC8ZbM7N2s1ttXBKVJfSJKIIwo51yZDl3gdMBmZQTPjz5tZpemIpl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJCT49+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJCT49+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BF81F00A3A;
	Wed, 19 Aug 2026 00:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098513;
	bh=ZKaEmHapjuMtX4yxwdjPB2ZpupMQOY5/wDAOh24eo2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJCT49+xS5V1w06gL1saMQJECc4zKAQ9z3wU1OJnMQf42w0PwNUKqxOI46TJAoHX8
	 p1kZ0gsYPjnMaWHQe5oXYVqezqiQsVBRLTi039Q4RAZJBPwdz5Sx7CCpSN96zBxFlZ
	 pVhMjZU6S+Xd2BfKoFpWFnFMkD3yfTrOmZmNjkTdonKbxqDmsS7cIWXUa7wiiElhyL
	 gxUt+09pnYDv2yBk5mBR2fsaVhqVvZYN77H5LDV22xvANNtStayWr4reG1mr4tRFxh
	 YRwZBErO6gYAf9MTDKzd/BpXYruvF9sFj5GkmjHY9LzPEnxxuM2S9j1nDpbPmlCPzh
	 Ifa7tKT4y/JUA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 20/38] xfs: plumb struct xfs_trans *tp into xfs_bmapi_convert_one_delalloc
Date: Wed, 19 Aug 2026 10:12:23 +1000
Message-ID: <20260819001442.1451892-21-dgc@kernel.org>
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

Add a struct xfs_trans *tp parameter to xfs_bmapi_convert_one_delalloc().
When a non-NULL transaction is provided, use it directly instead of
allocating one internally, and skip the ILOCK acquisition and
xfs_trans_ijoin() since the caller already holds the ILOCK with the
inode joined to the transaction.

On success with a caller-supplied transaction, the function returns
without committing or unlocking. On error, it returns the error
without cancelling or unlocking.

When tp is NULL, the existing behaviour is preserved.

All callers currently pass NULL, so there is no functional change.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 43 ++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 47c4d5c52b95..7f3a3a02a035 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4351,6 +4351,7 @@ xfs_bmapi_write(
  */
 static int
 xfs_bmapi_convert_one_delalloc(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_off_t		offset,
@@ -4362,23 +4363,27 @@ xfs_bmapi_convert_one_delalloc(
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	struct xfs_bmalloca	bma = { NULL };
 	uint16_t		flags = 0;
-	struct xfs_trans	*tp;
+	struct xfs_trans	*local_tp = NULL;
 	int			error;
 
 	if (whichfork == XFS_COW_FORK)
 		flags |= IOMAP_F_SHARED;
 
-	/*
-	 * Space for the extent and indirect blocks was reserved when the
-	 * delalloc extent was created so there's no need to do so here.
-	 */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
-				XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
+	if (!tp) {
+		/*
+		 * Space for the extent and indirect blocks was reserved when
+		 * the delalloc extent was created so there's no need to do so
+		 * here.
+		 */
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
+					XFS_TRANS_RESERVE, &local_tp);
+		if (error)
+			return error;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(local_tp, ip, 0);
+		tp = local_tp;
+	}
 
 	/*
 	 * Look up the extent before extending the extent count so that we
@@ -4470,15 +4475,19 @@ xfs_bmapi_convert_one_delalloc(
 		goto out_finish;
 
 	xfs_bmapi_finish(&bma, whichfork, 0);
-	error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (local_tp) {
+		error = xfs_trans_commit(local_tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
 	return error;
 
 out_finish:
 	xfs_bmapi_finish(&bma, whichfork, error);
 out_trans_cancel:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (local_tp) {
+		xfs_trans_cancel(local_tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
@@ -4503,8 +4512,8 @@ xfs_bmapi_convert_delalloc(
 	 * delalloc extent if free space is sufficiently fragmented.
 	 */
 	do {
-		error = xfs_bmapi_convert_one_delalloc(ip, whichfork, offset,
-					iomap, seq);
+		error = xfs_bmapi_convert_one_delalloc(NULL, ip, whichfork,
+					offset, iomap, seq);
 		if (error)
 			return error;
 	} while (iomap->offset + iomap->length <= offset);
-- 
2.55.0

