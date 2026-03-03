Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F0619C540
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496949; cv=none; b=Fgdwf/GPw0fHWazpuzj4yM40aq2vdOLFXNuwRDxYKi05lj197ytofIlNzWP0ZjG97GSM7ST8NLcbr+LPwJ3VNlcNaq11nzgHnx8GVcucMNDMuiFznny2x20lU9Tfg91TJ0cEroEiZrX8/zvbaqRgC+XorH2hJngeDA2FQw7ratg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496949; c=relaxed/simple;
	bh=/Zhe9fHctvRtxFFVOMlUSFncsQh/pOx68oGj5c/DYlk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=noalp/vjb7lsgewqkA+AllM3+/o/syaR7Ualo5F0w1psWUlSAFo9sccxYTIu20yBIroSYHuGTGkCSHKgf2A+Rx+BNC+Ltyxc11F3NlzpFlIQeiRatmne+U+MlJQiHMx9FYS6Daiw0kXOzl/2ESaAh2xVeBU6+E4bhkoGsOCnPv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loGOUwED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loGOUwED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADB5C19423;
	Tue,  3 Mar 2026 00:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496948;
	bh=/Zhe9fHctvRtxFFVOMlUSFncsQh/pOx68oGj5c/DYlk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=loGOUwEDLMwQMBtXaMUUMz2hd/B5esHznERNA9McpI3qJ5Fa+E8GsWYeJ0C6hEftH
	 cU3Sbken+745hzt+h75otU9GpYBhMegipgKyTyW0vaL3pRXVlK3Vizewq913PtL4Kd
	 KWi/uQ5FGiOc3TIwt152tSjtVjfqNM09ER9NMIZ2VIV1W95RLEP4/pWGo0wCRE35rv
	 cCkNUx3pKevOfEQu0da5gFVFHYGhSoFiCo4k7Xec+ZyxakUPn8gmDgvVsJzKvs/3Yl
	 abRrq4pLSkIMtNKsYgvWvLOpdPcoTw19qDTxYNVHgg94aHKesWygnkVoaN1JaVF6zK
	 3UVh8pGNTds5A==
Date: Mon, 02 Mar 2026 16:15:48 -0800
Subject: [PATCH 14/36] xfs: remove xfs_attr_leaf_hasname
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, mark.tinguely@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <177249638037.457970.10428615161023687723.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 3a65ea768b8094e4699e72f9ab420eb9e0f3f568

The calling convention of xfs_attr_leaf_hasname() is problematic, because
it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
non-NULL buffer pointer for an already released buffer when
xfs_attr3_leaf_lookup_int fails with other error values.

Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
that the buffer release code is done by each caller of
xfs_attr3_leaf_read.

Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Reported-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c |   75 +++++++++++++++++------------------------------------
 1 file changed, 24 insertions(+), 51 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 72b701f1b6dcae..baf617cfeabe00 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -49,7 +49,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -978,11 +977,12 @@ xfs_attr_lookup(
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
 
@@ -1221,27 +1221,6 @@ xfs_attr_shortform_addname(
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
@@ -1252,25 +1231,22 @@ STATIC int
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
 
@@ -1294,23 +1270,20 @@ xfs_attr_leaf_removename(
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
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
+	if (error)
 		return error;
-	} else if (error != -EEXIST)
-		return error;
-
-
-	error = xfs_attr3_leaf_getvalue(bp, args);
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error == -EEXIST)
+		error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
 	return error;
 }

