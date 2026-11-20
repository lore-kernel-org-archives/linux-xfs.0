Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190310;
	b=eEeajdaX58GksMBVxVcY8JA4ILe6BrqXMdTs3YCcovluAn3/a38C49oGn4BH2wv6+2t5
	 chf2SEHaEEy7uj39BIoKjqsDkic4K4bt3/wq/HNJ+gUsMqHoyjwkoVexITsibTA7lEuEm
	 yZ7pSpyxBcVprJLpjgfNxDb6mWNQsMO2HHFsFzfrlaJ5UhOQRf2Tr6i2B3Dh2ccQ4zTyU
	 fpK4vPExb0iWNXTD5KQ1cmhYV8caI2Z3kwnqgyxhlmaCsmIS5u6tOW/5igtj1sNL9lyqc
	 9h/jWH1PosYdalSar+97U4rThBKpb73aiNsyAsjXHuTeWBj6p4lHv/N4HP+8uKSvJXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cRNvHuL/5PrBLE24h6cbDnjO9r11f0E2kcoBC+EwYWE=;
	b=pSFUl1g8kz+QbHW+a3n0qilNKQV8mwQ3dJUCZ3ig5Z8SE240GTLJSTzw7blaB00HPQpr
	 XLochppyxuWKc5Cdr8tRTrCTbef0/KRlVecI6y7R670dSd7NGVmbMvrWESr03sKsCJZiS
	 +zjChIZRhiv133VP2N49nKwOveXzC5xyvIifgDy/NosPyYlg5nRTsOkwMCUHHfRVZmNEt
	 fiHgJ57/QGU1NuYwX/j3v2D1PVCw+tX2WsL+DpQ9L8NyC0PkazqYZVXjZan5XMEz6nkbH
	 pc3ZH4TQkXereItAj1Wt9qYa3vvxnkFgK8OkNTkLnA3CscmEVWgiN8nn+83XqH9J/sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnZ0dx6v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CD3606A325;
	Fri, 20 Nov 2026 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UnZ0dx6v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E292C1F00AE3;
	Fri, 20 Nov 2026 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190309;
	bh=cRNvHuL/5PrBLE24h6cbDnjO9r11f0E2kcoBC+EwYWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnZ0dx6vgo1hyXAua3Nrk71pfKv3uz4gLoZ3Ua6eoWdwTpp3dUK+GJ7zmUfABdykx
	 1mhW8f+j3374SRG6NesNLsSqeEGinyEadW8sMXqA8f+yhYx4eyNTAubGRRNvVz04DD
	 xWH9Jw8l+Bxrdq/OF5mLnkX21+SrCc59N5euFfELsn68OlZKhik+WbxU1wTmNBXPmK
	 cwjlGdQA40w+X4RJylLoCPbwA8Jagozu8ywQ9oyDZsci7xNJwJ3C22A4qRbVqjytGy
	 qSeFexv4rCEFgVn1qIMGCZ0bj61ki79OSXMoEskl8CzwsXymRb1ZRGG/mqJNg7UVQg
	 TIoISDUrzBXqA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com
Subject: [PATCH v19 05/15] xfs: handle fsverity I/O in write/read path
Date: Fri, 20 Nov 2026 16:57:39 +0100
Message-ID: <20261120155752.192025-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For write/writeback set IOMAP_F_FSVERITY flag telling iomap to not
update inode size and to not skip folios beyond EOF.

Initiate fsverity writeback with IOMAP_F_FSVERITY set to tell iomap
should not skip folio that is dirty beyond EOF.

In read path let iomap know that we are reading fsverity metadata. So,
treat holes in the tree as request to synthesize tree blocks and hole
after descriptor as end of the fsverity region.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/Makefile            |  1 +
 fs/xfs/libxfs/xfs_bmap.c   |  4 +--
 fs/xfs/libxfs/xfs_verity.c | 20 +++++++++++++
 fs/xfs/libxfs/xfs_verity.h | 13 ++++++++
 fs/xfs/xfs_aops.c          |  6 ++--
 fs/xfs/xfs_iomap.c         | 61 ++++++++++++++++++++++++++++----------
 fs/xfs/xfs_iomap.h         |  5 ++--
 fs/xfs/xfs_pnfs.c          |  2 +-
 8 files changed, 89 insertions(+), 23 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_verity.c
 create mode 100644 fs/xfs/libxfs/xfs_verity.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 399a207f2d0e..cb7f71457ee9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -59,6 +59,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_trans_resv.o \
 				   xfs_trans_space.o \
 				   xfs_types.o \
