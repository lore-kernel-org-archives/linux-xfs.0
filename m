Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0F72E9730
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544893; cv=none; b=jogz8+degbJ4UI5JeDSFLlsSuXZ7P5SQK7AR+c6+IHLrfWnAKDZfAr2lrxOXssouu5pbaMxEyvOLzvXybxjA2NXCDxGwvHzOhSw/5/OxRrha98lR00Z6k8ybTUDf1LpoNY6ox1cmrJaOwhUG3XpbA07hATIvGT09wFdzkvwQEGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544893; c=relaxed/simple;
	bh=27WNPaIFot79YO790TsIzsCighmWQp4+xp3y1Th0e3E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Me1QSBR622Db0kcSx/TH52BlzCSy6Hls6mTxcQfI+x0jP3gqjw8Ze1R9zTfTv2oxV9GSpkTr7WoZZnldHQaGaGtMScBFID3HRD7vozKJ38oA/XQxsFt14C0shZFHwePeejsj1VpLm4MLzxXdIRTwLX8FzHgeuHAPPD22BsStW9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CC+tRvhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CC+tRvhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7DBC4CEF7;
	Thu, 19 Feb 2026 23:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544893;
	bh=27WNPaIFot79YO790TsIzsCighmWQp4+xp3y1Th0e3E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CC+tRvhGYpc2wjcP8OUxdc6q2rO23BHFR3NnkqjwLJIlk61bEefSRZYIsVf6sCGBR
	 2L7vJLm8FLSpeJ3+ntI+ni9E2nG9bT4tt86qCvSP+7021RvfHCCnlX075RVokpKOcC
	 RW7+MiZtjT9zleAu6W2gu4iWBznw26uvVd0+Fcf+r5hSdw7epiisOxThd4Cz50lSBp
	 qaIv65e/kNVtwrexu1Ewj3gd8qPItRNV0Itfr0UewHLI7jXCNkD3d1agChcPVzGLg7
	 rCFDV0nCisUQcl8S5uTE1omKiJx8naJzPD+jgR2P5uG/R8vShj5xmvez92cQRWmoS5
	 XlSqmXvey6hPw==
Date: Thu, 19 Feb 2026 15:48:12 -0800
Subject: [PATCH 6/6] xfs_scrub_all: fix non-service-mode arguments to
 xfs_scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177154457316.1286306.13827456114748263272.stgit@frogsfrogsfrogs>
In-Reply-To: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Back in commit 7da76e2745d6a7, we changed the default arguments to
xfs_scrub for the xfs_scrub@ service to derive the fix/preen/check mode
from the "autofsck" filesystem property instead of hardcoding "-p".
Unfortunately, I forgot to make the same update for xfs_scrub_all being
run from the CLI and directly invoking xfs_scrub.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1125314
Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 7da76e2745d6a7 ("xfs_scrub: use the autofsck fsproperty to select mode")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/Makefile            |    2 +-
 scrub/xfs_scrub_all.py.in |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 6375d77a291bcb..ff79a265762332 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -16,7 +16,7 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all.py
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
-XFS_SCRUB_ARGS = -p
+XFS_SCRUB_ARGS = -o autofsck
 XFS_SCRUB_SERVICE_ARGS = -b -o autofsck
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index ce251daea6a5d5..9f861639a43ce4 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -102,7 +102,8 @@ class scrub_subprocess(scrub_control):
 		cmd = ['@sbindir@/xfs_scrub']
 		if 'SERVICE_MODE' in os.environ:
 			cmd += '@scrub_service_args@'.split()
-		cmd += '@scrub_args@'.split()
+		else:
+			cmd += '@scrub_args@'.split()
 		if scrub_media:
 			cmd += '-x'
 		cmd += [mnt]

