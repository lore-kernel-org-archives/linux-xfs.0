Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAC2C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiL3Xgq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiL3Xgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:36:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAEAAE5C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:36:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 34162CE19BD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB28C433EF;
        Fri, 30 Dec 2022 23:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443400;
        bh=4kzZUey9x3YiMSC5NL/OIfytj4Gn5GVLQQSoCsZVev0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o3E9eaTC8x6bwgEl0740ntRhagrYfeFoZwDZfYNqsS220hk98+A1vFNaZe4aCoAfO
         PdyjXOXQXnt+m5YrtYzdbH4wns6F+vq5nrX6pizhfxHz58dYVTzgF6xMT7gmsjdPdb
         Q7YYgXWkgeN6cuQATddlPISGHAqmG7BS43hT9UNT2DxnZndrToh1StaICH6zliYEIH
         ozv6gKj3Mh4Js0iqrRwjhNx0a/9klW8JfDLsvOQNgqmkvSquKEeja3geLrn1oFpEam
         CmtGopexthOCg+82ewYcdDLrYxO/12yauLMX0/Dve5byZaOj0vyWtiR2HrAzzTz4f6
         36f6vZwSt78Bg==
Subject: [PATCH 5/5] xfs: teach repair to fix file nlinks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:11 -0800
Message-ID: <167243839141.695835.17217796122689502779.stgit@magnolia>
In-Reply-To: <167243839062.695835.16105316950703126803.stgit@magnolia>
References: <167243839062.695835.16105316950703126803.stgit@magnolia>
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
 fs/xfs/scrub/nlinks_repair.c |  226 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.h         |    3 +
 7 files changed, 240 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ea9eda20a11d..a69c5585e41c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -190,6 +190,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   newbt.o \
+				   nlinks_repair.o \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 49ac7904896f..e29d7da2eb32 100644
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
index 69cf556b15a3..46baef3c2237 100644
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
 xchk_nlink_total(const struct xchk_nlink *live)
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
new file mode 100644
index 000000000000..2f83abd6eec7
--- /dev/null
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+	unsigned int		actual_nlink;
+	int			error;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &sc->tp);
+	if (error)
+		goto out_iolock;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
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
+	total_links = xchk_nlink_total(&obs);
+	actual_nlink = VFS_I(ip)->i_nlink;
+
+	/*
+	 * Cannot set more than the maxiumum possible link count.  We won't
+	 * touch this file, but we don't want to abort the entire operation,
+	 * so set an explicit error value to avoid static checker warnings and
+	 * return early.
+	 */
+	if (total_links > U32_MAX) {
+		trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		goto out_nextfile;
+	}
+
+	/*
+	 * Linked directories should have at least one "child" (the dot entry)
+	 * pointing up to them.
+	 */
+	if (S_ISDIR(VFS_I(ip)->i_mode) && actual_nlink > 0 &&
+					  obs.children == 0) {
+		trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		goto out_nextfile;
+	}
+
+	/* Non-directories cannot have directories pointing up to them. */
+	if (!S_ISDIR(VFS_I(ip)->i_mode) && obs.children != 0) {
+		trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		goto out_nextfile;
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
+		goto out_nextfile;
+	}
+
+	/* Perfect match means we're done with this file. */
+	if (total_links == actual_nlink)
+		goto out_nextfile;
+
+	mutex_unlock(&xnc->lock);
+
+	/* Commit the new link count. */
+	trace_xrep_nlinks_update_inode(mp, ip, &obs);
+
+	set_nlink(VFS_I(ip), total_links);
+	xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(sc->tp);
+	sc->tp = NULL;
+	if (error)
+		goto out_ilock;
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return 0;
+
+out_nextfile:
+	error = 0;
+out_scanlock:
+	mutex_unlock(&xnc->lock);
+	xchk_trans_cancel(sc);
+out_ilock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
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
+		error = xchk_iscan_iter(xnc->sc, &xnc->compare_iscan, ipp);
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
+	xchk_iscan_start(&xnc->compare_iscan, 30000, 100);
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
+	xchk_iscan_finish(&xnc->compare_iscan);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index f8d356b17b1f..6c19f0d7f335 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -107,6 +107,7 @@ int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
+int xrep_nlinks(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -191,6 +192,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_rtbitmap			xrep_notsupported
 #define xrep_quota			xrep_notsupported
 #define xrep_quotacheck			xrep_notsupported
+#define xrep_nlinks			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7e06aa98ca82..2c05fbde1f88 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -379,7 +379,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_nlinks,
 		.scrub	= xchk_nlinks,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_nlinks,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 25acfff8fe6b..dcbab5a197c1 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1953,6 +1953,9 @@ DEFINE_XREP_DQUOT_EVENT(xrep_disk_dquot);
 DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 #endif /* CONFIG_XFS_QUOTA */
 
+DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
+DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

