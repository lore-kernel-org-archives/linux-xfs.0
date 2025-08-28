Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A2722D7B5
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391335; cv=none; b=TOAsfOGLs/Aty9AooCeBl0pXpGn6K0RlpQabLxSTfGIibKMkEAatZhSXf5uP2sD3uPtujDoABjYq/G6tIxfHaWFE4jNc5VPGgfnJSnXKIzrAxU5WmB9PW/vWm07ZM6My/mcvufKyPiYb8ZbeOdJbJFx91hC5eg7a9RtZZHARrRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391335; c=relaxed/simple;
	bh=1UqxO7YC853iekUMQOl85N2ejnJQsUuI/KDn1Qz02DQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OweqFK5xSkC8M9p9TXfOwbISXK1Uyy/eO1KZxhuw1Nv2rw68GGZ8f/KVO7w41x7x2sGPJGKQ7++27jehG6sh5K0ECbTy0Jt6oPFuxEwJhn6TKMngG0VUVV8jlgWULSJQleUkeJIEznZDHDxOcaWFGVoYwVq4sOYSVZcBFzPHHoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DIzihBk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DIzihBk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF9CC4CEEB;
	Thu, 28 Aug 2025 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391335;
	bh=1UqxO7YC853iekUMQOl85N2ejnJQsUuI/KDn1Qz02DQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DIzihBk/7EKq6Vjpr+O+mvJO7QtkoXTdYtgUi+RUKq2/ph/XeDougODPEMcgYVYKy
	 Rq7rPV4Wq5P4E1h70LQMTWCgaPEt3mxNtO2RB4eEtmo4w150Vub2k1FNwC7MJc4aT0
	 RHBG3so+FHvAGbLkxlpWqza+OuCzEkwG3gpDFVv9d1aUjuSzsxIaGKeA2RrfK6iDGT
	 aEIrGHyHEkHVq4HIbximeIfFUxp+b86lrw/r/LOhtQWKV08B+n9hIuASdS2uUD+0kU
	 qWiqOm4Jq7SMJZe516LLZ38zivG+5h0SWtQpMKKYC6HH274fkqgc4NxhqFGqFFUA8J
	 hYulINmSVvF+A==
Date: Thu, 28 Aug 2025 07:28:54 -0700
Subject: [PATCH 4/9] xfs: compute per-AG extent reap limits dynamically
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126522.761138.15571172483898795822.stgit@frogsfrogsfrogs>
In-Reply-To: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Calculate the maximum number of extents that can be reaped in a single
transaction chain, and the number of buffers that can be invalidated in
a single transaction.  The rough calculation here is:

nr_extents = (logres - reservation used by any one step) /
		(space used by intents per extent +
		 space used per binval)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   42 +++++++++++++++
 fs/xfs/scrub/reap.c  |  140 ++++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/trace.c |    1 
 3 files changed, 171 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a8187281eb96b9..d39da0e67024fb 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2000,6 +2000,48 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
+DECLARE_EVENT_CLASS(xrep_reap_limits_class,
+	TP_PROTO(const struct xfs_trans *tp, unsigned int per_binval,
+		 unsigned int max_binval, unsigned int step_size,
+		 unsigned int per_intent,
+		 unsigned int max_deferred),
+	TP_ARGS(tp, per_binval, max_binval, step_size, per_intent, max_deferred),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, log_res)
+		__field(unsigned int, per_binval)
+		__field(unsigned int, max_binval)
+		__field(unsigned int, step_size)
+		__field(unsigned int, per_intent)
+		__field(unsigned int, max_deferred)
+	),
+	TP_fast_assign(
+		__entry->dev = tp->t_mountp->m_super->s_dev;
+		__entry->log_res = tp->t_log_res;
+		__entry->per_binval = per_binval;
+		__entry->max_binval = max_binval;
+		__entry->step_size = step_size;
+		__entry->per_intent = per_intent;
+		__entry->max_deferred = max_deferred;
+	),
+	TP_printk("dev %d:%d logres %u per_binval %u max_binval %u step_size %u per_intent %u max_deferred %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->log_res,
+		  __entry->per_binval,
+		  __entry->max_binval,
+		  __entry->step_size,
+		  __entry->per_intent,
+		  __entry->max_deferred)
+);
+#define DEFINE_REPAIR_REAP_LIMITS_EVENT(name) \
+DEFINE_EVENT(xrep_reap_limits_class, name, \
+	TP_PROTO(const struct xfs_trans *tp, unsigned int per_binval, \
+		 unsigned int max_binval, unsigned int step_size, \
+		 unsigned int per_intent, \
+		 unsigned int max_deferred), \
+	TP_ARGS(tp, per_binval, max_binval, step_size, per_intent, max_deferred))
+DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_agextent_limits);
+
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len, bool crosslinked),
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 33272729249f64..929ea3c453d313 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -36,6 +36,12 @@
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_extfree_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
+#include "xfs_buf_item.h"
+#include "xfs_bmap_item.h"
+#include "xfs_bmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -230,6 +236,15 @@ static inline void xreap_force_defer_finish(struct xreap_state *rs)
 	rs->nr_deferred = rs->max_deferred;
 }
 
