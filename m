Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A80712A159
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424990; cv=none; b=itVKlVkDdK9bV/4IufV3mleUkMHDQrHWMFssvu2gkst6XQAvYLa9QmsrBY37deoQWlYl48oZpNHzpUiRbeISgYmRGLtqv51uhQQ0/1Wvurp3YpuakjbNjdis50byN+4oH7QsxYeOxcX+rvEC7A/O4LqYIHSgw9tzISOSbwPhzIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424990; c=relaxed/simple;
	bh=K+yV7J5KP8u5PZe5UGkfanlrTVQy9N3qbKUibxceuJ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SvWW2xd+8eK7D9ard/EhRtzxfa6V4tKNb1dJuf6MQ8lZI8Py6y/gsTbhoQ1jb0/tZUyrPico7cwj9UpMyOEGir/jDtcuILDDLL96xfji3GptWwWpdbAE3uZfTBU+0PfVpp9jMokRZ93RT9JQUjGE0c26AX8hFHmZGLiWEdpRC0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhxnQLZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhxnQLZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A03EC433F1;
	Tue, 26 Mar 2024 03:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424989;
	bh=K+yV7J5KP8u5PZe5UGkfanlrTVQy9N3qbKUibxceuJ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qhxnQLZ0JZbBQX+NdwDjb+/UHknZJs4RCdjPnEOzw6ZRzRuPFE2XYdSEKZdCqQtTQ
	 E1G87o+6ec1A8a0Vfs6CddjEpaCiOml6MTNCWDibYbwE1eP2sSIgGCyoNTZOMm2Vy4
	 pY/ge2FSRYgCerCRbzBn3vl2LNf78CgePRz6x39EtQO3N68JAWqoaq2g5zFH6b8kGc
	 LywaqNcwxjPYjVVA8tEEF+6a/4iPJtPt+qVhLkdCU/JRTYz0KQ8tzZW49tW4HGf+xX
	 phEgJOp1XSaNFaTaUN5I+XadEcM0V8MDjSd3l6SPeD1Hrwt7QMmrtJp1vtYn/A/T3L
	 q2BgMX7uztP6A==
Date: Mon, 25 Mar 2024 20:49:49 -0700
Subject: [PATCH 082/110] xfs: consolidate btree block verification
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132562.2215168.14673593117612395564.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 2f5848b9d51b..fae121acecb4 100644
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
index ca4a305eb071..d3afa6209ff8 100644
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
 

