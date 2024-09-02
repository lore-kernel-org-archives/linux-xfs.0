Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BA219CC17
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301466; cv=none; b=qhLA2Km5qwYT60vbpFMuqoRzEYw7l/uHuXZFVRpx/PuUjdEsilt/wzHm3HfiMTeQpSONVgVQPrSQqKNh0tDRU+5cAP593FTrvsp5FNIs4nYpdshKzNgOkf4+5udXodkPX3QWX8LOtSQG/C+CHxlIfk0+XqOR7RE2OtT/EsPiPWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301466; c=relaxed/simple;
	bh=mZEXf4VioodfNCWINwkiz/omqXIaTarqpiIT3Bwu0Vk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Li2eJZrO6nfTbFxdiO3sFcR14HWYHmauOAB2wrZggq9qioUxbVuoHxzCu/8d7GYMxWt4uQ5aq0nKeZz9PJA7u51BPggkcvX+b+ExeqAlBaRFyLEO4cNw22xmCQoNyXsXSvxRb6EO7ITk6wYNZ/njG/usWGHY+tpOk/0vR9n+o5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiQyWU1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiQyWU1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217CBC4CEC7;
	Mon,  2 Sep 2024 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301466;
	bh=mZEXf4VioodfNCWINwkiz/omqXIaTarqpiIT3Bwu0Vk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XiQyWU1Q+x09ff/D2VFQI7mnzwwzdOFZ/okxNNoig54aLzoFzMSOT6LLhv0PiymWm
	 Hy3sxDCtrSfmTH8E25QEoP1le9WyAMfo7hjLW3kcEY0V+O4uwz9gqMAxlSHEkZZ//5
	 51LmpDX+mwkxrOtNZHeDUW6FpL4uSLwcCW24ufiH58SOvwQv9+xDJyL8viGe2Qgpj5
	 3YtQMuHCLBrraRtF1rVhRSWZX7HfvjpS6vUorJpcMfkdAwl2LcxhNNXs3tuz1EQAZR
	 QDWtSpdfVlkdS+nElNLFpaKC2BwAgF3X831Rbm0VKsWYutl4LmkMRp3VxerJvBotbW
	 oyXjz/CM8ChZA==
Date: Mon, 02 Sep 2024 11:24:25 -0700
Subject: [PATCH 02/12] xfs: factor out a xfs_validate_rt_geometry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105749.3325146.15482918038952714808.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
References: <172530105692.3325146.16430332012430234510.stgit@frogsfrogsfrogs>
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
index f2fb6035fd21..f9c3045f71e0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -232,6 +232,38 @@ xfs_validate_sb_read(
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
@@ -491,39 +523,13 @@ xfs_validate_sb_common(
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
index 37b1ed1bc209..796f02191dfd 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -38,6 +38,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
 		bool silent);
+bool	xfs_validate_rt_geometry(struct xfs_sb *sbp);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 

