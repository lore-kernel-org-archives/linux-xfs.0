Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E32BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/LHQBG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6ABC433C8;
	Sun, 31 Dec 2023 21:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057681;
	bh=QTL6aFdPgiAauDII8KHqSknp4QuqQbVlzFKVfzkf4MU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H/LHQBG/HLJWWTbUZeT05I610EFnQcnrskB+tJVuT0BmYRNOooTzcEudq3Kog/52C
	 0kUSv8DZSxjWaWsngNMPnKWlw70RBU+aMh4ZgJj9gj//RCT5ijl2OJV21MmUVqeO//
	 InhJfZ+BSIWVl6sMigFKvjjVexxhG93VAUgy5ZHJ8l8Ngtmcup4htbZjmzXXXg5e2I
	 n0ENgp1whNP0etkO9hrsZ87kQKhp++jfdhj5Ghnh98xF6q3iWLhNysBcbH8Sr7+ETW
	 /+glZPYeiCjv1uB6yPF5jgI7zJ7CZ7j0Yr521nk1scHQX0p0/yxKSW31OYLlzMyLu1
	 1CEsFR4rqg4eg==
Date: Sun, 31 Dec 2023 13:21:21 -0800
Subject: [PATCH 22/24] xfs: repair secondary realtime group superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846593.1763124.10346346517283580350.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Repair secondary realtime group superblocks.  They're not critical for
anything, but some consistency would be a good idea.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile               |    1 +
 fs/xfs/libxfs/xfs_rtgroup.c   |    2 +-
 fs/xfs/libxfs/xfs_rtgroup.h   |    3 +++
 fs/xfs/scrub/repair.h         |    3 +++
 fs/xfs/scrub/rgsuper_repair.c |   48 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c          |    2 +-
 6 files changed, 57 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7416ab9efc4d8..6dc9e740f8ce5 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -231,6 +231,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rgsuper_repair.o \
 				   rtbitmap_repair.o \
 				   rtsummary_repair.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index ed4f8aa67b158..7a45a16cbbab8 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -421,7 +421,7 @@ xfs_rtgroup_log_super(
 }
 
 /* Initialize a secondary realtime superblock. */
-static int
+int
 xfs_rtgroup_init_secondary_super(
 	struct xfs_mount	*mp,
 	xfs_rgnumber_t		rgno,
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index e6d60425faa4d..0a63f14b5aa0f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -221,6 +221,8 @@ void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
 		const struct xfs_buf *sb_bp);
 void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
 int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
+int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_buf **bpp);
 
 /* Lock the rt bitmap inode in exclusive mode */
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
@@ -241,6 +243,7 @@ int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
 # define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
+# define xfs_rtgroup_init_secondary_super(mp, rgno, bpp)	(-EOPNOTSUPP)
 # define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index a0780ccdd9ab6..3d8ca12b2cc51 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -139,9 +139,11 @@ int xrep_metapath(struct xfs_scrub *sc);
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
@@ -246,6 +248,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_symlink			xrep_notsupported
 #define xrep_dirtree			xrep_notsupported
 #define xrep_metapath			xrep_notsupported
+#define xrep_rgsuperblock		xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rgsuper_repair.c b/fs/xfs/scrub/rgsuper_repair.c
new file mode 100644
index 0000000000000..61961764a6cf9
--- /dev/null
+++ b/fs/xfs/scrub/rgsuper_repair.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_inode.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_rtgroup.h"
+#include "xfs_sb.h"
+#include "scrub/scrub.h"
+#include "scrub/repair.h"
+
+int
+xrep_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	/*
+	 * If this is the primary rtgroup superblock, log a superblock update
+	 * to force both to disk.
+	 */
+	if (sc->sr.rtg->rtg_rgno == 0) {
+		xfs_log_sb(sc->tp);
+		return 0;
+	}
+
+	/* Otherwise just write a new secondary to disk directly. */
+	error = xfs_rtgroup_init_secondary_super(sc->mp, sc->sr.rtg->rtg_rgno,
+			&bp);
+	if (error)
+		return error;
+
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index c1e226a9ac08d..c9acc10209ddb 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -463,7 +463,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rgsuperblock,
 		.scrub	= xchk_rgsuperblock,
 		.has	= xfs_has_rtgroups,
-		.repair = xrep_notsupported,
+		.repair = xrep_rgsuperblock,
 	},
 };
 

