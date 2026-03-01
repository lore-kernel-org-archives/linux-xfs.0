Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A051D2D7D47;
	Sun,  1 Mar 2026 01:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328836; cv=none; b=atdEbSRCGPgvIwNLuvYmeBfdsVrEeIdDI2m6gliYoF2g+qrsX+s4/R/ghyKActdrlUoAZB3ox3UbY+BnClet4MypvQPvfpr1VpUAySZcafMEDsDLAyJNRODz4DZ4GfCSDIPRLNMB73TZhtU93fcMECrtykwtuy+xO6Cwkeoe3UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328836; c=relaxed/simple;
	bh=8O5l/a/rrrN62FQMgVTOn+v5q63br84ov/F75O5q68g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=igtw18kM6Q/wzMjOUiZh/iRIuJxVwnY4UevhMAWNNHbUhReNxaESYtpH9oSx+EbGdEDS6XvfJ3tuGgNN+8PWxmF4r8rMk7leVLvfW202Xyv+FrKVT6DZqcP0Mq27G6pjucds4qTk1rJOWVOBK08sxX0TCmky3hphJPtnRwnXg+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+gN6XX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+gN6XX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC3CC19424;
	Sun,  1 Mar 2026 01:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328836;
	bh=8O5l/a/rrrN62FQMgVTOn+v5q63br84ov/F75O5q68g=;
	h=From:To:Cc:Subject:Date:From;
	b=m+gN6XX9WtHvw6+8QTjVqrsjwoKYarQCfpksS81fhW5wn4TdUFlufXDIb/+uQ3iDd
	 dijwGf2paJcopKG9MW0Qk1BEYazpepvQpL79tCVw9rlrQ7ai0w+7dq+1kSI3mHk2SW
	 pkTUtMq7nhghEsS2HTylS85niHhhRqHEw6tFJFUAndt2X4o9uZDgDAYSYtKqCsEwGq
	 IS1uKBKEHFehRjObeJgHA9cdMvwTpUcYZpVPbUv+vOjDGGgJtjtg+SMxGvp6UwNzyv
	 TYqYaR7usko/FbnZBZ79pudDgZPa7jYzxN5x2fcpubWJ0yIM15plURQZALjVl1ysrt
	 L9Bpmwbq/d+lg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	hch@lst.de
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: remove xfs_attr_leaf_hasname" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:33:54 -0500
Message-ID: <20260301013354.1693231-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 3a65ea768b8094e4699e72f9ab420eb9e0f3f568 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 9 Jan 2026 16:17:40 +0100
Subject: [PATCH] xfs: remove xfs_attr_leaf_hasname

The calling convention of xfs_attr_leaf_hasname() is problematic, because
it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
non-NULL buffer pointer for an already released buffer when
xfs_attr3_leaf_lookup_int fails with other error values.

Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
that the buffer release code is done by each caller of
xfs_attr3_leaf_read.

Cc: stable@vger.kernel.org # v5.19+
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Reported-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 75 +++++++++++++---------------------------
 1 file changed, 24 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 866abae58fe1e..9e6b18d6ae003 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -50,7 +50,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -979,11 +978,12 @@ xfs_attr_lookup(
 		return error;
 
 	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_hasname(args, &bp);
-
-		if (bp)
-			xfs_trans_brelse(args->trans, bp);
-
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+				0, &bp);
+		if (error)
+			return error;
+		error = xfs_attr3_leaf_lookup_int(bp, args);
+		xfs_trans_brelse(args->trans, bp);
 		return error;
 	}
 
@@ -1222,27 +1222,6 @@ xfs_attr_shortform_addname(
  * External routines when attribute list is one block
  *========================================================================*/
 
-/*
- * Return EEXIST if attr is found, or ENOATTR if not
- */
-STATIC int
-xfs_attr_leaf_hasname(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**bp)
-{
-	int                     error = 0;
-
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, bp);
-	if (error)
-		return error;
-
-	error = xfs_attr3_leaf_lookup_int(*bp, args);
-	if (error != -ENOATTR && error != -EEXIST)
-		xfs_trans_brelse(args->trans, *bp);
-
-	return error;
-}
-
 /*
  * Remove a name from the leaf attribute list structure
  *
@@ -1253,25 +1232,22 @@ STATIC int
 xfs_attr_leaf_removename(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp;
-	struct xfs_buf		*bp;
+	struct xfs_inode	*dp = args->dp;
 	int			error, forkoff;
+	struct xfs_buf		*bp;
 
 	trace_xfs_attr_leaf_removename(args);
 
-	/*
-	 * Remove the attribute.
-	 */
-	dp = args->dp;
-
-	error = xfs_attr_leaf_hasname(args, &bp);
-	if (error == -ENOATTR) {
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
+	if (error)
+		return error;
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error != -EEXIST) {
 		xfs_trans_brelse(args->trans, bp);
-		if (args->op_flags & XFS_DA_OP_RECOVERY)
+		if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
 			return 0;
 		return error;
-	} else if (error != -EEXIST)
-		return error;
+	}
 
 	xfs_attr3_leaf_remove(bp, args);
 
@@ -1295,23 +1271,20 @@ xfs_attr_leaf_removename(
  * Returns 0 on successful retrieval, otherwise an error.
  */
 STATIC int
-xfs_attr_leaf_get(xfs_da_args_t *args)
+xfs_attr_leaf_get(
+	struct xfs_da_args	*args)
 {
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_buf		*bp;
+	int			error;
 
 	trace_xfs_attr_leaf_get(args);
 
-	error = xfs_attr_leaf_hasname(args, &bp);
-
-	if (error == -ENOATTR)  {
-		xfs_trans_brelse(args->trans, bp);
-		return error;
-	} else if (error != -EEXIST)
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
+	if (error)
 		return error;
-
-
-	error = xfs_attr3_leaf_getvalue(bp, args);
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error == -EEXIST)
+		error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
 	return error;
 }
-- 
2.51.0




