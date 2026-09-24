Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2545D915
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244412; cv=none; b=miYE8HZ0konEA/yImB9irnQPMjr/Iw13w4IB36L59l3x82JMcCXOv7mnZsVfzEK1rxQurBAZv9wHFCXo4Fe6cl0+GpdTh8LCOjC8qLGCMjJPA0o6A6byYaQYzg13q84yYy8C+K2cUf62s4zVexpvr+0CsVheZlb6gVaIu7z9IP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244412; c=relaxed/simple;
	bh=HuFv+dhy/fe+CotDy0cxcs2tiEo82ipiD0yaJktHeHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4autSJoe1kr7czhlV0XlP0DcWJ7eNzO2XcFoR4+69GywW1Hwc5FxGJqk0qJlBs+uU5CIrUYJwZOm5UyyE3/a4k90R33wAna+6EfvWR1lJedSsV1HcisRAuVQixhYt7sExzCvEjnlPY1OWiNxTQl8TVFIUOgfv8CUnzicwgbE6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QemZVMuX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QemZVMuX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=60wpukGARQwRegZIW9MaxB9Oqgl4YcBU8SEhn2pPstk=; b=QemZVMuXlD90mFDKWFUykRr9hv
	9jb824Ccc4t0qaI0VG/rEP8pLtRnmaw/lKTcNcUWsziuPERqLxrKMpKwGlkqJGhEMIVWjJWe+u0eA
	e9vaProFRtgOQKjwHsuDujMYMUb1zqHcCHnVBx800mXMf9E8sMOv8XjUfcz6Z4JnNDWeZJA30hgYv
	pkAKlnUfzGtVxYoJYmMaGwsJZpLwcZn4R5Zm6pyqU12Dwd/QHFiTU/niripfhDCLXGorUYvUJm7dq
	F7rk0aPPo5OVGHpwuaOOQWH8BzwubojJWa+YEg9zOAAxPronDPzxoZFU+mvo8iLSoCS+w0lAuYMuq
	SXrGB4CA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLf-0000000AfR0-2N9Q;
	Thu, 24 Sep 2026 10:06:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 21/32] xfs: add support for per-RTG csum files
Date: Thu, 24 Sep 2026 12:04:11 +0200
Message-ID: <20260924100512.2733748-22-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: b9f4a597a9dcf00b8f22badb5d81d0f8c5584beb

Add the definitions for another per-RTG file that stores data checksums
for the RTG.  The file is fully preallocated at mkfs/growfs time, and
thus bmap lookups for it can be performed without taking locks.

Checksums are organized in fixed size large (initially 32Kib or 64KiB)
blocks to reduce the lookup and read overhead compare to using the
smaller file system block size.

Each block uses the standard RT file header for self-describing metadata
and can thus reuse the buf_ops including the verifier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_cksum.h      |   7 +-
 libxfs/xfs_health.h     |   4 +-
 libxfs/xfs_rtbitmap.c   |  10 +++
 libxfs/xfs_rtcsumfile.c |  94 +++++++++++++++++++++++++
 libxfs/xfs_rtcsumfile.h | 150 ++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.c    |  10 +++
 libxfs/xfs_rtgroup.h    |   6 ++
 libxfs/xfs_shared.h     |   1 +
 8 files changed, 280 insertions(+), 2 deletions(-)
 create mode 100644 libxfs/xfs_rtcsumfile.c
 create mode 100644 libxfs/xfs_rtcsumfile.h

diff --git a/libxfs/xfs_cksum.h b/libxfs/xfs_cksum.h
index 999a290cfd72..315b85ff78ae 100644
--- a/libxfs/xfs_cksum.h
+++ b/libxfs/xfs_cksum.h
@@ -2,7 +2,12 @@
 #ifndef _XFS_CKSUM_H
 #define _XFS_CKSUM_H 1
 
