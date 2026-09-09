Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8EA3A5422;
	Wed,  9 Sep 2026 06:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934252; cv=none; b=eDSrnxSvz5yaB4eJjSsfelvTk1pJGbYl9A/xwIFakHVvhMasuDyKHdp2NVtkb1upsinvEoUzoJywgBMLkmRPT8vniSgCLW6uiYAGi9mRxk3U0bk1fk+Wp7NTGK4KHXTLBdB9wJB/CtaKAh3HcMqACtkFEW4OskQEG2jXtfy1E1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934252; c=relaxed/simple;
	bh=Tuba46lGps7gU4raCGE4kEAQDk7wNXQDm3npedPwd5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le/mSlZ1n2oQq+oVQPPimyVMu1WDzx299bF3yyZ4Az2zczZSK61+A4/1J/VdRUgCTi7hgn0It/a8tkDtEoADAnOMVDlIrz1dPUyOXTM2xaJxi13ELN+cvSQcTVFvS6QWGGwJ1Pb0AlHn6lVkWwTO1DphARJxzo0QvHOWjwRmL9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ChWES6HB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ChWES6HB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UlSEemVgHX4YVTjpbP6zGxIR+yTpw2xCqzmcEoK/kcs=; b=ChWES6HB7U0+lT1aHn74Pe5lui
	F8R/ULjd/Dg/HUslKaSIGri7/bQIM9lT/qCQW0wXcCm0n2dQEhz6rh62Jii9SnyJelLXdbAYJ0frR
	CuOmkHHOGwWyDTMX8legJN3yOX8YRM4dwNNdSXeITnGEyU4jUxlPCc4mheuut5/ijVthqAMnFOH8x
	rRgKB5S0M7aFoMLx83uRG0xRU0CuEBT6l208e/6iw7AUVxzWDeQF0OuiAuXju7vmWR8STcO2/Zhif
	naM7o1nR/nK9hv3p9+bBgG+igcfTtvRLWrGvVtvIUhRXzKicBQqzYUHF/Jyd6cD8n4CtV3vPNqk95
	m0ANgkxw==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BWD-0000000Aqmb-0iFk;
	Wed, 09 Sep 2026 06:10:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 13/16] xfs: add support for lazy direct read bounce buffering
Date: Wed,  9 Sep 2026 09:09:02 +0300
Message-ID: <20260909060924.1102037-14-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
References: <20260909060924.1102037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently direct I/O reads always bounce buffer the I/O to deal with
the case where userspace is modifying the buffer in-flight while
reading data into it.

This is a very expensive countermeasure for something no sane application
should do, so try to avoid it by reading without a bounce buffer first,
and retrying the read on a checksum failure.  This avoids the cost of
bounce buffering for sanely behave applications.  For the rare case of
an application regularly modifying in-flight buffers, allow forcing the
always bounce buffer behavior through sysfs.  And now that we have that
knob, allow disabling read-side bounce buffering entirely for those who
live fast and dangerous.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |   3 +-
 fs/xfs/xfs_ioend.c | 103 +++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.h |   8 ++++
 fs/xfs/xfs_super.c |   1 +
 fs/xfs/xfs_sysfs.c |  78 +++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h |   1 +
 6 files changed, 187 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 077744b3f6c3..6f25879b6510 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -271,8 +271,7 @@ xfs_file_dio_read(
 		return ret;
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
 		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
-				&xfs_dio_read_bounce_ops, IOMAP_DIO_BOUNCE,
-				NULL, 0);
+				&xfs_dio_read_bounce_ops, 0, NULL, 0);
 	} else {
 		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin);
 		if (ret == -ENOTBLK)
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index a095cf217863..4fba8558d8d2 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2016-2025 Christoph Hellwig.
+ * Copyright (c) 2016-2026 Christoph Hellwig.
  * All Rights Reserved.
  */
 #include "xfs_platform.h"
@@ -18,15 +18,101 @@
 #include "xfs_ioend.h"
 #include <linux/bio-integrity.h>
 
