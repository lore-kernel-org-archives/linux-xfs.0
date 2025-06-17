Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADDD2192EA
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157575; cv=none; b=YbVR0V5YmRcR9k7hPDNkJ2CYT0fOLIiRwP16Ij65HCz8WKEXq89gCNBffxwwLumkDbpcmRD+R+nvcREv0Y0yF7TvflFDtQaRmuj4m4zbMTSLVetky6bKmfFynIj1FWoy/uRvOI3p+LIBxE6Snbln6I5+zO/r7YicdnRRvdbHggM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157575; c=relaxed/simple;
	bh=HmgZ2Kml3fGH0rWAYslLhAiuI3gA1Ph9cOT88TuSZHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sqe0Vb2qk3oNGgpleH21Lc7ZzsYMyFPLFBGQs+tw/B1hrN7R+lE/7EC6jWTr4kFvbeO57DvvfMutBFMsT+cgHCZvloHXZP4dERtSrBlTB3gTkabwQtVb9C/iEAjGyTGAKU3V2q2vipMHf36S0Q+AfoTipcWr52Uwyash8NZPqnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dhoKUVdQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dhoKUVdQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yHpzr2X2muA4i7C8yk4fYJNKprIcSFNfIkKjY1HfC48=; b=dhoKUVdQb985fHWKL4IOjhoHpq
	gfzO9bWwHrM2NKT8c726UCYcfmi4WbyLvEmuBc3C4j6+1mGNfHVuFEP38zQzxhr2vR0wVI7xD171q
	83BteUa+0Wac9L/HNw7vYd2LVEa1aJr8jKZkZIU5GUoN31gUkSyMr2fXKcbgG44VOie3UC6HIp7ue
	qW9HRGV5AIN6B6YF+HaMRqOVL84ZYQsw+VDFhNd8z9N7J0o0wwmwW7zQjxEH95V4VuEHtyNzcUhlY
	HMwOuJbXzH0tE4ta+QQkkJYZnLyPkvT+0rgSeK2xxTOXMIMD5fkKmoYLi2okayCtrnHOeVauZIQPd
	cwE+Cr/Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTvx-00000006yQa-0c7f;
	Tue, 17 Jun 2025 10:52:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: refactor xfs_calc_atomic_write_unit_max
Date: Tue, 17 Jun 2025 12:52:02 +0200
Message-ID: <20250617105238.3393499-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617105238.3393499-1-hch@lst.de>
References: <20250617105238.3393499-1-hch@lst.de>
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
---
 fs/xfs/xfs_mount.c | 77 +++++++++++++++++-----------------------------
 fs/xfs/xfs_trace.h | 31 +++++++++----------
 2 files changed, 43 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 047100b080aa..929b1f3349dc 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -679,68 +679,47 @@ static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
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
+	struct xfs_buftarg	*btp = type == XG_TYPE_RTG ?
+			mp->m_rtdev_targp : mp->m_ddev_targp;
 
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
@@ -758,7 +737,8 @@ xfs_set_max_atomic_write_opt(
 		max(mp->m_groups[XG_TYPE_AG].blocks,
 		    mp->m_groups[XG_TYPE_RTG].blocks);
 	const xfs_extlen_t	max_group_write =
-		max(xfs_calc_perag_awu_max(mp), xfs_calc_rtgroup_awu_max(mp));
+		max(xfs_calc_group_awu_max(mp, XG_TYPE_AG),
+		    xfs_calc_group_awu_max(mp, XG_TYPE_RTG));
 	int			error;
 
 	if (new_max_bytes == 0)
@@ -814,7 +794,8 @@ xfs_set_max_atomic_write_opt(
 		return error;
 	}
 
-	xfs_calc_atomic_write_unit_max(mp);
+	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_AG);
+	xfs_calc_atomic_write_unit_max(mp, XG_TYPE_RTG);
 	mp->m_awu_max_bytes = new_max_bytes;
 	return 0;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 01d284a1c759..a45de5d89933 100644
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