-#define XFS_CRC_SEED	(~(uint32_t)0)
+/*
+ * crc32c() does not include the inversion at the beginning and end, while
+ * crc64_nvme() does.
+ */
+#define XFS_CRC_SEED		(~(uint32_t)0)
+#define XFS_CRC64_SEED		0
 
 /*
  * Calculate the intermediate checksum for a buffer that has the CRC field
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 1d45cf5789e8..349093e75268 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -72,6 +72,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RG_SUMMARY	(1 << 2)  /* rt groups summary */
 #define XFS_SICK_RG_RMAPBT	(1 << 3)  /* reverse mappings */
 #define XFS_SICK_RG_REFCNTBT	(1 << 4)  /* reference counts */
+#define XFS_SICK_RG_CSUM	(1 << 5)  /* data checksums */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -119,7 +120,8 @@ struct xfs_rtgroup;
 				 XFS_SICK_RG_BITMAP | \
 				 XFS_SICK_RG_SUMMARY | \
 				 XFS_SICK_RG_RMAPBT | \
-				 XFS_SICK_RG_REFCNTBT)
+				 XFS_SICK_RG_REFCNTBT | \
+				 XFS_SICK_RG_CSUM)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 3abc495c2a3c..50f89f668889 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -122,9 +122,18 @@ const struct xfs_buf_ops xfs_rtsummary_buf_ops = {
 	.verify_struct	= xfs_rtbuf_verify,
 };
 
+const struct xfs_buf_ops xfs_rtcsum_buf_ops = {
+	.name		= "xfs_rtcsum",
+	.magic		= { 0, cpu_to_be32(XFS_RTCSUM_MAGIC) },
+	.verify_read	= xfs_rtbuf_verify_read,
+	.verify_write	= xfs_rtbuf_verify_write,
+	.verify_struct	= xfs_rtbuf_verify,
+};
+
 static const struct xfs_buf_ops *xfs_rtblock_buf_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_SUMMARY]	= &xfs_rtsummary_buf_ops,
 	[XFS_RTGI_BITMAP]	= &xfs_rtbitmap_buf_ops,
+	[XFS_RTGI_CSUM]		= &xfs_rtcsum_buf_ops,
 };
 
 const struct xfs_buf_ops *
