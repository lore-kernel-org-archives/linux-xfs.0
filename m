Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A66ED268
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610531; cv=none; b=JwcIbhCf6y3DGXF6uzjPGpLpSNo37cxqAE1FW3o562zvsTChbweo9qnZ/DmG1FWRDncvd6bKzBufXeS/R6VHk3n1ws++fhgY14DdBmrikaAxy7Z0V67fqgk3U+Gk7+zy8YroKl1pNca5OqAapljWZCZ9BwGbN2jteF0CmW829K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610531; c=relaxed/simple;
	bh=Umt3FByZGX1+036b7pTl4RboouiIqnqf0s9WdzU0FoM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvS+ki5fU0Y84sLaOKOaQUYeMno8hOt03Uf4gkZ/0HoZv2AI3dNltQ2aoN4qNm+UM1Xm7xMMZN4fNzAOLnBARaM4VNOmNml4KqIyRrbEjVbS2aiJe1apNqeCiSehZ5ebYI7Gatov1p3VRHskzwJGcZqWq+l+U6+4x+EJxtF43YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExFQfGF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExFQfGF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A6BC4CEC5;
	Fri, 11 Oct 2024 01:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610530;
	bh=Umt3FByZGX1+036b7pTl4RboouiIqnqf0s9WdzU0FoM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ExFQfGF2NItizMY4ixWGasGATX2Cgjg2WBdKOMpgeBmsaO0dAqLX/9ghGY0++JEue
	 NoRbq53bYYCmybiYZOEfuGu4i9/HuW5E44Dhdar6un98HNUhaTUsKoUewyuyyHLkKG
	 wgwUlkz5htoCV6+JYNsNhXcDn9pH5RJO20s0Me4asX3tDQ5ihtkCNU61qh9vatdDV+
	 Glt/QQ8Qi9W3WPESoAaquFiaMW/3fhDH7lfopzk6ddmVbuVjJcVQWT72uHKYMifJ+s
	 hjXQ+m3VZbtvfAIyXh84efXXBjnC5QpnKjZQh0KRJ1DGcySNwOzxZ8g9oPERjd1DPf
	 93wEM5rnmAU+Q==
Date: Thu, 10 Oct 2024 18:35:30 -0700
Subject: [PATCH 42/43] mkfs: add headers to realtime bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656009.4184637.2027498857372423320.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

When the rtgroups feature is enabled, format rtbitmap blocks with the
appropriate block headers.  libxfs takes care of the actual writing for
us, so all we have to do is ensure that the bitmap is the correct size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 38a51b43f55993..4ea734a4d48f59 100644
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

