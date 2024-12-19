Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ADF1A7265
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636126; cv=none; b=KSBehCPewXBC+nIA6wGMr5qtyuSZOFDxveJCZYfbJcPhuiwyn6aAx0/xuu2ee4GFIlML0PHNkH3CHHZNZ8j2f97zuNpyEY5Z1IElWf0ZI4Ro1fJjKDKAmyE7W6DsOtW1ukDHqyfv90n9HQjj+/41Q3CdHAYzZv5EuVTktEhYU2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636126; c=relaxed/simple;
	bh=P9yJ0kIPlRIXKJ7tn3ftFvACzfTVvwdlMN/DmEblveo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmOByFSDH08fDF4DZoHrQDBg+8JCvy/vpdLrwztxnnpxylGMjZ22DTA30dRhD5aj4475npVLBzMNqZLfE10ncK1+GnIs/9OVpxmSCZQTTrfTNdYtm9B5Od/SPfbfJUjdMf9nfwDuiwXdbU0RHpSKAaoUYTJAH0npoDOsZB4gvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mF+2bSy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mF+2bSy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46448C4CED0;
	Thu, 19 Dec 2024 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636126;
	bh=P9yJ0kIPlRIXKJ7tn3ftFvACzfTVvwdlMN/DmEblveo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mF+2bSy59B4lsKKtkYXZATbop+tajoRJEvi3Bw9epbVGWrfuPAqO8Mk2OXrwh30Nr
	 8S2UIxOq7Yot7kROoATuIS6RMe5rj8iUvhsyDCTGB2Nx8kHZ1Qe8mf7GiLglCRkZeH
	 ftV1frnTxXIiKWz9BKhqV6NSTnvjj7oBjK+WNjTkvhRoIgkw6JisSyYbgfXISg5H8g
	 KD7IrhIbxFXICRfXM0JN7qqPb+CnqFJRlS8jgt9SDsYAK43Neo1AgNcsURzfuJVxuF
	 tr8/mNCZqjScvstMJZy06kmBjQy5gksFMmj1NxIBQRUjNM9hhkCSozWD2g2zPT9/Gv
	 tFT8FgPgwbrmw==
Date: Thu, 19 Dec 2024 11:22:05 -0800
Subject: [PATCH 5/8] xfs: tidy up xfs_bmap_broot_realloc a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463578736.1571062.9995423761448974235.stgit@frogsfrogsfrogs>
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