+static void
+xfs_dio_bounce_end_io(
+	struct bio		*bio)
+{
+	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
+	int			error = blk_status_to_errno(bio->bi_status);
+	struct bio		*orig_bio = bio->bi_private;
+
+	if ((ioend->io_flags & IOMAP_IOEND_INTEGRITY) && !bio->bi_status)
+		error = iomap_ioend_integrity_verify(ioend);
+	iomap_bounce_read_end_io(ioend, orig_bio, error);
+}
+
+static void
+xfs_bounce_submit_ioend(
+	struct iomap_ioend	*ioend)
+{
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
+		fs_bio_integrity_alloc(&ioend->io_bio);
+	ioend->io_bio.bi_end_io = xfs_dio_bounce_end_io;
+	bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+	submit_bio(&ioend->io_bio);
+}
+
+static void
+xfs_end_bio_bounced(
+	struct bio		*bio)
+{
+	/*
+	 * Just complete the original ioends as all verification is done by the
+	 * end_io handlers for the clone bio(s).
+	 */
+	iomap_finish_ioends(iomap_ioend_from_bio(bio),
+			blk_status_to_errno(bio->bi_status));
+}
+
+static void
+xfs_read_bounce_and_resubmit(
+	struct iomap_ioend	*ioend)
+{
+	struct bio		*bio = &ioend->io_bio;
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	unsigned int		nofs_flag = memalloc_nofs_save();
+
+	trace_xfs_bounce_reread(ip, ioend->io_offset, ioend->io_size);
+
+	/*
+	 * Free the bio integrity data for the original bio, as we'll allocate
+	 * a new one for each sub-I/O, which could deadlock if we keep the
+	 * integrity data for the original bio around.
+	 */
+	if (bio_integrity(bio))
+		fs_bio_integrity_free(bio);
+
+	/*
+	 * Resubmit the bio through the iomap bounce machinery.  The original
+	 * bio itself is not resubmitted to the block layer, but just used to
+	 * track I/O completion of the cloned bios.
+	 */
+	bio_prepare_reissue(bio, xfs_inode_buftarg(ip)->bt_bdev);
+	bio->bi_iter = (struct bvec_iter) {
+		.bi_sector	= ioend->io_sector,
+		.bi_size	= ioend->io_size,
+		.bi_offset	= ioend->io_bvec_offset,
+	};
+	bio->bi_end_io = xfs_end_bio_bounced;
+	iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
+			xfs_bounce_submit_ioend);
+	memalloc_nofs_restore(nofs_flag);
+}
+
 static void
 xfs_end_io_read(
 	struct bio		*bio)
 {
 	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	int			error = blk_status_to_errno(bio->bi_status);
 
-	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY))
+	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY)) {
 		error = iomap_ioend_integrity_verify(ioend);
+		if ((ioend->io_flags & IOMAP_IOEND_DIRECT) &&
+		    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_LAZY) {
+			/*
+			 * We only really need to retry for guard tag errors,
+			 * but right now we can't distinguish them from other
+			 * (i.e, reftag) errors.
+			 */
+			if (error) {
+				xfs_read_bounce_and_resubmit(ioend);
+				return;
+			}
+		}
+	}
 
 	iomap_finish_ioends(ioend, error);
 }
@@ -38,7 +124,18 @@ xfs_ioend_submit_read(
 	loff_t			file_offset,
 	u16			ioend_flags)
 {
-	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct iomap_ioend	*ioend;
+
+	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
+	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
+	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
+		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
+				xfs_bounce_submit_ioend);
+		return;
+	}
+
 	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_alloc(bio);
 	bio->bi_end_io = xfs_end_io_read;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 216a38a354e7..894ff2f4ecbd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -142,6 +142,12 @@ struct xfs_freecounter {
 	uint64_t		res_saved;
 };
 
