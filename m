Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558361442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801765; cv=none; b=LAqP0sWIULPDBIiJEhiQIzpghU6kk4/RyWihI13l7Yo/nHyL3hGovwLdXuc8rNAdtm2bM3bTI6wi31sR+ChuPo7U/5CtBQqu5v8RtsqVuYRskDNm3iZk/5ulMbn+KPlWK2GdJR8dV73BrpBmh4ewOOsT1I6JNyjhEol6jeAp0F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801765; c=relaxed/simple;
	bh=OnrB2b6BgqieXL3o6sWgeaXLvn9yeiDQ+9l/wOlttmQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJ2VH2+js0Pi5Yu6Iq67Bg9Meu6RyOqqeeB/jsU7Al+1nmTVCvXzecpIHrnTON+37BkTB3ZQM+CrZMHWTB/D7mk3lomRkQLeTQmf4q8SdmNPCwjR5flKQiZUW9BqS0WfyWJn/kAJObrjQEixGN3SZv2ki4tLuJpTgHg1Caorr0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwvKlfax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwvKlfax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A0C5677A;
	Tue, 27 Aug 2024 23:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801765;
	bh=OnrB2b6BgqieXL3o6sWgeaXLvn9yeiDQ+9l/wOlttmQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XwvKlfax+kGWy6j9cDPzZAAYHg3qdtiZ5gu51arhBwKqX2WPbA0pwuDwhYXnv3wZx
	 rlEM1QdpVHPlAZF5HNyT1Ufz1ZAVv+md9AZxIbWCO4C6A7s+Nj7BIbc2P4o/A+PXzX
	 HwNG0cThHugUp6f3HTXQAihqLUl0gAuCHjaengaXcChSjqWSBmIvVlz2+KnvDmXyxm
	 q+H17pgIO7dd6SVQGmoTaoZmYbDaEeggi9lTL67GhV++xRQ6BTPws5eyIzY/nV7AEx
	 TbhhHnX5pq16l9eiMKxz9hDlMXzeiTo0F/msbfz359QGgp+BAWuWPEFkcHbWXsUMDh
	 2FhE5HNA4W18g==
Date: Tue, 27 Aug 2024 16:36:04 -0700
Subject: [PATCH 09/10] xfs: rearrange xfs_iroot_realloc a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131661.2291268.13799708059982137215.stgit@frogsfrogsfrogs>
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

Rearrange the innards of xfs_iroot_realloc so that we can reduce
duplicated code prior to genericizing the function.  No functional
changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   48 ++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 307207473abdb..306106b78d088 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -451,44 +451,46 @@ xfs_ifork_move_broot(
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
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*new_broot;
-	int			new_max;
 	size_t			new_size;
 	size_t			old_size = ifp->if_broot_bytes;
+	int			cur_max;
+	int			new_max;
+
+	/* Handle degenerate cases. */
+	if (rec_diff == 0)
+		return;
 
 	/*
-	 * Handle the degenerate case quietly.
+	 * If there wasn't any memory allocated before, just allocate it now
+	 * and get out.
 	 */
-	if (rec_diff == 0) {
+	if (old_size == 0) {
+		ASSERT(rec_diff > 0);
+
+		xfs_iroot_alloc(ip, whichfork,
+				xfs_bmap_broot_space_calc(mp, rec_diff));
 		return;
 	}
 
+	/* Compute the new and old record count and space requirements. */
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
+	new_max = cur_max + rec_diff;
+	ASSERT(new_max >= 0);
+	new_size = xfs_bmap_broot_space_calc(mp, new_max);
+
 	if (rec_diff > 0) {
-		/*
-		 * If there wasn't any memory allocated before, just
-		 * allocate it now and get out.
-		 */
-		if (old_size == 0) {
-			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			xfs_iroot_alloc(ip, whichfork, new_size);
-			return;
-		}
-
 		/*
 		 * If there is already an existing if_broot, then we need
 		 * to realloc() it and shift the pointers to their new
 		 * location.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
-		new_max = cur_max + rec_diff;
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_KERNEL | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
@@ -500,14 +502,8 @@ xfs_iroot_realloc(
 	/*
 	 * rec_diff is less than 0.  In this case, we are shrinking the
 	 * if_broot buffer.  It must already exist.  If we go to zero
-	 * records, just get rid of the root and clear the status bit.
+	 * bytes, just get rid of the root and clear the status bit.
 	 */
-	ASSERT((ifp->if_broot != NULL) && (old_size > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
-	new_max = cur_max + rec_diff;
-	ASSERT(new_max >= 0);
-
-	new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	if (new_size == 0) {
 		xfs_iroot_free(ip, whichfork);
 		return;
@@ -518,7 +514,7 @@ xfs_iroot_realloc(
 			old_size, new_max);
 	kfree(ifp->if_broot);
 	ifp->if_broot = new_broot;
-	ifp->if_broot_bytes = (int)new_size;
+	ifp->if_broot_bytes = new_size;
 }
 
 

