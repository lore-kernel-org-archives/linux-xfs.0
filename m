Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9958B1D0F7E
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416247; cv=none; b=b9Rr5rbPDHmU85GBjBB2e6fsfa+KC9SqHKNpvc9b+tUNw3yD7XNwIG/1/t/oC9xJDhVKQb4peCaiOjn9SjDpxDzXlnvPxFFtfgRtZcMeOXCbHAtINMeR9yCuvj/BqxFy4Bm7QF2po8xuNY5ih/Dn7QMf/+v7F4PeF8W5TEki7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416247; c=relaxed/simple;
	bh=neVwpzzWoEfhxcLgi6U1ic6a2Tpij+mBOGXRufzDgmM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEILlRCmUhXAxlwH27G9pn05ff53xepUzhtz3iKx8wY6+rqG90UJWWm89HTIQP+9QYifRSj+1KMULkKyeyj/BTVGS4oQbOLh8jlOV9ZSv9yKJ2H29uzvKP7TPFUGHWS0RyRACVdJlEHlzTyhvZz9MmU+iq8gQjK58BQyhYwrZVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izdqR2/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izdqR2/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D683C4CED2;
	Thu, 31 Oct 2024 23:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416247;
	bh=neVwpzzWoEfhxcLgi6U1ic6a2Tpij+mBOGXRufzDgmM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=izdqR2/2T7XoZIyIIy0YzEFTLG+XywFbsR8ho1sbqaCwmBLABQdq11jr6Z2jdkpNk
	 agd1gfx8BoxBvSCRxAxTBvMcePb4/pyNQvi/H7JP6vmMYXDBtXeATKLAfh2/YgltTn
	 1c20F4AsCqVo/TY2tGXGTgO0uO6lr/1NwgfbeN5Sh/ophWEVECMv5vCDDnNTanybwq
	 Qcwxmtmz5Q0k6ONnhEINDTr9lOArb7UJRY4bGgIkfrHs804p699xc9KLzfadBEvOZw
	 R3/RSALIHBy3GsQPGyj3xsNEss3hXLJfLvtxPqw0OCcjoZia4KFZ8sfOGRvpgK6p7o
	 CCSDL4cfhb85w==
Date: Thu, 31 Oct 2024 16:10:47 -0700
Subject: [PATCH 08/41] xfs: factor out a xfs_validate_rt_geometry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566042.962545.15976875332001408193.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6529eef810e2ded0e540162273ee31a41314ec4e

Split the RT geometry validation in the early mount code into a
helper than can be reused by repair (from which this code was
apparently originally stolen anyway).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: u64 return value for calc_rbmblocks]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_sb.c |   64 ++++++++++++++++++++++++++++++-------------------------
 libxfs/xfs_sb.h |    1 +
 2 files changed, 36 insertions(+), 29 deletions(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index a50c9c06c3f19c..c3185a4daeb4aa 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -229,6 +229,38 @@ xfs_validate_sb_read(
 	return 0;
 }
 
+static uint64_t
+xfs_sb_calc_rbmblocks(
+	struct xfs_sb		*sbp)
+{
+	return howmany_64(sbp->sb_rextents, NBBY * sbp->sb_blocksize);
+}
+
+/* Validate the realtime geometry */
+bool
+xfs_validate_rt_geometry(
+	struct xfs_sb		*sbp)
+{
+	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
+	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)
+		return false;
+
+	if (sbp->sb_rblocks == 0) {
+		if (sbp->sb_rextents != 0 || sbp->sb_rbmblocks != 0 ||
+		    sbp->sb_rextslog != 0 || sbp->sb_frextents != 0)
+			return false;
+		return true;
+	}
+
+	if (sbp->sb_rextents == 0 ||
+	    sbp->sb_rextents != div_u64(sbp->sb_rblocks, sbp->sb_rextsize) ||
+	    sbp->sb_rextslog != xfs_compute_rextslog(sbp->sb_rextents) ||
+	    sbp->sb_rbmblocks != xfs_sb_calc_rbmblocks(sbp))
+		return false;
+
+	return true;
+}
+
 /* Check all the superblock fields we care about when writing one out. */
 STATIC int
 xfs_validate_sb_write(
@@ -488,39 +520,13 @@ xfs_validate_sb_common(
 		}
 	}
 
-	/* Validate the realtime geometry; stolen from xfs_repair */
-	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
-	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
+	if (!xfs_validate_rt_geometry(sbp)) {
 		xfs_notice(mp,
-			"realtime extent sanity check failed");
+			"realtime %sgeometry check failed",
+			sbp->sb_rblocks ? "" : "zeroed ");
 		return -EFSCORRUPTED;
 	}
 
-	if (sbp->sb_rblocks == 0) {
-		if (sbp->sb_rextents != 0 || sbp->sb_rbmblocks != 0 ||
-		    sbp->sb_rextslog != 0 || sbp->sb_frextents != 0) {
-			xfs_notice(mp,
-				"realtime zeroed geometry check failed");
-			return -EFSCORRUPTED;
-		}
-	} else {
-		uint64_t	rexts;
-		uint64_t	rbmblocks;
-
-		rexts = div_u64(sbp->sb_rblocks, sbp->sb_rextsize);
-		rbmblocks = howmany_64(sbp->sb_rextents,
-				       NBBY * sbp->sb_blocksize);
-
-		if (sbp->sb_rextents == 0 ||
-		    sbp->sb_rextents != rexts ||
-		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
-		    sbp->sb_rbmblocks != rbmblocks) {
-			xfs_notice(mp,
-				"realtime geometry sanity check failed");
-			return -EFSCORRUPTED;
-		}
-	}
-
 	/*
 	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
 	 * would imply the image is corrupted.
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 37b1ed1bc2095e..796f02191dfd2e 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -38,6 +38,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
 		bool silent);
+bool	xfs_validate_rt_geometry(struct xfs_sb *sbp);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 

