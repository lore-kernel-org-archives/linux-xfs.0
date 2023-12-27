Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8530634
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vM9hloQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2D9C433C8;
	Mon,  1 Jan 2024 00:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067518;
	bh=NCwCJZ0+D5JIfKiu0TGMQ0XNPhycnWb1RbcwpDWNX5g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vM9hloQeShPJ8/cgLucfgSJlg7ZIi5sDTnKmBlIvZ7CcBY+hCVCKie3MP6XoXrW/3
	 StcF/HN+DdgdzVkc2LuDzlDbviFurKbhGySpPZ13c9NF/j6+Gub3O+EmqzJ6CGBPpI
	 xk4CyyO1pRx6TCFEp4i1fkJBcN9GizZv8dhx09c/xbkapa5oiJOSbKuUOgtUuqJrfg
	 xu3zi4itYHmbEtNFsvCQJLJeLv+zg8yCstixnIFBijaFNDGiDRngaw9JedOerYodZQ
	 WDbBEhnw0OGusx1kFN5tGeeWi1vEUPnlTsfSbpZd54LsuVIX/D7GaeEyhnZtg/K4Eu
	 8maxof3OdlmpA==
Date: Sun, 31 Dec 2023 16:05:18 +9900
Subject: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in the
 data device
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013726.1813633.879478659620513065.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013700.1813633.7627597760064686124.stgit@frogsfrogsfrogs>
References: <170405013700.1813633.7627597760064686124.stgit@frogsfrogsfrogs>
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
 include/xfs_inode.h   |    5 +
 include/xfs_mount.h   |    1 
 include/xfs_trace.h   |    7 ++
 io/inject.c           |    1 
 libxfs/init.c         |   11 +++
 libxfs/libxfs_priv.h  |   11 +++
 libxfs/xfs_ag_resv.c  |    3 +
 libxfs/xfs_errortag.h |    4 +
 libxfs/xfs_imeta.c    |  190 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h    |   11 +++
 libxfs/xfs_types.h    |    7 ++
 11 files changed, 248 insertions(+), 3 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 2675abdffcd..ec73fe192fd 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -216,7 +216,10 @@ typedef struct xfs_inode {
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_ifork	i_af;		/* attribute fork */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
-	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
+	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
+	/* Space that has been set aside to root a btree in this file. */
+	uint64_t		i_meta_resv_asked;
+
 	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	prid_t			i_projid;	/* owner's project id */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index a2fdd7c2f14..51a02e69776 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -99,6 +99,7 @@ typedef struct xfs_mount {
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refc btree levels */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
+	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 08ec51fc799..5010b35b1f6 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -389,4 +389,11 @@
 #define trace_xfs_iunlink_remove(...)		((void) 0)
 #define trace_xfs_iunlink_map_prev_fallback(...)	((void) 0)
 
+#define trace_xfs_imeta_resv_alloc_extent(...)	((void) 0)
+#define trace_xfs_imeta_resv_critical(...)	((void) 0)
+#define trace_xfs_imeta_resv_free(...)		((void) 0)
+#define trace_xfs_imeta_resv_free_extent(...)	((void) 0)
+#define trace_xfs_imeta_resv_init(...)		((void) 0)
+#define trace_xfs_imeta_resv_init_error(...)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/io/inject.c b/io/inject.c
index 4b0cd76005c..644baa42b64 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -64,6 +64,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_WB_DELAY_MS,		"wb_delay_ms" },
 		{ XFS_ERRTAG_WRITE_DELAY_MS,		"write_delay_ms" },
 		{ XFS_ERRTAG_SWAPEXT_FINISH_ONE,	"swapext_finish_one" },
+		{ XFS_ERRTAG_IMETA_RESV_CRITICAL,	"imeta_resv_critical" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/init.c b/libxfs/init.c
index 0332a4eeb21..2663485a80d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -651,6 +651,15 @@ xfs_agbtree_compute_maxlevels(
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
 /* Compute maximum possible height of all btrees. */
 void
 libxfs_compute_all_maxlevels(
@@ -667,7 +676,7 @@ libxfs_compute_all_maxlevels(
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
-
+	xfs_rtbtree_compute_maxlevels(mp);
 }
 
 /* Mount the metadata files under the metadata directory tree. */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 120a41e20a7..bbe7dd63443 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -221,6 +221,17 @@ uint32_t get_random_u32(void);
 #define get_random_u32()	(0)
 #endif
 
+static inline int
+__percpu_counter_compare(uint64_t *count, int64_t rhs, int32_t batch)
+{
+	if (*count > rhs)
+		return 1;
+	else if (*count < rhs)
+		return -1;
+	return 0;
+}
+
+
 #define PAGE_SIZE		getpagesize()
 
 #define inode_peek_iversion(inode)	(inode)->i_version
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 542740bb850..5963ff5602b 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -112,6 +112,7 @@ xfs_ag_resv_needed(
 	case XFS_AG_RESV_RMAPBT:
 		len -= xfs_perag_resv(pag, type)->ar_reserved;
 		break;
+	case XFS_AG_RESV_IMETA:
 	case XFS_AG_RESV_NONE:
 		/* empty */
 		break;
@@ -346,6 +347,7 @@ xfs_ag_resv_alloc_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_IMETA:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
@@ -388,6 +390,7 @@ xfs_ag_resv_free_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_IMETA:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 263d62a8d70..f359df69d6b 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
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
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index 6ada36d5559..e2b14624381 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -26,6 +26,9 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_health.h"
+#include "xfs_errortag.h"
+#include "xfs_btree.h"
+#include "xfs_alloc.h"
 
 /*
  * Metadata File Management
@@ -1074,3 +1077,190 @@ xfs_imeta_free_path(
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
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 3b5953efc01..f6dda8e5af0 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
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
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 195471c4385..ad2ce83874f 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
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

