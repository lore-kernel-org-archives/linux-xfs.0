Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5AA403AFE
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376285; cv=none; b=JrknwVxPR+pf/mowKaIMK/1x/qok35q3qeurbZ+uZ1mUmLhrRRUNHf2cziqYZ/lf7UrojwjgNhnEUycO1zblHhV30aMVBDXL23kreHL0aqqaez5UkndVHFqu5Rn0TfSklINMVzDDyT75TDgClFCtKSfCQYXBDv0q9LI1oiS5IY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376285; c=relaxed/simple;
	bh=J33YgSY+j/qNFasw0/e8q0BCJXBUWdSvdlG/rPWBs00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1EZdGY3LQLuERHEpM8c8H0v308vsleJIzSP30uh6qH1DW7WmG8Bd5PEraVx6tH7mi5XK0QjVCyBupeKkFczAxWOP1hcqvVwi6CtgYWqeGxhxQaf3ZldDsomYXHSEb0tJgAjiyd8C9Dyb2imRdKK4JA0lzY8V+dzbp+1gdDEKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xZMnFx59; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xZMnFx59"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hJkimiogS0QfKmfgquh2JGQx68JNuEwIUyhkJADsxJI=; b=xZMnFx59oWRS//ueCAxmx6w4so
	IHV98+AUKAA2HR/JlQ8CuyJRDeoZJJzEHIop2MaxKfRzyU24JJ9AVtMqrAN6u2IeMBj0xFXWyHwYO
	9F6cwpILOZh/f3k6QuZ43uk5KDAUDw05cLTmB1LYNILK0AZnrbZMRp1cOB1LUynEFFVDN/AqP642U
	VLI8MD6JCNs9AMsh/nZfsa3NzYVYE2/e3mPpU/yu3IPDNz4ZNhdxM83Hhix3jY4bbt3QmCsC9JQyE
	yJFUUzSeAI7I7TtBcjuKsWBTJUb4B6sweWYxE7GNUQxJF8n6KpJ0TccY+U+70tyPWPwRqIsKYCK3Q
	rdbZZHMA==;
Received: from [12.156.71.108] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS4f-0000000CHp0-2o9O;
	Mon, 10 Aug 2026 15:38:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: split ioend handling into a separate source file
Date: Mon, 10 Aug 2026 08:37:46 -0700
Message-ID: <20260810153759.466417-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260810153759.466417-1-hch@lst.de>
References: <20260810153759.466417-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The ioend handling used to be only for buffered writeback, but has been
extended to direct I/O and reads.  Split it into a new source file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/Makefile    |   1 +
 fs/xfs/xfs_aops.c  | 181 +-------------------------------------------
 fs/xfs/xfs_aops.h  |   1 -
 fs/xfs/xfs_file.c  |   2 +-
 fs/xfs/xfs_ioend.c | 184 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioend.h |  16 ++++
 6 files changed, 203 insertions(+), 182 deletions(-)
 create mode 100644 fs/xfs/xfs_ioend.c
 create mode 100644 fs/xfs/xfs_ioend.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9f7133e02576..399a207f2d0e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -91,6 +91,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_healthmon.o \
 				   xfs_icache.o \
 				   xfs_ioctl.o \
+				   xfs_ioend.o \
 				   xfs_iomap.o \
 				   xfs_iops.o \
 				   xfs_inode.o \
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d46b089f006a..438fff1cee9f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -20,6 +20,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_icache.h"
+#include "xfs_ioend.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
 #include <linux/bio-integrity.h>
@@ -36,15 +37,6 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
 	return container_of(ctx, struct xfs_writepage_ctx, ctx);
 }
 
-/*
- * Fast and loose check if this write could update the on-disk inode size.
- */
-static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
-{
-	return ioend->io_offset + ioend->io_size >
-		XFS_I(ioend->io_inode)->i_disk_size;
-}
-
 /*
  * Update on-disk file size now that data has been written to disk.
  */
@@ -80,177 +72,6 @@ xfs_setfilesize(
 	return xfs_trans_commit(tp);
 }
 
