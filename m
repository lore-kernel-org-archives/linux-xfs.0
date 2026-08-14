Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919EE45D5D9;
	Fri, 14 Aug 2026 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699615; cv=none; b=nD/Wx0sNbqCyy6ua4/KyuUGlxJNPwgCzV1fjb2+tVB9I3qBNPXN7KMTNI9AEL85gwmqGU0LhuCA3V0/5kCob6ODnpNKHbWz+WTG+u92fLQz+yRaAvlxXPOiO9Gcf+tGbGxExwSPUFmt9sbsYwOKgpZU1Fdz4VFeOleXQWnRQSC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699615; c=relaxed/simple;
	bh=WfUfrOIi9azv4LtygcUUaO5ypuuAdiWsaa26A/4GYTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI4i75ZxXRWUQ1lT9Y2pBrO10gV7sdtsdZs5r/HnycWGIutaYC9paKqciGn+muVKJ7htNgNaXE6xBwPyEqvn6IeDZbGsLkd5At9FRJjXURwpuJ+qqG/7g2Lsh9vrx4dt4tHlEvqW7qH5asohe03DjQ4zfU+2ub2HJvwMgreiWfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgCl7b4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgCl7b4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DB91F00A3A;
	Fri, 14 Aug 2026 09:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699613;
	bh=/UCjFrc8DprGc4h9995FHOIYzfsZfULfgqmAs2PP74Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgCl7b4nUe35RWlbf5FOdIIJCt3AdMqacp8ocUj7y//r4rpZQL/BC7fZI25G5V9+b
	 qMaXHl1Xa36wCXY4IYLUazGv4WQtyMdYb3DjhlTLhlBniLHIXUNmPKQXJu6FIEnuYy
	 lJ+Rr4a4hzYaxxH53ZUXCsC8qplsnDsMVKihc6HVDSL6nz7TqsBBBFuwbQrPPFtdPc
	 yoHadGix+Mu+MZlkjJP4h9+60FOm84aYOwzk3dFyjoHlADO/KOp71Xc05O9lfuA2X3
	 azKpg/pmLrcCsv/umN224IxByp/UANPazXUSceARaUkF/7LzUsqeoO0nZ8tGFaCgO0
	 Ym5rfA/yEflOw==
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
Subject: [PATCH v15 16/25] xfs: handle fsverity I/O in write/read path
Date: Fri, 14 Aug 2026 11:24:33 +0200
Message-ID: <20260814092448.1818082-17-aalbersh@kernel.org>
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

For write/writeback set IOMAP_F_FSVERITY flag telling iomap to not
update inode size and to not skip folios beyond EOF.

Initiate fsverity writeback with IOMAP_F_FSVERITY set to tell iomap
should not skip folio that is dirty beyond EOF.

In read path let iomap know that we are reading fsverity metadata. So,
treat holes in the tree as request to synthesize tree blocks and hole
after descriptor as end of the fsverity region.

Introduce a new inode flag meaning that merkle tree is being build on
the inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/Makefile          |  1 +
 fs/xfs/libxfs/xfs_bmap.c | 11 +++++++++++
 fs/xfs/xfs_aops.c        | 36 +++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_fsverity.c    | 22 ++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h    | 20 ++++++++++++++++++++
 fs/xfs/xfs_inode.h       |  6 ++++++
 fs/xfs/xfs_iomap.c       | 31 ++++++++++++++++++++++++-------
 fs/xfs/xfs_iomap.h       |  5 +++--
 8 files changed, 118 insertions(+), 14 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 399a207f2d0e..dd712c521862 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -150,6 +150,7 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
+xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
 
 # notify failure
 ifeq ($(CONFIG_MEMORY_FAILURE),y)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..cc48f6e20e80 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -41,6 +41,8 @@
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_fsverity.h"
+#include <linux/fsverity.h>
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -4402,6 +4404,10 @@ xfs_bmapi_convert_one_delalloc(
 	 * the extent.  Just return the real extent at this offset.
 	 */
 	if (!isnullstartblock(bma.got.br_startblock)) {
+		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
+		    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=
+			    xfs_fsverity_metadata_offset(ip))
+			flags |= IOMAP_F_FSVERITY;
 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
 		if (seq)
@@ -4449,6 +4455,11 @@ xfs_bmapi_convert_one_delalloc(
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
 	XFS_STATS_INC(mp, xs_xstrat_quick);
 
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
+	    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=
+		    xfs_fsverity_metadata_offset(ip))
+		flags |= IOMAP_F_FSVERITY;
+
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d2484c4a6151..7e4f1ea78032 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -23,6 +23,7 @@
 #include "xfs_ioend.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_fsverity.h"
 #include <linux/bio-integrity.h>
 
 struct xfs_writepage_ctx {
@@ -173,12 +174,16 @@ xfs_map_blocks(
 	int			retries = 0;
 	int			error = 0;
 	unsigned int		*seq;
+	unsigned int		iomap_flags = 0;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
 
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		iomap_flags |= IOMAP_F_FSVERITY;
+
 	/*
 	 * COW fork blocks can overlap data fork blocks even if the blocks
 	 * aren't shared.  COW I/O always takes precedent, so we must always
@@ -266,7 +271,8 @@ xfs_map_blocks(
 	    isnullstartblock(imap.br_startblock))
 		goto allocate_blocks;
 
-	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags,
+			  XFS_WPC(wpc)->data_seq);
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
@@ -413,12 +419,16 @@ xfs_zoned_map_blocks(
 	xfs_filblks_t		count_fsb;
 	struct xfs_bmbt_irec	imap, del;
 	struct xfs_iext_cursor	icur;
+	u16			iomap_flags = 0;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
 
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		iomap_flags |= IOMAP_F_FSVERITY;
+
 	/*
 	 * All dirty data must be covered by delalloc extents.  But truncate can
 	 * remove delalloc extents underneath us or reduce their size.
@@ -442,7 +452,7 @@ xfs_zoned_map_blocks(
 		imap.br_startblock = HOLESTARTBLOCK;
 		imap.br_state = XFS_EXT_NORM;
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, 0);
+		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags, 0);
 		return 0;
 	}
 	end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
@@ -455,7 +465,7 @@ xfs_zoned_map_blocks(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	xfs_iomap_set_anon_write(ip, &wpc->iomap, offset,
-			XFS_FSB_TO_B(mp, count_fsb));
+			XFS_FSB_TO_B(mp, count_fsb), iomap_flags);
 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
 	return 0;
 }
@@ -502,6 +512,22 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
 	.writeback_submit	= xfs_zoned_writeback_submit,
 };
 
+static int
+xfs_iomap_writepages(
+	struct xfs_inode		*ip,
+	struct iomap_writepage_ctx	*ctx)
+{
+	/*
+	 * Writeback does not work for folios past EOF, let it know that
+	 * I/O happens for fsverity metadata and this restriction need
+	 * to be skipped
+	 */
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		ctx->iomap.flags |= IOMAP_F_FSVERITY;
+
+	return iomap_writepages(ctx);
+}
+
 STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
@@ -521,7 +547,7 @@ xfs_vm_writepages(
 		};
 		int				error;
 
-		error = iomap_writepages(&xc.ctx);
+		error = xfs_iomap_writepages(ip, &xc.ctx);
 		if (xc.open_zone)
 			xfs_open_zone_put(xc.open_zone);
 		return error;
@@ -534,7 +560,7 @@ xfs_vm_writepages(
 			},
 		};
 
-		return iomap_writepages(&wpc.ctx);
+		return xfs_iomap_writepages(ip, &wpc.ctx);
 	}
 }
 
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
new file mode 100644
index 000000000000..d86009629b56
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.c
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_fsverity.h"
+#include <linux/fsverity.h>
+#include <linux/iomap.h>
+
+loff_t
+xfs_fsverity_metadata_offset(
+	const struct xfs_inode	*ip)
+{
+	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
+}
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
new file mode 100644
index 000000000000..5771db2cd797
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#ifndef __XFS_FSVERITY_H__
+#define __XFS_FSVERITY_H__
+
+#include "xfs_platform.h"
+
+#ifdef CONFIG_FS_VERITY
+loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
+#else
+static inline loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip)
+{
+	WARN_ON_ONCE(1);
+	return ULLONG_MAX;
+}
+#endif	/* CONFIG_FS_VERITY */
+
+#endif	/* __XFS_FSVERITY_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 34c1038ebfcd..17ce083591f4 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -419,6 +419,12 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
  */
 #define XFS_IREMAPPING		(1U << 15)
 
