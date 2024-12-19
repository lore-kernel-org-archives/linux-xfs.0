Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704C1AA7BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636204; cv=none; b=pjgLiXGyfixRvkGRdCe7ApYT5uh4s+CTk8a5i0WBMtBF8XniNzQX5RV04O6KxfX6rMoc668BM+4cQ/Yk0GgZ9SsDCjmd3EYelnFOd48VqPIjRaPxquA7lphB/ubdBccMfaXpcr9+C0fmRd6ZB89D7r+1etkdGJnMu9j+eJN5fWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636204; c=relaxed/simple;
	bh=I3xFsUMeSyI0cMBrYIdr+hfgzDEdLxDKmwvVvo/9SVw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l0lO9x6nO9y10x6fF50/qngSADQq2fTKHbMV9yCI1salmmUUETZJ3XuVOXWq5ThpdQPMAl8whylqkoW/6s9qZSrmBzf5FxdFaY1cnxIhMihETXj625wMBi/FrpAsPeqmhFp4ggTVS62y9B/m7r5VtsJF1qhz5ybAizht4+fDjsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oo8LQSOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oo8LQSOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6756CC4CECE;
	Thu, 19 Dec 2024 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636204;
	bh=I3xFsUMeSyI0cMBrYIdr+hfgzDEdLxDKmwvVvo/9SVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Oo8LQSOobbg6FtRVjaO7N3Utx+c5VAbjSY7ySF+FDBhbHKkd6vr7211dOBFrDmCEr
	 SJNakFbtPD5revE2FTIa/vcZ5HqwJo6ReiyZffS+RmIa92GJlpnAKQB0YtFil6jrgz
	 iKQzMPmeZxgrjNtl4FcHvyo818X5MUuPSKL8lXm+mQVthkKolb1Hx4JR6U2+Qybx/G
	 5gHjkMm8VT2Su3U3dHoLgc+Up7QrsQyrld0Q4c/mUiYCxDDs2/d8mKoknInBUCd3Cj
	 ZX3bCCdX1gNCnS6pl/ixLTutUrhv/4cRRiBMdMYCFPvaLhlPsgmI3bSQmUtAAmo16a
	 qRN4XblM5aRTQ==
Date: Thu, 19 Dec 2024 11:23:23 -0800
Subject: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in the
 data device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579201.1571383.11917455509404722918.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579158.1571383.10600787559817251215.stgit@frogsfrogsfrogs>
