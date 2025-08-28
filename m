Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918E021CA02
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391288; cv=none; b=IJ8OXrssU0dGeLgtpUFRdUUmT9PSzB9XbPcIdziUYKOnC/BOZnsoYGGHGuo0WdwHfPAAPoxa2oN9iUwVZE9gH4HqZgCvwHy8KVKOIJzgFs2fo3FCWcYgJjyY6W7ArVeg7oM4pv2z2ffSF+oAbwt7UCLagcsnEe/X2aHD78rUqMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391288; c=relaxed/simple;
	bh=FvBLbPiazb8KXzq+FPjkp2k3HwxQOt3SlBSZAprB2Ms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RqQPDOVXPFkd94oAEK47Im/r/aTCjqWUphV5jrQWvU/Hh0BzcsWcEeK+c940PFoAiXSV3jVMltQF2IyusnSrSYkeB+ddFBBU8N1JhZms23v8XX7wNBSTWd6gjlUPpdW8o6Oy8GxOiJnVK92hhMPBPnr4BxIf2la20JRMjxmOYxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXHpR6Q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXHpR6Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DF7C4CEEB;
	Thu, 28 Aug 2025 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391288;
	bh=FvBLbPiazb8KXzq+FPjkp2k3HwxQOt3SlBSZAprB2Ms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MXHpR6Q54DsUKwru+wzWviCMVqzfTJNUFM9ep4Dgs3vaCrQD/8MV/3hN1G0Rh/jJj
	 mPmkwoRRKUafXfWMxwsAZFCAfTaMQ1q/krvm/C03wZRwvdfkgrXIoawQ7M80GCzlM8
	 pD+rhNb2uQd3ecbeonoNAY5ge38EvW4gD2LqnYZ0q+l2Sn4KNFoZcDk+d4QowKLE7Q
	 dsBxg84bBTNOR/ijgxcM7CcHXfX+lUPzQd9DgCw85zhhyySfhlIJwGpBJnYymTtfgn
	 WLXGpEq3O4QK1g5xXHd24fdtTQWUSKKAey0vmqyQxTNQzfW45hzU0E65aAHxSLtjv8
	 /SPkgDUly/iVg==
Date: Thu, 28 Aug 2025 07:28:07 -0700
Subject: [PATCH 1/9] xfs: prepare reaping code for dynamic limits
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126461.761138.5633907133608492664.stgit@frogsfrogsfrogs>
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

The online repair block reaping code employs static limits to decide if
it's time to roll the transaction or finish the deferred item chains to
avoid overflowing the scrub transaction's reservation.  However, the
use of static limits aren't great -- btree blocks are assumed to be
scattered around the AG and the buffers need to be invalidated, whereas
COW staging extents are usually contiguous and do not have buffers.  We
would like to configure the limits dynamically.

To get ready for this, reorganize struct xreap_state to store dynamic
limits, and add helpers to hide some of the details of how the limits
are enforced.  Also rename the "xreap roll" functions to include the
word "binval" because they only exist to decide when we should roll the
transaction to deal with buffer invalidations.

No functional changes intended here.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |  149 +++++++++++++++++++++++++++------------------------
 1 file changed, 79 insertions(+), 70 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 8703897c0a9ccb..7877ef427990eb 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -95,17 +95,17 @@ struct xreap_state {
 	const struct xfs_owner_info	*oinfo;
 	enum xfs_ag_resv_type		resv;
 
-	/* If true, roll the transaction before reaping the next extent. */
-	bool				force_roll;
-
-	/* Number of deferred reaps attached to the current transaction. */
-	unsigned int			deferred;
-
 	/* Number of invalidated buffers logged to the current transaction. */
-	unsigned int			invalidated;
+	unsigned int			nr_binval;
 
-	/* Number of deferred reaps queued during the whole reap sequence. */
-	unsigned long long		total_deferred;
+	/* Maximum number of buffers we can invalidate in a single tx. */
+	unsigned int			max_binval;
+
+	/* Number of deferred reaps attached to the current transaction. */
+	unsigned int			nr_deferred;
+
+	/* Maximum number of intents we can reap in a single transaction. */
+	unsigned int			max_deferred;
 };
 
 /* Put a block back on the AGFL. */
@@ -148,44 +148,36 @@ xreap_put_freelist(
 }
 
 /* Are there any uncommitted reap operations? */
-static inline bool xreap_dirty(const struct xreap_state *rs)
+static inline bool xreap_is_dirty(const struct xreap_state *rs)
 {
-	if (rs->force_roll)
-		return true;
-	if (rs->deferred)
-		return true;
-	if (rs->invalidated)
-		return true;
-	if (rs->total_deferred)
-		return true;
-	return false;
+	return rs->nr_binval > 0 || rs->nr_deferred > 0;
 }
 
 #define XREAP_MAX_BINVAL	(2048)
 
 /*
- * Decide if we want to roll the transaction after reaping an extent.  We don't
- * want to overrun the transaction reservation, so we prohibit more than
- * 128 EFIs per transaction.  For the same reason, we limit the number
- * of buffer invalidations to 2048.
+ * Decide if we need to roll the transaction to clear out the the log
+ * reservation that we allocated to buffer invalidations.
  */
