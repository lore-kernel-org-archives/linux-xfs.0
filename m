Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF805318EF0
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291529; cv=none; b=CWiHg42yxNs8QEPTIeFHSuG1Q1vobGOx2q4usgShda2BbBhE1NDA2ZdhjpKNIjRAJbFIdvCbJl2E5wHNMp2T4vrDQd0/kSKvNmDc2ivUE1WYZKZffEcCSn5bJijOUUT5QH17t5gdMfkMEVWfCmPYlsv7yCS2FaQAfupbyjYsaLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291529; c=relaxed/simple;
	bh=/Zhe9fHctvRtxFFVOMlUSFncsQh/pOx68oGj5c/DYlk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEcRef7RlLpVR2o56Xkwk6ZgaWOU4mqY7MJk6zD1IPrNkFFPLjyaVf6FUAEnyZYA2j3HjTfP68wBSokH2m07/EZhJ4IXwVgtLx/T2B50OFxTqQfKzEDQecR64u75jFzG/VUajfbB3ui3FLH/zjeRu3/W46Bp9qf/+HGpDg/WTqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KI3QY9Vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KI3QY9Vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F7DC4CEF7;
	Mon, 23 Mar 2026 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291529;
	bh=/Zhe9fHctvRtxFFVOMlUSFncsQh/pOx68oGj5c/DYlk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KI3QY9Vy6+V9f9D6GeB5CYi9U6sNzq7eMUOQGXoTC31zYyP65ysU8wd/Q8fLCJl7J
	 lDkjG0EjZ4GnkLPWYXDHucHLZrVbKMQ8JSbUWDzoayTjwMsb+45vZvIC1KxZ5Djhdr
	 C+P73wdSuiSxSwAVv9dqv3YUAI13xmM54JYA2CQmBsS+YHufMNS9M2JDF2q8do2Im5
	 F+Fi3IeGteQ8uSGwHrnbZV5Nv69sIxqaZbeH3xaFcdgWWL4RiYkePpeZhijkuGaEF3
	 u4WIjjf1vg9FVN+V8t5m8RBV+1RY716Y5EXBBUtu+QqxENSGBFzmrudaRFryBvhXn8
	 AB51SQQ7zo2/g==
Date: Mon, 23 Mar 2026 11:45:28 -0700
Subject: [PATCH 16/40] xfs: remove xfs_attr_leaf_hasname
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, mark.tinguely@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429121035.2266274.10559831535373523168.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
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

