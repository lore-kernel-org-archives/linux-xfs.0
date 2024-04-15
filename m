Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502CE157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224777; cv=none; b=RbIuBiU6nA/LoEMiNp4ylCE8CQqoDfJlq5hqc/+Ks4461fB97MPxydsw8JgzEmm5wwlNXAOjvpZBB/thbLHPE5r//dRuxVN3H2OVm5uMcgG14i2QgRCdOcf3GfpQP7HJTxxX1/7hCht6eeKxEj4+aJ+Jp8IpoR0pzCvmHHwS05Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224777; c=relaxed/simple;
	bh=VydxwRGQdhkPP78omT0PPG2lc5HA4fg3ZgNeEjgVo60=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=raIMdaevskgxiWnv9pCHKz4YqDkFwfgkUVkICVhILKvG9dYhYwXD9a4jgBwnOvpW8gFll4UbOxJGLZZEeKCPullkR6NdEvHMJ5CLAma2JjNKGVv6cyhvcCiVZPXWhI8Z/XIfLOr7o9SGz3m/au8t/g3+RQjruO/9pavCCFz9ZNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVQfib1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVQfib1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273DEC113CC;
	Mon, 15 Apr 2024 23:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224777;
	bh=VydxwRGQdhkPP78omT0PPG2lc5HA4fg3ZgNeEjgVo60=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iVQfib1j5rKOR9UQcvujAsj7MxNimv0Vv36RNd21xymlh/pVkRRVSnEIE3Gqwaetp
	 ZCnOnJ9sxIfEm6ALkGbojHfRApPjUNpMk36+ElWiQkf7bNZCIcPt5NFoJTdRJmBmIy
	 GNNSomBYJum7xo83RgQfmUoeazQMXV+WsLrsTlqVPjoaInC6HdFj2nC6NBqJqXoi2e
	 RjiBu+JSTngvQ/2/iKB9sWZAREUSifKoU/WUFICSIZz/A/eE0G6fKMxEuUwinaeM69
	 3ySFwKHM0IajuZv/2osMj8TjXaVVybDvWuoxdDH96UkhicrWlA+Z3BBikpvsFXCGKA
	 QmrKyTtSBO0tw==
Date: Mon, 15 Apr 2024 16:46:16 -0700
Subject: [PATCH 2/3] xfs: teach the tempfile to set up atomic file content
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171322382208.88091.370743119350839220.stgit@frogsfrogsfrogs>
In-Reply-To: <171322382166.88091.17655506673018704776.stgit@frogsfrogsfrogs>
References: <171322382166.88091.17655506673018704776.stgit@frogsfrogsfrogs>
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

Create some new routines to exchange the contents of a temporary file
created to stage a repair with another ondisk file.  This will be used
by the realtime summary repair function to commit atomically the new
rtsummary data, which will be staged in the tempfile.

The rest of XFS coordinates access to the realtime metadata inodes
solely through the ILOCK.  For repair to hold its exclusive access to
the realtime summary file, it has to allocate a single large transaction
and roll it repeatedly throughout the repair while holding the ILOCK.
In turn, this means that for now there's only a partial file mapping
exchange implementation for the temporary file because we can only work
within an existing transaction.

