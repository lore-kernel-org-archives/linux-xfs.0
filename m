Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE580225A35
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824436; cv=none; b=ZExc0vu5ASkBWI3QgpZkmaJaOQJOUJmVCjgV/o29hx6Uphx7+aLg2TRed9+TJntRaMeibZQIBpenFclDBVE+sedBmycuIbnZGPsiWj0bdVBljkjvE9lN0NHeHBdu81rBibd2rlFfIMI/I5p4CDAJk87pvsFBayjnrXkr6L4L3ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824436; c=relaxed/simple;
	bh=MY8hrNa/vLmZWCEwgB0nc3u1RdnakIVjx24sat8+t0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM5gxWo7h9cVyWegIdN0X0X2yoQcLukfNHlre4XZtuHbIVsyGreAkrpwTrioGl9Virzhx4N9N9pecN7jtL6J1nOtYKrhz7XBB8OUl0/p6vlvtzp/48fPmjxtUbytPTHLZRZLjPDNA9tRiwdpwtBeaeApd5sGRcVogkirH+lWVuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zntrudyb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zntrudyb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YJXeV7bY4Wjt/JEY39BKm3WZaMOJoTmOVylK+GfouoU=; b=zntrudybepm1cJluB5WEc9/WgF
	WJqqxSgF04aRIrGgV6diMazyEDobyMM9QD7Olpp3qV4ohDgwVe5ND3g2qCs+p2HX0F30mBsDKYRTo
	G9Ld1Xz/mFyDpK0fEsGksSJsSM9KYnl+Ei2qJ5sml3Ey3ELwt3HgDJ9rKRjeniWVPdbIxg03z9jac
	BINnzn09wLpHMcTK83qPYnY/I+OIWMcDyCWdqCsftTxIB019//c08WTuTnRDtZNEqMd3wk8gWtR2A
	BqMwfT/XGH1zx3IxjWmXlanYZ3nRGjtj6HvsyQe8B8LexjThHt5GheWkxjcSla17nwAGJQnNqwzrD
	EYvkedkQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvfO-00000005Qv3-076g;
	Thu, 06 Feb 2025 06:47:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 41/43] xfs: export zone stats in /proc/*/mountstats
Date: Thu,  6 Feb 2025 07:44:57 +0100
Message-ID: <20250206064511.2323878-42-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Hans Holmberg <hans.holmberg@wdc.com>

Add the per-zone life time hint and the used block distribution
for fully written zones, grouping reclaimable zones in fixed-percentage
buckets spanning 0..9%, 10..19% and full zones as 100% used as well as a
few statistics about the zone allocator and open and reclaimable zones
in /proc/*/mountstats.

This gives good insight into data fragmentation and data placement
success rate.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Co-developed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile         |   1 +
 fs/xfs/xfs_super.c      |   4 ++
 fs/xfs/xfs_zone_alloc.h |   1 +
 fs/xfs/xfs_zone_info.c  | 105 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 111 insertions(+)
 create mode 100644 fs/xfs/xfs_zone_info.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e38838409271..5bf501cf8271 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -140,6 +140,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
 				   xfs_zone_alloc.o \
 				   xfs_zone_gc.o \
+				   xfs_zone_info.o \
 				   xfs_zone_space_resv.o
 
 xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 134859a3719d..877332ffd84b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1262,6 +1262,10 @@ xfs_fs_show_stats(
 	struct seq_file		*m,
 	struct dentry		*root)
 {
+	struct xfs_mount	*mp = XFS_M(root->d_sb);
+
+	if (xfs_has_zoned(mp) && IS_ENABLED(CONFIG_XFS_RT))
+		xfs_zoned_show_stats(m, mp);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index 1269390bfcda..ecf39106704c 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -44,6 +44,7 @@ void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
 
 uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
 		enum xfs_free_counter ctr);
+void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
 
 #ifdef CONFIG_XFS_RT
 int xfs_mount_zones(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
new file mode 100644
index 000000000000..7ba0a5931c99
--- /dev/null
+++ b/fs/xfs/xfs_zone_info.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023-2025 Christoph Hellwig.
+ * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_zone_priv.h"
+
+static const char xfs_write_hint_shorthand[6][16] = {
+	"NOT_SET", "NONE", "SHORT", "MEDIUM", "LONG", "EXTREME"};
+
+static inline const char *
+xfs_write_hint_to_str(
+	uint8_t			write_hint)
+{
+	if (write_hint > WRITE_LIFE_EXTREME)
+		return "UNKNOWN";
+	return xfs_write_hint_shorthand[write_hint];
+}
+
+static void
+xfs_show_open_zone(
+	struct seq_file		*m,
+	struct xfs_open_zone	*oz)
+{
+	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s\n",
+		rtg_rgno(oz->oz_rtg),
+		oz->oz_write_pointer, oz->oz_written,
+		rtg_rmap(oz->oz_rtg)->i_used_blocks,
+		xfs_write_hint_to_str(oz->oz_write_hint));
+}
+
+static void
+xfs_show_full_zone_used_distribution(
+	struct seq_file         *m,
+	struct xfs_mount        *mp)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	unsigned int		reclaimable = 0, full, i;
+
+	spin_lock(&zi->zi_used_buckets_lock);
+	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++) {
+		unsigned int entries = zi->zi_used_bucket_entries[i];
+
+		seq_printf(m, "\t  %2u..%2u%%: %u\n",
+				i * (100 / XFS_ZONE_USED_BUCKETS),
+				(i + 1) * (100 / XFS_ZONE_USED_BUCKETS) - 1,
+				entries);
+		reclaimable += entries;
+	}
+	spin_unlock(&zi->zi_used_buckets_lock);
+
+	full = mp->m_sb.sb_rgcount;
+	if (zi->zi_open_gc_zone)
+		full--;
+	full -= zi->zi_nr_open_zones;
+	full -= atomic_read(&zi->zi_nr_free_zones);
+	full -= reclaimable;
+
+	seq_printf(m, "\t     100%%: %u\n", full);
+}
+
+void
+xfs_zoned_show_stats(
+	struct seq_file		*m,
+	struct xfs_mount	*mp)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	struct xfs_open_zone	*oz;
+
+	seq_puts(m, "\n");
+
+	seq_printf(m, "\tuser free RT blocks: %lld\n",
+		xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
+	seq_printf(m, "\treserved free RT blocks: %lld\n",
+		mp->m_resblks[XC_FREE_RTEXTENTS].avail);
+	seq_printf(m, "\tuser available RT blocks: %lld\n",
+		xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE));
+	seq_printf(m, "\treserved available RT blocks: %lld\n",
+		mp->m_resblks[XC_FREE_RTAVAILABLE].avail);
+	seq_printf(m, "\tRT reservations required: %d\n",
+		!list_empty_careful(&zi->zi_reclaim_reservations));
+	seq_printf(m, "\tRT GC required: %d\n",
+		xfs_zoned_need_gc(mp));
+
+	seq_printf(m, "\tfree zones: %d\n", atomic_read(&zi->zi_nr_free_zones));
+	seq_puts(m, "\topen zones:\n");
+	spin_lock(&zi->zi_open_zones_lock);
+	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
+		xfs_show_open_zone(m, oz);
+	if (zi->zi_open_gc_zone) {
+		seq_puts(m, "\topen gc zone:\n");
+		xfs_show_open_zone(m, zi->zi_open_gc_zone);
+	}
+	spin_unlock(&zi->zi_open_zones_lock);
+	seq_puts(m, "\tused blocks distribution (fully written zones):\n");
+	xfs_show_full_zone_used_distribution(m, mp);
+}
-- 
2.45.2

