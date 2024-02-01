Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7CF43AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817225; cv=none; b=fOA7OF8y6v8YE3BNWJafamq2EmzKm7mhCmYLECr9ahPojrHf4lmXH65UCuRyO/rphRheXpEquZ1G/aRijGkyE5Ma/LN6Epo9TnItnp1KsJAXl0I43jsN9AqT5W7AnYbWx2DvLQZcLCByG/SlbPGNC9hQyNsgoTPPuXx4jh79mzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817225; c=relaxed/simple;
	bh=YjnceyAt1bgWbDPOGkyn8ljeKRmG+WXOL4e7qN4xzQY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMV6csaP82PBjdqCxzWxRsBo3Fuo0bJr4xiZO+PFKxWHiOBQEOeWxbPaS2n4e7jQ60xu2IUvBp3MS/o6lsY7NaLItgaaYaVXqfupjjrSNVvp8Mq4Qj3imrr24+aiXigqVuPnqFLC8jAuUjEJi+JINlHAWR9sDnN0cEwnr8ZJvCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZs6rIQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZs6rIQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5904C433F1;
	Thu,  1 Feb 2024 19:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817224;
	bh=YjnceyAt1bgWbDPOGkyn8ljeKRmG+WXOL4e7qN4xzQY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NZs6rIQLtqA8xvKkBjm5W6d3l4uKAUPeK17gPuc7AYtFZ4IDMozkZVG21KjEe+BTu
	 1wO9lc5XJdgzkcaPhb3QuxLrOl9qjfR8WeJ1bv5BykSA8EQ94MdId9EgojsCGlzTm4
	 eguUXyGatF3Pb6LVEr4ES7L8tWSCtyWk7+fBCFoo0tGRCcxdCz/qWPKrvVP9QmKlss
	 X1j6zeWNv+qZSXhVGvNdQ/busMcA5ngK2lEXHYE6qOla7KXep26VazPqR8IP0rMUly
	 ctUNCmgge/tzJ1brqtw8uSEs5WHzR2/ifQuHygXyVYXvpilOV5zI06iK9r5RcJ9KJd
	 4rxs+y80d88bQ==
Date: Thu, 01 Feb 2024 11:53:44 -0800
Subject: [PATCH 04/10] xfs: consolidate btree ptr checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335677.1606142.13327197520395156514.stgit@frogsfrogsfrogs>
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

Merge xfs_btree_check_sptr and xfs_btree_check_lptr into a single
__xfs_btree_check_ptr that can be shared between xfs_btree_check_ptr
and the scrub code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   60 ++++++++++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_btree.h |   21 ++--------------
 fs/xfs/scrub/btree.c      |   12 +++------
 3 files changed, 36 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index fc877188919e3..1a0816aa50091 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -242,28 +242,27 @@ xfs_btree_check_block(
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
@@ -277,27 +276,26 @@ xfs_btree_check_ptr(
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index c1d8d9895d15d..da9d5d6e12c24 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 187d692a0b58a..6fe5dae06f23c 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -236,22 +236,18 @@ xchk_btree_ptr_ok(
 	int			level,
 	union xfs_btree_ptr	*ptr)
 {
-	bool			res;
-
 	/* A btree rooted in an inode has no block pointer to the root. */
 	if (bs->cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
 	    level == bs->cur->bc_nlevels)
 		return true;
 
 	/* Otherwise, check the pointers. */
-	if (bs->cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		res = xfs_btree_check_lptr(bs->cur, be64_to_cpu(ptr->l), level);
-	else
-		res = xfs_btree_check_sptr(bs->cur, be32_to_cpu(ptr->s), level);
-	if (!res)
+	if (__xfs_btree_check_ptr(bs->cur, ptr, 0, level)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		return false;
+	}
 
-	return res;
+	return true;
 }
 
 /* Check that a btree block's sibling matches what we expect it. */