For now, the only tempswap functions needed here are to estimate the
resource requirements of the exchange, reserve more space/quota to an
existing transaction, and kick off the actual exchange.  The rest will
be added in a later patch in preparation for repairing xattrs and
directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/scrub.c    |    8 +-
 fs/xfs/scrub/scrub.h    |    7 ++
 fs/xfs/scrub/tempexch.h |   21 +++++
 fs/xfs/scrub/tempfile.c |  191 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h    |    1 
 5 files changed, 225 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/tempexch.h


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d9012e9a6afd..ff156edf49a0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -149,14 +149,15 @@ xchk_probe(
 
 /* Scrub setup and teardown */
 
+#define FSGATES_MASK	(XCHK_FSGATES_ALL | XREP_FSGATES_ALL)
 static inline void
 xchk_fsgates_disable(
 	struct xfs_scrub	*sc)
 {
-	if (!(sc->flags & XCHK_FSGATES_ALL))
+	if (!(sc->flags & FSGATES_MASK))
 		return;
 
-	trace_xchk_fsgates_disable(sc, sc->flags & XCHK_FSGATES_ALL);
+	trace_xchk_fsgates_disable(sc, sc->flags & FSGATES_MASK);
 
 	if (sc->flags & XCHK_FSGATES_DRAIN)
 		xfs_drain_wait_disable();
@@ -170,8 +171,9 @@ xchk_fsgates_disable(
 	if (sc->flags & XCHK_FSGATES_RMAP)
 		xfs_rmap_hook_disable();
 
-	sc->flags &= ~XCHK_FSGATES_ALL;
+	sc->flags &= ~FSGATES_MASK;
 }
+#undef FSGATES_MASK
 
 /* Free all the resources and finish the transactions. */
 STATIC int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index e37d8599718e..d38f0b30416c 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -131,6 +131,7 @@ struct xfs_scrub {
 #define XCHK_FSGATES_QUOTA	(1U << 4)  /* quota live update enabled */
 #define XCHK_FSGATES_DIRENTS	(1U << 5)  /* directory live update enabled */
 #define XCHK_FSGATES_RMAP	(1U << 6)  /* rmapbt live update enabled */
+#define XREP_FSGATES_EXCHANGE_RANGE (1U << 29) /* uses file content exchange */
 #define XREP_RESET_PERAG_RESV	(1U << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
 
@@ -145,6 +146,12 @@ struct xfs_scrub {
 				 XCHK_FSGATES_DIRENTS | \
 				 XCHK_FSGATES_RMAP)
 
+/*
+ * The sole XREP_FSGATES* flag reflects a log intent item that is protected
+ * by a log-incompat feature flag.  No code patching in use here.
+ */
+#define XREP_FSGATES_ALL	(XREP_FSGATES_EXCHANGE_RANGE)
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/tempexch.h b/fs/xfs/scrub/tempexch.h
new file mode 100644
index 000000000000..98222b684b6a
--- /dev/null
+++ b/fs/xfs/scrub/tempexch.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_TEMPEXCH_H__
+#define __XFS_SCRUB_TEMPEXCH_H__
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+struct xrep_tempexch {
+	struct xfs_exchmaps_req	req;
+};
+
+int xrep_tempexch_enable(struct xfs_scrub *sc);
+int xrep_tempexch_trans_reserve(struct xfs_scrub *sc, int whichfork,
+		struct xrep_tempexch *ti);
+
+int xrep_tempexch_contents(struct xfs_scrub *sc, struct xrep_tempexch *ti);
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_TEMPEXCH_H__ */
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 83e683e16561..7791336ca820 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -19,12 +19,14 @@
 #include "xfs_trans_space.h"
 #include "xfs_dir2.h"
 #include "xfs_exchrange.h"
+#include "xfs_exchmaps.h"
 #include "xfs_defer.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
 #include "scrub/trace.h"
 #include "scrub/tempfile.h"
+#include "scrub/tempexch.h"
 #include "scrub/xfile.h"
 
 /*
@@ -446,3 +448,192 @@ xrep_tempfile_roll_trans(
 	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
 	return 0;
 }
+
+/* Enable file content exchanges. */
+int
+xrep_tempexch_enable(
+	struct xfs_scrub	*sc)
+{
+	if (sc->flags & XREP_FSGATES_EXCHANGE_RANGE)
+		return 0;
+
+	if (!xfs_has_exchange_range(sc->mp))
+		return -EOPNOTSUPP;
+
+	trace_xchk_fsgates_enable(sc, XREP_FSGATES_EXCHANGE_RANGE);
+
+	sc->flags |= XREP_FSGATES_EXCHANGE_RANGE;
+	return 0;
+}
+
+/*
+ * Fill out the mapping exchange request in preparation for atomically
+ * committing the contents of a metadata file that we've rebuilt in the temp
+ * file.
+ */
+STATIC int
+xrep_tempexch_prep_request(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempexch	*tx)
+{
+	struct xfs_exchmaps_req	*req = &tx->req;
+
+	memset(tx, 0, sizeof(struct xrep_tempexch));
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
+		ASSERT(xfs_ifork_ptr(sc->ip, whichfork) != NULL);
+		ASSERT(xfs_ifork_ptr(sc->tempip, whichfork) != NULL);
+		return -EINVAL;
+	}
+
+	/* Exchange all mappings in both forks. */
+	req->ip1 = sc->tempip;
+	req->ip2 = sc->ip;
+	req->startoff1 = 0;
+	req->startoff2 = 0;
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		req->flags |= XFS_EXCHMAPS_ATTR_FORK;
+		break;
+	case XFS_DATA_FORK:
+		/* Always exchange sizes when exchanging data fork mappings. */
+		req->flags |= XFS_EXCHMAPS_SET_SIZES;
+		break;
+	}
+	req->blockcount = XFS_MAX_FILEOFF;
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
+xrep_tempexch_reserve_quota(
+	struct xfs_scrub		*sc,
+	const struct xrep_tempexch	*tx)
+{
+	struct xfs_trans		*tp = sc->tp;
+	const struct xfs_exchmaps_req	*req = &tx->req;
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
+	 * need to account for any net gain in mapped blocks during the
+	 * exchange.  Second, we need reservation for the gross gain in mapped
+	 * blocks so that we don't trip over any quota block reservation
+	 * assertions.  We must reserve the gross gain because the quota code
+	 * subtracts from bcount the number of blocks that we unmap; it does
+	 * not add that quantity back to the quota block reservation.
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
+ * Prepare an existing transaction for an atomic file contents exchange.
+ *
+ * This function fills out the mapping exchange request and resource estimation
+ * structures in preparation for exchanging the contents of a metadata file
+ * that has been rebuilt in the temp file.  Next, it reserves space and quota
+ * for the transaction.
+ *
+ * The caller must hold ILOCK_EXCL of the scrub target file and the temporary
+ * file.  The caller must join both inodes to the transaction with no unlock
+ * flags, and is responsible for dropping both ILOCKs when appropriate.  Only
+ * use this when those ILOCKs cannot be dropped.
+ */
+int
+xrep_tempexch_trans_reserve(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempexch	*tx)
+{
+	int			error;
+
+	ASSERT(sc->tp != NULL);
+	xfs_assert_ilocked(sc->ip, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(sc->tempip, XFS_ILOCK_EXCL);
+
+	error = xrep_tempexch_prep_request(sc, whichfork, tx);
+	if (error)
+		return error;
+
+	error = xfs_exchmaps_estimate(&tx->req);
+	if (error)
+		return error;
+
+	error = xfs_trans_reserve_more(sc->tp, tx->req.resblks, 0);
+	if (error)
+		return error;
+
+	return xrep_tempexch_reserve_quota(sc, tx);
+}
+
+/*
+ * Exchange file mappings (and hence file contents) between the file being
+ * repaired and the temporary file.  Returns with both inodes locked and joined
+ * to a clean scrub transaction.
+ */
+int
+xrep_tempexch_contents(
+	struct xfs_scrub	*sc,
+	struct xrep_tempexch	*tx)
+{
+	int			error;
+
+	ASSERT(sc->flags & XREP_FSGATES_EXCHANGE_RANGE);
+
+	xfs_exchange_mappings(sc->tp, &tx->req);
+	error = xfs_defer_finish(&sc->tp);
+	if (error)
+		return error;
+
+	/*
+	 * If we exchanged the ondisk sizes of two metadata files, we must
+	 * exchanged the incore sizes as well.
+	 */
+	if (tx->req.flags & XFS_EXCHMAPS_SET_SIZES) {
+		loff_t	temp;
+
+		temp = i_size_read(VFS_I(sc->ip));
+		i_size_write(VFS_I(sc->ip), i_size_read(VFS_I(sc->tempip)));
+		i_size_write(VFS_I(sc->tempip), temp);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index ae90731bf6ad..8d05f2adae3d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -114,6 +114,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XCHK_FSGATES_RMAP,			"fsgates_rmap" }, \
+	{ XREP_FSGATES_EXCHANGE_RANGE,		"fsgates_exchrange" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 

