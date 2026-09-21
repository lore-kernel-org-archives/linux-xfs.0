Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79742360EE5
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971253; cv=none; b=BaV8ySJncAUtyD/CyyerM9GGShMWcrAYu5Fey9rI00Wsg8WdVgfnXow/3xSOA/Rx7KKNVPql6W0B1osUoab0JmscgeFUzIk6YSnoTlDr1qw/qGR/XCFOmLi76wjI8n3PlpcpsyZWYKF2SgAAq0Guj+mKv7w1aa/2zNvYHHKqQhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971253; c=relaxed/simple;
	bh=0krcfnxPW0ZpJ0LQK2yxVae4uqr6WL90WZHLq+HFPlw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3/JcfWDeX+ZS1snC+QFq6+rL50lGqKJjl3wlqA17D8k1M+eUFo52HXA5pDL2AaoL1Pihp0zBPrKMz06TRr4b1du6nzWrpRbFOprcDTmONL8OXpXtHZ+liyyLwRCtJug6z9Cr4yABaOlPxmO/p2PDS0ozCfBcQs/fftRlEz6LlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEF+GV8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEF+GV8/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 388D21F000FF;
	Mon, 21 Sep 2026 06:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971252;
	bh=dM/nEDFQvWmuxkRtiwWKI5qdoEJg2ArLEEIG1w4/xlc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AEF+GV8/3JSizzc4zPwRRc/phkwGtDRUPCnU/YUS7AODgwl7JunfsmZTn0U6VJehg
	 M23WPSaZjpHnKNMHy2sFEaPgnH9SBO5lwiiRsWg2ELx3FL2sdZxtdhuF2dXERZpTQX
	 zpnAAdeD4K0BZCKrHTaft3vUfeWdbD6U0lnvG7Q/UH8spxw8nycLNSw3XZpSrzWuzw
	 4hSDdY2IS5L8ax3ziIzBb+TFoXccALuUPDcHIygDuOlNtzGT+NRRUvHIUG6t7ayf3f
	 vUjzP6ah8oRldnBI8iOaVLZ+YyyuvkV8aVMxo3YaI4S2zfcTRWhEvTPH6R/prgilsO
	 zdf7RS9MRn1fg==
Date: Sun, 20 Sep 2026 23:14:11 -0700
Subject: [PATCH 2/3] mkfs: allow disabling quota flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996057675.169604.16144457816697173954.stgit@frogsfrogsfrogs>
In-Reply-To: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
References: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that with the new defaults= option, it's possible for the
mkfs input validation code to allow the defaults file to turn on quotas
and a cli option to turn off quotas.  However, the qflags modification
code doesn't clear flags correctly because previously it didn't have to;
qflags is zero by default, so uquota=0 wouldn't change anything.

Fix this by introducing a little more logic to clear a mask of quota
flags and (if the value is 1) OR'ing a flag back in.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 525f826429a868 ("mkfs: add quota flags when setting up filesystem")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 mkfs/xfs_mkfs.c |   42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 334367b81555ec..aa87951db0d041 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2055,6 +2055,21 @@ log_opts_parser(
 	return 0;
 }
 
+static void
+toggle_qflag(
+	struct opt_params	*opts,
+	int			subopt,
+	const char		*value,
+	struct cli_params	*cli,
+	uint16_t		flag,
+	uint16_t		mask)
+{
+	cli->sb_feat.qflags &= ~mask;
+
+	if (getnum(value, opts, subopt))
+		cli->sb_feat.qflags |= flag;
+}
+
 static int
 meta_opts_parser(
 	struct opt_params	*opts,
@@ -2107,28 +2122,31 @@ meta_opts_parser(
 		cli->sb_feat.metadir = getnum(value, opts, subopt);
 		break;
 	case M_UQUOTA:
-		if (getnum(value, opts, subopt))
-			cli->sb_feat.qflags |= XFS_UQUOTA_ACCT | XFS_UQUOTA_ENFD;
+		toggle_qflag(opts, subopt, value, cli,
+				XFS_UQUOTA_ACCT | XFS_UQUOTA_ENFD,
+				XFS_UQUOTA_ACCT | XFS_UQUOTA_ENFD);
 		break;
 	case M_GQUOTA:
-		if (getnum(value, opts, subopt))
-			cli->sb_feat.qflags |= XFS_GQUOTA_ACCT | XFS_GQUOTA_ENFD;
+		toggle_qflag(opts, subopt, value, cli,
+				XFS_GQUOTA_ACCT | XFS_GQUOTA_ENFD,
+				XFS_GQUOTA_ACCT | XFS_GQUOTA_ENFD);
 		break;
 	case M_PQUOTA:
-		if (getnum(value, opts, subopt))
-			cli->sb_feat.qflags |= XFS_PQUOTA_ACCT | XFS_PQUOTA_ENFD;
+		toggle_qflag(opts, subopt, value, cli,
+				XFS_PQUOTA_ACCT | XFS_PQUOTA_ENFD,
+				XFS_PQUOTA_ACCT | XFS_PQUOTA_ENFD);
 		break;
 	case M_UQNOENFORCE:
-		if (getnum(value, opts, subopt))
-			cli->sb_feat.qflags |= XFS_UQUOTA_ACCT;
+		toggle_qflag(opts, subopt, value, cli, XFS_UQUOTA_ACCT,
+				XFS_UQUOTA_ACCT | XFS_UQUOTA_ENFD);
 		break;
 	case M_GQNOENFORCE:
-		if (getnum(value, opts, subopt))
-			cli->sb_feat.qflags |= XFS_GQUOTA_ACCT;
+		toggle_qflag(opts, subopt, value, cli, XFS_GQUOTA_ACCT,
+				XFS_GQUOTA_ACCT | XFS_GQUOTA_ENFD);
 		break;
 	case M_PQNOENFORCE:
-		if (getnum(value, opts, subopt))
-			cli->sb_feat.qflags |= XFS_PQUOTA_ACCT;
+		toggle_qflag(opts, subopt, value, cli, XFS_PQUOTA_ACCT,
+				XFS_PQUOTA_ACCT | XFS_PQUOTA_ENFD);
 		break;
 	default:
 		return -EINVAL;

