Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E7718EA2
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051495; cv=none; b=CqVRktqNZRQo8iLE3H/X7N+75QYWVquxmmido9PSm3T+3skGadb7zMS9NnvMH86tdraAk4QQ0DbnzyOaRK8lOV6pRc2Szcf0+OxoW+f0kiB6/SnrL6vSb6byWR0OfJoRDznfgij0HlVSyE+5Tu/Zq8IojdJQ0wXd6VsWy2nIMHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051495; c=relaxed/simple;
	bh=J8jy845ViyvCWrBYyhVYBEjknWr6xFblEK58wCo36/E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dPvdJLQX1c1TMozihWo3i0Guuza8VYfjMgJDEzvQgffJ3N21JkRRnGJgDtfUfK5hFAUX8pcztGttQL+J6o/To4sfFohkqpkEDajl+0VCfdadnwcG0qfwCBh4B5tffG9tE9N12IhMwe9DHJd2Xq3GzWg8cQloXYljZtPJvgjuLcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=te1rvWqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="te1rvWqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE600C4CED3;
	Fri, 13 Dec 2024 00:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051494;
	bh=J8jy845ViyvCWrBYyhVYBEjknWr6xFblEK58wCo36/E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=te1rvWqSrhvq3lS0mkbc8EksLnY6L1+0JPLS8nJYjPxppXCtSHz2Bdc+CMcjP3lAj
	 tdkqCakRODfvLcW0a+ZAPXB439TP07yqumuQM5EQrinV4JqgFK+CZ99v7excOTKDlm
	 txueoXa/7hOPNTPHdIcO5K0g3Ig1xrmxf2OYw651BrSN7rEjUvvO37FbfDHnYgz8Am
	 kiqWiWWOOZy3YNmhJAiffezSPj8qfNVRwin/TgrNqhT8mfWDg9AOmVGthwxy6aglL6
	 CZ5Zbk1aoKPuYmQ0o+WiJ6+uRG0zYLyGNsUsLMWyFmYOXIiVPWE3uCeZoQxSQev+xq
	 TAj023rCbnr4Q==
Date: Thu, 12 Dec 2024 16:58:14 -0800
Subject: [PATCH 1/8] xfs: tidy up xfs_iroot_realloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122177.1180922.14038648509804731936.stgit@frogsfrogsfrogs>
In-Reply-To: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
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
 
 

