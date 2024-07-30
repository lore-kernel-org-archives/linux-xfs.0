Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C927F5C96
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301014; cv=none; b=qv2sAf46VUBe3pur4fMLiYiTjKFxrpe2b+BwkgasMq9TxEcBZpeNBhubUPByB99YrblmfEoCTex9u+oD8+GK6DGP5G7YcRdW3/YKVTK3tDY10VofKh2+ibjzuqGHyHYDXoQh+DlQlF8bWFCK9uPPgxcCgbg4aIvJrvNVSGJ7ObE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301014; c=relaxed/simple;
	bh=Of1454qtQuYHTSlU44/55KG47QLEKGaaki08MoIUd7A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYUE42pxx7LXiuyogDDvbzB6LpQxxns2e5vxDizQb9iR5sjd/SKHFLItFaR6Y4hFT6rEupzlK76Kd/gc0wd2IsRJcsqcBnmfyh0nytJ4SqaR7iHRo2mLbs5ryjX14PfpaKQ+WzgTt2iYP295EEhLrzS7I6a92EYbN63rFBo/CtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBqaOV2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBqaOV2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A03C32786;
	Tue, 30 Jul 2024 00:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301014;
	bh=Of1454qtQuYHTSlU44/55KG47QLEKGaaki08MoIUd7A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kBqaOV2hXExW4uKdYkil1+nOv7D19+nP2OoD3PywMECfdfoj+QeJaOmqtzLAqejtl
	 GkXEci3Y0MdsFItB5Th/jry2hSRr4TklNDRIKjQFtk8e+Mt351ilcxtOyyqqTLgrjf
	 mO3W40aCnkuXDkFOe8nJOsArCwvIvqdLPaRTw7HoxKU932J1JRdroE+BKioTNNVubV
	 umvuiIKDizscn9Xa5gydv76G8FqFRNOCVZV7iVtdUkoBBzmhR4pNebOK7qPUDELH9r
	 7YsYRoc157pAX9oMXAMd8d7WWaOSvmNTWX5qXAbFwxZloPHQbJiXwrxYOtgXTGlk9+
	 gKfX3Fl4xUf6w==
Date: Mon, 29 Jul 2024 17:56:54 -0700
Subject: [PATCH 12/12] mkfs: add a formatting option for exchange-range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844560.1344699.13468796571019891277.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

Allow users to enable the logged file mapping exchange intent items on a
filesystem, which in turn enables XFS_IOC_EXCHANGE_RANGE and online
repair of metadata that lives in files, e.g. directories and xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/mkfs.xfs.8.in |    7 +++++++
 mkfs/lts_4.19.conf     |    1 +
 mkfs/lts_5.10.conf     |    1 +
 mkfs/lts_5.15.conf     |    1 +
 mkfs/lts_5.4.conf      |    1 +
 mkfs/lts_6.1.conf      |    1 +
 mkfs/lts_6.6.conf      |    1 +
 mkfs/xfs_mkfs.c        |   26 ++++++++++++++++++++++++--
 8 files changed, 37 insertions(+), 2 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 8060d342c..d5a0783ac 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -670,6 +670,13 @@ If the value is omitted, 1 is assumed.
 This feature will be enabled when possible.
 This feature is only available for filesystems formatted with -m crc=1.
 .TP
+.BI exchange[= value]
+When enabled, application programs can exchange file contents atomically
+via the XFS_IOC_EXCHANGE_RANGE ioctl.
+Online repair uses this functionality to rebuild extended attributes,
+directories, symbolic links, and realtime metadata files.
+This feature is disabled by default.
+This feature is only available for filesystems formatted with -m crc=1.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index 8b2bdd7a3..92e8eba6b 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index 40189310a..34e7662cd 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index aeecc0355..a36a5c2b7 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index 0a40718b8..4204d5b8f 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
index 452abdf82..9a90def8f 100644
--- a/mkfs/lts_6.1.conf
+++ b/mkfs/lts_6.1.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_6.6.conf b/mkfs/lts_6.6.conf
index 244f8eaf7..3f7fb6519 100644
--- a/mkfs/lts_6.6.conf
+++ b/mkfs/lts_6.6.conf
@@ -12,3 +12,4 @@ rmapbt=1
 [inode]
 sparse=1
 nrext64=1
+exchange=0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6d2469c3c..991ecbdd0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -90,6 +90,7 @@ enum {
 	I_PROJID32BIT,
 	I_SPINODES,
 	I_NREXT64,
+	I_EXCHANGE,
 	I_MAX_OPTS,
 };
 
@@ -469,6 +470,7 @@ static struct opt_params iopts = {
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
 		[I_NREXT64] = "nrext64",
+		[I_EXCHANGE] = "exchange",
 		[I_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -523,7 +525,13 @@ static struct opt_params iopts = {
 		  .minval = 0,
 		  .maxval = 1,
 		  .defaultval = 1,
-		}
+		},
+		{ .index = I_EXCHANGE,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -889,6 +897,7 @@ struct sb_feat_args {
 	bool	nodalign;
 	bool	nortalign;
 	bool	nrext64;
+	bool	exchrange;		/* XFS_SB_FEAT_INCOMPAT_EXCHRANGE */
 };
 
 struct cli_params {
@@ -1024,7 +1033,8 @@ usage( void )
 			    sectsize=num,concurrency=num]\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
-			    projid32bit=0|1,sparse=0|1,nrext64=0|1]\n\
+			    projid32bit=0|1,sparse=0|1,nrext64=0|1,\n\
+			    exchange=0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1,\n\
@@ -1722,6 +1732,9 @@ inode_opts_parser(
 	case I_NREXT64:
 		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
 		break;
+	case I_EXCHANGE:
+		cli->sb_feat.exchrange = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2365,6 +2378,13 @@ _("64 bit extent count not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.nrext64 = false;
+
+		if (cli->sb_feat.exchrange && cli_opt_set(&iopts, I_EXCHANGE)) {
+			fprintf(stderr,
+_("exchange-range not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.exchrange = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3498,6 +3518,8 @@ sb_set_features(
 
 	if (fp->nrext64)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+	if (fp->exchrange)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_EXCHRANGE;
 }
 
 /*

