Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3E7F4EB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000765; cv=none; b=WpPQNdoYHoOUjXXvwFW7NFCovQKhKKI2cDcGTTA7RMvfU6FHLeYX+s75JEAcKw6FcBmAZRp9zB6yxWFRI5ZmOT0oqZgQ0gNeCRn0CXSTHr5uc2AcIs//vs/gh6ij1I+eiO7RGL6xMMohtUFfCuIqNOYG6dpO/sZ06nmGGuV4vKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000765; c=relaxed/simple;
	bh=bjKgWY45mXtW/7csKVH/hkQPe5JO4MM0FK9tJ7A3ezU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mTIBN0XjTCyKB6jmeZHCXTQA290BhetpK4sVbDg5Va7q+p41mgdqu3Ro9Sg/5hAgkPWHjil9tg49CYpgGqRh7Lv1ZU1kMl6x89PEIyKFJOeGs+mO13f4DRoaF/DabhEeZHaTQbEpnOFb7nqLREP0uLY4JJpDzAW0eSF5gcsbp7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJXwUgCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJXwUgCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CD5C43394;
	Tue, 27 Feb 2024 02:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000765;
	bh=bjKgWY45mXtW/7csKVH/hkQPe5JO4MM0FK9tJ7A3ezU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EJXwUgCGb3wwvYGoZq31fMA+zhBHNjTBLOFB+Ep2XT6IebArIdCdK9a2VX5bzmlVf
	 N+fG8z/aBvohduZqABbe05URKN+zkpyd0lnqDoumBhJnlyUyWk1Mf6HVx+3J4g0spl
	 w3At2h+Q/ceUDEiqVWf0opNxBxFrsCJa1Ux8u3Qp2AaGgza/uc8i0GFVDikDkrMu4N
	 /mczJMkN/F2ZJZn9Em8PBgHwcSMbpVVuj9WWjlMGz8sCTeBhSPxFV8HgcLUvaBbzul
	 6YpXcMsR68VDDeMOiJxotMRvw+HgauYytZTKBIfKd9Ck+PrUYeM1fmvxfu5IivUuUx
	 Xc6nBrCLnxZ9g==
Date: Mon, 26 Feb 2024 18:26:04 -0800
Subject: [PATCH 2/3] xfs: teach the tempfile to set up atomic file content
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900012687.938812.17754155412825394260.stgit@frogsfrogsfrogs>
In-Reply-To: <170900012647.938812.317435406248625314.stgit@frogsfrogsfrogs>
References: <170900012647.938812.317435406248625314.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/scrub.c    |    8 +-
 fs/xfs/scrub/scrub.h    |    7 ++
 fs/xfs/scrub/tempexch.h |   21 +++++
 fs/xfs/scrub/tempfile.c |  194 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h    |    1 
 5 files changed, 228 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/tempexch.h


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d9012e9a6afd2..ff156edf49a08 100644
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
index e37d8599718e2..aca3e652343c1 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -131,6 +131,7 @@ struct xfs_scrub {
 #define XCHK_FSGATES_QUOTA	(1U << 4)  /* quota live update enabled */
 #define XCHK_FSGATES_DIRENTS	(1U << 5)  /* directory live update enabled */
 #define XCHK_FSGATES_RMAP	(1U << 6)  /* rmapbt live update enabled */
+#define XREP_FSGATES_EXCHMAPS	(1U << 29) /* uses atomic file content exchange */
 #define XREP_RESET_PERAG_RESV	(1U << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
 
@@ -145,6 +146,12 @@ struct xfs_scrub {
 				 XCHK_FSGATES_DIRENTS | \
 				 XCHK_FSGATES_RMAP)
 
+/*
+ * The sole XREP_FSGATES* flag reflects a log intent item that is protected
+ * by a log-incompat feature flag.  No code patching in use here.
+ */
+#define XREP_FSGATES_ALL	(XREP_FSGATES_EXCHMAPS)
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/tempexch.h b/fs/xfs/scrub/tempexch.h
new file mode 100644
index 0000000000000..98222b684b6a0
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
index 83e683e165618..9ed750699809e 100644
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
@@ -446,3 +448,195 @@ xrep_tempfile_roll_trans(
 	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
 	return 0;
 }
+
+/* Enable atomic file content exchanges. */
+int
+xrep_tempexch_enable(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (sc->flags & XREP_FSGATES_EXCHMAPS)
+		return 0;
+
+	error = xfs_exchrange_enable(sc->mp);
+	if (error)
+		return error;
+
+	trace_xchk_fsgates_enable(sc, XREP_FSGATES_EXCHMAPS);
+
+	sc->flags |= XREP_FSGATES_EXCHMAPS;
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
+	ASSERT(xfs_isilocked(sc->ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(sc->tempip, XFS_ILOCK_EXCL));
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
+	ASSERT(sc->flags & XREP_FSGATES_EXCHMAPS);
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
index 50801d5914839..5edbabacc31a8 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -114,6 +114,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XCHK_FSGATES_RMAP,			"fsgates_rmap" }, \
+	{ XREP_FSGATES_EXCHMAPS,		"fsgates_exchmaps" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 

