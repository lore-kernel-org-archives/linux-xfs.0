Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAE710E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895563; cv=none; b=b9/q7SobvHO2E7ts+0htNxkZ/hkHdm0tQg1Rmdwe11PJlhd2InGt4ijRMz1Klu8hb6U2D9taqStcZdECTyeoOCNL2GiCNneTFgjAocEqvEB9AJodPwU+lNqMV8dQMZkZBtO+o+chHgGihAZPAfGN9q+yEESDSA36XUCO1DppIX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895563; c=relaxed/simple;
	bh=YoJbesoFelplnJ13HqirOhD6+R5HthwA9L8nycb7MPk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iC0MbTBOBjl3hMP4/EQ5AD5bsk/JCUiGgZwSYQSsfDUeEdFxGDoqyp9ErDd7R1YCV4zycqb3M+7HgtaFw/xpR+Pp712Um/g2BKoYM0YnpLjCWHjRkfCYQMuIBCfRfcWQMgVNPFbgMKt6AsuJYbfB1ytsKT2E2voe5SzpU8SSy0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkpgceZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkpgceZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76805C19425;
	Thu, 19 Mar 2026 04:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895563;
	bh=YoJbesoFelplnJ13HqirOhD6+R5HthwA9L8nycb7MPk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bkpgceZe1fmGO0goZ5CSg815WOAhIcvuwX38n8ME47on8X6R4Ny5ii8J4O1d0ngD1
	 E+M5eon09Q+YFgy2bxi3FihIxvynXHLmB0x99o4GWaPu5/f/SLlK4mumQctpcqEJaG
	 TlyZuIBwef2YJ7K1vlQVFeahj6H3iuZ6Slmw6XjG6o0Cg0Wy3LRIMkdD6SeVtKDGug
	 fDvah3E7etv0MBGwyJMyzNYlHTRchFD5Y6F4LA3iJSUFv6JcwyTiInwra694sMdCt+
	 0kcyZdxB60TmpwLPo1rsTxyy0PNjK98rKP6nWmmLcDfIHHh2wFWOqCCmy5VW/i09p+
	 60UmZsp5EUSXw==
Date: Wed, 18 Mar 2026 21:46:03 -0700
Subject: [PATCH 02/22] mkfs: rename byte unit conversion macros
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389506977.3681140.16696878706426311389.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Rename these macros so that we can promote the generic ones in the next
patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f859626afdda36..e0f0bb28e12159 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -18,9 +18,10 @@
 #include "proto.h"
 #include <ini.h>
 
-#define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
-#define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
-#define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
+/* Convert a quantity of mega/giga/terabytes into units of blocks */
+#define TERABLOCKS(count, blog)	((uint64_t)(count) << (40 - (blog)))
+#define GIGABLOCKS(count, blog)	((uint64_t)(count) << (30 - (blog)))
+#define MEGABLOCKS(count, blog)	((uint64_t)(count) << (20 - (blog)))
 
 /*
  * Realistically, the log should never be smaller than 64MB.  Studies by the
@@ -28,7 +29,7 @@
  * latency of the xlog grant head waitqueue when running a heavy metadata
  * update workload when the log size is at least 64MB.
  */
-#define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)	(MEGABYTES(64, (blog)))
+#define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)	(MEGABLOCKS(64, (blog)))
 
 /*
  * Use this macro before we have superblock and mount structure to
@@ -3443,7 +3444,7 @@ validate_supported(
 	 *
 	 * 64MB * (8 / 7) * 4 = 293MB
 	 */
