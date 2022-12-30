Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645D0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiL3Xf1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiL3Xf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:35:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262FA12D20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3D30B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77356C433EF;
        Fri, 30 Dec 2022 23:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443322;
        bh=rGRoDTaoqV/solGXsf5ODEa5pw6NOxQWYvwW7pvyv2U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ersTKKUlGAmB3wEwspaa5X3qeA8eN7Pp77qDzW/dy9f43Cgttw5xTw3V9w+L9NRLS
         NzlvdD8lInF/XHJgCTBd/AcPOXSFDYC1fLSFFWE1cpZtGo2GmGRuNi+WXAEUCacJrI
         RPxECh52gs5xJOU92s8dgo5w7f8MR1mnUSC8jkoljakSejDBomH6gD8pJ6phVdXDbr
         U1Movua6FPTanKIqLS/hiO9SB0JVFAcgyYl1kWHb2uF23BzRJY+r64atVxJ3Wft2Py
         9MHSS5HBa/NMLEadqMny/6gBPfvCgjS05BHOEZDm26Btra8FNzX3+skfqb16V+EL1N
         KxF+K0MkQr4Cw==
Subject: [PATCH 5/5] xfs: repair dquots based on live quotacheck results
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:07 -0800
Message-ID: <167243838763.695667.11428863914800891961.stgit@magnolia>
In-Reply-To: <167243838686.695667.4884256571173103690.stgit@magnolia>
References: <167243838686.695667.4884256571173103690.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the shadow quota counters that live quotacheck creates to reset the
incore dquot counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/scrub/quotacheck.c        |    9 +
 fs/xfs/scrub/quotacheck.h        |    3 
 fs/xfs/scrub/quotacheck_repair.c |  254 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c            |   13 +-
 fs/xfs/scrub/repair.h            |    5 +
 fs/xfs/scrub/scrub.c             |    2 
 fs/xfs/scrub/trace.h             |    1 
 8 files changed, 281 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/scrub/quotacheck_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 62398f7332a1..30e555eac02e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -199,6 +199,7 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
 				   quota_repair.o \
