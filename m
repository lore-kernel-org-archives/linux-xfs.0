Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192D2BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqMh+RfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DB8C433C7;
	Sun, 31 Dec 2023 21:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058088;
	bh=pE9hGw4Dw5FT57NpeeXPsRcpYjASXlR0QprFACY5PPU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qqMh+RfYoFKDbeWYmT27/Knczc6xz4lpxk2pR80rtLDsOq4k/RYHZnYeVvuJPdVMs
	 va/uJf24Ex8OvKbSLtlK8WAOzHicQg5OSRGhLm/u3y92urcD6berDV8ExT6JfzrW/0
	 Vc6e3BccylDHdH/q5u/+Hkdp99EW/womOa7WGfJASYFCPO4nh01lDHZnbX3ZGVybVM
	 RjkAsKslWfr4GWbyzyuyHiIrEFAdqGFhSLe0DicD2q3OAqC+X2cyMP2sBjzVZgWjV7
	 tqYpz0pYrPduxj7RM23ucR2aIE6RPWDEd0uHt0VSxyS5MfIBjhgvb+l8+U38cN3AiU
	 0M3NKefqO6z4Q==
Date: Sun, 31 Dec 2023 13:28:08 -0800
Subject: [PATCH 7/9] xfs: remove duplicate asserts in xfs_defer_extent_free
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848448.1764329.7946844448940228128.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
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

The bno/len verification is already done by the calls to
xfs_verify_rtbext / xfs_verify_fsbext, and reporting a corruption error
seem like the better handling than tripping an assert anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   13 -------------
 1 file changed, 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1ea88d4675f5f..ca4df5e0b2a31 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2596,23 +2596,10 @@ xfs_defer_extent_free(
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
-#ifdef DEBUG
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
 
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(len > 0);
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
-	agno = XFS_FSB_TO_AGNO(mp, bno);
-	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno < mp->m_sb.sb_agblocks);
-	ASSERT(len < mp->m_sb.sb_agblocks);
-	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
-#endif
 	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
-	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))

