Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4397528FFE6
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 12:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751892819; cv=none; b=KueMyrmV2Uu519zfxFzG4/AFl6CJ/4iqdXRD96mGyqE+UzEEnCbz9jUgDhqypE6egKr1XUbp4G5XV2oCDMW6UVySKIvm3U9+yDT0G4NBWQcexX/dMV+75Udwy/xupju0ioAkAqH9SX30vDSwbiUDlk//SGe9BwRE0SEKF/aYG9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751892819; c=relaxed/simple;
	bh=26nTMWDsmFglB+DxwbpL0cfyvAWPf/xxEiZm1Anbo7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDCTQYDiPDgfA4AWMQ9Mm0cs1x6l/sbcffWhx0PcjxpCylasR9Ef7jSEj7iSv7W2Vr/1cXkHW9dF70NrKXT4QMQGtpHaD8dvxmytgNtUPufnbfqSBZKgdtAjkeg2XNk9Hl1qyR9JApQegtD6yMELZb04/mgmhieRbEG82g1vj34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cwcrNXm9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cwcrNXm9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F1M5HEPpUDGKIOeoaaw8LO1gFxhdbBZhD5vjp5+PkZs=; b=cwcrNXm9et1loCh722Ws7YaSVD
	ZYKyMnYOr3H3XXifwoELlbE1tvzDs7EN2kCZrz8DUJTHuE+Y3Peta0bGiqzdatNROftKOckKYYxBg
	1a7QRCPOKIZD8LENAfz8A7O39jlaP+fvyOgV3ISl6I6xMW+lQnSF0jBV7yzz8gV12njO2i0HLlbKw
	gfTVWAfALdC/UiSDBlvwV3Q7XAPDrSV3TiNtom3IAYowSr7EQLaqqKvR3SWX0VDUn4CIiA9Wv0ek5
	kpPqhhoPVGnYA8gwK69FTsc8BouQKiLUmUPks+NQcogDUudMrKzADeiItB/Jm0Mw4qZGXUOzTfmBi
	W17Ddbdw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uYlLl-00000002SiZ-2gzK;
	Mon, 07 Jul 2025 12:53:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: refactor xfs_calc_atomic_write_unit_max
Date: Mon,  7 Jul 2025 14:53:15 +0200
Message-ID: <20250707125323.3022719-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250707125323.3022719-1-hch@lst.de>
References: <20250707125323.3022719-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This function and the helpers used by it duplicate the same logic for AGs
and RTGs.  Use the xfs_group_type enum to unify both variants.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c | 76 +++++++++++++++++-----------------------------
 fs/xfs/xfs_trace.h | 31 +++++++++----------
 2 files changed, 42 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 047100b080aa..99fbb22bad4c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -679,68 +679,46 @@ static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
 }
 
 /*
- * If the data device advertises atomic write support, limit the size of data
- * device atomic writes to the greatest power-of-two factor of the AG size so
- * that every atomic write unit aligns with the start of every AG.  This is
- * required so that the per-AG allocations for an atomic write will always be
+ * If the underlying device advertises atomic write support, limit the size of
+ * atomic writes to the greatest power-of-two factor of the group size so
+ * that every atomic write unit aligns with the start of every group.  This is
+ * required so that the allocations for an atomic write will always be
  * aligned compatibly with the alignment requirements of the storage.
  *
- * If the data device doesn't advertise atomic writes, then there are no
- * alignment restrictions and the largest out-of-place write we can do
- * ourselves is the number of blocks that user files can allocate from any AG.
+ * If the device doesn't advertise atomic writes, then there are no alignment
+ * restrictions and the largest out-of-place write we can do ourselves is the
+ * number of blocks that user files can allocate from any group.
  */
