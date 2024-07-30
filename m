Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2576A7E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299825; cv=none; b=RMSqrWib6mMNubArAfd7Vu1c/9dJvc8+NXR+hLy1brIfzM4j/EMZdIV1owJm5sJP88aIxhW2h585guhi8RKnh4nyiSxUwj1e8nlxTDAn6iwDt7NOo6o27ebaesJsDYTmJ+iYYFSIQXql0T899MooT1bvWkUEVXHWCY2OiA2CQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299825; c=relaxed/simple;
	bh=J2MBeUrcJJzJdgMsZ992i3srKB0G+bMVO9JppJTk6AU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTm/4aVQ7f+iypCZVNaJEMXvsfs8mwtY7D1xbN6REK7pWb8PgqYPER1i2IAr1ENC+6QDUuxZaaWYyHdCc5TZPVDP5zHzmeTS19/htzRxHwqI2+woRNvVF9LuVLtIMYRpGKQXnCZjheeYabhpsHdlyt4+rgSDBIHjY5Yc5CK8iDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SlE2NXnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SlE2NXnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AD6C32786;
	Tue, 30 Jul 2024 00:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299825;
	bh=J2MBeUrcJJzJdgMsZ992i3srKB0G+bMVO9JppJTk6AU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SlE2NXnG5Lgv7pH1TVmJfLz5ryjeOTNYmoE/2zipz3hlkx1WVpZ8mN4Bbg98zW3Rj
	 NBwejJtNbArmrTJ4A4ZxOKvnXGHdvNi9DsdPgHLMQkndbnwBRTDIKDsXvggkh7LhA3
	 QcWnQhNohqF/obfM73lX7/wXXukuua0IKCEOFByrsuBArbIkPgazsN26aaoL8w/AJm
	 4nL1bUgHc4DunwvgBmuXTVbHXu7tlec5W3CBRsNN5CMbdRhORxZnCMRBGdeSlHsRHO
	 dBZ8VRJdLqstyB9o3F8UHF0zAs0lFWX8t+xrwb3voKWPchWkl7yjpE06Rz507P7Uap
	 mOj8UIzAi0U5A==
Date: Mon, 29 Jul 2024 17:37:04 -0700
Subject: [PATCH 051/115] xfs: rearrange xfs_attr_match parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843160.1338752.10235040469343834149.stgit@frogsfrogsfrogs>
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

Source kernel commit: 63211876ced33fbb730f515e8d830de53533fc82

Rearrange the parameters to this function so that they match the order
of attr listent: attr_flags -> name -> namelen -> value -> valuelen.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr_leaf.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 346f0127d..a3859961f 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -507,9 +507,9 @@ xfs_attr3_leaf_read(
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
@@ -519,12 +519,12 @@ xfs_attr_match(
 
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
@@ -743,8 +743,8 @@ xfs_attr_sf_findname(
 	for (sfe = xfs_attr_sf_firstentry(sf);
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
+		if (xfs_attr_match(args, sfe->flags, sfe->nameval,
+					sfe->namelen))
 			return sfe;
 	}
 
@@ -2440,15 +2440,16 @@ xfs_attr3_leaf_lookup_int(
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

