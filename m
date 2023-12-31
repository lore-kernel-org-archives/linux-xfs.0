Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027CDC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZP30MPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C526AC433C7;
	Sun, 31 Dec 2023 22:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061576;
	bh=Rn5v4hyNUfcTEKle0V5AL0YcuF6daFPt46UFO58HEq4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JZP30MPFwSgs11+mcYTtWCXYFCUKIv9sAef7wLzgTr9Ar7jGXKTn/8GhcxGK+N2fq
	 P1kdO1Sk4N2GHc6kGpl5aqaQA2tBppiSbOaXYu/5W2iNtIntyVabWs7aFHo0fgZ2Wa
	 3jJmQ3ifc1zl3O/7C6mBQszUxP8MVaDSIgMjePACu8N1QBH5N9B6s6/bEEanOWt2Ym
	 23Tnn/sE1waQ0H/FMYtHiFGmQYgcIaRFZsVFlUB/nhw5YRhlHXlXTZgnka/AOrrX51
	 kIXjoBJfo9couldum3T68PuczbARktY7xi903l6nGYZRQ4oy1loi7huqUvUphzPn6A
	 U3cAgohTm+vcw==
Date: Sun, 31 Dec 2023 14:26:16 -0800
Subject: [PATCH 1/4] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995894.1795978.5913633219255532151.stgit@frogsfrogsfrogs>
In-Reply-To: <170404995879.1795978.16481180835947373560.stgit@frogsfrogsfrogs>
References: <170404995879.1795978.16481180835947373560.stgit@frogsfrogsfrogs>
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
 include/libxfs.h            |    1 +
 libxfs/xfs_bmap.c           |    1 +
 libxfs/xfs_inode_fork.c     |    1 +
 libxfs/xfs_shared.h         |   13 -------------
 libxfs/xfs_symlink_remote.c |    2 +-
 libxfs/xfs_symlink_remote.h |   22 ++++++++++++++++++++++
 6 files changed, 26 insertions(+), 14 deletions(-)
 create mode 100644 libxfs/xfs_symlink_remote.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 43fb5425796..16667b9d8b3 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -84,6 +84,7 @@ struct iomap;
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_symlink_remote.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d6cb466d63f..54db35bc398 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -32,6 +32,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "defer_item.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 5f45a1f1240..46da5edfb11 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -24,6 +24,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 518ea9456eb..7509c1406a3 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
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
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index cf894b5276a..a989ce2f3f2 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -13,7 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
-
+#include "xfs_symlink_remote.h"
 
 /*
  * Each contiguous block has a header, so it is not just a simple pathlen
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
new file mode 100644
index 00000000000..c6f621a0ec0
--- /dev/null
+++ b/libxfs/xfs_symlink_remote.h
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

