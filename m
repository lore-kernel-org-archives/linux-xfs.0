Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C96D45DF44;
	Fri, 14 Aug 2026 09:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699621; cv=none; b=pnY2p0F0YugDl7b0B4/E+WHZxdqQhN45b08RR8qnsJR3L3o7pGHBHwYyyc24KVCqWk6A+D2S9qdHYg3PIv7BO5SYB5ioNI8smL8QAGUBKhHqvZbgEMeJYewrOrStZbXqF/XOaSnz+wBciq6hq85R3ONM0RF4VJEupD4nz+K6c+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699621; c=relaxed/simple;
	bh=1izi5Z6PQnS9wrNeeIeJ7shJyCnvay+W0RXnpwUcGPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZ4NC5pdjqMONfG6wwwwjJSnLQbXNpzH9t24qdSvPSAmKE6+197ynBrdUafj7Xx6CTbLn8HvEUdJpyd1MfYE1Mme7MWIDJh2jjGTjFVyb3fpAnfBv61nrTtFrFe3kzE8sEVaTZ4TPje3DhsqzjmObjf/cmR1WDtktO82qyJ6gsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6nTx7jR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6nTx7jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8CB1F000E9;
	Fri, 14 Aug 2026 09:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699618;
	bh=uzCRqrME1KzqHyLh0JOWfmA2CO8qtZcojFhU9X8Y/ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6nTx7jR0MwuOpKso4yrGxMWjR5XMCqMELp7kChDRH4U2Vty2vK9V057XFHUMCK4S
	 rtK6bODlUgGH7mFWolppg41D3Q6jAOSIXQFFDC0JlUYdkTup5tB2AQEp2ud/lCPWqW
	 mYqVmoqSf/w2ZqC72Va1CJbfPHgXieFlwb3PPNJ/G6/1aQ+AocP6miKGcgar9BGDjN
	 4wBOeruuZA7MU3h/ZoEc+ajdVO0aEA7Dht+cuSYi63vsSrP0wmKz0SbnXYgsYOUpcy
	 HhgWPrL3zaIiDy0yK2oAHLMFVxTiJaW+WoptHlswJHn0iV2qfC01f5In9JUmHNzJ5J
	 BFpow2QI4g8Og==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 17/25] xfs: use read ioend for fsverity data verification
Date: Fri, 14 Aug 2026 11:24:34 +0200
Message-ID: <20260814092448.1818082-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use read ioends for fsverity verification. Do not issue fsverity
metadata I/O through the same workqueue due to risk of a deadlock by a
filled workqueue.

Pass fsverity_info from iomap context down to the ioend as hashtable
lookups are expensive.

Add a simple helper to check that this is not fsverity metadata but file
data that needs verification.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c     | 13 ++++++-----
 fs/xfs/xfs_file.c     |  3 ++-
 fs/xfs/xfs_fsverity.c |  9 ++++++++
 fs/xfs/xfs_fsverity.h |  6 ++++++
 fs/xfs/xfs_ioend.c    | 50 +++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_ioend.h    |  4 +++-
 include/linux/iomap.h |  1 +
 7 files changed, 77 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7e4f1ea78032..c6e5fc74c7c7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -25,6 +25,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_fsverity.h"
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -606,7 +607,7 @@ xfs_bio_submit_read(
 {
 	xfs_ioend_submit_read(iter->inode, ctx->read_ctx,
 			ctx->read_ctx_file_offset,
-			iomap_ioend_flags(&iter->iomap));
+			iomap_ioend_flags(&iter->iomap), ctx->vi);
 	ctx->read_ctx = NULL;
 }
 
@@ -618,11 +619,13 @@ static const struct iomap_read_ops xfs_iomap_read_ops = {
 
 static inline const struct iomap_read_ops *
 xfs_get_iomap_read_ops(
-	const struct address_space	*mapping)
+	const struct address_space	*mapping,
+	loff_t				position)
 {
 	struct xfs_inode		*ip = XFS_I(mapping->host);
 
-	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
+	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
+			xfs_fsverity_is_file_data(ip, position))
 		return &xfs_iomap_read_ops;
 	return &iomap_bio_read_ops;
 }