-static inline bool xreap_want_roll(const struct xreap_state *rs)
+static inline bool xreap_want_binval_roll(const struct xreap_state *rs)
 {
-	if (rs->force_roll)
-		return true;
-	if (rs->deferred > XREP_MAX_ITRUNCATE_EFIS)
-		return true;
-	if (rs->invalidated > XREAP_MAX_BINVAL)
-		return true;
-	return false;
+	return rs->nr_binval >= rs->max_binval;
 }
 
-static inline void xreap_reset(struct xreap_state *rs)
+/* Reset the buffer invalidation count after rolling. */
+static inline void xreap_binval_reset(struct xreap_state *rs)
 {
-	rs->total_deferred += rs->deferred;
-	rs->deferred = 0;
-	rs->invalidated = 0;
-	rs->force_roll = false;
+	rs->nr_binval = 0;
+}
+
+/*
+ * Bump the number of invalidated buffers, and return true if we can continue,
+ * or false if we need to roll the transaction.
+ */
+static inline bool xreap_inc_binval(struct xreap_state *rs)
+{
+	rs->nr_binval++;
+	return rs->nr_binval < rs->max_binval;
 }
 
 #define XREAP_MAX_DEFER_CHAIN		(2048)
@@ -194,25 +186,36 @@ static inline void xreap_reset(struct xreap_state *rs)
  * Decide if we want to finish the deferred ops that are attached to the scrub
  * transaction.  We don't want to queue huge chains of deferred ops because
  * that can consume a lot of log space and kernel memory.  Hence we trigger a
- * xfs_defer_finish if there are more than 2048 deferred reap operations or the
- * caller did some real work.
+ * xfs_defer_finish if there are too many deferred reap operations or we've run
+ * out of space for invalidations.
  */
-static inline bool
-xreap_want_defer_finish(const struct xreap_state *rs)
+static inline bool xreap_want_defer_finish(const struct xreap_state *rs)
 {
-	if (rs->force_roll)
-		return true;
-	if (rs->total_deferred > XREAP_MAX_DEFER_CHAIN)
-		return true;
-	return false;
+	return rs->nr_deferred >= rs->max_deferred;
 }
 
+/*
+ * Reset the defer chain length and buffer invalidation count after finishing
+ * items.
+ */
 static inline void xreap_defer_finish_reset(struct xreap_state *rs)
 {
-	rs->total_deferred = 0;
-	rs->deferred = 0;
-	rs->invalidated = 0;
-	rs->force_roll = false;
+	rs->nr_deferred = 0;
+	rs->nr_binval = 0;
+}
+
+/*
+ * Bump the number of deferred extent reaps.
+ */
+static inline void xreap_inc_defer(struct xreap_state *rs)
+{
+	rs->nr_deferred++;
+}
+
+/* Force the caller to finish a deferred item chain. */
+static inline void xreap_force_defer_finish(struct xreap_state *rs)
+{
+	rs->nr_deferred = rs->max_deferred;
 }
 
 /*
@@ -297,14 +300,13 @@ xreap_agextent_binval(
 		while ((bp = xrep_bufscan_advance(mp, &scan)) != NULL) {
 			xfs_trans_bjoin(sc->tp, bp);
 			xfs_trans_binval(sc->tp, bp);
-			rs->invalidated++;
 
 			/*
 			 * Stop invalidating if we've hit the limit; we should
 			 * still have enough reservation left to free however
 			 * far we've gotten.
 			 */
