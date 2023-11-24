Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BC73C49E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGds9D2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DA1C433C8;
	Fri, 24 Nov 2023 23:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870147;
	bh=bNi+a4MeN0sLcR735jDl6kbrOOu3FBLhBEfd5+H9EjQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RGds9D2ERogvAWDsJ0G3IoOs4njumsrre0gz8OnUf9Ya+ZShVnbA1TFeobFdunTqC
	 9UCpLjARYs7uNOA7aaz5r1yr4r5OTcrFU5FP/hrjGopYtgGzzo/+GEfuRAFkO3GVex
	 jEI9jv2f9wrt3Wvs70Uirwd8f4yJVTdfKi5BjG0ZBcDnzCO06OeVeVKjx0QMy2NGW0
	 IgnrzoC2roY2iMNKJjkIdH30KH3TbB2jw0Z5GHN9W0Ud/VhvcOGQZzRK9bhumUJX1I
	 r8r69Z1KrPx/Lqwwhg3XV74yrb8tp9lQENKHbXfAD8SYk6SMc1EXRmHT25bW2MBVvt
	 5z85loTkjzo3w==
Date: Fri, 24 Nov 2023 15:55:46 -0800
Subject: [PATCH 6/6] xfs: online repair of realtime bitmaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928439.2771542.8593836559546727999.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
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

Fix all the file metadata surrounding the realtime bitmap file, which
includes the rt geometry, file size, forks, and space mappings.  The
bitmap contents themselves cannot be fixed without rt rmap, so that will
come later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                |    4 +
 fs/xfs/scrub/repair.h          |    7 +
 fs/xfs/scrub/rtbitmap.c        |   16 ++-
 fs/xfs/scrub/rtbitmap.h        |   22 ++++
 fs/xfs/scrub/rtbitmap_repair.c |  202 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c           |    2 
 6 files changed, 245 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/rtbitmap.h
 create mode 100644 fs/xfs/scrub/rtbitmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 71a76f8ac5e47..36e7bc7d147e2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -191,5 +191,9 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount_repair.o \
 				   repair.o \
 				   )
+
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rtbitmap_repair.o \
+				   )
 endif
 endif
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index b7ddd35e753eb..f54dff9268bcc 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -115,6 +115,12 @@ int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
 
+#ifdef CONFIG_XFS_RT
+int xrep_rtbitmap(struct xfs_scrub *sc);
+#else
+# define xrep_rtbitmap			xrep_notsupported
+#endif /* CONFIG_XFS_RT */
+
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
 
