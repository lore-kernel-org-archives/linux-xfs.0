Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA20446AA85;
	Thu, 24 Sep 2026 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244108; cv=none; b=i9fdVnva3tXOTwBOk7OcFJ2xEdkemJsICvF1ZXADBPdN5wvD/2UHTuLIQlQd2RE/nyqDr9o8Sd98oop7zXMxanmI+KghM0seGUw/JcFdYcDnkuLPbNYpuk3KTiVXquyfoUkjhUA1fCcJxOOJ58uylIF8HwwASlAvAzuyZF17Bh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244108; c=relaxed/simple;
	bh=jixoMfPlOALzSvodHPR6QuGSRy9b295sSCd3j2LBj5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwebQ0HiSbSmUEIb8k4Ikbc+sbsZdbIKMdZkDvwr2dw9h4nIqIXFj2sm4rJzaYdvExDfIXXUdi01BBzWYoYrwybzDaEh6U4zPWWgxr+uCNbqLeLpSmHKKyXUEyn4E32QOK7M5ez2ZoAHvrDalymo2DjGmDlb+cztInPuYgosZJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Lhl7l5o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Lhl7l5o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t6Hc+5RLBHAklx6PoQQzU3UhI/fQtGi95i6zobXj7H4=; b=3Lhl7l5o3CAiN3XjtuoKCzF9ej
	qpl+4j71D+VBDjzxDBRTrSMZKFMJmSUNR+DCPYnWUoZPSyyhFmo9k8m4PywpAFwegg+7mWvp87Zgk
	dS9qCwt/OWvTT9PAcYaIwaa3r+gQ9CElzyWH8O0c3EAioF3PZGQLe2bmfW0htdry4t1zsuOa4B5e6
	Y7SdEDdL69iyYJ1M63ypCY00UwxI2DP840rjajOESd8ClBchP9CxGO7iw6YGQFKgaUQGOzvBjLnbF
	tsIiXnGgFIpn3ALFbEiLDM6320+laSaMlf3wLx61G8QDsgl6qcHGqJyA1tvbbMt99Hc7aWyaGCpDO
	1BZZIaKw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gGq-0000000AeZh-37jA;
	Thu, 24 Sep 2026 10:01:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 11/21] xfs: core RT data checksum support
Date: Thu, 24 Sep 2026 11:59:43 +0200
Message-ID: <20260924100032.2733101-12-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Support reading and writing of data checksum buffers, and generating
and verifying the checksum.

All data checksum buffers for an open zone are pre-allocated at zone open
time, so that we never have to read in a partially written buffer as part
of a data write, which would otherwise impose very expensive seeks and
stall writes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Kconfig          |   1 +
 fs/xfs/Makefile         |   1 +
 fs/xfs/xfs_inode.h      |   5 +
 fs/xfs/xfs_rtcsum.c     | 317 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtcsum.h     |  23 +++
 fs/xfs/xfs_super.c      |  14 ++
 fs/xfs/xfs_sysfs.c      |   2 +
 fs/xfs/xfs_zone_alloc.c |  32 +++-
 fs/xfs/xfs_zone_priv.h  |   8 +
 9 files changed, 399 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/xfs_rtcsum.c
 create mode 100644 fs/xfs/xfs_rtcsum.h

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index b99da294e9a3..424a04b507a6 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -106,6 +106,7 @@ config XFS_RT
 	bool "XFS Realtime subvolume support"
 	depends on XFS_FS
 	default BLK_DEV_ZONED
+	select CRC64
 	help
 	  If you say Y here you will be able to mount and use XFS filesystems
 	  which contain a realtime subvolume.  The realtime subvolume is a
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 79ea4136fbba..0d57bf0701ec 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -142,6 +142,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
+				   xfs_rtcsum.o \
 				   xfs_zone_alloc.o \
 				   xfs_zone_gc.o \
 				   xfs_zone_info.o \
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 34c1038ebfcd..9ed2fbfe86ff 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -376,6 +376,11 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
 	return xfs_can_sw_atomic_write(ip->i_mount);
 }
 
