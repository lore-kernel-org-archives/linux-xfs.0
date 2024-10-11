Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0E35228
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608877; cv=none; b=qQUt6DCkEESqTZelzyIbDLy5S9qbDcwF8Znmh/6dq1IzbWN5NwZIH3EvzZM0im0VejQkgE/m1vEflrUksGBT6uZhvxPcymruS/MDVXW2FkTRq+j/dSQSXHiM3YHD+EuVafWvs2h7H8YY7iQ1T3G1mOdtTtXIQjhLfkHE2WL2wYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608877; c=relaxed/simple;
	bh=+er4NIXSYSi/rVydpo/FsEmkcVwKv0dPnkk4mTY3biI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UUjLwtNNqLPIxH3AiuXuR4k6LYtha636OLHW8gtV5mPzBQOYbwY0KIqnNux1IVMTPV4zTiFI4gm22cyxY1Mth+1HxUcSs6SlkzOzZGx/VzCbsOG9xsonzHSZ25Swy1vbhzuMj8tnfcu9BMDJqLu3JDQiW2wTpoQNByqj/N+JotM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QH9/5kF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QH9/5kF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9CEC4CEC5;
	Fri, 11 Oct 2024 01:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608876;
	bh=+er4NIXSYSi/rVydpo/FsEmkcVwKv0dPnkk4mTY3biI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QH9/5kF3eJAwEFpqHvpf2oN6YDumLpyWLKPzrSDK8mqz9p/8IwxJxJ4GJVS8P34ZW
	 B1UrDKoq27N07AqJ8cuCBBPdWIKE+5MkqwsB5gLT24mCsW1bU5conjvMaPejlt6Ke9
	 AJ+YGxrwWzwPzzwxJl8zodbx+0mhUEw+1tfRSpjXhmItxQ5Wq/fJp9LwgCn7egxaGb
	 StLGf74OGmAL5KVR29yqzhtpBvaNfbB7KWmQv5JBGaRlBGS7aytpOKfb1ZdpXOWPCS
	 rpu2CehdOcN9qUBmumTS65yMUoW+ZzdOXSm/S4KkUtFxvR6meLOC3WdOdbeYGEZxcR
	 7c6WC4vJrvV9Q==
Date: Thu, 10 Oct 2024 18:07:55 -0700
Subject: [PATCH 24/36] xfs: repair realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644656.4178701.1391767121510145567.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
index fc8476c522746e..c255882fc5e40b 100644
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
 

