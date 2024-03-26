Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E531292FD
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424598; cv=none; b=OVpkIfLKMGWSVt0ANCWDst97l9PzkO21vG+Rt6OipknPFvb1eu6TXaBwH1V/0Uc6ZHgg/+wsJZIg6UwPlRbRG4aU3Df3Mn4zDR1Dx13wlg6AKCfUEFzVEKJXOBrE/+NeXmWallXKD2lEDqdTVDbg6yQ7coXohV3MOmek0ZkiSFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424598; c=relaxed/simple;
	bh=2Lj+1s9F+iUkPpzzn3ISi7d0hRl6n0RaJfTgWWxnwbQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLO2DItrNJSbj8mpcY2r/qBnkTqbN2SXczMyIdSeA3gAXwQ3zwsCxP0KNO3WGIfL5F+oBj/9JyYL4O8uJd8dVxg7kGhxoT/jo6Aph1YqnL8Zd8R4oS36HnnE1m60lrNsyxMf+1m90SVMhmqkBzw8IyxCwNv1vn/kUrmXTJf3pD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXCJkwU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXCJkwU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204D4C433C7;
	Tue, 26 Mar 2024 03:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424598;
	bh=2Lj+1s9F+iUkPpzzn3ISi7d0hRl6n0RaJfTgWWxnwbQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LXCJkwU351lZprn0C1Esu8LAERK2TCw9bvqJ5fH1y2B7E0IcbVvgXeDonbg6aBBjf
	 HhJTUGPsWMl+4b5RysT3vAP+auUi8upXbBEYGVzyXu63Wgb+ZGs5E7tucxscYTye2F
	 2TxrF2Svnf4QkumVvsR6gxEx08JKaeZTRgi7AwDgfFhH6uDG5Mh9iBPFgrcpjDipPX
	 tA5GJNFwW6+MNGkZPnIKkBLdacdg+HfobSPycH+37MmReTODPCBh8/IaKAkDdBCJfq
	 Pxux9hKp+GM/FgVL8ZUUiQshmEEhj1K3rIvwAu5qdZXFiLM/0sEpMH8v+h3Zl6ygqz
	 fXBY4Mx37a/dg==
Date: Mon, 25 Mar 2024 20:43:17 -0700
Subject: [PATCH 057/110] xfs: fold xfs_refcountbt_init_common into
 xfs_refcountbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132204.2215168.2758321712154614047.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 45bfb39e003e..c1ae76949692 100644
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

