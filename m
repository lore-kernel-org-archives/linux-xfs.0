Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F021BB06
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192085; cv=none; b=qndf54lktjXoKYxojf7jRBzA1CGVCUXJqrp4xzugCnj47U0mrbgD4DKeE44InwUfNPQcbcU51SLSgC5PTAllxllwe1N6/m0+GXefya8T9M7rk8j65pHHm0t7AdB4tvaJGyRu+7NcuEqf8zACxF+axTK7X+v9z5P+IZLhJlw2Cm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192085; c=relaxed/simple;
	bh=lRfe52tyMyBnmokqal2CmqJt6IEB3cyIqrb5SMrW8CU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QLXZxJYfzHZJoBhQm23tOnCP9QzY4OddjyBE10zZ6tX1Fza8oDpg+zjimqD/X0eCVmB78KPwDX66vdjQDEub0UdfYuynusFR/OvtICBOlqWqlcSxoFq5tm0YbRwmJdWaMwrlzOiTlcVy6LhU9Ntot6BFdMVg4DRdMwUqCV+McVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJQjLDrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJQjLDrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298D8C4CEC3;
	Thu, 17 Oct 2024 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192085;
	bh=lRfe52tyMyBnmokqal2CmqJt6IEB3cyIqrb5SMrW8CU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lJQjLDrJISHVqIU9CO4PeBU2R0pjIy88lEblHYvb4pj552YqiXfEO+fXEpczh1Nkb
	 zC3x/1kViK9HNG8ePIkSJEcgo0TDGYMC9QwgORFDLHxwe1H6Iv5YPGuHbz4G8aLvbs
	 mDNyTMV1dDAICze3uEj+W08+by1ygsLQWc6gz0S4ddYxQ6fxxEZ1/i2ldImBRWzckV
	 rAZj9CYmMaMGYihzI6TUfIKmeGW+xXqoFD1oHPdLhMfIaki8Hhh0MzQdxbhcNBktyr
	 uaoBF9V1QLwL1hX6jpQ4UE3RVrVpHLoarpHEFfaJT9vCfJkif/hMgKyjXKDoUAXQzX
	 GdMkE8alKKgEw==
Date: Thu, 17 Oct 2024 12:08:04 -0700
Subject: [PATCH 24/34] xfs: repair realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072083.3453179.10995550419166957274.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.h  |    3 +++
 fs/xfs/scrub/rgsuper.c |   16 ++++++++++++++++
 fs/xfs/scrub/scrub.c   |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4052185743910d..b649da1a93eb8c 100644
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
index 00dfe043dfea7f..463b3573bb761b 100644
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
@@ -66,3 +70,15 @@ xchk_rgsuperblock(
 	xchk_rgsuperblock_xref(sc);
 	return 0;
 }
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int
+xrep_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	ASSERT(rtg_rgno(sc->sr.rtg) == 0);
+
+	xfs_log_sb(sc->tp);
+	return 0;
+}
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ceb22c722d8f52..950f5a58dcd967 100644
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
 