@@ -140,6 +149,7 @@ xfs_rtblock_ops(
 static enum xfs_blft xfs_rtblock_buf_types[XFS_RTGI_MAX] = {
 	[XFS_RTGI_SUMMARY]	= XFS_BLFT_RTSUMMARY_BUF,
 	[XFS_RTGI_BITMAP]	= XFS_BLFT_RTBITMAP_BUF,
+	[XFS_RTGI_CSUM]		= XFS_BLFT_RTCSUM_BUF,
 };
 
 /* Release cached rt bitmap and summary buffers. */
diff --git a/libxfs/xfs_rtcsumfile.c b/libxfs/xfs_rtcsumfile.c
new file mode 100644
index 000000000000..fc71c52beafd
--- /dev/null
+++ b/libxfs/xfs_rtcsumfile.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Christoph Hellwig.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_bmap.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans.h"
+#include "xfs_error.h"
+#include "xfs_health.h"
+#include "xfs_rtcsumfile.h"
+
+int
+xfs_rtcsum_bmap(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno,
+	xfs_daddr_t		*daddr)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*csumip = rtg_csum(rtg);
+	struct xfs_ifork	*ifp = &csumip->i_df;
+	unsigned int		csum_block = xfs_rgb_to_rtcsumblock(mp, rgbno);
+	xfs_fileoff_t		start_fsb =
+		XFS_B_TO_FSB(mp, mp->m_rtcsum_bsize) * csum_block;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+
+	ASSERT(!xfs_need_iread_extents(ifp));
+
+	if (XFS_IS_CORRUPT(mp, ifp->if_nextents != 1))
+		goto sick;
+
+	/*
+	 * We can do an unlocked lookup here because the bmap btree for the
+	 * csum files is immutable once created.
+	 */
+	if (XFS_IS_CORRUPT(mp, !xfs_iext_lookup_extent(csumip, ifp, start_fsb,
+			&icur, &got)))
+		goto sick;
+	if (XFS_IS_CORRUPT(mp, got.br_startoff > start_fsb))
+		goto sick;
+
+	start_fsb -= got.br_startoff;
+	*daddr = XFS_FSB_TO_DADDR(mp, got.br_startblock + start_fsb);
+	return 0;
+sick:
+	xfs_rtginode_mark_sick(rtg, XFS_RTGI_CSUM);
+	return -EFSCORRUPTED;
+}
+
+xfs_off_t
+xfs_rtcsum_file_size(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	uint64_t		raw_size;
+
+	raw_size = (xfs_off_t)rtg_blocks(rtg) << mp->m_rtcsum_shift;
+	return DIV_ROUND_UP_ULL(raw_size, xfs_rtcsum_payload_size(mp)) *
+			mp->m_rtcsum_bsize;
+}
+
+int
+xfs_rtcsum_alloc_blocks(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	return xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_CSUM, 0,
+			XFS_B_TO_FSB(mp, rtg_csum(rtg)->i_disk_size),
+			XFS_B_TO_FSB(mp, mp->m_rtcsum_bsize),
+			XFS_BMAPI_CONTIG, NULL);
+}
+
+int
+xfs_rtcsum_create(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	bool			init)
+{
+	ip->i_disk_size = xfs_rtcsum_file_size(rtg);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/libxfs/xfs_rtcsumfile.h b/libxfs/xfs_rtcsumfile.h
new file mode 100644
index 000000000000..8aacac05adc3
--- /dev/null
+++ b/libxfs/xfs_rtcsumfile.h
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _XFS_RTCSUMFILE_H
+#define _XFS_RTCSUMFILE_H
+
+#include "xfs_rtgroup.h"
+
+/*
+ * Maximum size of a checksum buffer for writes, used for the log reservation.
+ */
+#define XFS_RTCSUM_MAX_WRITE	SZ_64K
+
+/*
+ * Size of the actual payload in the RT data checksum block.  This excludes the
+ * self-describing metadata header.
+ */
+static inline unsigned int
+xfs_rtcsum_payload_size(
+	struct xfs_mount	*mp)
+{
+	return mp->m_rtcsum_bsize - sizeof(struct xfs_rtbuf_blkinfo);
+}
+
+/* Convert data length in logical blocks to checksum length in bytes. */
+static inline unsigned int
+xfs_extlen_to_rtcsum_len(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		nb)
+{
+	return nb << mp->m_rtcsum_shift;
+}
+
+/* Convert checksum length in bytes to data length in logical blocks. */
+static inline xfs_extlen_t
+xfs_rtcsum_len_to_extlen(
+	struct xfs_mount	*mp,
+	unsigned int		csum_len)
+{
+	return csum_len >> mp->m_rtcsum_shift;
+}
+
+/* Convert an rgbno to the csum byte position in the csum file. */
+static inline xfs_off_t
+xfs_rgb_to_rtcsumpos(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rgbno)
+{
+	return (xfs_off_t)rgbno << mp->m_rtcsum_shift;
+}
+
+/* Convert an rgbno to the csum block index in the csum file. */
+static inline unsigned int
+xfs_rgb_to_rtcsumblock(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rgbno)
+{
+	return div_u64(xfs_rgb_to_rtcsumpos(mp, rgbno),
+			xfs_rtcsum_payload_size(mp));
+}
+
+/* Convert an rgbno to a the checksum offset within an rt csum block. */
+static inline unsigned int
+xfs_rgb_to_rtcsumoff(
+	struct xfs_mount	*mp,
+	xfs_rgblock_t		rgbno)
+{
+	uint32_t		off;
+
+	div_u64_rem(xfs_rgb_to_rtcsumpos(mp, rgbno),
+			xfs_rtcsum_payload_size(mp), &off);
+	return sizeof(struct xfs_rtbuf_blkinfo) + off;
+}
+
+/* Convert an rtbno to a the checksum offset within an rt csum block. */
+static inline unsigned int
+xfs_rtb_to_rtcsumoff(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		fsbno)
+{
+	return xfs_rgb_to_rtcsumoff(mp, xfs_rtb_to_rgbno(mp, fsbno));
+}
+
+int xfs_rtcsum_bmap(struct xfs_rtgroup *rtg, xfs_rgblock_t rgbno,
+		xfs_daddr_t *daddr);
+xfs_off_t xfs_rtcsum_file_size(struct xfs_rtgroup *rtg);
+int xfs_rtcsum_alloc_blocks(struct xfs_rtgroup *rtg);
+int xfs_rtcsum_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
+
+static inline unsigned int
+xfs_rtcsum_bufs_per_rtg(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	if (xfs_has_rtcsum(mp))
+		return div_u64(xfs_rtcsum_file_size(rtg), mp->m_rtcsum_bsize);
+	return 0;
+}
+
+static inline xfs_filblks_t
+xfs_rtcsum_max_len(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno)
+{
+	return xfs_rtcsum_len_to_extlen(mp,
+			mp->m_rtcsum_bsize - xfs_rtb_to_rtcsumoff(mp, fsbno));
+}
+
+union xfs_csum {
+	uint32_t		crc32c;
+	uint64_t		crc64;
+};
+
+static __always_inline void
+xfs_csum_seed(
+	struct xfs_mount	*mp,
+	union xfs_csum		*csum)
+{
+	if (mp->m_sb.sb_rtcsum_type == XFS_CSUM_TYPE_CRC32C)
+		csum->crc32c = XFS_CRC_SEED;
+	else
+		csum->crc64 = XFS_CRC64_SEED;
+}
+
+static __always_inline void
+xfs_csum_gen(
+	struct xfs_mount	*mp,
+	void			*data,
+	unsigned int		len,
+	union xfs_csum		*csum)
+{
+	if (mp->m_sb.sb_rtcsum_type == XFS_CSUM_TYPE_CRC32C)
+		csum->crc32c = crc32c(csum->crc32c, data, len);
+	else
+		csum->crc64 = crc64_nvme(csum->crc64, data, len);
+}
+
+static __always_inline void
+xfs_csum_finalize(
+	struct xfs_mount	*mp,
+	union xfs_disk_csum	*to,
+	union xfs_csum		*csum)
+{
+	if (mp->m_sb.sb_rtcsum_type == XFS_CSUM_TYPE_CRC32C)
+		to->crc32c = cpu_to_le32(~csum->crc32c);
+	else
+		to->crc64 = cpu_to_le64(csum->crc64);
+}
+
+#endif /* _XFS_RTCSUMFILE_H */
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index c1f8d2cb186a..dcacdf4c9c13 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -33,6 +33,7 @@
 #include "xfs_metadir.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_rtcsumfile.h"
 
 /* Find the first usable fsblock in this rtgroup. */
 static inline uint32_t
@@ -392,6 +393,15 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.enabled	= xfs_has_reflink,
 		.create		= xfs_rtrefcountbt_create,
 	},
