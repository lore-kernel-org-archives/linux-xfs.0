Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5BD13AF2
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372846; cv=none; b=O0k9iH5DYhRCfIAOaMXSzKiI+79qqxO5SPysfKubyGvIwEbgRyr5EHmJgknEIGQBsud9NrZFlMjY86QQMNZL4fnD64eTBPgXC6a9r6J3f+14o0wrI5qKK25hhG7llwbOuaU0Ar1DJGNOKQ+fWGwbRTOWnqdyRHokQ+0x/yymtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372846; c=relaxed/simple;
	bh=ohefvzWQKaKtRHiiUxXOfcGIGGdlwA/u+iIdzHcyyTM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qigGtU3aaf7sY9K4zxiY9ok9YQ8o5krHLHeo3LlSnPitIu2n8C4L/rWUO5IjKANEvoRXY3TTlmayRmvIZu8AKQYJuCHYoIC986vJq0bjaud+h7SJUtFseQC8yGGjVV1Y7+Fhke38rpyjvv++3GbXw0wT4ze1NLFWSkg5M4hg7Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBQcocti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBQcocti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2051BC32782;
	Fri, 23 Aug 2024 00:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372846;
	bh=ohefvzWQKaKtRHiiUxXOfcGIGGdlwA/u+iIdzHcyyTM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vBQcoctijLcvWd7ta63+9OqBPmKg0h1XHwHcA2p582D+bseemfvoYfLC5aCYuu+Vc
	 E1rvK4JaunF/3ePHegRCFyVLg04TRocdneXmTVPgPBh2phzKy8h8RJ+Decit2nInfi
	 +dAEce3N7G2FBT86nuUyMa8R44ZTRYcexsRlaRuwoTRVk+6GIKhB1oLG73BR7cmUMr
	 iooJmAGZsQI8KYgk1Nnc5xJ9GJ0bl5u+iUQ9mq3QNFGqyqTp4DrrvufxMbZnov2NVv
	 w9mqDWdOh1wZeNZtd0Vv5coxbLJVscC2T8Kk4ahaF4wrVDsihTNVao9g7+YBaRdnn2
	 HBF6Y+BjTtxBg==
Date: Thu, 22 Aug 2024 17:27:25 -0700
Subject: [PATCH 24/26] xfs: repair realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088939.60592.12149395691309789384.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Repair the realtime superblock if it has become out of date with the
primary superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.h  |    3 +++
 fs/xfs/scrub/rgsuper.c |   16 ++++++++++++++++
 fs/xfs/scrub/scrub.c   |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4052185743910..b649da1a93eb8 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -146,9 +146,11 @@ int xrep_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
 int xrep_rtsummary(struct xfs_scrub *sc);
+int xrep_rgsuperblock(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
 # define xrep_rtsummary			xrep_notsupported
+# define xrep_rgsuperblock		xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -253,6 +255,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_symlink			xrep_notsupported
 #define xrep_dirtree			xrep_notsupported
 #define xrep_metapath			xrep_notsupported
+#define xrep_rgsuperblock		xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index bfba31a03adbc..ad54a58cd9848 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -10,8 +10,12 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_rtgroup.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/repair.h"
 
 /* Set us up with a transaction and an empty context. */
 int
@@ -71,3 +75,15 @@ xchk_rgsuperblock(
 	xchk_rgsuperblock_xref(sc);
 	return 0;
 }
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int
+xrep_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	ASSERT(sc->sr.rtg->rtg_rgno == 0);
+
+	xfs_log_sb(sc->tp);
+	return 0;
+}
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index fc8476c522746..c255882fc5e40 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -456,7 +456,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rgsuperblock,
 		.scrub	= xchk_rgsuperblock,
 		.has	= xfs_has_rtsb,
-		.repair = xrep_notsupported,
+		.repair = xrep_rgsuperblock,
 	},
 };
 

