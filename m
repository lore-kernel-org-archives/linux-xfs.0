Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621A1442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801702; cv=none; b=Kx4uVBxPFXz8CQVtkzLJt9YO5yRQvlki1dfOnRBsvc9vsFIfxOwnI8OkRrHeIQQ8XFqOOM6wnClINwTZaG26ddQ07DUDc6UhQzQ3fLCOqOqqxwnA3dmUPVs13afW0fUViFryqWADb1vDOBjvHv9qIqj95h40lulutAirsWy8gxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801702; c=relaxed/simple;
	bh=UIU0nmzGU2qINXS0X/zOCusifkbCQxcmOSvoKx9AtF8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qz8A/Ex55tJQhAy1Jd3AEhOpX/BONwKBjsBP5k3UNJSOk0kLHxsscWmKat0dIBYPV712m04uKcU27R/Wk622n2cIPADGTEJJ/nZH052pA3YXBEDbPCNLgSPLB3ELsGJXGpS+UfR0QSzjIcO6MzDwK6s81DMZuB9wULPZT2tDkrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMMoQ7Ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMMoQ7Ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAE3C55DF6;
	Tue, 27 Aug 2024 23:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801702;
	bh=UIU0nmzGU2qINXS0X/zOCusifkbCQxcmOSvoKx9AtF8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SMMoQ7EcETH2AcAi9xRuwfz2+o6XAjWV355x8nl0GjodvY8KKn8yrbQMtdWXsHVCZ
	 RXaIrURpCKj6BHfGsAQdTGUpw/9bhKNCjW4DHoR0GWmtUNFnRKBEiJl9goxaaqqTL6
	 GwA+mfbTmjBrgf03Ngxer/7DnsajHZPcJ0SJejccuHEU9WxyxSxH+9lj0HvsYUUoCC
	 8Wbre2Ez8vNPu3bKus17fH9ON/hi6KIz1NJfwYU/H4zfpXIrpOlogBH9e9pufVFJtA
	 meNTIFP6zM1xyn/BAQix+7rl1+tKhnkh6SrbRwwo+/T3H7jBBhPpJmXnFRT1RhCEKR
	 9aHvS6vQ/s7Rw==
Date: Tue, 27 Aug 2024 16:35:01 -0700
Subject: [PATCH 05/10] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131591.2291268.4549323808410277633.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The bmap btree cannot ever have zero key/pointer records in an incore
btree block.  If the number of records drops to zero, that means we're
converting the fork to extents format and are trying to remove the tree.
This logic won't hold for the future realtime rmap btree, so move the
logic into the bmbt code.

This helps us remove a level of indentation in xfs_iroot_realloc because
we can handle the zero-size case in a single place instead of repeatedly
checking it.  We'll refactor further in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.h |    7 +++++
 fs/xfs/libxfs/xfs_inode_fork.c |   56 ++++++++++++++--------------------------
 2 files changed, 27 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index af47174fca084..b7842c3420f04 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -163,6 +163,13 @@ xfs_bmap_broot_space_calc(
 	struct xfs_mount	*mp,
 	unsigned int		nrecs)
 {
+	/*
+	 * If the bmbt root block is empty, we should be converting the fork
+	 * to extents format.  Hence, the size is zero.
+	 */
+	if (nrecs == 0)
+		return 0;
+
 	return xfs_bmbt_block_len(mp) + \
 	       (nrecs * (sizeof(struct xfs_bmbt_key) + sizeof(xfs_bmbt_ptr_t)));
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 973e027e3d883..acb1e9cc45b76 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -447,48 +447,32 @@ xfs_iroot_realloc(
 	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
-	if (new_max > 0)
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
-	else
-		new_size = 0;
-	if (new_size > 0) {
-		new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
-		/*
-		 * First copy over the btree block header.
-		 */
-		memcpy(new_broot, ifp->if_broot,
-			xfs_bmbt_block_len(ip->i_mount));
-	} else {
-		new_broot = NULL;
+
+	new_size = xfs_bmap_broot_space_calc(mp, new_max);
+	if (new_size == 0) {
+		kfree(ifp->if_broot);
+		ifp->if_broot = NULL;
+		ifp->if_broot_bytes = 0;
+		return;
 	}
 
-	/*
-	 * Only copy the keys and pointers if there are any.
-	 */
-	if (new_max > 0) {
-		/*
-		 * First copy the keys.
-		 */
-		op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
-		np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_key_t));
+	new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
+	memcpy(new_broot, ifp->if_broot, xfs_bmbt_block_len(ip->i_mount));
+
+	op = (char *)xfs_bmbt_key_addr(mp, ifp->if_broot, 1);
+	np = (char *)xfs_bmbt_key_addr(mp, new_broot, 1);
+	memcpy(np, op, new_max * sizeof(xfs_bmbt_key_t));
+
+	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
+			ifp->if_broot_bytes);
+	np = (char *)xfs_bmap_broot_ptr_addr(mp, new_broot, 1, (int)new_size);
+	memcpy(np, op, new_max * sizeof(xfs_fsblock_t));
 
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
 
 

