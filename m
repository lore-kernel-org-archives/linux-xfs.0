Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7B128EA
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347019; cv=none; b=SV+Iyid80bwHWcb0G2WoJf5vffscM7FlwRdGFsb9g1sxZyhMabeP1pN20qywUwZvI3fV+6WiANQuiMXST4GIwXqed/bFtG4jFuZ8/SUM2hFR3cWKJerNdeVyf3Uc5J3JmoX//NgjQyaPEBoNcTv99M3jS6NFHNmFrzrKDVbwuMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347019; c=relaxed/simple;
	bh=6aawWXQZHWQc6zCRQlFPVHNbYSXXUQa6rlgrRQJakCs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QshQAYiQz04wLG8VvKEHUJq9VBGe7WQjlMei1qPNTh+cZq6LP1jY/1t8lSL/5/J7bA2eZOu0jTgsGwK8CLojKaHayqOWXG76h76N06HQIr68zm1v39rRPTi0Ucx24vT9Pl0W5F4v4tV8JHgJ4PCrOzSvv/mxGWx5fw/3hgvaRNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tV1XfUks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tV1XfUks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0556CC2BD11;
	Wed, 22 May 2024 03:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347019;
	bh=6aawWXQZHWQc6zCRQlFPVHNbYSXXUQa6rlgrRQJakCs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tV1XfUksfd6ThwufWW3u3SuULcaqxwK+wM8Bk2GaXB7DewLnpV1dLnd3r4Esue89i
	 4fhb/S0Ff/Cwe9rukQWsjjju16Ed7zzJYUbzI0wlsod0uVmY6u1G9KZt/tDf3bx9do
	 tmryUgFc3fqR2CUFmP4YRXpddtdPiAStoLK5nCRb2T+/wA1bGE0L7DEM1OD5B6U1TX
	 ivU2Ws/HSkpkkp4aA6uGBSJKZbBJaVT1p5TFcS7hLVdgfMk9bFOZlefAMnRq7N4RCC
	 Ap4t+IbM1gUn1lqJR2yGnkw1ii59xT2DXwMmRgxL0nVj+guziBUh43GMiDj1sKInXt
	 UnJBdzT2WiiDg==
Date: Tue, 21 May 2024 20:03:38 -0700
Subject: [PATCH 057/111] xfs: fold xfs_refcountbt_init_common into
 xfs_refcountbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532553.2478931.14264057065704932311.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4f2dc69e4bcb4b3bfaea0a96ac6424b0ed998172

Make the levels initialization in xfs_refcountbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount_btree.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)


diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 45bfb39e0..c1ae76949 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -345,12 +345,15 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 };
 
 /*
- * Initialize a new refcount btree cursor.
+ * Create a new refcount btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
  */
-static struct xfs_btree_cur *
-xfs_refcountbt_init_common(
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
@@ -363,23 +366,12 @@ xfs_refcountbt_init_common(
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_refc.nr_ops = 0;
 	cur->bc_refc.shape_changes = 0;
-	return cur;
-}
-
-/* Create a btree cursor. */
-struct xfs_btree_cur *
-xfs_refcountbt_init_cursor(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag)
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_refcountbt_init_common(mp, tp, pag);
-	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
+
+		cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+	}
 	return cur;
 }
 
@@ -392,7 +384,7 @@ xfs_refcountbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_refcountbt_init_common(mp, NULL, pag);
+	cur = xfs_refcountbt_init_cursor(mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

