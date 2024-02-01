Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271C584FA8
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816897; cv=none; b=pCzLk8eVqRIwtBNzmgnvM0O7SErerX7Mc/kF9LAirjZP3CIia5pD7JciSc3y07+hRetKmquAd6nPvghK0OsPBZkAAk39iUfWxU0Xiqfcf4zWTCnCCgtK9x8piUr+JdAmIUg+9ewE2jYCU0ZApzYwkHzWWlLxEZ+ndWwZv+6Ah28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816897; c=relaxed/simple;
	bh=aUb8M+aAoAhMut20K5RNrUgNAFlAfbp67acH12oIyGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNS9+JiTocFKLp/h0Z0RrFsx/nlJDm0NgOarQjWlJuvTAZYfxs9Qmw33M9CyByzXgwFlycQlsdzWLye5nDsz3g7et+5cryh4XPXEppztLTRRkEwF+Y3Jqdc7AxDnlTbR3eJiazhWvTFz6K63mWEFRAqnm6eSQpZSWWyGoiL49zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ML4L8gZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ML4L8gZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63D0C43390;
	Thu,  1 Feb 2024 19:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816896;
	bh=aUb8M+aAoAhMut20K5RNrUgNAFlAfbp67acH12oIyGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ML4L8gZIXKwFogu6DVVFlgszNZk0A4s7t8S5DGQpGHlfw6kN+lqHmN+YR/eFhlRRM
	 QcoZX55mqMgZ3+wZTQr6Xbpp71KkM4yeSpdLEKo0bFVkktHy2ghvvPzmK8hX0L3fhW
	 LsiFnM4wENgNrnDHNwCwrzpXDniYntFOpAA3/sd+uryUdPZuLsiAMfFcmNq7LqFFOd
	 M+ssymZcdT795YQ73n+TXO7J9a6MRwXIZuemRl+OyoDDyolKytcyUKfoZ7ZV8OzQ4k
	 iW7ho32nI7gfLOIeB2JMwHnxNUtGO0oEQPEzhziAET0lBYB0BHapTN3YR3NhkdG/DO
	 hLrNecXFO7udg==
Date: Thu, 01 Feb 2024 11:48:16 -0800
Subject: [PATCH 10/27] xfs: fold xfs_rmapbt_init_common into
 xfs_rmapbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334948.1605438.17614719757700281000.stgit@frogsfrogsfrogs>
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

Make the levels initialization in xfs_rmapbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 84eb767425cba..dda9f8844d841 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -502,10 +502,16 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
 };
 
-static struct xfs_btree_cur *
-xfs_rmapbt_init_common(
+/*
+ * Create a new reverse mapping btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
+ */
+struct xfs_btree_cur *
+xfs_rmapbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
@@ -513,23 +519,12 @@ xfs_rmapbt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	return cur;
-}
-
-/* Create a new reverse mapping btree cursor. */
-struct xfs_btree_cur *
-xfs_rmapbt_init_cursor(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag)
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_rmapbt_init_common(mp, tp, pag);
-	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
+
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+	}
 	return cur;
 }
 
@@ -542,7 +537,7 @@ xfs_rmapbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_rmapbt_init_common(mp, NULL, pag);
+	cur = xfs_rmapbt_init_cursor(mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

