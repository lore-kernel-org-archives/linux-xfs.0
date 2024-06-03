Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D42D60A
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442382; cv=none; b=MQLstp6cwnAmYDztD3l6rjX4IChL1aomAVgTHbzu29SaGyABcRPo3z2vI8ycvaVUSiGVmI6WQMAFIW/5J5KyLxcj7P+urpDQXblD7lxLGJ3ai+Bh5W9BqUtNjqrU3m3eIOMYTBu5CWNQty1OzR5MNj5NeV/uRK92h5DjO1zgDWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442382; c=relaxed/simple;
	bh=+x+Zc91ZGIQu+n96pT0lml1sawTBKrwCwqcC4Sd7Scg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MFXzSIRACINJl5yD4EQRXWfll7xCUA6yPxZYaZSJIN1MtYkZr8BU6RI8OetZK4A1oaDrZUPj1A178InIl84iezgnzTpRoyjoPlNO03U+Csqk/VS2Q0IgFth3xHPBoDkwo7OmwWNdveVPdn6muDaMKwXaYQbqUKiYDM3BVzo48Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JY72Up0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JY72Up0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B6C2BD10;
	Mon,  3 Jun 2024 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442381;
	bh=+x+Zc91ZGIQu+n96pT0lml1sawTBKrwCwqcC4Sd7Scg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JY72Up0Yk1IL0XDq2QIG49zryEha19MoA44fSzMVyZP7dTqAdjzsZkSJ3OOL7NDwK
	 AAayH6wYAkZ9QspkTigGTeq2MhRVJ0LdOa6/CpvQKMy+o/3WRmvdig5wOhupF0X58z
	 ElhtERYt+drxjwa+ruIv5BmVxJK3YYkysIGOA2HNiEUEcxItczVij3bBiJTXH1pSzv
	 7bSxeUckr00aR+7P3ptejGrEaTltFSwnrRR+9S/erlgUEZNxOv+40xJI2t+Zlr9Z6R
	 HLk7FT5fnJi+DiAsEFP77VOJ/DbbN4yh28s/tGyydNKrCu4DzNaPFWfeDTFcA/UWQv
	 6IsFyj83Eq3RQ==
Date: Mon, 03 Jun 2024 12:19:41 -0700
Subject: [PATCH 106/111] xfs: move xfs_symlink_remote.c declarations to
 xfs_symlink_remote.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040957.1443973.713683817721466523.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

