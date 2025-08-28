Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349D6225403
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391351; cv=none; b=kU3RULWDx451qfrBP3M3t/dOa/dhvrCe1Altc7DHhTKYVLurbqZBEY4CQGnRZCPn3Jma0XzWwXj3PZqSSm2CVVRFiPcmPdwcTNWGqNJCVYxTisFvZQIqaXH5F4/6MjnEV7O/vUpgs1OMB/Dv2OXC89WrGrX+sTVOfoU4iAYVZhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391351; c=relaxed/simple;
	bh=U5tYCKjr2B0gVOX7ETkgECUJ5ZpxOD8d0TDF3a5wpe8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UHSU6yVqGQOfJDjlkm36zkj6LNTwS7UOCHJfqFF5qt7NYa4R8sLrftcWKkmeUBoaegT+42RlqKERzKFvwl/4NNbsAJGl7UFDBaStVOMMcFE8/1RBzOvcCOp/VMlZMTQVL64e/QbIrfYAY0L01osvlsO1tGsDHXKS4MdrJbUWxAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9KIIfuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9KIIfuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D72DC4CEEB;
	Thu, 28 Aug 2025 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391351;
	bh=U5tYCKjr2B0gVOX7ETkgECUJ5ZpxOD8d0TDF3a5wpe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c9KIIfuhDHok85X8yrEZ7igumnrA5bGmUAPMviwTpT/HqsHVkNs+FWF5aHu9JxkTT
	 ZnUFP/liAE83FyqhvHIiMv0NbMpsT596rbj/8OYTDn01Re3YnXVzewm26cE7FRcQNR
	 Ktrs3fjrg+hkfgW8k98vSYe9pqVtrZOLI6lzC5pij+EQPlCwkDQnPdewoyuU07gyRU
	 Tv9xYOpXT44WjxPVs7l/7xZVMFLFvT+Hu7XItVTjd3I2t2RnKXe7PtFZosINqJO32p
	 rKhztZqxB74RlsTFdkBcbevpvt2B5QHq7nFqmnZT3lEDSghC2QRLJ12ctnkodYUws7
	 bfj5u/5xmauYw==
Date: Thu, 28 Aug 2025 07:29:10 -0700
Subject: [PATCH 5/9] xfs: compute data device CoW staging extent reap limits
 dynamically
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126543.761138.12043696058302651120.stgit@frogsfrogsfrogs>
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

Calculate the maximum number of CoW staging extents that can be reaped
in a single transaction chain.  The rough calculation here is:

nr_extents = (logres - reservation used by any one step) /
		(space used by intents per extent +
		 space used for a few buffer invalidations)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    1 +
 fs/xfs/scrub/reap.c  |   88 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 84 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d39da0e67024fb..a9da22f50534cb 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2041,6 +2041,7 @@ DEFINE_EVENT(xrep_reap_limits_class, name, \
 		 unsigned int max_deferred), \
 	TP_ARGS(tp, per_binval, max_binval, step_size, per_intent, max_deferred))
 DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_agextent_limits);
+DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_agcow_limits);
 
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 929ea3c453d313..aaef7e6771a045 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -443,7 +443,7 @@ xreap_agextent_iter(
 
 		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
 			/*
-			 * If we're unmapping CoW staging extents, remove the
+			 * t0: Unmapping CoW staging extents, remove the
 			 * records from the refcountbt, which will remove the
 			 * rmap record as well.
 			 */
@@ -475,7 +475,7 @@ xreap_agextent_iter(
 	}
 
 	/*
-	 * If we're getting rid of CoW staging extents, use deferred work items
+	 * t2: To get rid of CoW staging extents, use deferred work items
 	 * to remove the refcountbt records (which removes the rmap records)
 	 * and free the extent.  We're not worried about the system going down
 	 * here because log recovery walks the refcount btree to clean out the
@@ -626,6 +626,84 @@ xreap_configure_agextent_limits(
 			step_size, per_intent, rs->max_deferred);
 }
 
+/*
+ * Compute the maximum number of intent items that reaping can attach to the
+ * scrub transaction given the worst case log overhead of the intent items
+ * needed to reap a single CoW staging extent.  This is not for freeing
+ * metadata blocks.
+ */
+STATIC void
+xreap_configure_agcow_limits(
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
+	const unsigned int	cui = xfs_cui_log_space(1) +
+				      xfs_cud_log_space();
+
+	/*
+	 * Various things can happen when reaping non-CoW metadata blocks:
+	 *
+	 * t0: Unmapping crosslinked CoW blocks: deferred removal of refcount
+	 * record, which defers removal of rmap record
+	 *
+	 * t2: Freeing CoW blocks: deferred removal of refcount record, which
+	 * defers removal of rmap record; and deferred removal of the space
+	 *
+	 * For simplicity, we'll use the worst-case intents size to determine
+	 * the maximum number of deferred extents before we have to finish the
+	 * whole chain.  If we're trying to reap a btree larger than this size,
+	 * a crash midway through reaping can result in leaked blocks.
+	 */
+	const unsigned int	t0 = cui + rui;
+	const unsigned int	t2 = cui + rui + efi;
+	const unsigned int	per_intent = max(t0, t2);
+
+	/*
+	 * For each transaction in a reap chain, we must be able to take one
+	 * step in the defer item chain, which should only consist of CUI, EFI,
+	 * or RUI items.
+	 */
+	const unsigned int	f1 = xfs_calc_finish_efi_reservation(mp, 1);
+	const unsigned int	f2 = xfs_calc_finish_rui_reservation(mp, 1);
+	const unsigned int	f3 = xfs_calc_finish_cui_reservation(mp, 1);
+	const unsigned int	step_size = max3(f1, f2, f3);
+
+	/* Largest buffer size (in fsblocks) that can be invalidated. */
+	const unsigned int	max_binval = xrep_binval_max_fsblocks(mp);
+
+	/* Overhead of invalidating one buffer */
+	const unsigned int	per_binval =
+		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+
+	/*
+	 * For each transaction in a reap chain, we can delete some number of
+	 * extents and invalidate some number of blocks.  We assume that CoW
+	 * staging extents are usually more than 1 fsblock, and that there
+	 * shouldn't be any buffers for those blocks.  From the assumptions,
+	 * set the number of deferrals to use as much of the reservation as
+	 * it can, but leave space to invalidate 1/8th that number of buffers.
+	 */
+	const unsigned int	variable_overhead = per_intent +
+							(per_binval / 8);
+
+	xreap_configure_limits(rs, step_size, variable_overhead, per_intent,
+			per_binval);
+
+	trace_xreap_agcow_limits(sc->tp, per_binval, rs->max_binval, step_size,
+			per_intent, rs->max_deferred);
+}
+
 /*
  * Break an AG metadata extent into sub-extents by fate (crosslinked, not
  * crosslinked), and dispose of each sub-extent separately.
@@ -800,15 +878,15 @@ xrep_reap_fsblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= XFS_AG_RESV_NONE,
-		.max_binval		= XREAP_MAX_BINVAL,
-		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
 	ASSERT(xfs_has_rmapbt(sc->mp));
 	ASSERT(sc->ip != NULL);
 
-	if (oinfo != &XFS_RMAP_OINFO_COW)
+	if (oinfo == &XFS_RMAP_OINFO_COW)
+		xreap_configure_agcow_limits(&rs);
+	else
 		xreap_configure_agextent_limits(&rs);
 	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
 	if (error)

