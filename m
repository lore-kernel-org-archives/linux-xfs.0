Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6EC171C4
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928387; cv=none; b=pgBjG00+uGrQzShT9ogir/2nRMtozfCTE8hHAEyZfVrX8KMhM9hmov6wV7B+gVmhlNn7eOIyWh905BLnQj/aKhoMF1OK83aUjjgsxrlRkRvCVhcyZ536kRRKMDRGd+Y35rCe8gaYvu5WH3kBhnfxiXI1jpVLlJZjUcWCMbpUrRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928387; c=relaxed/simple;
	bh=uao53P/DNuOaLAODbjSuZ51KqgTczBenTNKqXaOUwAU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfLRzqqxTKsJDXZWUPV8VJpWlJtLlUxJ3aAS/F+2yMg3kZO2og2UN/kYLOBNVcNhZeDW/oil+phT02UoRmg3tKDn8glEv6Pi2IAgOi4Ys0qQ3k+arWOilXg6xKfb3qvgUHvslu+V8a1p/vmWSEX0hxYMPRwujWbJ4WLY5YzTVuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsbMabOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsbMabOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6E0C116B1;
	Wed, 24 Apr 2024 03:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928386;
	bh=uao53P/DNuOaLAODbjSuZ51KqgTczBenTNKqXaOUwAU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PsbMabOMvUg2jBfK0AwIdRE+UtvKP9wOyo1LWUPq+169StnWFnjM8A5g38iQcqt9q
	 MeMfF0allvJVfXPsy6OKl7vxPYFndIKa3bogPFAnc8idl0WCx6VHG1BBxenLWsLLic
	 5S35A2AL0zT45rtOLAKolzvHH6YJqcL4NtCwNcTOutKEDrUwnZVsjpNcKbnObjjqjE
	 gx0CM3kwmgddoPg7CvmZxxig2T1W9DlSARZcwS+95RdWKlOzs1XfuF75Pr6AVITn4H
	 KpM+9w/sHj+NHxNbiTo+qW7oXjez5YbH1nrlkFTAx9/3297hOq+55fYcCPcgHY/ere
	 4d/7oduCrURVw==
Date: Tue, 23 Apr 2024 20:13:06 -0700
Subject: [PATCH 02/30] xfs: check the flags earlier in xfs_attr_match
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783298.1905110.8668433292321910348.stgit@frogsfrogsfrogs>
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
index bb00183d1349..c47fad39744e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -507,6 +507,13 @@ xfs_attr3_leaf_read(
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
@@ -514,21 +521,15 @@ xfs_attr_match(
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
 

