Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD4C128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423548; cv=none; b=Z9wQ+qDjta+JpkvM5DJo9XWtNRclxcRdgKI5E/kls1S9uEr5nyqlWer/MYxFlirDI2ZfPuWysjdePVHLglwrkp2hrOChfaaSjmEqbZSiO4BtBDzEXASQPZINpiEiBCXty6Ni4h/8fUQiAvdaPciup/YyijrMzEyFewIoKnohtCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423548; c=relaxed/simple;
	bh=96jg6SaE1Ww8PIuFTohArNWan5Ah6zEn7Vv7SFJf+u8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ASH2oll9mQQ0T9u4MGbHre14yeuoMaA+Pr0BAwcjI8tL2f8eqvSzR10CCoRckK3Ekg3MyLm0JW1icHbZ6U49PoltMSm+pxDh813eZhNPhYLtD+Fk26ajCYtk/gZeffT4QOfJrMo/kAW6sqQjtdnLFUCoQR+PwzAEiOsxKn5uBOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqI8w26K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqI8w26K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770BEC433F1;
	Tue, 26 Mar 2024 03:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423548;
	bh=96jg6SaE1Ww8PIuFTohArNWan5Ah6zEn7Vv7SFJf+u8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aqI8w26KNdbrJ5nT++ArQOGhWIR1E7bR/MaXx+t9thwnPzOwDruLDRvxy4GGQkTe8
	 c5JasUDMLI+BWXVFHoZYdg4PSu47/7tGFVm9MOzCM/rDOPWn2lOBOO1/5H98TyUCm/
	 WhEy5gZg1DECd4vCREmc5mFO5Vfv93G9g0FSD1/eBeLtgPZXkoRMATuDkH6tBfoRKe
	 QbKWY5eOCTd87omEo3/PXdwiVbg3s0Mq/fJlTG3v8D0AH7cFG/kcSvj12XPEViWa/k
	 4fG6HzXRPrHU6lysQxZyW0wmMyph5b3LWpV0YIuiF8Oku0e2gLXmu64bpM+Igv6yYa
	 y/qPAtP8pJvLw==
Date: Mon, 25 Mar 2024 20:25:48 -0700
Subject: [PATCH 1/8] xfs_db: add a bmbt inflation command
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130370.2214793.8694135788913305667.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
References: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
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

Add a command to xfs_db to clone a data fork mapping over and over
again.  This will make it easier to exercise really high sharing counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/Makefile       |   65 +++++-
 db/bmap_inflate.c |  551 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c      |    1 
 db/command.h      |    1 
 man/man8/xfs_db.8 |   23 ++
 5 files changed, 633 insertions(+), 8 deletions(-)
 create mode 100644 db/bmap_inflate.c


diff --git a/db/Makefile b/db/Makefile
index d00801ab4739..83389376c36c 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -7,14 +7,63 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_db
 
-HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h crc.h debug.h \
-	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
-	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
-	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
-	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
-	fuzz.h obfuscate.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c iunlink.c namei.c \
+HFILES = \
+	addr.h \
+	agf.h \
+	agfl.h \
+	agi.h \
+	attr.h \
+	attrset.h \
+	attrshort.h \
+	bit.h \
+	block.h \
+	bmap.h \
+	bmroot.h \
+	btblock.h \
+	check.h \
+	command.h \
+	crc.h \
+	debug.h \
+	dir2.h \
+	dir2sf.h \
+	dquot.h \
+	echo.h \
+	faddr.h \
+	field.h \
+	flist.h \
+	fprint.h \
+	frag.h \
+	freesp.h \
+	fsmap.h \
+	fuzz.h \
+	hash.h \
+	help.h \
+	init.h \
+	inode.h \
+	input.h \
+	io.h \
+	logformat.h \
+	malloc.h \
+	metadump.h \
+	obfuscate.h \
+	output.h \
+	print.h \
+	quit.h \
+	sb.h \
+	sig.h \
+	strvec.h \
+	symlink.h \
+	text.h \
+	type.h \
+	write.h
+CFILES = $(HFILES:.h=.c) \
+	bmap_inflate.c \
+	btdump.c \
+	btheight.c \
+	convert.c \
+	info.c \
+	iunlink.c \
+	namei.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
new file mode 100644
index 000000000000..33b0c954d8f8
--- /dev/null
+++ b/db/bmap_inflate.c
@@ -0,0 +1,551 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "command.h"
+#include "init.h"
+#include "output.h"
+#include "io.h"
+#include "libfrog/convert.h"
+
+static void
+bmapinflate_help(void)
+{
+	dbprintf(_(
+"\n"
+" Make the bmbt really big by cloning the first data fork mapping over and over.\n"
+" -d     Constrain dirty buffers to this many bytes.\n"
+" -e     Print the size and height of the btree and exit.\n"
+" -n nr  Create this many copies of the mapping.\n"
+"\n"
+));
+
+}
+
+static int
+find_mapping(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*irec)
+{
+	struct xfs_iext_cursor	icur;
+	int			error;
+
+	if (!xfs_has_reflink(ip->i_mount)) {
+		dbprintf(_("filesystem does not support reflink\n"));
+		return 1;
+	}
+
+	if (ip->i_df.if_nextents != 1) {
+		dbprintf(_("inode must have only one data fork mapping\n"));
+		return 1;
+	}
+
+	error = -libxfs_iread_extents(tp, ip, XFS_DATA_FORK);
+	if (error) {
+		dbprintf(_("could not read data fork, err %d\n"), error);
+		return 1;
+	}
+
+	libxfs_iext_first(&ip->i_df, &icur);
+	if (!xfs_iext_get_extent(&ip->i_df, &icur, irec)) {
+		dbprintf(_("could not read data fork mapping\n"));
+		return 1;
+	}
+
+	if (irec->br_state != XFS_EXT_NORM) {
+		dbprintf(_("cannot duplicate unwritten extent\n"));
+		return 1;
+	}
+
+	return 0;
+}
+
+static int
+set_nrext64(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_extnum_t		nextents)
+{
+	xfs_extnum_t		max_extents;
+	bool			large_extcount;
+
+	large_extcount = xfs_inode_has_large_extent_counts(ip);
+	max_extents = xfs_iext_max_nextents(large_extcount, XFS_DATA_FORK);
+	if (nextents <= max_extents)
+		return 0;
+	if (large_extcount)
+		return EFSCORRUPTED;
+	if (!xfs_has_large_extent_counts(ip->i_mount))
+		return EFSCORRUPTED;
+
+	max_extents = xfs_iext_max_nextents(true, XFS_DATA_FORK);
+	if (nextents > max_extents)
+		return EFSCORRUPTED;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
+
+static int
+populate_extents(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	struct xbtree_ifakeroot		*ifake,
+	const struct xfs_bmbt_irec	*template,
+	xfs_extnum_t			nextents)
+{
+	struct xfs_bmbt_irec		irec = {
+		.br_startoff		= 0,
+		.br_startblock		= template->br_startblock,
+		.br_blockcount		= template->br_blockcount,
+		.br_state		= XFS_EXT_NORM,
+	};
+	struct xfs_iext_cursor		icur;
+	struct xfs_ifork		*ifp = ifake->if_fork;
+	unsigned long long		i;
+
+	/* Add all the mappings to the incore extent tree. */
+	libxfs_iext_first(ifp, &icur);
+	for (i = 0; i < nextents; i++) {
+		libxfs_iext_insert_raw(ifp, &icur, &irec);
+		ifp->if_nextents++;
+		libxfs_iext_next(ifp, &icur);
+
+		irec.br_startoff += irec.br_blockcount;
+	}
+
+	ip->i_nblocks = template->br_blockcount * nextents;
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	return 0;
+}
+
+struct bmbt_resv {
+	struct list_head	list;
+	xfs_fsblock_t		fsbno;
+	xfs_extlen_t		len;
+	xfs_extlen_t		used;
+};
+
+struct bmbt_data {
+	struct xfs_bmbt_irec	irec;
+	struct list_head	resv_list;
+	unsigned long long	iblocks;
+	unsigned long long	nr;
+};
+
+static int
+alloc_bmbt_blocks(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	struct bmbt_data	*bd,
+	uint64_t		nr_blocks)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct list_head	*resv_list = &bd->resv_list;
+	int			error = 0;
+
+	while (nr_blocks > 0) {
+		struct xfs_alloc_arg	args = {
+			.tp		= *tpp,
+			.mp		= mp,
+			.minlen		= 1,
+			.maxlen		= nr_blocks,
+			.prod		= 1,
+			.resv		= XFS_AG_RESV_NONE,
+		};
+		struct bmbt_resv	*resv;
+		xfs_fsblock_t		target = 0;
+
+		if (xfs_has_rmapbt(mp)) {
+			xfs_agnumber_t		tgt_agno;
+
+			/*
+			 * Try to allocate bmbt blocks in a different AG so
+			 * that we don't blow up the rmapbt with the bmbt
+			 * records.
+			 */
+			tgt_agno = 1 + XFS_FSB_TO_AGNO(mp,
+							bd->irec.br_startblock);
+			if (tgt_agno >= mp->m_sb.sb_agcount)
+				tgt_agno = 0;
+			target = XFS_AGB_TO_FSB(mp, tgt_agno, 0);
+		}
+
+		libxfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino,
+				XFS_DATA_FORK);
+
+		error = -libxfs_alloc_vextent_start_ag(&args, target);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK)
+			return ENOSPC;
+
+		resv = kmalloc(sizeof(struct bmbt_resv), 0);
+		if (!resv)
+			return ENOMEM;
+
+		INIT_LIST_HEAD(&resv->list);
+		resv->fsbno = args.fsbno;
+		resv->len = args.len;
+		resv->used = 0;
+		list_add_tail(&resv->list, resv_list);
+
+		nr_blocks -= args.len;
+
+		error = -libxfs_trans_roll_inode(tpp, ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+static int
+get_bmbt_records(
+	struct xfs_btree_cur	*cur,
+	unsigned int		idx,
+	struct xfs_btree_block	*block,
+	unsigned int		nr_wanted,
+	void			*priv)
+{
+	struct xfs_bmbt_irec	*irec = &cur->bc_rec.b;
+	struct bmbt_data	*bd = priv;
+	union xfs_btree_rec	*block_rec;
+	struct xfs_ifork	*ifp = cur->bc_ino.ifake->if_fork;
+	unsigned int		loaded;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		memcpy(irec, &bd->irec, sizeof(struct xfs_bmbt_irec));
+
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+		ifp->if_nextents++;
+
+		bd->irec.br_startoff += bd->irec.br_blockcount;
+	}
+
+	return loaded;
+}
+
+static int
+claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct bmbt_data	*bd = priv;
+	struct bmbt_resv	*resv;
+	xfs_fsblock_t		fsb;
+
+	/*
+	 * The first item in the list should always have a free block unless
+	 * we're completely out.
+	 */
+	resv = list_first_entry(&bd->resv_list, struct bmbt_resv, list);
+	if (resv->used == resv->len)
+		return ENOSPC;
+
+	fsb = resv->fsbno + resv->used;
+	resv->used++;
+
+	/* If we used all the blocks in this reservation, move it to the end. */
+	if (resv->used == resv->len)
+		list_move_tail(&resv->list, &bd->resv_list);
+
+	ptr->l = cpu_to_be64(fsb);
+	bd->iblocks++;
+	return 0;
+}
+
+static size_t
+iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
+}
+
+static int
+populate_btree(
+	struct xfs_trans		**tpp,
+	struct xfs_inode		*ip,
+	uint16_t			dirty_blocks,
+	struct xbtree_ifakeroot		*ifake,
+	struct xfs_btree_cur		*bmap_cur,
+	const struct xfs_bmbt_irec	*template,
+	xfs_extnum_t			nextents)
+{
+	struct xfs_btree_bload		bmap_bload = {
+		.get_records		= get_bmbt_records,
+		.claim_block		= claim_block,
+		.iroot_size		= iroot_size,
+		.max_dirty		= dirty_blocks,
+		.leaf_slack		= 1,
+		.node_slack		= 1,
+	};
+	struct bmbt_data		bd = {
+		.irec			= {
+			.br_startoff	= 0,
+			.br_startblock	= template->br_startblock,
+			.br_blockcount	= template->br_blockcount,
+			.br_state	= XFS_EXT_NORM,
+		},
+		.iblocks		= 0,
+	};
+	struct bmbt_resv		*resv, *n;
+	int				error;
+
+	error = -libxfs_btree_bload_compute_geometry(bmap_cur, &bmap_bload,
+			nextents);
+	if (error)
+		return error;
+
+	error = -libxfs_trans_reserve_more(*tpp, bmap_bload.nr_blocks, 0);
+	if (error)
+		return error;
+
+	INIT_LIST_HEAD(&bd.resv_list);
+	error = alloc_bmbt_blocks(tpp, ip, &bd, bmap_bload.nr_blocks);
+	if (error)
+		return error;
+
+	error = -libxfs_btree_bload(bmap_cur, &bmap_bload, &bd);
+	if (error)
+	       goto out_resv_list;
+
+	ip->i_nblocks = bd.iblocks + (template->br_blockcount * nextents);
+	libxfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+
+out_resv_list:
+	/* Leak any unused blocks */
+	list_for_each_entry_safe(resv, n, &bd.resv_list, list) {
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+	return error;
+}
+
+static int
+build_new_datafork(
+	struct xfs_trans		**tpp,
+	struct xfs_inode		*ip,
+	uint16_t			dirty_blocks,
+	const struct xfs_bmbt_irec	*irec,
+	xfs_extnum_t			nextents)
+{
+	struct xbtree_ifakeroot		ifake;
+	struct xfs_btree_cur		*bmap_cur;
+	int				error;
+
+	error = set_nrext64(*tpp, ip, nextents);
+	if (error)
+		return error;
+
+	/* Set up staging for the new bmbt */
+	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
+	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
+
+	/*
+	 * Figure out the size and format of the new fork, then fill it with
+	 * the bmap record we want.
+	 */
+	if (nextents <= XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK)) {
+		ifake.if_fork->if_format = XFS_DINODE_FMT_EXTENTS;
+		error = populate_extents(*tpp, ip, &ifake, irec, nextents);
+	} else {
+		ifake.if_fork->if_format = XFS_DINODE_FMT_BTREE;
+		error = populate_btree(tpp, ip, dirty_blocks, &ifake, bmap_cur,
+				irec, nextents);
+	}
+	if (error) {
+		libxfs_btree_del_cursor(bmap_cur, 0);
+		goto err_ifork;
+	}
+
+	/* Install the new fork in the inode. */
+	libxfs_bmbt_commit_staged_btree(bmap_cur, *tpp, XFS_DATA_FORK);
+	libxfs_btree_del_cursor(bmap_cur, 0);
+
+	/* Mark filesystem as needsrepair */
+	dbprintf(_("filesystem is now inconsistent, xfs_repair required!\n"));
+	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	libxfs_log_sb(*tpp);
+
+err_ifork:
+	kmem_cache_free(xfs_ifork_cache, ifake.if_fork);
+	return error;
+}
+
+static int
+estimate_size(
+	struct xfs_inode		*ip,
+	unsigned long long		dirty_blocks,
+	xfs_extnum_t			nextents)
+{
+	struct xfs_btree_bload		bmap_bload = {
+		.leaf_slack		= 1,
+		.node_slack		= 1,
+	};
+	struct xbtree_ifakeroot		ifake;
+	struct xfs_btree_cur		*bmap_cur;
+	int				error;
+
+	/* FMT_EXTENTS means we report zero btblocks and zero height */
+	if (nextents <= XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
+		goto report;
+
+	ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
+	ifake.if_fork_size = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+
+	bmap_cur = libxfs_bmbt_stage_cursor(ip->i_mount, ip, &ifake);
+	error = -libxfs_btree_bload_compute_geometry(bmap_cur, &bmap_bload,
+			nextents);
+	libxfs_btree_del_cursor(bmap_cur, error);
+
+	kmem_cache_free(xfs_ifork_cache, ifake.if_fork);
+
+	if (error)
+		return error;
+
+report:
+	dbprintf(_("ino 0x%llx nextents %llu btblocks %llu btheight %u dirty %u\n"),
+			ip->i_ino, nextents, bmap_bload.nr_blocks,
+			bmap_bload.btree_height, dirty_blocks);
+
+	return 0;
+}
+
+static int
+bmapinflate_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	char			*p;
+	unsigned long long	nextents = 0;
+	unsigned long long	dirty_bytes = 60U << 20; /* 60MiB */
+	unsigned long long	dirty_blocks;
+	unsigned int		resblks;
+	bool			estimate = false;
+	int			c, error;
+
+	if (iocur_top->ino == NULLFSINO) {
+		dbprintf(_("no current inode\n"));
+		return 0;
+	}
+
+	optind = 0;
+	while ((c = getopt(argc, argv, "d:en:")) != EOF) {
+		switch (c) {
+		case 'e':
+			estimate = true;
+			break;
+		case 'n':
+			errno = 0;
+			nextents = strtoull(optarg, &p, 0);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'd':
+			errno = 0;
+			dirty_bytes = cvtnum(mp->m_sb.sb_blocksize,
+					     mp->m_sb.sb_sectsize, optarg);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		default:
+			dbprintf(_("bad option for bmap command\n"));
+			return 0;
+		}
+	}
+
+	dirty_blocks = XFS_B_TO_FSBT(mp, dirty_bytes);
+	if (dirty_blocks >= UINT16_MAX)
+		dirty_blocks = UINT16_MAX - 1;
+
+	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip);
+	if (error) {
+		dbprintf(_("could not grab inode 0x%llx, err %d\n"),
+				iocur_top->ino, error);
+		return 1;
+	}
+
+	error = estimate_size(ip, dirty_blocks, nextents);
+	if (error)
+		goto out_irele;
+	if (estimate)
+		goto done;
+
+	resblks = libxfs_bmbt_calc_size(mp, nextents);
+	error = -libxfs_trans_alloc_inode(ip, &M_RES(mp)->tr_itruncate,
+			resblks, 0, false, &tp);
+	if (error) {
+		dbprintf(_("could not allocate transaction, err %d\n"),
+				error);
+		return 1;
+	}
+
+	error = find_mapping(tp, ip, &irec);
+	if (error)
+		goto out_cancel;
+
+	error = build_new_datafork(&tp, ip, dirty_blocks, &irec, nextents);
+	if (error) {
+		dbprintf(_("could not build new data fork, err %d\n"),
+				error);
+		exitcode = 1;
+		goto out_cancel;
+	}
+
+	error = -libxfs_trans_commit(tp);
+	if (error) {
+		dbprintf(_("could not commit transaction, err %d\n"),
+				error);
+		exitcode = 1;
+		return 1;
+	}
+
+done:
+	libxfs_irele(ip);
+	return 0;
+
+out_cancel:
+	libxfs_trans_cancel(tp);
+out_irele:
+	libxfs_irele(ip);
+	return 1;
+}
+
+static const struct cmdinfo bmapinflate_cmd = {
+	.name		= "bmapinflate",
+	.cfunc		= bmapinflate_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= N_("[-n copies] [-e] [-d maxdirty]"),
+	.oneline	= N_("inflate bmbt by copying mappings"),
+	.help		= bmapinflate_help,
+};
+
+void
+bmapinflate_init(void)
+{
+	if (!expert_mode)
+		return;
+
+	add_command(&bmapinflate_cmd);
+}
diff --git a/db/command.c b/db/command.c
index 2bbd7b0b24f9..6cda03e9856d 100644
--- a/db/command.c
+++ b/db/command.c
@@ -142,4 +142,5 @@ init_commands(void)
 	fuzz_init();
 	timelimit_init();
 	iunlink_init();
