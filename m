Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1082E2417C0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882952; cv=none; b=m8zoEf8NYFJUXRq8go7LPAaJ7VFMHSJmPAseFTuUk43WyNOs779xXkIzlk4Sn0f4Og8XbsXUnr8twK091aH7NAp/OPX1Iz4yzffKJvsfdRbdoKwWTbWzlFZvOro655oVPUctESX8JcV/obPcyumGLgYFrxN9PfBFG6VDabH+FYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882952; c=relaxed/simple;
	bh=ezEdjI0Akf98Ov87OqmRFfGjguFgGatB6JhHtp+jkWI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zl71k6hkYdRZh5MhwMceKKRURzmrJuD2Ad3Hdkwb/+Oc6HvvpIFjN2158d1hN2DJw84PhcgAYzx3YEFZM10W2L/u9XMpZ9S/FxYgAYhOZ5vcV+pI+82gQDrLh7qpEsGPXqHI8m/45/fQ7vuhaPOuotZFp0fBJwKIBNBfwq2s8SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ae9xZ7Fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ae9xZ7Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F50C4CEDF;
	Thu,  6 Feb 2025 23:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882950;
	bh=ezEdjI0Akf98Ov87OqmRFfGjguFgGatB6JhHtp+jkWI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ae9xZ7FrLucOirau8GE9ziw6jwLvN66SMqx+iMINYFNznPgANWUdUjcsVT0xx8IUt
	 mSGI3iX50G0AgA7FgjKobvVJUOOcxkWWtHJ6SI5Isj1W8zxwMqt/25v0y1Qpgyqk0z
	 kTx7NRSex2QM+z7UfQdR13DDIWXd1BiFSHlI+/CRK+WwZICAyN6Qthibhwejdme7Zn
	 yIVT8l315Zy+QQMsaLeOHwf66EzTDNr8loxWhgCmJgNaXrX7LWJxTheKREH2x9fDDZ
	 g4HqE1OS+/EbIAMD3OB9YK2mZMTlh9mlSSrkW50bNHjDLlDOFK32G3dYf0nzox5b2m
	 TaoLbV4EQSJXA==
Date: Thu, 06 Feb 2025 15:02:30 -0800
Subject: [PATCH 22/22] mkfs: enable reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089269.2741962.12417664592407560122.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow the creation of filesystems with both reflink and realtime volumes
enabled.  For now we don't support a realtime extent size > 1.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/init.c            |    4 +--
 libxfs/libxfs_api_defs.h |    1 +
 mkfs/xfs_mkfs.c          |   63 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 60 insertions(+), 8 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 00bd46a6013e28..5b45ed3472762c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -305,9 +305,9 @@ rtmount_init(
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 
-	if (xfs_has_reflink(mp)) {
+	if (xfs_has_reflink(mp) && mp->m_sb.sb_rextsize > 1) {
 		fprintf(stderr,
-	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
+	_("%s: Reflink not compatible with realtime extent size > 1. Please try a newer xfsprogs.\n"),
 				progname);
 		return -1;
 	}
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 66cbb34f05a48f..530feef2a47db8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -323,6 +323,7 @@
 #define xfs_rtrefcountbt_absolute_maxlevels	libxfs_rtrefcountbt_absolute_maxlevels
 #define xfs_rtrefcountbt_calc_reserves	libxfs_rtrefcountbt_calc_reserves
 #define xfs_rtrefcountbt_calc_size		libxfs_rtrefcountbt_calc_size
+#define xfs_rtrefcountbt_calc_reserves	libxfs_rtrefcountbt_calc_reserves
 #define xfs_rtrefcountbt_commit_staged_btree	libxfs_rtrefcountbt_commit_staged_btree
 #define xfs_rtrefcountbt_create		libxfs_rtrefcountbt_create
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9239109434d748..c794f918573f91 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2671,12 +2671,36 @@ _("inode btree counters not supported without finobt support\n"));
 	}
 
 	if (cli->xi->rt.name) {
-		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
-			fprintf(stderr,
-_("reflink not supported with realtime devices\n"));
-			usage();
+		if (cli->rtextsize && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with rt extent size specified\n"));
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
+		if (cfg->blocksize < XFS_MIN_RTEXTSIZE && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with blocksize %d < %d\n"),
+						cli->blocksize,
+						XFS_MIN_RTEXTSIZE);
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
+		if (!cli->sb_feat.metadir && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK) &&
+			    cli_opt_set(&mopts, M_METADIR)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices without metadir feature\n"));
+				usage();
+			} else if (cli_opt_set(&mopts, M_REFLINK)) {
+				cli->sb_feat.metadir = true;
+			} else {
+				cli->sb_feat.reflink = false;
+			}
 		}
-		cli->sb_feat.reflink = false;
 
 		if (!cli->sb_feat.metadir && cli->sb_feat.rmapbt) {
 			if (cli_opt_set(&mopts, M_RMAPBT) &&
@@ -2874,6 +2898,19 @@ validate_rtextsize(
 			usage();
 		}
 		cfg->rtextblocks = (xfs_extlen_t)(rtextbytes >> cfg->blocklog);
+	} else if (cli->sb_feat.reflink && cli->xi->rt.name) {
+		/*
+		 * reflink doesn't support rt extent size > 1FSB yet, so set
+		 * an extent size of 1FSB.  Make sure we still satisfy the
+		 * minimum rt extent size.
+		 */
+		if (cfg->blocksize < XFS_MIN_RTEXTSIZE) {
+			fprintf(stderr,
+		_("reflink not supported on rt volume with blocksize %d\n"),
+				cfg->blocksize);
+			usage();
+		}
+		cfg->rtextblocks = 1;
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2905,6 +2942,12 @@ validate_rtextsize(
 		}
 	}
 	ASSERT(cfg->rtextblocks);
+
+	if (cli->sb_feat.reflink && cfg->rtblocks > 0 && cfg->rtextblocks > 1) {
+		fprintf(stderr,
+_("reflink not supported on realtime with extent sizes > 1\n"));
+		usage();
+	}
 }
 
 /* Validate the incoming extsize hint. */
@@ -5087,11 +5130,19 @@ check_rt_meta_prealloc(
 		error = -libxfs_metafile_resv_init(rtg_rmap(rtg), ask);
 		if (error)
 			prealloc_fail(mp, error, ask, _("realtime rmap btree"));
+
+		ask = libxfs_rtrefcountbt_calc_reserves(mp);
+		error = -libxfs_metafile_resv_init(rtg_refcount(rtg), ask);
+		if (error)
+			prealloc_fail(mp, error, ask,
+					_("realtime refcount btree"));
 	}
 
 	/* Unreserve the realtime metadata reservations. */
-	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		libxfs_metafile_resv_free(rtg_rmap(rtg));
+		libxfs_metafile_resv_free(rtg_refcount(rtg));
+	}
 
 	/* Unreserve the per-AG reservations. */
 	while ((pag = xfs_perag_next(mp, pag)))

