Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE921EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907523; cv=none; b=P5jNpGOzTRFEDhAS2niS6UEkeyjZ4dxqQBAsR6E90i4Tugq2GjdjCy3h3T0SJ1XvCWkg7gJa4V5sseUU1RSXVgxLhCe821KeP28JF5Q+HBi0/kKcw4RJXmQ5YZ0e9FUum7TAsKCfwINn5qJ7+o2K/mK4nQi5DfrQE53hGlw9C9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907523; c=relaxed/simple;
	bh=jCrPKavoVJ3ES5P2UG5drrvhN2O6PECyq75hhqjxyVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca6EBMpibcjD4+syZiUwJFL+jKdgPdLMOtEsAUuNQqmFQFLtodxRRZ6ZEy4fNs5iretNrsSlJ8fNHoIA4HmujqQO7Ze9th5V++qlQo/IsdHRUN8KoCURhDGadRS2RYvkLOnVx5dcOjMDrwY9oG0KSrbHq6Ufuk0FN8aVlvNcDCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vXugLAsg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vXugLAsg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iU37WazKQLyyvktIYByQUcdaVUNP0mxEyMVZ+/Kpk9U=; b=vXugLAsgh47j0hjYYGbswMiU2s
	W7RjUMf9pormUQI9yg6f2eiql4v5JKE4dYt+TBQsQSeP1H9KtFmTFaFNAyfNO/tN9Vyd7KgF8HMWG
	5yp6/VCdhdLqnOMVQiUJiZVzlhNiUM+wjh97c+SYnU/TZh8YMvHDHQczmTZcsbAtkN8EFDW00lXg8
	3VWlcu1rhwobq+Oxgg76UDCqKpZGLdgyJ7XodVrxr8zgDl4P6JEzPjqnWKI6VCacOoJoMCfZcw0al
	iqWFEqUlHF4BEo1dlTC7oBc7xI1C70ymxXIAbGWaGUyFcbX0QXCRYpuOYgqE5U4x429RoNtyAJNuK
	0IUNjXpw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIYL-0000000EJYr-0fib;
	Wed, 11 Dec 2024 08:58:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 43/43] xfs: export zone stats in /proc/*/mountstats
Date: Wed, 11 Dec 2024 09:55:08 +0100
Message-ID: <20241211085636.1380516-44-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
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
 fs/xfs/xfs_zone_info.c  | 120 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+)
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
index 47468623fdc6..df384c4de192 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1243,6 +1243,10 @@ xfs_fs_show_stats(
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
index 44fa1594f73e..94ab32826c83 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -34,6 +34,7 @@ void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
 
 uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
 		enum xfs_free_counter ctr);
+void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
 
 #ifdef CONFIG_XFS_RT
 int xfs_mount_zones(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
new file mode 100644
index 000000000000..689c9acb24d7
--- /dev/null
+++ b/fs/xfs/xfs_zone_info.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023-2024 Christoph Hellwig.
+ * Copyright (c) 2024, Western Digital Corporation or its affiliates.
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
+#define XFS_USED_BUCKETS	10
+#define XFS_USED_BUCKET_PCT	(100 / XFS_USED_BUCKETS)
+
+static unsigned int
+xfs_zone_to_bucket(
+	struct xfs_rtgroup      *rtg)
+{
+	return div_u64(rtg_rmap(rtg)->i_used_blocks * XFS_USED_BUCKETS,
+			rtg->rtg_extents);
+}
+
+static void
+xfs_show_full_zone_used_distribution(
+	struct seq_file         *m,
+	struct xfs_mount        *mp)
+{
+	struct xfs_zone_info	*zi = mp->m_zone_info;
+	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
+	unsigned int            buckets[XFS_USED_BUCKETS] = {0};
+	unsigned int		reclaimable = 0, full, i;
+	struct xfs_rtgroup      *rtg;
+
+	lockdep_assert_held(&zi->zi_zone_list_lock);
+
+	rcu_read_lock();
+	xas_for_each_marked(&xas, rtg, ULONG_MAX, XFS_RTG_RECLAIMABLE) {
+		buckets[xfs_zone_to_bucket(rtg)]++;
+		reclaimable++;
+	}
+	rcu_read_unlock();
+
+	for (i = 0; i < XFS_USED_BUCKETS; i++)
+		seq_printf(m, "\t  %2u..%2u%%: %u\n", i * XFS_USED_BUCKET_PCT,
+				(i + 1) * XFS_USED_BUCKET_PCT - 1, buckets[i]);
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
+	seq_printf(m, "\tuser free blocks: %lld\n",
+		xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
+	seq_printf(m, "\treserved free blocks: %lld\n",
+		mp->m_resblks[XC_FREE_RTEXTENTS].avail);
+	seq_printf(m, "\tuser available blocks: %lld\n",
+		xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE));
+	seq_printf(m, "\treserved available blocks: %lld\n",
+		mp->m_resblks[XC_FREE_RTAVAILABLE].avail);
+	seq_printf(m, "\treservations required: %d\n",
+		!list_empty_careful(&zi->zi_reclaim_reservations));
+	seq_printf(m, "\tGC required: %d\n",
+		xfs_zoned_need_gc(mp));
+
+	spin_lock(&zi->zi_zone_list_lock);
+	seq_printf(m, "\tfree zones: %d\n", atomic_read(&zi->zi_nr_free_zones));
+	seq_puts(m, "\topen zones:\n");
+	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
+		xfs_show_open_zone(m, oz);
+	if (zi->zi_open_gc_zone) {
+		seq_puts(m, "\topen gc zone:\n");
+		xfs_show_open_zone(m, zi->zi_open_gc_zone);
+	}
+	seq_puts(m, "\tused blocks distribution (fully written zones):\n");
+	xfs_show_full_zone_used_distribution(m, mp);
+	spin_unlock(&zi->zi_zone_list_lock);
+}
-- 
2.45.2

