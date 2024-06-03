Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280A13C9B8
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442053; cv=none; b=EQO2rgYngTeU89LoNDmmE3Qf6sBM3RttOPDKpZ/7x7cYQZUMnpar18T33t8n3tL1DZLPFemhw9FJcathAv6YYHWvCluKEDMUw0ab7SedIU80ubTMn5twJVWrnlHvvKuva3DCCa03rbe1ygAj0iVmWHXpW7NIsyXp7hHrkCyaCQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442053; c=relaxed/simple;
	bh=Sg89HynfWyDtzcyiu3Yx8LaE8nIHJLciXHb3P8ak4Ng=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YqhrLJ4uv4S9R1/lN5KwrVzNgWP3Rw1QD9u75u0LOKeZkRxBXvgC6+7ycBXr0aR6gSSTYXsTu3YLzy3nkTcdZhdDObczLPwFPhg8WlT3YZE8NEhQ2hGe10hmBroLJTfBED0F0q0MaGm48l1qKoAXR+8ejqEayI1eOvOKlBqIz5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sRtJor/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sRtJor/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2927BC2BD10;
	Mon,  3 Jun 2024 19:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442053;
	bh=Sg89HynfWyDtzcyiu3Yx8LaE8nIHJLciXHb3P8ak4Ng=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sRtJor/fQfgnXBXflUdREGNI36cUC8JifiZ5ei/SM1dshF8if+gICu64LEbrqM4Bk
	 PJ5YmgM2x0GMql8UPuCRELec9tWP8McB6JORSRoYc0U3mdObLzg8SH9r2ZCWG/otqH
	 Y7CYf1Uk9dEty5iRAesAqNifQMI/ajLO+tVpYweOS+xbOZfoTwTa8ITDsY7edLDc4m
	 c63n42u0Phye/bRHq60ZsYxONgmcsnsCKmQWzXsVrPGPSnBYcrQc+Ipx/IkeNlTBCJ
	 DLEVrzb95Kx9m4ieXrqezHRu2XryQIPcO6k0ByTOYAvxrEaSGzvrkeJ2gmvZp37dg1
	 KYL6csy4j7DRA==
Date: Mon, 03 Jun 2024 12:14:12 -0700
Subject: [PATCH 085/111] xfs: remove xfs_btree_reada_bufl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040645.1443973.7881900303489719058.stgit@frogsfrogsfrogs>
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

Source kernel commit: 5eec8fa30dfa548d07332756101053f47f6ba26c

xfs_btree_reada_bufl just wraps xfs_btree_readahead and a fsblock
to daddr conversion.  Just open code it's two callsites in the only
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   30 ++++++------------------------
 libxfs/xfs_btree.h |   11 -----------
 2 files changed, 6 insertions(+), 35 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 6b1839243..2bef2f3e2 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -886,25 +886,6 @@ xfs_btree_read_bufl(
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
@@ -932,19 +913,20 @@ xfs_btree_readahead_fsblock(
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
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index b9b46a573..001ff9392 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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