+static inline bool xfs_is_rtcsum_inode(const struct xfs_inode *ip)
+{
+	return xfs_has_rtcsum(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
+}
+
 /*
  * In-core inode flags.
  */
diff --git a/fs/xfs/xfs_rtcsum.c b/fs/xfs/xfs_rtcsum.c
new file mode 100644
index 000000000000..7cdc5a5029eb
--- /dev/null
+++ b/fs/xfs/xfs_rtcsum.c
@@ -0,0 +1,317 @@
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
+#include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
+#include "xfs_trans_space.h"
+#include "xfs_error.h"
+#include "xfs_health.h"
+#include "xfs_rtcsum.h"
+#include "xfs_zone_priv.h"
+#include <linux/iomap.h>
+
+static_assert(IOMAP_CSUM_MAX_SIZE <= XFS_RTCSUM_MAX_WRITE);
+
+static const char *xfs_data_csum_names[XFS_CSUM_TYPE_MAX] = {
+	[XFS_CSUM_TYPE_CRC32C]	= "crc32c",
+	[XFS_CSUM_TYPE_CRC64]	= "crc64",
+};
+
+int
+xfs_csum_verify(
+	struct xfs_mount	*mp,
+	struct bio		*bio,
+	struct bvec_iter	*iter,
+	void			*csum_buf,
+	xfs_fsblock_t		bno,
+	bool			verbose)
+{
+	unsigned int		bsize = mp->m_sb.sb_blocksize;
+	unsigned int		csum_size = 1u << mp->m_rtcsum_shift;
+	unsigned int		offset = 0;
+	union xfs_csum		csum;
+	union xfs_disk_csum	dsum;
+
+	do {
+		struct bio_vec	bv = mp_bvec_iter_bvec(bio->bi_io_vec, *iter);
+
+		if (offset == 0)
+			xfs_csum_seed(mp, &csum);
+		bv.bv_len = min(bv.bv_len, bsize - offset);
+		xfs_csum_gen(mp, bvec_virt(&bv), bv.bv_len, &csum);
+		offset += bv.bv_len;
+		if (offset == bsize) {
+			xfs_csum_finalize(mp, &dsum, &csum);
+			if (unlikely(memcmp(&dsum, csum_buf, csum_size) != 0))
+				goto mismatch;
+			bno++;
+			csum_buf += csum_size;
+			offset = 0;
+		}
+		bio_advance_iter_single(bio, iter, bv.bv_len);
+	} while (iter->bi_size);
+
+	return 0;
+
+mismatch:
+	if (verbose) {
+		xfs_warn_ratelimited(mp,
+"data csum mismatch for rtblock 0x%llx: 0x%*phN (expected 0x%*phN)",
+			bno, csum_size, &csum, csum_size, csum_buf);
+	}
+	return -EIO;
+}
+
+void
+xfs_csum_generate(
+	struct xfs_mount	*mp,
+	struct bio		*bio,
+	void			*csum_buf)
+{
+	struct bvec_iter	iter = bio->bi_iter;
+	unsigned int		bsize = mp->m_sb.sb_blocksize;
+	unsigned int		csum_size = 1u << mp->m_rtcsum_shift;
+	unsigned int		offset = 0;
+	union xfs_csum		csum;
+
+	do {
+		struct bio_vec	bv = mp_bvec_iter_bvec(bio->bi_io_vec, iter);
+
+		if (offset == 0)
+			xfs_csum_seed(mp, &csum);
+		bv.bv_len = min(bv.bv_len, bsize - offset);
+		xfs_csum_gen(mp, bvec_virt(&bv), bv.bv_len, &csum);
+		offset += bv.bv_len;
+		if (offset == bsize) {
+			xfs_csum_finalize(mp, csum_buf, &csum);
+			csum_buf += csum_size;
+			offset = 0;
+		}
+		bio_advance_iter_single(bio, &iter, bv.bv_len);
+	} while (iter.bi_size);
+}
+
+/*
+ * Read the checksum buffer for @rtg/@csum_off and return it unlocked.
+ *
+ * We don't need to lock read access to the buffer because checksums will not
+ * change until the @rtg is reset.
+ */
+int
+xfs_rtcsum_read_async(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		fsbno,
+	struct xfs_buf		**bpp)
+{
+	xfs_daddr_t		csum_daddr;
+	struct xfs_rtgroup	*rtg;
+	int			error;
+
+	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, fsbno));
+	if (!rtg)
+		return -EFSCORRUPTED;
+	error = xfs_rtcsum_bmap(rtg, xfs_rtb_to_rgbno(mp, fsbno), &csum_daddr);
+	if (!error)
+		error = xfs_buf_read_async(mp->m_ddev_targp, csum_daddr,
+				BTOBB(mp->m_rtcsum_bsize), &xfs_rtcsum_buf_ops,
+				bpp);
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+
+/*
+ * When opening a zone for writing, do a speculative buf_get for each csum
+ * buffer.  This ensures we usually have a buffer in-memory when we actually
+ * start writing to it.
+ *
+ * Without this we'd have to read the buffer from disk, as we don't know if
+ * anyone has already written to it by the time we get to the buffer due to
+ * completion reordering.
+ *
+ * When reopening a partially written zone at mount time, just read ahead
+ * the entire csums for the zone.
+ */
+int
+xfs_rtcsum_open_zone(
+	struct xfs_open_zone	*oz)
+{
+	struct xfs_rtgroup	*rtg = oz->oz_rtg;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rgblock_t		rgbno = 0;
+	int			i, error;
+
+	for (i = 0; i < oz->oz_nr_csum_bufs; i++) {
+		xfs_daddr_t	csum_daddr;
+		struct xfs_buf	*bp;
+
+		error = xfs_rtcsum_bmap(rtg, rgbno, &csum_daddr);
+		if (error)
+			goto out_error;
+
+		if (oz->oz_allocated) {
+			error = xfs_buf_read_async(mp->m_ddev_targp, csum_daddr,
+					BTOBB(mp->m_rtcsum_bsize),
+					&xfs_rtcsum_buf_ops, &bp);
+		} else {
+			error = xfs_buf_get(mp->m_ddev_targp, csum_daddr,
+					BTOBB(mp->m_rtcsum_bsize), &bp);
+			if (!error) {
+				bp->b_flags = XBF_DONE;
+				xfs_rtfile_initialize_buf(rtg, XFS_RTGI_CSUM,
+						bp, NULL);
+			}
+			xfs_buf_unlock(bp);
+		}
+		if (error)
+			goto out_error;
+		oz->oz_csum_bufs[i] = bp;
+		rgbno += (xfs_rtcsum_payload_size(mp) /
+			  (1u << mp->m_rtcsum_shift));
+	}
+
+	return 0;
+
+out_error:
+	while (--i >= 0)
+		xfs_buf_rele(oz->oz_csum_bufs[i]);
+	return error;
+}
+
+void
+xfs_rtcsum_free_zone(
+	struct xfs_open_zone	*oz)
+{
+	unsigned int		i;
+
+	for (i = 0; i < oz->oz_nr_csum_bufs; i++)
+		xfs_buf_rele(oz->oz_csum_bufs[i]);
+}
+
+static int
+xfs_rtcsum_log_one(
+	struct xfs_open_zone	*oz,
+	xfs_rgblock_t		rgbno,
+	const void		*csum,
+	xfs_extlen_t		nfsb,
+	struct xfs_trans	*tp,
+	xfs_extlen_t		*nr)
+{
+	struct xfs_rtgroup	*rtg = oz->oz_rtg;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	unsigned int		boff = xfs_rgb_to_rtcsumoff(mp, rgbno);
+	struct xfs_buf		*bp;
+	unsigned int		len;
+	int			error;
+
+	bp = oz->oz_csum_bufs[xfs_rgb_to_rtcsumblock(mp, rgbno)];
+	error = xfs_buf_read_async_wait(bp);
+	if (error) {
+		if (xfs_metadata_is_sick(error))
+			xfs_rtginode_mark_sick(rtg, XFS_RTGI_CSUM);
+		return error;
+	}
+
+	xfs_buf_hold(bp);
+	xfs_buf_lock(bp);
+	xfs_trans_bjoin(tp, bp);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_RTCSUM_BUF);
+
+	*nr = min(nfsb,
+		xfs_rtcsum_len_to_extlen(mp, mp->m_rtcsum_bsize - boff));
+	len = xfs_extlen_to_rtcsum_len(mp, *nr);
+	memcpy(bp->b_addr + boff, csum, len);
+
+	/*
+	 * Avoid realloc churn as we're filling the buffer (almost) sequentially
+	 * and rather fast.
+	 */
+	bp->b_log_item->bli_flags |= XFS_BLI_PREALLOC;
+	xfs_trans_log_buf(tp, bp, boff, boff + len - 1);
+	return 0;
+}
+
+int
+xfs_rtcsum_log(
+	struct xfs_open_zone	*oz,
+	xfs_daddr_t		daddr,
+	unsigned int		data_len,
+	const void		*csum)
+{
+	struct xfs_mount	*mp = rtg_mount(oz->oz_rtg);
+	xfs_rgblock_t		rgbno = xfs_daddr_to_rgbno(mp, daddr);
+	xfs_extlen_t		nfsb = XFS_B_TO_FSB(mp, data_len);
+	struct xfs_trans_res	tres = M_RES(mp)->tr_csum;
+	struct xfs_trans	*tp;
+	int			error;
+
+	tres.tr_logres = xfs_calc_csum_reservation(mp,
+				xfs_extlen_to_rtcsum_len(mp, nfsb));
+	ASSERT(tres.tr_logres <= M_RES(mp)->tr_csum.tr_logres);
+
+	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	do {
+		xfs_extlen_t nr;
+
+		error = xfs_rtcsum_log_one(oz, rgbno, csum, nfsb, tp, &nr);
+		if (error)
+			goto out_trans_cancel;
+		rgbno += nr;
+		nfsb -= nr;
+		csum += xfs_extlen_to_rtcsum_len(mp, nr);
+	} while (nfsb);
+
+	return xfs_trans_commit(tp);
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+int
+xfs_rtcsum_mount(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * Supporting highmem would require less efficient loops for the
+	 * checksumming.  We could do that with a separate code path, but
+	 * there isn't much of a point in the extra test coverage required just
+	 * for obsolete 32-bit platforms.
+	 */
+	if (IS_ENABLED(CONFIG_HIGHMEM)) {
+		xfs_alert(mp,
+"CONFIG_HIGHMEM not supported with data checksums.");
+		return -EINVAL;
+	}
+
+	/*
+	 * We can't support data checksums on DAX because the direct access
+	 * doesn't allow computing and verifying the checksums.
+	 */
+	if (xfs_has_dax_always(mp)) {
+		xfs_warn(mp, "dax=always not supported with data checksums");
+		return -EINVAL;
+	}
+	mp->m_features |= XFS_FEAT_DAX_NEVER;
+
+	xfs_info(mp, "using %s for RT device data checksums",
+		xfs_data_csum_names[mp->m_sb.sb_rtcsum_type]);
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_rtcsum.h b/fs/xfs/xfs_rtcsum.h
new file mode 100644
index 000000000000..bd16f5a99451
--- /dev/null
+++ b/fs/xfs/xfs_rtcsum.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _XFS_RTCSUM_H
+#define _XFS_RTCSUM_H
+
+#include "xfs_rtcsumfile.h"
+
+void xfs_csum_generate(struct xfs_mount *mp, struct bio *bio,
+		void *csum_buf);
+int xfs_csum_verify(struct xfs_mount *mp, struct bio *bio,
+		struct bvec_iter *iter, void *csum_buf,
+		xfs_fsblock_t bno, bool verbose);
+
+int xfs_rtcsum_read_async(struct xfs_mount *mp, xfs_rtblock_t fsbno,
+		struct xfs_buf **bpp);
+int xfs_rtcsum_log(struct xfs_open_zone *oz, xfs_daddr_t daddr,
+		unsigned int data_len, const void *csum);
+
+int xfs_rtcsum_open_zone(struct xfs_open_zone *oz);
+void xfs_rtcsum_free_zone(struct xfs_open_zone *oz);
+
+int xfs_rtcsum_mount(struct xfs_mount *mp);
+
+#endif /* _XFS_RTCSUM_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fce1d2905c94..5a6769239f35 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -50,6 +50,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_healthmon.h"
+#include "xfs_rtcsum.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -1953,6 +1954,19 @@ xfs_fs_fill_super(
 		}
 	}
 