+				   xfs_verity.o \
 				   )
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 050522c58b16..f74411312901 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4414,7 +4414,7 @@ xfs_bmapi_convert_one_delalloc(
 	 * the extent.  Just return the real extent at this offset.
 	 */
 	if (!isnullstartblock(bma.got.br_startblock)) {
-		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
+		xfs_bmbt_to_iomap(ip, iomap, &bma.got, offset, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
 		if (seq)
 			*seq = READ_ONCE(ifp->if_seq);
@@ -4462,7 +4462,7 @@ xfs_bmapi_convert_one_delalloc(
 	XFS_STATS_INC(mp, xs_xstrat_quick);
 
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
-	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
+	xfs_bmbt_to_iomap(ip, iomap, &bma.got, offset, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
 	if (seq)
 		*seq = READ_ONCE(ifp->if_seq);
diff --git a/fs/xfs/libxfs/xfs_verity.c b/fs/xfs/libxfs/xfs_verity.c
new file mode 100644
index 000000000000..c1731b89a5a1
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_verity.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
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
+#include "xfs_verity.h"
+
+loff_t
+xfs_fsverity_metadata_offset(
+	const struct xfs_inode	*ip)
+{
+	return round_up(i_size_read(VFS_IC(ip)), XFS_FSVERITY_START_ALIGN);
+}
diff --git a/fs/xfs/libxfs/xfs_verity.h b/fs/xfs/libxfs/xfs_verity.h
new file mode 100644
index 000000000000..da90f798faa8
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_verity.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#ifndef __XFS_VERITY_H__
+#define __XFS_VERITY_H__
+
+#include "xfs_platform.h"
+#include <linux/fsverity.h>
+
+loff_t xfs_fsverity_metadata_offset(const struct xfs_inode *ip);
+
+#endif	/* __XFS_VERITY_H__ */
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1db6f3640c53..b9728997f944 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -23,6 +23,7 @@
 #include "xfs_ioend.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_verity.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -265,7 +266,8 @@ xfs_map_blocks(
 	    isnullstartblock(imap.br_startblock))
 		goto allocate_blocks;
 
-	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, XFS_WPC(wpc)->data_seq);
+	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, offset, 0, 0,
+			  XFS_WPC(wpc)->data_seq);
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
@@ -441,7 +443,7 @@ xfs_zoned_map_blocks(
 		imap.br_startblock = HOLESTARTBLOCK;
 		imap.br_state = XFS_EXT_NORM;
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, 0);
+		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, offset, 0, 0, 0);
 		return 0;
 	}
 	end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 50eae7ff6145..5117704530f6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -32,6 +32,8 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_verity.h"
+#include <linux/fsverity.h>
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -54,6 +56,15 @@ xfs_alert_fsblock_zero(
 	return -EFSCORRUPTED;
 }
 
+static bool
+xfs_iomap_is_fsverity_metadata(
+	struct xfs_inode	*ip,
+	loff_t			offset)
+{
+	return offset >= xfs_fsverity_metadata_offset(ip) &&
+	       (fsverity_is_building(VFS_I(ip)) || fsverity_active(VFS_I(ip)));
+}
+
 u64
 xfs_iomap_inode_sequence(
 	struct xfs_inode	*ip,
@@ -101,6 +112,7 @@ xfs_bmbt_to_iomap(
 	struct xfs_inode	*ip,
 	struct iomap		*iomap,
 	struct xfs_bmbt_irec	*imap,
+	loff_t			offset,
 	unsigned int		mapping_flags,
 	u16			iomap_flags,
 	u64			sequence_cookie)
@@ -152,6 +164,15 @@ xfs_bmbt_to_iomap(
 			iomap->flags |= IOMAP_F_INTEGRITY;
 	}
 
+	/*
+	 * Tell iomap when this I/O covers fs-verity metadata so it handles size
+	 * updates and post-EOF folios correctly.  The attr fork uses a separate
+	 * offset space, so exclude it.
+	 */
+	if (!(iomap_flags & IOMAP_F_XATTR) &&
+	    xfs_iomap_is_fsverity_metadata(ip, offset))
+		iomap->flags |= IOMAP_F_FSVERITY;
+
 	/*
 	 * If the inode is dirty for datasync purposes, let iomap know so it
 	 * doesn't elide the IO completion journal flushes on O_DSYNC IO.
@@ -1006,7 +1027,8 @@ xfs_direct_write_iomap_begin(
 	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
 	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags, iomap_flags,
+			seq);
 
 allocate_blocks:
 	error = -EAGAIN;
@@ -1037,7 +1059,7 @@ xfs_direct_write_iomap_begin(
 		return error;
 
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags,
 				 iomap_flags | IOMAP_F_NEW, seq);
 
 out_found_cow:
@@ -1045,13 +1067,15 @@ xfs_direct_write_iomap_begin(
 	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
 	if (imap.br_startblock != HOLESTARTBLOCK) {
 		seq = xfs_iomap_inode_sequence(ip, 0);
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, offset, flags,
+				0, seq);
 		if (error)
 			goto out_unlock;
 	}
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 	xfs_iunlock(ip, lockmode);
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags,
+			IOMAP_F_SHARED, seq);
 
 out_unlock:
 	if (lockmode)
@@ -1270,7 +1294,8 @@ xfs_atomic_write_cow_iomap_begin(
 	trace_xfs_iomap_found(ip, offset, length, XFS_COW_FORK, &cmap);
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags,
+			IOMAP_F_SHARED, seq);
 
 convert_delay:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -1622,8 +1647,9 @@ xfs_zoned_fill_srcmap(
 	 */
 	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
 	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
-	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
-			xfs_iomap_inode_sequence(ip, 0));
+	return xfs_bmbt_to_iomap(ip, srcmap, &smap,
+			XFS_FSB_TO_B(ip->i_mount, offset_fsb), flags,
+			0, xfs_iomap_inode_sequence(ip, 0));
 }
 
 static int
