Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C211A0AFE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636064; cv=none; b=h64XDPqv5Zmds9eWO45qPwFQyWE0818tl64WbrFrtkyO6yjYyvUyNbpR9h1BeQFA93n9Elo7Nb6ikwbEs6T6uNjbiFzpybPjkWcDD5z5294IucrzD7JK3KRU+z0nOmUOQFSZKc0KvdUg19KO15IK4u8BB7y1mi8xUyusQ1+y8xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636064; c=relaxed/simple;
	bh=5XM9eyAqCdMecumvdfR3x9tV+L4CxWKFxVCfCmI9bfk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1dW18dxZWk4UsKz57QNs5FxA3MksdLuj13ykJnD8vx68tYC78OAbASq10qDH6h3cQJcRehmTKsRE9cpogy4lqG0kEp+uPAtPSNhq5+c5JgstgE9lRXJlUyl87ECiceAxMRz+n2wuTf3olGOl2sIzQ1N9o5pg9BIox6LKr8IFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Indv2bwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Indv2bwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F14C4CECE;
	Thu, 19 Dec 2024 19:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636063;
	bh=5XM9eyAqCdMecumvdfR3x9tV+L4CxWKFxVCfCmI9bfk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Indv2bwFQU/UEnBAZrHuLS1g9kKOGoYGM0BG/9hItIlMrylm5edndYLmsg1IvPuOc
	 auMCYH9vR0llPawpvtzN2/foJ+TGvdyMbwWGsmLTjwcQ/NP01behOkh2Ux5W2/dlVO
	 S5mnJLgFZc9eixC2qSNaDz8jcNIo/F7GIba0y+6br7QZOYRjxzcDDt6werfxDYjWCf
	 kOcpVFAmGsq5PaQ56AGZ3dTOVbeV8aakN5rPMftIKhvR8SHh9FPBPZgvofJZmMh6in
	 h06qsllmwDZDtbhwbZaKosKrE90hrvVk1faLqQ9fl97NUMai1rW087uosZSnxlGbma
	 wEtJA3wCHz8zQ==
Date: Thu, 19 Dec 2024 11:21:03 -0800
Subject: [PATCH 1/8] xfs: tidy up xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463578667.1571062.14494736624608834807.stgit@frogsfrogsfrogs>
In-Reply-To: <173463578631.1571062.6149474539778937307.stgit@frogsfrogsfrogs>
References: <173463578631.1571062.6149474539778937307.stgit@frogsfrogsfrogs>
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
 
 