-			if (rs->invalidated > XREAP_MAX_BINVAL) {
+			if (!xreap_inc_binval(rs)) {
 				*aglenp -= agbno_next - bno;
 				goto out;
 			}
@@ -416,7 +418,7 @@ xreap_agextent_iter(
 		trace_xreap_dispose_unmap_extent(pag_group(sc->sa.pag), agbno,
 				*aglenp);
 
-		rs->force_roll = true;
+		xreap_force_defer_finish(rs);
 
 		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
 			/*
@@ -443,7 +445,7 @@ xreap_agextent_iter(
 	 */
 	xreap_agextent_binval(rs, agbno, aglenp);
 	if (*aglenp == 0) {
-		ASSERT(xreap_want_roll(rs));
+		ASSERT(xreap_want_binval_roll(rs));
 		return 0;
 	}
 
@@ -463,7 +465,7 @@ xreap_agextent_iter(
 		if (error)
 			return error;
 
-		rs->force_roll = true;
+		xreap_force_defer_finish(rs);
 		return 0;
 	}
 
@@ -474,7 +476,7 @@ xreap_agextent_iter(
 		if (error)
 			return error;
 
-		rs->force_roll = true;
+		xreap_force_defer_finish(rs);
 		return 0;
 	}
 
@@ -489,8 +491,8 @@ xreap_agextent_iter(
 	if (error)
 		return error;
 
-	rs->deferred++;
-	if (rs->deferred % 2 == 0)
+	xreap_inc_defer(rs);
+	if (rs->nr_deferred % 2 == 0)
 		xfs_defer_add_barrier(sc->tp);
 	return 0;
 }
@@ -531,11 +533,11 @@ xreap_agmeta_extent(
 			if (error)
 				return error;
 			xreap_defer_finish_reset(rs);
-		} else if (xreap_want_roll(rs)) {
+		} else if (xreap_want_binval_roll(rs)) {
 			error = xrep_roll_ag_trans(sc);
 			if (error)
 				return error;
-			xreap_reset(rs);
+			xreap_binval_reset(rs);
 		}
 
 		agbno += aglen;
@@ -556,6 +558,8 @@ xrep_reap_agblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= type,
+		.max_binval		= XREAP_MAX_BINVAL,
+		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
@@ -566,7 +570,7 @@ xrep_reap_agblocks(
 	if (error)
 		return error;
 
-	if (xreap_dirty(&rs))
+	if (xreap_is_dirty(&rs))
 		return xrep_defer_finish(sc);
 
 	return 0;
@@ -628,7 +632,7 @@ xreap_fsmeta_extent(
 			if (error)
 				goto out_agf;
 			xreap_defer_finish_reset(rs);
-		} else if (xreap_want_roll(rs)) {
+		} else if (xreap_want_binval_roll(rs)) {
 			/*
 			 * Hold the AGF buffer across the transaction roll so
 			 * that we don't have to reattach it to the scrub
@@ -639,7 +643,7 @@ xreap_fsmeta_extent(
 			xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
 			if (error)
 				goto out_agf;
-			xreap_reset(rs);
+			xreap_binval_reset(rs);
 		}
 
 		agbno += aglen;
@@ -668,6 +672,8 @@ xrep_reap_fsblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= XFS_AG_RESV_NONE,
+		.max_binval		= XREAP_MAX_BINVAL,
+		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
@@ -678,7 +684,7 @@ xrep_reap_fsblocks(
 	if (error)
 		return error;
 
-	if (xreap_dirty(&rs))
+	if (xreap_is_dirty(&rs))
 		return xrep_defer_finish(sc);
 
 	return 0;
@@ -778,7 +784,7 @@ xreap_rgextent_iter(
 				*rglenp);
 
 		xfs_refcount_free_cow_extent(sc->tp, true, rtbno, *rglenp);
-		rs->deferred++;
+		xreap_inc_defer(rs);
 		return 0;
 	}
 
@@ -799,7 +805,7 @@ xreap_rgextent_iter(
 	if (error)
 		return error;
 
-	rs->deferred++;
+	xreap_inc_defer(rs);
 	return 0;
 }
 
@@ -855,11 +861,11 @@ xreap_rtmeta_extent(
 			if (error)
 				goto out_unlock;
 			xreap_defer_finish_reset(rs);
-		} else if (xreap_want_roll(rs)) {
+		} else if (xreap_want_binval_roll(rs)) {
 			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
 			if (error)
 				goto out_unlock;
-			xreap_reset(rs);
+			xreap_binval_reset(rs);
 		}
 
 		rgbno += rglen;
@@ -886,6 +892,8 @@ xrep_reap_rtblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= XFS_AG_RESV_NONE,
+		.max_binval		= XREAP_MAX_BINVAL,
+		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
@@ -896,7 +904,7 @@ xrep_reap_rtblocks(
 	if (error)
 		return error;
 
-	if (xreap_dirty(&rs))
+	if (xreap_is_dirty(&rs))
 		return xrep_defer_finish(sc);
 
 	return 0;
@@ -922,6 +930,8 @@ xrep_reap_metadir_fsblocks(
 		.sc			= sc,
 		.oinfo			= &oinfo,
 		.resv			= XFS_AG_RESV_NONE,
+		.max_binval		= XREAP_MAX_BINVAL,
+		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
@@ -930,12 +940,11 @@ xrep_reap_metadir_fsblocks(
 	ASSERT(xfs_is_metadir_inode(sc->ip));
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
-
 	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
 	if (error)
 		return error;
 
-	if (xreap_dirty(&rs)) {
+	if (xreap_is_dirty(&rs)) {
 		error = xrep_defer_finish(sc);
 		if (error)
 			return error;

