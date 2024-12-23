Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043C4187858
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994522; cv=none; b=pJn+07EG5dRpiwYpLR557FI8a+VqZ1qF/mttdMYrz5VVvF3oLC7nTDIVzhZdXmbWvvaADx+pteeGgmTLsAtevUpKedHhznO4e7lBPn9RhmLUbrS2Nvz5QLhcA6OWbEFSc6R5o55/dqLezxsW5plTrzhNb2d+fNwvq/XxGQyna2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994522; c=relaxed/simple;
	bh=P9yJ0kIPlRIXKJ7tn3ftFvACzfTVvwdlMN/DmEblveo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OquAlG+/141weblrPOvvn2mhmaNWQxOwqPFMH+bGjmRT4aMCLOc/Uu7nhdxL9LwZWabvOSMmNGyLhNBXegpRW9qq3JARgAUowf1ZM27aQASjRZ2Ahs5YWxG4ifOq68BONbuddVY7/DlkKN3DOpDrLSSWBJYW6CDV2lgBp647SYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcHdudZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcHdudZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9163CC4CED3;
	Mon, 23 Dec 2024 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994521;
	bh=P9yJ0kIPlRIXKJ7tn3ftFvACzfTVvwdlMN/DmEblveo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HcHdudZ1oBYW4t4GA5ajHWLdeySlq4epjgTpSP0agyBAVB1W4ibOTq6GT1vaGssk4
	 sSkwcZi3IHig4Tje5sWj52ghTPqSG+DMhnIw6fuxNhyBfU7p3cPrnmCkNj03o1KxZd
	 xkyCh6dXyAwfqf+jOxOcDxZhFdqbDqmNCLsoDHvGY3j9aVQlg4xoUOlgA51+DHk/1Y
	 PPiHS7m4MG1mkYGxzvfBa38NrhZuFRAIu6mW1Rz30r5dyBTnXTbex6CLtJurbs7v2K
	 aQ3+cEdlBHHAWerpF/roTFYekTlQE/7bJR2ZwjUHP93tJ31Jd64KdhZwwrpgt/nlK8
	 N0YlnsX6pDqaQ==
Date: Mon, 23 Dec 2024 14:55:21 -0800
Subject: [PATCH 5/8] xfs: tidy up xfs_bmap_broot_realloc a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499417685.2379682.1214119943738759992.stgit@frogsfrogsfrogs>
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

Hoist out the code that migrates broot pointers during a resize
operation to avoid code duplication and streamline the caller.  Also
use the correct bmbt pointer type for the sizeof operation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   43 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 22cf2059d54dd4..908d7b050e9ce0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -516,6 +516,22 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
+static inline void
+xfs_bmbt_move_ptrs(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*broot,
+	short			old_size,
+	size_t			new_size,
+	unsigned int		numrecs)
+{
+	void			*dptr;
+	void			*sptr;
+
+	sptr = xfs_bmap_broot_ptr_addr(mp, broot, 1, old_size);
+	dptr = xfs_bmap_broot_ptr_addr(mp, broot, 1, new_size);
+	memmove(dptr, sptr, numrecs * sizeof(xfs_bmbt_ptr_t));
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records.  Move the
  * records and pointers in if_broot to fit the new size.  When shrinking this
@@ -541,8 +557,7 @@ xfs_bmap_broot_realloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	char			*np;
-	char			*op;
+	struct xfs_btree_block	*broot;
 	unsigned int		new_size;
 	unsigned int		old_size = ifp->if_broot_bytes;
 
@@ -577,15 +592,11 @@ xfs_bmap_broot_realloc(
 		 * they are kept butted up against the btree block header.
 		 */
 		old_numrecs = xfs_bmbt_maxrecs(mp, old_size, false);
-		xfs_broot_realloc(ifp, new_size);
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     old_size);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     (int)new_size);
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+		broot = xfs_broot_realloc(ifp, new_size);
+		ASSERT(xfs_bmap_bmdr_space(broot) <=
 			xfs_inode_fork_size(ip, whichfork));
-		memmove(np, op, old_numrecs * (uint)sizeof(xfs_fsblock_t));
-		return ifp->if_broot;
+		xfs_bmbt_move_ptrs(mp, broot, old_size, new_size, old_numrecs);
+		return broot;
 	}
 
 	/*
@@ -599,15 +610,11 @@ xfs_bmap_broot_realloc(
 	 * not butted up against the btree block header, then reallocating
 	 * broot.
 	 */
-	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1, old_size);
-	np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-					     (int)new_size);
-	memmove(np, op, new_numrecs * (uint)sizeof(xfs_fsblock_t));
-
-	xfs_broot_realloc(ifp, new_size);
-	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+	xfs_bmbt_move_ptrs(mp, ifp->if_broot, old_size, new_size, new_numrecs);
+	broot = xfs_broot_realloc(ifp, new_size);
+	ASSERT(xfs_bmap_bmdr_space(broot) <=
 	       xfs_inode_fork_size(ip, whichfork));
-	return ifp->if_broot;
+	return broot;
 }
 
 static struct xfs_btree_block *

