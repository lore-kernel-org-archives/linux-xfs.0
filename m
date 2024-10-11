Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CB7D2FB
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610656; cv=none; b=jxhxzTRmeuMZrHrVc/sJQhiblrMjxH20K2UL48tpRn0fV2J0ghRQ9Gr2UWbpi+E6ozKXPxqILOdfXzN7xlY0L65RuEPoN5SZYiCS2N4I1nudrNNB9Va2e89xubXRa6Wj4OsLr0qtJsiP9sUfJGtTSWfogP+lt6q9iVivEJ7i5Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610656; c=relaxed/simple;
	bh=9yK224qtusOJjnNWqKpGg411Y6HVP35uoRykjgGid6s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ie0K64ss5fbBgvBeUzE/wbfU7eyMn1EbMj/ncjM/sYdYuPWRemGYkELLxHhsb+xpP1wliAlq60qTLbhCBT0OL2xVhsiAYiPPLugpXsb1Ldcx+YGk6HbaErKhNG1Et4cGp3e1ZthM78dVeH7x4yEqLQt74zcnxj8QTKmC5TFDcD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ca1C5Yb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ca1C5Yb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45196C4CEC5;
	Fri, 11 Oct 2024 01:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610656;
	bh=9yK224qtusOJjnNWqKpGg411Y6HVP35uoRykjgGid6s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ca1C5Yb3uIS9Hu/ZPSzE+1Yrv/xgzxtJNYpQsUyCpht5y71basXbeVPuFlV7mXx0y
	 C6sKJVUI2ed0hI85ks/clEBMypJ6fguD4C6i1mQmuvytmRnrQItLKQcCB+Bk3ggFnJ
	 B5kDm+mmOmPr4PtgHkQLkzOV2rlzU4DEY6q5P8Uzd3UxBafdqy8srk2HLLpVFnYTqF
	 LktxthIIouNNOnOaiRV1VLQRNtM2YwgTOOCxAkeTV20cEYPl0jKA4+ieOrAM80UQPc
	 +wPEJQyOgHFIrDKyTKULq8MFpM9gaw2cgrOA6ks4lkco5XobRSXcOnPL5jQ9qglbQX
	 CYFeDgAurliIg==
Date: Thu, 10 Oct 2024 18:37:35 -0700
Subject: [PATCH 7/7] mkfs: add quota flags when setting up filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656480.4186076.15873436204269832107.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
References: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
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