+	if (xfs_has_rtcsum(mp)) {
+		if (!IS_ENABLED(CONFIG_XFS_RT) || !xfs_has_zoned(mp)) {
+			xfs_alert(mp,
+	"zoned allocator required for RT data checksums");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
+
+		error = xfs_rtcsum_mount(mp);
+		if (error)
+			goto out_filestream_unmount;
+	}
+
 	if (xfs_has_reflink(mp)) {
 		if (xfs_has_realtime(mp) &&
 		    !xfs_reflink_supports_rextsize(mp, mp->m_sb.sb_rextsize)) {
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index e77917ac179d..c1ae9b7c4cc1 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -401,6 +401,8 @@ static bool
 xfs_has_read_bounce(
 	struct xfs_mount	*mp)
 {
+	if (xfs_has_rtcsum(mp))
+		return true;
 	if (bdev_has_integrity_csum(mp->m_ddev_targp->bt_bdev))
 		return true;
 	if (mp->m_rtdev_targp &&
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bbdff9abe2b2..9d9a713684b9 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_zones.h"
 #include "xfs_trace.h"
 #include "xfs_mru_cache.h"
+#include "xfs_rtcsum.h"
 #include <linux/bio-integrity.h>
 
 static void
@@ -42,8 +43,10 @@ void
 xfs_open_zone_put(
 	struct xfs_open_zone	*oz)
 {
-	if (atomic_dec_and_test(&oz->oz_ref))
+	if (atomic_dec_and_test(&oz->oz_ref)) {
+		xfs_rtcsum_free_zone(oz);
 		call_rcu(&oz->oz_rcu, xfs_open_zone_free_rcu);
+	}
 }
 
 static inline uint32_t
@@ -416,9 +419,12 @@ xfs_init_open_zone(
 	enum rw_hint		write_hint,
 	bool			is_gc)
 {
+	unsigned int		nr_csum_bufs = xfs_rtcsum_bufs_per_rtg(rtg);
 	struct xfs_open_zone	*oz;
+	int			error;
 
-	oz = kzalloc_obj(*oz, GFP_NOFS | __GFP_NOFAIL);
+	oz = kzalloc_flex(*oz, oz_csum_bufs, nr_csum_bufs,
+			GFP_NOFS | __GFP_NOFAIL);
 	spin_lock_init(&oz->oz_alloc_lock);
 	atomic_set(&oz->oz_ref, 1);
 	oz->oz_rtg = rtg;
@@ -426,6 +432,14 @@ xfs_init_open_zone(
 	oz->oz_written = write_pointer;
 	oz->oz_write_hint = write_hint;
 	oz->oz_is_gc = is_gc;
+	oz->oz_nr_csum_bufs = nr_csum_bufs;
+	if (nr_csum_bufs) {
+		error = xfs_rtcsum_open_zone(oz);
+		if (error) {
+			kfree(oz);
+			return ERR_PTR(error);
+		}
+	}
 
 	/*
 	 * All dereferences of rtg->rtg_open_zone hold the ILOCK for the rmap
@@ -449,6 +463,7 @@ xfs_open_zone(
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
+	struct xfs_open_zone	*oz;
 	struct xfs_group	*xg;
 
 	/*
@@ -469,7 +484,14 @@ xfs_open_zone(
 	xas_unlock(&xas);
 
 	set_current_state(TASK_RUNNING);
-	return xfs_init_open_zone(to_rtg(xg), 0, write_hint, is_gc);
+	oz = xfs_init_open_zone(to_rtg(xg), 0, write_hint, is_gc);
+	if (IS_ERR(oz)) {
+		xfs_rtgroup_rele(to_rtg(xg));
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
+		return NULL;
+	}
+
+	return oz;
 }
 
 static struct xfs_open_zone *
@@ -1144,9 +1166,11 @@ xfs_init_zone(
 		/* zone is open */
 		struct xfs_open_zone *oz;
 
-		atomic_inc(&rtg_group(rtg)->xg_active_ref);
 		oz = xfs_init_open_zone(rtg, write_pointer, WRITE_LIFE_NOT_SET,
 				false);
+		if (IS_ERR(oz))
+			return PTR_ERR(oz);
+		atomic_inc(&rtg_group(rtg)->xg_active_ref);
 		list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
 		zi->zi_nr_open_zones++;
 
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index fcb57506d8e6..322a031e6ba0 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -42,6 +42,14 @@ struct xfs_open_zone {
 	struct xfs_rtgroup	*oz_rtg;
 
 	struct rcu_head		oz_rcu;
+
+	/*
+	 * Checksum buffers.  All checksum buffers for an open zone are pinned
+	 * into memory so that we never need to read them in to log checksums
+	 * for a write.
+	 */
+	unsigned int		oz_nr_csum_bufs;
+	struct xfs_buf		*oz_csum_bufs[] __counted_by(oz_nr_csum_bufs);
 };
 
 /*
-- 
2.53.0