References: <173463579158.1571383.10600787559817251215.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_ag_resv.c  |    3 +
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_metadir.c  |    4 +
 fs/xfs/libxfs/xfs_metafile.c |  205 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_metafile.h |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 +
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_fsops.c           |   17 +++
 fs/xfs/xfs_inode.h           |    6 +
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_rtalloc.c         |   21 ++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_trace.h           |   45 +++++++++
 14 files changed, 341 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index f5d853089019f0..fb79215a509d21 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -114,6 +114,7 @@ xfs_ag_resv_needed(
 	case XFS_AG_RESV_RMAPBT:
 		len -= xfs_perag_resv(pag, type)->ar_reserved;
 		break;
+	case XFS_AG_RESV_METAFILE:
 	case XFS_AG_RESV_NONE:
 		/* empty */
 		break;
@@ -347,6 +348,7 @@ xfs_ag_resv_alloc_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_METAFILE:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
@@ -389,6 +391,7 @@ xfs_ag_resv_free_extent(
 
 	switch (type) {
 	case XFS_AG_RESV_AGFL:
+	case XFS_AG_RESV_METAFILE:
 		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 7002d7676a7884..a53c5d40e084dc 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
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
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index bae7377c0f228c..178e89711cb7c6 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -29,6 +29,10 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_parent.h"
 #include "xfs_health.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
+#include "xfs_btree.h"
+#include "xfs_alloc.h"
 
 /*
  * Metadata Directory Tree
diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index adeb25d1a444ca..e151663cc9efd6 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -17,6 +17,10 @@
 #include "xfs_metafile.h"
 #include "xfs_trace.h"
 #include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
+#include "xfs_alloc.h"
 
 /* Set up an inode to be recognized as a metadata directory inode. */
 void
@@ -50,3 +54,204 @@ xfs_metafile_clear_iflag(
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
diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index acec400123db05..8d8f08a6071c23 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index bf33c2b1e43e5f..ca2401c1facda7 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 78cdc5064a8c47..dbd87e1376943a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -63,6 +63,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_WB_DELAY_MS,
 	XFS_RANDOM_WRITE_DELAY_MS,
 	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
+	XFS_RANDOM_METAFILE_RESV_CRITICAL,
 };
 
 struct xfs_errortag_attr {
@@ -181,6 +182,7 @@ XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
+XFS_ERRORTAG_ATTR_RW(metafile_resv_crit, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -227,6 +229,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(wb_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
+	XFS_ERRORTAG_ATTR_LIST(metafile_resv_crit),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 28dde215c89953..e1145107d8cbd1 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -21,6 +21,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
+#include "xfs_rtalloc.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -541,6 +542,19 @@ xfs_fs_reserve_ag_blocks(
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
@@ -555,6 +569,9 @@ xfs_fs_unreserve_ag_blocks(
 {
 	struct xfs_perag	*pag = NULL;
 
+	if (xfs_has_realtime(mp))
+		xfs_rt_resv_free(mp);
+
 	while ((pag = xfs_perag_next(mp, pag)))
 		xfs_ag_resv_free(pag);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1141c2e8e123ae..c08093a65352ec 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -31,6 +31,12 @@ typedef struct xfs_inode {
 			struct xfs_dquot *i_gdquot;	/* group dquot */
 			struct xfs_dquot *i_pdquot;	/* project dquot */
 		};
+
+		/*
+		 * Space that has been set aside to accomodate expansions of a
+		 * metadata btree rooted in this file.
+		 */
+		uint64_t	i_meta_resv_asked;
 	};
 
 	/* Inode location stuff */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5918f433dba754..97137126b16f5a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -650,6 +650,15 @@ xfs_agbtree_compute_maxlevels(
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
index db9dade7d22a19..ddb9d19a3a3d53 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -165,6 +165,7 @@ typedef struct xfs_mount {
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
+	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fcfa6e0eb3ad2a..5128c5ad72f5da 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1344,6 +1344,12 @@ xfs_growfs_rt(
 
 		if (!error)
 			error = error2;
+
+		/* Reset the rt metadata btree space reservations. */
+		xfs_rt_resv_free(mp);
+		error2 = xfs_rt_resv_init(mp);
+		if (error2 && error2 != -ENOSPC)
+			error = error2;
 	}
 
 out_unlock:
@@ -1487,6 +1493,21 @@ xfs_rtalloc_reinit_frextents(
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
 /*
  * Read in the bmbt of an rt metadata inode so that we never have to load them
  * at runtime.  This enables the use of shared ILOCKs for rtbitmap scans.  Use
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 8e2a07b8174b74..d87523e6a55006 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -34,6 +34,9 @@ int					/* error */
 xfs_rtmount_inodes(
 	struct xfs_mount	*mp);	/* file system mount structure */
 
+void xfs_rt_resv_free(struct xfs_mount *mp);
+int xfs_rt_resv_init(struct xfs_mount *mp);
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -60,6 +63,8 @@ xfs_rtmount_init(
 }
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
 # define xfs_rtunmount_inodes(m)
+# define xfs_rt_resv_free(mp)				((void)0)
+# define xfs_rt_resv_init(mp)				(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7b16cdd72e9ddd..cbda663fe6e817 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5574,6 +5574,51 @@ DEFINE_EVENT(xfs_metadir_class, name, \
 	TP_ARGS(dp, name, ino))
 DEFINE_METADIR_EVENT(xfs_metadir_lookup);
 
+/* metadata inode space reservations */
+
+DECLARE_EVENT_CLASS(xfs_metafile_resv_class,
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
+#define DEFINE_METAFILE_RESV_EVENT(name) \
+DEFINE_EVENT(xfs_metafile_resv_class, name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_filblks_t len), \
+	TP_ARGS(ip, len))
+DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_init);
+DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_free);
+DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_alloc_space);
+DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_free_space);
+DEFINE_METAFILE_RESV_EVENT(xfs_metafile_resv_critical);
+DEFINE_INODE_ERROR_EVENT(xfs_metafile_resv_init_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

