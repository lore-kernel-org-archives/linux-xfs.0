Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F567E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299840; cv=none; b=oXMZrq2wSMBXpXzqmtphfdO3FHsw1rfhge3Gqp2IkOgzOPY8Yq9SVz1hOtFyu6mri+9jkAUuxuWyfE+3AihqiWhh4Zgq1A9ADE8f8aUocJqA2IJjPvhxZOt9a60N42nRBq3SX/mVP+0H6/wtOwfreI1jT/0YXREMx+rXXMDjjPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299840; c=relaxed/simple;
	bh=7glL9aW38A9R83IPn2CaVH54n9cz4mk+fNRMeq9y4QE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLGMAPMeo/CDvkfhiHe1loHCxjr0mMoFVOG+5tfKltnpa7BWuboTRDSQW7Hw9bCIYANLiHZgouAxJ03QPsCn9BVQYsIROZBv9fWe3UpnQHIXBjV3nSIXshQpM/ZYLf/oYj9IFgFUetmXizP/OGxhlfsdbq+e2rPs1n6+CCoDvEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hB3vQboJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hB3vQboJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AADC32786;
	Tue, 30 Jul 2024 00:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299840;
	bh=7glL9aW38A9R83IPn2CaVH54n9cz4mk+fNRMeq9y4QE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hB3vQboJpge/ltYp8Yk72qQP+Xw2wWOBuVGheoht9gBGZjtL1juO0RxHiNC7Almiu
	 4hKLnIos0zh/BHIDhekbw/y1rnqVOm8LOcFBlFB/u0vOXP9wyS+JRoJiS4eViQmnHA
	 qnqRZ2elRQY8btw6qt/rFgdpBl8hj949sXqCHCvMhPsTHEFEUdvZ5sjc+sFf7ikVQl
	 997ayJ4aZCtSX++vTYxsJufe74mwBsid8IiVZ5/bfQnw1u/HMrdghGr08BFZ95AiB4
	 1XVRlVSZQc7Vxo8e74Zl2YdUAzHGPC+6djdYlzFgRW9CJcBBk14f72R9MrgjxVdWGz
	 WP1b/j1xorU6w==
Date: Mon, 29 Jul 2024 17:37:20 -0700
Subject: [PATCH 052/115] xfs: check the flags earlier in xfs_attr_match
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843173.1338752.12803574115243320131.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f49af061f49c004fb6df7f791f39f9ed370f767b

Checking the flags match is much cheaper than a memcmp, so do it early
on in xfs_attr_match, and also add a little helper to calculate the
match mask right under the comment explaining the logic for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr_leaf.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a3859961f..c6322fbd2 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -504,6 +504,13 @@ xfs_attr3_leaf_read(
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
@@ -511,21 +518,15 @@ xfs_attr_match(
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
 

