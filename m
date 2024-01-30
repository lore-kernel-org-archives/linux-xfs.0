Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1109376F2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591354; cv=none; b=TaNBGgd2l6a9uOXrjoNOgriChkYiq73EDMOsawEzHCL57MjpijtBGgGVGjogCXAou6dBPk8GDt9jKS3ugrQY3+PPIWLdCgUtEE6XBpmUrlbTBnxA6x8axDyf4RIeUhNaayVBEdlY80FXcmbRfw0oUtsDoHZ4TrLfZBSpndeg3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591354; c=relaxed/simple;
	bh=LWkypntz3SyTmpfqTOJ/MFW/wtWgpk4pTzzLNmp6nGw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjGwvbIQ4z8hBXDSl/1EEa/gWdUeVSSEruWU3CQzFoZ4JSz44wFqc8ULhj89MyWZY0v1FjkrIB3VCC/lp8XIKaHmYtCHIkg6e4uDeQNY8abzVR8h42+H0/87TUmXXBd4R1o14H/InEB+LbbwrC5hYw0TiI1Jpe5TI9zKiyEpveo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOnVqEei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOnVqEei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADDBC433F1;
	Tue, 30 Jan 2024 05:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591354;
	bh=LWkypntz3SyTmpfqTOJ/MFW/wtWgpk4pTzzLNmp6nGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nOnVqEeioFjat9xOwedrmBbT0jsiCQNQuK2XbflRFfwfGzWxjog73syR2TNbO0Dn+
	 6gp4N13mRF3dLyejSJWWxhkMXeD1gUkP7KpY57KeFpCVPl7EQPQI8AIrR74PABTRBQ
	 EcrCfyxdJM8MLYP0fPrFOZYEK+2zsypbZ0+jrZ6IGj/sWodFC9FaFdnK/IOvFyXIGh
	 NsP06qzklckAd9L+YKk6n3T5Fbt3IaJpHzV5ueofHiTjuHbu4Ovz7Z8YkdkjPhKjHs
	 7PPmK0APFNXXpg1zzTtRdmCkhAqT4WscDONEz8d4GJSGwUFdE5yU6/uvlD/jZnfR7i
	 O+P2FmoH+H0qw==
Date: Mon, 29 Jan 2024 21:09:13 -0800
Subject: [PATCH 4/4] xfs: teach repair to fix file nlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063326.3353617.15871107529862909902.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
References: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
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

Fix the file link counts since we just computed the correct ones.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/nlinks.c        |    4 +
 fs/xfs/scrub/nlinks.h        |    5 +
 fs/xfs/scrub/nlinks_repair.c |  223 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.h         |    3 +
 7 files changed, 237 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index cabf1dd341adc..1efc3b7727dc0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -195,6 +195,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   newbt.o \
