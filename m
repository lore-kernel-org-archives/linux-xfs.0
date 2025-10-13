Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CA2288D2
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323387; cv=none; b=QViWnemPAMfixvZ4LuCd1Dr4MEDkt13ch9q0oKZIvwK68FwaH+d1pKV1QJ+FeEHseuPHbj6uUijKgcn+neCIehYyRA13j+S9UM+GfcymlF98Zo8V1Kczt3Z+kzAUqw00SHpxf5Csc+P0qY//sKDQihzrFoI+T1rp1U0ajBiLciI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323387; c=relaxed/simple;
	bh=4ZZF1hM54AyAEjt7hZv3QJF/6LaNGKVarssxRjqkynw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rX5sVOReWSlEXTDmOpS4sLJ7miiAYkZcGK70aM9vI2bTT/w7fXi6c+pwT6J+8T03KGbqVDGdYhD+l69chmeesxibcMCcRymaz9PrQT6b9O6uh/Hse4ZneY30FZhTFV69JjU+S25aXIxrhmRpx1N2gYPXjlQ27nt7gj+9UV6Oya4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4OaiDOlB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4OaiDOlB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JeWf6TrbP84pwfOZOOOy2cbiNPHcTLUkIlSA9yI8bNY=; b=4OaiDOlBre62j+3KYlYoyqnOIk
	LgytwqfZW2Tu1wdsvVbfdgjbxdG24WTOwIFMpJ4/IXFujsHzWPqEdC0HQG0ZWXKAlCQOttviOyhDg
	hqWRlVicL06RGmCZitj85RUqb2aND8mDC8yAZdvUmcLYUoMVtbb2UGP0ldCyOUbdWx5Z44p/STNgX
	82K8v1qFLMFfXOYiPzxBLO5n75Sb0HXmJ3vwKVc2eLLH2TTCjlaN7BehRt7qlnqsVmNxLsDUWN8OK
	LiTRK95pssvtSAIVPQkaYbEDX5XAsKl7GlFUhqdUQ3J1ud7c74ghq9bClEpZk55zZpnXgKe8i//ds
	ZNSaLzOw==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88Wf-0000000C7IC-1cSk;
	Mon, 13 Oct 2025 02:43:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: remove xlog_in_core_2_t
Date: Mon, 13 Oct 2025 11:42:10 +0900
Message-ID: <20251013024228.4109032-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024228.4109032-1-hch@lst.de>
References: <20251013024228.4109032-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xlog_in_core_2_t is a really odd type, not only is it grossly
misnamed because it actually is an on-disk structure, but it also
reprents the actual on-disk structure in a rather odd way.

A v1 or small v2 log header look like:

	+-----------------------+
	|      xlog_record      |
	+-----------------------+

while larger v2 log headers look like:

	+-----------------------+
	|      xlog_record      |
	+-----------------------+
	|  xlog_rec_ext_header  |
	+-------------------+---+
	|         .....         |
	+-----------------------+
	|  xlog_rec_ext_header  |
	+-----------------------+

