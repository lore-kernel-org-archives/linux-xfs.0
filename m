Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DB37462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994461; cv=none; b=sortkr6yGzDw7x6jth1kd18Pvpd18YZGoq+OvfF3fgnDxl18wjR3OAGeebrTlCkPliTjhR9FxBjU96Gaf5dXmw+vIVPlYFxMVdUts4Af80tLR0L4gdTmKSZdUfK+52AyjmMsrMvKTccnE4l0KNANN/7LP9IiINSgxWOWiS6j90s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994461; c=relaxed/simple;
	bh=5XM9eyAqCdMecumvdfR3x9tV+L4CxWKFxVCfCmI9bfk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjVP6Aa8yh9n3z7TgZtPxIe8MXoUhqBLHak325PoYG4YGLptDY/RggPYyfBvbwH0xuEQMCwVa0q9UF3T5+y4E5ygioG7/gzbQ7ckyO53ZfQdB8rtcZLEfukRw0VVhgzvssZpsv3amDRStgpeo+fEKFDsXtrvQ5z0AxOgnEtKzVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMRqQ4aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMRqQ4aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB9AC4CED3;
	Mon, 23 Dec 2024 22:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994459;
	bh=5XM9eyAqCdMecumvdfR3x9tV+L4CxWKFxVCfCmI9bfk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VMRqQ4awljUWYwjn2fQxtqIQ9fmJ6BjAhP9FeyRNUKuAmrVD579QHV07g/kApnIfv
	 sTEkcNRfHwcSVx80yaiVZD8cTaVUKWLPb2JSGaU3kj/Rbv+y1ATUZx9Yw6RAJnSFBw
	 kyL1QA5tBRlR7aU5WtPpwDXljii4qnID+tAw3Khbzgt367m6BaHbugY3toY2ZJiL0c
	 70YoZCYqQwnSGNgLpoUyAle6ATH6aMKIz7Vzy/nEO7cLXFZ/BopBxjRLZpZ3+b7yA/
	 +hj98Fy42qlMWtmfgSw5q3tjgtb4wviLu6kX7A8fIKqefwjhsfMg//23Jm9sITi87o
	 tBGfZcwXgBZFQ==
Date: Mon, 23 Dec 2024 14:54:18 -0800
Subject: [PATCH 1/8] xfs: tidy up xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499417616.2379682.655728418659965836.stgit@frogsfrogsfrogs>
In-Reply-To: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
References: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Tidy up this function a bit before we start refactoring the memory
handling and move the function to the bmbt code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   83 +++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 43 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1158ca48626b71..7f865479c4159f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -382,33 +382,32 @@ xfs_iformat_attr_fork(
  */
 void
 xfs_iroot_realloc(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	int			rec_diff,
 	int			whichfork)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	int			cur_max;
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*new_broot;
-	int			new_max;
-	size_t			new_size;
 	char			*np;
 	char			*op;
+	size_t			new_size;
+	short			old_size = ifp->if_broot_bytes;
+	int			cur_max;
+	int			new_max;
 
 	/*
 	 * Handle the degenerate case quietly.
 	 */
-	if (rec_diff == 0) {
+	if (rec_diff == 0)
 		return;
-	}
 
-	ifp = xfs_ifork_ptr(ip, whichfork);
 	if (rec_diff > 0) {
 		/*
 		 * If there wasn't any memory allocated before, just
 		 * allocate it now and get out.
 		 */
-		if (ifp->if_broot_bytes == 0) {
+		if (old_size == 0) {
 			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
 			ifp->if_broot = kmalloc(new_size,
 						GFP_KERNEL | __GFP_NOFAIL);
@@ -422,13 +421,13 @@ xfs_iroot_realloc(
 		 * location.  The records don't change location because
 		 * they are kept butted up against the btree block header.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false);
+		cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
 		new_max = cur_max + rec_diff;
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_KERNEL | __GFP_NOFAIL);
 		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
+						     old_size);
 		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 						     (int)new_size);
 		ifp->if_broot_bytes = (int)new_size;
@@ -443,52 +442,50 @@ xfs_iroot_realloc(
 	 * if_broot buffer.  It must already exist.  If we go to zero
 	 * records, just get rid of the root and clear the status bit.
 	 */
-	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false);
+	ASSERT(ifp->if_broot != NULL && old_size > 0);
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	else
 		new_size = 0;
-	if (new_size > 0) {
-		new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
-		/*
-		 * First copy over the btree block header.
-		 */
-		memcpy(new_broot, ifp->if_broot,
-			xfs_bmbt_block_len(ip->i_mount));
-	} else {
-		new_broot = NULL;
+	if (new_size == 0) {
+		ifp->if_broot = NULL;
+		ifp->if_broot_bytes = 0;
+		return;
 	}
 
 	/*
-	 * Only copy the keys and pointers if there are any.
+	 * Shrink the btree root by allocating a smaller object and copying the
+	 * fields from the old object to the new object.  krealloc does nothing
+	 * if we realloc downwards.
 	 */
-	if (new_max > 0) {
-		/*
-		 * First copy the keys.
-		 */
-		op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
-		np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
+	new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
+	/*
+	 * First copy over the btree block header.
+	 */
+	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
+
+	/*
+	 * First copy the keys.
+	 */
+	op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
+	np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
+	memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
+
+	/*
+	 * Then copy the pointers.
+	 */
+	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1, old_size);
+	np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1, (int)new_size);
+	memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
 
-		/*
-		 * Then copy the pointers.
-		 */
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1,
-						     (int)new_size);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
-	}
 	kfree(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = (int)new_size;
-	if (ifp->if_broot)
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-			xfs_inode_fork_size(ip, whichfork));
-	return;
+	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+	       xfs_inode_fork_size(ip, whichfork));
 }
 
 

