Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862C68BF7
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710442; cv=none; b=vGOEtEOrZMdb/zYmYwd+HZGodNpMBg/fOLcC11N59Ju8FDPSN+XyiJFeJa/bZClwYHR0bmc5LaYijNsMzrwnKmY5RQD8wuULrCBWiVPeiV0kdVb9//psnorArDgI/01rWSwjhFWNCiKYruH+ngeKUWHwfIKG5oUQrFDWGLRO6OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710442; c=relaxed/simple;
	bh=hA+yt9yN8VleVxIll9rThexLpWpT/2vrWsCtU9sMMPk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6sTkKQBduU1yNJ/EPrkrRZbtkuotmC4BFP2Zd6yaU1D9+KFhsz4DvQf01hr69SePAT6lTwZzUboRirDQW4ZhiX76KLD4ISgz2EFmizoBn0JvW47Nu8dIDZPEFrVIg67TLYmkLGMpXjI8jWHAS3eagXg5QbzqWhVaQ2nfZLrxdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mh4rArRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mh4rArRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E460C433C7;
	Wed, 10 Apr 2024 00:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710442;
	bh=hA+yt9yN8VleVxIll9rThexLpWpT/2vrWsCtU9sMMPk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Mh4rArRYGunWMHgcvdAVli6gkf3voZDDUmvXQ0/2jHsT9V7vxODuWhuG3yOMTiSwI
	 Bi7eaSHlnHv1Q6a+01HPm95fi1ZEKN1MOn4bMoiHJzUwqHgcZTvOPrAyFCR7/NsdQK
	 kC4VnPQNXjJH8/xBT+w7MftT4lNr9sK1HYZl9vWZvDnmCDZ0s5EmQQc/Z0C4TtlP6T
	 tf8MqokcXusEochuS3NQksO0uRsBaM2AX0zKNhv7e0EPVUn1UgsA6dm/NoR6Mu/8KY
	 0C0GRq7ZW+eI2+gI5oI4pww37sdipS/77KDWe9A5b+bhx3ff//g1k2RDdsa5brERZd
	 DZR69E9KNNzHw==
Date: Tue, 09 Apr 2024 17:54:01 -0700
Subject: [PATCH 02/32] xfs: check the flags earlier in xfs_attr_match
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com, hch@lst.de,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270969591.3631889.10114648429816387256.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Checking the flags match is much cheaper than a memcmp, so do it early
on in xfs_attr_match, and also add a little helper to calculate the
match mask right under the comment explaining the logic for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 53ef784e3049e..9cb3a5d1c07d1 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -506,6 +506,13 @@ xfs_attr3_leaf_read(
  * INCOMPLETE flag will not be set in attr->attr_filter, but rather
  * XFS_DA_OP_RECOVERY will be set in args->op_flags.
  */
+static inline unsigned int xfs_attr_match_mask(const struct xfs_da_args *args)
+{
+	if (args->op_flags & XFS_DA_OP_RECOVERY)
+		return XFS_ATTR_NSP_ONDISK_MASK;
+	return XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE;
+}
+
 static bool
 xfs_attr_match(
 	struct xfs_da_args	*args,
@@ -513,21 +520,15 @@ xfs_attr_match(
 	const unsigned char	*name,
 	unsigned int		namelen)
 {
+	unsigned int		mask = xfs_attr_match_mask(args);
 
 	if (args->namelen != namelen)
 		return false;
+	if ((args->attr_filter & mask) != (attr_flags & mask))
+		return false;
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
 
-	/* Recovery ignores the INCOMPLETE flag. */
-	if ((args->op_flags & XFS_DA_OP_RECOVERY) &&
-	    args->attr_filter == (attr_flags & XFS_ATTR_NSP_ONDISK_MASK))
-		return true;
-
-	/* All remaining matches need to be filtered by INCOMPLETE state. */
-	if (args->attr_filter !=
-	    (attr_flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
-		return false;
 	return true;
 }
 