I.e., the ext headers are a variable sized array at the end of the
header.  So instead of declaring a union of xlog_rec_header,
xlog_rec_ext_header and padding to BBSIZE, add the proper padding to
struct struct xlog_rec_header and struct xlog_rec_ext_header, and
add a variable sized array of the latter to the former.  This also
exposes the somewhat unusual scope of the log checksums, which is
made explicitly now by adding proper padding and macro designating
the actual payload length.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 31 +++++++++++++++----------------
 fs/xfs/libxfs/xfs_ondisk.h     |  6 ++++--
 fs/xfs/xfs_log.c               | 21 ++++++---------------
 fs/xfs/xfs_log_priv.h          |  3 +--
 4 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 91a841ea5bb3..4cb69bd285ca 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -126,6 +126,16 @@ struct xlog_op_header {
 #define XLOG_FMT XLOG_FMT_LINUX_LE
 #endif
 
+struct xlog_rec_ext_header {
+	__be32		xh_cycle;	/* write cycle of log */
+	__be32		xh_cycle_data[XLOG_CYCLE_DATA_SIZE];
+	__u8		xh_reserved[252];
+};
+
+/* actual ext header payload size for checksumming */
+#define XLOG_REC_EXT_SIZE \
+	offsetofend(struct xlog_rec_ext_header, xh_cycle_data)
+
 typedef struct xlog_rec_header {
 	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
 	__be32	  h_cycle;	/* write cycle of log			:  4 */
@@ -161,30 +171,19 @@ typedef struct xlog_rec_header {
 	 * (little-endian) architectures.
 	 */
 	__u32	  h_pad0;
+
+	__u8	  h_reserved[184];
+	struct xlog_rec_ext_header h_ext[];
 } xlog_rec_header_t;
 
 #ifdef __i386__
 #define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_size)
-#define XLOG_REC_SIZE_OTHER	sizeof(struct xlog_rec_header)
+#define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_pad0)
 #else
-#define XLOG_REC_SIZE		sizeof(struct xlog_rec_header)
+#define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_pad0)
 #define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
 #endif /* __i386__ */
 
-typedef struct xlog_rec_ext_header {
-	__be32	  xh_cycle;	/* write cycle of log			: 4 */
-	__be32	  xh_cycle_data[XLOG_CYCLE_DATA_SIZE];		/*	: 256 */
-} xlog_rec_ext_header_t;
-
-/*
- * Quite misnamed, because this union lays out the actual on-disk log buffer.
- */
-typedef union xlog_in_core2 {
-	xlog_rec_header_t	hic_header;
-	xlog_rec_ext_header_t	hic_xheader;
-	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
-
 /* not an on-disk structure, but needed by log recovery in userspace */
 struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 7bfa3242e2c5..2e9715cc1641 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -174,9 +174,11 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		328);
-	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	260);
+	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		512);
+	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	512);
 
+	XFS_CHECK_OFFSET(struct xlog_rec_header, h_reserved,		328);
+	XFS_CHECK_OFFSET(struct xlog_rec_ext_header, xh_reserved,	260);
 	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index acddab467b77..1fe3abbd3d36 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1526,12 +1526,8 @@ xlog_pack_data(
 		dp += BBSIZE;
 	}
 
-	if (xfs_has_logv2(log->l_mp)) {
-		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)iclog->ic_header;
-
-		for (i = 1; i < log->l_iclog_heads; i++)
-			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
-	}
+	for (i = 0; i < log->l_iclog_heads - 1; i++)
+		rhead->h_ext[i].xh_cycle = cycle_lsn;
 }
 
 /*
@@ -1556,16 +1552,11 @@ xlog_cksum(
 
 	/* ... then for additional cycle data for v2 logs ... */
 	if (xfs_has_logv2(log->l_mp)) {
-		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
-		int		i;
-		int		xheads;
+		int		xheads, i;
 
-		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE);
-
-		for (i = 1; i < xheads; i++) {
-			crc = crc32c(crc, &xhdr[i].hic_xheader,
-				     sizeof(struct xlog_rec_ext_header));
-		}
+		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE) - 1;
+		for (i = 0; i < xheads; i++)
+			crc = crc32c(crc, &rhead->h_ext[i], XLOG_REC_EXT_SIZE);
 	}
 
 	/* ... and finally for the payload */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f1aed6e8f747..ac98ac71152d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -716,11 +716,10 @@ xlog_item_space(
 static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
 {
 	if (i >= XLOG_CYCLE_DATA_SIZE) {
-		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
 		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
 		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
 
-		return &xhdr[j].hic_xheader.xh_cycle_data[k];
+		return &rhead->h_ext[j - 1].xh_cycle_data[k];
 	}
 
 	return &rhead->h_cycle_data[i];
-- 
2.47.3

