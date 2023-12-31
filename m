Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AD9B675
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHwmMLyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811B2C433C7;
	Sun, 31 Dec 2023 20:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053692;
	bh=KZRnL56XC4TAAOzX0MUMt6ot6bsiUYlS3fb0oXYh6R8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QHwmMLyJT5gvaiAEJ3UEqxezOGKH8mrkemOeI873RH+++cr2VgVJsvbv7c7qEOU96
	 I+3ro5v93qlVKGrBAH1ptLH4PvWiQCBh6ujxJHhIQpWJKgqfU1AV0/rUW5Z/3bKHo0
	 yzxy9rGRqqp5xiL5QOAfqB/p+TvEW/VcdktvaBNWXgZKU0jSZFry+RgKFoBTuCI2hU
	 4aBWIJZgYnxArdTh2CEC0k4LdliFKqgi4MysfUvNAE4TAM5sz8u0zGghQRcxtOJEpm
	 kafJ2KhYzrrrd2eEmlTubYcTZw2kZzUMLemts/jIS6H6qwCqP/TGmQgsfukoSSt0hr
	 D/rfEExm4f8OA==
Date: Sun, 31 Dec 2023 12:14:52 -0800
Subject: [PATCH 5/9] xfs: support in-memory buffer cache targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829659.1748854.3761446311521327635.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow the buffer cache to target in-memory files by connecting it to
xfiles.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig         |    4 ++
 fs/xfs/Makefile        |    1 +
 fs/xfs/scrub/xfile.h   |   16 +++++++++
 fs/xfs/xfs_buf.c       |   46 ++++++++++++++++++++++---
 fs/xfs/xfs_buf.h       |   22 ++++++++++++
 fs/xfs/xfs_buf_xfile.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf_xfile.h |   18 ++++++++++
 7 files changed, 191 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/xfs_buf_xfile.c
 create mode 100644 fs/xfs/xfs_buf_xfile.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index dbcf55377e9fe..7c016a8788456 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -128,6 +128,9 @@ config XFS_LIVE_HOOKS
 	bool
 	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
 
+config XFS_IN_MEMORY_FILE
+	bool
+
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
@@ -135,6 +138,7 @@ config XFS_ONLINE_SCRUB
 	depends on TMPFS && SHMEM
 	select XFS_LIVE_HOOKS
 	select XFS_DRAIN_INTENTS
+	select XFS_IN_MEMORY_FILE
 	help
 	  If you say Y here you will be able to check metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a6a455ac5a38b..7eb7c521c4a84 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -138,6 +138,7 @@ endif
 
 xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
 xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
+xfs-$(CONFIG_XFS_IN_MEMORY_FILE)	+= xfs_buf_xfile.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 9022fe8924b94..d7661ee909495 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_SCRUB_XFILE_H__
 #define __XFS_SCRUB_XFILE_H__
 
+#ifdef CONFIG_XFS_IN_MEMORY_FILE
+
 struct xfile_page {
 	struct page		*page;
 	void			*fsdata;
@@ -24,6 +26,7 @@ static inline pgoff_t xfile_page_index(const struct xfile_page *xfpage)
 
 struct xfile {
 	struct file		*file;
+	struct xfs_buf_cache	bcache;
 };
 
 int xfile_create(const char *description, loff_t isize, struct xfile **xfilep);
@@ -75,5 +78,18 @@ int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
 int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
 
 int xfile_dump(struct xfile *xf);
+#else
+static inline int
+xfile_obj_load(struct xfile *xf, void *buf, size_t count, loff_t offset)
+{
+	return -EIO;
+}
+
+static inline int
+xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t offset)
+{
+	return -EIO;
+}
+#endif /* CONFIG_XFS_IN_MEMORY_FILE */
 
 #endif /* __XFS_SCRUB_XFILE_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 05b651672085d..9ce08a4823851 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -21,6 +21,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_ag.h"
+#include "xfs_buf_xfile.h"
 
 struct kmem_cache *xfs_buf_cache;
 
@@ -1556,6 +1557,30 @@ xfs_buf_ioapply_map(
 
 }
 
+/* Start a synchronous process-context buffer IO. */
+static inline void
+xfs_buf_start_sync_io(
+	struct xfs_buf	*bp)
+{
+	atomic_inc(&bp->b_io_remaining);
+}
+
+/* Finish a synchronous bprocess-context uffer IO. */
+static void
+xfs_buf_end_sync_io(
+	struct xfs_buf	*bp,
+	int		error)
+{
+	if (error)
+		cmpxchg(&bp->b_io_error, 0, error);
+
+	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
+
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+		xfs_buf_ioend(bp);
+}
+
 STATIC void
 _xfs_buf_ioapply(
 	struct xfs_buf	*bp)
