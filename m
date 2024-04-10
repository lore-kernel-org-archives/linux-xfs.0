Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E475B7460
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710427; cv=none; b=YkMY7fNHW2NIq1eycm1VrbmCO7ynC8OohIaOxPUAOVb5kGQXGwp5RdIqaiAjG91BM0YW9B7+NKlj4BOkynIO6h+M8IQ+3dz7/sfp10WT6Reaf6Ak4TOaqMCvIkXBOb8T3hLqEoRqNUxZUhWerm5mbSFrZfrrV7N+ifNRlVKhftQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710427; c=relaxed/simple;
	bh=pHeRlcaAbjYMq9lUlNk5MQyBb52Y7GOZFy1TAYINrgU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jNF5cHTwsIImdJWccDSr5gXtX0VEWdrA95cN6GOlfBBIM53Ni3ClsaSKxAiEZVwDiXY4rT1pC4QUyYLB7jbPG9V1ISnOPYgcB9GW3ZaohDzNdx/cnlUvYs90MmjkXVfWyg58nvgYdr4bNiRa13yyRPS+bgCZ4sepwcSrzbhIcP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfm6l+1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfm6l+1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D00C433F1;
	Wed, 10 Apr 2024 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710426;
	bh=pHeRlcaAbjYMq9lUlNk5MQyBb52Y7GOZFy1TAYINrgU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kfm6l+1O+NoamviM5VqV7h2y0WCCrt05KQYLaTKvNHZpanN5K5hJyXhIt2cpF0mBb
	 dp8iOGMQxasc8o7gY2J5nGiwaQVeyUmJdmdqQ6sFs1vc/Z/qPBsAmEXWzOC5UnTcJk
	 hvXlnIpjbr/lHNiXR2r9mSf4EHXr4iwHMCQNIrbUKYj/jX8GuOY7YDZBBEiEXyASpN
	 UYacrPrgKd2/YrFJATGRsvPcziFql+NL5oOgEiFX0YVuri4w7QZB8dejVK3wqcqGcK
	 L8vIuE2ONzj5nE8BJTTbM6dB8XSt2lHzJ5RgL+uqqsgeOCE2vwFbEf3Tzo/2xzg7o4
	 mbRHAeaxSXCgg==
Date: Tue, 09 Apr 2024 17:53:46 -0700
Subject: [PATCH 01/32] xfs: rearrange xfs_attr_match parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969575.3631889.6417849868606970393.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Rearrange the parameters to this function so that they match the order
of attr listent: attr_flags -> name -> namelen -> value -> valuelen.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 7929caf2052f7..53ef784e3049e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -509,9 +509,9 @@ xfs_attr3_leaf_read(
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
@@ -521,12 +521,12 @@ xfs_attr_match(
 
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
@@ -745,8 +745,8 @@ xfs_attr_sf_findname(
 	for (sfe = xfs_attr_sf_firstentry(sf);
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
+		if (xfs_attr_match(args, sfe->flags, sfe->nameval,
+					sfe->namelen))
 			return sfe;
 	}
 
@@ -2442,15 +2442,16 @@ xfs_attr3_leaf_lookup_int(
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

