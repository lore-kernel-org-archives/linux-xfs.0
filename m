Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD972CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548061; cv=none; b=dv8VtSGShggk+LgWes12NRuo9rpjkTnsZ/RYAqDcEuot1HDyqCZnJ4P0EdMZARBbuRwMO6FNfut2OarSXjtTteYgGi51dF46FEqlQ9pUsYD5mYQdPVjSLM7MKXuLsk58Cd3Rrd2MMSVMVdmnZBFJfJavHGQg2xxWgfsgYZN3pTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548061; c=relaxed/simple;
	bh=neVwpzzWoEfhxcLgi6U1ic6a2Tpij+mBOGXRufzDgmM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMbLeGJA5CckFG9uSCcvzhAduaj0HetUl6cSBSdeAvbOFVh2HDfYCyXnDyw0pWNQbMI9263IF3M3/Qn61YIFAqpgyKIW4CxZCUbTbH3Vt5J+0cHvj8rl/HT76I0JL6NgHUWeyxEjrmtloE8H+xKBPSRIz5E2nFcmwIWrb7bNCLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhpoNc1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhpoNc1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD7BC4CEC3;
	Mon, 21 Oct 2024 22:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548061;
	bh=neVwpzzWoEfhxcLgi6U1ic6a2Tpij+mBOGXRufzDgmM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VhpoNc1YhGeIu0pWvZotqVawY9aztuP/qNI16uF+ztl0uDnOsoNFV/5LuiPVhEIZU
	 LqnMnENZSpY+Xop/9GKfoWvQD44vh2lRYPjzreNaGkOA/1AlLPo4V9q0QrVSLpNZ/6
	 o4pb1CNaTwaxNavFuiU0N45OMF1rA2AaxtvCmnicDDQ27Dg66q56wNOl3YQocRNX5v
	 psy+6zAo0u9cQQGcxQPhjErj8QHp/1jQp604UeoovMKsSqSEnw42kx3tz6e5Bm4sL5
	 FzyqCAvZl+bCvAeMDcNqC2sF+17fXkojjPsh7eBaOhOlg2ABo0Ldu5BX2Idc0TqGCV
	 Ut1s0NzagCW8w==
Date: Mon, 21 Oct 2024 15:01:00 -0700
Subject: [PATCH 08/37] xfs: factor out a xfs_validate_rt_geometry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783593.34558.10965735688692303380.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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
 

