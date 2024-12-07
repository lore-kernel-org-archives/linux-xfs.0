Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9024A1C
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530665; cv=none; b=Cs04KKjndXg5cGHliSC+NvZ4xRwj9pCTCF6BbkkQMWBs2ix3D41rCVmtUiy56vlHVYzzScKzM8SCfLnjWTzV3UAx94wQ/LdbSSthk4p8AhDVyYsXG+jLJRvg0QSi7WzJPeetYJDA+9llYvkbKC4dXj1ZxF9PcA697xbcU2rVTpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530665; c=relaxed/simple;
	bh=U3qyw4cZTfuqd15KXMbH8i2VmPReWmTYt2hZWJzl9MI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMujIVHIvCnPf9PqMpbMTAUiVN83N5acz6++ppC03Br5qwFE0ZiTugRclP6iZVGw37rB/ZcbVEp02E3ZTsKJRWz4aXqzhcTv6MyhkUuFYJwQ/weIysIpYoEXXCJ0KLEmvOP9S+92j/plOEuzl0kY3ZpkX6aBDquNX4mXu4FE5n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+xK9D2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+xK9D2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F10C4CED1;
	Sat,  7 Dec 2024 00:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530664;
	bh=U3qyw4cZTfuqd15KXMbH8i2VmPReWmTYt2hZWJzl9MI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t+xK9D2Rc1SbPzn2GnHmkshCwXloS+zxD1p4g53VJJJ1pAVHOe8qFNfE5CC6UO75Z
	 w/LCeHTd4PpVmYfu/FbbQdNRm7xA+9db+SCUEHKEnSOFF/6m0C+oe22OUvcnc+yqdP
	 OwhG0QYBNL5Km+fwG+3iFf3eLvLhVNVkkLYLD4N2xUy0o3pGtu51rmG1tAWE9Dtxph
	 m7d9R4R6T/cE23Ok0icqeTO+Il2wJbrQxTTFxpEm+e0hBzH/dVqCJ1csTrZyBGvRaF
	 HT89K2VcTb8qfYrk1irWQ8DlNnjqY+HQXK4ygwEEdnDAFntGqjGiwZsL7nn/GpWJxG
	 r3plQd1SPBe4Q==
Date: Fri, 06 Dec 2024 16:17:44 -0800
Subject: [PATCH 49/50] mkfs: add headers to realtime bitmap blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752694.126362.14739180271347119851.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

