Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740E357CA6
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347410; cv=none; b=rL432YLkP8KGkpQMxcKp2h476gze9sy3/RKekLS1vM9Jwho82sScO3vXb1/lZxZJ9j9R/QJAaES9rYBGeYfQB4ad2+Q4E3rPBF5529PUCeUGyzIDMkRJufzAm2Vl3jq8RzFdbjKdc5Y05vgGDy5tV8PkapFFVctiut7kiMSRPOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347410; c=relaxed/simple;
	bh=iOy3UXlgl5pNHXwM0Zdcokm++91aKa/AKN3gHocb7YI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBaURKpZXNWRUQoFBeMS0uceIrlvEagBKDKXRPoT84HThHp1T2tuC1oR9udztVL1F/vgupCFi4K3+W5NqY7SuuNRs+t/XbeW/wdJUXQiidF/G/J2cyDfajX9OfqC4n8LklAvMFpzSnuJVaArafGThRHCNSgbh5eKfNJZbIMtVZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfG0xUf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfG0xUf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A217C2BD11;
	Wed, 22 May 2024 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347410;
	bh=iOy3UXlgl5pNHXwM0Zdcokm++91aKa/AKN3gHocb7YI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tfG0xUf1kUptBEFBXZwfSPcD5F6KIwBNjrNS5F60i+8RrJCy5dc7Lacdytc/wlqKS
	 DujkyEE74exv4JLSnRv1eKf27OuYWn2MAb5cJ7ZMdasR7y3Cr+lJlNr7HpYhEW4pYY
	 ANwYmqWH9D3QgV9GniEhVzuLgINglTk6ZMt9scOp8lWcoxF8d1BXI8MEq/+tVE5Qsd
	 BoNI9w1xSrACpg0woGhgHOtRqKKs9VY49iFlRRJyd4vl6ZE2xkUsOMOV2Ypuzw8BSS
	 Igcak+KPSY+S5HI4N1hxiIvhPHI+pTf2d9KHf3aiw92l0G5easuOr3AZDGEsnTCWSb
	 5TPNy6/JFKHdQ==
Date: Tue, 21 May 2024 20:10:09 -0700
Subject: [PATCH 082/111] xfs: consolidate btree block verification
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532929.2478931.2723150847555803392.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4ce0c711d9ab3a435bc605cd2f36a3f6b4e12c05

Add a __xfs_btree_check_block helper that can be called by the scrub code
to validate a btree block of any form, and move the duplicate error
handling code from xfs_btree_check_sblock and xfs_btree_check_lblock into
xfs_btree_check_block and thus remove these two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   72 ++++++++++++++++++++++------------------------------
 libxfs/xfs_btree.h |    9 +------
 2 files changed, 31 insertions(+), 50 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2f5848b9d..fae121ace 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -95,7 +95,7 @@ xfs_btree_check_sblock_siblings(
  * Check a long btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
  */
-xfs_failaddr_t
+static xfs_failaddr_t
 __xfs_btree_check_lblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -144,33 +144,11 @@ __xfs_btree_check_lblock(
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
@@ -206,26 +184,28 @@ __xfs_btree_check_sblock(
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
@@ -238,10 +218,18 @@ xfs_btree_check_block(
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ca4a305eb..d3afa6209 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
 

