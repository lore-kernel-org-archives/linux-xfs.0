Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A16223C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881385; cv=none; b=pT0zjhkTrRLdESxkacmSOohMrc4UPrjYh/xcAqWC4HNYhCXIeG+/FCAVxWyr/f0XFoQVNLw/222OCLOHpE5Qf9oEUEk6dn0EDjd1boQWHO5onbV8jNTpM6knIfA1xIoUDA6w15pNUpZE7szN0v1evFpoLWgCcS72W+ij4o7Jfbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881385; c=relaxed/simple;
	bh=f8gcgP6beYLz7/rhSVMwV61qqrjzedcQ7C/PJlNZqYk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QX403JtG80YfRIcCCmGzHb6XDZWIhftFqamEHM5MYYv/yjI/2ZICVZdK+ZEbk9J/PZf5gFgshspE03WVyzP84ywEvWWCqDLVjzFoiYZlRshTJnO4PyqvpPgg33cSAXII8ORdjev24lP7ImBf9REAYds92MfXj+BE6+ac+pbaikk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bK/v6Hgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bK/v6Hgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F953C4CEDD;
	Thu,  6 Feb 2025 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881385;
	bh=f8gcgP6beYLz7/rhSVMwV61qqrjzedcQ7C/PJlNZqYk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bK/v6HggQGAE20zSvytVCt3mTS8DBzTB/J6MchxC06ug1OpDfCcAN5An7I2T8qIxq
	 8N0G8IVsnPbfJvqUej91EfWhUglWuuxrLSo5XAXnFWk7yuY6D03PmntVMlwMZZQ1MQ
	 Y9ZU4WgHS2G6p26tOE81BRFs3vjTsaskeg+jAMtD9AeIjqWwcwR1MiqcJO35jkC/jy
	 dFe1r+ofz0fkBiFzlW+uac1sF4kcwy7h2mJvigZhTTXaE7JA3sjhjGcAT/5bup90/X
	 3XMUXILWbpFvvHfnavPqQarrg/ZlK7c+jci1He+iRXovF+7/CFyehoSGUJYLRg3+Px
	 /NCcRhxl4Hjqg==
Date: Thu, 06 Feb 2025 14:36:24 -0800
Subject: [PATCH 05/56] xfs: tidy up xfs_bmap_broot_realloc a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086867.2739176.755268644443590548.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c914081775e2e39e4afa9b4bb9e5c98202110f51

Hoist out the code that migrates broot pointers during a resize
operation to avoid code duplication and streamline the caller.  Also
use the correct bmbt pointer type for the sizeof operation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap_btree.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index baae9ab91fa908..40e0cb3016fc5e 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -515,6 +515,22 @@ xfs_bmbt_keys_contiguous(
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
@@ -540,8 +556,7 @@ xfs_bmap_broot_realloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	char			*np;
-	char			*op;
+	struct xfs_btree_block	*broot;
 	unsigned int		new_size;
 	unsigned int		old_size = ifp->if_broot_bytes;
 
@@ -576,15 +591,11 @@ xfs_bmap_broot_realloc(
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
@@ -598,15 +609,11 @@ xfs_bmap_broot_realloc(
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

