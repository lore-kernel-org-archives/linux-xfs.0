Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B3148832
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609077; cv=none; b=IC7SB7AKQC5O98lzcDt+F6mhc3egBu0LgxaHMgSZYGdtZt/rm9nCHPPKqdDtSSPUb4ELHY7cE1iGmni1nzYj4zEnEDkpJVXUUIYDOLsW9nj5H4L8lnbWhVPvq1+gm+2xdNagBruK4rMBtBgU0pAXrIVOhj8KZijHoURm1dExU5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609077; c=relaxed/simple;
	bh=z0c3fGy0djDcXD5XvAo4h8+ePCbGx1Jg62qIy7VqUc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZy8/FjV8JIkaiCD6SLkxzt71eFRzEwycB6HEw3/cYx4hXe2hqHtrTLiX//HN/ZnmjsjrJGvdgq/Sf0ZZtOm+PPOl6nkubb38GuNwT4jcmApGpUGSj9pri2GvUc0hM/hq4pjlHnswH2dq2jopoFDe4zCJN2Rc0/KXMO0HYUaqL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dWTMl0+C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dWTMl0+C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wq99DMrvuOHwu+5F4HoX8BUWRPRX6yldymD9wP+p1jk=; b=dWTMl0+CwiYvHcanP2HUCe+3Lt
	BrW2eWxUTKmJHL5RXswz7mkQWVQPu1bdP//PfXtk3RqbG7XjCr4Okp9+/0XAI8K84FEju6ElvqTz7
	0ifpiFLvJc8nyVMKWHIUyLcYujr/Av5GQxt2VC9BWTsQ7jRZ5eGTf3qZM57BqrhqKrwyumwDKc9N6
	6rM9rB+vf4a+EeVDgehqwNA4Z5fUdXejr9eKnt4IJMd3bhMG5YQyLe1Kyu/5bbP5up7OkMJWlRAvW
	SIxfSJXEvyFkeMF5uypUeyfdMLpNhs3JLG5PDQykabrE0LiRw7vWMVF2vIaRDTZls7yDZ1VC6qWuM
	TmEy9Umg==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CW3-00000000iMR-1brk;
	Mon, 14 Apr 2025 05:37:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 29/43] xfs_repair: validate rt groups vs reported hardware zones
Date: Mon, 14 Apr 2025 07:36:12 +0200
Message-ID: <20250414053629.360672-30-hch@lst.de>
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

Run a report zones ioctl, and verify the rt group state vs the
reported hardware zone state.  Note that there is no way to actually
fix up any discrepancies here, as that would be rather scary without
having transactions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/Makefile |   1 +
 repair/phase5.c |  11 +---
 repair/zoned.c  | 139 ++++++++++++++++++++++++++++++++++++++++++++++++
 repair/zoned.h  |  10 ++++
 4 files changed, 152 insertions(+), 9 deletions(-)
 create mode 100644 repair/zoned.c
 create mode 100644 repair/zoned.h

diff --git a/repair/Makefile b/repair/Makefile
index ff5b1f5abeda..fb0b2f96cc91 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -81,6 +81,7 @@ CFILES = \
 	strblobs.c \
 	threads.c \
 	versions.c \
+	zoned.c \
 	xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
diff --git a/repair/phase5.c b/repair/phase5.c
index e350b411c243..e44c26885717 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -21,6 +21,7 @@
 #include "rmap.h"
 #include "bulkload.h"
 #include "agbtree.h"
+#include "zoned.h"
 
 static uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
 static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
