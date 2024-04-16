Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3095227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230778; cv=none; b=sOqfy0ifrgqefbNzBCYKaV0jTbbLeqKLmHQs+V6nO+ZOcJmApn2PJ/lStWBO1mT6EgHuhJzbX/TcQEZBkHUoqE7uxWeF+Kv0/GpiJgfsAqfsXKcDbUw4MSOx4KxSHXUzBMunDlFxvckuxhyjo/4TCmkRbXc8Ip2s7S20ojJv7bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230778; c=relaxed/simple;
	bh=qZL3N45Bdsj79PQL1rUWck8uA1E6uMO0LZ7Dj/EQ9jA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tjS7Sglwh1jWjjvN8VRj5AIdMSaQlLpO1/MR5pO5iomHaMF85ZbOflKZRKtoo3wkyZJuhXYed5rWmADrFeV5dxIZd3P/ZX/f3MhUeUleLYlvtSzuK4lW88bRBCBUOogIEkZyjNeB8BfM/ZTYrMeeldrTArPc3MtuCdeqoXrOVr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hE3+S8SV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hE3+S8SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FDEC113CC;
	Tue, 16 Apr 2024 01:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230778;
	bh=qZL3N45Bdsj79PQL1rUWck8uA1E6uMO0LZ7Dj/EQ9jA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hE3+S8SVbhi+t9b1W8Che/XEoCkZWL27VvgX2EySQv6L4wAF4KwBcIkmG9B8ubURz
	 VcDLKBSoxbSCNH/90oePXDdcmTVdfjJzIDlYkFbQIHdSP8LMv0K0AA7oxM94IRZ+El
	 glgWrXCdiLnebfskexAOIhmtbiYR2vKEtmKUnPmQmTpUUVbM8QonTvn33IhASc4ru5
	 sV3eQ9XQo0XXc8G4GZpZ6OkhpdKMzkVhPT9fs8baE9idjfv+FirJYQmwLGBXKnrBOu
	 5K7pipVpl1d/yk+gxo8rkpHOKqj2CB+SPCZf1zyo7NwYQ0B1mfclnl71wnJiB+Gtq+
	 Pdp9sBx0pw3Kg==
Date: Mon, 15 Apr 2024 18:26:18 -0700
Subject: [PATCH 01/31] xfs: rearrange xfs_attr_match parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027803.251715.14078267857153551216.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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
index 3b024ab892e68..bb00183d13492 100644
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