-static inline xfs_extlen_t xfs_calc_perag_awu_max(struct xfs_mount *mp)
-{
-	if (mp->m_ddev_targp->bt_bdev_awu_min > 0)
-		return max_pow_of_two_factor(mp->m_sb.sb_agblocks);
-	return rounddown_pow_of_two(mp->m_ag_max_usable);
-}
-
-/*
- * Reflink on the realtime device requires rtgroups, and atomic writes require
- * reflink.
- *
- * If the realtime device advertises atomic write support, limit the size of
- * data device atomic writes to the greatest power-of-two factor of the rtgroup
- * size so that every atomic write unit aligns with the start of every rtgroup.
- * This is required so that the per-rtgroup allocations for an atomic write
- * will always be aligned compatibly with the alignment requirements of the
- * storage.
- *
- * If the rt device doesn't advertise atomic writes, then there are no
- * alignment restrictions and the largest out-of-place write we can do
- * ourselves is the number of blocks that user files can allocate from any
- * rtgroup.
- */
-static inline xfs_extlen_t xfs_calc_rtgroup_awu_max(struct xfs_mount *mp)
+static xfs_extlen_t
+xfs_calc_group_awu_max(
+	struct xfs_mount	*mp,
+	enum xfs_group_type	type)
 {
-	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
+	struct xfs_groups	*g = &mp->m_groups[type];
+	struct xfs_buftarg	*btp = xfs_group_type_buftarg(mp, type);
 
-	if (rgs->blocks == 0)
+	if (g->blocks == 0)
 		return 0;
-	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_bdev_awu_min > 0)
-		return max_pow_of_two_factor(rgs->blocks);
-	return rounddown_pow_of_two(rgs->blocks);
+	if (btp && btp->bt_bdev_awu_min > 0)
+		return max_pow_of_two_factor(g->blocks);
+	return rounddown_pow_of_two(g->blocks);
 }
 
 /* Compute the maximum atomic write unit size for each section. */
 static inline void
 xfs_calc_atomic_write_unit_max(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	enum xfs_group_type	type)
 {
-	struct xfs_groups	*ags = &mp->m_groups[XG_TYPE_AG];
-	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
+	struct xfs_groups	*g = &mp->m_groups[type];
 
 	const xfs_extlen_t	max_write = xfs_calc_atomic_write_max(mp);
 	const xfs_extlen_t	max_ioend = xfs_reflink_max_atomic_cow(mp);
-	const xfs_extlen_t	max_agsize = xfs_calc_perag_awu_max(mp);
-	const xfs_extlen_t	max_rgsize = xfs_calc_rtgroup_awu_max(mp);
-
-	ags->awu_max = min3(max_write, max_ioend, max_agsize);
-	rgs->awu_max = min3(max_write, max_ioend, max_rgsize);
+	const xfs_extlen_t	max_gsize = xfs_calc_group_awu_max(mp, type);
 
-	trace_xfs_calc_atomic_write_unit_max(mp, max_write, max_ioend,
-			max_agsize, max_rgsize);
+	g->awu_max = min3(max_write, max_ioend, max_gsize);
+	trace_xfs_calc_atomic_write_unit_max(mp, type, max_write, max_ioend,
+			max_gsize, g->awu_max);
 }
 
 /*
@@ -758,7 +736,8 @@ xfs_set_max_atomic_write_opt(
 		max(mp->m_groups[XG_TYPE_AG].blocks,
 		    mp->m_groups[XG_TYPE_RTG].blocks);
 	const xfs_extlen_t	max_group_write =
-		max(xfs_calc_perag_awu_max(mp), xfs_calc_rtgroup_awu_max(mp));
+		max(xfs_calc_group_awu_max(mp, XG_TYPE_AG),
+		    xfs_calc_group_awu_max(mp, XG_TYPE_RTG));
 	int			error;
 
 	if (new_max_bytes == 0)
@@ -814,7 +793,8 @@ xfs_set_max_atomic_write_opt(
 		return error;
 	}
 
-	xfs_calc_atomic_write_unit_max(mp);
+	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_AG);
+	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_RTG);
 	mp->m_awu_max_bytes = new_max_bytes;
 	return 0;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aae0d0ef84e0..6addebd764b0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -171,36 +171,33 @@ DEFINE_ATTR_LIST_EVENT(xfs_attr_leaf_list);
 DEFINE_ATTR_LIST_EVENT(xfs_attr_node_list);
 
 TRACE_EVENT(xfs_calc_atomic_write_unit_max,
-	TP_PROTO(struct xfs_mount *mp, unsigned int max_write,
-		 unsigned int max_ioend, unsigned int max_agsize,
-		 unsigned int max_rgsize),
-	TP_ARGS(mp, max_write, max_ioend, max_agsize, max_rgsize),
+	TP_PROTO(struct xfs_mount *mp, enum xfs_group_type type,
+		 unsigned int max_write, unsigned int max_ioend,
+		 unsigned int max_gsize, unsigned int awu_max),
+	TP_ARGS(mp, type, max_write, max_ioend, max_gsize, awu_max),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(unsigned int, max_write)
 		__field(unsigned int, max_ioend)
-		__field(unsigned int, max_agsize)
-		__field(unsigned int, max_rgsize)
-		__field(unsigned int, data_awu_max)
-		__field(unsigned int, rt_awu_max)
+		__field(unsigned int, max_gsize)
+		__field(unsigned int, awu_max)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
+		__entry->type = type;
 		__entry->max_write = max_write;
 		__entry->max_ioend = max_ioend;
-		__entry->max_agsize = max_agsize;
-		__entry->max_rgsize = max_rgsize;
-		__entry->data_awu_max = mp->m_groups[XG_TYPE_AG].awu_max;
-		__entry->rt_awu_max = mp->m_groups[XG_TYPE_RTG].awu_max;
+		__entry->max_gsize = max_gsize;
+		__entry->awu_max = awu_max;
 	),
-	TP_printk("dev %d:%d max_write %u max_ioend %u max_agsize %u max_rgsize %u data_awu_max %u rt_awu_max %u",
+	TP_printk("dev %d:%d %s max_write %u max_ioend %u max_gsize %u awu_max %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->max_write,
 		  __entry->max_ioend,
-		  __entry->max_agsize,
-		  __entry->max_rgsize,
-		  __entry->data_awu_max,
-		  __entry->rt_awu_max)
+		  __entry->max_gsize,
+		  __entry->awu_max)
 );
 
 TRACE_EVENT(xfs_calc_max_atomic_write_fsblocks,
-- 
2.47.2

