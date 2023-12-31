Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B99BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNaw9JKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0D2C433C8;
	Sun, 31 Dec 2023 21:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057979;
	bh=ApdNkJUMC2O79NDTKDHDclIquSh1VXNb18hKnjzfgtE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PNaw9JKLvuaPvVX46ciBfDieZAk/7PcZTnP9VUhGXChzgYTWU4LGl9ff5QZJ5B1x9
	 tCk1yZ5POmPnG7hDT66SEpIwBkcqac7OrdypV86FLfKEvFbqPmiFae65AosjwPdY04
	 c+tBeg6fEm45A/bdshk8oau9LOa2xuHT7tyAUJ8sLyItSXL+TBEi9aZEjzlwW5FfLE
	 iHfyHcgC/AJPwwP1ltucMtm466FKDqTXGjZunSVot9JcG2zfbj+ITQTHrnSg3G49dx
	 ohJ2ZtltpWto9wcBOTKobIkiAiPRaXatUvCGZ3e1Lrde8RvsuWT0NxObxUjCIDbTUL
	 k1ODOLkEEx2eA==
Date: Sun, 31 Dec 2023 13:26:18 -0800
Subject: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in the
 data device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847963.1764226.13292944018021574980.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847925.1764226.3996380045217070282.stgit@frogsfrogsfrogs>
References: <170404847925.1764226.3996380045217070282.stgit@frogsfrogsfrogs>
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

Create a new space reservation scheme so that btree metadata for the
realtime volume can reserve space in the data device to avoid space
underruns.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c  |    3 +
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_imeta.c    |  191 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h    |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 ++
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_fsops.c           |   17 ++++
 fs/xfs/xfs_inode.h           |    3 +
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_rtalloc.c         |   23 +++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_trace.h           |   45 ++++++++++
 13 files changed, 322 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index c9594254304b2..f775b92b4aacd 100644
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
index 263d62a8d70f8..f359df69d6b52 100644
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
index 57be23f89d864..8c9eef0eebda1 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -27,6 +27,10 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_health.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
+#include "xfs_btree.h"
+#include "xfs_alloc.h"
 
 /*
  * Metadata File Management
@@ -1075,3 +1079,190 @@ xfs_imeta_free_path(
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
+	ASSERT(xfs_is_metadir_inode(ip));
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
+	ASSERT(xfs_is_metadir_inode(ip));
+	ASSERT(XFS_IS_DQDETACHED(ip->i_mount, ip));
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
+	xfs_trans_log_inode(args->tp, ip, XFS_ILOG_CORE);
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
+	ASSERT(xfs_is_metadir_inode(ip));
+	ASSERT(XFS_IS_DQDETACHED(ip->i_mount, ip));
+	trace_xfs_imeta_resv_free_extent(ip, len);
+
+	ip->i_nblocks -= len;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
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
+	ASSERT(xfs_is_metadir_inode(ip));
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
+	ASSERT(xfs_is_metadir_inode(ip));
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
index 3b5953efc013c..f6dda8e5af006 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -102,6 +102,17 @@ unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_link_space_res(struct xfs_mount *mp);
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
 int xfs_imeta_iget(struct xfs_trans *tp, xfs_ino_t ino, unsigned char ftype,
 		struct xfs_inode **ipp);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 195471c438599..ad2ce83874f9f 100644
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
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index c3792ab41c271..35702905a0fe1 100644
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
index bd37a7ef28178..99f9f5c8d9b6e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -22,6 +22,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -592,6 +593,19 @@ xfs_fs_reserve_ag_blocks(
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
@@ -607,6 +621,9 @@ xfs_fs_unreserve_ag_blocks(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
+	if (xfs_has_realtime(mp))
+		xfs_rt_resv_free(mp);
+
 	for_each_perag(mp, agno, pag)
 		xfs_ag_resv_free(pag);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e33b270c6b508..6013a97d02c5d 100644
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
index ba6c77e7e265d..c774ac73bdec5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -659,6 +659,15 @@ xfs_agbtree_compute_maxlevels(
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
@@ -731,6 +740,7 @@ xfs_mountfs(
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
+	xfs_rtbtree_compute_maxlevels(mp);
 
 	/*
 	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a086b96b0a513..7ef8d5f706883 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -140,6 +140,7 @@ typedef struct xfs_mount {
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
+	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6479bb04657ec..49528f901d047 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1310,6 +1310,14 @@ xfs_growfs_rt(
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
@@ -1544,6 +1552,21 @@ xfs_rtalloc_reinit_frextents(
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
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index b982b97cf073f..c01ca192646a9 100644
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
@@ -96,6 +99,8 @@ xfs_rtmount_init(
 }
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
+# define xfs_rt_resv_free(mp)				((void)0)
+# define xfs_rt_resv_init(mp)				(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 87c3fe0f078be..db5d2b20b36fc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5282,6 +5282,51 @@ DEFINE_EVENT(xfs_imeta_dir_class, name, \
 	TP_ARGS(dp, name, ino))
 DEFINE_IMETA_DIR_EVENT(xfs_imeta_dir_lookup);
 
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

