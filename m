Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DCA171C4
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928371; cv=none; b=UlVJXgEmvxR6Lm5lWvkpJyCatpfjtqRMy6IrEeIaNEA5Cg3NLvKNNeCGuFRU0hbvAWJ4z0GaCD9xazO30yfFt2P0mBoyZ5VxgtVvA2Lf4w+HZ4hkXT1JF+8yCEFr3QOesgwECDwA4Yw8iZdQ4V2XD4tsuJjYCucD3rvAfpWnGGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928371; c=relaxed/simple;
	bh=zhirR94Ok+Mn+eFP1eAG/wN15sC97gEtrMML0wqGioI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oc0pau6FNFewxPk6IL126+3ibHGV7NsRX7fDENuzjzp7HN4WP0wIM+opzD6gzmzbchvz3i1he6EUBh6ra22WXLNVLyUfZmveaP0TeTGNG362aB3hNdLG2q8OZqIuFqsrSabfMaGwfM7jQLHso8FN8Nvmwk/IAGc5vu2Akh6awjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dy8i/dib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dy8i/dib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D98C116B1;
	Wed, 24 Apr 2024 03:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928371;
	bh=zhirR94Ok+Mn+eFP1eAG/wN15sC97gEtrMML0wqGioI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dy8i/dib/1BFvNcnslZJRSXACPdWPtdCmNGbR5Ac1zZl7ZaM9fJCkH7T6rkEehiV7
	 UsQBMYI/7dItHjFKKOJM1WjjdIa6Mkqt6b0d4kObIv7SPsrmy80d15h5AXOhA4wqEY
	 8FgwIWOgLM1RiEBR0y5mtIix+BCPG3Ms/DLbMaymWl53Eoqeybeq2jC/j25F6a1Klh
	 CPMCTIqlw/V6ZDdHdfohx5HmVKHYw7HHwFOAyn6uN6FcQu174RMhcFbfvovRHlibNa
	 fQ1szW97JPKg/eh/tiSYtgB+Lc5cxln6y1uRq645RV1C/vlJScgkVcVJdopwieJk3W
	 WxIoU+59/3BZQ==
Date: Tue, 23 Apr 2024 20:12:50 -0700
Subject: [PATCH 01/30] xfs: rearrange xfs_attr_match parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783281.1905110.14261877765328293313.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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

Rearrange the parameters to this function so that they match the order
of attr listent: attr_flags -> name -> namelen -> value -> valuelen.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3b024ab892e6..bb00183d1349 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -510,9 +510,9 @@ xfs_attr3_leaf_read(
 static bool
 xfs_attr_match(
 	struct xfs_da_args	*args,
-	uint8_t			namelen,
-	unsigned char		*name,
-	int			flags)
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen)
 {
 
 	if (args->namelen != namelen)
@@ -522,12 +522,12 @@ xfs_attr_match(
 
 	/* Recovery ignores the INCOMPLETE flag. */
 	if ((args->op_flags & XFS_DA_OP_RECOVERY) &&
-	    args->attr_filter == (flags & XFS_ATTR_NSP_ONDISK_MASK))
+	    args->attr_filter == (attr_flags & XFS_ATTR_NSP_ONDISK_MASK))
 		return true;
 
 	/* All remaining matches need to be filtered by INCOMPLETE state. */
 	if (args->attr_filter !=
-	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
+	    (attr_flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
 		return false;
 	return true;
 }
@@ -746,8 +746,8 @@ xfs_attr_sf_findname(
 	for (sfe = xfs_attr_sf_firstentry(sf);
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
+		if (xfs_attr_match(args, sfe->flags, sfe->nameval,
+					sfe->namelen))
 			return sfe;
 	}
 
@@ -2443,15 +2443,16 @@ xfs_attr3_leaf_lookup_int(
  */
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
-			if (!xfs_attr_match(args, name_loc->namelen,
-					name_loc->nameval, entry->flags))
+			if (!xfs_attr_match(args, entry->flags,
+						name_loc->nameval,
+						name_loc->namelen))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
-			if (!xfs_attr_match(args, name_rmt->namelen,
-					name_rmt->name, entry->flags))
+			if (!xfs_attr_match(args, entry->flags, name_rmt->name,
+						name_rmt->namelen))
 				continue;
 			args->index = probe;
 			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);

