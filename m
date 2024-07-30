Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F573FE4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299746; cv=none; b=rt2ekdBY6R32idcIDwyNoPd+stsZXUmz+sxHrsyuvHQdEaruHvTDQhce2HJAQegzKCWuAOSPgPWFE07wwqXCwtdUkFl4GJGR978uJXxko+dQvqTT0Uzp/DUPYYYR28ImnERkvPAw/cqCcDHq2N+7LPhDopmI3uzlUbKoDlZqb4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299746; c=relaxed/simple;
	bh=ibFX8elBA6+vt3Cyn1yJdjyD2OfAnWo4Q5+HLK3Hk7U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPKuwIB6oxviUI5mtT9amdanAWwfDionwXAtQ2ZOIYOxoXCYQ2qV0SOgrTw6YFbE9/fqfWTcndaQ2Mv67b1ABz8+ogoOYHSKRBOCghxowxE8UUoH+tdeb0E1YvzwtnBqpu2D+nEfVW3GScszB/YbrS7vaf0K/QcaoM1MDvCZssc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCBJWQup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCBJWQup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CE1C32786;
	Tue, 30 Jul 2024 00:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299746;
	bh=ibFX8elBA6+vt3Cyn1yJdjyD2OfAnWo4Q5+HLK3Hk7U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eCBJWQupeTvBhRKiTS3m/ORxG6TLxnI+mAVvd6KM2u8n94TQ22CjnNiffSQuTDFTl
	 kcRPHHbjGB7YM2NG7G+jtxeWVTJyVsZT2oQkEtc59fYOG3Wr3G/tcog9CJUvSy9qxk
	 Id7dRm7zQFV7jhI3jMmM908FIqkDj+O65NUZ44DocIyqGYt1hTrOl22XyKECTNZcG1
	 aOoLRLQ1ZYRAVpNOu/dnWayZ8sK6eue7wAQS9svDnChvwpXzaVh+U6i/4Xhy4OqHF5
	 5/+uPtdYqQwDSO5GaSG/WzpaGNcpNZdc0hPeBGPmwU956cfvROk7zgePy89OmwZ8p0
	 Zhke3qo88T48Q==
Date: Mon, 29 Jul 2024 17:35:46 -0700
Subject: [PATCH 046/115] xfs: attr fork iext must be loaded before calling
 xfs_attr_is_leaf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843089.1338752.16878558381685097871.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ef80de940a6344da1d4f12c948a0ad4d6ff6e841

Christoph noticed that the xfs_attr_is_leaf in xfs_attr_get_ilocked can
access the incore extent tree of the attr fork, but nothing in the
xfs_attr_get path guarantees that the incore tree is actually loaded.

Most of the time it is, but seeing as xfs_attr_is_leaf ignores the
return value of xfs_iext_get_extent I guess we've been making choices
based on random stack contents and nobody's complained?

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5249f9be0..8e9e23836 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -85,6 +85,8 @@ xfs_attr_is_leaf(
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	imap;
 
+	ASSERT(!xfs_need_iread_extents(ifp));
+
 	if (ifp->if_nextents != 1 || ifp->if_format != XFS_DINODE_FMT_EXTENTS)
 		return false;
 
@@ -222,11 +224,21 @@ int
 xfs_attr_get_ilocked(
 	struct xfs_da_args	*args)
 {
+	int			error;
+
 	xfs_assert_ilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
 	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
 
+	/*
+	 * The incore attr fork iext tree must be loaded for xfs_attr_is_leaf
+	 * to work correctly.
+	 */
+	error = xfs_iread_extents(args->trans, args->dp, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
 	if (args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
 	if (xfs_attr_is_leaf(args->dp))
@@ -868,6 +880,11 @@ xfs_attr_lookup(
 		return -ENOATTR;
 	}
 
+	/* Prerequisite for xfs_attr_is_leaf */
+	error = xfs_iread_extents(args->trans, args->dp, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_hasname(args, &bp);
 