+/*
+ * fs-verity's Merkle tree is under construction. The file is read-only, the
+ * only writes happening are for the fsverity metadata.
+ */
+#define XFS_VERITY_CONSTRUCTION	(1U << 16)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e87c26c3e03b..edeb2daa8e31 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -32,6 +32,8 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_fsverity.h"
+#include <linux/fsverity.h>
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -883,6 +885,9 @@ xfs_direct_write_iomap_begin(
 	if (flags & IOMAP_ATOMIC)
 		iomap_flags |= IOMAP_F_ATOMIC_BIO;
 
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		iomap_flags |= IOMAP_F_FSVERITY;
+
 	/*
 	 * COW writes may allocate delalloc space or convert unwritten COW
 	 * extents, so we need to make sure to take the lock exclusively here.
@@ -1080,7 +1085,7 @@ xfs_zoned_direct_write_iomap_begin(
 			return error;
 	}
 
-	xfs_iomap_set_anon_write(ip, iomap, offset, length);
+	xfs_iomap_set_anon_write(ip, iomap, offset, length, 0);
 	return 0;
 }
 
@@ -1584,7 +1589,8 @@ xfs_zoned_buffered_write_iomap_begin(
 	loff_t			count,
 	unsigned		flags,
 	struct iomap		*iomap,
-	struct iomap		*srcmap)
+	struct iomap		*srcmap,
+	u16			iomap_flags)
 {
 	struct iomap_iter	*iter =
 		container_of(iomap, struct iomap_iter, iomap);
@@ -1594,7 +1600,6 @@ xfs_zoned_buffered_write_iomap_begin(
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
-	u16			iomap_flags = IOMAP_F_SHARED;
 	unsigned int		lockmode = XFS_ILOCK_EXCL;
 	xfs_filblks_t		count_fsb;
 	xfs_extlen_t		indlen;
@@ -1657,7 +1662,8 @@ xfs_zoned_buffered_write_iomap_begin(
 				smap.br_startoff + smap.br_blockcount);
 			xfs_trim_extent(&smap, offset_fsb,
 					end_fsb - offset_fsb);
-			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
+			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags,
+					iomap_flags,
 					xfs_iomap_inode_sequence(ip, 0));
 			if (error)
 				goto out_unlock;
@@ -1667,6 +1673,8 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (!ip->i_cowfp)
 		xfs_ifork_init_cow(ip);
 
+	iomap_flags |= IOMAP_F_SHARED;
+
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
 		got.br_startoff = end_fsb;
 	if (got.br_startoff <= offset_fsb) {
@@ -1798,9 +1806,12 @@ xfs_buffered_write_iomap_begin(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		iomap_flags |= IOMAP_F_FSVERITY;
+
 	if (xfs_is_zoned_inode(ip))
 		return xfs_zoned_buffered_write_iomap_begin(inode, offset,
-				count, flags, iomap, srcmap);
+				count, flags, iomap, srcmap, iomap_flags);
 
 	/* we can't use delayed allocations when using extent size hints */
 	if (xfs_get_extsz_hint(ip))
@@ -2186,12 +2197,17 @@ xfs_read_iomap_begin(
 	bool			shared = false;
 	unsigned int		lockmode = XFS_ILOCK_SHARED;
 	u64			seq;
+	unsigned int		iomap_flags = 0;
 
 	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)));
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	if (fsverity_active(inode) &&
+	    (offset >= xfs_fsverity_metadata_offset(ip)))
+		iomap_flags |= IOMAP_F_FSVERITY;
+
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
@@ -2205,8 +2221,9 @@ xfs_read_iomap_begin(
 	if (error)
 		return error;
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
-				 shared ? IOMAP_F_SHARED : 0, seq);
+	iomap_flags |= shared ? IOMAP_F_SHARED : 0;
+
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
 }
 
 const struct iomap_ops xfs_read_iomap_ops = {
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index f697d7e73ab6..2e363f2ed070 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -34,13 +34,14 @@ xfs_iomap_set_anon_write(
 	struct xfs_inode		*ip,
 	struct iomap			*iomap,
 	loff_t				offset,
-	loff_t				length)
+	loff_t				length,
+	u16				iomap_flags)
 {
 	iomap->type = IOMAP_MAPPED;
 	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
 	iomap->offset = offset;
 	iomap->length = length;
-	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
+	iomap->flags = iomap_flags | IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 }
 
 static inline xfs_filblks_t
-- 
2.54.0