If we're creating a metadir filesystem, the quota accounting and
enforcement flags persist until the sysadmin changes them.  Add a means
to specify those qflags at format time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |   48 ++++++++++++++++++++
 mkfs/xfs_mkfs.c        |  113 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 1 deletion(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 004dac350e2dc9..82d9e0000d72ea 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -340,6 +340,54 @@ .SH OPTIONS
 See the
 .BI xfs_scrub (8)
 manual page for more information on this property.
+.TP
+.B uquota
+If the metadata directory feature is enabled, the
+.B \-m uquota
+option will set up user quota accounting and enforcement at format time;
+specifying the quota options in fstab is no longer unnecessary.
+If metadata directories are not enabled, quotas must still be enabled via
+fstab.
+.TP
+.B gquota
+If the metadata directory feature is enabled, the
+.B \-m gquota
+option will set up group quota accounting and enforcement at format time;
+specifying the quota options in fstab is no longer unnecessary.
+If metadata directories are not enabled, quotas must still be enabled via
+fstab.
+.TP
+.B pquota
+If the metadata directory feature is enabled, the
+.B \-m pquota
+option will set up project quota accounting and enforcement at format time;
+specifying the quota options in fstab is no longer unnecessary.
+If metadata directories are not enabled, quotas must still be enabled via
+fstab.
+.TP
+.B uqnoenforce
+If the metadata directory feature is enabled, the
+.B \-m uqnoenforce
+option will set up user quota accounting at format time; specifying the quota
+options in fstab is no longer unnecessary.
+If metadata directories are not enabled, quotas must still be enabled via
+fstab.
+.TP
+.B gqnoenforce
+If the metadata directory feature is enabled, the
+.B \-m gqnoenforce
+option will set up group quota accounting at format time; specifying the quota
+options in fstab is no longer unnecessary.
+If metadata directories are not enabled, quotas must still be enabled via
+fstab.
+.TP
+.B pqnoenforce
+If the metadata directory feature is enabled, the
+.B \-m pqnoenforce
+option will set up project quota accounting at format time; specifying the
+quota options in fstab is no longer unnecessary.
+If metadata directories are not enabled, quotas must still be enabled via
+fstab.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4e02adbd1913fa..0e1260ec70829c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -153,6 +153,12 @@ enum {
 	M_BIGTIME,
 	M_AUTOFSCK,
 	M_METADIR,
+	M_UQUOTA,
+	M_GQUOTA,
+	M_PQUOTA,
+	M_UQNOENFORCE,
+	M_GQNOENFORCE,
+	M_PQNOENFORCE,
 	M_MAX_OPTS,
 };
 
@@ -833,6 +839,12 @@ static struct opt_params mopts = {
 		[M_BIGTIME] = "bigtime",
 		[M_AUTOFSCK] = "autofsck",
 		[M_METADIR] = "metadir",
+		[M_UQUOTA] = "uquota",
+		[M_GQUOTA] = "gquota",
+		[M_PQUOTA] = "pquota",
+		[M_UQNOENFORCE] = "uqnoenforce",
+		[M_GQNOENFORCE] = "gqnoenforce",
+		[M_PQNOENFORCE] = "pqnoenforce",
 		[M_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -888,6 +900,48 @@ static struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = M_UQUOTA,
+		  .conflicts = { { &mopts, M_UQNOENFORCE },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = M_GQUOTA,
+		  .conflicts = { { &mopts, M_GQNOENFORCE },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = M_PQUOTA,
+		  .conflicts = { { &mopts, M_GQNOENFORCE },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = M_UQNOENFORCE,
+		  .conflicts = { { &mopts, M_UQUOTA },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = M_GQNOENFORCE,
+		  .conflicts = { { &mopts, M_GQUOTA },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = M_PQNOENFORCE,
+		  .conflicts = { { &mopts, M_PQUOTA },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -945,6 +999,8 @@ struct sb_feat_args {
 	bool	nortalign;
 	bool	nrext64;
 	bool	exchrange;		/* XFS_SB_FEAT_INCOMPAT_EXCHRANGE */
+
+	uint16_t qflags;
 };
 
 struct cli_params {
@@ -1083,6 +1139,8 @@ usage( void )
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
 			    inobtcount=0|1,bigtime=0|1,autofsck=xxx,\n\
 			    metadir=0|1]\n\
+/* quota */		[-m uquota|uqnoenforce,gquota|gqnoenforce,\n\
+			    pquota|pqnoenforce]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num,concurrency=num]\n\
@@ -1921,6 +1979,30 @@ meta_opts_parser(
 	case M_METADIR:
 		cli->sb_feat.metadir = getnum(value, opts, subopt);
 		break;
+	case M_UQUOTA:
+		if (getnum(value, opts, subopt))
+			cli->sb_feat.qflags |= XFS_UQUOTA_ACCT | XFS_UQUOTA_ENFD;
+		break;
+	case M_GQUOTA:
+		if (getnum(value, opts, subopt))
+			cli->sb_feat.qflags |= XFS_GQUOTA_ACCT | XFS_GQUOTA_ENFD;
+		break;
+	case M_PQUOTA:
+		if (getnum(value, opts, subopt))
+			cli->sb_feat.qflags |= XFS_PQUOTA_ACCT | XFS_PQUOTA_ENFD;
+		break;
+	case M_UQNOENFORCE:
+		if (getnum(value, opts, subopt))
+			cli->sb_feat.qflags |= XFS_UQUOTA_ACCT;
+		break;
+	case M_GQNOENFORCE:
+		if (getnum(value, opts, subopt))
+			cli->sb_feat.qflags |= XFS_GQUOTA_ACCT;
+		break;
+	case M_PQNOENFORCE:
+		if (getnum(value, opts, subopt))
+			cli->sb_feat.qflags |= XFS_PQUOTA_ACCT;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2517,6 +2599,12 @@ _("metadata directory not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.metadir = false;
+
+		if (cli->sb_feat.qflags) {
+			fprintf(stderr,
+_("persistent quota flags not supported without CRC support\n"));
+			usage();
+		}
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -2562,6 +2650,26 @@ _("cowextsize not supported without reflink support\n"));
 		cli->sb_feat.exchrange = true;
 	}
 
+	if (cli->sb_feat.qflags && cli->xi->rt.name) {
+		fprintf(stderr,
+_("persistent quota flags not supported with realtime volumes\n"));
+				usage();
+	}
+
+	/*
+	 * Persistent quota flags requires metadir support because older
+	 * kernels (or current kernels with old filesystems) will reset qflags
+	 * in the absence of any quota mount options.
+	 */
+	if (cli->sb_feat.qflags && !cli->sb_feat.metadir) {
+		if (cli_opt_set(&mopts, M_METADIR)) {
+			fprintf(stderr,
+_("persistent quota flags not supported without metadir support\n"));
+			usage();
+		}
+		cli->sb_feat.metadir = true;
+	}
+
 	/*
 	 * Exchange-range will be needed for space reorganization on filesystems
 	 * with realtime rmap or realtime reflink enabled, and there is no good
@@ -3812,6 +3920,9 @@ sb_set_features(
 	if (fp->dirftype && !fp->crcs_enabled)
 		sbp->sb_features2 |= XFS_SB_VERSION2_FTYPE;
 
+	if (fp->qflags)
+		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
+
 	/* update whether extended features are in use */
 	if (sbp->sb_features2 != 0)
 		sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
@@ -4338,7 +4449,7 @@ finish_superblock_setup(
 			   (cfg->loginternal ? cfg->logblocks : 0);
 	sbp->sb_frextents = 0;	/* will do a free later */
 	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
-	sbp->sb_qflags = 0;
+	sbp->sb_qflags = cfg->sb_feat.qflags;
 	sbp->sb_unit = cfg->dsunit;
 	sbp->sb_width = cfg->dswidth;
 	mp->m_features |= libxfs_sb_version_to_features(sbp);

