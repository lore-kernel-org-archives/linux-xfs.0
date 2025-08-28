Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C751421CA02
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391382; cv=none; b=twj9bM82v8iDyGb2oON53dG9vTMLbWPgJhep8y/flvUARk0X4Ya3XPBwAOxiC6UFP1q2BnAPlgw0oKndL1nteeJ8vD+s8avoc8p3EEZln/5ug+KTP87BpOsYms7de1f300UDVUgsruLdeHcheKVfL0Qd59bLMefl3YvbGseKBz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391382; c=relaxed/simple;
	bh=rqJOnj2rc1e3SSL/ElhvyofnWc1qj+BFKs3A/xa6M70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJT7R1KiuYif2xBaY/21gKRALRyjvd5UfadhRQWRJ26z+AZCihPhPwFrvJKuuYGJx8zuCdzU9O07hbgW5JP+VDwXi6derD3b+KgTtSoZm4slk6txVdZADyKj3UQqhUCZgp+/5qtmOPiRY+XkHt3uW1PnXIMUxr2j8uYGZC3Bh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLNeraNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLNeraNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C9BC4CEEB;
	Thu, 28 Aug 2025 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391382;
	bh=rqJOnj2rc1e3SSL/ElhvyofnWc1qj+BFKs3A/xa6M70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PLNeraNCPQw5kgKBMECH+KNPCW1JeTNumbk9tAfOMkZxgKa+/KD9Tx+H4Mko9HDH8
	 aVjaSVHgDR9RoQQm60GPcaHOmzBcD5NIeEIfRfzQ0FCY+Wmo92fzl6/dggFBvVt1hu
	 NzqnBsvmLeMycfGPDtMC1iIOaF/jtMxyjIfPB83EAIZBZ+/w5VDHRcF2s9jMYn/otl
	 qR+8jp1Task4KC8DrisogPQ5hUjdG9hGIDjdPecIJXc6WmQQ3Jvkcn06Jj6zgt4rdi
	 syQ9XicW5C2DaO4mcD9y0BHJQ8AErATcycSUHmg8cysn4MMcFRPHCEeeHx+tgU8Sbo
	 jnDTom8cmRzjA==
Date: Thu, 28 Aug 2025 07:29:41 -0700
Subject: [PATCH 7/9] xfs: compute file mapping reap limits dynamically
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126584.761138.3241277838690114723.stgit@frogsfrogsfrogs>
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

Reaping file fork mappings is a little different -- log recovery can
free the blocks for us, so we only try to process a single mapping at a
time.  Therefore, we only need to figure out the maximum number of
blocks that we can invalidate in a single transaction.

The rough calculation here is:

nr_extents = (logres - reservation used by any one step) /
		(space used per binval)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    1 
 fs/xfs/scrub/reap.c  |  109 ++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 105 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1a994d339c42cf..39ea651cbb7510 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2043,6 +2043,7 @@ DEFINE_EVENT(xrep_reap_limits_class, name, \
 DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_agextent_limits);
 DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_agcow_limits);
 DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_rgcow_limits);
+DEFINE_REPAIR_REAP_LIMITS_EVENT(xreap_bmapi_limits);
 
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index b2f089e2c49daa..d58fd57aaebb43 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -542,7 +542,7 @@ xreap_configure_limits(
 		return;
 	}
 
-	rs->max_deferred = res / variable_overhead;
+	rs->max_deferred = per_intent ? res / variable_overhead : 0;
 	res -= rs->max_deferred * per_intent;
 	rs->max_binval = per_binval ? res / per_binval : 0;
 }
@@ -1446,7 +1446,7 @@ xrep_reap_bmapi_iter(
 				imap->br_blockcount);
 
 		/*
-		 * Schedule removal of the mapping from the fork.  We use
+		 * t0: Schedule removal of the mapping from the fork.  We use
 		 * deferred log intents in this function to control the exact
 		 * sequence of metadata updates.
 		 */
@@ -1479,8 +1479,8 @@ xrep_reap_bmapi_iter(
 		return error;
 
 	/*
-	 * Schedule removal of the mapping from the fork.  We use deferred log
-	 * intents in this function to control the exact sequence of metadata
+	 * t1: Schedule removal of the mapping from the fork.  We use deferred
+	 * work in this function to control the exact sequence of metadata
 	 * updates.
 	 */
 	xfs_bmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
@@ -1491,6 +1491,105 @@ xrep_reap_bmapi_iter(
 			XFS_FREE_EXTENT_SKIP_DISCARD);
 }
 
