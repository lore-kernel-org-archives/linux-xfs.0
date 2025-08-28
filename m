Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5472253B0
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391367; cv=none; b=tcGTfK4anqNA7bs37ggBjwRJa6K/ttNGv5dysGeFdWEgHqtAcGwzp3nzDxWuMyW+uVhMeAC56By7vJeUmMrNCVCj9bR9zq2sEOdPX8e1q5n+8ZqWAYYxocCp1YRowjnH7Oi47T+kLaa6Qtrf711YF43jZHQuNDG0ME4KAYdE8RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391367; c=relaxed/simple;
	bh=xUpq35S4g9T52uI2bM1ctUSU8wLcJEpRpzmsa4cpw4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tzT7bBOTgM/OPjweVTUIyvF1lJrOSui8zxwNAxgXvTQ5Mac1a3Y0a1tD3Ds4ySWNs912DVF5aShD0cd84rw7ydnLYKBR6cq120Vt7I6E5P20NzO02WAjUNQuXeLjPkeU8vsfAPB59wmmCnks9rOFQ4JkFCClioevN9fQmt22Km8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7ga1j53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7ga1j53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6086C4CEEB;
	Thu, 28 Aug 2025 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391366;
	bh=xUpq35S4g9T52uI2bM1ctUSU8wLcJEpRpzmsa4cpw4A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D7ga1j5356fdw/+F9PQM25VWH0vTDm0ca/0QUHjsAN8nTDVRq/wgqy7wzEms8cJP3
	 WxmQ7QQGVwMF2R1RiuqmQ3UwMBK7ZELRWLGviEjCyR9hZ7ncJXmB7wUwmB3Qsnaeq7
	 fEF29dMnvxARNnVY6OZ5Dg4OysyLAwYOSu+J57/V3qyU4nv23XSjkGznTdBCyqH8Xh
	 k08PNyOiKZcaz2XvhI3MKjvwPkv5M9x1D6gQ/OYv70croTm4nQFcLlxnasa5EIfpsV
	 83GkFgntSqW3TeIv9C8yVgFPyvazkzjBBrU+CtajDYpHfoYgVNAcn9hI7O3NSSK08S
	 TyfwPxKjCxwkg==
Date: Thu, 28 Aug 2025 07:29:26 -0700
Subject: [PATCH 6/9] xfs: compute realtime device CoW staging extent reap
 limits dynamically
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126564.761138.12680157577981903157.stgit@frogsfrogsfrogs>
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
		(space used by intents per extent)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    1 +
 fs/xfs/scrub/reap.c  |   71 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 68 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a9da22f50534cb..1a994d339c42cf 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2042,6 +2042,7 @@ DEFINE_EVENT(xrep_reap_limits_class, name, \
 	TP_ARGS(tp, per_binval, max_binval, step_size, per_intent, max_deferred))
 DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_agextent_limits);
 DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_agcow_limits);
+DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_rgcow_limits);
 
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index aaef7e6771a045..b2f089e2c49daa 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -984,7 +984,7 @@ xreap_rgextent_iter(
 	rtbno = xfs_rgbno_to_rtb(sc->sr.rtg, rgbno);
 
 	/*
-	 * If there are other rmappings, this block is cross linked and must
+	 * t1: There are other rmappings; this block is cross linked and must
 	 * not be freed.  Remove the forward and reverse mapping and move on.
 	 */
 	if (crosslinked) {
@@ -999,7 +999,7 @@ xreap_rgextent_iter(
 	trace_xreap_dispose_free_extent(rtg_group(sc->sr.rtg), rgbno, *rglenp);
 
 	/*
-	 * The CoW staging extent is not crosslinked.  Use deferred work items
+	 * t2: The CoW staging extent is not crosslinked.  Use deferred work
 	 * to remove the refcountbt records (which removes the rmap records)
 	 * and free the extent.  We're not worried about the system going down
 	 * here because log recovery walks the refcount btree to clean out the
@@ -1017,6 +1017,69 @@ xreap_rgextent_iter(
 	return 0;
 }
 
+/*
+ * Compute the maximum number of intent items that reaping can attach to the
+ * scrub transaction given the worst case log overhead of the intent items
+ * needed to reap a single CoW staging extent.  This is not for freeing
+ * metadata blocks.
+ */
+STATIC void
+xreap_configure_rgcow_limits(
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
+	 * t1: Unmapping crosslinked CoW blocks: deferred removal of refcount
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
+	const unsigned int	t1 = cui + rui;
+	const unsigned int	t2 = cui + rui + efi;
+	const unsigned int	per_intent = max(t1, t2);
+
+	/*
+	 * For each transaction in a reap chain, we must be able to take one
+	 * step in the defer item chain, which should only consist of CUI, EFI,
+	 * or RUI items.
+	 */
+	const unsigned int	f1 = xfs_calc_finish_rt_efi_reservation(mp, 1);
+	const unsigned int	f2 = xfs_calc_finish_rt_rui_reservation(mp, 1);
+	const unsigned int	f3 = xfs_calc_finish_rt_cui_reservation(mp, 1);
+	const unsigned int	step_size = max3(f1, f2, f3);
+
+	/*
+	 * The only buffer for the rt device is the rtgroup super, so we don't
+	 * need to save space for buffer invalidations.
+	 */
+	xreap_configure_limits(rs, step_size, per_intent, per_intent, 0);
+
+	trace_xreap_rgcow_limits(sc->tp, 0, 0, step_size, per_intent,
+			rs->max_deferred);
+}
+
 #define XREAP_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP | \
 				 XFS_RTGLOCK_RMAP | \
 				 XFS_RTGLOCK_REFCOUNT)
@@ -1100,14 +1163,14 @@ xrep_reap_rtblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= XFS_AG_RESV_NONE,
-		.max_binval		= XREAP_MAX_BINVAL,
-		.max_deferred		= XREAP_MAX_DEFER_CHAIN,
 	};
 	int				error;
 
 	ASSERT(xfs_has_rmapbt(sc->mp));
 	ASSERT(sc->ip != NULL);
+	ASSERT(oinfo == &XFS_RMAP_OINFO_COW);
 
+	xreap_configure_rgcow_limits(&rs);
 	error = xrtb_bitmap_walk(bitmap, xreap_rtmeta_extent, &rs);
 	if (error)
 		return error;

