Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B9FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbiLaAC6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiLaAC5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:02:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89641E3CA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:02:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A3AFB81C22
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268B2C433D2;
        Sat, 31 Dec 2022 00:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444972;
        bh=1NylQOT6zXz4iFIxEdtizR6kRMtYDctme9nDnNqDcvk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kas23jA50KFaN/N+i++sdwib8RG40AyweOc0XpQQK/N/EX+XQXu11tvdX1NE1vvUP
         kz+PHiB6RkNTawQfI01RYGwu/bKTrI3gmwV8qQpjaYIX4wEGwBZlQhJZeBtR2O2Z/p
         VenjvcD/2DFdzzEV3hGva9cG+7uR1ha44nZzGEso05zFxdeQ+zxEVYeOpFfoAt84SO
         hLLkbin4sP39I6utgBDhbNf41tWfrQwoTH7Z+Fxw81bROEzYXmsRMej7adE03s3siF
         hTw3kcIKGQt3w/8ddwbIk3x5nfVxGT9DSXwQvbq71B+ShoLYhG91u0r1GST8EnYPxj
         JmkqvRfWD6CCQ==
Subject: [PATCH 1/1] xfs: online repair of symbolic links
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:23 -0800
Message-ID: <167243846317.700901.1179169501507419792.stgit@magnolia>
In-Reply-To: <167243846301.700901.2906379875397268733.stgit@magnolia>
References: <167243846301.700901.2906379875397268733.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a symbolic link target looks bad, try to sift through the rubble to
find as much of the target buffer that we can, and stage a new target
(short or remote format as needed) in a temporary file and use the
atomic extent swapping mechanism to commit the results.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    9 -
 fs/xfs/libxfs/xfs_symlink_remote.h |   22 +-
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  452 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |    5 
 fs/xfs/scrub/trace.h               |   46 ++++
 11 files changed, 560 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6d6ca775553f..e7a8a740318a 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -205,6 +205,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount_repair.o \
 				   repair.o \
 				   rmap_repair.o \
+				   symlink_repair.o \
 				   tempfile.o \
 				   xfblob.o \
 				   xfbtree.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7cbb96a805a3..0dfa84993a9e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -766,7 +766,7 @@ xfs_bmap_local_to_extents_empty(
 }
 
 
