Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B6313C68A
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441944; cv=none; b=YlG7rEuT6jHGZN+LfceBxTy+DohV9HpbYLlw/f0s5j5kdEQ9Iio9EXnnbLFX+oUOtG+EGwmbGiugxB4+zONQJvGtEnSUXKUBFsR2AFrp2w0zkmIWUfaPaDSm5Jagdbqup7PkzIo3+8CgENE4RTbC3wZPRxtY3Bc9xgDDpD2l0KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441944; c=relaxed/simple;
	bh=LAUhVW4K0xbz7vY3IOuYaBFjnDIzVNqvV9g9WH6GIK4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JK9meIXBmrTA2nP5YpEpy2wBTKT+maTl5a/mSaNgE+VZFiP7HJbvUY0/D2pDj90M08VoyyfOO9tQ5lKPHXoV5SddoTy2FlNca9S6r/WRw/Ht1ug2HSj3DAX0yan+PD8GBtvX61arDJRWFGuTOKJPPNdyO9P47TovbQ2iy+Fyupc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPNRC7Ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPNRC7Ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9D6C2BD10;
	Mon,  3 Jun 2024 19:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441943;
	bh=LAUhVW4K0xbz7vY3IOuYaBFjnDIzVNqvV9g9WH6GIK4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mPNRC7Ca8jp9WFo/uyHUWUE+YVW/T7HrDwu7hl0Ct+oARsyiqIeKhEHk6GHsNrJ0D
	 qM00SuASb0yj3JCVBMhM7yWb5AulH/bsqWaXIAP18ILnL5Jv67/mKKuJRR4szAZ3ga
	 IgzL2RN4oD6bZ7ePUlbOWhLP2W9A4x3zQg+iVu8DdsXSd2Gg4/ulAnvTGxWXDzp/be
	 Wi2LHJGb4jxXdSv0ejuUHb+q/jlZgYU7lh3HtFJjb7IT7TQpELKjWWbTpoIqTCecp6
	 NVARM6is5E4iWpSJwE3zC3G9KlI2C3DDFHlEziU5gd+LRnXLUPqNp9EE2AjCoZ8lWD
	 C9eOtN/RL4nZQ==
Date: Mon, 03 Jun 2024 12:12:23 -0700
Subject: [PATCH 078/111] xfs: consolidate btree ptr checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040542.1443973.6138267426329215684.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   60 +++++++++++++++++++++++++---------------------------
 libxfs/xfs_btree.h |   21 +++---------------
 2 files changed, 32 insertions(+), 49 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 55775ddf0..4fb167f57 100644
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
index 9a264ffee..ca4a305eb 100644
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