+/* Maximum number of fsblocks that we might find in a buffer to invalidate. */
+static inline unsigned int
+xrep_binval_max_fsblocks(
+	struct xfs_mount	*mp)
+{
+	/* Remote xattr values are the largest buffers that we support. */
+	return xfs_attr3_max_rmt_blocks(mp);
+}
+
 /*
  * Compute the maximum length of a buffer cache scan (in units of sectors),
  * given a quantity of fs blocks.
@@ -239,12 +254,8 @@ xrep_bufscan_max_sectors(
 	struct xfs_mount	*mp,
 	xfs_extlen_t		fsblocks)
 {
-	int			max_fsbs;
-
-	/* Remote xattr values are the largest buffers that we support. */
-	max_fsbs = xfs_attr3_max_rmt_blocks(mp);
-
-	return XFS_FSB_TO_BB(mp, min_t(xfs_extlen_t, fsblocks, max_fsbs));
+	return XFS_FSB_TO_BB(mp, min_t(xfs_extlen_t, fsblocks,
+				       xrep_binval_max_fsblocks(mp)));
 }
 
 /*
@@ -442,6 +453,7 @@ xreap_agextent_iter(
 			return 0;
 		}
 
+		/* t1: unmap crosslinked metadata blocks */
 		xfs_rmap_free_extent(sc->tp, false, fsbno, *aglenp,
 				rs->oinfo->oi_owner);
 		xreap_inc_defer(rs);
@@ -482,7 +494,7 @@ xreap_agextent_iter(
 		return 0;
 	}
 