@@ -634,7 +637,7 @@ xfs_vm_read_folio(
 {
 	struct iomap_read_folio_ctx	ctx = { .cur_folio = folio };
 
-	ctx.ops = xfs_get_iomap_read_ops(folio->mapping);
+	ctx.ops = xfs_get_iomap_read_ops(folio->mapping, folio_pos(folio));
 	iomap_read_folio(&xfs_read_iomap_ops, &ctx, NULL);
 	return 0;
 }
@@ -645,7 +648,7 @@ xfs_vm_readahead(
 {
 	struct iomap_read_folio_ctx	ctx = { .rac = rac };
 
-	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
+	ctx.ops = xfs_get_iomap_read_ops(rac->mapping, readahead_pos(rac));
 	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index de74a823eb98..1bedf2ef647c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -237,7 +237,8 @@ xfs_dio_read_bounce_submit_io(
 	loff_t			file_offset)
 {
 	xfs_ioend_submit_read(iter->inode, bio, file_offset,
-			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
+			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT,
+			NULL);
 }
 
 static const struct iomap_dio_ops xfs_dio_read_bounce_ops = {
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index d86009629b56..d1b3ccc65322 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -20,3 +20,12 @@ xfs_fsverity_metadata_offset(
 {
 	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
 }
+
+bool
+xfs_fsverity_is_file_data(
+	const struct xfs_inode	*ip,
+	loff_t			offset)
+{
+	return fsverity_active(VFS_IC(ip)) &&
+			offset < xfs_fsverity_metadata_offset(ip);
+}
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
index 5771db2cd797..ec77ba571106 100644
--- a/fs/xfs/xfs_fsverity.h
+++ b/fs/xfs/xfs_fsverity.h
@@ -9,12 +9,18 @@
 
 #ifdef CONFIG_FS_VERITY
 loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
+bool xfs_fsverity_is_file_data(const struct xfs_inode *ip, loff_t offset);
 #else
 static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
 {
 	WARN_ON_ONCE(1);
 	return ULLONG_MAX;
 }
+static inline bool xfs_fsverity_is_file_data(const struct xfs_inode *ip,
+					    loff_t offset)
+{
+	return false;
+}
 #endif	/* CONFIG_FS_VERITY */
 
 #endif	/* __XFS_FSVERITY_H__ */
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 37a3ae8066e9..d320da39e7a9 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -16,15 +16,55 @@
 #include "xfs_reflink.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_ioend.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
+#include "xfs_fsverity.h"
 #include <linux/bio-integrity.h>
+#include <linux/fsverity.h>
+
+static void
+xfs_end_fsverity_io_read(
+	struct work_struct	*work)
+{
+	struct iomap_ioend	*ioend =
+		container_of(work, struct iomap_ioend, io_work);
+
+	if (!ioend->io_bio.bi_status)
+		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
+
+	iomap_finish_ioends(
+		ioend, blk_status_to_errno(ioend->io_bio.bi_status));
+}
 
 static void
 xfs_end_io_read(
 	struct bio		*bio)
 {
 	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	int			error = blk_status_to_errno(bio->bi_status);
 
+	/*
+	 * If we have fsverity and block device integrity attached to this bio,
+	 * we need to run fsverity verification of data folios from a separate
+	 * fsverity workqueue. This is necessary to avoid deadlocking due to
+	 * fsverity issuing more reads of fsverity metadata which would be
+	 * processed by the same worker in the BIO completion workqueue.
+	 *
+	 * Without block device integrity, fsverity metadata IO will not use
+	 * ioends for completion.
+	 */
+	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
+			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
+		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
+			fsverity_enqueue_verify_work(&ioend->io_work);
+			return;
+		}
+
+		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);
+		error = blk_status_to_errno(ioend->io_bio.bi_status);
+	}
+
 	iomap_finish_ioends(ioend, error);
 }
 
@@ -33,9 +73,15 @@ xfs_ioend_submit_read(
 	struct inode		*inode,
 	struct bio		*bio,
 	loff_t			file_offset,
-	u16			ioend_flags)
+	u16			ioend_flags,
+	struct fsverity_info	*vi)
 {
-	iomap_init_ioend(inode, bio, file_offset, ioend_flags);
+	struct iomap_ioend	*ioend;
+
+	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
+	ioend->io_vi = vi;
+	INIT_WORK(&ioend->io_work, xfs_end_fsverity_io_read);
+
 	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_alloc(bio);
 	bio->bi_end_io = xfs_end_io_read;
diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
index 7c2a1ea3e6ed..992c248a693a 100644
--- a/fs/xfs/xfs_ioend.h
+++ b/fs/xfs/xfs_ioend.h
@@ -2,6 +2,8 @@
 #ifndef __XFS_IOEND_H
 #define __XFS_IOEND_H
 
+#include <linux/fsverity.h>
+
 /*
  * Fast and loose check if this write could update the on-disk inode size.
  */
@@ -13,6 +15,6 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 
 void xfs_end_bio(struct bio *bio);
 void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
-		loff_t file_offset, u16 ioend_flags);
+		loff_t file_offset, u16 ioend_flags, struct fsverity_info *vi);
 
 #endif /* __XFS_IOEND_H */
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0959b97e641b..f329a57d6ee9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -454,6 +454,7 @@ struct iomap_ioend {
 	sector_t		io_sector;	/* start sector of ioend */
 	void			*io_private;	/* file system private data */
 	struct fsverity_info	*io_vi;		/* fsverity info */
+	struct work_struct	io_work;	/* fsverity blocking I/O */
 	struct bio		io_bio;		/* MUST BE LAST! */
 };
 
-- 
2.54.0

