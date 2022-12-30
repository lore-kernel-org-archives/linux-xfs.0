Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E9CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbiLaABY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiLaABX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:01:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D0362C1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:01:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4565B61CB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971ABC433EF;
        Sat, 31 Dec 2022 00:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444878;
        bh=bO2KPJenl+6pquoG5crl6Pd2HRVoqWn7zf+Ux9dHWBg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hiq7k7xjgAD0kx1PUHsXSr8Z94ksBfFSQl503oapIOIslIHPhDBHLQCuq30XA7TDk
         sjcU0zhXjHJjdQ6wSj0ZdMoyDf3PwAcCpE07oMu9NiHXMdNG7eC1CK9xLBPg5GB6qT
         LQGPdTc4bAUbxAyrKJmegZ/VK9dpU7aFtJcEFDXeGCf6RVhL+3C5xjXonYrJm/vv5C
         7Pq83qb8DHS0UapKdE3nX+RStNx2q+SpnqbzHtjZbH9SFeYptIXIguDM9NM5aRQWrt
         7gKN9R3Dmmpekn1761kDYOfLJcj8Og5Q8CNiND5unELB8uYRx7eyDLmgsZmdJuPU+Q
         wHQDC3//EeiJA==
Subject: [PATCH 1/3] xfs: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:16 -0800
Message-ID: <167243845654.700660.5987851769478821645.stgit@magnolia>
In-Reply-To: <167243845636.700660.17331865239070788293.stgit@magnolia>
References: <167243845636.700660.17331865239070788293.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a directory looks like it's in bad shape, try to sift through the
rubble to find whatever directory entries we can, scan the directory
tree for the parent (if needed), stage the new directory contents in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.  As a side effect of this patch, directory
inactivation will be able to purge any leftover dir blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1152 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.c        |   23 +
 fs/xfs/scrub/nlinks_repair.c |    9 
 fs/xfs/scrub/repair.c        |   29 +
 fs/xfs/scrub/repair.h        |    5 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/tempfile.c      |   13 
 fs/xfs/scrub/tempfile.h      |    2 
 fs/xfs/scrub/trace.h         |  135 +++++
 fs/xfs/xfs_inode.c           |   51 ++
 12 files changed, 1430 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0ae616f25a98..43536f1b351e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -191,6 +191,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   attr_repair.o \
 				   bmap_repair.o \
 				   cow_repair.o \