-static void
-xfs_ioend_put_open_zones(
-	struct iomap_ioend	*ioend)
-{
-	struct iomap_ioend *tmp;
-
-	/*
-	 * Put the open zone for all ioends merged into this one (if any).
-	 */
-	list_for_each_entry(tmp, &ioend->io_list, io_list) {
-		if (tmp->io_private)
-			xfs_open_zone_put(tmp->io_private);
-	}
-
-	/*
-	 * The main ioend might not have an open zone if the submission failed
-	 * before xfs_zone_alloc_and_submit got called.
-	 */
-	if (ioend->io_private)
-		xfs_open_zone_put(ioend->io_private);
-}
-
-/*
- * IO write completion.
- */
-STATIC void
-xfs_end_ioend_write(
-	struct iomap_ioend	*ioend)
-{
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	bool			is_zoned = xfs_is_zoned_inode(ip);
-	xfs_off_t		offset = ioend->io_offset;
-	size_t			size = ioend->io_size;
-	unsigned int		nofs_flag;
-	int			error;
-
-	/*
-	 * We can allocate memory here while doing writeback on behalf of
-	 * memory reclaim.  To avoid memory allocation deadlocks set the
-	 * task-wide nofs context for the following operations.
-	 */
-	nofs_flag = memalloc_nofs_save();
-
-	/*
-	 * Just clean up the in-memory structures if the fs has been shut down.
-	 */
-	if (xfs_is_shutdown(mp)) {
-		error = -EIO;
-		goto done;
-	}
-
-	/*
-	 * Clean up all COW blocks and underlying data fork delalloc blocks on
-	 * I/O error. The delalloc punch is required because this ioend was
-	 * mapped to blocks in the COW fork and the associated pages are no
-	 * longer dirty. If we don't remove delalloc blocks here, they become
-	 * stale and can corrupt free space accounting on unmount.
-	 */
-	error = blk_status_to_errno(ioend->io_bio.bi_status);
-	if (unlikely(error)) {
-		/*
-		 * Zoned writes update the in-core open zone accounting before
-		 * I/O submission.  A failed write leaves that state
-		 * inconsistent, so shut down the filesystem instead of letting
-		 * later writers wait forever for open zone space to become
-		 * available.
-		 */
-		if (is_zoned) {
-			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-			goto done;
-		}
-		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
-			ASSERT(!is_zoned);
-			xfs_reflink_cancel_cow_range(ip, offset, size, true);
-			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
-					offset + size, NULL);
-		}
-		goto done;
-	}
-
-	/*
-	 * Success: commit the COW or unwritten blocks if needed.
-	 */
-	if (is_zoned)
-		error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
-				ioend->io_private, NULLFSBLOCK);
-	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
-		error = xfs_reflink_end_cow(ip, offset, size);
-	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
-		error = xfs_iomap_write_unwritten(ip, offset, size, false);
-
-	if (!error &&
-	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
-	    xfs_ioend_is_append(ioend))
-		error = xfs_setfilesize(ip, offset, size);
-done:
-	if (is_zoned)
-		xfs_ioend_put_open_zones(ioend);
-	iomap_finish_ioends(ioend, error);
-	memalloc_nofs_restore(nofs_flag);
-}
-
-/*
- * Finish all pending IO completions that require transactional modifications.
- *
- * We try to merge physical and logically contiguous ioends before completion to
- * minimise the number of transactions we need to perform during IO completion.
- * Both unwritten extent conversion and COW remapping need to iterate and modify
- * one physical extent at a time, so we gain nothing by merging physically
- * discontiguous extents here.
- *
- * The ioend chain length that we can be processing here is largely unbound in
- * length and we may have to perform significant amounts of work on each ioend
- * to complete it. Hence we have to be careful about holding the CPU for too
- * long in this loop.
- */
-void
-xfs_end_io(
-	struct work_struct	*work)
-{
-	struct xfs_inode	*ip =
-		container_of(work, struct xfs_inode, i_ioend_work);
-	struct iomap_ioend	*ioend;
-	struct list_head	tmp;
-	unsigned long		flags;
-
-	spin_lock_irqsave(&ip->i_ioend_lock, flags);
-	list_replace_init(&ip->i_ioend_list, &tmp);
-	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
-
-	iomap_sort_ioends(&tmp);
-	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
-			io_list))) {
-		list_del_init(&ioend->io_list);
-		iomap_ioend_try_merge(ioend, &tmp);
-		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
-			iomap_finish_ioends(ioend,
-				blk_status_to_errno(ioend->io_bio.bi_status));
-		else
-			xfs_end_ioend_write(ioend);
-		cond_resched();
-	}
-}
-
-void
-xfs_end_bio(
-	struct bio		*bio)
-{
-	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	unsigned long		flags;
-
-	/*
-	 * For Appends record the actually written block number and set the
-	 * boundary flag if needed.
-	 */
-	if (IS_ENABLED(CONFIG_XFS_RT) && bio_is_zone_append(bio)) {
-		ioend->io_sector = bio->bi_iter.bi_sector;
-		xfs_mark_rtg_boundary(ioend);
-	}
-
-	spin_lock_irqsave(&ip->i_ioend_lock, flags);
-	if (list_empty(&ip->i_ioend_list))
-		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
-					 &ip->i_ioend_work));
-	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
-	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
-}
-
 /*
  * We cannot cancel the ioend directly on error.  We may have already set other
  * pages under writeback and hence we have to run I/O completion to mark the
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 5a7a0f1a0b49..d5ae5c9d4c26 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -10,6 +10,5 @@ extern const struct address_space_operations xfs_address_space_operations;
 extern const struct address_space_operations xfs_dax_aops;
 
 int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
-void xfs_end_bio(struct bio *bio);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4745f047193c..3f394791106b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -25,7 +25,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 #include "xfs_file.h"
-#include "xfs_aops.h"
+#include "xfs_ioend.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_error.h"
 #include "xfs_errortag.h"
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
new file mode 100644
index 000000000000..40695d18dac0
--- /dev/null
+++ b/fs/xfs/xfs_ioend.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2016-2025 Christoph Hellwig.
+ * All Rights Reserved.
+ */
+#include "xfs_platform.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_iomap.h"
+#include "xfs_trace.h"
+#include "xfs_bmap_util.h"
+#include "xfs_reflink.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_ioend.h"
+
+static void
+xfs_ioend_put_open_zones(
+	struct iomap_ioend	*ioend)
+{
+	struct iomap_ioend *tmp;
+
+	/*
+	 * Put the open zone for all ioends merged into this one (if any).
+	 */
+	list_for_each_entry(tmp, &ioend->io_list, io_list)
+		xfs_open_zone_put(tmp->io_private);
+
+	/*
+	 * The main ioend might not have an open zone if the submission failed
+	 * before xfs_zone_alloc_and_submit got called.
+	 */
+	if (ioend->io_private)
+		xfs_open_zone_put(ioend->io_private);
+}
+
+static void
+xfs_end_ioend_write(
+	struct iomap_ioend	*ioend)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			is_zoned = xfs_is_zoned_inode(ip);
+	xfs_off_t		offset = ioend->io_offset;
+	size_t			size = ioend->io_size;
+	unsigned int		nofs_flag;
+	int			error;
+
+	/*
+	 * We can allocate memory here while doing writeback on behalf of
+	 * memory reclaim.  To avoid memory allocation deadlocks set the
+	 * task-wide nofs context for the following operations.
+	 */
+	nofs_flag = memalloc_nofs_save();
+
+	/*
+	 * Just clean up the in-memory structures if the fs has been shut down.
+	 */
+	if (xfs_is_shutdown(mp)) {
+		error = -EIO;
+		goto done;
+	}
+
+	/*
+	 * Clean up all COW blocks and underlying data fork delalloc blocks on
+	 * I/O error. The delalloc punch is required because this ioend was
+	 * mapped to blocks in the COW fork and the associated pages are no
+	 * longer dirty. If we don't remove delalloc blocks here, they become
+	 * stale and can corrupt free space accounting on unmount.
+	 */
+	error = blk_status_to_errno(ioend->io_bio.bi_status);
+	if (unlikely(error)) {
+		/*
+		 * Zoned writes update the in-core open zone accounting before
+		 * I/O submission.  A failed write leaves that state
+		 * inconsistent, so shut down the filesystem instead of letting
+		 * later writers wait forever for open zone space to become
+		 * available.
+		 */
+		if (is_zoned) {
+			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+			goto done;
+		}
+		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
+			ASSERT(!is_zoned);
+			xfs_reflink_cancel_cow_range(ip, offset, size, true);
+			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
+					offset + size, NULL);
+		}
+		goto done;
+	}
+
+	/*
+	 * Success: commit the COW or unwritten blocks if needed.
+	 */
+	if (is_zoned)
+		error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
+				ioend->io_private, NULLFSBLOCK);
+	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
+		error = xfs_reflink_end_cow(ip, offset, size);
+	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
+		error = xfs_iomap_write_unwritten(ip, offset, size, false);
+
+	if (!error &&
+	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
+	    xfs_ioend_is_append(ioend))
+		error = xfs_setfilesize(ip, offset, size);
+done:
+	if (is_zoned)
+		xfs_ioend_put_open_zones(ioend);
+	iomap_finish_ioends(ioend, error);
+	memalloc_nofs_restore(nofs_flag);
+}
+
+/*
+ * Finish all pending IO completions that require transactional modifications.
+ *
+ * We try to merge physical and logically contiguous ioends before completion to
+ * minimise the number of transactions we need to perform during IO completion.
+ * Both unwritten extent conversion and COW remapping need to iterate and modify
+ * one physical extent at a time, so we gain nothing by merging physically
+ * discontiguous extents here.
+ *
+ * The ioend chain length that we can be processing here is largely unbound in
+ * length and we may have to perform significant amounts of work on each ioend
+ * to complete it. Hence we have to be careful about holding the CPU for too
+ * long in this loop.
+ */
+void
+xfs_end_io(
+	struct work_struct	*work)
+{
+	struct xfs_inode	*ip =
+		container_of(work, struct xfs_inode, i_ioend_work);
+	struct iomap_ioend	*ioend;
+	struct list_head	tmp;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&ip->i_ioend_lock, flags);
+	list_replace_init(&ip->i_ioend_list, &tmp);
+	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
+
+	iomap_sort_ioends(&tmp);
+	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
+			io_list))) {
+		list_del_init(&ioend->io_list);
+		iomap_ioend_try_merge(ioend, &tmp);
+		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
+			iomap_finish_ioends(ioend,
+				blk_status_to_errno(ioend->io_bio.bi_status));
+		else
+			xfs_end_ioend_write(ioend);
+		cond_resched();
+	}
+}
+
+void
+xfs_end_bio(
+	struct bio		*bio)
+{
+	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned long		flags;
+
+	/*
+	 * For Appends record the actually written block number and set the
+	 * boundary flag if needed.
+	 */
+	if (IS_ENABLED(CONFIG_XFS_RT) && bio_is_zone_append(bio)) {
+		ioend->io_sector = bio->bi_iter.bi_sector;
+		xfs_mark_rtg_boundary(ioend);
+	}
+
+	spin_lock_irqsave(&ip->i_ioend_lock, flags);
+	if (list_empty(&ip->i_ioend_list))
+		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
+					 &ip->i_ioend_work));
+	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
+	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
+}
diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
new file mode 100644
index 000000000000..525865767fca
--- /dev/null
+++ b/fs/xfs/xfs_ioend.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __XFS_IOEND_H
+#define __XFS_IOEND_H
+
+/*
+ * Fast and loose check if this write could update the on-disk inode size.
+ */
+static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
+{
+	return ioend->io_offset + ioend->io_size >
+		XFS_I(ioend->io_inode)->i_disk_size;
+}
+
+void xfs_end_bio(struct bio *bio);
+
+#endif /* __XFS_IOEND_H */
-- 
2.53.0

