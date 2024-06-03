Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65BF13A256
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441646; cv=none; b=mcvfHzqKULU2ELIk0vZ7A8QkOYP2UM8UrMbTmLLhcCTu/cGHDDYGfo4NJ20CUN48gYtmBIRa0OkEgQ+I7/7o3BBVnJUDHnXDzVUkDjxZgJr7Qo6L4FwRSOG3Qrun2tdw1+kuc+f6x/K5W5qhonEAZZ3kozZpmQZUi7NI0T2L+9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441646; c=relaxed/simple;
	bh=eMvrDH4cteu4vDiklO+7CdyELI4mHJfGvzOOG7oro9w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHALBV65FiwbtIQLyWi2k7Z6DXu/iru9gewIUCKxlvM6xG91PrfqaZ+x81gTRpglDKvy3bIFLJL8obLc/6V/e3tXquhedteY6O+BwxN2vK42i/9EXnu3P782nBq+AIGTFsSx8hr58Hou5RovlH53z9wg0aQ+MLkE+Q6wL0xf8oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZJEV1g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZJEV1g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0925C32786;
	Mon,  3 Jun 2024 19:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441646;
	bh=eMvrDH4cteu4vDiklO+7CdyELI4mHJfGvzOOG7oro9w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sZJEV1g91cu2C9rY2ZaHfGMj45T0d6XjYEdV3IDiYCYRzCkJR0oYS9KVnXhJ86iGE
	 Jgvb9ucGi8DmWEAylK8F1CNP450dHByiRIfUNr2+Zs5W9g6/gXKjGaSYzxXHmsSwRo
	 9zk0sdY32fBNe0GoULz6QadNsC58RjOSsa30siEAviQQSdgCGzPlf3o42xh/itLByx
	 Yk3TyJzxtrxlExLpxrT4Xssm0CTuUl8vpk+Ly9PvmHLcIG6bGAHcjlsRxpaSaCq9az
	 ZWNSLeGSJmfJXoKwttKmnkMC06addNriP0azyV7sTuYJTLu38L4+6xlARxMHwkoq+u
	 ASgGwf6f0tKWA==
Date: Mon, 03 Jun 2024 12:07:26 -0700
Subject: [PATCH 059/111] xfs: fold xfs_rmapbt_init_common into
 xfs_rmapbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040260.1443973.8295513958249212433.stgit@frogsfrogsfrogs>
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

Source kernel commit: c49a4b2f0ef0ac5daee5c2a3cfd2b537345c34eb

Make the levels initialization in xfs_rmapbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_rmap_btree.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)


diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 52c820108..fabab29e2 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -500,10 +500,16 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
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
@@ -511,23 +517,12 @@ xfs_rmapbt_init_common(
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
 
@@ -540,7 +535,7 @@ xfs_rmapbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_rmapbt_init_common(mp, NULL, pag);
+	cur = xfs_rmapbt_init_cursor(mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

