Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3821E5717
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971102; cv=none; b=XdJKAy23nEtyqnWsA/IE++SX1DAVgWXB97VK9JBta/0SxxoSZQ0eNXKnB6QUVtYB3Nfk6xCetL+Rfc8KppKlC6k/wD5qW0tbaVbfS7aYVFHKvlRofplBHr3WpkepyMC7VwjYFvQyTn/08Kke0k1XDupKAIpyPWJNyoDtoIWXBwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971102; c=relaxed/simple;
	bh=EyfBrxfYJDUB8ncykyWRLB/76vC+8xoUkRZLlOjGfEI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KICn/9Lx8O2OxbvKIjxp35fYPBgNMjK7PamIv2KGphJu/AkwEv/hGD6Kxc0DmBMUb0IjrxbPCvNljTMfiU8n3udcKktnOCk4zAZhK47OrgIvBAVHLD/XGlVf1LnNqbwhaH+MeU2Pa0/eDiideH1l2d3ZkmSdIWElsLruso7lYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpJIF1JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpJIF1JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9521C4CECC;
	Mon, 18 Nov 2024 23:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971102;
	bh=EyfBrxfYJDUB8ncykyWRLB/76vC+8xoUkRZLlOjGfEI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KpJIF1JUQA11wEDXSklPzzFelvWTmcydU5S+Uw/eIFTiTZ8M79Due1lz1xmEs6Qse
	 lA6X0Syvoz/UcbQ6xduF1fBIAd2Fw+SwoRbH2RCbc/lf/+5ymXaw9dHHxT3TR8jl5X
	 bNumUUfzKpxfxLKP8ZRKVs9Tdroio/2dC7tGmE5ldQrCNxlfqMUo6kwWK+0J1nn0rl
	 rmoOmQ6rcin69SX5ZLwfkzS0XjT0HWeXTH7RE5j11+SBEcoCTh8//SdxQQHg+zN0d3
	 4Flp+BxewzLbyWHzQK7BvLV08e/70TBslpVqAeJriZQF7yrBsTg2FBhE65G5e4hrPn
	 G6egM2ojsaBvg==
Date: Mon, 18 Nov 2024 15:05:02 -0800
Subject: [PATCH 02/10] xfs: metapath scrubber should use the already loaded
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173197084448.911325.8377209709944240957.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't waste time in xchk_setup_metapath_dqinode doing a second lookup of
the quota inodes, just grab them from the quotainfo structure.  The
whole point of this scrubber is to make sure that the dirents exist, so
it's completely silly to do lookups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/metapath.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index b78db651346518..80467d6bc76389 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -196,36 +196,45 @@ xchk_setup_metapath_dqinode(
 	struct xfs_scrub	*sc,
 	xfs_dqtype_t		type)
 {
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*dp = NULL;
 	struct xfs_inode	*ip = NULL;
-	const char		*path;
 	int			error;
 
+	if (!qi)
+		return -ENOENT;
+
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		ip = qi->qi_uquotaip;
+		break;
+	case XFS_DQTYPE_GROUP:
+		ip = qi->qi_gquotaip;
+		break;
+	case XFS_DQTYPE_PROJ:
+		ip = qi->qi_pquotaip;
+		break;
+	default:
+		ASSERT(0);
+		return -EINVAL;
+	}
+	if (!ip)
+		return -ENOENT;
+
 	error = xfs_trans_alloc_empty(sc->mp, &tp);
 	if (error)
 		return error;
 
 	error = xfs_dqinode_load_parent(tp, &dp);
-	if (error)
-		goto out_cancel;
-
-	error = xfs_dqinode_load(tp, dp, type, &ip);
-	if (error)
-		goto out_dp;
-
 	xfs_trans_cancel(tp);
-	tp = NULL;
+	if (error)
+		return error;
 
-	path = kasprintf(GFP_KERNEL, "%s", xfs_dqinode_path(type));
-	error = xchk_setup_metapath_scan(sc, dp, path, ip);
+	error = xchk_setup_metapath_scan(sc, dp,
+			kstrdup(xfs_dqinode_path(type), GFP_KERNEL), ip);
 
-	xfs_irele(ip);
-out_dp:
 	xfs_irele(dp);
-out_cancel:
-	if (tp)
-		xfs_trans_cancel(tp);
 	return error;
 }
 #else