-	/* Put blocks back on the AGFL one at a time. */
+	/* t3: Put blocks back on the AGFL one at a time. */
 	if (rs->resv == XFS_AG_RESV_AGFL) {
 		ASSERT(*aglenp == 1);
 		error = xreap_put_freelist(sc, agbno);
@@ -494,7 +506,7 @@ xreap_agextent_iter(
 	}
 
 	/*
-	 * Use deferred frees to get rid of the old btree blocks to try to
+	 * t4: Use deferred frees to get rid of the old btree blocks to try to
 	 * minimize the window in which we could crash and lose the old blocks.
 	 * Add a defer ops barrier every other extent to avoid stressing the
 	 * system with large EFIs.
@@ -510,6 +522,110 @@ xreap_agextent_iter(
 	return 0;
 }
 
+/* Configure the deferral and invalidation limits */
+static inline void
+xreap_configure_limits(
+	struct xreap_state	*rs,
+	unsigned int		fixed_overhead,
+	unsigned int		variable_overhead,
+	unsigned int		per_intent,
+	unsigned int		per_binval)
+{
+	struct xfs_scrub	*sc = rs->sc;
+	unsigned int		res = sc->tp->t_log_res - fixed_overhead;
+
+	/* Don't underflow the reservation */
+	if (sc->tp->t_log_res < (fixed_overhead + variable_overhead)) {
+		ASSERT(sc->tp->t_log_res >=
+				(fixed_overhead + variable_overhead));
+		xfs_force_shutdown(sc->mp, SHUTDOWN_CORRUPT_INCORE);
+		return;
+	}
+
+	rs->max_deferred = res / variable_overhead;
+	res -= rs->max_deferred * per_intent;
+	rs->max_binval = per_binval ? res / per_binval : 0;
+}
+
+/*
+ * Compute the maximum number of intent items that reaping can attach to the
+ * scrub transaction given the worst case log overhead of the intent items
+ * needed to reap a single per-AG space extent.  This is not for freeing CoW
+ * staging extents.
+ */
+STATIC void
+xreap_configure_agextent_limits(
+	struct xreap_state	*rs)
+{
+	struct xfs_scrub	*sc = rs->sc;
+	struct xfs_mount	*mp = sc->mp;
+
+	/*
+	 * In the worst case, relogging an intent item causes both an intent
+	 * item and a done item to be attached to a transaction for each extent
+	 * that we'd like to process.
+	 */
+	const unsigned int	efi = xfs_efi_log_space(1) +
+				      xfs_efd_log_space(1);
+	const unsigned int	rui = xfs_rui_log_space(1) +
+				      xfs_rud_log_space();
+
+	/*
+	 * Various things can happen when reaping non-CoW metadata blocks:
+	 *
+	 * t1: Unmapping crosslinked metadata blocks: deferred removal of rmap
+	 * record.
+	 *
+	 * t3: Freeing to AGFL: roll and finish deferred items for every block.
+	 * Limits here do not matter.
+	 *
+	 * t4: Freeing metadata blocks: deferred freeing of the space, which
+	 * also removes the rmap record.
+	 *
+	 * For simplicity, we'll use the worst-case intents size to determine
+	 * the maximum number of deferred extents before we have to finish the
+	 * whole chain.  If we're trying to reap a btree larger than this size,
+	 * a crash midway through reaping can result in leaked blocks.
+	 */
+	const unsigned int	t1 = rui;
+	const unsigned int	t4 = rui + efi;
+	const unsigned int	per_intent = max(t1, t4);
+
+	/*
+	 * For each transaction in a reap chain, we must be able to take one
+	 * step in the defer item chain, which should only consist of EFI or
+	 * RUI items.
+	 */
+	const unsigned int	f1 = xfs_calc_finish_efi_reservation(mp, 1);
+	const unsigned int	f2 = xfs_calc_finish_rui_reservation(mp, 1);
+	const unsigned int	step_size = max(f1, f2);
+
+	/* Largest buffer size (in fsblocks) that can be invalidated. */
+	const unsigned int	max_binval = xrep_binval_max_fsblocks(mp);
+
+	/* Maximum overhead of invalidating one buffer. */
+	const unsigned int	per_binval =
+		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+
+	/*
+	 * For each transaction in a reap chain, we can delete some number of
+	 * extents and invalidate some number of blocks.  We assume that btree
+	 * blocks aren't usually contiguous; and that scrub likely pulled all
+	 * the buffers into memory.  From these assumptions, set the maximum
+	 * number of deferrals we can queue before flushing the defer chain,
+	 * and the number of invalidations we can queue before rolling to a
+	 * clean transaction (and possibly relogging some of the deferrals) to
+	 * the same quantity.
+	 */
+	const unsigned int	variable_overhead = per_intent + per_binval;
+
+	xreap_configure_limits(rs, step_size, variable_overhead, per_intent,
+			per_binval);
+
+	trace_xreap_agextent_limits(sc->tp, per_binval, rs->max_binval,
+			step_size, per_intent, rs->max_deferred);
+}
+
 /*
  * Break an AG metadata extent into sub-extents by fate (crosslinked, not
  * crosslinked), and dispose of each sub-extent separately.
@@ -571,14 +687,13 @@ xrep_reap_agblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= type,
-		.max_binval		= XREAP_MAX_BINVAL,
-		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
 	ASSERT(xfs_has_rmapbt(sc->mp));
 	ASSERT(sc->ip == NULL);
 
+	xreap_configure_agextent_limits(&rs);
 	error = xagb_bitmap_walk(bitmap, xreap_agmeta_extent, &rs);
 	if (error)
 		return error;
@@ -693,6 +808,8 @@ xrep_reap_fsblocks(
 	ASSERT(xfs_has_rmapbt(sc->mp));
 	ASSERT(sc->ip != NULL);
 
+	if (oinfo != &XFS_RMAP_OINFO_COW)
+		xreap_configure_agextent_limits(&rs);
 	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
 	if (error)
 		return error;
@@ -943,8 +1060,6 @@ xrep_reap_metadir_fsblocks(
 		.sc			= sc,
 		.oinfo			= &oinfo,
 		.resv			= XFS_AG_RESV_NONE,
-		.max_binval		= XREAP_MAX_BINVAL,
-		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
@@ -952,6 +1067,7 @@ xrep_reap_metadir_fsblocks(
 	ASSERT(sc->ip != NULL);
 	ASSERT(xfs_is_metadir_inode(sc->ip));
 
+	xreap_configure_agextent_limits(&rs);
 	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
 	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
 	if (error)
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 2450e214103fed..987313a52e6401 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -22,6 +22,7 @@
 #include "xfs_parent.h"
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
+#include "xfs_trans.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"

