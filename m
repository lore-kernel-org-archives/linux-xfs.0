Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2292F128823
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424927; cv=none; b=qAdTSLqBry0BToARIaPpZWP/ZS9WcFSM2RYSvA9bJcf3qj4c0T8Z/n1JUEftdjfzLS8w79qQl8lGlZcWq2uxMXtTDe5PAdRSPZwJfTxqRa9tmlOwN/iVkefoHXU4TniJS+702NjvklgM/gCvGWskr36cQQ8NHkBH2i0/wcDuK30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424927; c=relaxed/simple;
	bh=YSpFh27Q4Q/wiikRzqqT3fmULpE2WYdqfXHqvwNEOT4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EanfCgq3A7TKiyMJP3v+d1x8RzgOdtR2WgpNr+fJOoWhy5D9azmkAxlKmjOvBUnslNaOANrJeAJPXcAkZvVVRTeJEhj4anFdhjt4uLhn/2FwRZcFrLfoR2KeG2Jz+py1F0O47dpE2J2b+wzyjKLgaFcxnsZvoZKd5tcayf4ZS+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nY+xhHxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nY+xhHxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED004C433C7;
	Tue, 26 Mar 2024 03:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424927;
	bh=YSpFh27Q4Q/wiikRzqqT3fmULpE2WYdqfXHqvwNEOT4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nY+xhHxZFLNMMr67Dwne1DAbdO9SUx+Cz4eQQ6LzbGylfF2MgaA3eJadv7jX8/4xZ
	 wljg8m7MgZGBG5/u2W/qbgQImxDyaubpTE0iniPs8zf5k6aYmAQAhVrZByNWb72XWp
	 t/hvyX7qpQnszB4mVM3e7jgHN0WZ718MVuDp1fBLj7swS0iGZ6bBOJ7NCn09nR/hjR
	 fVfMOAbt41d/okIJYLCS+35vGkCt98vP3WsiP0qOP1PIa6IKEKJfKOKxa23Re+Xtlv
	 i6HuxFEAmVzwyfZnrUbjWxLXWHOVOKaA5xEARQcy7oPk4oortjdmygv5RPiX8uQFMR
	 7pX7ZByKxy18w==
Date: Mon, 25 Mar 2024 20:48:46 -0700
Subject: [PATCH 078/110] xfs: consolidate btree ptr checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132503.2215168.674317608283046876.stgit@frogsfrogsfrogs>
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

Source kernel commit: 57982d6c835a71da5c66e6090680de1adf6e736a

Merge xfs_btree_check_sptr and xfs_btree_check_lptr into a single
__xfs_btree_check_ptr that can be shared between xfs_btree_check_ptr
and the scrub code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   60 +++++++++++++++++++++++++---------------------------
 libxfs/xfs_btree.h |   21 +++---------------
 2 files changed, 32 insertions(+), 49 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 55775ddf0a22..4fb167f57f8a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -239,28 +239,27 @@ xfs_btree_check_block(
 		return xfs_btree_check_sblock(cur, block, level, bp);
 }
 
-/* Check that this long pointer is valid and points within the fs. */
-bool
-xfs_btree_check_lptr(
-	struct xfs_btree_cur	*cur,
-	xfs_fsblock_t		fsbno,
-	int			level)
+int
+__xfs_btree_check_ptr(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				index,
+	int				level)
 {
 	if (level <= 0)
-		return false;
-	return xfs_verify_fsbno(cur->bc_mp, fsbno);
-}
+		return -EFSCORRUPTED;
 
-/* Check that this short pointer is valid and points within the AG. */
-bool
-xfs_btree_check_sptr(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		agbno,
-	int			level)
-{
-	if (level <= 0)
-		return false;
-	return xfs_verify_agbno(cur->bc_ag.pag, agbno);
+	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
+		if (!xfs_verify_fsbno(cur->bc_mp,
+				be64_to_cpu((&ptr->l)[index])))
+			return -EFSCORRUPTED;
+	} else {
+		if (!xfs_verify_agbno(cur->bc_ag.pag,
+				be32_to_cpu((&ptr->s)[index])))
+			return -EFSCORRUPTED;
+	}
+
+	return 0;
 }
 
 /*
@@ -274,27 +273,26 @@ xfs_btree_check_ptr(
 	int				index,
 	int				level)
 {
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
-		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
-				level))
-			return 0;
-		xfs_err(cur->bc_mp,
+	int				error;
+
+	error = __xfs_btree_check_ptr(cur, ptr, index, level);
+	if (error) {
+		if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
+			xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ino.ip->i_ino,
 				cur->bc_ino.whichfork, cur->bc_ops->name,
 				level, index);
-	} else {
-		if (xfs_btree_check_sptr(cur, be32_to_cpu((&ptr->s)[index]),
-				level))
-			return 0;
-		xfs_err(cur->bc_mp,
+		} else {
+			xfs_err(cur->bc_mp,
 "AG %u: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ag.pag->pag_agno, cur->bc_ops->name,
 				level, index);
+		}
+		xfs_btree_mark_sick(cur);
 	}
 
-	xfs_btree_mark_sick(cur);
-	return -EFSCORRUPTED;
+	return error;
 }
 
 #ifdef DEBUG
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 9a264ffee303..ca4a305eb071 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -343,6 +343,9 @@ xfs_failaddr_t __xfs_btree_check_lblock(struct xfs_btree_cur *cur,
 xfs_failaddr_t __xfs_btree_check_sblock(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
 
+int __xfs_btree_check_ptr(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int index, int level);
+
 /*
  * Check that block header is ok.
  */
@@ -353,24 +356,6 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block, if any */
 
-/*
- * Check that (long) pointer is ok.
- */
-bool					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lptr(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_fsblock_t		fsbno,	/* btree block disk address */
-	int			level);	/* btree block level */
-
-/*
- * Check that (short) pointer is ok.
- */
-bool					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_sptr(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agblock_t		agbno,	/* btree block disk address */
-	int			level);	/* btree block level */
-
 /*
  * Delete the btree cursor.
  */

