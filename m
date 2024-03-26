Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799C11D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424488; cv=none; b=Se6v/Qw5RG2SnkhvzYds4OTbEYj7XEFFVmMbykXKDXKtFxz2nlg7oKCUVQTb4YqEA3zlEZZRu1G5Z1lrujhb0UUYarpYuq/kiyBxdWJveD235bCKGqbAaa4AZv2YH788Mgy0K2zlJ+OHl8AM/8jrVfUebFaJFSZj1dfUga5Vh5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424488; c=relaxed/simple;
	bh=v/Le4z1LNP1Gsw4eknuG9+PHmSVRPYodE4nqcAiYx3g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V8UFM5YM62vjSHHEPbsFeRZsoKXXqW1ATw71tivA+K9daJA7lCcN+yS+v6BICm1juY3ggr6Nwy3GfwY/SmoFOeAR4Ov9CCue3B25q+MqWCo+ZhFePP7ADG+hU0fOlxL+fgp9S0FlXzmRK8KQdLxqr+xAs4HNBfnDhA1W0Dh5R2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmt5RZEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmt5RZEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AA2C433C7;
	Tue, 26 Mar 2024 03:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424488;
	bh=v/Le4z1LNP1Gsw4eknuG9+PHmSVRPYodE4nqcAiYx3g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fmt5RZEMSw/FGnuNnStqP1J6GOb+xhJ+dFccrIy40bqSdXEydhw/mEQp8DW1VBLhP
	 AfH5gsefumAp1pwsxgdMcJ7y8hKv/epuwgLa0xzugc0ZR3Jl3jmgWCJ6JuEgHSFznk
	 UqsiCGla0LclBxnIWxnC+UO8jCDKWkvnsRlwAxjQ78jKtxDMAkwYQlc53uuR4nFZCZ
	 KpoYBeettlV/22qofAoDmwAbEd2uPU5ovqVF5v4uoDZ/YudmASub1haaoq/aKc1khg
	 GmkqPf8gMoL2pnA/REVc0e3CyK2md64E1c2IKDKajALwaSGmWIXKPe5gwM/EYBby7r
	 NRKwbOKpuyMOg==
Date: Mon, 25 Mar 2024 20:41:27 -0700
Subject: [PATCH 050/110] xfs: move comment about two 2 keys per pointer in the
 rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132104.2215168.5353150739505304099.stgit@frogsfrogsfrogs>
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

Source kernel commit: 72c2070f3f52196a2e8b4efced94390b62eb8ac4

Move it to the relevant initialization of the ops structure instead
of a place that has nothing to do with the key size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f87e34a1dee8..311261df38a2 100644
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

