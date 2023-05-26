Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9523BC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjEZBAN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZBAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9CE194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC6A3649F2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25484C433D2;
        Fri, 26 May 2023 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062810;
        bh=QT5xWiscpAvxyznie3NIbmBVqcLfUARFSvBAab6ORV8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SmxZZvXUT4TnG/98UaYmg1NldhtnZImk8Sgug0nGAQLyT/PY1Y1vL5nStf69gVl+y
         ptrjdL/Ip0Vb3o0KEtlt4TwWuQyF4t5MlAAGgM8cAyxQBcn5n/GycHu5WFcnsDcXLB
         YV2mcJ4vECQx9b6YpKImNw98DzqYMzqErDZ7HMMsKtBLkYQiuV/ZNyUyfV6rHQkTzL
         lUaRd2dYC8sUyeUe56OTszJ0gJhVZFFG0z0Dyt2LARsirdFDOl9i0d7IEmCY5h5/vh
         O/DZ+1cHmmS6/ieyt5uWH2zkLQTkUARvD+8iklesYuLetzOmpjd9UdygfugY2+fIMB
         jpeYXBli5URYw==
Date:   Thu, 25 May 2023 18:00:09 -0700
Subject: [PATCH 5/5] xfs: teach repair to fix file nlinks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060343.3731332.8482108317594387583.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060263.3731332.723936389513300302.stgit@frogsfrogsfrogs>
References: <168506060263.3731332.723936389513300302.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the nlinks now too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/nlinks.c        |    4 +
 fs/xfs/scrub/nlinks.h        |    5 +
 fs/xfs/scrub/nlinks_repair.c |  227 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c        |   37 +++++++
 fs/xfs/scrub/repair.h        |    3 +
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.h         |    3 +
 8 files changed, 279 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c80b68ada797..b97b7ea74109 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -191,6 +191,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   newbt.o \
+				   nlinks_repair.o \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 5f608905165e..e4d2d350190e 100644
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
index 34c59075b72c..c3c7e79efc3f 100644
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
index 000000000000..9ab098d85d17
--- /dev/null
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021-2023 Oracle.  All Rights Reserved.
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
+		goto out_iolock;
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
+		bool	overflow = xrep_set_nlink(ip, total_links);
+
+		if (overflow)
+			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		else
+			trace_xrep_nlinks_update_inode(mp, ip, &obs);
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
+	if (error)
+		goto out_ilock;
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	return 0;
+
+out_scanlock:
+	mutex_unlock(&xnc->lock);
+out_trans:
+	xchk_trans_cancel(sc);
+out_ilock:
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+out_iolock:
+	xchk_iunlock(sc, XFS_IOLOCK_EXCL);
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
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 5588f2c51a37..7b3d88230b5b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1133,3 +1133,40 @@ xrep_metadata_inode_forks(
 
 	return 0;
 }
+
+/*
+ * Set a file's link count, being careful about integer overflows.  Returns
+ * true if we had to correct an integer overflow.
+ */
+bool
+xrep_set_nlink(
+	struct xfs_inode	*ip,
+	uint64_t		nlink)
+{
+	bool			ret = false;
+
+	if (nlink > U32_MAX) {
+		/*
+		 * The observed link count will overflow the nlink field.
+		 *
+		 * The VFS won't let users create more hardlinks if the link
+		 * count is larger than XFS_MAXLINK, but it will let them
+		 * delete hardlinks.  XFS_MAXLINK is half of U32_MAX, which
+		 * means that sysadmins could actually fix this situation by
+		 * deleting links and calling us again.
+		 *
+		 * Set the link count to the largest possible value that will
+		 * fit in the field.  This will buy us the most possible time
+		 * to avoid a UAF should the sysadmins start deleting links.
+		 * As long as the link count stays above MAXLINK the undercount
+		 * problem will not get worse.
+		 */
+		BUILD_BUG_ON((uint64_t)XFS_MAXLINK >= U32_MAX);
+
+		nlink = U32_MAX;
+		ret = true;
+	}
+
+	set_nlink(VFS_I(ip), nlink);
+	return ret;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4f27ebeead92..e70b3afde39d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -76,6 +76,7 @@ int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
+bool xrep_set_nlink(struct xfs_inode *ip, uint64_t nlink);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -107,6 +108,7 @@ int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
+int xrep_nlinks(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -191,6 +193,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_rtbitmap			xrep_notsupported
 #define xrep_quota			xrep_notsupported
 #define xrep_quotacheck			xrep_notsupported
+#define xrep_nlinks			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 244fa9157d71..cfae97e3db04 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -377,7 +377,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_nlinks,
 		.scrub	= xchk_nlinks,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_nlinks,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0870edd76a5e..9df95fb67e78 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2004,6 +2004,9 @@ DEFINE_XREP_DQUOT_EVENT(xrep_disk_dquot);
 DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 #endif /* CONFIG_XFS_QUOTA */
 
+DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
+DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