+				   nlinks_repair.o \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 421615136972b..8eb0f96932866 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -61,7 +61,9 @@ xchk_setup_nlinks(
  * set the INCOMPLETE flag even when a negative errno is returned.  This care
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
- * xchk_*_process_error.
+ * xchk_*_process_error.  Scrub and repair share the same incore data
+ * structures, so the INCOMPLETE flag is critical to prevent a repair based on
+ * insufficient information.
  *
  * Because we are scanning a live filesystem, it's possible that another thread
  * will try to update the link counts for an inode that we've already scanned.
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index 58d247c051292..6b651ac0822e2 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -81,9 +81,12 @@ struct xchk_nlink {
  */
 #define XCHK_NLINK_WRITTEN		(1U << 0)
 
-/* This data item was seen by the check-time compare function. */
+/* Already checked this link count record. */
 #define XCHK_NLINK_COMPARE_SCANNED	(1U << 1)
 
+/* Already made a repair with this link count record. */
+#define XREP_NLINK_DIRTY		(1U << 2)
+
 /* Compute total link count, using large enough variables to detect overflow. */
 static inline uint64_t
 xchk_nlink_total(struct xfs_inode *ip, const struct xchk_nlink *live)
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
new file mode 100644
index 0000000000000..b87618322f55b
--- /dev/null
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_bmap_util.h"
+#include "xfs_iwalk.h"
+#include "xfs_ialloc.h"
+#include "xfs_sb.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/repair.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/iscan.h"
+#include "scrub/nlinks.h"
+#include "scrub/trace.h"
+
+/*
+ * Live Inode Link Count Repair
+ * ============================
+ *
+ * Use the live inode link count information that we collected to replace the
+ * nlink values of the incore inodes.  A scrub->repair cycle should have left
+ * the live data and hooks active, so this is safe so long as we make sure the
+ * inode is locked.
+ */
+
+/*
+ * Correct the link count of the given inode.  Because we have to grab locks
+ * and resources in a certain order, it's possible that this will be a no-op.
+ */
+STATIC int
+xrep_nlinks_repair_inode(
+	struct xchk_nlink_ctrs	*xnc)
+{
+	struct xchk_nlink	obs;
+	struct xfs_scrub	*sc = xnc->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+	uint64_t		total_links;
+	uint64_t		actual_nlink;
+	bool			dirty = false;
+	int			error;
+
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &sc->tp);
+	if (error)
+		return error;
+
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(sc->tp, ip, 0);
+
+	mutex_lock(&xnc->lock);
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		error = -ECANCELED;
+		goto out_scanlock;
+	}
+
+	error = xfarray_load_sparse(xnc->nlinks, ip->i_ino, &obs);
+	if (error)
+		goto out_scanlock;
+
+	/*
+	 * We're done accessing the shared scan data, so we can drop the lock.
+	 * We still hold @ip's ILOCK, so its link count cannot change.
+	 */
+	mutex_unlock(&xnc->lock);
+
+	total_links = xchk_nlink_total(ip, &obs);
+	actual_nlink = VFS_I(ip)->i_nlink;
+
+	/*
+	 * Non-directories cannot have directories pointing up to them.
+	 *
+	 * We previously set error to zero, but set it again because one static
+	 * checker author fears that programmers will fail to maintain this
+	 * invariant and built their tool to flag this as a security risk.  A
+	 * different tool author made their bot complain about the redundant
+	 * store.  This is a never-ending and stupid battle; both tools missed
+	 * *actual bugs* elsewhere; and I no longer care.
+	 */
+	if (!S_ISDIR(VFS_I(ip)->i_mode) && obs.children != 0) {
+		trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		error = 0;
+		goto out_trans;
+	}
+
+	/*
+	 * We did not find any links to this inode.  If the inode agrees, we
+	 * have nothing further to do.  If not, the inode has a nonzero link
+	 * count and we don't have anywhere to graft the child onto.  Dropping
+	 * a live inode's link count to zero can cause unexpected shutdowns in
+	 * inactivation, so leave it alone.
+	 */
+	if (total_links == 0) {
+		if (actual_nlink != 0)
+			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		goto out_trans;
+	}
+
+	/* Commit the new link count if it changed. */
+	if (total_links != actual_nlink) {
+		if (total_links > XFS_MAXLINK) {
+			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+			goto out_trans;
+		}
+
+		trace_xrep_nlinks_update_inode(mp, ip, &obs);
+
+		set_nlink(VFS_I(ip), total_links);
+		dirty = true;
+	}
+
+	if (!dirty) {
+		error = 0;
+		goto out_trans;
+	}
+
+	xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+
+	error = xrep_trans_commit(sc);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	return error;
+
+out_scanlock:
+	mutex_unlock(&xnc->lock);
+out_trans:
+	xchk_trans_cancel(sc);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	return error;
+}
+
+/*
+ * Try to visit every inode in the filesystem for repairs.  Move on if we can't
+ * grab an inode, since we're still making forward progress.
+ */
+static int
+xrep_nlinks_iter(
+	struct xchk_nlink_ctrs	*xnc,
+	struct xfs_inode	**ipp)
+{
+	int			error;
+
+	do {
+		error = xchk_iscan_iter(&xnc->compare_iscan, ipp);
+	} while (error == -EBUSY);
+
+	return error;
+}
+
+/* Commit the new inode link counters. */
+int
+xrep_nlinks(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_nlink_ctrs	*xnc = sc->buf;
+	int			error;
+
+	/*
+	 * We need ftype for an accurate count of the number of child
+	 * subdirectory links.  Child subdirectories with a back link (dotdot
+	 * entry) but no forward link are unfixable, so we cannot repair the
+	 * link count of the parent directory based on the back link count
+	 * alone.  Filesystems without ftype support are rare (old V4) so we
+	 * just skip out here.
+	 */
+	if (!xfs_has_ftype(sc->mp))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Use the inobt to walk all allocated inodes to compare and fix the
+	 * link counts.  Retry iget every tenth of a second for up to 30
+	 * seconds -- even if repair misses a few inodes, we still try to fix
+	 * as many of them as we can.
+	 */
+	xchk_iscan_start(sc, 30000, 100, &xnc->compare_iscan);
+	ASSERT(sc->ip == NULL);
+
+	while ((error = xrep_nlinks_iter(xnc, &sc->ip)) == 1) {
+		/*
+		 * Commit the scrub transaction so that we can create repair
+		 * transactions with the correct reservations.
+		 */
+		xchk_trans_cancel(sc);
+
+		error = xrep_nlinks_repair_inode(xnc);
+		xchk_iscan_mark_visited(&xnc->compare_iscan, sc->ip);
+		xchk_irele(sc, sc->ip);
+		sc->ip = NULL;
+		if (error)
+			break;
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+
+		/*
+		 * Create a new empty transaction so that we can advance the
+		 * iscan cursor without deadlocking if the inobt has a cycle.
+		 * We can only push the inactivation workqueues with an empty
+		 * transaction.
+		 */
+		error = xchk_trans_alloc_empty(sc);
+		if (error)
+			break;
+	}
+	xchk_iscan_iter_finish(&xnc->compare_iscan);
+	xchk_iscan_teardown(&xnc->compare_iscan);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index fdfa066999218..8edac0150e960 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -116,6 +116,7 @@ int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
+int xrep_nlinks(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -196,6 +197,7 @@ xrep_setup_nothing(
 #define xrep_rtbitmap			xrep_notsupported
 #define xrep_quota			xrep_notsupported
 #define xrep_quotacheck			xrep_notsupported
+#define xrep_nlinks			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 883c47b6c6860..c0b99184bb3ef 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -376,7 +376,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_nlinks,
 		.scrub	= xchk_nlinks,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_nlinks,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 9512170ea9a7b..c9b6b0e0bf117 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2185,6 +2185,9 @@ DEFINE_XREP_DQUOT_EVENT(xrep_dquot_item_fill_bmap_hole);
 DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 #endif /* CONFIG_XFS_QUOTA */
 
+DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
+DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

