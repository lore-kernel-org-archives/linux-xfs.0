Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B35EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiLaBed (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiLaBec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A10F18387
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 859C561CC5
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF785C433EF;
        Sat, 31 Dec 2022 01:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450468;
        bh=Tn1r2nbGw4j7LBFe5wQC4oavnaVobsV7llTwTiLgZB4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bxr6ukSpsVnj10Ur4I+wmSWLbU1LYzNhsdWSNbiqGYD/XkxY6LmRR/lneaojxF//b
         xt5B5H5tWQ3Mj0aKaFxE0hvu4SBfbKrVlOZXABeCc58dn+nrPTOpz0k3uh44FcH1WC
         juQbX4Fz9X0wdXI1FfdpPCPkKMqkAsSvR/+k9hj3dttkXoWoRGgClH9E9ThMl8nUCx
         /PqjaE90ToafbEYzg8G7qC18EdAV3ZSbh0tkjvZ+jPWZVHYmfBQU44+MHsBe6mhF1Y
         3FL9K2PqPz2zKvvO3nxy5Qj+JNKKNEplU2c5lHS7m/F9qSJn+4mU2WzrEvAatGMGjX
         vQfN4P8XmbtRA==
Subject: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in the
 data device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:02 -0800
Message-ID: <167243868227.714306.9230373978142096047.stgit@magnolia>
In-Reply-To: <167243868195.714306.16190516279141417082.stgit@magnolia>
References: <167243868195.714306.16190516279141417082.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new space reservation scheme so that btree metadata for the
realtime volume can reserve space in the data device to avoid space
underruns.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c  |    3 +
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_imeta.c    |  187 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h    |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 ++
 fs/xfs/scrub/newbt.c         |    3 -
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_fsops.c           |   17 ++++
 fs/xfs/xfs_inode.h           |    3 +
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_rtalloc.c         |   23 +++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_trace.h           |   45 ++++++++++
 14 files changed, 320 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 8723cd0d3f58..75c04319e9e3 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -113,6 +113,7 @@ xfs_ag_resv_needed(
 	case XFS_AG_RESV_RMAPBT:
 		len -= xfs_perag_resv(pag, type)->ar_reserved;
 		break;
+	case XFS_AG_RESV_IMETA:
 	case XFS_AG_RESV_NONE:
 		/* empty */
 		break;
@@ -347,6 +348,7 @@ xfs_ag_resv_alloc_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_IMETA:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
@@ -389,6 +391,7 @@ xfs_ag_resv_free_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_IMETA:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 263d62a8d70f..f359df69d6b5 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -64,7 +64,8 @@
 #define XFS_ERRTAG_WB_DELAY_MS				42
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
 #define XFS_ERRTAG_SWAPEXT_FINISH_ONE			44
-#define XFS_ERRTAG_MAX					45
+#define XFS_ERRTAG_IMETA_RESV_CRITICAL			45
+#define XFS_ERRTAG_MAX					46
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -113,5 +114,6 @@
 #define XFS_RANDOM_WB_DELAY_MS				3000
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
 #define XFS_RANDOM_SWAPEXT_FINISH_ONE			1
+#define XFS_RANDOM_IMETA_RESV_CRITICAL			4
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index e4db1651d067..5bfb1eabf21d 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -27,6 +27,10 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
+#include "xfs_btree.h"
+#include "xfs_alloc.h"
 
 /*
  * Metadata Inode Number Management
@@ -1208,3 +1212,186 @@ xfs_imeta_free_path(
 	kfree(path->im_path);
 	kfree(path);
 }
+
+/*
+ * Is the amount of space that could be allocated towards a given metadata
+ * file at or beneath a certain threshold?
+ */
+static inline bool
+xfs_imeta_resv_can_cover(
+	struct xfs_inode	*ip,
+	int64_t			rhs)
+{
+	/*
+	 * The amount of space that can be allocated to this metadata file is
+	 * the remaining reservation for the particular metadata file + the
+	 * global free block count.  Take care of the first case to avoid
+	 * touching the per-cpu counter.
+	 */
+	if (ip->i_delayed_blks >= rhs)
+		return true;
+
+	/*
+	 * There aren't enough blocks left in the inode's reservation, but it
+	 * isn't critical unless there also isn't enough free space.
+	 */
+	return __percpu_counter_compare(&ip->i_mount->m_fdblocks,
+			rhs - ip->i_delayed_blks, 2048) >= 0;
+}
+
+/*
+ * Is this metadata file critically low on blocks?  For now we'll define that
+ * as the number of blocks we can get our hands on being less than 10% of what
+ * we reserved or less than some arbitrary number (maximum btree height).
+ */
+bool
+xfs_imeta_resv_critical(
+	struct xfs_inode	*ip)
+{
+	uint64_t		asked_low_water;
+
+	if (!ip)
+		return false;
+
+	ASSERT(xfs_is_metadata_inode(ip));
+	trace_xfs_imeta_resv_critical(ip, 0);
+
+	if (!xfs_imeta_resv_can_cover(ip, ip->i_mount->m_rtbtree_maxlevels))
+		return true;
+
+	asked_low_water = div_u64(ip->i_meta_resv_asked, 10);
+	if (!xfs_imeta_resv_can_cover(ip, asked_low_water))
+		return true;
+
+	return XFS_TEST_ERROR(false, ip->i_mount,
+			XFS_ERRTAG_IMETA_RESV_CRITICAL);
+}
+
+/* Allocate a block from the metadata file's reservation. */
+void
+xfs_imeta_resv_alloc_extent(
+	struct xfs_inode	*ip,
+	struct xfs_alloc_arg	*args)
+{
+	int64_t			len = args->len;
+
+	ASSERT(xfs_is_metadata_inode(ip));
+	ASSERT(args->resv == XFS_AG_RESV_IMETA);
+
+	trace_xfs_imeta_resv_alloc_extent(ip, args->len);
+
+	/*
+	 * Allocate the blocks from the metadata inode's block reservation
+	 * and update the ondisk sb counter.
+	 */
+	if (ip->i_delayed_blks > 0) {
+		int64_t		from_resv;
+
+		from_resv = min_t(int64_t, len, ip->i_delayed_blks);
+		ip->i_delayed_blks -= from_resv;
+		xfs_mod_delalloc(ip->i_mount, -from_resv);
+		xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS,
+				-from_resv);
+		len -= from_resv;
+	}
+
+	/*
+	 * Any allocation in excess of the reservation requires in-core and
+	 * on-disk fdblocks updates.
+	 */
+	if (len)
+		xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_FDBLOCKS, -len);
+
+	ip->i_nblocks += args->len;
+}
+
+/* Free a block to the metadata file's reservation. */
+void
+xfs_imeta_resv_free_extent(
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	xfs_filblks_t		len)
+{
+	int64_t			to_resv;
+
+	ASSERT(xfs_is_metadata_inode(ip));
+	trace_xfs_imeta_resv_free_extent(ip, len);
+
+	ip->i_nblocks -= len;
+
+	/*
+	 * Add the freed blocks back into the inode's delalloc reservation
+	 * until it reaches the maximum size.  Update the ondisk fdblocks only.
+	 */
+	to_resv = ip->i_meta_resv_asked - (ip->i_nblocks + ip->i_delayed_blks);
+	if (to_resv > 0) {
+		to_resv = min_t(int64_t, to_resv, len);
+		ip->i_delayed_blks += to_resv;
+		xfs_mod_delalloc(ip->i_mount, to_resv);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, to_resv);
+		len -= to_resv;
+	}
+
+	/*
+	 * Everything else goes back to the filesystem, so update the in-core
+	 * and on-disk counters.
+	 */
+	if (len)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, len);
+}
+
+/* Release a metadata file's space reservation. */
+void
+xfs_imeta_resv_free_inode(
+	struct xfs_inode	*ip)
+{
+	if (!ip)
+		return;
+
+	ASSERT(xfs_is_metadata_inode(ip));
+	trace_xfs_imeta_resv_free(ip, 0);
+
+	xfs_mod_delalloc(ip->i_mount, -ip->i_delayed_blks);
+	xfs_mod_fdblocks(ip->i_mount, ip->i_delayed_blks, true);
+	ip->i_delayed_blks = 0;
+	ip->i_meta_resv_asked = 0;
+}
+
+/* Set up a metadata file's space reservation. */
+int
+xfs_imeta_resv_init_inode(
+	struct xfs_inode	*ip,
+	xfs_filblks_t		ask)
+{
+	xfs_filblks_t		hidden_space;
+	xfs_filblks_t		used;
+	int			error;
+
+	if (!ip || ip->i_meta_resv_asked > 0)
+		return 0;
+
+	ASSERT(xfs_is_metadata_inode(ip));
+
+	/*
+	 * Space taken by all other metadata btrees are accounted on-disk as
+	 * used space.  We therefore only hide the space that is reserved but
+	 * not used by the trees.
+	 */
+	used = ip->i_nblocks;
+	if (used > ask)
+		ask = used;
+	hidden_space = ask - used;
+
+	error = xfs_mod_fdblocks(ip->i_mount, -(int64_t)hidden_space, true);
+	if (error) {
+		trace_xfs_imeta_resv_init_error(ip, error, _RET_IP_);
+		return error;
+	}
+
+	xfs_mod_delalloc(ip->i_mount, hidden_space);
+	ip->i_delayed_blks = hidden_space;
+	ip->i_meta_resv_asked = ask;
+
+	trace_xfs_imeta_resv_init(ip, ask);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 7840087b71da..c3137be4c47c 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -84,6 +84,17 @@ void xfs_imeta_droplink(struct xfs_inode *ip);
 unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 
+/* Space reservations for metadata inodes. */
+struct xfs_alloc_arg;
+
+bool xfs_imeta_resv_critical(struct xfs_inode *ip);
+void xfs_imeta_resv_alloc_extent(struct xfs_inode *ip,
+		struct xfs_alloc_arg *args);
+void xfs_imeta_resv_free_extent(struct xfs_inode *ip, struct xfs_trans *tp,
+		xfs_filblks_t len);
+void xfs_imeta_resv_free_inode(struct xfs_inode *ip);
+int xfs_imeta_resv_init_inode(struct xfs_inode *ip, xfs_filblks_t ask);
+
 /* Must be implemented by the libxfs client */
 int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
 		struct xfs_inode **ipp);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index c27c84561b5e..d37f8a7ce5f8 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -221,6 +221,13 @@ enum xfs_ag_resv_type {
 	 * altering fdblocks.  If you think you need this you're wrong.
 	 */
 	XFS_AG_RESV_IGNORE,
+
+	/*
+	 * This allocation activity is being done on behalf of a metadata file.
+	 * These files maintain their own permanent space reservations and are
+	 * required to adjust fdblocks using the xfs_imeta_resv_* helpers.
+	 */
+	XFS_AG_RESV_IMETA,
 };
 
 /* Results of scanning a btree keyspace to check occupancy. */
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index ebdfdf631be3..9c0ccba75656 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -422,7 +422,8 @@ xrep_newbt_free_extent(
 	}
 
 	if (xnr->resv == XFS_AG_RESV_RMAPBT ||
-	    xnr->resv == XFS_AG_RESV_METADATA) {
+	    xnr->resv == XFS_AG_RESV_METADATA ||
+	    xnr->resv == XFS_AG_RESV_IMETA) {
 		/*
 		 * Metadata blocks taken from a per-AG reservation must be put
 		 * back into that reservation immediately because EFIs cannot
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 4b57a809ced5..af449cf8847e 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -63,6 +63,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_WB_DELAY_MS,
 	XFS_RANDOM_WRITE_DELAY_MS,
 	XFS_RANDOM_SWAPEXT_FINISH_ONE,
+	XFS_RANDOM_IMETA_RESV_CRITICAL,
 };
 
 struct xfs_errortag_attr {
@@ -181,6 +182,7 @@ XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(swapext_finish_one, XFS_ERRTAG_SWAPEXT_FINISH_ONE);
+XFS_ERRORTAG_ATTR_RW(imeta_resv_critical, XFS_ERRTAG_IMETA_RESV_CRITICAL);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -227,6 +229,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(wb_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(swapext_finish_one),
+	XFS_ERRORTAG_ATTR_LIST(imeta_resv_critical),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 8186f142864a..9770916acd69 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -22,6 +22,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -576,6 +577,19 @@ xfs_fs_reserve_ag_blocks(
 		xfs_warn(mp,
 	"Error %d reserving per-AG metadata reserve pool.", error);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+
+	if (xfs_has_realtime(mp)) {
+		err2 = xfs_rt_resv_init(mp);
+		if (err2 && err2 != -ENOSPC) {
+			xfs_warn(mp,
+		"Error %d reserving realtime metadata reserve pool.", err2);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		}
+
+		if (err2 && !error)
+			error = err2;
 	}
 
 	return error;
@@ -591,6 +605,9 @@ xfs_fs_unreserve_ag_blocks(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
+	if (xfs_has_realtime(mp))
+		xfs_rt_resv_free(mp);
+
 	for_each_perag(mp, agno, pag)
 		xfs_ag_resv_free(pag);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 06601c409010..ca7ebb07efc7 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -55,6 +55,9 @@ typedef struct xfs_inode {
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
 	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
+	/* Space that has been set aside to root a btree in this file. */
+	uint64_t		i_meta_resv_asked;
+
 	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	prid_t			i_projid;	/* owner's project id */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bcfeaaf11536..d94d44f40be4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -649,6 +649,15 @@ xfs_agbtree_compute_maxlevels(
 	mp->m_agbtree_maxlevels = max(levels, mp->m_refc_maxlevels);
 }
 
+/* Compute maximum possible height for realtime btree types for this fs. */
+static inline void
+xfs_rtbtree_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	/* This will be filled in later. */
+	mp->m_rtbtree_maxlevels = 0;
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -721,6 +730,7 @@ xfs_mountfs(
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
+	xfs_rtbtree_compute_maxlevels(mp);
 
 	/*
 	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 176b2e71da9e..55e6e30f9045 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -138,6 +138,7 @@ typedef struct xfs_mount {
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
+	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f8f0557dc46c..7a94fb5b5a7f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1321,6 +1321,14 @@ xfs_growfs_rt(
 		goto out_free;
 
 	error = xfs_rtgroup_update_secondary_sbs(mp);
+	if (error)
+		goto out_free;
+
+	/* Reset the rt metadata btree space reservations. */
+	xfs_rt_resv_free(mp);
+	error = xfs_rt_resv_init(mp);
+	if (error == -ENOSPC)
+		error = 0;
 
 out_free:
 	/*
@@ -1554,6 +1562,21 @@ xfs_rtalloc_reinit_frextents(
 	return 0;
 }
 
+/* Free space reservations for rt metadata inodes. */
+void
+xfs_rt_resv_free(
+	struct xfs_mount	*mp)
+{
+}
+
+/* Reserve space for rt metadata inodes' space expansion. */
+int
+xfs_rt_resv_init(
+	struct xfs_mount	*mp)
+{
+	return 0;
+}
+
 static inline int
 __xfs_rt_iget(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index d0fd49db77bd..04931ab1bcac 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -54,6 +54,9 @@ int					/* error */
 xfs_rtmount_inodes(
 	struct xfs_mount	*mp);	/* file system mount structure */
 
+void xfs_rt_resv_free(struct xfs_mount *mp);
+int xfs_rt_resv_init(struct xfs_mount *mp);
+
 /*
  * Pick an extent for allocation at the start of a new realtime file.
  * Use the sequence number stored in the atime field of the bitmap inode.
@@ -99,6 +102,8 @@ xfs_rtmount_init(
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
 # define xfs_rtfile_convert_unwritten(ip, pos, len)	(0)
+# define xfs_rt_resv_free(mp)				((void)0)
+# define xfs_rt_resv_init(mp)				(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d0e939f5b706..0b5748546c4c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5072,6 +5072,51 @@ DEFINE_IMETA_DIR_EVENT(xfs_imeta_dir_created);
 DEFINE_IMETA_DIR_EVENT(xfs_imeta_dir_unlinked);
 DEFINE_IMETA_DIR_EVENT(xfs_imeta_dir_link);
 
+/* metadata inode space reservations */
+
+DECLARE_EVENT_CLASS(xfs_imeta_resv_class,
+	TP_PROTO(struct xfs_inode *ip, xfs_filblks_t len),
+	TP_ARGS(ip, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned long long, freeblks)
+		__field(unsigned long long, reserved)
+		__field(unsigned long long, asked)
+		__field(unsigned long long, used)
+		__field(unsigned long long, len)
+	),
+	TP_fast_assign(
+		struct xfs_mount *mp = ip->i_mount;
+
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->freeblks = percpu_counter_sum(&mp->m_fdblocks);
+		__entry->reserved = ip->i_delayed_blks;
+		__entry->asked = ip->i_meta_resv_asked;
+		__entry->used = ip->i_nblocks;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d ino 0x%llx freeblks %llu resv %llu ask %llu used %llu len %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->freeblks,
+		  __entry->reserved,
+		  __entry->asked,
+		  __entry->used,
+		  __entry->len)
+)
+#define DEFINE_IMETA_RESV_EVENT(name) \
+DEFINE_EVENT(xfs_imeta_resv_class, name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_filblks_t len), \
+	TP_ARGS(ip, len))
+DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_init);
+DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_free);
+DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_alloc_extent);
+DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_free_extent);
+DEFINE_IMETA_RESV_EVENT(xfs_imeta_resv_critical);
+DEFINE_INODE_ERROR_EVENT(xfs_imeta_resv_init_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

