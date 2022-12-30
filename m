Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80B3C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiL3X5O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbiL3X5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:57:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F92416588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F105761C44
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA95C433EF;
        Fri, 30 Dec 2022 23:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444629;
        bh=CGuNHKBrVnO5T/r/7tmrhJ/ZU222MZtN5xcDgLj4rhs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vzbic5B2NzO8iJ0UubkIgdXh1q5YVKrmVozOAZexfWgtXfrDcG74ZVUou3VgsiEtj
         XjKncyisTuuHTeqQoXignlbo0hyisR8gWZeHCMrwWyAjawV0NjVUtjUUYZWTSWFSeP
         0Kt4UKrb+9xvoWcnez0cqpwVyC2ZX/KcDVtMyqWq7YM8xdC2E3HzND45pSbSRPGNC4
         kN8kp2AUtVKiIW0t0b7xpAj480KZ+OfDixymWP3hSOL4yK3Lq/4EDChopr+Tf6Re7d
         OYacru20/6kPn4Tn1zCOScRaMoCy/RgvnTLQjEv/P2H977owNlyGWgwUC46sYGKzdV
         8JVcSeAE2Hs2A==
Subject: [PATCH 2/3] xfs: teach the tempfile to support atomic extent swapping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:05 -0800
Message-ID: <167243844505.700124.13639617427288035717.stgit@magnolia>
In-Reply-To: <167243844474.700124.6546659007531232200.stgit@magnolia>
References: <167243844474.700124.6546659007531232200.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create some new routines to exchange the contents of a temporary file
created to stage a repair with another ondisk file.  This will be used
by the realtime summary repair function to commit atomically the new
rtsummary data, which will be staged in the tempfile.

The rest of XFS coordinates access to the realtime metadata inodes
solely through the ILOCK.  For repair to hold its exclusive access to
the realtime summary file, it has to allocate a single large transaction
and roll it repeatedly throughout the repair while holding the ILOCK.
In turn, this means that for now there's only a partial swapext
implementation for the temporary file, because we can only work within
an existing transaction.  Hence the only tempswap functions needed here
are to estimate the resource requirements of swapext between, reserve
more space/quota to an existing transaction, and kick off the actual
swap.  The rest will be added in a later patch in preparation for
repairing xattrs and directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c    |    4 +
 fs/xfs/scrub/scrub.h    |    1 
 fs/xfs/scrub/tempfile.c |  193 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempswap.h |   21 +++++
 fs/xfs/scrub/trace.h    |    1 
 5 files changed, 220 insertions(+)
 create mode 100644 fs/xfs/scrub/tempswap.h


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7bab30c2766e..a994710d99ae 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -193,6 +193,10 @@ xchk_teardown(
 		xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
 	}