+				   dir_repair.o \
 				   fscounters_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index ab6daf8549c1..218cf43cdf93 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -19,12 +19,21 @@
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/readdir.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub directories. */
 int
 xchk_setup_directory(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_directory(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_inode_contents(sc, 0);
 }
 
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
new file mode 100644
index 000000000000..99d8ce8528c5
--- /dev/null
+++ b/fs/xfs/scrub/dir_repair.c
@@ -0,0 +1,1152 @@
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
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_bmap_util.h"
+#include "xfs_swapext.h"
+#include "xfs_xchgrange.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
+#include "scrub/readdir.h"
+#include "scrub/reap.h"
+
+/*
+ * Directory Repair
+ * ================
+ *
+ * We repair directories by reading the directory data blocks looking for
+ * directory entries.  Salvaged entries are added to a private hidden temporary
+ * dir without touching the link counts of the inodes found.  When we're done
+ * salvaging, we rewrite the directory block owners and use an atomic extent
+ * swap to commit the new directory blocks to the directory being repaired.
+ * This will disrupt readdir cursors, but there's not much else we can do.
+ */
+
+/* Directory entry to be restored in the new directory. */
+struct xrep_dirent {
+	/* Cookie for retrieval of the dirent name. */
+	xfblob_cookie		name_cookie;
+
+	/* Target inode number. */
+	xfs_ino_t		ino;
+
+	/* Hash of the dirent name. */
+	unsigned int		hash;
+
+	/* Length of the dirent name. */
+	uint8_t			namelen;
+
+	/* File type of the dirent. */
+	uint8_t			ftype;
+};
+
+struct xrep_dir {
+	struct xfs_scrub	*sc;
+
+	struct xrep_tempswap	tx;
+
+	/* Fixed-size array of xrep_dirent structures. */
+	struct xfarray		*dir_entries;
+
+	/* Blobs containing directory entry names. */
+	struct xfblob		*dir_names;
+
+	/*
+	 * This is the parent that we're going to set on the reconstructed
+	 * directory.
+	 */
+	xfs_ino_t		parent_ino;
+
+	/* nlink value of the corrected directory. */
+	xfs_nlink_t		new_nlink;
+
+	/* Preallocated args struct for performing dir operations */
+	struct xfs_da_args	args;
+
+	/* Directory entry name, plus the trailing null. */
+	char			namebuf[MAXNAMELEN];
+};
+
+/* Absorb up to 8 pages of dirents before we flush them to the temp dir. */
+#define XREP_DIR_SALVAGE_BYTES	(PAGE_SIZE * 8)
+
+/* Set up for a directory repair. */
+int
+xrep_setup_directory(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFDIR);
+	if (error)
+		return error;
+
+	sc->buf = kvzalloc(sizeof(struct xrep_dir), XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Decide if we want to salvage this entry.  We don't bother with oversized
+ * names or the dot entry.
+ */
+STATIC int
+xrep_dir_want_salvage(
+	struct xrep_dir		*rd,
+	const char		*name,
+	int			namelen,
+	xfs_ino_t		ino)
+{
+	struct xfs_mount	*mp = rd->sc->mp;
+
+	/* No pointers to ourselves or to garbage. */
+	if (ino == rd->sc->ip->i_ino)
+		return false;
+	if (!xfs_verify_dir_ino(mp, ino))
+		return false;
+
+	/* No weird looking names or dot entries. */
+	if (namelen >= MAXNAMELEN || namelen <= 0)
+		return false;
+	if (namelen == 1 && name[0] == '.')
+		return false;
+
+	return true;
+}
+
+/* Allocate an in-core record to hold entries while we rebuild the dir data. */
+STATIC int
+xrep_dir_salvage_entry(
+	struct xrep_dir		*rd,
+	unsigned char		*name,
+	unsigned int		namelen,
+	xfs_ino_t		ino)
+{
+	struct xrep_dirent	entry = {
+		.ino		= ino,
+	};
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_inode	*ip;
+	unsigned int		i = 0;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/*
+	 * Truncate the name to the first character that would trip namecheck.
+	 * If we no longer have a name after that, ignore this entry.
+	 */
+	while (i < namelen && name[i] != 0 && name[i] != '/')
+		i++;
+	if (i == 0)
+		return 0;
+	entry.namelen = i;
+	entry.hash = xfs_da_hashname(name, entry.namelen);
+
+	/* Ignore '..' entries; we already picked the new parent. */
+	if (entry.namelen == 2 && name[0] == '.' && name[1] == '.') {
+		trace_xrep_dir_salvaged_parent(sc->ip, ino);
+		return 0;
+	}
+
+	trace_xrep_dir_salvage_entry(sc->ip, name, entry.namelen, ino);
+
+	/*
+	 * Compute the ftype or dump the entry if we can't.  We don't lock the
+	 * inode because inodes can't change type while we have a reference.
+	 */
+	error = xchk_iget(sc, ino, &ip);
+	if (error)
+		return 0;
+
+	entry.ftype = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
+	xchk_irele(sc, ip);
+
+	/* Remember this for later. */
+	error = xfblob_store(rd->dir_names, &entry.name_cookie, name,
+			entry.namelen);
+	if (error)
+		return error;
+
+	return xfarray_append(rd->dir_entries, &entry);
+}
+
+/* Record a shortform directory entry for later reinsertion. */
+STATIC int
+xrep_dir_salvage_sf_entry(
+	struct xrep_dir			*rd,
+	struct xfs_dir2_sf_hdr		*sfp,
+	struct xfs_dir2_sf_entry	*sfep)
+{
+	xfs_ino_t			ino;
+
+	ino = xfs_dir2_sf_get_ino(rd->sc->mp, sfp, sfep);
+	if (!xrep_dir_want_salvage(rd, sfep->name, sfep->namelen, ino))
+		return 0;
+
+	return xrep_dir_salvage_entry(rd, sfep->name, sfep->namelen, ino);
+}
+
+/* Record a regular directory entry for later reinsertion. */
+STATIC int
+xrep_dir_salvage_data_entry(
+	struct xrep_dir			*rd,
+	struct xfs_dir2_data_entry	*dep)
+{
+	xfs_ino_t			ino;
+
+	ino = be64_to_cpu(dep->inumber);
+	if (!xrep_dir_want_salvage(rd, dep->name, dep->namelen, ino))
+		return 0;
+
+	return xrep_dir_salvage_entry(rd, dep->name, dep->namelen, ino);
+}
+
+/* Try to recover block/data format directory entries. */
+STATIC int
+xrep_dir_recover_data(
+	struct xrep_dir		*rd,
+	struct xfs_buf		*bp)
+{
+	struct xfs_da_geometry	*geo = rd->sc->mp->m_dir_geo;
+	unsigned int		offset;
+	unsigned int		end;
+	int			error = 0;
+
+	/*
+	 * Loop over the data portion of the block.
+	 * Each object is a real entry (dep) or an unused one (dup).
+	 */
+	offset = geo->data_entry_offset;
+	end = min_t(unsigned int, BBTOB(bp->b_length),
+			xfs_dir3_data_end_offset(geo, bp->b_addr));
+
+	while (offset < end) {
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+
+		if (xchk_should_terminate(rd->sc, &error))
+			return error;
+
+		/* Skip unused entries. */
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			offset += be16_to_cpu(dup->length);
+			continue;
+		}
+
+		/* Don't walk off the end of the block. */
+		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (offset > end)
+			break;
+
+		/* Ok, let's save this entry. */
+		error = xrep_dir_salvage_data_entry(rd, dep);
+		if (error)
+			return error;
+
+	}
+
+	return 0;
+}
+
+/* Try to recover shortform directory entries. */
+STATIC int
+xrep_dir_recover_sf(
+	struct xrep_dir			*rd)
+{
+	struct xfs_dir2_sf_hdr		*sfp;
+	struct xfs_dir2_sf_entry	*sfep;
+	struct xfs_dir2_sf_entry	*next;
+	struct xfs_ifork		*ifp;
+	xfs_ino_t			ino;
+	unsigned char			*end;
+	int				error = 0;
+
+	ifp = xfs_ifork_ptr(rd->sc->ip, XFS_DATA_FORK);
+	sfp = (struct xfs_dir2_sf_hdr *)rd->sc->ip->i_df.if_u1.if_data;
+	end = (unsigned char *)ifp->if_u1.if_data + ifp->if_bytes;
+
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
+	trace_xrep_dir_salvaged_parent(rd->sc->ip, ino);
+
+	sfep = xfs_dir2_sf_firstentry(sfp);
+	while ((unsigned char *)sfep < end) {
+		if (xchk_should_terminate(rd->sc, &error))
+			return error;
+
+		next = xfs_dir2_sf_nextentry(rd->sc->mp, sfp, sfep);
+		if ((unsigned char *)next > end)
+			break;
+
+		/* Ok, let's save this entry. */
+		error = xrep_dir_salvage_sf_entry(rd, sfp, sfep);
+		if (error)
+			return error;
+
+		sfep = next;
+	}
+
+	return 0;
+}
+
+/*
+ * Try to figure out the format of this directory from the data fork mappings
+ * and the directory size.  If we can be reasonably sure of format, we can be
+ * more aggressive in salvaging directory entries.  On return, @magic_guess
+ * will be set to DIR3_BLOCK_MAGIC if we think this is a "block format"
+ * directory; DIR3_DATA_MAGIC if we think this is a "data format" directory,
+ * and 0 if we can't tell.
+ */
+STATIC void
+xrep_dir_guess_format(
+	struct xrep_dir		*rd,
+	__be32			*magic_guess)
+{
+	struct xfs_inode	*ip = rd->sc->ip;
+	struct xfs_da_geometry	*geo = rd->sc->mp->m_dir_geo;
+	xfs_fileoff_t		last;
+	int			error;
+
+	ASSERT(xfs_has_crc(ip->i_mount));
+
+	*magic_guess = 0;
+
+	/*
+	 * If there's a single directory block and the directory size is
+	 * exactly one block, this has to be a single block format directory.
+	 */
+	error = xfs_bmap_last_offset(ip, &last, XFS_DATA_FORK);
+	if (!error && XFS_FSB_TO_B(ip->i_mount, last) == geo->blksize &&
+	    ip->i_disk_size == geo->blksize) {
+		*magic_guess = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
+		return;
+	}
+
+	/*
+	 * If the last extent before the leaf offset matches the directory
+	 * size and the directory size is larger than 1 block, this is a
+	 * data format directory.
+	 */
+	last = geo->leafblk;
+	error = xfs_bmap_last_before(rd->sc->tp, ip, &last, XFS_DATA_FORK);
+	if (!error &&
+	    XFS_FSB_TO_B(ip->i_mount, last) > geo->blksize &&
+	    XFS_FSB_TO_B(ip->i_mount, last) == ip->i_disk_size) {
+		*magic_guess = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
+		return;
+	}
+}
+
+/* Recover directory entries from a specific directory block. */
+STATIC int
+xrep_dir_recover_dirblock(
+	struct xrep_dir		*rd,
+	__be32			magic_guess,
+	xfs_dablk_t		dabno)
+{
+	struct xfs_dir2_data_hdr *hdr;
+	struct xfs_buf		*bp;
+	__be32			oldmagic;
+	int			error;
+
+	/*
+	 * Try to read buffer.  We invalidate them in the next step so we don't
+	 * bother to set a buffer type or ops.
+	 */
+	error = xfs_da_read_buf(rd->sc->tp, rd->sc->ip, dabno,
+			XFS_DABUF_MAP_HOLE_OK, &bp, XFS_DATA_FORK, NULL);
+	if (error || !bp)
+		return error;
+
+	hdr = bp->b_addr;
+	oldmagic = hdr->magic;
+
+	trace_xrep_dir_recover_dirblock(rd->sc->ip, dabno,
+			be32_to_cpu(hdr->magic), be32_to_cpu(magic_guess));
+
+	/*
+	 * If we're sure of the block's format, proceed with the salvage
+	 * operation using the specified magic number.
+	 */
+	if (magic_guess) {
+		hdr->magic = magic_guess;
+		goto recover;
+	}
+
+	/*
+	 * If we couldn't guess what type of directory this is, then we will
+	 * only salvage entries from directory blocks that match the magic
+	 * number and pass verifiers.
+	 */
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
+		if (!xrep_buf_verify_struct(bp, &xfs_dir3_block_buf_ops))
+			goto out;
+		if (xfs_dir3_block_header_check(bp, rd->sc->ip->i_ino) != NULL)
+			goto out;
+		break;
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+		if (!xrep_buf_verify_struct(bp, &xfs_dir3_data_buf_ops))
+			goto out;
+		if (xfs_dir3_data_header_check(bp, rd->sc->ip->i_ino) != NULL)
+			goto out;
+		break;
+	default:
+		goto out;
+	}
+
+recover:
+	error = xrep_dir_recover_data(rd, bp);
+
+out:
+	hdr->magic = oldmagic;
+	xfs_trans_brelse(rd->sc->tp, bp);
+	return error;
+}
+
+static inline void xrep_dir_init_args(struct xrep_dir *rd)
+{
+	memset(&rd->args, 0, sizeof(struct xfs_da_args));
+	rd->args.geo = rd->sc->mp->m_dir_geo;
+	rd->args.whichfork = XFS_DATA_FORK;
+	rd->args.owner = rd->sc->ip->i_ino;
+	rd->args.trans = rd->sc->tp;
+}
+
+/*
+ * Enter a name in a directory, or check for available space.
+ * If inum is 0, only the available space test is performed.
+ */
+STATIC int
+xrep_dir_createname(
+	struct xrep_dir		*rd,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
+	xfs_ino_t		inum,
+	xfs_extlen_t		total)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	if (inum) {
+		error = xfs_dir_ino_validate(sc->mp, inum);
+		if (error)
+			return error;
+	}
+
+	xrep_dir_init_args(rd);
+	rd->args.name = name->name;
+	rd->args.namelen = name->len;
+	rd->args.filetype = name->type;
+	rd->args.hashval = xfs_dir2_hashname(sc->mp, name);
+	rd->args.inumber = inum;
+	rd->args.dp = dp;
+	rd->args.total = total;
+	rd->args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_addname(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_addname(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_addname(&rd->args);
+
+	return xfs_dir2_node_addname(&rd->args);
+}
+
+/* Insert one dir entry without cycling locks or transactions. */
+STATIC int
+xrep_dir_insert_rec(
+	struct xrep_dir			*rd,
+	const struct xrep_dirent	*entry)
+{
+	struct xfs_name			name = {
+		.len			= entry->namelen,
+		.type			= entry->ftype,
+		.name			= rd->namebuf,
+	};
+	struct xfs_mount		*mp = rd->sc->mp;
+	char				*namebuf = rd->namebuf;
+	xfs_ino_t			ino;
+	uint				resblks;
+	int				error;
+
+	/* The entry name is stored in the in-core buffer. */
+	error = xfblob_load(rd->dir_names, entry->name_cookie, namebuf,
+			entry->namelen);
+	if (error)
+		return error;
+	namebuf[MAXNAMELEN - 1] = 0;
+
+	trace_xrep_dir_insert_rec(rd->sc->tempip, &name, entry->ino);
+
+	resblks = XFS_LINK_SPACE_RES(mp, entry->namelen);
+	error = xchk_trans_alloc(rd->sc, resblks);
+	if (error)
+		return error;
+
+	/*
+	 * Lock the temporary directory and join it to the transaction, and
+	 * make sure this filename isn't unique before we add it.
+	 */
+	xrep_tempfile_ilock(rd->sc);
+	xfs_trans_ijoin(rd->sc->tp, rd->sc->tempip, 0);
+
+	error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
+	if (error != -ENOENT)
+		goto out_cancel;
+
+	error = xrep_dir_createname(rd, rd->sc->tempip, &name, entry->ino,
+			resblks);
+	if (error)
+		goto out_cancel;
+
+	if (name.type == XFS_DIR3_FT_DIR)
+		rd->new_nlink++;
+
+	/* Commit and unlock. */
+	error = xrep_trans_commit(rd->sc);
+	if (error)
+		return error;
+
+	xrep_tempfile_iunlock(rd->sc);
+	return 0;
+out_cancel:
+	xchk_trans_cancel(rd->sc);
+	xrep_tempfile_iunlock(rd->sc);
+	return error;
+}
+
+/*
+ * Periodically flush salvaged directory entries to the temporary file.  This
+ * is done to reduce the memory requirements of the directory rebuild, since
+ * directories can contain up to 32GB of directory data.
+ */
+STATIC int
+xrep_dir_flush_salvaged(
+	struct xrep_dir		*rd)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	/*
+	 * Entering this function, the scrub context has a reference to the
+	 * inode being repaired, the temporary file, and a scrub transaction
+	 * that we use during dirent salvaging to avoid livelocking if there
+	 * are cycles in the directory structures.  We hold ILOCK_EXCL on both
+	 * the inode being repaired and the temporary file, though they are
+	 * not ijoined to the scrub transaction.
+	 *
+	 * To constrain kernel memory use, we occasionally write salvaged
+	 * dirents from the xfarray and xfblob structures into the temporary
+	 * directory in preparation for swapping the directory structures at
+	 * the end.  Updating the temporary file requires a transaction, so we
+	 * commit the scrub transaction and drop the two ILOCKs so that
+	 * we can allocate whatever transaction we want.
+	 *
+	 * We still hold IOLOCK_EXCL on the inode being repaired, which
+	 * prevents anyone from accessing the damaged directory data while we
+	 * repair it.
+	 */
+	error = xrep_trans_commit(rd->sc);
+	if (error)
+		return error;
+	xchk_iunlock(rd->sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Take the IOLOCK of the temporary file while we modify dirents.  This
+	 * isn't strictly required because the temporary file is never revealed
+	 * to userspace, but we follow the same locking rules.
+	 */
+	while (!xrep_tempfile_iolock_nowait(rd->sc)) {
+		if (xchk_should_terminate(rd->sc, &error))
+			return error;
+		delay(1);
+	}
+
+	/* Add all the salvaged dirents to the temporary directory. */
+	foreach_xfarray_idx(rd->dir_entries, array_cur) {
+		struct xrep_dirent	entry;
+
+		error = xfarray_load(rd->dir_entries, array_cur, &entry);
+		if (error)
+			return error;
+
+		error = xrep_dir_insert_rec(rd, &entry);
+		if (error)
+			return error;
+	}
+	xrep_tempfile_iounlock(rd->sc);
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rd->dir_entries);
+	xfblob_truncate(rd->dir_names);
+
+	/* Recreate the salvage transaction and relock both inodes. */
+	error = xchk_trans_alloc(rd->sc, 0);
+	if (error)
+		return error;
+	xchk_ilock(rd->sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/* Extract as many directory entries as we can. */
+STATIC int
+xrep_dir_recover(
+	struct xrep_dir		*rd)
+{
+	struct xfs_bmbt_irec	got;
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_da_geometry	*geo = sc->mp->m_dir_geo;
+	xfs_fileoff_t		offset;
+	xfs_dablk_t		dabno;
+	__be32			magic_guess;
+	int			nmap;
+	int			error;
+
+	xrep_dir_guess_format(rd, &magic_guess);
+
+	/* Iterate each directory data block in the data fork. */
+	for (offset = 0;
+	     offset < geo->leafblk;
+	     offset = got.br_startoff + got.br_blockcount) {
+		nmap = 1;
+		error = xfs_bmapi_read(sc->ip, offset, geo->leafblk - offset,
+				&got, &nmap, 0);
+		if (error)
+			return error;
+		if (nmap != 1)
+			return -EFSCORRUPTED;
+		if (!xfs_bmap_is_written_extent(&got))
+			continue;
+
+		for (dabno = round_up(got.br_startoff, geo->fsbcount);
+		     dabno < got.br_startoff + got.br_blockcount;
+		     dabno += geo->fsbcount) {
+			if (xchk_should_terminate(rd->sc, &error))
+				return error;
+
+			error = xrep_dir_recover_dirblock(rd,
+					magic_guess, dabno);
+			if (error)
+				return error;
+
+			/* Flush dirents to constrain memory usage. */
+			if (xfarray_bytes(rd->dir_entries) +
+			    xfblob_bytes(rd->dir_names) <
+			    XREP_DIR_SALVAGE_BYTES)
+				continue;
+
+			error = xrep_dir_flush_salvaged(rd);
+			if (error)
+				return error;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Find all the directory entries for this inode by scraping them out of the
+ * directory leaf blocks by hand, and flushing them into the temp dir.
+ */
+STATIC int
+xrep_dir_find_entries(
+	struct xrep_dir		*rd)
+{
+	struct xfs_inode	*ip = rd->sc->ip;
+	int			error;
+
+	/*
+	 * Salvage directory entries from the old directory, and write them to
+	 * the temporary directory.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xrep_dir_recover_sf(rd);
+	} else {
+		error = xfs_iread_extents(rd->sc->tp, ip, XFS_DATA_FORK);
+		if (error)
+			return error;
+
+		error = xrep_dir_recover(rd);
+	}
+	if (error)
+		return error;
+
+	return xrep_dir_flush_salvaged(rd);
+}
+
+/*
+ * Free all the directory blocks and reset the data fork.  The caller must
+ * join the inode to the transaction.  This function returns with the inode
+ * joined to a clean scrub transaction.
+ */
+STATIC int
+xrep_dir_reset_fork(
+	struct xrep_dir		*rd,
+	xfs_ino_t		parent_ino)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->tempip, XFS_DATA_FORK);
+	int			error;
+
+	/* Unmap all the directory buffers. */
+	if (xfs_ifork_has_extents(ifp)) {
+		error = xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	trace_xrep_dir_reset_fork(sc->tempip, parent_ino);
+
+	/* Reset the data fork to an empty data fork. */
+	xfs_idestroy_fork(ifp);
+	ifp->if_bytes = 0;
+	sc->tempip->i_disk_size = 0;
+
+	/* Reinitialize the short form directory. */
+	xrep_dir_init_args(rd);
+	rd->args.dp = sc->tempip;
+	error = xfs_dir2_sf_create(&rd->args, parent_ino);
+	if (error)
+		return error;
+
+	return xrep_tempfile_roll_trans(sc);
+}
+
+/*
+ * Prepare both inodes' directory forks for extent swapping.  Promote the
+ * tempfile from short format to leaf format, and if the file being repaired
+ * has a short format data fork, turn it into an empty extent list.
+ */
+STATIC int
+xrep_dir_swap_prep(
+	struct xfs_scrub	*sc,
+	bool			temp_local,
+	bool			ip_local)
+{
+	int			error;
+
+	/*
+	 * If the tempfile's directory is in shortform format, convert that
+	 * to a single leaf extent so that we can use the atomic extent swap.
+	 */
+	if (temp_local) {
+		struct xfs_da_args	args = {
+			.dp		= sc->tempip,
+			.geo		= sc->mp->m_dir_geo,
+			.whichfork	= XFS_DATA_FORK,
+			.trans		= sc->tp,
+			.total		= 1,
+			.owner		= sc->ip->i_ino,
+		};
+
+		error = xfs_dir2_sf_to_block(&args);
+		if (error)
+			return error;
+
+		/*
+		 * Roll the deferred log items to get us back to a clean
+		 * transaction.
+		 */
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
+/*
+ * Replace the inode number of a directory entry.
+ */
+static int
+xrep_dir_replace(
+	struct xrep_dir		*rd,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
+	xfs_ino_t		inum,
+	xfs_extlen_t		total)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	error = xfs_dir_ino_validate(sc->mp, inum);
+	if (error)
+		return error;
+
+	xrep_dir_init_args(rd);
+	rd->args.name = name->name;
+	rd->args.namelen = name->len;
+	rd->args.filetype = name->type;
+	rd->args.hashval = xfs_dir2_hashname(sc->mp, name);
+	rd->args.inumber = inum;
+	rd->args.dp = dp;
+	rd->args.total = total;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_replace(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_replace(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_replace(&rd->args);
+
+	return xfs_dir2_node_replace(&rd->args);
+}
+
+/* Swap the temporary directory's data fork with the one being repaired. */
+STATIC int
+xrep_dir_swap(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	bool			ip_local, temp_local;
+	int			error = 0;
+
+	/*
+	 * Take the IOLOCK on the temporary file so that we can run dir
+	 * operations with the same locks held as we would for a normal file.
+	 */
+	while (!xrep_tempfile_iolock_nowait(rd->sc)) {
+		if (xchk_should_terminate(rd->sc, &error))
+			return error;
+		delay(1);
+	}
+
+	error = xrep_tempswap_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+	if (error)
+		return error;
+
+	/*
+	 * Reset the temporary directory's '.' entry to point to the directory
+	 * we're repairing.  Note: shortform directories lack the dot entry.
+	 *
+	 * It's possible that this replacement could also expand a sf tempdir
+	 * into block format.
+	 */
+	if (0) { // sc->tempip->i_df.if_format != XFS_DINODE_FMT_LOCAL) {
+		error = xrep_dir_replace(rd, sc->tempip, &xfs_name_dot,
+				sc->ip->i_ino, rd->tx.req.resblks);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Reset the temporary directory's '..' entry to point to the parent
+	 * that we found.  The temporary directory was created with the root
+	 * directory as the parent, so we can skip this if repairing a
+	 * subdirectory of the root.
+	 *
+	 * It's also possible that this replacement could also expand a sf
+	 * tempdir into block format.
+	 */
+	if (rd->parent_ino != sc->mp->m_rootip->i_ino) {
+		error = xrep_dir_replace(rd, rd->sc->tempip, &xfs_name_dotdot,
+				rd->parent_ino, rd->tx.req.resblks);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Changing the dot and dotdot entries could have changed the shape of
+	 * the directory, so we recompute these.
+	 */
+	ip_local = sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+	temp_local = sc->tempip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+
+	/*
+	 * If the both files have a local format data fork and the rebuilt
+	 * directory data would fit in the repaired file's data fork, copy
+	 * the contents from the tempfile and declare ourselves done.
+	 */
+	if (ip_local && temp_local &&
+	    sc->tempip->i_disk_size <= xfs_inode_data_fork_size(sc->ip)) {
+		set_nlink(VFS_I(sc->ip), rd->new_nlink);
+		xrep_tempfile_copyout_local(sc, XFS_DATA_FORK);
+		return 0;
+	}
+
+	/* Clean the transaction before we start working on the extent swap. */
+	error = xrep_tempfile_roll_trans(rd->sc);
+	if (error)
+		return error;
+
+	/* Otherwise, make sure both data forks are in block-mapping mode. */
+	error = xrep_dir_swap_prep(sc, temp_local, ip_local);
+	if (error)
+		return error;
+
+	/*
+	 * Set nlink of the directory under repair to the number of
+	 * subdirectories that will be in the new directory data.  Do this in
+	 * the same transaction sequence that (atomically) commits the new
+	 * data.
+	 */
+	set_nlink(VFS_I(sc->ip), rd->new_nlink);
+
+	return xrep_tempswap_contents(sc, &rd->tx);
+}
+
+/*
+ * Swap the new directory contents (which we created in the tempfile) into the
+ * directory being repaired.
+ */
+STATIC int
+xrep_dir_rebuild_tree(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error;
+
+	trace_xrep_dir_rebuild_tree(sc->ip, rd->parent_ino);
+
+	/*
+	 * Commit the repair transaction so that we can use the atomic extent
+	 * swap helper functions to compute the correct block reservations and
+	 * re-lock the inodes.
+	 *
+	 * We still hold IOLOCK_EXCL (aka i_rwsem) which will prevent directory
+	 * modifications, but there's nothing to prevent userspace from reading
+	 * the directory until we're ready for the swap operation.  Reads will
+	 * return -EIO without shutting down the fs, so we're ok with that.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Swap the tempdir's data fork with the file being repaired.  This
+	 * recreates the transaction and re-takes the ILOCK in the scrub
+	 * context.
+	 */
+	error = xrep_dir_swap(rd);
+	if (error)
+		return error;
+
+	/*
+	 * Release the old directory blocks and reset the data fork of the temp
+	 * directory to an empty shortform directory because inactivation does
+	 * nothing for directories.
+	 */
+	return xrep_dir_reset_fork(rd, sc->mp->m_rootip->i_ino);
+}
+
+/*
+ * If we're the root of a directory tree, we are our own parent.  If we're an
+ * unlinked directory, the parent /won't/ have a link to us.  Set the parent
+ * directory to the root for both cases.  Returns NULLFSINO if we don't know
+ * what to do.
+ */
+static inline xfs_ino_t
+xrep_dir_self_parent(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
+		return sc->mp->m_sb.sb_rootino;
+
+	if (VFS_I(sc->ip)->i_nlink == 0)
+		return sc->mp->m_sb.sb_rootino;
+
+	return NULLFSINO;
+}
+
+/*
+ * Look up the dotdot entry.  Returns NULLFSINO if we don't know what to do.
+ * The next patch will check this more carefully.
+ */
+static inline xfs_ino_t
+xrep_dir_lookup_parent(
+	struct xrep_dir		*rd)
+{
+	return xrep_dotdot_lookup(rd->sc);
+}
+
+/*
+ * Try to find the parent of the directory being repaired.
+ *
+ * NOTE: This function will someday be augmented by the directory parent repair
+ * code, which will know how to check the parent and scan the filesystem if
+ * we cannot find anything.  Inode scans will have to be done before we start
+ * salvaging directory entries, so we do this now.
+ */
+STATIC int
+xrep_dir_find_parent(
+	struct xrep_dir		*rd)
+{
+	rd->parent_ino = xrep_dir_self_parent(rd);
+	if (rd->parent_ino != NULLFSINO)
+		return 0;
+
+	rd->parent_ino = xrep_dir_lookup_parent(rd);
+	if (rd->parent_ino != NULLFSINO)
+		return 0;
+
+	/* NOTE: A future patch will deal with moving orphans. */
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Repair the directory metadata.
+ *
+ * XXX: Directory entry buffers can be multiple fsblocks in size.  The buffer
+ * cache in XFS can't handle aliased multiblock buffers, so this might
+ * misbehave if the directory blocks are crosslinked with other filesystem
+ * metadata.
+ *
+ * XXX: Is it necessary to check the dcache for this directory to make sure
+ * that we always recreate every cached entry?
+ */
+int
+xrep_directory(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_dir		*rd = sc->buf;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	rd->sc = sc;
+	rd->parent_ino = NULLFSINO;
+	rd->new_nlink = 2;
+
+	/* Set up some staging memory for salvaging dirents. */
+	error = xfarray_create(sc->mp, "directory entries", 0,
+			sizeof(struct xrep_dirent), &rd->dir_entries);
+	if (error)
+		goto out_rd;
+
+	error = xfblob_create(sc->mp, "dirent names", &rd->dir_names);
+	if (error)
+		goto out_arr;
+
+	/*
+	 * Drop the ILOCK and MMAPLOCK on this directory; we don't need to
+	 * hold these to maintain control over the directory we're fixing.
+	 * This should leave us holding only IOLOCK_EXCL.  If we have to scan
+	 * the entire filesystem to find or confirm the parent of this
+	 * directory, we may have to cycle IOLOCK_EXCL.
+	 */
+	if (sc->ilock_flags & XFS_ILOCK_EXCL)
+		xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	xchk_iunlock(sc, XFS_MMAPLOCK_EXCL);
+
+	/* Figure out who is going to be the parent of this directory. */
+	error = xrep_dir_find_parent(rd);
+	if (error)
+		goto out_names;
+
+	/* Re-grab the ILOCK so that we can salvage directory entries. */
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Collect directory entries by parsing raw leaf blocks to salvage
+	 * whatever we can.  When we're done, free the staging memory before
+	 * swapping the directories to reduce memory usage.
+	 */
+	error = xrep_dir_find_entries(rd);
+	if (error)
+		goto out_names;
+
+	xfblob_destroy(rd->dir_names);
+	xfarray_destroy(rd->dir_entries);
+	rd->dir_names = NULL;
+	rd->dir_entries = NULL;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto out_rd;
+
+	/* Swap in the good contents. */
+	error = xrep_dir_rebuild_tree(rd);
+
+out_names:
+	if (rd->dir_names)
+		xfblob_destroy(rd->dir_names);
+out_arr:
+	if (rd->dir_entries)
+		xfarray_destroy(rd->dir_entries);
+out_rd:
+	return error;
+}
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index e29d7da2eb32..54aa3dc4dc89 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -27,6 +27,7 @@
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
 #include "scrub/readdir.h"
+#include "scrub/tempfile.h"
 
 /*
  * Live Inode Link Count Checking
@@ -147,6 +148,13 @@ xchk_nlinks_live_update(
 	if (action == XFS_BACKREF_NLINK_DELTA)
 		scan_dir = p->ip;
 
+	/*
+	 * Ignore temporary directories being used to stage dir repairs, since
+	 * we don't bump the link counts of the children.
+	 */
+	if (xrep_is_tempfile(scan_dir))
+		return NOTIFY_DONE;
+
 	/* Ignore the live update if the directory hasn't been scanned yet. */
 	if (!xchk_iscan_want_live_update(&xnc->collect_iscan, scan_dir->i_ino))
 		return NOTIFY_DONE;
@@ -316,6 +324,13 @@ xchk_nlinks_collect_dir(
 	unsigned int		lock_mode;
 	int			error = 0;
 
+	/*
+	 * Ignore temporary directories being used to stage dir repairs, since
+	 * we don't bump the link counts of the children.
+	 */
+	if (xrep_is_tempfile(dp))
+		return 0;
+
 	/* Prevent anyone from changing this directory while we walk it. */
 	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	lock_mode = xfs_ilock_data_map_shared(dp);
@@ -547,6 +562,14 @@ xchk_nlinks_compare_inode(
 	unsigned int		actual_nlink;
 	int			error;
 
+	/*
+	 * Ignore temporary files being used to stage repairs, since we assume
+	 * they're correct for non-directories, and the directory repair code
+	 * doesn't bump the link counts for the children.
+	 */
+	if (xrep_is_tempfile(ip))
+		return 0;
+
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	mutex_lock(&xnc->lock);
 
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 2f83abd6eec7..4723b015a1c1 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -25,6 +25,7 @@
 #include "scrub/iscan.h"
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
+#include "scrub/tempfile.h"
 
 /*
  * Live Inode Link Count Repair
@@ -52,6 +53,14 @@ xrep_nlinks_repair_inode(
 	unsigned int		actual_nlink;
 	int			error;
 
+	/*
+	 * Ignore temporary files being used to stage repairs, since we assume
+	 * they're correct for non-directories, and the directory repair code
+	 * doesn't bump the link counts for the children.
+	 */
+	if (xrep_is_tempfile(ip))
+		return 0;
+
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &sc->tp);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index e5e5dbdce7c4..b5c5ee7f512b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -34,6 +34,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
+#include "xfs_dir2.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1234,3 +1235,31 @@ xrep_buf_verify_struct(
 
 	return fa == NULL;
 }
+
+/*
+ * Look up the '..' entry for @sc->ip.  Returns NULLFSINO if sc->ip is not
+ * a directory, the directory is corrupt, or the inode number can't possibly
+ * be valid.
+ */
+xfs_ino_t
+xrep_dotdot_lookup(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_name		dotdot = xfs_name_dotdot;
+	xfs_ino_t		ino;
+	int			error;
+
+	/* sc->ip had better be a directory, so bail out if it isn't */
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		ASSERT(0);
+		return NULLFSINO;
+	}
+
+	error = xfs_dir_lookup(sc->tp, sc->ip, &dotdot, &ino, NULL);
+	if (error)
+		return NULLFSINO;
+	if (!xfs_verify_dir_ino(sc->mp, ino))
+		return NULLFSINO;
+
+	return ino;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 2a79d7a5ba7e..5fccc9c81d8f 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -83,6 +83,7 @@ int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
 int xrep_setup_rtsummary(struct xfs_scrub *sc, unsigned int *resblks,
 		size_t *bufsize);
 int xrep_setup_xattr(struct xfs_scrub *sc);
+int xrep_setup_directory(struct xfs_scrub *sc);
 
 int xrep_xattr_reset_fork(struct xfs_scrub *sc);
 
@@ -120,6 +121,7 @@ int xrep_bmap_cow(struct xfs_scrub *sc);
 int xrep_nlinks(struct xfs_scrub *sc);
 int xrep_fscounters(struct xfs_scrub *sc);
 int xrep_xattr(struct xfs_scrub *sc);
+int xrep_directory(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -145,6 +147,7 @@ int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
 void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
 
 bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
+xfs_ino_t xrep_dotdot_lookup(struct xfs_scrub *sc);
 
 #else
 
@@ -189,6 +192,7 @@ xrep_setup_nothing(
 #define xrep_setup_ag_rmapbt		xrep_setup_nothing
 #define xrep_setup_ag_refcountbt	xrep_setup_nothing
 #define xrep_setup_xattr		xrep_setup_nothing
+#define xrep_setup_directory		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -229,6 +233,7 @@ xrep_setup_rtsummary(
 #define xrep_fscounters			xrep_notsupported
 #define xrep_rtsummary			xrep_notsupported
 #define xrep_xattr			xrep_notsupported
+#define xrep_directory			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0ec23fc650be..1695e9d2f104 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -327,7 +327,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_directory,
 		.scrub	= xchk_directory,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_directory,
 	},
 	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index c9a089b169f2..b275c0b764f4 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -793,3 +793,16 @@ xrep_tempfile_copyout_local(
 	ilog_flags |= xfs_ilog_fdata(whichfork);
 	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
 }
+
+/* Decide if a given XFS inode is a temporary file for a repair. */
+bool
+xrep_is_tempfile(
+	const struct xfs_inode	*ip)
+{
+	const struct inode	*inode = &ip->i_vnode;
+
+	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
+		return true;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index 402957f7f2b3..4ca35f5d49a5 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -33,11 +33,13 @@ int xrep_tempfile_set_isize(struct xfs_scrub *sc, unsigned long long isize);
 
 int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
 void xrep_tempfile_copyout_local(struct xfs_scrub *sc, int whichfork);
+bool xrep_is_tempfile(const struct xfs_inode *ip);
 #else
 static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 {
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 }
+# define xrep_is_tempfile(ip)		(false)
 # define xrep_tempfile_rele(sc)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index fa67a9451820..b35b7d5a3767 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2399,6 +2399,141 @@ DEFINE_EVENT(xrep_xattr_class, name, \
 DEFINE_XREP_XATTR_CLASS(xrep_xattr_rebuild_tree);
 DEFINE_XREP_XATTR_CLASS(xrep_xattr_reset_fork);
 
+TRACE_EVENT(xrep_dir_recover_dirblock,
+	TP_PROTO(struct xfs_inode *dp, xfs_dablk_t dabno, uint32_t magic,
+		 uint32_t magic_guess),
+	TP_ARGS(dp, dabno, magic, magic_guess),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_dablk_t, dabno)
+		__field(uint32_t, magic)
+		__field(uint32_t, magic_guess)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->dabno = dabno;
+		__entry->magic = magic;
+		__entry->magic_guess = magic_guess;
+	),
+	TP_printk("dev %d:%d dir 0x%llx dablk 0x%x magic 0x%x magic_guess 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->dabno,
+		  __entry->magic,
+		  __entry->magic_guess)
+);
+
+TRACE_EVENT(xrep_dir_salvage_entry,
+	TP_PROTO(struct xfs_inode *dp, char *name, unsigned int namelen,
+		 xfs_ino_t ino),
+	TP_ARGS(dp, name, namelen, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen + 1)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+		__get_str(name)[namelen] = 0;
+		__entry->ino = ino;
+	),
+	TP_printk("dev %d:%d dir 0x%llx name '%.*s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->ino)
+);
+
+DECLARE_EVENT_CLASS(xrep_dir_class,
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino),
+	TP_ARGS(dp, parent_ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_ino_t, parent_ino)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->parent_ino = parent_ino;
+	),
+	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->parent_ino)
+)
+#define DEFINE_XREP_DIR_CLASS(name) \
+DEFINE_EVENT(xrep_dir_class, name, \
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino), \
+	TP_ARGS(dp, parent_ino))
+DEFINE_XREP_DIR_CLASS(xrep_dir_rebuild_tree);
+DEFINE_XREP_DIR_CLASS(xrep_dir_reset_fork);
+
+DECLARE_EVENT_CLASS(xrep_dirent_class,
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name, xfs_ino_t ino),
+	TP_ARGS(dp, name, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+		__field(xfs_ino_t, ino)
+		__field(uint8_t, ftype)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+		__entry->ino = ino;
+		__entry->ftype = name->type;
+	),
+	TP_printk("dev %d:%d dir 0x%llx ftype %s name '%.*s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR),
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->ino)
+)
+#define DEFINE_XREP_DIRENT_CLASS(name) \
+DEFINE_EVENT(xrep_dirent_class, name, \
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name, xfs_ino_t ino), \
+	TP_ARGS(dp, name, ino))
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_insert_rec);
+
+DECLARE_EVENT_CLASS(xrep_parent_salvage_class,
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino),
+	TP_ARGS(dp, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->ino = ino;
+	),
+	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->ino)
+)
+#define DEFINE_XREP_PARENT_SALVAGE_CLASS(name) \
+DEFINE_EVENT(xrep_parent_salvage_class, name, \
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino), \
+	TP_ARGS(dp, ino))
+DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_dir_salvaged_parent);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d81c864207bb..ce55dde40d9d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_attr.h"
+#include "xfs_bit.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
@@ -1592,6 +1593,51 @@ xfs_release(
 	return error;
 }
 