@@ -177,6 +183,7 @@ xrep_setup_nothing(
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_bmap_cow			xrep_notsupported
+#define xrep_rtbitmap			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 3b5b62fbf4e0a..92058eb545344 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -17,12 +17,8 @@
 #include "xfs_bit.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
-
-struct xchk_rtbitmap {
-	uint64_t		rextents;
-	uint64_t		rbmblocks;
-	unsigned int		rextslog;
-};
+#include "scrub/repair.h"
+#include "scrub/rtbitmap.h"
 
 /* Set us up with the realtime metadata locked. */
 int
@@ -38,7 +34,13 @@ xchk_setup_rtbitmap(
 		return -ENOMEM;
 	sc->buf = rtb;
 
-	error = xchk_trans_alloc(sc, 0);
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rtbitmap(sc, rtb);
+		if (error)
+			return error;
+	}
+
+	error = xchk_trans_alloc(sc, rtb->resblks);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtbitmap.h b/fs/xfs/scrub/rtbitmap.h
new file mode 100644
index 0000000000000..85304ff019e1d
--- /dev/null
+++ b/fs/xfs/scrub/rtbitmap.h
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RTBITMAP_H__
+#define __XFS_SCRUB_RTBITMAP_H__
+
+struct xchk_rtbitmap {
+	uint64_t		rextents;
+	uint64_t		rbmblocks;
+	unsigned int		rextslog;
+	unsigned int		resblks;
+};
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int xrep_setup_rtbitmap(struct xfs_scrub *sc, struct xchk_rtbitmap *rtb);
+#else
+# define xrep_setup_rtbitmap(sc, rtb)	(0)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
new file mode 100644
index 0000000000000..46f5d5f605c91
--- /dev/null
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/xfile.h"
+#include "scrub/rtbitmap.h"
+
+/* Set up to repair the realtime bitmap file metadata. */
+int
+xrep_setup_rtbitmap(
+	struct xfs_scrub	*sc,
+	struct xchk_rtbitmap	*rtb)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	blocks = 0;
+
+	/*
+	 * Reserve enough blocks to write out a completely new bmbt for a
+	 * maximally fragmented bitmap file.  We do not hold the rtbitmap
+	 * ILOCK yet, so this is entirely speculative.
+	 */
+	blocks = xfs_bmbt_calc_size(mp, mp->m_sb.sb_rbmblocks);
+	if (blocks > UINT_MAX)
+		return -EOPNOTSUPP;
+
+	rtb->resblks += blocks;
+	return 0;
+}
+
+/*
+ * Make sure that the given range of the data fork of the realtime file is
+ * mapped to written blocks.  The caller must ensure that the inode is joined
+ * to the transaction.
+ */
+STATIC int
+xrep_rtbitmap_data_mappings(
+	struct xfs_scrub	*sc,
+	xfs_filblks_t		len)
+{
+	struct xfs_bmbt_irec	map;
+	xfs_fileoff_t		off = 0;
+	int			error;
+
+	ASSERT(sc->ip != NULL);
+
+	while (off < len) {
+		int		nmaps = 1;
+
+		/*
+		 * If we have a real extent mapping this block then we're
+		 * in ok shape.
+		 */
+		error = xfs_bmapi_read(sc->ip, off, len - off, &map, &nmaps,
+				XFS_DATA_FORK);
+		if (error)
+			return error;
+		if (nmaps == 0) {
+			ASSERT(nmaps != 0);
+			return -EFSCORRUPTED;
+		}
+
+		/*
+		 * Written extents are ok.  Holes are not filled because we
+		 * do not know the freespace information.
+		 */
+		if (xfs_bmap_is_written_extent(&map) ||
+		    map.br_startblock == HOLESTARTBLOCK) {
+			off = map.br_startoff + map.br_blockcount;
+			continue;
+		}
+
+		/*
+		 * If we find a delalloc reservation then something is very
+		 * very wrong.  Bail out.
+		 */
+		if (map.br_startblock == DELAYSTARTBLOCK)
+			return -EFSCORRUPTED;
+
+		/* Make sure we're really converting an unwritten extent. */
+		if (map.br_state != XFS_EXT_UNWRITTEN) {
+			ASSERT(map.br_state == XFS_EXT_UNWRITTEN);
+			return -EFSCORRUPTED;
+		}
+
+		/* Make sure this block has a real zeroed extent mapped. */
+		nmaps = 1;
+		error = xfs_bmapi_write(sc->tp, sc->ip, map.br_startoff,
+				map.br_blockcount,
+				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
+				0, &map, &nmaps);
+		if (error)
+			return error;
+		if (nmaps != 1)
+			return -EFSCORRUPTED;
+
+		/* Commit new extent and all deferred work. */
+		error = xrep_defer_finish(sc);
+		if (error)
+			return error;
+
+		off = map.br_startoff + map.br_blockcount;
+	}
+
+	return 0;
+}
+
+/* Fix broken rt volume geometry. */
+STATIC int
+xrep_rtbitmap_geometry(
+	struct xfs_scrub	*sc,
+	struct xchk_rtbitmap	*rtb)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_trans	*tp = sc->tp;
+
+	/* Superblock fields */
+	if (mp->m_sb.sb_rextents != rtb->rextents)
+		xfs_trans_mod_sb(sc->tp, XFS_TRANS_SB_REXTENTS,
+				rtb->rextents - mp->m_sb.sb_rextents);
+
+	if (mp->m_sb.sb_rbmblocks != rtb->rbmblocks)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBMBLOCKS,
+				rtb->rbmblocks - mp->m_sb.sb_rbmblocks);
+
+	if (mp->m_sb.sb_rextslog != rtb->rextslog)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSLOG,
+				rtb->rextslog - mp->m_sb.sb_rextslog);
+
+	/* Fix broken isize */
+	sc->ip->i_disk_size = roundup_64(sc->ip->i_disk_size,
+					 mp->m_sb.sb_blocksize);
+
+	if (sc->ip->i_disk_size < XFS_FSB_TO_B(mp, rtb->rbmblocks))
+		sc->ip->i_disk_size = XFS_FSB_TO_B(mp, rtb->rbmblocks);
+
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return xrep_roll_trans(sc);
+}
+
+/* Repair the realtime bitmap file metadata. */
+int
+xrep_rtbitmap(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_rtbitmap	*rtb = sc->buf;
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	blocks = 0;
+	int			error;
+
+	/* Impossibly large rtbitmap means we can't touch the filesystem. */
+	if (rtb->rbmblocks > U32_MAX)
+		return 0;
+
+	/*
+	 * If the size of the rt bitmap file is larger than what we reserved,
+	 * figure out if we need to adjust the block reservation in the
+	 * transaction.
+	 */
+	blocks = xfs_bmbt_calc_size(mp, rtb->rbmblocks);
+	if (blocks > UINT_MAX)
+		return -EOPNOTSUPP;
+	if (blocks > rtb->resblks) {
+		error = xfs_trans_reserve_more(sc->tp, blocks, 0);
+		if (error)
+			return error;
+
+		rtb->resblks += blocks;
+	}
+
+	/* Fix inode core and forks. */
+	error = xrep_metadata_inode_forks(sc);
+	if (error)
+		return error;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Ensure no unwritten extents. */
+	error = xrep_rtbitmap_data_mappings(sc, rtb->rbmblocks);
+	if (error)
+		return error;
+
+	/* Fix inconsistent bitmap geometry */
+	return xrep_rtbitmap_geometry(sc, rtb);
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 89ce6d2f9ad14..9982b626bfc33 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -330,7 +330,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtbitmap,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,