@@ -1613,6 +1638,15 @@ _xfs_buf_ioapply(
 	/* we only use the buffer cache for meta-data */
 	op |= REQ_META;
 
+	if (bp->b_target->bt_flags & XFS_BUFTARG_XFILE) {
+		int	error;
+
+		xfs_buf_start_sync_io(bp);
+		error = xfile_buf_ioapply(bp);
+		xfs_buf_end_sync_io(bp, error);
+		return;
+	}
+
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
@@ -1976,10 +2010,12 @@ xfs_free_buftarg(
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
-	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
-	/* the main block device is closed by kill_block_super */
-	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
-		bdev_release(btp->bt_bdev_handle);
+	if (!(btp->bt_flags & XFS_BUFTARG_XFILE)) {
+		fs_put_dax(btp->bt_daxdev, btp->bt_mount);
+		/* the main block device is closed by kill_block_super */
+		if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
+			bdev_release(btp->bt_bdev_handle);
+	}
 
 	kvfree(btp);
 }
@@ -2019,7 +2055,7 @@ xfs_setsize_buftarg_early(
 	return xfs_setsize_buftarg(btp, bdev_logical_block_size(btp->bt_bdev));
 }
 
-static struct xfs_buftarg *
+struct xfs_buftarg *
 xfs_alloc_buftarg_common(
 	struct xfs_mount	*mp,
 	const char		*descr)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4e964470587ce..a86c0b8e5a85e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -21,6 +21,7 @@ extern struct kmem_cache *xfs_buf_cache;
  *	Base types
  */
 struct xfs_buf;
+struct xfile;
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
@@ -109,9 +110,11 @@ typedef struct xfs_buftarg {
 	struct bdev_handle	*bt_bdev_handle;
 	struct block_device	*bt_bdev;
 	struct dax_device	*bt_daxdev;
+	struct xfile		*bt_xfile;
 	u64			bt_dax_part_off;
 	struct xfs_mount	*bt_mount;
 	struct xfs_buf_cache	*bt_cache;
+	unsigned int		bt_flags;
 	unsigned int		bt_meta_sectorsize;
 	size_t			bt_meta_sectormask;
 	size_t			bt_logical_sectorsize;
@@ -125,6 +128,13 @@ typedef struct xfs_buftarg {
 	struct ratelimit_state	bt_ioerror_rl;
 } xfs_buftarg_t;
 
+#ifdef CONFIG_XFS_IN_MEMORY_FILE
+/* in-memory buftarg via bt_xfile */
+# define XFS_BUFTARG_XFILE	(1U << 0)
+#else
+# define XFS_BUFTARG_XFILE	(0)
+#endif
+
 #define XB_PAGES	2
 
 struct xfs_buf_map {
@@ -375,6 +385,8 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 /*
  *	Handling of buftargs.
  */
+struct xfs_buftarg *xfs_alloc_buftarg_common(struct xfs_mount *mp,
+		const char *descr);
 struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
 		struct bdev_handle *bdev_handle);
 extern void xfs_free_buftarg(struct xfs_buftarg *);
@@ -385,24 +397,32 @@ extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
 static inline struct block_device *
 xfs_buftarg_bdev(struct xfs_buftarg *btp)
 {
+	if (btp->bt_flags & XFS_BUFTARG_XFILE)
+		return NULL;
 	return btp->bt_bdev;
 }
 
 static inline unsigned int
 xfs_getsize_buftarg(struct xfs_buftarg *btp)
 {
+	if (btp->bt_flags & XFS_BUFTARG_XFILE)
+		return SECTOR_SIZE;
 	return block_size(btp->bt_bdev);
 }
 
 static inline bool
 xfs_readonly_buftarg(struct xfs_buftarg *btp)
 {
+	if (btp->bt_flags & XFS_BUFTARG_XFILE)
+		return false;
 	return bdev_read_only(btp->bt_bdev);
 }
 
 static inline int
 xfs_buftarg_flush(struct xfs_buftarg *btp)
 {
+	if (btp->bt_flags & XFS_BUFTARG_XFILE)
+		return 0;
 	return blkdev_issue_flush(btp->bt_bdev);
 }
 
@@ -414,6 +434,8 @@ xfs_buftarg_zeroout(
 	gfp_t			gfp_mask,
 	unsigned int		flags)
 {
+	if (btp->bt_flags & XFS_BUFTARG_XFILE)
+		return -EOPNOTSUPP;
 	return blkdev_issue_zeroout(btp->bt_bdev, sector, nr_sects, gfp_mask,
 			flags);
 }
diff --git a/fs/xfs/xfs_buf_xfile.c b/fs/xfs/xfs_buf_xfile.c
new file mode 100644
index 0000000000000..15cbe3df7aa01
--- /dev/null
+++ b/fs/xfs/xfs_buf_xfile.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_buf.h"
+#include "xfs_buf_xfile.h"
+#include "scrub/xfile.h"
+
+/* Perform a buffer IO to an xfile.  Caller must be in process context. */
+int
+xfile_buf_ioapply(
+	struct xfs_buf		*bp)
+{
+	struct xfile		*xfile = bp->b_target->bt_xfile;
+	loff_t			pos = BBTOB(xfs_buf_daddr(bp));
+	size_t			size = BBTOB(bp->b_length);
+
+	if (bp->b_map_count > 1) {
+		/* We don't need or support multi-map buffers. */
+		ASSERT(0);
+		return -EIO;
+	}
+
+	if (bp->b_flags & XBF_WRITE)
+		return xfile_obj_store(xfile, bp->b_addr, size, pos);
+	return xfile_obj_load(xfile, bp->b_addr, size, pos);
+}
+
+/* Allocate a buffer cache target for a memory-backed file. */
+int
+xfile_alloc_buftarg(
+	struct xfs_mount	*mp,
+	const char		*descr,
+	struct xfs_buftarg	**btpp)
+{
+	struct xfs_buftarg	*btp;
+	struct xfile		*xfile;
+	int			error;
+
+	error = xfile_create(descr, 0, &xfile);
+	if (error)
+		return error;
+
+	error = xfs_buf_cache_init(&xfile->bcache);
+	if (error)
+		goto out_xfile;
+
+	btp = xfs_alloc_buftarg_common(mp, descr);
+	if (!btp) {
+		error = -ENOMEM;
+		goto out_bcache;
+	}
+
+	btp->bt_xfile = xfile;
+	btp->bt_dev = (dev_t)-1U;
+	btp->bt_flags |= XFS_BUFTARG_XFILE;
+	btp->bt_cache = &xfile->bcache;
+
+	btp->bt_meta_sectorsize = SECTOR_SIZE;
+	btp->bt_meta_sectormask = SECTOR_SIZE - 1;
+	btp->bt_logical_sectorsize = SECTOR_SIZE;
+	btp->bt_logical_sectormask = SECTOR_SIZE - 1;
+
+	*btpp = btp;
+	return 0;
+
+out_bcache:
+	xfs_buf_cache_destroy(&xfile->bcache);
+out_xfile:
+	xfile_destroy(xfile);
+	return error;
+}
+
+/* Free a buffer cache target for a memory-backed file. */
+void
+xfile_free_buftarg(
+	struct xfs_buftarg	*btp)
+{
+	struct xfile		*xfile = btp->bt_xfile;
+
+	ASSERT(btp->bt_flags & XFS_BUFTARG_XFILE);
+
+	xfs_free_buftarg(btp);
+	xfs_buf_cache_destroy(&xfile->bcache);
+	xfile_destroy(xfile);
+}
diff --git a/fs/xfs/xfs_buf_xfile.h b/fs/xfs/xfs_buf_xfile.h
new file mode 100644
index 0000000000000..69d7846215468
--- /dev/null
+++ b/fs/xfs/xfs_buf_xfile.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_BUF_XFILE_H__
+#define __XFS_BUF_XFILE_H__
+
+#ifdef CONFIG_XFS_IN_MEMORY_FILE
+int xfile_buf_ioapply(struct xfs_buf *bp);
+int xfile_alloc_buftarg(struct xfs_mount *mp, const char *descr,
+		struct xfs_buftarg **btpp);
+void xfile_free_buftarg(struct xfs_buftarg *btp);
+#else
+# define xfile_buf_ioapply(bp)			(-EOPNOTSUPP)
+#endif /* CONFIG_XFS_IN_MEMORY_FILE */
+
+#endif /* __XFS_BUF_XFILE_H__ */

