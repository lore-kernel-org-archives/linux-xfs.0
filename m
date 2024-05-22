Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570B770F7
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347786; cv=none; b=echKZ3CeS0qVmGGLc0x8J/yCRyOJg7MaajSm6X4YbDW1482IwJGkECUW70C8ACOFv2wVms6nyjr/mSroJ5SS/Oc97NDWrtSb02sHabiMgvSh/DDGcsuZQf5ujjntFr1PrVSOwM0YQi1o7+0e3JTOOFPT3IKRwZaS7esO9cP425M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347786; c=relaxed/simple;
	bh=m4YL2OtOkfEDTGYc5Jl6SwDW/gMiDA5Dd+abKhAOBrM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqvQMd1akf2rqFf1bHnc7nL8c2AKeJBlLdXVaUDWq6GKdeLkpiNddIMv6dii59dZZ53pZkfzC6sGye2mjo0Zb608RLG1Htgz1aZiSa9p4M6ft8AH1fL6Ckwnd1yHz9u3z+yPI4GmRrVS14cY3zgDSfO/GgsbYOVWH3hQOrFACz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ts6LTpVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ts6LTpVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD581C2BD11;
	Wed, 22 May 2024 03:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347785;
	bh=m4YL2OtOkfEDTGYc5Jl6SwDW/gMiDA5Dd+abKhAOBrM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ts6LTpVxQ/U8HoWtFYXLRgoVH6py3Pr0LnXTO/aknHKd6dSR66aBJ7ZEUXwMpQip7
	 +zCgv4m4CHBZ6NNlXkSvUfzEWXfdSSlii+HmRl8tbJVT4/h24cACaIVMmSwgMZkTfb
	 mUcLugRhHqZRthCqb+6sMNtIbg5WyYEcI0y3BcUbL85bv4dp7hn4DdkpPHULFr/JE5
	 lAld5cTMlss59V9h43Sy5qETMRqmhXXoRjeipf3WtOFXg/9/7ysANBo3G+Px/28iaP
	 MKQ/sTe7K500u0UikwUjYtO3iodDqvz9nTWcAQVwdNptIZF/YeJjJTVW3xL+kgS6re
	 GH8E72Ofl9MNw==
Date: Tue, 21 May 2024 20:16:25 -0700
Subject: [PATCH 106/111] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533294.2478931.1608722062738677560.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 622d88e2ad7960b83af38dabf6b848a22a5a1c1f

Move declarations for libxfs symlink functions into a separate header
file like we do for most everything else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h            |    1 +
 libxfs/xfs_bmap.c           |    1 +
 libxfs/xfs_inode_fork.c     |    1 +
 libxfs/xfs_shared.h         |   13 -------------
 libxfs/xfs_symlink_remote.c |    1 +
 libxfs/xfs_symlink_remote.h |   22 ++++++++++++++++++++++
 6 files changed, 26 insertions(+), 13 deletions(-)
 create mode 100644 libxfs/xfs_symlink_remote.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 563c40e57..79df8bc7c 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -86,6 +86,7 @@ struct iomap;
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_symlink_remote.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 70476c549..b089f53e0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -32,6 +32,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "defer_item.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 052748814..d9f0a21ac 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -24,6 +24,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 #include "xfs_health.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index cab49e711..dfd61fa83 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -182,19 +182,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
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
index fa90b1793..33689ba2e 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "xfs_symlink_remote.h"
 
 
 /*
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
new file mode 100644
index 000000000..c6f621a0e
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