+	bmapinflate_init();
 }
diff --git a/db/command.h b/db/command.h
index a89e71504f9c..2c2926afd7b5 100644
--- a/db/command.h
+++ b/db/command.h
@@ -35,3 +35,4 @@ extern void		btheight_init(void);
 extern void		timelimit_init(void);
 extern void		namei_init(void);
 extern void		iunlink_init(void);
+extern void		bmapinflate_init(void);
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index f53ddd67d87c..a7f6d55ed8be 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -388,6 +388,29 @@ and
 options are used to select the attribute or data
 area of the inode, if neither option is given then both areas are shown.
 .TP
+.BI "bmapinflate [\-d " dirty_bytes "] [-e] [\-n " nr "]
+Duplicates the first data fork mapping this many times, as if the mapping had
+been repeatedly reflinked.
+This is an expert-mode command for exercising high-refcount filesystems only.
+Existing data fork mappings will be forgotten and the refcount btree will not
+be updated.
+This command leaves at least the refcount btree and the inode inconsistent;
+.B xfs_repair
+must be run afterwards.
+.RS 1.0i
+.TP 0.4i
+.B \-d
+Constrain the memory consumption of new dirty btree blocks to this quantity.
+Defaults to 60MiB.
+.TP 0.4i
+.B \-e
+Estimate the number of blocks and height of the new data fork mapping
+structure and exit without changing anything.
+.TP 0.4i
+.B \-n
+Create this many copies of the first mapping.
+.RE
+.TP
 .B btdump [-a] [-i]
 If the cursor points to a btree node, dump the btree from that block downward.
 If instead the cursor points to an inode, dump the data fork block mapping btree if there is one.