+	if (sc->flags & XREP_ATOMIC_EXCHANGE) {
+		sc->flags &= ~XREP_ATOMIC_EXCHANGE;
+		xfs_xchg_range_rele_log_assist(sc->mp);
+	}
 	if (sc->flags & XCHK_HAVE_FREEZE_PROT) {
 		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
 		mnt_drop_write_file(sc->file);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 7892901ad70b..9c26a6092c52 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -131,6 +131,7 @@ struct xfs_scrub {
 #define XCHK_FSHOOKS_QUOTA	(1 << 4)  /* quota live update enabled */
 #define XCHK_FSHOOKS_NLINKS	(1 << 5)  /* link count live update enabled */
 #define XCHK_FSHOOKS_RMAP	(1 << 6)  /* rmapbt live update enabled */
+#define XREP_ATOMIC_EXCHANGE	(1 << 29) /* uses atomic file content exchange */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index d45ed229b8cb..7214d2370bc9 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -19,12 +19,14 @@
 #include "xfs_trans_space.h"
 #include "xfs_dir2.h"
 #include "xfs_xchgrange.h"
+#include "xfs_swapext.h"
 #include "xfs_defer.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
 #include "scrub/trace.h"
 #include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
 #include "scrub/xfile.h"
 
 /*
@@ -424,3 +426,194 @@ xrep_tempfile_roll_trans(
 	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
 	return 0;
 }
+
+/* Enable atomic extent swapping. */
+int
+xrep_tempswap_grab_log_assist(
+	struct xfs_scrub	*sc)
+{
+	bool			need_rele = false;
+	int			error;
+
+	ASSERT(!(sc->flags & XREP_ATOMIC_EXCHANGE));
+
+	error = xfs_xchg_range_grab_log_assist(sc->mp, true, &need_rele);
+	if (error)
+		return error;
+	if (!need_rele) {
+		ASSERT(need_rele);
+		return -EOPNOTSUPP;
+	}
+
+	sc->flags |= XREP_ATOMIC_EXCHANGE;
+	return 0;
+}
+
+/*
+ * Fill out the swapext request in preparation for swapping the contents of a
+ * metadata file that we've rebuilt in the temp file.
+ */
+STATIC int
+xrep_tempswap_prep_request(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempswap	*tx)
+{
+	struct xfs_swapext_req	*req = &tx->req;
+
+	memset(tx, 0, sizeof(struct xrep_tempswap));
+
+	/* COW forks don't exist on disk. */
+	if (whichfork == XFS_COW_FORK) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	/* Both files should have the relevant forks. */
+	if (!xfs_ifork_ptr(sc->ip, whichfork) ||
+	    !xfs_ifork_ptr(sc->tempip, whichfork)) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	/* Swap all mappings in both forks. */
+	req->ip1 = sc->tempip;
+	req->ip2 = sc->ip;
+	req->startoff1 = 0;
+	req->startoff2 = 0;
+	req->whichfork = whichfork;
+	req->blockcount = XFS_MAX_FILEOFF;
+	req->req_flags = XFS_SWAP_REQ_LOGGED;
+
+	/* Always swap sizes when we're swapping data fork mappings. */
+	if (whichfork == XFS_DATA_FORK)
+		req->req_flags |= XFS_SWAP_REQ_SET_SIZES;
+
+	/*
+	 * If we're repairing symlinks, xattrs, or directories, always try to
+	 * convert ip2 to short format after swapping.
+	 */
+	if (whichfork == XFS_ATTR_FORK || S_ISDIR(VFS_I(sc->ip)->i_mode) ||
+	    S_ISLNK(VFS_I(sc->ip)->i_mode))
+		req->req_flags |= XFS_SWAP_REQ_CVT_INO2_SF;
+
+	return 0;
+}
+
+/*
+ * Obtain a quota reservation to make sure we don't hit EDQUOT.  We can skip
+ * this if quota enforcement is disabled or if both inodes' dquots are the
+ * same.  The qretry structure must be initialized to zeroes before the first
+ * call to this function.
+ */
+STATIC int
+xrep_tempswap_reserve_quota(
+	struct xfs_scrub		*sc,
+	const struct xrep_tempswap	*tx)
+{
+	struct xfs_trans		*tp = sc->tp;
+	const struct xfs_swapext_req	*req = &tx->req;
+	int64_t				ddelta, rdelta;
+	int				error;
+
+	/*
+	 * Don't bother with a quota reservation if we're not enforcing them
+	 * or the two inodes have the same dquots.
+	 */
+	if (!XFS_IS_QUOTA_ON(tp->t_mountp) || req->ip1 == req->ip2 ||
+	    (req->ip1->i_udquot == req->ip2->i_udquot &&
+	     req->ip1->i_gdquot == req->ip2->i_gdquot &&
+	     req->ip1->i_pdquot == req->ip2->i_pdquot))
+		return 0;
+
+	/*
+	 * Quota reservation for each file comes from two sources.  First, we
+	 * need to account for any net gain in mapped blocks during the swap.
+	 * Second, we need reservation for the gross gain in mapped blocks so
+	 * that we don't trip over any quota block reservation assertions.  We
+	 * must reserve the gross gain because the quota code subtracts from
+	 * bcount the number of blocks that we unmap; it does not add that
+	 * quantity back to the quota block reservation.
+	 */
+	ddelta = max_t(int64_t, 0, req->ip2_bcount - req->ip1_bcount);
+	rdelta = max_t(int64_t, 0, req->ip2_rtbcount - req->ip1_rtbcount);
+	error = xfs_trans_reserve_quota_nblks(tp, req->ip1,
+			ddelta + req->ip1_bcount, rdelta + req->ip1_rtbcount,
+			true);
+	if (error)
+		return error;
+
+	ddelta = max_t(int64_t, 0, req->ip1_bcount - req->ip2_bcount);
+	rdelta = max_t(int64_t, 0, req->ip1_rtbcount - req->ip2_rtbcount);
+	return xfs_trans_reserve_quota_nblks(tp, req->ip2,
+			ddelta + req->ip2_bcount, rdelta + req->ip2_rtbcount,
+			true);
+}
+
+/*
+ * Prepare an existing transaction for a swap.  The caller must hold
+ * the ILOCK of both the inode being repaired and the temporary file.
+ * Only use this when those ILOCKs cannot be dropped.
+ *
+ * Fill out the swapext request and resource estimation structures in
+ * preparation for swapping the contents of a metadata file that we've rebuilt
+ * in the temp file, then reserve space and quota to the transaction.
+ */
+int
+xrep_tempswap_trans_reserve(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempswap	*tx)
+{
+	int			error;
+
+	ASSERT(sc->tp != NULL);
+	ASSERT(xfs_isilocked(sc->ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(sc->tempip, XFS_ILOCK_EXCL));
+
+	error = xrep_tempswap_prep_request(sc, whichfork, tx);
+	if (error)
+		return error;
+
+	error = xfs_swapext_estimate(&tx->req);
+	if (error)
+		return error;
+
+	error = xfs_trans_reserve_more(sc->tp, tx->req.resblks, 0);
+	if (error)
+		return error;
+
+	return xrep_tempswap_reserve_quota(sc, tx);
+}
+
+/* Swap forks between the file being repaired and the temporary file. */
+int
+xrep_tempswap_contents(
+	struct xfs_scrub	*sc,
+	struct xrep_tempswap	*tx)
+{
+	int			error;
+
+	ASSERT(sc->flags & XREP_ATOMIC_EXCHANGE);
+
+	xfs_swapext(sc->tp, &tx->req);
+	error = xfs_defer_finish(&sc->tp);
+	if (error)
+		return error;
+
+	/*
+	 * If we swapped the ondisk sizes of two metadata files, we must swap
+	 * the incore sizes as well.  Since online fsck doesn't use swapext on
+	 * the data forks of user-accessible files, the two sizes are always
+	 * the same, so we don't need to log the inodes.
+	 */
+	if (tx->req.req_flags & XFS_SWAP_REQ_SET_SIZES) {
+		loff_t	temp;
+
+		temp = i_size_read(VFS_I(sc->ip));
+		i_size_write(VFS_I(sc->ip), i_size_read(VFS_I(sc->tempip)));
+		i_size_write(VFS_I(sc->tempip), temp);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/tempswap.h b/fs/xfs/scrub/tempswap.h
new file mode 100644
index 000000000000..62e88cc6d91a
--- /dev/null
+++ b/fs/xfs/scrub/tempswap.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_TEMPSWAP_H__
+#define __XFS_SCRUB_TEMPSWAP_H__
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+struct xrep_tempswap {
+	struct xfs_swapext_req	req;
+};
+
+int xrep_tempswap_grab_log_assist(struct xfs_scrub *sc);
+int xrep_tempswap_trans_reserve(struct xfs_scrub *sc, int whichfork,
+		struct xrep_tempswap *ti);
+
+int xrep_tempswap_contents(struct xfs_scrub *sc, struct xrep_tempswap *ti);
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_TEMPFILE_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 292e2c3ece1d..aebfaef07e2d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -124,6 +124,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XCHK_FSHOOKS_QUOTA,			"fshooks_quota" }, \
 	{ XCHK_FSHOOKS_NLINKS,			"fshooks_nlinks" }, \
 	{ XCHK_FSHOOKS_RMAP,			"fshooks_rmap" }, \
+	{ XREP_ATOMIC_EXCHANGE,			"atomic_swapext" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 

