Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6C18C07
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881797; cv=none; b=hCTWDhEQK6eqWp/+8bbdGFugX8Rf6/e99VGazDNEIIRE/dS01iqkGXiCxLyWmGqG8kZXWfANkbRGBkSEEfgVwQC+p5YYKwPDuGgfVWV4d+rj4gXQD8QpCAghJRU7vVlnaNhjxsZG74J+STo6pIZfxfBZtOUz1vavOPWCSRTeDhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881797; c=relaxed/simple;
	bh=6hvurFtnDZ8ox500BcSYOHUSV/fHO38gddCVRw3z4NU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB0XBzwoxM5ms+OR8IYLQ369W0SY63QnFOs+7pwKkXEw/x1ej5gAbzV0p7GPOIlzBI8SQ2mePvajP5EJzLQXtb1Zcv8sMKLvbAzTGl4UxDF0W3ztoh46SJuhL5askXUYDAsiARBIIg9auJzxiMipWU1MmuXRLWnPL3WB4+/uWIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOiSEyW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOiSEyW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238A8C116B1;
	Tue,  2 Jul 2024 00:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881797;
	bh=6hvurFtnDZ8ox500BcSYOHUSV/fHO38gddCVRw3z4NU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KOiSEyW6+hKlWdChKLybD7QZEbsLlaxoNneNC8uNR5ZzfG46w6/LCwbgQd8g0ZRk6
	 kMMTshq658qttgK4KXr9knsuCVq5ZLjUUd8lNkOIFFE8XsK8iBzBeVwilcUibBIaRo
	 fHVKs1atk+9AZKfPUAbiYAOxmzJcU7nkKjcJUqIF8bnZSq0/d60obCQtEGLfsqMIHW
	 ab4URRVAn+yS6IS/5ef0v92/N/bw3whFR50yKli65nkNjF6sSl6z3iN69DCxCXDGSt
	 9ilFkxrX9rU2CtkdrDmxrTF1gOa7vyrqrxCWdgeOSZzxw1ux3ZIuR5et5pFrQMR06o
	 GI0hIix5qFC0g==
Date: Mon, 01 Jul 2024 17:56:36 -0700
Subject: [PATCH 12/12] mkfs: add a formatting option for exchange-range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116893.2006519.8574742517764976343.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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
index 8060d342c2a4..d5a0783ac5d6 100644
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
index 8b2bdd7a3471..92e8eba6ba8f 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index 40189310af2a..34e7662cd671 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index aeecc0355673..a36a5c2b7850 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index 0a40718b8f62..4204d5b8f235 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
index 452abdf82e62..9a90def8f489 100644
--- a/mkfs/lts_6.1.conf
+++ b/mkfs/lts_6.1.conf
@@ -12,3 +12,4 @@ rmapbt=0
 [inode]
 sparse=1
 nrext64=0
+exchange=0
diff --git a/mkfs/lts_6.6.conf b/mkfs/lts_6.6.conf
index 244f8eaf7645..3f7fb651937d 100644
--- a/mkfs/lts_6.6.conf
+++ b/mkfs/lts_6.6.conf
@@ -12,3 +12,4 @@ rmapbt=1
 [inode]
 sparse=1
 nrext64=1
+exchange=0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6d2469c3c81f..991ecbdd03ff 100644
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