+enum xfs_read_bounce {
+	XFS_READ_BOUNCE_NEVER,
+	XFS_READ_BOUNCE_ALWAYS,
+	XFS_READ_BOUNCE_LAZY,
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -177,6 +183,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_sync_workqueue;
 	struct workqueue_struct *m_blockgc_wq;
 	struct workqueue_struct *m_inodegc_wq;
+	enum xfs_read_bounce	m_read_bounce;
 
 	int			m_bsize;	/* fs logical block size */
 	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
@@ -291,6 +298,7 @@ typedef struct xfs_mount {
 	struct xfs_zone_info	*m_zone_info;	/* zone allocator information */
 	struct dentry		*m_debugfs;	/* debugfs parent */
 	struct xfs_kobj		m_kobj;
+	struct xfs_kobj		m_csum_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b24db75eaedc..fce1d2905c94 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2317,6 +2317,7 @@ xfs_init_fs_context(
 	mp->m_logbufs = -1;
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
+	mp->m_read_bounce = XFS_READ_BOUNCE_LAZY;
 
 	xfs_hooks_init(&mp->m_dir_update_hooks);
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index b62712187324..e77917ac179d 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -392,6 +392,71 @@ const struct kobj_type xfs_stats_ktype = {
 	.default_groups = xfs_stats_groups,
 };
 
+static inline struct xfs_mount *csum_to_mp(struct kobject *kobj)
+{
+	return container_of(to_kobj(kobj), struct xfs_mount, m_csum_kobj);
+}
+
+static bool
+xfs_has_read_bounce(
+	struct xfs_mount	*mp)
+{
+	if (bdev_has_integrity_csum(mp->m_ddev_targp->bt_bdev))
+		return true;
+	if (mp->m_rtdev_targp &&
+	    bdev_has_integrity_csum(mp->m_rtdev_targp->bt_bdev))
+		return true;
+	return false;
+}
+
+static const char * const bounce_modes[] = {
+	[XFS_READ_BOUNCE_NEVER]		= "never",
+	[XFS_READ_BOUNCE_ALWAYS]	= "always",
+	[XFS_READ_BOUNCE_LAZY]		= "lazy",
+};
+
+static ssize_t
+read_bounce_show(
+	struct kobject		*kobj,
+	char			*buf)
+{
+	struct xfs_mount	*mp = csum_to_mp(kobj);
+
+	return sysfs_emit(buf, "%s\n",
+			bounce_modes[READ_ONCE(mp->m_read_bounce)]);
+}
+
+static ssize_t
+read_bounce_store(
+	struct kobject		*kobj,
+	const char		*buf,
+	size_t			count)
+{
+	struct xfs_mount	*mp = csum_to_mp(kobj);
+	int			ret;
+
+	if (!xfs_has_read_bounce(mp))
+		return -EINVAL;
+	ret = sysfs_match_string(bounce_modes, buf);
+	if (ret < 0)
+		return ret;
+	WRITE_ONCE(mp->m_read_bounce, ret);
+	return count;
+}
+XFS_SYSFS_ATTR_RW(read_bounce);
+
+static struct attribute *xfs_csum_attrs[] = {
+	ATTR_LIST(read_bounce),
+	NULL,
+};
+ATTRIBUTE_GROUPS(xfs_csum);
+
+static const struct kobj_type xfs_csum_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_sysfs_ops,
+	.default_groups = xfs_csum_groups,
+};
+
 /* xlog */
 
 static inline struct xlog *
@@ -817,11 +882,17 @@ xfs_mount_sysfs_init(
 	if (error)
 		goto out_remove_fsdir;
 
+	/* .../xfs/<dev>/csum/ */
+	error = xfs_sysfs_init(&mp->m_csum_kobj, &xfs_csum_ktype, &mp->m_kobj,
+			"csum");
+	if (error)
+		goto out_remove_stats_dir;
+
 	/* .../xfs/<dev>/error/ */
 	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
 				&mp->m_kobj, "error");
 	if (error)
-		goto out_remove_stats_dir;
+		goto out_remove_csum_dir;
 
 	/* .../xfs/<dev>/error/fail_at_unmount */
 	error = sysfs_create_file(&mp->m_error_kobj.kobject,
@@ -835,12 +906,14 @@ xfs_mount_sysfs_init(
 				"metadata", &mp->m_error_meta_kobj,
 				xfs_error_meta_init);
 	if (error)
-		goto out_remove_error_dir;
+		goto out_remove_csum_dir;
 
 	return 0;
 
 out_remove_error_dir:
 	xfs_sysfs_del(&mp->m_error_kobj);
+out_remove_csum_dir:
+	xfs_sysfs_del(&mp->m_csum_kobj);
 out_remove_stats_dir:
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 out_remove_fsdir:
@@ -864,6 +937,7 @@ xfs_mount_sysfs_del(
 	}
 	xfs_sysfs_del(&mp->m_error_meta_kobj);
 	xfs_sysfs_del(&mp->m_error_kobj);
+	xfs_sysfs_del(&mp->m_csum_kobj);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 	xfs_sysfs_del(&mp->m_kobj);
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f333c938fbd9..2af9a1429ae9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1896,6 +1896,7 @@ DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
 DEFINE_SIMPLE_IO_EVENT(xfs_file_splice_read);
 DEFINE_SIMPLE_IO_EVENT(xfs_zoned_map_blocks);
+DEFINE_SIMPLE_IO_EVENT(xfs_bounce_reread);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
-- 
2.53.0

