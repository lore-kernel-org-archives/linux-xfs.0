Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E558947E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371768; cv=none; b=iSgFgzKhrIG8LDGWf2d9BrsQTngMcP4DI0UcRWvDM/oVoPywSjHUWUV4ifwafLtwudnT/MeMOqI0qKTAjyiFIdp9P9NkXO+6Y/UnGep8W/V0dNDMGb2O7MG7JcviCmqQRF7z3bmIL+EUzhHVGJ7bJNztOmiXXnQprgK3/WFPEuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371768; c=relaxed/simple;
	bh=VY4m2PWxkhA2lkL09B+mWR3QyDA3zQf+Hhl6DingQF4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qy46aLf0m9/vWJirGUr+73gk7uQ2Ab171G9OOsXd1OolbAyky5TWkWx4IyFGbPfgUDcaV+GqNaXz2lTXqQgoZ/5Dtzv6LwCNdyN3Gi1DrpAiSXHv0TYaQ7HXdYcKg0XpKy+PIwIh3gTYYyg20fU0AqQ5KYbifaUEctEtAvXZTZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNb8JPn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNb8JPn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD39C4AF0E;
	Fri, 23 Aug 2024 00:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371767;
	bh=VY4m2PWxkhA2lkL09B+mWR3QyDA3zQf+Hhl6DingQF4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cNb8JPn99fjCdh+B85Dse2lFHkIZ3A3yEz1f6Dn64GBB6ZzASFgeMphijduDy5Le/
	 k6A18oARoGKRnEnqOAh3ZuMzR1v1hS1R3vzDBK5WMVL7fimRf1Vi7T+RJZEsrFYw1N
	 A4COSTa5YyT5GejCP0Ms+jcuzOgzXsBnrE/DQffQHdHVfDSu8S9c6vnixvWlJA19UB
	 Hk+2uVbfNN1y+80BYNnT63QPqySJywCOhp7gdfJHCBBBny3MNeI1wTULN/VY8ZEVUo
	 37iQaLW9O9u+Ryl9g1w5mMkGr5VM74anQ1Orfyywemkp3XcQdbWXGzDFRHbh4ySBGC
	 lGlIhKd7hg8YQ==
Date: Thu, 22 Aug 2024 17:09:27 -0700
Subject: [PATCH 02/12] xfs: factor out a xfs_validate_rt_geometry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086053.58604.11507018611823623127.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

Split the RT geometry validation in the early mount code into a
helper than can be reused by repair (from which this code was
apparently originally stolen anyway).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: u64 return value for calc_rbmblocks]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |   64 ++++++++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_sb.h |    1 +
 2 files changed, 36 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b781e5f836e4c..a4221afb012b6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -234,6 +234,38 @@ xfs_validate_sb_read(
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
@@ -493,39 +525,13 @@ xfs_validate_sb_common(
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
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 37b1ed1bc2095..796f02191dfd2 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -38,6 +38,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
 		bool silent);
+bool	xfs_validate_rt_geometry(struct xfs_sb *sbp);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 

