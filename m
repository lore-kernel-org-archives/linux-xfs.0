Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51B931D743
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087800; cv=none; b=RRxfjK0W8ZTAr6Zw4MbajAGrelTzDtlMctROVDLCSHUgy11DZ0RyW4zcDLsFCyOb208IhjreAPU3RBvGJ5X3ZnnXJqdNt0XcSPmQz7x8r2KNuXDOvIHwNjEVZi44yRFGc3PH6rm3RqTh1KTseNcAbYLwRZzBcsw4oVT74zEltMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087800; c=relaxed/simple;
	bh=pFtmnkQifZ5bnFyPN15sLYMr4TEUtLtUoHul7sVxfG4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSJigM9VyEesCtyBVA2iJivFXXVok8ASOgUIw+20l9tgrJ9QEO6Hw8WC4cyT/e/MmETyO7/nJ/QNz/ifRGCbl8AapIYdNdAJ2ei6KTKQ87E5MZloA4/eGqMSMLWLW9IG4htI+CmZEX/g+afWoVk5+APgLs3aTXoXbvJa9bHQUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5Ad8NKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5Ad8NKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4203C4CEF1;
	Fri,  5 Sep 2025 15:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087800;
	bh=pFtmnkQifZ5bnFyPN15sLYMr4TEUtLtUoHul7sVxfG4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F5Ad8NKSAI0xnmBd2nqeG1YKiQXu3SnVOOHqYvseGfoZN224Q6s7Uq5xAPOKm6tli
	 fO7sCU5EeiiMQo9t/L+3YWgabvCftvlSsNOZtKiMEtogrJG3RvFu3GuShI2/cKLjvx
	 aR5z4hAFUChBGJ/1rf5fSxi1+Ax5XN4fLbHdr4xrUCzo9uZJrx9e+BZ/p1+0X04Z0A
	 EqFLoyecSfyOBiGJN+RrBQ9Kan1vlHNT+/6IPWM3MR34MeP+snzZDFJWitWmlU3NNo
	 JPKrc4iEgNI+5+1/SM0GLVI7WQoaztvBg2Fwiprr09iEjE2REmUF2e3eCu1hdwAkqu
	 Rxt/wKJcHj1hQ==
Date: Fri, 05 Sep 2025 08:56:40 -0700
Subject: [PATCH 5/9] xfs: compute data device CoW staging extent reap limits
 dynamically
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <175708765163.3402543.14486245509336114779.stgit@frogsfrogsfrogs>
In-Reply-To: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
References: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

