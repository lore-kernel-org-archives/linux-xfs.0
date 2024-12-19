Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954FA18FDDE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636704; cv=none; b=PXTn6lD29BIDgumzCqP44kbcDexEQyttuuGHF7k8nCVW9jmWwd5bGO30U6XbPJu+6BkZphLqtADIVIRLhZL1MATaMVes38PQ3dnX3Kc9b5ptUdxwAQiW1axIuXoFQ9rcm+BAD/d0P9Q4gpcmxhs3XceZbrNtNDcxkTSSQvhVb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636704; c=relaxed/simple;
	bh=wL7t3zV5ZDO6UKZLeMHmGNu1Y7D+P1nQAv5kUnuDuDM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cN9Jezot9v8OgLmN2EhmYPv7WG8NE/VRsssSRF4k7j9KsYWci1P+MPXI/S+4G24hX4g6fvIWHTNx4helPgu0XVf4mxCLKPGcLFZKInqEa8LonEvtd8vx+UC10wIEWcylCAKgDVmqtVZcPK7vf+SqnmPxGMyVF4qhROhrkiv5rtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3uKiK1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3uKiK1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644AFC4CED4;
	Thu, 19 Dec 2024 19:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636704;
	bh=wL7t3zV5ZDO6UKZLeMHmGNu1Y7D+P1nQAv5kUnuDuDM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C3uKiK1w1Ph5iGqFJAe4sIp52S8ZTWcg8EW3PBCKzXY6kygPai83qLbSMp+GMavJp
	 4vRoS8wxr1r/UrwD1vSsTzNrHa7x+Xv5RKGc/APrzNzLWjtSxy3gYCjoG7ApPiCJ+k
	 WDj5+NUC5twIKe+GNZc91tODSodkq0FXvUG4nMeBZgx0jDys8fNbF35Zpg9O/f/WbD
	 o6XsPXhmHuWk+fn43C9E4wBvG87QB6rIPJ/06iVKlsgi0NVK4TcH8/TaDA/wUJ90Mo
	 HIgn6a1rkc0P2ynZlBz6rnkMjxZoE+D4o0TnnZusmOluot/6F7InFuIEC67gX1+993
	 Nl5LntoLcTbqg==