-STATIC int				/* error */
+int					/* error */
 xfs_bmap_local_to_extents(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_inode_t	*ip,		/* incore inode pointer */
@@ -776,7 +776,8 @@ xfs_bmap_local_to_extents(
 	void		(*init_fn)(struct xfs_trans *tp,
 				   struct xfs_buf *bp,
 				   struct xfs_inode *ip,
-				   struct xfs_ifork *ifp))
+				   struct xfs_ifork *ifp, void *priv),
+	void		*priv)
 {
 	int		error = 0;
 	int		flags;		/* logging flags returned */
@@ -841,7 +842,7 @@ xfs_bmap_local_to_extents(
 	 * log here. Note that init_fn must also set the buffer log item type
 	 * correctly.
 	 */
-	init_fn(tp, bp, ip, ifp);
+	init_fn(tp, bp, ip, ifp, priv);
 
 	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
@@ -974,8 +975,8 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		return xfs_bmap_local_to_extents(tp, ip, 1, flags,
-						 XFS_DATA_FORK,
-						 xfs_symlink_local_to_remote);
+				XFS_DATA_FORK, xfs_symlink_local_to_remote,
+				NULL);
 
 	/* should only be called for types that support local format data */
 	ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 413ec27f2f24..9559f7174bba 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -174,6 +174,12 @@ unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
+int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_extlen_t total, int *logflagsp, int whichfork,
+		void (*init_fn)(struct xfs_trans *tp, struct xfs_buf *bp,
+				struct xfs_inode *ip, struct xfs_ifork *ifp,
+				void *priv),
+		void *priv);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index b48dcb893a2a..d0c4bd7fb019 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -169,7 +169,8 @@ xfs_symlink_local_to_remote(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*ip,
-	struct xfs_ifork	*ifp)
+	struct xfs_ifork	*ifp,
+	void			*priv)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	char			*buf;
@@ -318,9 +319,10 @@ xfs_symlink_remote_read(
 
 /* Write the symlink target into the inode. */
 int
-xfs_symlink_write_target(
+__xfs_symlink_write_target(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
+	xfs_ino_t		owner,
 	const char		*target_path,
 	int			pathlen,
 	xfs_fsblock_t		fs_blocks,
@@ -375,8 +377,7 @@ xfs_symlink_write_target(
 		byte_cnt = min(byte_cnt, pathlen);
 
 		buf = bp->b_addr;
-		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset, byte_cnt,
-				bp);
+		buf += xfs_symlink_hdr_set(mp, owner, offset, byte_cnt, bp);
 
 		memcpy(buf, cur_chunk, byte_cnt);
 
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index 05eb9c3937d9..45855b78178f 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -16,13 +16,27 @@ int xfs_symlink_hdr_set(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
 bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
-				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+				 struct xfs_inode *ip, struct xfs_ifork *ifp,
+				 void *priv);
 xfs_failaddr_t xfs_symlink_sf_verify_struct(void *sfp, int64_t size);
 xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
-int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
-		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
-		uint resblks);
+int __xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_ino_t owner, const char *target_path, int pathlen,
+		xfs_fsblock_t fs_blocks, uint resblks);
+
+static inline int
+xfs_symlink_write_target(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const char		*target_path,
+	int			pathlen,
+	xfs_fsblock_t		fs_blocks,
+	uint			resblks)
+{
+	return __xfs_symlink_write_target(tp, ip, ip->i_ino, target_path,
+			pathlen, fs_blocks, resblks);
+}
 int xfs_symlink_remote_truncate(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 5a7787e3d3a1..c6461acd1112 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -86,6 +86,7 @@ int xrep_setup_xattr(struct xfs_scrub *sc);
 int xrep_setup_directory(struct xfs_scrub *sc);
 int xrep_setup_parent(struct xfs_scrub *sc);
 int xrep_setup_nlinks(struct xfs_scrub *sc);
+int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *resblks);
 
 int xrep_xattr_reset_fork(struct xfs_scrub *sc);
 
@@ -125,6 +126,7 @@ int xrep_fscounters(struct xfs_scrub *sc);
 int xrep_xattr(struct xfs_scrub *sc);
 int xrep_directory(struct xfs_scrub *sc);
 int xrep_parent(struct xfs_scrub *sc);
+int xrep_symlink(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -215,6 +217,11 @@ xrep_setup_rtsummary(
 	return 0;
 }
 
+static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
+{
+	return 0;
+}
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -240,6 +247,7 @@ xrep_setup_rtsummary(
 #define xrep_xattr			xrep_notsupported
 #define xrep_directory			xrep_notsupported
 #define xrep_parent			xrep_notsupported
+#define xrep_symlink			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b334fd3d7706..a596789e463d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -341,7 +341,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_symlink,
 		.scrub	= xchk_symlink,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_symlink,
 	},
 	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index c134f738bc43..0938d73838f6 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -10,23 +10,34 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_symlink.h"
 #include "xfs_symlink_remote.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub a symbolic link. */
 int
 xchk_setup_symlink(
 	struct xfs_scrub	*sc)
 {
+	unsigned int		resblks = 0;
+	int			error;
+
 	/* Allocate the buffer without the inode lock held. */
 	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
 
-	return xchk_setup_inode_contents(sc, 0);
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_symlink(sc, &resblks);
+		if (error)
+			return error;
+	}
+
+	return xchk_setup_inode_contents(sc, resblks);
 }
 
 /* Symbolic links. */
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
new file mode 100644
index 000000000000..89d9187bc5fe
--- /dev/null
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -0,0 +1,452 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_symlink.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_symlink_remote.h"
+#include "xfs_swapext.h"
+#include "xfs_xchgrange.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
+#include "scrub/reap.h"
+
+/*
+ * Symbolic Link Repair
+ * ====================
+ *
+ * We repair symbolic links by reading whatever target data we can find, up to
+ * the first NULL byte.  Zero length symlinks are turned into links to the
+ * current directory.  The new target is written into a private hidden
+ * temporary file, and then an atomic extent swap commits the new symlink
+ * target to the file being repaired.
+ */
+
+/* Set us up to repair the rtsummary file. */
+int
+xrep_setup_symlink(
+	struct xfs_scrub	*sc,
+	unsigned int		*resblks)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	blocks;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFLNK);
+	if (error)
+		return error;
+
+	/*
+	 * If we're doing a repair, we reserve enough blocks to write out a
+	 * completely new symlink file, plus twice as many blocks as we would
+	 * need if we can only allocate one block per data fork mapping.  This
+	 * should cover the preallocation of the temporary file and swapping
+	 * the extent mappings.
+	 *
+	 * We cannot use xfs_swapext_estimate because we have not yet
+	 * constructed the replacement rtsummary and therefore do not know how
+	 * many extents it will use.  By the time we do, we will have a dirty
+	 * transaction (which we cannot drop because we cannot drop the
+	 * rtsummary ILOCK) and cannot ask for more reservation.
+	 */
+	blocks = xfs_symlink_blocks(sc->mp, XFS_SYMLINK_MAXLEN);
+	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
+	if (blocks > UINT_MAX)
+		return -EOPNOTSUPP;
+
+	*resblks += blocks;
+	return 0;
+}
+
+/* Try to salvage the pathname from rmt blocks. */
+STATIC int
+xrep_symlink_salvage_remote(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_inode	*ip = sc->ip;
+	struct xfs_buf		*bp;
+	char			*target_buf = sc->buf;
+	xfs_failaddr_t		fa;
+	xfs_filblks_t		fsblocks;
+	xfs_daddr_t		d;
+	loff_t			len;
+	loff_t			offset;
+	unsigned int		byte_cnt;
+	bool			magic_ok;
+	bool			hdr_ok;
+	int			n;
+	int			nmaps = XFS_SYMLINK_MAPS;
+	int			error;
+
+	/* We'll only read until the buffer is full. */
+	len = min_t(loff_t, ip->i_disk_size, XFS_SYMLINK_MAXLEN);
+	fsblocks = xfs_symlink_blocks(sc->mp, len);
+	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
+	if (error)
+		return error;
+
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		struct xfs_dsymlink_hdr	*dsl;
+
+		d = XFS_FSB_TO_DADDR(sc->mp, mval[n].br_startblock);
+
+		/* Read the rmt block.  We'll run the verifiers manually. */
+		error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+				d, XFS_FSB_TO_BB(sc->mp, mval[n].br_blockcount),
+				0, &bp, NULL);
+		if (error)
+			return error;
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		/* How many bytes do we expect to get out of this buffer? */
+		byte_cnt = XFS_FSB_TO_B(sc->mp, mval[n].br_blockcount);
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(sc->mp, byte_cnt);
+		byte_cnt = min_t(unsigned int, byte_cnt, len);
+
+		/*
+		 * See if the verifiers accept this block.  We're willing to
+		 * salvage if the if the offset/byte/ino are ok and either the
+		 * verifier passed or the magic is ok.  Anything else and we
+		 * stop dead in our tracks.
+		 */
+		fa = bp->b_ops->verify_struct(bp);
+		dsl = bp->b_addr;
+		magic_ok = dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC);
+		hdr_ok = xfs_symlink_hdr_ok(ip->i_ino, offset, byte_cnt, bp);
+		if (!hdr_ok || (fa != NULL && !magic_ok))
+			break;
+
+		memcpy(target_buf + offset, dsl + 1, byte_cnt);
+
+		len -= byte_cnt;
+		offset += byte_cnt;
+	}
+
+	/* Ensure we have a zero at the end, and /some/ contents. */
+	if (offset == 0 || target_buf[0] == 0)
+		sprintf(target_buf, ".");
+	else
+		target_buf[offset] = 0;
+	return 0;
+}
+
+/*
+ * Try to salvage an inline symlink's contents.  Empty symlinks become a link
+ * to the current directory.
+ */
+STATIC void
+xrep_symlink_salvage_inline(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_inode	*ip = sc->ip;
+	char			*target_buf = sc->buf;
+	struct xfs_ifork	*ifp;
+
+	ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	if (ifp->if_u1.if_data)
+		strncpy(target_buf, ifp->if_u1.if_data, xfs_inode_data_fork_size(ip));
+	if (target_buf[0] == 0)
+		sprintf(target_buf, ".");
+}
+
+/* Salvage whatever we can of the target. */
+STATIC int
+xrep_symlink_salvage(
+	struct xfs_scrub	*sc)
+{
+	if (sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		xrep_symlink_salvage_inline(sc);
+	} else {
+		int		error = xrep_symlink_salvage_remote(sc);
+
+		if (error)
+			return error;
+	}
+
+	trace_xrep_symlink_salvage_target(sc->ip, sc->buf, strlen(sc->buf));
+	return 0;
+}
+
+STATIC void
+xrep_symlink_local_to_remote(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp,
+	void			*priv)
+{
+	struct xfs_scrub	*sc = priv;
+	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
+
+	xfs_symlink_local_to_remote(tp, bp, ip, ifp, NULL);
+
+	if (!xfs_has_crc(sc->mp))
+		return;
+
+	dsl->sl_owner = cpu_to_be64(sc->ip->i_ino);
+	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
+					ifp->if_bytes - 1);
+}
+
+/*
+ * Prepare both links' data forks for extent swapping.  Promote the tempfile
+ * from local format to extents format, and if the file being repaired has a
+ * short format data fork, turn it into an empty extent list.
+ */
+STATIC int
+xrep_symlink_swap_prep(
+	struct xfs_scrub	*sc,
+	bool			temp_local,
+	bool			ip_local)
+{
+	int			error;
+
+	/*
+	 * If the temp link is in shortform format, convert that to a remote
+	 * target so that we can use the atomic extent swap.
+	 */
+	if (temp_local) {
+		int		logflags = XFS_ILOG_CORE;
+
+		error = xfs_bmap_local_to_extents(sc->tp, sc->tempip, 1,
+				&logflags, XFS_DATA_FORK,
+				xrep_symlink_local_to_remote,
+				sc);
+		if (error)
+			return error;
+
+		xfs_trans_log_inode(sc->tp, sc->ip, 0);
+
+		error = xfs_defer_finish(&sc->tp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If the file being repaired had a shortform data fork, convert that
+	 * to an empty extent list in preparation for the atomic extent swap.
+	 */
+	if (ip_local) {
+		struct xfs_ifork	*ifp;
+
+		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+		xfs_idestroy_fork(ifp);
+		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+		ifp->if_nextents = 0;
+		ifp->if_bytes = 0;
+		ifp->if_u1.if_root = NULL;
+		ifp->if_height = 0;
+
+		xfs_trans_log_inode(sc->tp, sc->ip,
+				XFS_ILOG_CORE | XFS_ILOG_DDATA);
+	}
+
+	return 0;
+}
+
+/* Swap the temporary link's data fork with the one being repaired. */
+STATIC int
+xrep_symlink_swap(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_tempswap	*tx = sc->buf;
+	bool			ip_local, temp_local;
+	int			error;
+
+	/*
+	 * We're done with the temporary buffer, so we can reuse it for the
+	 * tempfile swap information.
+	 */
+	error = xrep_tempswap_trans_alloc(sc, XFS_DATA_FORK, tx);
+	if (error)
+		return error;
+
+	ip_local = sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+	temp_local = sc->tempip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+
+	/*
+	 * If the both links have a local format data fork and the rebuilt
+	 * remote data would fit in the repaired file's data fork, copy the
+	 * contents from the tempfile and declare ourselves done.
+	 */
+	if (ip_local && temp_local &&
+	    sc->tempip->i_disk_size <= xfs_inode_data_fork_size(sc->ip)) {
+		xrep_tempfile_copyout_local(sc, XFS_DATA_FORK);
+		return 0;
+	}
+
+	/* Otherwise, make sure both data forks are in block-mapping mode. */
+	error = xrep_symlink_swap_prep(sc, temp_local, ip_local);
+	if (error)
+		return error;
+
+	return xrep_tempswap_contents(sc, tx);
+}
+
+/*
+ * Free all the remote blocks and reset the data fork.  The caller must join
+ * the inode to the transaction.  This function returns with the inode joined
+ * to a clean scrub transaction.
+ */
+STATIC int
+xrep_symlink_reset_fork(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->tempip, XFS_DATA_FORK);
+	int			error;
+
+	/* Unmap all the remote target buffers. */
+	if (xfs_ifork_has_extents(ifp)) {
+		error = xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	trace_xrep_symlink_reset_fork(sc->tempip);
+
+	/* Reset the temp link to have the same dummy content. */
+	xfs_idestroy_fork(ifp);
+	error = xfs_symlink_write_target(sc->tp, sc->tempip, ".", 1, 0, 0);
+	if (error)
+		return error;
+
+	return xrep_tempfile_roll_trans(sc);
+}
+
+/*
+ * Reinitialize a link target.  Caller must ensure the inode is joined to
+ * the transaction.
+ */
+STATIC int
+xrep_symlink_rebuild(
+	struct xfs_scrub	*sc)
+{
+	char			*target_buf = sc->buf;
+	xfs_fsblock_t		fs_blocks;
+	unsigned int		target_len;
+	unsigned int		resblks;
+	int			error;
+
+	/* How many blocks do we need? */
+	target_len = strlen(target_buf);
+	ASSERT(target_len != 0);
+	if (target_len == 0 || target_len > XFS_SYMLINK_MAXLEN)
+		return -EFSCORRUPTED;
+
+	trace_xrep_symlink_rebuild(sc->ip);
+
+	/*
+	 * In preparation to write the new symlink target to the temporary
+	 * file, drop the ILOCK of the file being repaired (it shouldn't be
+	 * joined) and take the ILOCK of the temporary file.
+	 *
+	 * The VFS does not take the IOLOCK while reading a symlink (and new
+	 * symlinks are hidden with INEW until they've been written) so it's
+	 * possible that a readlink() could see the old corrupted contents
+	 * while we're doing this.
+	 */
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_tempfile_ilock(sc);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	/*
+	 * Reserve resources to reinitialize the target.  We're allowed to
+	 * exceed file quota to repair inconsistent metadata, though this is
+	 * unlikely.
+	 */
+	fs_blocks = xfs_symlink_blocks(sc->mp, target_len);
+	resblks = XFS_SYMLINK_SPACE_RES(sc->mp, target_len, fs_blocks);
+	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->tempip, resblks, 0,
+			true);
+	if (error)
+		return error;
+
+	/* Erase the dummy target set up by the tempfile initialization. */
+	xfs_idestroy_fork(&sc->tempip->i_df);
+	sc->tempip->i_df.if_bytes = 0;
+	sc->tempip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+
+	/* Write the salvaged target to the temporary link. */
+	error = __xfs_symlink_write_target(sc->tp, sc->tempip, sc->ip->i_ino,
+			target_buf, target_len, fs_blocks, resblks);
+	if (error)
+		return error;
+
+	/*
+	 * Commit the repair transaction so that we can use the atomic extent
+	 * swap helper functions to compute the correct block reservations and
+	 * re-lock the inodes.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	xrep_tempfile_iunlock(sc);
+
+	/*
+	 * Swap the temp link's data fork with the file being repaired.  This
+	 * recreates the transaction and takes the ILOCKs of the file being
+	 * repaired and the temporary file.
+	 */
+	error = xrep_symlink_swap(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Release the old symlink blocks and reset the data fork of the temp
+	 * link to an empty shortform link.
+	 */
+	return xrep_symlink_reset_fork(sc);
+}
+
+/* Repair a symbolic link. */
+int
+xrep_symlink(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
+
+	error = xrep_symlink_salvage(sc);
+	if (error)
+		return error;
+
+	/* Now reset the target. */
+	return xrep_symlink_rebuild(sc);
+}
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index b275c0b764f4..e5087f14343b 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -21,6 +21,7 @@
 #include "xfs_xchgrange.h"
 #include "xfs_swapext.h"
 #include "xfs_defer.h"
+#include "xfs_symlink_remote.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -109,6 +110,10 @@ xrep_tempfile_create(
 		error = xfs_dir_init(tp, sc->tempip, dp);
 		if (error)
 			goto out_trans_cancel;
+	} else if (S_ISLNK(VFS_I(sc->tempip)->i_mode)) {
+		error = xfs_symlink_write_target(tp, sc->tempip, ".", 1, 0, 0);
+		if (error)
+			goto out_trans_cancel;
 	}
 
 	/*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b29ed4dde427..1cacea2ba195 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2596,6 +2596,52 @@ DEFINE_REPAIR_DENTRY_EVENT(xrep_orphanage_check_child);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_orphanage_check_dentry);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_orphanage_zap_child);
 
+TRACE_EVENT(xrep_symlink_salvage_target,
+	TP_PROTO(struct xfs_inode *ip, char *target, unsigned int targetlen),
+	TP_ARGS(ip, target, targetlen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, targetlen)
+		__dynamic_array(char, target, targetlen + 1)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->targetlen = targetlen;
+		memcpy(__get_str(target), target, targetlen);
+		__get_str(target)[targetlen] = 0;
+	),
+	TP_printk("dev %d:%d ip 0x%llx target '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->targetlen,
+		  __get_str(target))
+);
+
+DECLARE_EVENT_CLASS(xrep_symlink_class,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+	),
+	TP_printk("dev %d:%d ip 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino)
+);
+
+#define DEFINE_XREP_SYMLINK_EVENT(name) \
+DEFINE_EVENT(xrep_symlink_class, name, \
+	TP_PROTO(struct xfs_inode *ip), \
+	TP_ARGS(ip))
+DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_rebuild);
+DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_reset_fork);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 