@@ -1796,7 +1822,7 @@ xfs_zoned_buffered_write_iomap_begin(
 	trace_xfs_iomap_alloc(ip, offset, XFS_FSB_TO_B(mp, count_fsb),
 			XFS_COW_FORK, &got);
 done:
-	error = xfs_bmbt_to_iomap(ip, iomap, &got, flags, iomap_flags,
+	error = xfs_bmbt_to_iomap(ip, iomap, &got, offset, flags, iomap_flags,
 			xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED));
 out_unlock:
 	xfs_iunlock(ip, lockmode);
@@ -2104,7 +2130,8 @@ xfs_buffered_write_iomap_begin(
 found_imap:
 	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
 	xfs_iunlock(ip, lockmode);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags, iomap_flags,
+			seq);
 
 convert_delay:
 	xfs_iunlock(ip, lockmode);
@@ -2119,8 +2146,8 @@ xfs_buffered_write_iomap_begin(
 
 found_cow:
 	if (imap.br_startoff <= offset_fsb) {
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0,
-				xfs_iomap_inode_sequence(ip, 0));
+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, offset, flags,
+				0, xfs_iomap_inode_sequence(ip, 0));
 		if (error)
 			goto out_unlock;
 	} else {
@@ -2131,7 +2158,8 @@ xfs_buffered_write_iomap_begin(
 	iomap_flags |= IOMAP_F_SHARED;
 	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
 	xfs_iunlock(ip, lockmode);
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, iomap_flags, seq);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags, iomap_flags,
+			seq);
 
 out_unlock:
 	xfs_iunlock(ip, lockmode);
@@ -2238,7 +2266,7 @@ xfs_read_iomap_begin(
 	if (error)
 		return error;
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags,
 				 shared ? IOMAP_F_SHARED : 0, seq);
 }
 
@@ -2298,7 +2326,7 @@ xfs_seek_iomap_begin(
 			end_fsb = min(end_fsb, data_fsb);
 		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
+		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, offset, flags,
 				IOMAP_F_SHARED, seq);
 		/*
 		 * This is a COW extent, so we must probe the page cache
@@ -2322,7 +2350,7 @@ xfs_seek_iomap_begin(
 done:
 	seq = xfs_iomap_inode_sequence(ip, 0);
 	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags, 0, seq);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 	return error;
@@ -2370,7 +2398,8 @@ xfs_xattr_iomap_begin(
 	if (error)
 		return error;
 	ASSERT(nimaps);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, offset, flags,
+			IOMAP_F_XATTR, seq);
 }
 
 DEFINE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next, xfs_xattr_iomap_begin);
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 071fff666507..c9bd6de1bfda 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -22,8 +22,9 @@ xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 
 u64 xfs_iomap_inode_sequence(struct xfs_inode *ip, u16 iomap_flags);
 int xfs_bmbt_to_iomap(struct xfs_inode *ip, struct iomap *iomap,
-		struct xfs_bmbt_irec *imap, unsigned int mapping_flags,
-		u16 iomap_flags, u64 sequence_cookie);
+		struct xfs_bmbt_irec *imap, loff_t offset,
+		unsigned int mapping_flags, u16 iomap_flags,
+		u64 sequence_cookie);
 
 int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
 		struct xfs_zone_alloc_ctx *ac, bool *did_zero);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 065875c8b7da..ff097400d064 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -256,7 +256,7 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, offset, 0, 0, seq);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-- 
2.54.0