Date: Thu, 19 Dec 2024 11:31:43 -0800
Subject: [PATCH 32/37] xfs: online repair of the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580306.1571512.3126512103638820643.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Repair the realtime rmap btree while mounted.  Similar to the regular
rmap btree repair code, we walk the data fork mappings of every realtime
file in the filesystem to collect reverse-mapping records in an xfarray.
Then we sort the xfarray, and use the btree bulk loader to create a new
rtrmap btree ondisk.  Finally, we swap the btree roots, and reap the old
blocks in the usual way.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/Makefile                   |    1 
 fs/xfs/libxfs/xfs_btree_staging.c |    1 
 fs/xfs/libxfs/xfs_rtrmap_btree.c  |    2 
 fs/xfs/libxfs/xfs_rtrmap_btree.h  |    3 
 fs/xfs/scrub/common.c             |    4 
 fs/xfs/scrub/common.h             |    2 
 fs/xfs/scrub/repair.c             |  144 +++++++
 fs/xfs/scrub/repair.h             |   14 +
 fs/xfs/scrub/rtrmap.c             |    7 
 fs/xfs/scrub/rtrmap_repair.c      |  733 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c              |    2 
 fs/xfs/scrub/trace.h              |   57 +++
 12 files changed, 966 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 136a465e00d2b1..338e10f81b7b71 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -234,6 +234,7 @@ xfs-y				+= $(addprefix scrub/, \
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rtbitmap_repair.o \
+				   rtrmap_repair.o \
 				   rtsummary_repair.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 58c146b5c9d479..5ed84f9cc877ef 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -134,6 +134,7 @@ xfs_btree_stage_ifakeroot(
 	cur->bc_ino.ifake = ifake;
 	cur->bc_nlevels = ifake->if_levels;
 	cur->bc_ino.forksize = ifake->if_fork_size;
+	cur->bc_ino.whichfork = XFS_STAGING_FORK;
 	cur->bc_flags |= XFS_BTREE_STAGING;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 0a78dee01b1b2e..571a9e1b956099 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -660,7 +660,7 @@ xfs_rtrmapbt_compute_maxlevels(
 }
 
 /* Calculate the rtrmap btree size for some records. */
-static unsigned long long
+unsigned long long
 xfs_rtrmapbt_calc_size(
 	struct xfs_mount	*mp,
 	unsigned long long	len)
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index bf73460be274d1..ad76ac7938b602 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -198,4 +198,7 @@ int xfs_rtrmapbt_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
 int xfs_rtrmapbt_init_rtsb(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
 		struct xfs_trans *tp);
 
+unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index ca43dd4f52b2d6..06cb61e6349827 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -819,7 +819,7 @@ xchk_rtgroup_btcur_free(
  * Unlock the realtime group.  This must be done /after/ committing (or
  * cancelling) the scrub transaction.
  */
-static void
+void
 xchk_rtgroup_unlock(
 	struct xchk_rt		*sr)
 {
@@ -904,7 +904,7 @@ int
 xchk_setup_rt(
 	struct xfs_scrub	*sc)
 {
-	return xchk_trans_alloc(sc, 0);
+	return xchk_trans_alloc(sc, xrep_calc_rtgroup_resblks(sc));
 }
 
 /* Set us up with AG headers and btree cursors. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e5891609af2740..50ac6cca18fe45 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -147,12 +147,14 @@ xchk_rtgroup_init_existing(
 
 int xchk_rtgroup_lock(struct xfs_scrub *sc, struct xchk_rt *sr,
 		unsigned int rtglock_flags);
+void xchk_rtgroup_unlock(struct xchk_rt *sr);
 void xchk_rtgroup_btcur_free(struct xchk_rt *sr);
 void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
 #else
 # define xchk_rtgroup_init(sc, rgno, sr)		(-EFSCORRUPTED)
 # define xchk_rtgroup_init_existing(sc, rgno, sr)	(-EFSCORRUPTED)
 # define xchk_rtgroup_lock(sc, sr, lockflags)		(-EFSCORRUPTED)
+# define xchk_rtgroup_unlock(sr)			do { } while (0)
 # define xchk_rtgroup_btcur_free(sr)			do { } while (0)
 # define xchk_rtgroup_free(sc, sr)			do { } while (0)
 #endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 82fe01d78cb08d..61e414c81253af 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -40,6 +40,8 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
+#include "xfs_metafile.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -382,6 +384,41 @@ xrep_calc_ag_resblks(
 	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * Figure out how many blocks to reserve for a rtgroup repair.  We calculate
+ * the worst case estimate for the number of blocks we'd need to rebuild one of
+ * any type of per-rtgroup btree.
+ */
+xfs_extlen_t
+xrep_calc_rtgroup_resblks(
+	struct xfs_scrub		*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_metadata	*sm = sc->sm;
+	uint64_t			usedlen;
+	xfs_extlen_t			rmapbt_sz = 0;
+
+	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
+		return 0;
+	if (!xfs_has_rtgroups(mp)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	usedlen = xfs_rtbxlen_to_blen(mp, xfs_rtgroup_extents(mp, sm->sm_agno));
+	ASSERT(usedlen <= XFS_MAX_RGBLOCKS);
+
+	if (xfs_has_rmapbt(mp))
+		rmapbt_sz = xfs_rtrmapbt_calc_size(mp, usedlen);
+
+	trace_xrep_calc_rtgroup_resblks_btsize(mp, sm->sm_agno, usedlen,
+			rmapbt_sz);
+
+	return rmapbt_sz;
+}
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Reconstructing per-AG Btrees
  *
@@ -1284,3 +1321,110 @@ xrep_buf_verify_struct(
 
 	return fa == NULL;
 }
+
+/* Check the sanity of a rmap record for a metadata btree inode. */
+int
+xrep_check_ino_btree_mapping(
+	struct xfs_scrub		*sc,
+	const struct xfs_rmap_irec	*rec)
+{
+	enum xbtree_recpacking		outcome;
+	int				error;
+
+	/*
+	 * Metadata btree inodes never have extended attributes, and all blocks
+	 * should have the bmbt block flag set.
+	 */
+	if ((rec->rm_flags & XFS_RMAP_ATTR_FORK) ||
+	    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+		return -EFSCORRUPTED;
+
+	/* Make sure the block is within the AG. */
+	if (!xfs_verify_agbext(sc->sa.pag, rec->rm_startblock,
+				rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	error = xfs_alloc_has_records(sc->sa.bno_cur, rec->rm_startblock,
+			rec->rm_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/*
+ * Reset the block count of the inode being repaired, and adjust the dquot
+ * block usage to match.  The inode must not have an xattr fork.
+ */
+void
+xrep_inode_set_nblocks(
+	struct xfs_scrub	*sc,
+	int64_t			new_blocks)
+{
+	int64_t			delta =
+		new_blocks - sc->ip->i_nblocks;
+
+	sc->ip->i_nblocks = new_blocks;
+
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	if (delta != 0)
+		xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT,
+				delta);
+}
+
+/* Reset the block reservation for a metadata inode. */
+int
+xrep_reset_metafile_resv(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_inode	*ip = sc->ip;
+	int64_t			delta;
+	int			error;
+
+	delta = ip->i_nblocks + ip->i_delayed_blks - ip->i_meta_resv_asked;
+	if (delta == 0)
+		return 0;
+
+	/*
+	 * Too many blocks have been reserved, transfer some from the incore
+	 * reservation back to the filesystem.
+	 */
+	if (delta > 0) {
+		int64_t		give_back;
+
+		give_back = min_t(uint64_t, delta, ip->i_delayed_blks);
+		if (give_back > 0) {
+			xfs_mod_delalloc(ip, 0, -give_back);
+			xfs_add_fdblocks(ip->i_mount, give_back);
+			ip->i_delayed_blks -= give_back;
+		}
+
+		return 0;
+	}
+
+	/*
+	 * Not enough reservation; try to take some blocks from the filesystem
+	 * to the metadata inode.  @delta is negative here, so invert the sign.
+	 */
+	delta = -delta;
+	error = xfs_dec_fdblocks(sc->mp, delta, true);
+	while (error == -ENOSPC) {
+		delta--;
+		if (delta == 0) {
+			xfs_warn(sc->mp,
+"Insufficient free space to reset space reservation for inode 0x%llx after repair.",
+					ip->i_ino);
+			return 0;
+		}
+		error = xfs_dec_fdblocks(sc->mp, delta, true);
+	}
+	if (error)
+		return error;
+
+	xfs_mod_delalloc(ip, 0, delta);
+	ip->i_delayed_blks += delta;
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 7f493752ea78e6..ac5962732d269d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -97,6 +97,7 @@ int xrep_setup_parent(struct xfs_scrub *sc);
 int xrep_setup_nlinks(struct xfs_scrub *sc);
 int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *resblks);
 int xrep_setup_dirtree(struct xfs_scrub *sc);
+int xrep_setup_rtrmapbt(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -113,10 +114,15 @@ int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 void xrep_rtgroup_btcur_init(struct xfs_scrub *sc, struct xchk_rt *sr);
 int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
 		xfs_filblks_t len);
+xfs_extlen_t xrep_calc_rtgroup_resblks(struct xfs_scrub *sc);
 #else
 # define xrep_rtgroup_init(sc, rtg, sr, lockflags)	(-ENOSYS)
+# define xrep_calc_rtgroup_resblks(sc)			(0)
 #endif /* CONFIG_XFS_RT */
 
+int xrep_check_ino_btree_mapping(struct xfs_scrub *sc,
+		const struct xfs_rmap_irec *rec);
+
 /* Metadata revalidators */
 
 int xrep_revalidate_allocbt(struct xfs_scrub *sc);
@@ -150,10 +156,12 @@ int xrep_metapath(struct xfs_scrub *sc);
 int xrep_rtbitmap(struct xfs_scrub *sc);
 int xrep_rtsummary(struct xfs_scrub *sc);
 int xrep_rgsuperblock(struct xfs_scrub *sc);
+int xrep_rtrmapbt(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
 # define xrep_rtsummary			xrep_notsupported
 # define xrep_rgsuperblock		xrep_notsupported
+# define xrep_rtrmapbt			xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -172,6 +180,8 @@ int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
 void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
 
 bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
+void xrep_inode_set_nblocks(struct xfs_scrub *sc, int64_t new_blocks);
+int xrep_reset_metafile_resv(struct xfs_scrub *sc);
 
 #else
 
@@ -195,6 +205,8 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+#define xrep_calc_rtgroup_resblks	xrep_calc_ag_resblks
+
 static inline int
 xrep_reset_perag_resv(
 	struct xfs_scrub	*sc)
@@ -222,6 +234,7 @@ xrep_setup_nothing(
 #define xrep_setup_nlinks		xrep_setup_nothing
 #define xrep_setup_dirtree		xrep_setup_nothing
 #define xrep_setup_metapath		xrep_setup_nothing
+#define xrep_setup_rtrmapbt		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -259,6 +272,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_dirtree			xrep_notsupported
 #define xrep_metapath			xrep_notsupported
 #define xrep_rgsuperblock		xrep_notsupported
+#define xrep_rtrmapbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 764fa296792234..300a1e85b3d625 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -27,6 +27,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Set us up with the realtime metadata locked. */
 int
@@ -38,6 +39,12 @@ xchk_setup_rtrmapbt(
 	if (xchk_need_intent_drain(sc))
 		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
 
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rtrmapbt(sc);
+		if (error)
+			return error;
+	}
+
 	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
new file mode 100644
index 00000000000000..60e317725dea86
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -0,0 +1,733 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
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
+#include "xfs_btree_staging.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_quota.h"
+#include "xfs_rtalloc.h"
+#include "xfs_ag.h"
+#include "xfs_rtgroup.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/fsb_bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/iscan.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
+
+/*
+ * Realtime Reverse Mapping Btree Repair
+ * =====================================
+ *
+ * This isn't quite as difficult as repairing the rmap btree on the data
+ * device, since we only store the data fork extents of realtime files on the
+ * realtime device.  We still have to freeze the filesystem and stop the
+ * background threads like we do for the rmap repair, but we only have to scan
+ * realtime inodes.
+ *
+ * Collecting entries for the new realtime rmap btree is easy -- all we have
+ * to do is generate rtrmap entries from the data fork mappings of all realtime
+ * files in the filesystem.  We then scan the rmap btrees of the data device
+ * looking for extents belonging to the old btree and note them in a bitmap.
+ *
+ * To rebuild the realtime rmap btree, we bulk-load the collected mappings into
+ * a new btree cursor and atomically swap that into the realtime inode.  Then
+ * we can free the blocks from the old btree.
+ *
+ * We use the 'xrep_rtrmap' prefix for all the rmap functions.
+ */
+
+/*
+ * Packed rmap record.  The UNWRITTEN flags are hidden in the upper bits of
+ * offset, just like the on-disk record.
+ */
+struct xrep_rtrmap_extent {
+	xfs_rgblock_t	startblock;
+	xfs_extlen_t	blockcount;
+	uint64_t	owner;
+	uint64_t	offset;
+} __packed;
+
+/* Context for collecting rmaps */
+struct xrep_rtrmap {
+	/* new rtrmapbt information */
+	struct xrep_newbt	new_btree;
+
+	/* rmap records generated from primary metadata */
+	struct xfarray		*rtrmap_records;
+
+	struct xfs_scrub	*sc;
+
+	/* bitmap of old rtrmapbt blocks */
+	struct xfsb_bitmap	old_rtrmapbt_blocks;
+
+	/* inode scan cursor */
+	struct xchk_iscan	iscan;
+
+	/* get_records()'s position in the free space record array. */
+	xfarray_idx_t		array_cur;
+};
+
+/* Set us up to repair rt reverse mapping btrees. */
+int
+xrep_setup_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rtrmap	*rr;
+
+	rr = kzalloc(sizeof(struct xrep_rtrmap), XCHK_GFP_FLAGS);
+	if (!rr)
+		return -ENOMEM;
+
+	rr->sc = sc;
+	sc->buf = rr;
+	return 0;
+}
+
+/* Make sure there's nothing funny about this mapping. */
+STATIC int
+xrep_rtrmap_check_mapping(
+	struct xfs_scrub	*sc,
+	const struct xfs_rmap_irec *rec)
+{
+	if (xfs_rtrmap_check_irec(sc->sr.rtg, rec) != NULL)
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	return xrep_require_rtext_inuse(sc, rec->rm_startblock,
+			rec->rm_blockcount);
+}
+
+/* Store a reverse-mapping record. */
+static inline int
+xrep_rtrmap_stash(
+	struct xrep_rtrmap	*rr,
+	xfs_rgblock_t		startblock,
+	xfs_extlen_t		blockcount,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	struct xrep_rtrmap_extent	rre = {
+		.startblock	= startblock,
+		.blockcount	= blockcount,
+		.owner		= owner,
+	};
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= startblock,
+		.rm_blockcount	= blockcount,
+		.rm_owner	= owner,
+		.rm_offset	= offset,
+		.rm_flags	= flags,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	trace_xrep_rtrmap_found(sc->mp, &rmap);
+
+	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
+	return xfarray_append(rr->rtrmap_records, &rre);
+}
+
+/* Finding all file and bmbt extents. */
+
+/* Context for accumulating rmaps for an inode fork. */
+struct xrep_rtrmap_ifork {
+	/*
+	 * Accumulate rmap data here to turn multiple adjacent bmaps into a
+	 * single rmap.
+	 */
+	struct xfs_rmap_irec	accum;
+
+	struct xrep_rtrmap	*rr;
+};
+
+/* Stash an rmap that we accumulated while walking an inode fork. */
+STATIC int
+xrep_rtrmap_stash_accumulated(
+	struct xrep_rtrmap_ifork	*rf)
+{
+	if (rf->accum.rm_blockcount == 0)
+		return 0;
+
+	return xrep_rtrmap_stash(rf->rr, rf->accum.rm_startblock,
+			rf->accum.rm_blockcount, rf->accum.rm_owner,
+			rf->accum.rm_offset, rf->accum.rm_flags);
+}
+
+/* Accumulate a bmbt record. */
+STATIC int
+xrep_rtrmap_visit_bmbt(
+	struct xfs_btree_cur	*cur,
+	struct xfs_bmbt_irec	*rec,
+	void			*priv)
+{
+	struct xrep_rtrmap_ifork *rf = priv;
+	struct xfs_rmap_irec	*accum = &rf->accum;
+	struct xfs_mount	*mp = rf->rr->sc->mp;
+	xfs_rgblock_t		rgbno;
+	unsigned int		rmap_flags = 0;
+	int			error;
+
+	if (xfs_rtb_to_rgno(mp, rec->br_startblock) !=
+	    rtg_rgno(rf->rr->sc->sr.rtg))
+		return 0;
+
+	if (rec->br_state == XFS_EXT_UNWRITTEN)
+		rmap_flags |= XFS_RMAP_UNWRITTEN;
+
+	/* If this bmap is adjacent to the previous one, just add it. */
+	rgbno = xfs_rtb_to_rgbno(mp, rec->br_startblock);
+	if (accum->rm_blockcount > 0 &&
+	    rec->br_startoff == accum->rm_offset + accum->rm_blockcount &&
+	    rgbno == accum->rm_startblock + accum->rm_blockcount &&
+	    rmap_flags == accum->rm_flags) {
+		accum->rm_blockcount += rec->br_blockcount;
+		return 0;
+	}
+
+	/* Otherwise stash the old rmap and start accumulating a new one. */
+	error = xrep_rtrmap_stash_accumulated(rf);
+	if (error)
+		return error;
+
+	accum->rm_startblock = rgbno;
+	accum->rm_blockcount = rec->br_blockcount;
+	accum->rm_offset = rec->br_startoff;
+	accum->rm_flags = rmap_flags;
+	return 0;
+}
+
+/*
+ * Iterate the block mapping btree to collect rmap records for anything in this
+ * fork that maps to the rt volume.  Sets @mappings_done to true if we've
+ * scanned the block mappings in this fork.
+ */
+STATIC int
+xrep_rtrmap_scan_bmbt(
+	struct xrep_rtrmap_ifork *rf,
+	struct xfs_inode	*ip,
+	bool			*mappings_done)
+{
+	struct xrep_rtrmap	*rr = rf->rr;
+	struct xfs_btree_cur	*cur;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	int			error = 0;
+
+	*mappings_done = false;
+
+	/*
+	 * If the incore extent cache is already loaded, we'll just use the
+	 * incore extent scanner to record mappings.  Don't bother walking the
+	 * ondisk extent tree.
+	 */
+	if (!xfs_need_iread_extents(ifp))
+		return 0;
+
+	/* Accumulate all the mappings in the bmap btree. */
+	cur = xfs_bmbt_init_cursor(rr->sc->mp, rr->sc->tp, ip, XFS_DATA_FORK);
+	error = xfs_bmap_query_all(cur, xrep_rtrmap_visit_bmbt, rf);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		return error;
+
+	/* Stash any remaining accumulated rmaps and exit. */
+	*mappings_done = true;
+	return xrep_rtrmap_stash_accumulated(rf);
+}
+
+/*
+ * Iterate the in-core extent cache to collect rmap records for anything in
+ * this fork that matches the AG.
+ */
+STATIC int
+xrep_rtrmap_scan_iext(
+	struct xrep_rtrmap_ifork *rf,
+	struct xfs_ifork	*ifp)
+{
+	struct xfs_bmbt_irec	rec;
+	struct xfs_iext_cursor	icur;
+	int			error;
+
+	for_each_xfs_iext(ifp, &icur, &rec) {
+		if (isnullstartblock(rec.br_startblock))
+			continue;
+		error = xrep_rtrmap_visit_bmbt(NULL, &rec, rf);
+		if (error)
+			return error;
+	}
+
+	return xrep_rtrmap_stash_accumulated(rf);
+}
+
+/* Find all the extents on the realtime device mapped by an inode fork. */
+STATIC int
+xrep_rtrmap_scan_dfork(
+	struct xrep_rtrmap	*rr,
+	struct xfs_inode	*ip)
+{
+	struct xrep_rtrmap_ifork rf = {
+		.accum		= { .rm_owner = ip->i_ino, },
+		.rr		= rr,
+	};
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	int			error = 0;
+
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+		bool		mappings_done;
+
+		/*
+		 * Scan the bmbt for mappings.  If the incore extent tree is
+		 * loaded, we want to scan the cached mappings since that's
+		 * faster when the extent counts are very high.
+		 */
+		error = xrep_rtrmap_scan_bmbt(&rf, ip, &mappings_done);
+		if (error || mappings_done)
+			return error;
+	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
+		/* realtime data forks should only be extents or btree */
+		return -EFSCORRUPTED;
+	}
+
+	/* Scan incore extent cache. */
+	return xrep_rtrmap_scan_iext(&rf, ifp);
+}
+
+/* Record reverse mappings for a file. */
+STATIC int
+xrep_rtrmap_scan_inode(
+	struct xrep_rtrmap	*rr,
+	struct xfs_inode	*ip)
+{
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	/* Skip the rt rmap btree inode. */
+	if (rr->sc->ip == ip)
+		return 0;
+
+	lock_mode = xfs_ilock_data_map_shared(ip);
+
+	/* Check the data fork if it's on the realtime device. */
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = xrep_rtrmap_scan_dfork(rr, ip);
+		if (error)
+			goto out_unlock;
+	}
+
+	xchk_iscan_mark_visited(&rr->iscan, ip);
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+	return error;
+}
+
+/* Record extents that belong to the realtime rmap inode. */
+STATIC int
+xrep_rtrmap_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rtrmap		*rr = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(rr->sc, &error))
+		return error;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rr->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_check_ino_btree_mapping(rr->sc, rec);
+	if (error)
+		return error;
+
+	return xfsb_bitmap_set(&rr->old_rtrmapbt_blocks,
+			xfs_gbno_to_fsb(cur->bc_group, rec->rm_startblock),
+			rec->rm_blockcount);
+}
+
+/* Scan one AG for reverse mappings for the realtime rmap btree. */
+STATIC int
+xrep_rtrmap_scan_ag(
+	struct xrep_rtrmap	*rr,
+	struct xfs_perag	*pag)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	error = xrep_ag_init(sc, pag, &sc->sa);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_rtrmap_walk_rmap, rr);
+	xchk_ag_free(sc, &sc->sa);
+	return error;
+}
+
+/* Generate all the reverse-mappings for the realtime device. */
+STATIC int
+xrep_rtrmap_find_rmaps(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag = NULL;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/* Generate rmaps for the realtime superblock */
+	if (xfs_has_rtsb(sc->mp) && rtg_rgno(rr->sc->sr.rtg) == 0) {
+		error = xrep_rtrmap_stash(rr, 0, sc->mp->m_sb.sb_rextsize,
+				XFS_RMAP_OWN_FS, 0, 0);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Set up for a potentially lengthy filesystem scan by reducing our
+	 * transaction resource usage for the duration.  Specifically:
+	 *
+	 * Unlock the realtime metadata inodes and cancel the transaction to
+	 * release the log grant space while we scan the filesystem.
+	 *
+	 * Create a new empty transaction to eliminate the possibility of the
+	 * inode scan deadlocking on cyclical metadata.
+	 *
+	 * We pass the empty transaction to the file scanning function to avoid
+	 * repeatedly cycling empty transactions.  This can be done even though
+	 * we take the IOLOCK to quiesce the file because empty transactions
+	 * do not take sb_internal.
+	 */
+	xchk_trans_cancel(sc);
+	xchk_rtgroup_unlock(&sc->sr);
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(&rr->iscan, &ip)) == 1) {
+		error = xrep_rtrmap_scan_inode(rr, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	xchk_iscan_iter_finish(&rr->iscan);
+	if (error)
+		return error;
+
+	/*
+	 * Switch out for a real transaction and lock the RT metadata in
+	 * preparation for building a new tree.
+	 */
+	xchk_trans_cancel(sc);
+	error = xchk_setup_rt(sc);
+	if (error)
+		return error;
+	error = xchk_rtgroup_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+	if (error)
+		return error;
+
+	/* Scan for old rtrmap blocks. */
+	while ((pag = xfs_perag_next(sc->mp, pag))) {
+		error = xrep_rtrmap_scan_ag(rr, pag);
+		if (error) {
+			xfs_perag_rele(pag);
+			return error;
+		}
+	}
+
+	return 0;
+}
+
+/* Building the new rtrmap btree. */
+
+/* Retrieve rtrmapbt data for bulk load. */
+STATIC int
+xrep_rtrmap_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xrep_rtrmap_extent	rec;
+	struct xfs_rmap_irec		*irec = &cur->bc_rec.r;
+	struct xrep_rtrmap		*rr = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+	int				error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		error = xfarray_load_next(rr->rtrmap_records, &rr->array_cur,
+				&rec);
+		if (error)
+			return error;
+
+		irec->rm_startblock = rec.startblock;
+		irec->rm_blockcount = rec.blockcount;
+		irec->rm_owner = rec.owner;
+
+		if (xfs_rmap_irec_offset_unpack(rec.offset, irec) != NULL)
+			return -EFSCORRUPTED;
+
+		error = xrep_rtrmap_check_mapping(rr->sc, irec);
+		if (error)
+			return error;
+
+		block_rec = xfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_rtrmap_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_rtrmap	*rr = priv;
+
+	return xrep_newbt_claim_block(cur, &rr->new_btree, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_rtrmap_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	return xfs_rtrmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
+}
+
+/*
+ * Use the collected rmap information to stage a new rmap btree.  If this is
+ * successful we'll return with the new btree root information logged to the
+ * repair transaction but not yet committed.  This implements section (III)
+ * above.
+ */
+STATIC int
+xrep_rtrmap_build_new_tree(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xfs_btree_cur	*rmap_cur;
+	uint64_t		nr_records;
+	int			error;
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the realtime rmapbt inode.
+	 */
+	error = xrep_newbt_init_metadir_inode(&rr->new_btree, sc);
+	if (error)
+		return error;
+
+	rr->new_btree.bload.get_records = xrep_rtrmap_get_records;
+	rr->new_btree.bload.claim_block = xrep_rtrmap_claim_block;
+	rr->new_btree.bload.iroot_size = xrep_rtrmap_iroot_size;
+
+	rmap_cur = xfs_rtrmapbt_init_cursor(NULL, rtg);
+	xfs_btree_stage_ifakeroot(rmap_cur, &rr->new_btree.ifake);
+
+	nr_records = xfarray_length(rr->rtrmap_records);
+
+	/* Compute how many blocks we'll need for the rmaps collected. */
+	error = xfs_btree_bload_compute_geometry(rmap_cur,
+			&rr->new_btree.bload, nr_records);
+	if (error)
+		goto err_cur;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err_cur;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire
+	 * rtrmapbt from the number of extents we found, and pump up our
+	 * transaction to have sufficient block reservation.  We're allowed
+	 * to exceed quota to repair inconsistent metadata, though this is
+	 * unlikely.
+	 */
+	error = xfs_trans_reserve_more_inode(sc->tp, rtg_rmap(rtg),
+			rr->new_btree.bload.nr_blocks, 0, true);
+	if (error)
+		goto err_cur;
+
+	/* Reserve the space we'll need for the new btree. */
+	error = xrep_newbt_alloc_blocks(&rr->new_btree,
+			rr->new_btree.bload.nr_blocks);
+	if (error)
+		goto err_cur;
+
+	/* Add all observed rmap records. */
+	rr->new_btree.ifake.if_fork->if_format = XFS_DINODE_FMT_META_BTREE;
+	rr->array_cur = XFARRAY_CURSOR_INIT;
+	error = xfs_btree_bload(rmap_cur, &rr->new_btree.bload, rr);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new rtrmap btree in the inode.  After this point the old
+	 * btree is no longer accessible, the new tree is live, and we can
+	 * delete the cursor.
+	 */
+	xfs_rtrmapbt_commit_staged_btree(rmap_cur, sc->tp);
+	xrep_inode_set_nblocks(rr->sc, rr->new_btree.ifake.if_blocks);
+	xfs_btree_del_cursor(rmap_cur, 0);
+
+	/* Dispose of any unused blocks and the accounting information. */
+	error = xrep_newbt_commit(&rr->new_btree);
+	if (error)
+		return error;
+
+	return xrep_roll_trans(sc);
+
+err_cur:
+	xfs_btree_del_cursor(rmap_cur, error);
+	xrep_newbt_cancel(&rr->new_btree);
+	return error;
+}
+
+/* Reaping the old btree. */
+
+/* Reap the old rtrmapbt blocks. */
+STATIC int
+xrep_rtrmap_remove_old_tree(
+	struct xrep_rtrmap	*rr)
+{
+	int			error;
+
+	/*
+	 * Free all the extents that were allocated to the former rtrmapbt and
+	 * aren't cross-linked with something else.
+	 */
+	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
+	if (error)
+		return error;
+
+	/*
+	 * Ensure the proper reservation for the rtrmap inode so that we don't
+	 * fail to expand the new btree.
+	 */
+	return xrep_reset_metafile_resv(rr->sc);
+}
+
+/* Set up the filesystem scan components. */
+STATIC int
+xrep_rtrmap_setup_scan(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	char			*descr;
+	int			error;
+
+	xfsb_bitmap_init(&rr->old_rtrmapbt_blocks);
+
+	/* Set up some storage */
+	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
+	error = xfarray_create(descr, 0, sizeof(struct xrep_rtrmap_extent),
+			&rr->rtrmap_records);
+	kfree(descr);
+	if (error)
+		goto out_bitmap;
+
+	/* Retry iget every tenth of a second for up to 30 seconds. */
+	xchk_iscan_start(sc, 30000, 100, &rr->iscan);
+	return 0;
+
+out_bitmap:
+	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+	return error;
+}
+
+/* Tear down scan components. */
+STATIC void
+xrep_rtrmap_teardown(
+	struct xrep_rtrmap	*rr)
+{
+	xchk_iscan_teardown(&rr->iscan);
+	xfarray_destroy(rr->rtrmap_records);
+	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+}
+
+/* Repair the realtime rmap btree. */
+int
+xrep_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rtrmap	*rr = sc->buf;
+	int			error;
+
+	/* Functionality is not yet complete. */
+	return xrep_notsupported(sc);
+
+	/* Make sure any problems with the fork are fixed. */
+	error = xrep_metadata_inode_forks(sc);
+	if (error)
+		return error;
+
+	error = xrep_rtrmap_setup_scan(rr);
+	if (error)
+		return error;
+
+	/* Collect rmaps for realtime files. */
+	error = xrep_rtrmap_find_rmaps(rr);
+	if (error)
+		goto out_records;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Rebuild the rtrmap information. */
+	error = xrep_rtrmap_build_new_tree(rr);
+	if (error)
+		goto out_records;
+
+	/* Kill the old tree. */
+	error = xrep_rtrmap_remove_old_tree(rr);
+	if (error)
+		goto out_records;
+
+out_records:
+	xrep_rtrmap_teardown(rr);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 09983899c34164..16da054b2eb0dc 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -465,7 +465,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rtrmapbt,
 		.scrub	= xchk_rtrmapbt,
 		.has	= xfs_has_rtrmapbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtrmapbt,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3b661e4443453c..3f2a8695ef5cb5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2285,6 +2285,32 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		  __entry->rmapbt_sz,
 		  __entry->refcbt_sz)
 )
+
+#ifdef CONFIG_XFS_RT
+TRACE_EVENT(xrep_calc_rtgroup_resblks_btsize,
+	TP_PROTO(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		 xfs_rgblock_t usedlen, xfs_rgblock_t rmapbt_sz),
+	TP_ARGS(mp, rgno, usedlen, rmapbt_sz),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rgblock_t, usedlen)
+		__field(xfs_rgblock_t, rmapbt_sz)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rgno = rgno;
+		__entry->usedlen = usedlen;
+		__entry->rmapbt_sz = rmapbt_sz;
+	),
+	TP_printk("dev %d:%d rgno 0x%x usedlen %u rmapbt %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->usedlen,
+		  __entry->rmapbt_sz)
+);
+#endif /* CONFIG_XFS_RT */
+
 TRACE_EVENT(xrep_reset_counters,
 	TP_PROTO(struct xfs_mount *mp, struct xchk_fscounters *fsc),
 	TP_ARGS(mp, fsc),
@@ -3755,6 +3781,37 @@ TRACE_EVENT(xrep_rtbitmap_load_word,
 		  (__entry->ondisk_word & __entry->word_mask),
 		  __entry->word_mask)
 );
+
+TRACE_EVENT(xrep_rtrmap_found,
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_rmap_irec *rec),
+	TP_ARGS(mp, rec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rgblock_t, rgbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rtdev = mp->m_rtdev_targp->bt_dev;
+		__entry->rgbno = rec->rm_startblock;
+		__entry->len = rec->rm_blockcount;
+		__entry->owner = rec->rm_owner;
+		__entry->offset = rec->rm_offset;
+		__entry->flags = rec->rm_flags;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rgbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->rgbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
 #endif /* CONFIG_XFS_RT */
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */

