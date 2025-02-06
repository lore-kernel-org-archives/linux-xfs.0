Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF66923C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881495; cv=none; b=KMR3Qm2DY+L5UA5ldH+MCslK1pgkZMjiqlwXA1mUQpEACJkSzdan5cnPYFywDLcAFVRMT6Ny7j9AgUp0sLRdGk34wFxxHZg2pkBndvC9OZkziRUzOKXstEiaoU3Fz0GUDinesNbBp8IS60em4ueaCtK6osYC8pi/EKMeK816Ooc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881495; c=relaxed/simple;
	bh=vmI+0sRpptpFs7QZj19AjeXPRPI18m7FMQu3RHPYVZw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NGCMcNAJ6iWg4YNjzUiRXDA89T4ZLgPTpK9t68jyapCCdGRmhQMBOUmcSfy4jBi4DAK4jfxMyWIl+TfXl7yz8R86iiiM3nYdC3vPW07UWk7I9ln5xOJds0URg+IdPzoviACMY8orbvLJIsrlMGFS/iHCeUlRgxRQZtdrdIxkpvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OokuMfZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OokuMfZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2318C4CEDD;
	Thu,  6 Feb 2025 22:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881494;
	bh=vmI+0sRpptpFs7QZj19AjeXPRPI18m7FMQu3RHPYVZw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OokuMfZPX+oYP50S6FNgbRzRhmxnFThLjVQ/ho7fBv5ebzcKNrmi6S2wrmCwY4Z2L
	 LH4vwBFKSHnOprCaf33tinLineOXpYSnOwzcc+alq+SrU+9p6WxvPI1olmmx4IBmJs
	 3s8pVqpU+TrAFPEUsw8E68nsSfdY0YgW3aQbxJS3YYGi+mDDHvVykZmRLx18fSTW5R
	 COpdAjL3UCK/pGPaVYRVRcNd0DXK/SvUmEhtR65rp9LGyJCkfZJpfJfiJcmF6rosWM
	 0JoxO5Zrt31+3hsQfNNEMdj5YFhNdsSZoYGytk4bsUQGj6dc1yc1jqp3s2lFOlivH5
	 Eic6fBXFmUkdA==
Date: Thu, 06 Feb 2025 14:38:14 -0800
Subject: [PATCH 12/56] xfs: allow inode-based btrees to reserve space in the
 data device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086975.2739176.1652989930338392540.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 05290bd5c6236b8ad659157edb36bd2d38f46d3e

Create a new space reservation scheme so that btree metadata for the
realtime volume can reserve space in the data device to avoid space
underruns.

Back when we were testing the rmap and refcount btrees for the data
device, people observed occasional shutdowns when xfs_btree_split was
called for either of those two btrees.  This happened when certain
operations (mostly writeback ioends) created new rmap or refcount
records, which would expand the size of the btree.  If there were no
free blocks available the allocation would fail and the split would shut
down the filesystem.

I considered pre-reserving blocks for btree expansion at the time of a
write() call, but there wasn't any good way to attach the reservations
to an inode and keep them there all the way to ioend processing.  Unlike
delalloc reservations which have that indlen mechanism, there's no way
to do that for mapped extents; and indlen blocks are given back during
the delalloc -> unwritten transition.

The solution was to reserve sufficient blocks for rmap/refcount btree
expansion at mount time.  This is what the XFS_AG_RESV_* flags provide;
any expansion of those two btrees can come from the pre-reserved space.