+	[XFS_RTGI_CSUM] = {
+		.name		= "csum",
+		.metafile_type	= XFS_METAFILE_RTCSUM,
+		.sick		= XFS_SICK_RG_CSUM,
+		.fmt_mask	= (1U << XFS_DINODE_FMT_EXTENTS) |
+				  (1U << XFS_DINODE_FMT_BTREE),
+		.enabled	= xfs_has_rtcsum,
+		.create		= xfs_rtcsum_create,
+	},
 };
 
 /* Return the shortname of this rtgroup inode. */
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 2aa6d4e59cc3..4b8e6b526deb 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -16,6 +16,7 @@ enum xfs_rtg_inodes {
 	XFS_RTGI_SUMMARY,	/* allocation summary */
 	XFS_RTGI_RMAP,		/* rmap btree inode */
 	XFS_RTGI_REFCOUNT,	/* refcount btree inode */
+	XFS_RTGI_CSUM,		/* data checksum inode */
 
 	XFS_RTGI_MAX,
 };
@@ -109,6 +110,11 @@ static inline struct xfs_inode *rtg_refcount(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_inodes[XFS_RTGI_REFCOUNT];
 }
 
+static inline struct xfs_inode *rtg_csum(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_inodes[XFS_RTGI_CSUM];
+}
+
 /* Passive rtgroup references */
 static inline struct xfs_rtgroup *
 xfs_rtgroup_get(
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index b1e0d9bc1f7d..8a60f2c56fe7 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -40,6 +40,7 @@ extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
 extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
+extern const struct xfs_buf_ops xfs_rtcsum_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops;
-- 
2.53.0