@@ -631,15 +632,7 @@ check_rtmetadata(
 	struct xfs_mount	*mp)
 {
 	if (xfs_has_zoned(mp)) {
-		/*
-		 * Here we could/should verify the zone state a bit when we are
-		 * on actual zoned devices:
-		 *	- compare hw write pointer to last written
-		 *	- compare zone state to last written
-		 *
-		 * Note much we can do when running in zoned mode on a
-		 * conventional device.
-		 */
+		check_zones(mp);
 		return;
 	}
 
diff --git a/repair/zoned.c b/repair/zoned.c
new file mode 100644
index 000000000000..456076b9817d
--- /dev/null
+++ b/repair/zoned.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Christoph Hellwig.
+ */
+#include <ctype.h>
+#include <linux/blkzoned.h>
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "xfs_zones.h"
+#include "err_protos.h"
+#include "zoned.h"
+
+/* random size that allows efficient processing */
+#define ZONES_PER_IOCTL			16384
+
+static void
+report_zones_cb(
+	struct xfs_mount	*mp,
+	struct blk_zone		*zone)
+{
+	xfs_rtblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
+	xfs_rgblock_t		write_pointer;
+	xfs_rgnumber_t		rgno;
+	struct xfs_rtgroup	*rtg;
+
+	if (xfs_rtb_to_rgbno(mp, zsbno) != 0) {
+		do_error(_("mismatched zone start 0x%llx."),
+				(unsigned long long)zsbno);
+		return;
+	}
+
+	rgno = xfs_rtb_to_rgno(mp, zsbno);
+	rtg = xfs_rtgroup_grab(mp, rgno);
+	if (!rtg) {
+		do_error(_("realtime group not found for zone %u."), rgno);
+		return;
+	}
+
+	if (!rtg_rmap(rtg))
+		do_warn(_("no rmap inode for zone %u."), rgno);
+	else
+		xfs_zone_validate(zone, rtg, &write_pointer);
+	xfs_rtgroup_rele(rtg);
+}
+
+void
+check_zones(
+	struct xfs_mount	*mp)
+{
+	int			fd = mp->m_rtdev_targp->bt_bdev_fd;
+	uint64_t		sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
+	unsigned int		zone_size, zone_capacity;
+	uint64_t		device_size;
+	size_t			rep_size;
+	struct blk_zone_report	*rep;
+	unsigned int		i, n = 0;
+
+	if (ioctl(fd, BLKGETSIZE64, &device_size))
+		return; /* not a block device */
+	if (ioctl(fd, BLKGETZONESZ, &zone_size) || !zone_size)
+		return;	/* not zoned */
+
+	/* BLKGETSIZE64 reports a byte value */
+	device_size = BTOBB(device_size);
+	if (device_size / zone_size < mp->m_sb.sb_rgcount) {
+		do_error(_("rt device too small\n"));
+		return;
+	}
+
+	rep_size = sizeof(struct blk_zone_report) +
+		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
+	rep = malloc(rep_size);
+	if (!rep) {
+		do_warn(_("malloc failed for zone report\n"));
+		return;
+	}
+
+	while (n < mp->m_sb.sb_rgcount) {
+		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
+		int ret;
+
+		memset(rep, 0, rep_size);
+		rep->sector = sector;
+		rep->nr_zones = ZONES_PER_IOCTL;
+
+		ret = ioctl(fd, BLKREPORTZONE, rep);
+		if (ret) {
+			do_error(_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
+			goto out_free;
+		}
+		if (!rep->nr_zones)
+			break;
+
+		for (i = 0; i < rep->nr_zones; i++) {
+			if (n >= mp->m_sb.sb_rgcount)
+				break;
+
+			if (zones[i].len != zone_size) {
+				do_error(_("Inconsistent zone size!\n"));
+				goto out_free;
+			}
+
+			switch (zones[i].type) {
+			case BLK_ZONE_TYPE_CONVENTIONAL:
+			case BLK_ZONE_TYPE_SEQWRITE_REQ:
+				break;
+			case BLK_ZONE_TYPE_SEQWRITE_PREF:
+				do_error(
+_("Found sequential write preferred zone\n"));
+				goto out_free;
+			default:
+				do_error(
+_("Found unknown zone type (0x%x)\n"), zones[i].type);
+				goto out_free;
+			}
+
+			if (!n) {
+				zone_capacity = zones[i].capacity;
+				if (zone_capacity > zone_size) {
+					do_error(
+_("Zone capacity larger than zone size!\n"));
+					goto out_free;
+				}
+			} else if (zones[i].capacity != zone_capacity) {
+				do_error(
+_("Inconsistent zone capacity!\n"));
+				goto out_free;
+			}
+
+			report_zones_cb(mp, &zones[i]);
+			n++;
+		}
+		sector = zones[rep->nr_zones - 1].start +
+			 zones[rep->nr_zones - 1].len;
+	}
+
+out_free:
+	free(rep);
+}
diff --git a/repair/zoned.h b/repair/zoned.h
new file mode 100644
index 000000000000..ab76bf15b3ca
--- /dev/null
+++ b/repair/zoned.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2024 Christoph Hellwig.
+ */
+#ifndef _XFS_REPAIR_ZONED_H_
+#define _XFS_REPAIR_ZONED_H_
+
+void check_zones(struct xfs_mount *mp);
+
+#endif /* _XFS_REPAIR_ZONED_H_ */
-- 
2.47.2