This patch brings that pre-reservation ability to inode-rooted btrees so
that the rt rmap and refcount btrees can also save room for future
expansion.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h   |    5 +
 include/xfs_mount.h   |    1 
 include/xfs_trace.h   |    7 ++
 io/inject.c           |    1 
 libxfs/libxfs_priv.h  |   11 +++
 libxfs/xfs_ag_resv.c  |    3 +
 libxfs/xfs_errortag.h |    4 +
 libxfs/xfs_metadir.c  |    3 +
 libxfs/xfs_metafile.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_metafile.h |   11 +++
 libxfs/xfs_types.h    |    7 ++
 11 files changed, 254 insertions(+), 2 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 30e171696c80e2..5bb31eb4aa5305 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -224,7 +224,10 @@ typedef struct xfs_inode {
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
index 19d08cf047f202..532bff8513bf53 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -115,6 +115,7 @@ typedef struct xfs_mount {
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refc btree levels */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
+	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a53ce092c8ea3b..30166c11dd597b 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -390,4 +390,11 @@
 #define trace_xfs_group_put(...)		((void) 0)
 #define trace_xfs_group_rele(...)		((void) 0)
 
+#define trace_xfs_metafile_resv_alloc_space(...)	((void) 0)
+#define trace_xfs_metafile_resv_critical(...)	((void) 0)
+#define trace_xfs_metafile_resv_free(...)		((void) 0)
+#define trace_xfs_metafile_resv_free_space(...)	((void) 0)
+#define trace_xfs_metafile_resv_init(...)		((void) 0)
+#define trace_xfs_metafile_resv_init_error(...)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/io/inject.c b/io/inject.c
index 4aeb6da326b4fd..7b9a76406cc54d 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -64,6 +64,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_WB_DELAY_MS,		"wb_delay_ms" },
 		{ XFS_ERRTAG_WRITE_DELAY_MS,		"write_delay_ms" },
 		{ XFS_ERRTAG_EXCHMAPS_FINISH_ONE,	"exchmaps_finish_one" },
+		{ XFS_ERRTAG_METAFILE_RESV_CRITICAL,	"metafile_resv_crit" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a1401b2c1e409b..7e5c125b581a2f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -219,6 +219,17 @@ uint32_t get_random_u32(void);
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
 extern unsigned int PAGE_SHIFT;
 
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index f5cbaa94664f22..83cac20331fd34 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -113,6 +113,7 @@ xfs_ag_resv_needed(
 	case XFS_AG_RESV_RMAPBT:
 		len -= xfs_perag_resv(pag, type)->ar_reserved;
 		break;
+	case XFS_AG_RESV_METAFILE:
 	case XFS_AG_RESV_NONE:
 		/* empty */
 		break;
@@ -346,6 +347,7 @@ xfs_ag_resv_alloc_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_METAFILE:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
@@ -388,6 +390,7 @@ xfs_ag_resv_free_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_METAFILE:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 7002d7676a7884..a53c5d40e084dc 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -64,7 +64,8 @@
 #define XFS_ERRTAG_WB_DELAY_MS				42
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
-#define XFS_ERRTAG_MAX					45
+#define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
+#define XFS_ERRTAG_MAX					46
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -113,5 +114,6 @@
 #define XFS_RANDOM_WB_DELAY_MS				3000
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
 #define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
+#define XFS_RANDOM_METAFILE_RESV_CRITICAL		4
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index b5f05925e73a4e..253fbf48e170e0 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -28,6 +28,9 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_parent.h"
 #include "xfs_health.h"
+#include "xfs_errortag.h"
+#include "xfs_btree.h"
+#include "xfs_alloc.h"
 
 /*
  * Metadata Directory Tree
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 3bd9493373115a..7f673d706aada8 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -17,6 +17,8 @@
 #include "xfs_metafile.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
+#include "xfs_errortag.h"
+#include "xfs_alloc.h"
 
 /* Set up an inode to be recognized as a metadata directory inode. */
 void
@@ -50,3 +52,204 @@ xfs_metafile_clear_iflag(
 	ip->i_diflags2 &= ~XFS_DIFLAG2_METADATA;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/*
+ * Is the amount of space that could be allocated towards a given metadata
+ * file at or beneath a certain threshold?
+ */
+static inline bool
+xfs_metafile_resv_can_cover(
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
+xfs_metafile_resv_critical(
+	struct xfs_inode	*ip)
+{
+	uint64_t		asked_low_water;
+
+	if (!ip)
+		return false;
+
+	ASSERT(xfs_is_metadir_inode(ip));
+	trace_xfs_metafile_resv_critical(ip, 0);
+
+	if (!xfs_metafile_resv_can_cover(ip, ip->i_mount->m_rtbtree_maxlevels))
+		return true;
+
+	asked_low_water = div_u64(ip->i_meta_resv_asked, 10);
+	if (!xfs_metafile_resv_can_cover(ip, asked_low_water))
+		return true;
+
+	return XFS_TEST_ERROR(false, ip->i_mount,
+			XFS_ERRTAG_METAFILE_RESV_CRITICAL);
+}
+
+/* Allocate a block from the metadata file's reservation. */
+void
+xfs_metafile_resv_alloc_space(
+	struct xfs_inode	*ip,
+	struct xfs_alloc_arg	*args)
+{
+	int64_t			len = args->len;
+
+	ASSERT(xfs_is_metadir_inode(ip));
+	ASSERT(args->resv == XFS_AG_RESV_METAFILE);
+
+	trace_xfs_metafile_resv_alloc_space(ip, args->len);
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
+		xfs_mod_delalloc(ip, 0, -from_resv);
+		xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS,
+				-from_resv);
+		len -= from_resv;
+	}
+
+	/*
+	 * Any allocation in excess of the reservation requires in-core and
+	 * on-disk fdblocks updates.  If we can grab @len blocks from the
+	 * in-core fdblocks then all we need to do is update the on-disk
+	 * superblock; if not, then try to steal some from the transaction's
+	 * block reservation.  Overruns are only expected for rmap btrees.
+	 */
+	if (len) {
+		unsigned int	field;
+		int		error;
+
+		error = xfs_dec_fdblocks(ip->i_mount, len, true);
+		if (error)
+			field = XFS_TRANS_SB_FDBLOCKS;
+		else
+			field = XFS_TRANS_SB_RES_FDBLOCKS;
+
+		xfs_trans_mod_sb(args->tp, field, -len);
+	}
+
+	ip->i_nblocks += args->len;
+	xfs_trans_log_inode(args->tp, ip, XFS_ILOG_CORE);
+}
+
+/* Free a block to the metadata file's reservation. */
+void
+xfs_metafile_resv_free_space(
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	xfs_filblks_t		len)
+{
+	int64_t			to_resv;
+
+	ASSERT(xfs_is_metadir_inode(ip));
+	trace_xfs_metafile_resv_free_space(ip, len);
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
+		xfs_mod_delalloc(ip, 0, to_resv);
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
+xfs_metafile_resv_free(
+	struct xfs_inode	*ip)
+{
+	/* Non-btree metadata inodes don't need space reservations. */
+	if (!ip || !ip->i_meta_resv_asked)
+		return;
+
+	ASSERT(xfs_is_metadir_inode(ip));
+	trace_xfs_metafile_resv_free(ip, 0);
+
+	if (ip->i_delayed_blks) {
+		xfs_mod_delalloc(ip, 0, -ip->i_delayed_blks);
+		xfs_add_fdblocks(ip->i_mount, ip->i_delayed_blks);
+		ip->i_delayed_blks = 0;
+	}
+	ip->i_meta_resv_asked = 0;
+}
+
+/* Set up a metadata file's space reservation. */
+int
+xfs_metafile_resv_init(
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
+	error = xfs_dec_fdblocks(ip->i_mount, hidden_space, true);
+	if (error) {
+		trace_xfs_metafile_resv_init_error(ip, error, _RET_IP_);
+		return error;
+	}
+
+	xfs_mod_delalloc(ip, 0, hidden_space);
+	ip->i_delayed_blks = hidden_space;
+	ip->i_meta_resv_asked = ask;
+
+	trace_xfs_metafile_resv_init(ip, ask);
+	return 0;
+}
diff --git a/libxfs/xfs_metafile.h b/libxfs/xfs_metafile.h
index acec400123db05..8d8f08a6071c23 100644
--- a/libxfs/xfs_metafile.h
+++ b/libxfs/xfs_metafile.h
@@ -21,6 +21,17 @@ void xfs_metafile_set_iflag(struct xfs_trans *tp, struct xfs_inode *ip,
 		enum xfs_metafile_type metafile_type);
 void xfs_metafile_clear_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
 
+/* Space reservations for metadata inodes. */
+struct xfs_alloc_arg;
+
+bool xfs_metafile_resv_critical(struct xfs_inode *ip);
+void xfs_metafile_resv_alloc_space(struct xfs_inode *ip,
+		struct xfs_alloc_arg *args);
+void xfs_metafile_resv_free_space(struct xfs_inode *ip, struct xfs_trans *tp,
+		xfs_filblks_t len);
+void xfs_metafile_resv_free(struct xfs_inode *ip);
+int xfs_metafile_resv_init(struct xfs_inode *ip, xfs_filblks_t ask);
+
 /* Code specific to kernel/userspace; must be provided externally. */
 
 int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index bf33c2b1e43e5f..ca2401c1facda7 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -202,6 +202,13 @@ enum xfs_ag_resv_type {
 	 * altering fdblocks.  If you think you need this you're wrong.
 	 */
 	XFS_AG_RESV_IGNORE,
+
+	/*
+	 * This allocation activity is being done on behalf of a metadata file.
+	 * These files maintain their own permanent space reservations and are
+	 * required to adjust fdblocks using the xfs_metafile_resv_* helpers.
+	 */
+	XFS_AG_RESV_METAFILE,
 };
 
 /* Results of scanning a btree keyspace to check occupancy. */