+/*
+ * Mark all the buffers attached to this directory stale.  In theory we should
+ * never be freeing a directory with any blocks at all, but this covers the
+ * case where we've recovered a directory swap with a "temporary" directory
+ * created by online repair and now need to dump it.
+ */
+STATIC void
+xfs_inactive_dir(
+	struct xfs_inode	*dp)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(dp, XFS_DATA_FORK);
+	xfs_fileoff_t		off;
+
+	/*
+	 * Invalidate each directory block.  All directory blocks are of
+	 * fsbcount length and alignment, so we only need to walk those same
+	 * offsets.  We hold the only reference to this inode, so we must wait
+	 * for the buffer locks.
+	 */
+	for_each_xfs_iext(ifp, &icur, &got) {
+		for (off = round_up(got.br_startoff, geo->fsbcount);
+		     off < got.br_startoff + got.br_blockcount;
+		     off += geo->fsbcount) {
+			struct xfs_buf	*bp = NULL;
+			xfs_fsblock_t	fsbno;
+			int		error;
+
+			fsbno = (off - got.br_startoff) + got.br_startblock;
+			error = xfs_buf_incore(mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(mp, fsbno),
+					XFS_FSB_TO_BB(mp, geo->fsbcount),
+					XBF_BCACHE_SCAN, &bp);
+			if (error)
+				continue;
+
+			xfs_buf_stale(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+}
+
 /*
  * xfs_inactive_truncate
  *
@@ -1887,6 +1933,11 @@ xfs_inactive(
 	if (error)
 		goto out;
 
+	if (S_ISDIR(VFS_I(ip)->i_mode) && ip->i_df.if_nextents > 0) {
+		xfs_inactive_dir(ip);
+		truncate = 1;
+	}
+
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)