+				   quotacheck_repair.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index b9162556d00e..10d0fd717aea 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -101,7 +101,9 @@ xchk_setup_quotacheck(
  * set the INCOMPLETE flag even when a negative errno is returned.  This care
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
- * xchk_*_process_error.
+ * xchk_*_process_error.  Scrub and repair share the same incore data
+ * structures, so the INCOMPLETE flag is critical to prevent a repair based on
+ * insufficient information.
  *
  * Because we are scanning a live filesystem, it's possible that another thread
  * will try to update the quota counters for an inode that we've already
@@ -405,11 +407,14 @@ xqcheck_collect_inode(
 
 	/* Figure out the data / rt device block counts. */
 	xfs_ilock(ip, XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED);
-	ilock_flags = xfs_ilock_data_map_shared(ip);
 	if (XFS_IS_REALTIME_INODE(ip)) {
+		ilock_flags = xfs_ilock_data_map_shared(ip);
 		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 		if (error)
 			goto out_abort;
+	} else {
+		ilock_flags = XFS_ILOCK_SHARED;
+		xfs_ilock(ip, ilock_flags);
 	}
 	xfs_inode_count_blocks(tp, ip, &nblks, &rtblks);
 
diff --git a/fs/xfs/scrub/quotacheck.h b/fs/xfs/scrub/quotacheck.h
index 6dc55686ad39..ccb3a9ffb168 100644
--- a/fs/xfs/scrub/quotacheck.h
+++ b/fs/xfs/scrub/quotacheck.h
@@ -30,6 +30,9 @@ struct xqcheck_dquot {
 /* Already checked this dquot. */
 #define XQCHECK_DQUOT_COMPARE_SCANNED	(1U << 1)
 
+/* Already repaired this dquot. */
+#define XQCHECK_DQUOT_REPAIR_SCANNED	(1U << 2)
+
 /* Live quotacheck control structure. */
 struct xqcheck {
 	struct xfs_scrub	*sc;
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
new file mode 100644
index 000000000000..c7e5941366b8
--- /dev/null
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -0,0 +1,254 @@
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
+#include "xfs_quota.h"
+#include "xfs_qm.h"
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
+#include "scrub/quotacheck.h"
+#include "scrub/trace.h"
+
+/*
+ * Live Quotacheck Repair
+ * ======================
+ *
+ * Use the live quota counter information that we collected to replace the
+ * counter values in the incore dquots.  A scrub->repair cycle should have left
+ * the live data and hooks active, so this is safe so long as we make sure the
+ * dquot is locked.
+ */
+
+/* Commit new counters to a dquot. */
+static int
+xqcheck_commit_dquot(
+	struct xfs_dquot	*dqp,
+	xfs_dqtype_t		dqtype,
+	void			*priv)
+{
+	struct xqcheck_dquot	xcdq;
+	struct xqcheck		*xqc = priv;
+	struct xfarray		*counts = xqcheck_counters_for(xqc, dqtype);
+	int64_t			delta;
+	bool			dirty = false;
+	int			error = 0;
+
+	/* Unlock the dquot just long enough to allocate a transaction. */
+	xfs_dqunlock(dqp);
+	error = xchk_trans_alloc(xqc->sc, 0);
+	xfs_dqlock(dqp);
+	if (error)
+		return error;
+
+	xfs_trans_dqjoin(xqc->sc->tp, dqp);
+
+	if (xchk_iscan_aborted(&xqc->iscan)) {
+		error = -ECANCELED;
+		goto out_cancel;
+	}
+
+	mutex_lock(&xqc->lock);
+	error = xfarray_load_sparse(counts, dqp->q_id, &xcdq);
+	if (error)
+		goto out_unlock;
+
+	/* Adjust counters as needed. */
+	delta = (int64_t)xcdq.icount - dqp->q_ino.count;
+	if (delta) {
+		dqp->q_ino.reserved += delta;
+		dqp->q_ino.count += delta;
+		dirty = true;
+	}
+
+	delta = (int64_t)xcdq.bcount - dqp->q_blk.count;
+	if (delta) {
+		dqp->q_blk.reserved += delta;
+		dqp->q_blk.count += delta;
+		dirty = true;
+	}
+
+	delta = (int64_t)xcdq.rtbcount - dqp->q_rtb.count;
+	if (delta) {
+		dqp->q_rtb.reserved += delta;
+		dqp->q_rtb.count += delta;
+		dirty = true;
+	}
+
+	xcdq.flags |= (XQCHECK_DQUOT_REPAIR_SCANNED | XQCHECK_DQUOT_WRITTEN);
+	error = xfarray_store(counts, dqp->q_id, &xcdq);
+	if (error == -EFBIG) {
+		/*
+		 * EFBIG means we tried to store data at too high a byte offset
+		 * in the sparse array.  IOWs, we cannot complete the repair
+		 * and must cancel the whole operation.  This should never
+		 * happen, but we need to catch it anyway.
+		 */
+		error = -ECANCELED;
+	}
+	mutex_unlock(&xqc->lock);
+	if (error || !dirty)
+		goto out_cancel;
+
+	trace_xrep_quotacheck_dquot(xqc->sc->mp, dqp->q_type, dqp->q_id);
+
+	/* Commit the dirty dquot to disk. */
+	dqp->q_flags |= XFS_DQFLAG_DIRTY;
+	if (dqp->q_id)
+		xfs_qm_adjust_dqtimers(dqp);
+	xfs_trans_log_dquot(xqc->sc->tp, dqp);
+
+	/*
+	 * Transaction commit unlocks the dquot, so we must re-lock it so that
+	 * the caller can put the reference (which apparently requires a locked
+	 * dquot).
+	 */
+	error = xrep_trans_commit(xqc->sc);
+	xfs_dqlock(dqp);
+	return error;
+
+out_unlock:
+	mutex_unlock(&xqc->lock);
+out_cancel:
+	xchk_trans_cancel(xqc->sc);
+
+	/* Re-lock the dquot so the caller can put the reference. */
+	xfs_dqlock(dqp);
+	return error;
+}
+
+/* Commit new quota counters for a particular quota type. */
+STATIC int
+xqcheck_commit_dqtype(
+	struct xqcheck		*xqc,
+	unsigned int		dqtype)
+{
+	struct xqcheck_dquot	xcdq;
+	struct xfs_scrub	*sc = xqc->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfarray		*counts = xqcheck_counters_for(xqc, dqtype);
+	struct xfs_dquot	*dqp;
+	xfarray_idx_t		cur = XFARRAY_CURSOR_INIT;
+	int			error;
+
+	/*
+	 * Update the counters of every dquot that the quota file knows about.
+	 */
+	error = xfs_qm_dqiterate(mp, dqtype, xqcheck_commit_dquot, xqc);
+	if (error)
+		return error;
+
+	/*
+	 * Make a second pass to deal with the dquots that we know about but
+	 * the quota file previously did not know about.
+	 */
+	mutex_lock(&xqc->lock);
+	while ((error = xfarray_iter(counts, &cur, &xcdq)) == 1) {
+		xfs_dqid_t	id = cur - 1;
+
+		if (xcdq.flags & XQCHECK_DQUOT_REPAIR_SCANNED)
+			continue;
+
+		mutex_unlock(&xqc->lock);
+
+		/*
+		 * Grab the dquot, allowing for dquot block allocation in a
+		 * separate transaction.  We committed the scrub transaction
+		 * in a previous step, so we will not be creating nested
+		 * transactions here.
+		 */
+		error = xfs_qm_dqget(mp, id, dqtype, true, &dqp);
+		if (error)
+			return error;
+
+		error = xqcheck_commit_dquot(dqp, dqtype, xqc);
+		xfs_qm_dqput(dqp);
+		if (error)
+			return error;
+
+		mutex_lock(&xqc->lock);
+	}
+	mutex_unlock(&xqc->lock);
+
+	return error;
+}
+
+/* Figure out quota CHKD flags for the running quota types. */
+static inline unsigned int
+xqcheck_chkd_flags(
+	struct xfs_mount	*mp)
+{
+	unsigned int		ret = 0;
+
+	if (XFS_IS_UQUOTA_ON(mp))
+		ret |= XFS_UQUOTA_CHKD;
+	if (XFS_IS_GQUOTA_ON(mp))
+		ret |= XFS_GQUOTA_CHKD;
+	if (XFS_IS_PQUOTA_ON(mp))
+		ret |= XFS_PQUOTA_CHKD;
+	return ret;
+}
+
+/* Commit the new dquot counters. */
+int
+xrep_quotacheck(
+	struct xfs_scrub	*sc)
+{
+	struct xqcheck		*xqc = sc->buf;
+	unsigned int		qflags = xqcheck_chkd_flags(sc->mp);
+	int			error;
+
+	/*
+	 * Clear the CHKD flag for the running quota types and commit the scrub
+	 * transaction so that we can allocate new quota block mappings if we
+	 * have to.  If we crash after this point, the sb still has the CHKD
+	 * flags cleared, so mount quotacheck will fix all of this up.
+	 */
+	xrep_update_qflags(sc, qflags, 0);
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	/* Commit the new counters to the dquots. */
+	if (xqc->ucounts) {
+		error = xqcheck_commit_dqtype(xqc, XFS_DQTYPE_USER);
+		if (error)
+			return error;
+	}
+	if (xqc->gcounts) {
+		error = xqcheck_commit_dqtype(xqc, XFS_DQTYPE_GROUP);
+		if (error)
+			return error;
+	}
+	if (xqc->pcounts) {
+		error = xqcheck_commit_dqtype(xqc, XFS_DQTYPE_PROJ);
+		if (error)
+			return error;
+	}
+
+	/* Set the CHKD flags now that we've fixed quota counts. */
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	xrep_update_qflags(sc, 0, qflags);
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 539c3544b11a..7f66c763580b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -679,21 +679,26 @@ xrep_find_ag_btree_roots(
 
 #ifdef CONFIG_XFS_QUOTA
 /* Update some quota flags in the superblock. */
-static void
+void
 xrep_update_qflags(
 	struct xfs_scrub	*sc,
-	unsigned int		clear_flags)
+	unsigned int		clear_flags,
+	unsigned int		set_flags)
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*bp;
 
 	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
-	if ((mp->m_qflags & clear_flags) == 0)
+	if ((mp->m_qflags & clear_flags) == 0 &&
+	    (mp->m_qflags & set_flags) == set_flags)
 		goto no_update;
 
 	mp->m_qflags &= ~clear_flags;
+	mp->m_qflags |= set_flags;
+
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_qflags &= ~clear_flags;
+	mp->m_sb.sb_qflags |= set_flags;
 	spin_unlock(&mp->m_sb_lock);
 
 	/*
@@ -723,7 +728,7 @@ xrep_force_quotacheck(
 	if (!(flag & sc->mp->m_qflags))
 		return;
 
-	xrep_update_qflags(sc, flag);
+	xrep_update_qflags(sc, flag, 0);
 }
 
 /*
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 16047fc42696..f8d356b17b1f 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -62,6 +62,8 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
 
 #ifdef CONFIG_XFS_QUOTA
+void xrep_update_qflags(struct xfs_scrub *sc, unsigned int clear_flags,
+		unsigned int set_flags);
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 #else
@@ -114,8 +116,10 @@ int xrep_rtbitmap(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_QUOTA
 int xrep_quota(struct xfs_scrub *sc);
+int xrep_quotacheck(struct xfs_scrub *sc);
 #else
 # define xrep_quota			xrep_notsupported
+# define xrep_quotacheck		xrep_notsupported
 #endif /* CONFIG_XFS_QUOTA */
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
@@ -186,6 +190,7 @@ static inline int xrep_setup_rtbitmap(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_bmap_cow			xrep_notsupported
 #define xrep_rtbitmap			xrep_notsupported
 #define xrep_quota			xrep_notsupported
+#define xrep_quotacheck			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index db277b57e8a2..60c6665b6277 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -370,7 +370,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_quotacheck,
 		.scrub	= xchk_quotacheck,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_quotacheck,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f8ee323a3cd2..2a025eb356fc 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1762,6 +1762,7 @@ DEFINE_EVENT(xrep_dquot_class, name, \
 	TP_ARGS(mp, type, id))
 DEFINE_XREP_DQUOT_EVENT(xrep_dquot_item);
 DEFINE_XREP_DQUOT_EVENT(xrep_disk_dquot);
+DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 #endif /* CONFIG_XFS_QUOTA */
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */

