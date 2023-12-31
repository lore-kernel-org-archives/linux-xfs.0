Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196ECBA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cY8J24D6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9F4C433C7;
	Sun, 31 Dec 2023 20:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054223;
	bh=o3sYpKwvSL/fJPw+CNdb8o5IhwVOOFw4GaPLfnwTc0A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cY8J24D6/dPeyHFpz3Y8oCPJgIO/sf2CK3KPcs5g+r6EiH7J1n6RMLtlDNWnnEnQQ
	 ywHtT8MoIYC1/Tb1IfXuhCoLqbGuHwAZ+vhjpGralxI5G7pj6bWax9xO+MVteGo6s+
	 ZOqJZFyWKnTZkFP9C2Ah15fTYGOabwxvDJpBxGuccRcKTbIFRGH5Wj4M5m+PerFMGi
	 8zRLb9/vpOT8laxkEizjuzeJJrr4qyg7iFrEi1aJiaXM0T4mr40JffBxPOqlt4vqXx
	 9Rp5hasDsVujKbxBTQYyE3GaTp5q1mZFxBxlo4XxJuQg4g8ttX66s8O5A/j4TSSiL/
	 vT5Cq9TocQCKg==
Date: Sun, 31 Dec 2023 12:23:43 -0800
Subject: [PATCH 1/3] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404832663.1750161.5605007924957293446.stgit@frogsfrogsfrogs>
In-Reply-To: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
References: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
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

Move declarations for libxfs symlink functions into a separate header
file like we do for most everything else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c           |    1 +
 fs/xfs/libxfs/xfs_inode_fork.c     |    1 +
 fs/xfs/libxfs/xfs_shared.h         |   13 -------------
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 +-
 fs/xfs/libxfs/xfs_symlink_remote.h |   22 ++++++++++++++++++++++
 fs/xfs/scrub/inode_repair.c        |    1 +
 fs/xfs/scrub/symlink.c             |    1 +
 fs/xfs/xfs_symlink.c               |    1 +
 8 files changed, 28 insertions(+), 14 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_symlink_remote.h


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 03a67a4acd668..17f607b3b8cdf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -38,6 +38,7 @@
 #include "xfs_iomap.h"
 #include "xfs_health.h"
 #include "xfs_bmap_item.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index bce36df4402a3..7e571fcfe9d1a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,6 +26,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 518ea9456ebae..7509c1406a355 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -137,19 +137,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
 
-
-/*
- * Symlink decoding/encoding functions
- */
-int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
-int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
-			uint32_t size, struct xfs_buf *bp);
-void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
-xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
-
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
 	/* Maximum inode count in this filesystem. */
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 3c96d1d617fb0..a809a784d1741 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -16,7 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
-
+#include "xfs_symlink_remote.h"
 
 /*
  * Each contiguous block has a header, so it is not just a simple pathlen
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
new file mode 100644
index 0000000000000..c6f621a0ec053
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_SYMLINK_REMOTE_H
+#define __XFS_SYMLINK_REMOTE_H
+
+/*
+ * Symlink decoding/encoding functions
+ */
+int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
+int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
+			uint32_t size, struct xfs_buf *bp);
+void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
+				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
+
+#endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 20cecf3c69342..549b66ef826a9 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -37,6 +37,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 60643d791d4a2..06f8fe117cb4c 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -13,6 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_symlink.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/health.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b7f251fc2951c..ca1daf8245fa6 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -24,6 +24,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 /* ----- Kernel only functions below ----- */
 int

