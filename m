Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D61370
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUzgS64o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC431C433C7;
	Mon,  1 Jan 2024 00:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069066;
	bh=vVgM03VssCr86SPVaQHsaWRhjFHEnponpgcionlKfA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jUzgS64oIMzQaO/iPS2d+RP9CT/yiOgaL4RdgcG1wg3Ywvf7BMawHy2w0s570n/eE
	 E++11qnP/D7gIeEmJGjhyjFqSMHp79edaaWZoHXMKvx4kgeUz3dhP4anCjCmGdfRBs
	 iP6r0L4h/Kkccyxqw2lLWg2ndA41P+MAOLafQFrxmp1PPqbq637R/WIpVoRJNKgO/0
	 0hbx5sxK2n0XPUuWrG1d3zLzuHyY3oLfZIpSvawgxAU44PMy0xfjR+Q5KEOUwv1qSf
	 KubkaK/Jxj78MmQzs73SRMs1jYJ05XamrvKskLlzm9NG7Pxl6YsCUOGtGf8YV4WQp/
	 qNPnKzQnOOFkA==
Date: Sun, 31 Dec 2023 16:31:06 +9900
Subject: [PATCH 19/42] xfs: enable extent size hints for CoW operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017380.1817107.18332451117594864832.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Wire up the copy-on-write extent size hint for realtime files, and
connect it to the rt allocator so that we avoid fragmentation on rt
filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c87ca1938ec..bc703b13b7e 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6401,7 +6401,13 @@ xfs_get_cowextsz_hint(
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		b = 0;
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
+			b = ip->i_extsize;
+	} else {
+		b = xfs_get_extsz_hint(ip);
+	}
 
 	a = max(a, b);
 	if (a == 0)

