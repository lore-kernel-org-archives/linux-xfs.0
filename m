Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CAE137923
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441506; cv=none; b=hW68IkMiPIUonHwLhj6Xt44g5UjD47Magbr4IqkXkp6Z8ZQWTB3kIjC9n5gOkCXHYtFv83RkJw54IybuAmKy+6Fu4ExdI3vBY1f+2mggTfcKCwdt1Af4cwcA0oPPWAhLp4PMXWjAZ2uvA6ic6jZBQ2q4rrLSm/mcXoHTWyN9B4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441506; c=relaxed/simple;
	bh=gZBRW/r7sIEvBCkWQO9Z9wiQkbWuS/2iIhSgP1WjBVY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qx6tNJem2BxWJbBq3UxdoJvXo4Le3H0RIPaR4ZT9r99lY5zv0/kNjj8QWFNp+4UKOgTmoimf5GRKeCpK/N/wX01hpvLGJ0UFW3nG6dDxrUueoWd0bmxz357fr1IIvjbBiX6GpNIWVCm9tgBWLTayQhy0mfmYliTtdQelNDfrt4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJGFoja5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJGFoja5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A13AC2BD10;
	Mon,  3 Jun 2024 19:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441506;
	bh=gZBRW/r7sIEvBCkWQO9Z9wiQkbWuS/2iIhSgP1WjBVY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZJGFoja5AhROQFJPJk22vLr+qlvmpTzpP8zYaULzXzZDWIt1ozBWAXkqRmq7lJbC4
	 IDkyaC8wC6Q9Yjc4g9JSVhWpzSQ4chZl0ap/92q9qdP7FCqmU5IHt8NZjGoIAKe/zj
	 ib07JAHmRtXipy/yKBWyu7WzykNEqygzv60rCIpg8eEQNiGARbDFQ7UgisVekhTl4y
	 GaR5PwEvt1V9JSUJEMTTyEVhEIvGYl1QkYYQy19mUUDTrQ7QBlUPQzxr/CEFOwj2+e
	 XLLmFI1dZdj8uzUikDa9/7l7th6f0ORvdvVeLBfsVoYFL6suV6HHMADZAGcUp1O99A
	 qgPiQK7blAIbg==
Date: Mon, 03 Jun 2024 12:05:05 -0700
Subject: [PATCH 050/111] xfs: move comment about two 2 keys per pointer in the
 rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040125.1443973.1706943327407265314.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 72c2070f3f52196a2e8b4efced94390b62eb8ac4

Move it to the relevant initialization of the ops structure instead
of a place that has nothing to do with the key size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_rmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f87e34a1d..311261df3 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -475,6 +475,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
@@ -507,7 +508,6 @@ xfs_rmapbt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);

