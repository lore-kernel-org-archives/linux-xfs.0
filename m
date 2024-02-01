Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7611C7C6C1
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817100; cv=none; b=M9BdIhustFCHTMaGFsAaaGM+af9ka80uoRGT39wXOn118X4oaPcj6WO4ztl17mAeuTxoyKVc8BWRID50R0CbnzRBtLWKIv87sqSY1LInBiPx1iEgTYrTd+wN8jH9Ab66QHz//lPnOp0NkfpxEdP7IqGqFzwJJddLSdsjbTK8cBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817100; c=relaxed/simple;
	bh=2iNwFqWdCm6frCVS6TgDqOr7HASb4yeye0+uwgQC86E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujn0hV57gXXgPVYsOiC/2WYo25VQPRUmXI06RBTmCMcnThFS7zHOvaI0llcQtuFSIMsfcNsvi6bDP34TAbJouGkO61hoiB6+qMlCUN8s3oKFBX9nSFJB4gpQjXW2O3gsydMIO0crlR/D//GHBnMw8tePXyAySo20jQCS3C8ZdFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AFUdLZrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFUdLZrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77EEC433C7;
	Thu,  1 Feb 2024 19:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817100;
	bh=2iNwFqWdCm6frCVS6TgDqOr7HASb4yeye0+uwgQC86E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AFUdLZrpid7EJfpgZ2AI93FRCliNB2wqctgU1n/UqG46Rrfmjy0xF+4ejI5d/WAzz
	 l5YUX3+boGg3nwCrrBMQIsVvsZDA0o2t6gAopjHJ8rUSwO4Z+I3FSn5M2nfPSHJ1h+
	 hlEfDjk6BG+b/S6lU3mVkMsSpFzInLmBlHJAfBukEzH/M50EgausjpwvMF9TjiJLSJ
	 AtkDZk139XHKezw2gLezCZlZlJyVWLRnejlRhY3aVook7TyaSMPxh/hPi6Mi/ThdLB
	 aPco/vhQfXJInWK/F+rBBW5Zdh9aCa8Fca5pqQaL2kakY5IEVUa661uGEQVZgGGZd6
	 ZvkU7G1LxcVng==
Date: Thu, 01 Feb 2024 11:51:39 -0800
Subject: [PATCH 23/27] xfs: remove the which variable in xchk_iallocbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335162.1605438.1639673685572769161.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

The which variable that holds a btree number is passed to two functions
that ignore it and used in a single check that can check the sm_type
as well.  Remove it to unclutter the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/ialloc.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index a720fc62262a6..26d589e9ba1c3 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -649,8 +649,7 @@ xchk_iallocbt_rec(
  */
 STATIC void
 xchk_iallocbt_xref_rmap_btreeblks(
-	struct xfs_scrub	*sc,
-	int			which)
+	struct xfs_scrub	*sc)
 {
 	xfs_filblks_t		blocks;
 	xfs_extlen_t		inobt_blocks = 0;
@@ -688,7 +687,6 @@ xchk_iallocbt_xref_rmap_btreeblks(
 STATIC void
 xchk_iallocbt_xref_rmap_inodes(
 	struct xfs_scrub	*sc,
-	int			which,
 	unsigned long long	inodes)
 {
 	xfs_filblks_t		blocks;
@@ -719,17 +717,14 @@ xchk_iallocbt(
 		.next_startino	= NULLAGINO,
 		.next_cluster_ino = NULLAGINO,
 	};
-	xfs_btnum_t		which;
 	int			error;
 
 	switch (sc->sm->sm_type) {
 	case XFS_SCRUB_TYPE_INOBT:
 		cur = sc->sa.ino_cur;
-		which = XFS_BTNUM_INO;
 		break;
 	case XFS_SCRUB_TYPE_FINOBT:
 		cur = sc->sa.fino_cur;
-		which = XFS_BTNUM_FINO;
 		break;
 	default:
 		ASSERT(0);
@@ -741,7 +736,7 @@ xchk_iallocbt(
 	if (error)
 		return error;
 
-	xchk_iallocbt_xref_rmap_btreeblks(sc, which);
+	xchk_iallocbt_xref_rmap_btreeblks(sc);
 
 	/*
 	 * If we're scrubbing the inode btree, inode_blocks is the number of
@@ -750,9 +745,8 @@ xchk_iallocbt(
 	 * knows about.  We can't do this for the finobt since it only points
 	 * to inode chunks with free inodes.
 	 */
-	if (which == XFS_BTNUM_INO)
-		xchk_iallocbt_xref_rmap_inodes(sc, which, iabt.inodes);
-
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_INOBT)
+		xchk_iallocbt_xref_rmap_inodes(sc, iabt.inodes);
 	return error;
 }
 