+/* Compute the maximum mapcount of a file buffer. */
+static unsigned int
+xreap_bmapi_binval_mapcount(
+	struct xfs_scrub	*sc)
+{
+	/* directory blocks can span multiple fsblocks and be discontiguous */
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_DIR)
+		return sc->mp->m_dir_geo->fsbcount;
+
+	/* all other file xattr/symlink blocks must be contiguous */
+	return 1;
+}
+
+/* Compute the maximum block size of a file buffer. */
+static unsigned int
+xreap_bmapi_binval_blocksize(
+	struct xfs_scrub	*sc)
+{
+	switch (sc->sm->sm_type) {
+	case XFS_SCRUB_TYPE_DIR:
+		return sc->mp->m_dir_geo->blksize;
+	case XFS_SCRUB_TYPE_XATTR:
+	case XFS_SCRUB_TYPE_PARENT:
+		/*
+		 * The xattr structure itself consists of single fsblocks, but
+		 * there could be remote xattr blocks to invalidate.
+		 */
+		return XFS_XATTR_SIZE_MAX;
+	}
+
+	/* everything else is a single block */
+	return sc->mp->m_sb.sb_blocksize;
+}
+
+/*
+ * Compute the maximum number of buffer invalidations that we can do while
+ * reaping a single extent from a file fork.
+ */
+STATIC void
+xreap_configure_bmapi_limits(
+	struct xreap_state	*rs)
+{
+	struct xfs_scrub	*sc = rs->sc;
+	struct xfs_mount	*mp = sc->mp;
+
+	/* overhead of invalidating a buffer */
+	const unsigned int	per_binval =
+		xfs_buf_inval_log_space(xreap_bmapi_binval_mapcount(sc),
+					    xreap_bmapi_binval_blocksize(sc));
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
+	const unsigned int	bui = xfs_bui_log_space(1) +
+				      xfs_bud_log_space();
+
+	/*
+	 * t1: Unmapping crosslinked file data blocks: one bmap deletion,
+	 * possibly an EFI for underfilled bmbt blocks, and an rmap deletion.
+	 *
+	 * t2: Freeing freeing file data blocks: one bmap deletion, possibly an
+	 * EFI for underfilled bmbt blocks, and another EFI for the space
+	 * itself.
+	 */
+	const unsigned int	t1 = (bui + efi) + rui;
+	const unsigned int	t2 = (bui + efi) + efi;
+	const unsigned int	per_intent = max(t1, t2);
+
+	/*
+	 * For each transaction in a reap chain, we must be able to take one
+	 * step in the defer item chain, which should only consist of CUI, EFI,
+	 * or RUI items.
+	 */
+	const unsigned int	f1 = xfs_calc_finish_efi_reservation(mp, 1);
+	const unsigned int	f2 = xfs_calc_finish_rui_reservation(mp, 1);
+	const unsigned int	f3 = xfs_calc_finish_bui_reservation(mp, 1);
+	const unsigned int	step_size = max3(f1, f2, f3);
+
+	/*
+	 * Each call to xreap_ifork_extent starts with a clean transaction and
+	 * operates on a single mapping by creating a chain of log intent items
+	 * for that mapping.  We need to leave enough reservation in the
+	 * transaction to log btree buffer and inode updates for each step in
+	 * the chain, and to relog the log intents.
+	 */
+	const unsigned int	per_extent_res = per_intent + step_size;
+
+	xreap_configure_limits(rs, per_extent_res, per_binval, 0, per_binval);
+
+	trace_xreap_bmapi_limits(sc->tp, per_binval, rs->max_binval,
+			step_size, per_intent, 1);
+}
+
 /*
  * Dispose of as much of this file extent as we can.  Upon successful return,
  * the imap will reflect the mapping that was removed from the fork.
@@ -1554,7 +1653,6 @@ xrep_reap_ifork(
 		.sc		= sc,
 		.ip		= ip,
 		.whichfork	= whichfork,
-		.max_binval	= XREAP_MAX_BINVAL,
 	};
 	xfs_fileoff_t		off = 0;
 	int			bmap_flags = xfs_bmapi_aflag(whichfork);
@@ -1564,6 +1662,7 @@ xrep_reap_ifork(
 	ASSERT(ip == sc->ip || ip == sc->tempip);
 	ASSERT(whichfork == XFS_ATTR_FORK || !XFS_IS_REALTIME_INODE(ip));
 
+	xreap_configure_bmapi_limits(&rs);
 	while (off < XFS_MAX_FILEOFF) {
 		struct xfs_bmbt_irec	imap;
 		int			nimaps = 1;

