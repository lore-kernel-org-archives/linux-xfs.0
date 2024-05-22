Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DF6139E
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346956; cv=none; b=Inrub6ZDb9ehtWtYrAteaBNjsRiLGOwG5f0x1WBavydFY9hKVbsYLUNKzzzUwmNXf08VjbCvD7Aj/MYU7mlunRzVxCqWfzB9XWckv8KRDVLZhtc5HnUMXy6mfpZNHl06J07GJISLJfZfkk+6BnTZGbikQfMM3CaPOzad38V0ZzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346956; c=relaxed/simple;
	bh=4GufBizA7xQFRcwUXJoFedcYzRDMfqO0GYmn/hEmTH0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GZcRGCkJzewjr/jPR4g/G+bbSM28+74eBRbmDCTTRc6cdWoenYT461GDRDdj4Dacu59JU1W/775KQ7pVvQr0NGBztK4PH8goJrceT6zIW5SBlLRcCR9hci93LXj7WjvgkDV7dNsrnLDPvWDxG5ea74WetjWNnVucFDyL0nC7Mec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixDvIQCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixDvIQCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6253AC2BD11;
	Wed, 22 May 2024 03:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346956;
	bh=4GufBizA7xQFRcwUXJoFedcYzRDMfqO0GYmn/hEmTH0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ixDvIQCGkP9mDiyUJOHzzsi5v9yswyiLt3hdgq/uJ1E3VRJ3DEZkfVsi/BN/55b1o
	 Nmmp11C3zIUBegmFBcUZAXcAt4EhK4DzHRikyifO1TVgwZNDb2BClkTcROEPfIiP3O
	 qFdHPwJg2YGIXHwV9hxlfJok3K2yrZzkqJRzvNus3FgrtvRpUB65dgdgSDL8rwTxNS
	 UGqAplbrjKTFuy95Gwj+U1CRiKrq82QdwwFPwWZuZxn0b0ExwU+tDCbD0WcSJuRQli
	 xmrNqFky6gz18qFkoyJ8cEGKX97f5eQvzPfbpFFcrXajztD4nWMZEhhC0vjI73ZpWW
	 9Ji9bl+cWt4/g==
Date: Tue, 21 May 2024 20:02:35 -0700
Subject: [PATCH 053/111] xfs: fold xfs_allocbt_init_common into
 xfs_allocbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532493.2478931.11013785469210987078.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: fb518f8eeb90197624b21a3429e57b6a65bff7bb

Make the levels initialization in xfs_allocbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c |   42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6b17037f8..13d2310cf 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -511,11 +511,16 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.keys_contiguous	= NULL, /* not needed right now */
 };
 
-/* Allocate most of a new allocation btree cursor. */
-STATIC struct xfs_btree_cur *
-xfs_allocbt_init_common(
+/*
+ * Allocate a new allocation btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
+ */
+struct xfs_btree_cur *
+xfs_allocbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
@@ -530,31 +535,14 @@ xfs_allocbt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops, mp->m_alloc_maxlevels,
 			xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	return cur;
-}
-
-/*
- * Allocate a new allocation btree cursor.
- */
-struct xfs_btree_cur *			/* new alloc btree cursor */
-xfs_allocbt_init_cursor(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agf structure */
-	struct xfs_perag	*pag,
-	xfs_btnum_t		btnum)		/* btree identifier */
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_allocbt_init_common(mp, tp, pag, btnum);
-	if (btnum == XFS_BTNUM_CNT)
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-	else
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
-
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
 
+		cur->bc_nlevels = (btnum == XFS_BTNUM_BNO) ?
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) :
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	}
 	return cur;
 }
 
@@ -568,7 +556,7 @@ xfs_allocbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, NULL, pag, btnum);
+	cur = xfs_allocbt_init_cursor(mp, NULL, NULL, pag, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

