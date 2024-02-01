Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC5B8528E
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817288; cv=none; b=Mr/g4ip5elbR443M1/7lnfQJEKEgqcd2ME0BVZsE532TwyzMqJwyAkZ94kbclBXwcyiGeft24pXasZABu1YoQ5EhPasuHR2oiYOgVomFw7gDkuiSFVv+M6dQNZgdk40FBzlCS8vBvntsUuHCw/xmTnvNKrfD7Df0hDzU1B70JPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817288; c=relaxed/simple;
	bh=cnPnCFOC2cEVeKcOBWAkhpIH1cg8C33R042yFq40jjc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aZZ+rf6uUcbU9ftjlD9YBqblPzD39miRLiO97N4rdBvD0bVcB3PvvCkbwC2cH85dFpEuz0Odt9anATHwQdjUVNlcIEf4kMDmhW9ymbHbykLHPyGMrrWkQTmqT9OwTRLRHg4qd4KUc6M1XkZLn3DKVUOMIMmcFjDpOisCWY19Lqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaGR8BWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaGR8BWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68245C433F1;
	Thu,  1 Feb 2024 19:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817287;
	bh=cnPnCFOC2cEVeKcOBWAkhpIH1cg8C33R042yFq40jjc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iaGR8BWqV12aN3sykSDQrhnGOUr20lUwVQX8+hRH/plxpSOyxqk0l6uVH/+35CzA7
	 zBhzkeg0ISSIwsWRVdaQQuWOTKnoNxfsvZw+QanXfwWhU/oxXwOCl7kpTk9g4Wv+fm
	 OkIo1e9j7NcUwa1sMYTPcM6n5R8gaVgBoGSJPMR1PbybTan8U37n5/x+y3SKE0abYD
	 sPJnEIZwcqAFwhgCFYSvugC1xwP5f+qMeDCBDM/rGfsoFPAYi0gD5PwM0/aEfefn/B
	 DNtNIQB20ZnmczyaaMkdipzYFu3c6Pb1i8GPgOkdv51rW9eSq1oOMl0Oi7SAK2jApe
	 ckU1QvnZgzvzQ==
Date: Thu, 01 Feb 2024 11:54:46 -0800
Subject: [PATCH 08/10] xfs: consolidate btree block verification
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335741.1606142.1218479094088731179.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add a __xfs_btree_check_block helper that can be called by the scrub code
to validate a btree block of any form, and move the duplicate error
handling code from xfs_btree_check_sblock and xfs_btree_check_lblock into
xfs_btree_check_block and thus remove these two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   72 +++++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_btree.h |    9 +-----
 fs/xfs/scrub/btree.c      |    9 +-----
 3 files changed, 32 insertions(+), 58 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f5d7c4236963b..c7bd05ffc4ae1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -98,7 +98,7 @@ xfs_btree_check_sblock_siblings(
  * Check a long btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
  */
-xfs_failaddr_t
+static xfs_failaddr_t
 __xfs_btree_check_lblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -147,33 +147,11 @@ __xfs_btree_check_lblock(
 	return fa;
 }
 
-/* Check a long btree block header. */
-static int
-xfs_btree_check_lblock(
-	struct xfs_btree_cur	*cur,
-	struct xfs_btree_block	*block,
-	int			level,
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
-
-	fa = __xfs_btree_check_lblock(cur, block, level, bp);
-	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK)) {
-		if (bp)
-			trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_btree_mark_sick(cur);
-		return -EFSCORRUPTED;
-	}
-	return 0;
-}
-
 /*
  * Check a short btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
  */
-xfs_failaddr_t
+static xfs_failaddr_t
 __xfs_btree_check_sblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -209,26 +187,28 @@ __xfs_btree_check_sblock(
 	return fa;
 }
 
-/* Check a short btree block header. */
-STATIC int
-xfs_btree_check_sblock(
+/*
+ * Internal btree block check.
+ *
+ * Return NULL if the block is ok or the address of the failed check otherwise.
+ */
+xfs_failaddr_t
+__xfs_btree_check_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
+	if (cur->bc_ops->ptr_len == XFS_BTREE_SHORT_PTR_LEN)
+		return __xfs_btree_check_sblock(cur, block, level, bp);
+	return __xfs_btree_check_lblock(cur, block, level, bp);
+}
 
-	fa = __xfs_btree_check_sblock(cur, block, level, bp);
-	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK)) {
-		if (bp)
-			trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_btree_mark_sick(cur);
-		return -EFSCORRUPTED;
-	}
-	return 0;
+static inline unsigned int xfs_btree_block_errtag(struct xfs_btree_cur *cur)
+{
+	if (cur->bc_ops->ptr_len == XFS_BTREE_SHORT_PTR_LEN)
+		return XFS_ERRTAG_BTREE_CHECK_SBLOCK;
+	return XFS_ERRTAG_BTREE_CHECK_LBLOCK;
 }
 
 /*
@@ -241,10 +221,18 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		return xfs_btree_check_lblock(cur, block, level, bp);
-	else
-		return xfs_btree_check_sblock(cur, block, level, bp);
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_failaddr_t		fa;
+
+	fa = __xfs_btree_check_block(cur, block, level, bp);
+	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
+	    XFS_TEST_ERROR(false, mp, xfs_btree_block_errtag(cur))) {
+		if (bp)
+			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
+		return -EFSCORRUPTED;
+	}
+	return 0;
 }
 
 int
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index da9d5d6e12c24..7c0b598178f6f 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -334,15 +334,8 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
  */
 #define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)((bp)->b_addr))
 
-/*
- * Internal long and short btree block checks.  They return NULL if the
- * block is ok or the address of the failed check otherwise.
- */
-xfs_failaddr_t __xfs_btree_check_lblock(struct xfs_btree_cur *cur,
+xfs_failaddr_t __xfs_btree_check_block(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
-xfs_failaddr_t __xfs_btree_check_sblock(struct xfs_btree_cur *cur,
-		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
-
 int __xfs_btree_check_ptr(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, int index, int level);
 
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 6fe5dae06f23c..fe678a0438bc5 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -584,7 +584,6 @@ xchk_btree_get_block(
 	struct xfs_btree_block	**pblock,
 	struct xfs_buf		**pbp)
 {
-	xfs_failaddr_t		failed_at;
 	int			error;
 
 	*pblock = NULL;
@@ -596,13 +595,7 @@ xchk_btree_get_block(
 		return error;
 
 	xfs_btree_get_block(bs->cur, level, pbp);
-	if (bs->cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		failed_at = __xfs_btree_check_lblock(bs->cur, *pblock,
-				level, *pbp);
-	else
-		failed_at = __xfs_btree_check_sblock(bs->cur, *pblock,
-				 level, *pbp);
-	if (failed_at) {
+	if (__xfs_btree_check_block(bs->cur, *pblock, level, *pbp)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 		return 0;
 	}

