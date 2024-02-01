Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7AE85289
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817335; cv=none; b=Kcmk/587FvxVxan0XgrQCthbYncUBiR53KtqSEylB0dNS9mhrJSQpdotKaLN7wzno5Urx6MQx8P/0x5MA8UawBjcVaX4VHUTvQVz98th2MMBsp7qmrNR/95YfM0Gr3pKQJ3PR8RYH1FUgia4quwLuLTOaJAbitgLADRbJ/SI4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817335; c=relaxed/simple;
	bh=BGd4uGJTF8tNb3Zi+xHvf66c4M4xG+ekvLUtuRudvHk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Agku5Zsl+2yhYIo6ijLCKN9XpVU1/SMeGeTo/T4PzMLGIU09hyERXNEmuieatSXmZmq4l1OEqUod3cX6z9oJ4oPn/gLnb8FNjkntbdbGsb9O7Px4Pkfi1BF6hRR06MALIuyF3mrkVH77ioefEdoVoQIB/jyP6Em4fr/6unIa8bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqZav4YO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqZav4YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B2AC433C7;
	Thu,  1 Feb 2024 19:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817334;
	bh=BGd4uGJTF8tNb3Zi+xHvf66c4M4xG+ekvLUtuRudvHk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lqZav4YOlFb9xcQK2sXGmxtw7qwiGTwyyePTaChQ9cojUii/EwODbJoLASQNsB4xt
	 N5LqYIPCBbK4k5I6TejpD5fZSuFqrdetoJhvKhf1OnRiyYoRdXeDw2so0RVMKmToUe
	 VmrrOYaf0GOBlSS0oPcNE/1G4ckCN+CfHmaH6IbfPoJ5AU9HGWccLiU4viKCCB3yaA
	 ob2VJfedf9R7LfVrYF/pwkLCF5wI73pRSbFNh7+/LlpGZy/tGvRTyP1Rf1xVNWIvOb
	 TetxRakx3NaEUNP+8on/pzetq+c67Xjjdvz7zHLRrnpiwSR/OVc6U8Ar9uOL33qJEJ
	 elmIqbVFyVi5w==
Date: Thu, 01 Feb 2024 11:55:33 -0800
Subject: [PATCH 1/4] xfs: remove xfs_btree_reada_bufl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336146.1608096.870671815956033354.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
References: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
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

xfs_btree_reada_bufl just wraps xfs_btree_readahead and a fsblock
to daddr conversion.  Just open code it's two callsites in the only
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   30 ++++++------------------------
 fs/xfs/libxfs/xfs_btree.h |   11 -----------
 2 files changed, 6 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b228b22893fa0..2689cad9b25ab 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -889,25 +889,6 @@ xfs_btree_read_bufl(
 	return 0;
 }
 
-/*
- * Read-ahead the block, don't wait for it, don't return a buffer.
- * Long-form addressing.
- */
-/* ARGSUSED */
-void
-xfs_btree_reada_bufl(
-	struct xfs_mount	*mp,		/* file system mount point */
-	xfs_fsblock_t		fsbno,		/* file system block number */
-	xfs_extlen_t		count,		/* count of filesystem blocks */
-	const struct xfs_buf_ops *ops)
-{
-	xfs_daddr_t		d;
-
-	ASSERT(fsbno != NULLFSBLOCK);
-	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	xfs_buf_readahead(mp->m_ddev_targp, d, mp->m_bsize * count, ops);
-}
-
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
  * Short-form addressing.
@@ -935,19 +916,20 @@ xfs_btree_readahead_fsblock(
 	int			lr,
 	struct xfs_btree_block	*block)
 {
-	int			rval = 0;
+	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
 	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	int			rval = 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
-		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
-				     cur->bc_ops->buf_ops);
+		xfs_buf_readahead(mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, left),
+				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLFSBLOCK) {
-		xfs_btree_reada_bufl(cur->bc_mp, right, 1,
-				     cur->bc_ops->buf_ops);
+		xfs_buf_readahead(mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, right),
+				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8544f2f506f80..d95f521a48a74 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -391,17 +391,6 @@ xfs_btree_read_bufl(
 	int			refval,	/* ref count value for buffer */
 	const struct xfs_buf_ops *ops);
 
-/*
- * Read-ahead the block, don't wait for it, don't return a buffer.
- * Long-form addressing.
- */
-void					/* error */
-xfs_btree_reada_bufl(
-	struct xfs_mount	*mp,	/* file system mount point */
-	xfs_fsblock_t		fsbno,	/* file system block number */
-	xfs_extlen_t		count,	/* count of filesystem blocks */
-	const struct xfs_buf_ops *ops);
-
 /*
  * Read-ahead the block, don't wait for it, don't return a buffer.
  * Short-form addressing.

