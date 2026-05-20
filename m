Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08963E9299;
	Wed, 20 May 2026 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280686; cv=none; b=fGSYN/4QH2dow2QMkKQcE8xcOZz0y2tFJKbR99O+248+9LSYPKTALc7OeBEKCqBdipxqsM2+JYCBMGFliPnYOTiNf11L34QsTqCkP5CP9KtsArBeDkeyeP00VlzGLhPtVWrze63ZFN6KQDmcu1QgBIdAJRN4OFfE/c58s8JXPw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280686; c=relaxed/simple;
	bh=zAqS1f07EiIaQcCO0AZp7/t41XaPwR0USrgvgTZdPno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWSq0D3FxyXp5EB9SXnX/8bDzBq9fvUHkVjw8MVU626VaqyMXQW3fWd1qtUV9RYIEj0Bz8uCJOsxd9U6dGgwm2QSFnPWKbhX7iD9Ohw1Q9jBnWkA2PpB2UGUTfjDWKg1bvaRSwPeLx74YSV9IkGToRf/Ekl2GW2JwdvGV3eq5tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogzDGkZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogzDGkZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA291F00894;
	Wed, 20 May 2026 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280682;
	bh=Q/8QKW6zbsRwWhwGEi9ElfQBNCcTTA5pNjJ71ec5bYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogzDGkZ1Qw/3a25UIh/Kxuvj2HoazOwG5fJKaTewVNJXZw8EWDY19v7DuMBhZ4AAa
	 BNEK+TLpLtDGj1+v5d/hK2ASeQnzAnUF9BGhLCCzZCgmExXUZzOihgWLdaQ/vN2f6p
	 m0MZ71Dll2PPKf+vaH2ugcsI5yO+mZHi4Bmz2hcWkwpW6DCDa3UGapb3gApamk/c7V
	 nSP+P7bbyps+SBziaiW/nq6sloaR1lbL5wntH/IaecxudHtQiqXloJ/Q5Z+UIrL1Hu
	 UBh2wbgA1vu60c8/M5vZH28u7l0sGnFW3KUCHCAiM/5APQ8C28A2x6pXH3d2I1im0n
	 V/d/tmNvXqlfQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v10 14/22] xfs: handle fsverity I/O in write/read path
Date: Wed, 20 May 2026 14:37:12 +0200
Message-ID: <20260520123722.405752-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/Makefile          |  1 +
 fs/xfs/libxfs/xfs_bmap.c |  7 +++++++
 fs/xfs/xfs_aops.c        | 16 +++++++++++++++-
 fs/xfs/xfs_fsverity.c    | 21 +++++++++++++++++++++
 fs/xfs/xfs_fsverity.h    | 20 ++++++++++++++++++++
 fs/xfs/xfs_inode.h       |  6 ++++++
 fs/xfs/xfs_iomap.c       | 15 +++++++++++++--
 7 files changed, 83 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9f7133e02576..38b7f51e5d84 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -149,6 +149,7 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
+xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
 
 # notify failure
 ifeq ($(CONFIG_MEMORY_FAILURE),y)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7a4c8f1aa76c..931d02678d19 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -41,6 +41,8 @@
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_fsverity.h"
+#include <linux/fsverity.h>
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -4451,6 +4453,11 @@ xfs_bmapi_convert_one_delalloc(
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
index f279055fcea0..9503252a0fa4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -22,6 +22,7 @@
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_fsverity.h"
 #include <linux/bio-integrity.h>
 
 struct xfs_writepage_ctx {
@@ -339,12 +340,16 @@ xfs_map_blocks(
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
@@ -432,7 +437,8 @@ xfs_map_blocks(
 	    isnullstartblock(imap.br_startblock))
 		goto allocate_blocks;
 
-	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, iomap_flags,
+			  XFS_WPC(wpc)->data_seq);
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
@@ -705,6 +711,14 @@ xfs_vm_writepages(
 			},
 		};
 
+		/*
+		 * Writeback does not work for folios past EOF, let it know that
+		 * I/O happens for fsverity metadata and this restriction need
+		 * to be skipped
+		 */
+		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+			wpc.ctx.iomap.flags |= IOMAP_F_FSVERITY;
+
 		return iomap_writepages(&wpc.ctx);
 	}
 }
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
new file mode 100644
index 000000000000..6e6a8636a577
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.c
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#include "xfs_platform.h"
+#include "xfs_format.h"
+#include "xfs_inode.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_fsverity.h"
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
index bd6d33557194..6df48d68a919 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -415,6 +415,12 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
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
index f20a02f49ed9..2af2bc47b9b3 100644
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
@@ -1812,6 +1814,9 @@ xfs_buffered_write_iomap_begin(
 		return xfs_direct_write_iomap_begin(inode, offset, count,
 				flags, iomap, srcmap);
 
+	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		iomap_flags |= IOMAP_F_FSVERITY;
+
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
@@ -2191,12 +2196,17 @@ xfs_read_iomap_begin(
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
@@ -2210,8 +2220,9 @@ xfs_read_iomap_begin(
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
-- 
2.51.2

