Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A739413E02A
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609044; cv=none; b=MV8pQakJ0ACa+yHkWqsh/+dDCNueuXKOB0RInclZp1gfHln0DQWEMlbioR/jA92NcF8vLAjpS7EtWZ0YrBKB358PqSvDRclyce1wwJyEkcbAloALb28me0EJzzsjBZYW9UExkkZaTwWSqlfNkbuV3rmGdnp3uHKCHgY64L2oa1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609044; c=relaxed/simple;
	bh=BkC/m154CJsw0Px6Jv53LmVivcXd8YbDCohH4aSlZ2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjE10KN/bidLnu8E3UW/HkLq4/ionxHlVfWf0xihCFNbqEsVpGoV9VJV0WbHUvjnlsbKoxJ0C90g4HoL2LuJegu9HChAQG/mHUYYVGttHwMVmNpwQJVAGHyilccuEBQqA3uqmMjPqUZaaoCX8mugthU0YWT6jjDGq5TG0oLx/t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=avi4SmFx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="avi4SmFx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L9l3FdDmJLfyFQltYwffx+AATZ+7S9Y5NWxorFe7MFs=; b=avi4SmFxR9UHvdhsqJGqyMTqeP
	WJHjFo70CB+24nNQg9l6ugv0nN3o8sEDeQYDSnAMirAskw5mfrbxfDeCN8FJTwavybobt1xtGpjNQ
	A9Wig72O+RByS2JZmOIlk5MMRHHqNEJ8xLsdwvBjy4kcAzz+BrgOeutnmqywSwWMByu2ryP/8zFnT
	hqSIw2oTe6ovNyRA3bx+/+4kBGHv8OYbzwuT6al/VNrFBrk5fp+/tS9VOwLRH7axHGH7ZmgHt1jTp
	pEO02ntn9hSCTwpU3cWrz6LPzceh/oTwYxOvH2UdO6IBVRu5GWcImi6G34WJGLIWRAn2r1i7UqZPD
	v0fAKhwQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVV-00000000iFK-3Tt8;
	Mon, 14 Apr 2025 05:37:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 16/43] xfs: parse and validate hardware zone information
Date: Mon, 14 Apr 2025 07:35:59 +0200
Message-ID: <20250414053629.360672-17-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 720c2d58348329ce57bfa7ecef93ee0c9bf4b405

Add support to validate and parse reported hardware zone state.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_zones.c | 171 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_zones.h |  35 ++++++++++
 2 files changed, 206 insertions(+)
 create mode 100644 libxfs/xfs_zones.c
 create mode 100644 libxfs/xfs_zones.h

diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
new file mode 100644
index 000000000000..b022ed960eac
--- /dev/null
+++ b/libxfs/xfs_zones.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023-2025 Christoph Hellwig.
+ * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_rtgroup.h"
+#include "xfs_zones.h"
+
+static bool
+xfs_zone_validate_empty(
+	struct blk_zone		*zone,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		*write_pointer)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	if (rtg_rmap(rtg)->i_used_blocks > 0) {
+		xfs_warn(mp, "empty zone %u has non-zero used counter (0x%x).",
+			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
+		return false;
+	}
+
+	*write_pointer = 0;
+	return true;
+}
+
+static bool
+xfs_zone_validate_wp(
+	struct blk_zone		*zone,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		*write_pointer)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rtblock_t		wp_fsb = xfs_daddr_to_rtb(mp, zone->wp);
+
+	if (rtg_rmap(rtg)->i_used_blocks > rtg->rtg_extents) {
+		xfs_warn(mp, "zone %u has too large used counter (0x%x).",
+			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
+		return false;
+	}
+
+	if (xfs_rtb_to_rgno(mp, wp_fsb) != rtg_rgno(rtg)) {
+		xfs_warn(mp, "zone %u write pointer (0x%llx) outside of zone.",
+			 rtg_rgno(rtg), wp_fsb);
+		return false;
+	}
+
+	*write_pointer = xfs_rtb_to_rgbno(mp, wp_fsb);
+	if (*write_pointer >= rtg->rtg_extents) {
+		xfs_warn(mp, "zone %u has invalid write pointer (0x%x).",
+			 rtg_rgno(rtg), *write_pointer);
+		return false;
+	}
+
+	return true;
+}
+
+static bool
+xfs_zone_validate_full(
+	struct blk_zone		*zone,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		*write_pointer)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	if (rtg_rmap(rtg)->i_used_blocks > rtg->rtg_extents) {
+		xfs_warn(mp, "zone %u has too large used counter (0x%x).",
+			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
+		return false;
+	}
+
+	*write_pointer = rtg->rtg_extents;
+	return true;
+}
+
+static bool
+xfs_zone_validate_seq(
+	struct blk_zone		*zone,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		*write_pointer)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_EMPTY:
+		return xfs_zone_validate_empty(zone, rtg, write_pointer);
+	case BLK_ZONE_COND_IMP_OPEN:
+	case BLK_ZONE_COND_EXP_OPEN:
+	case BLK_ZONE_COND_CLOSED:
+		return xfs_zone_validate_wp(zone, rtg, write_pointer);
+	case BLK_ZONE_COND_FULL:
+		return xfs_zone_validate_full(zone, rtg, write_pointer);
+	case BLK_ZONE_COND_NOT_WP:
+	case BLK_ZONE_COND_OFFLINE:
+	case BLK_ZONE_COND_READONLY:
+		xfs_warn(mp, "zone %u has unsupported zone condition 0x%x.",
+			rtg_rgno(rtg), zone->cond);
+		return false;
+	default:
+		xfs_warn(mp, "zone %u has unknown zone condition 0x%x.",
+			rtg_rgno(rtg), zone->cond);
+		return false;
+	}
+}
+
+static bool
+xfs_zone_validate_conv(
+	struct blk_zone		*zone,
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_NOT_WP:
+		return true;
+	default:
+		xfs_warn(mp,
+"conventional zone %u has unsupported zone condition 0x%x.",
+			 rtg_rgno(rtg), zone->cond);
+		return false;
+	}
+}
+
+bool
+xfs_zone_validate(
+	struct blk_zone		*zone,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		*write_pointer)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+
+	/*
+	 * Check that the zone capacity matches the rtgroup size stored in the
+	 * superblock.  Note that all zones including the last one must have a
+	 * uniform capacity.
+	 */
+	if (XFS_BB_TO_FSB(mp, zone->capacity) != g->blocks) {
+		xfs_warn(mp,
+"zone %u capacity (0x%llx) does not match RT group size (0x%x).",
+			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->capacity),
+			g->blocks);
+		return false;
+	}
+
+	if (XFS_BB_TO_FSB(mp, zone->len) != 1 << g->blklog) {
+		xfs_warn(mp,
+"zone %u length (0x%llx) does match geometry (0x%x).",
+			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->len),
+			1 << g->blklog);
+	}
+
+	switch (zone->type) {
+	case BLK_ZONE_TYPE_CONVENTIONAL:
+		return xfs_zone_validate_conv(zone, rtg);
+	case BLK_ZONE_TYPE_SEQWRITE_REQ:
+		return xfs_zone_validate_seq(zone, rtg, write_pointer);
+	default:
+		xfs_warn(mp, "zoned %u has unsupported type 0x%x.",
+			rtg_rgno(rtg), zone->type);
+		return false;
+	}
+}
diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
new file mode 100644
index 000000000000..c4f1367b2cca
--- /dev/null
+++ b/libxfs/xfs_zones.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LIBXFS_ZONES_H
+#define _LIBXFS_ZONES_H
+
+struct xfs_rtgroup;
+
+/*
+ * In order to guarantee forward progress for GC we need to reserve at least
+ * two zones:  one that will be used for moving data into and one spare zone
+ * making sure that we have enough space to relocate a nearly-full zone.
+ * To allow for slightly sloppy accounting for when we need to reserve the
+ * second zone, we actually reserve three as that is easier than doing fully
+ * accurate bookkeeping.
+ */
+#define XFS_GC_ZONES		3U
+
+/*
+ * In addition we need two zones for user writes, one open zone for writing
+ * and one to still have available blocks without resetting the open zone
+ * when data in the open zone has been freed.
+ */
+#define XFS_RESERVED_ZONES	(XFS_GC_ZONES + 1)
+#define XFS_MIN_ZONES		(XFS_RESERVED_ZONES + 1)
+
+/*
+ * Always keep one zone out of the general open zone pool to allow for GC to
+ * happen while other writers are waiting for free space.
+ */
+#define XFS_OPEN_GC_ZONES	1U
+#define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
+
+bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
+	xfs_rgblock_t *write_pointer);
+
+#endif /* _LIBXFS_ZONES_H */
-- 
2.47.2