-	if (mp->m_sb.sb_dblocks < MEGABYTES(300, mp->m_sb.sb_blocklog)) {
+	if (mp->m_sb.sb_dblocks < MEGABLOCKS(300, mp->m_sb.sb_blocklog)) {
 		fprintf(stderr,
  _("Filesystem must be larger than 300MB.\n"));
 		usage();
@@ -3559,7 +3560,7 @@ _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\
 				BBTOB(ft->data.sunit), BBTOB(ft->data.swidth));
 			ft->data.sunit = 0;
 			ft->data.swidth = 0;
-		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
+		} else if (cfg->dblocks < GIGABLOCKS(1, cfg->blocklog)) {
 			/*
 			 * Don't use automatic stripe detection if the device
 			 * size is less than 1GB because the performance gains
@@ -4056,7 +4057,7 @@ calc_concurrency_ag_geometry(
 	 */
 	try_threads = nr_threads;
 	try_agsize = cfg->dblocks / try_threads;
-	if (try_agsize < GIGABYTES(4, cfg->blocklog)) {
+	if (try_agsize < GIGABLOCKS(4, cfg->blocklog)) {
 		do {
 			try_threads--;
 			if (try_threads <= def_agcount) {
@@ -4065,7 +4066,7 @@ calc_concurrency_ag_geometry(
 			}
 
 			try_agsize = cfg->dblocks / try_threads;
-		} while (try_agsize < GIGABYTES(4, cfg->blocklog));
+		} while (try_agsize < GIGABLOCKS(4, cfg->blocklog));
 		goto out;
 	}
 
@@ -4413,7 +4414,7 @@ calc_concurrency_rtgroup_geometry(
 	 */
 	try_threads = nr_threads;
 	try_rgsize = cfg->rtblocks / try_threads;
-	if (try_rgsize < GIGABYTES(4, cfg->blocklog)) {
+	if (try_rgsize < GIGABLOCKS(4, cfg->blocklog)) {
 		do {
 			try_threads--;
 			if (try_threads <= def_rgcount) {
@@ -4422,7 +4423,7 @@ calc_concurrency_rtgroup_geometry(
 			}
 
 			try_rgsize = cfg->rtblocks / try_threads;
-		} while (try_rgsize < GIGABYTES(4, cfg->blocklog));
+		} while (try_rgsize < GIGABLOCKS(4, cfg->blocklog));
 		goto out;
 	}
 
@@ -4516,7 +4517,7 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 		 * If nobody specified a realtime device or the rtgroup size,
 		 * try 1TB, rounded down to the nearest rt extent.
 		 */
-		cfg->rgsize = TERABYTES(1, cfg->blocklog);
+		cfg->rgsize = TERABLOCKS(1, cfg->blocklog);
 		cfg->rgsize -= cfg->rgsize % cfg->rtextblocks;
 		cfg->rgcount = 0;
 	} else if (cfg->rtblocks < cfg->rtextblocks * 2) {
@@ -4651,7 +4652,7 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 					(cfg->rtblocks % cfg->rgcount != 0);
 		} else {
 			/* 256MB zones just like typical SMR HDDs */
-			cfg->rgsize = MEGABYTES(256, cfg->blocklog);
+			cfg->rgsize = MEGABLOCKS(256, cfg->blocklog);
 			cfg->rgcount = cfg->rtblocks / cfg->rgsize +
 					(cfg->rtblocks % cfg->rgsize != 0);
 		}
@@ -4692,9 +4693,9 @@ calculate_imaxpct(
 	 *  - under  1 TB, use XFS_DFL_IMAXIMUM_PCT (25%).
 	 */
 
-	if (cfg->dblocks < TERABYTES(1, cfg->blocklog))
+	if (cfg->dblocks < TERABLOCKS(1, cfg->blocklog))
 		cfg->imaxpct = XFS_DFL_IMAXIMUM_PCT;
-	else if (cfg->dblocks < TERABYTES(50, cfg->blocklog))
+	else if (cfg->dblocks < TERABLOCKS(50, cfg->blocklog))
 		cfg->imaxpct = 5;
 	else
 		cfg->imaxpct = 1;
@@ -5016,7 +5017,7 @@ calc_concurrency_logblocks(
 	 * If this filesystem is smaller than a gigabyte, there's little to be
 	 * gained from making the log larger.
 	 */
-	if (cfg->dblocks < GIGABYTES(1, cfg->blocklog))
+	if (cfg->dblocks < GIGABLOCKS(1, cfg->blocklog))
 		goto out;
 
 	/*
@@ -5279,7 +5280,7 @@ _("max log size %d smaller than min log size %d, filesystem is too small\n"),
 				XFS_MIN_REALISTIC_LOG_BLOCKS(cfg->blocklog));
 
 		/* And for a tiny filesystem, use the absolute minimum size */
-		if (cfg->dblocks < MEGABYTES(300, cfg->blocklog))
+		if (cfg->dblocks < MEGABLOCKS(300, cfg->blocklog))
 			cfg->logblocks = min_logblocks;
 
 		/* Ensure the chosen size fits within log size requirements */

