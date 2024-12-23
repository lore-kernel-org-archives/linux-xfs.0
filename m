Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2923433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992689; cv=none; b=dghdCsBZG1JYVe7A0JDpKSxXkQk5T37mzecVwwQpEHSwmn73pFZq6ZBPbCnIyC80ds6KUN97eiLZ/GZ8Dl/nvKYIE5rK2Xgx9cf8AIJt24qwPaeddIu/2l+X8Ma9A0YBiPn/APucOudI48QUBZ65VpPkvOPYv/neSOap3vq7FUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992689; c=relaxed/simple;
	bh=/nZCbVlq4DDAzuMTWDYGQkFGG85BrqptAzs+zhHKHAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMSdDjgS9gnaUX/4eNm1cwso5aX+qegiUYOQNQrgrjaYUIDSccchkoMHwjj2VNf008Kbt3prYrKKh8L6DgkWZbc97obLYu0l/rXbuPgQDIkkzwQyN9XrGP/6WUcalyAyzW33a7HU0jDGh8AtL0/0zeNfdyDnMnuqcVq3/OR0gGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xe3feRux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xe3feRux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAC1C4CED3;
	Mon, 23 Dec 2024 22:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992688;
	bh=/nZCbVlq4DDAzuMTWDYGQkFGG85BrqptAzs+zhHKHAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xe3feRuxGDf+BabVe+7CC9uBcFNi0YPJASTQMXNvbopLLHeKbXg2FaIwEfXVPK2WR
	 a6UHcCNvC5AtE0JWIKS0ViZcUw0HhvJZa0TrCk/orog6Op/e+Kz8mv2cNaTYfMupAl
	 wW7RpT6xo5zlrK55q9Be6POcB8JCNiNaZfkeEsLBAXGz9Pp41l8I6Z4NXV1BwBcqvd
	 t4s9AJpTJSxjo+1tUnYtucslkj3VzLRAFtl5xcmj+prsqZJIUQga4sayXwGbQYMRuU
	 sCCv3YReTzB8/7ohEuOG0jtWZieO08PWuRHAz7mkmvhvx2dlaNWTgMSzDDajWehaPJ
	 P8yqtNsakFfmQ==
Date: Mon, 23 Dec 2024 14:24:48 -0800
Subject: [PATCH 50/51] mkfs: add headers to realtime bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944569.2297565.14022702152240476260.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When the rtgroups feature is enabled, format rtbitmap blocks with the
appropriate block headers.  libxfs takes care of the actual writing for
us, so all we have to do is ensure that the bitmap is the correct size.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2549a636568d1b..5b9fd0e92f7aba 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3210,6 +3210,7 @@ validate_rtdev(
 	struct cli_params	*cli)
 {
 	struct libxfs_init	*xi = cli->xi;
+	unsigned int		rbmblocksize = cfg->blocksize;
 
 	if (!xi->rt.dev) {
 		if (cli->rtsize) {
@@ -3253,8 +3254,10 @@ reported by the device (%u).\n"),
 _("cannot have an rt subvolume with zero extents\n"));
 		usage();
 	}
+	if (cfg->sb_feat.metadir)
+		rbmblocksize -= sizeof(struct xfs_rtbuf_blkinfo);
 	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
-						NBBY * cfg->blocksize);
+						NBBY * rbmblocksize);
 }
 
 static bool

