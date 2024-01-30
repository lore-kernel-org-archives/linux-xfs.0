Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70AD376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591291; cv=none; b=CQe/ZFxJhd62NJr71HDTaFbkY2I3nnPEQZ8PsSlkPF3TmT+2o8TozE0auDI63vtpJcuhDz8XCvrv8TMHeosQw7MSM0dYaDBoJjS5RDJkhyRB3Ejk1384K0m4y8O+lnMU41sAOoTIhAXmCdAY8jNidjvOVbMKP0agB1/Q7wdcE7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591291; c=relaxed/simple;
	bh=rULpHIqFMLlahkJ90sGVlBfG76AqRJa/5mMt/7cpFhU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nkoMrzuk91k+ynkGJQTi6zaK2Hf6+D+xjqnbroW7hJopjJIQTAGXkIHeCV/kHRKWEOP6/1wzYczSImvw/UU5tzXZc6J8xjIa1zHAfNHZbe0esHQosN/0qU9e4C9QZpTIaIIvl1FdcVwBvOjD2yOMhvkwHswZXis4/Ktqg+3mwpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jM0IJ+EK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jM0IJ+EK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91809C433F1;
	Tue, 30 Jan 2024 05:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591291;
	bh=rULpHIqFMLlahkJ90sGVlBfG76AqRJa/5mMt/7cpFhU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jM0IJ+EKfZHU0MImDxTkg5fIU7I+KRpZJ8147P4DXVYECUjBNc7jh6b1/F5w0fEiS
	 zPE7Q9K+fqUpUcCKPMznC4hv8Mdyv7QdGxXxYtBVq1bIW2+v2fkCxxvmZQWAp2X9Ye
	 JCbObb1dnYIgOYncw+jw5SmDm0NR4qSUo5Q4bVpN3DBhF+tS7uTMwhrd4/KgBothA4
	 yOBIejxQNPLqOj+Jepi+UfeYRRZvEdnvQ/xl8GYddpndwy63Gmh9sDQhpiGVeKJbrI
	 wmZSCMjXpWSBLLPjUnKH3iVj0JgqdAbhzaUsxoKSaURIhV/4TnqofgbtCi6dcGRnsP
	 RLFMs4Pgfw/6A==
Date: Mon, 29 Jan 2024 21:08:11 -0800
Subject: [PATCH 8/8] xfs: repair dquots based on live quotacheck results
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659062885.3353369.14154590610670604835.stgit@frogsfrogsfrogs>
In-Reply-To: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
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

Use the shadow quota counters that live quotacheck creates to reset the
incore dquot counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/scrub/quotacheck.c        |    4 -
 fs/xfs/scrub/quotacheck.h        |    3 
 fs/xfs/scrub/quotacheck_repair.c |  261 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c            |   13 +-
 fs/xfs/scrub/repair.h            |    5 +
 fs/xfs/scrub/scrub.c             |    2 
 fs/xfs/scrub/trace.h             |    1 
 8 files changed, 284 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/scrub/quotacheck_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 12266812fa107..563178216393f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -205,6 +205,7 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
 				   quota_repair.o \
+				   quotacheck_repair.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index 123a9c60847b5..46aa2392470ce 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -102,7 +102,9 @@ xchk_setup_quotacheck(
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
diff --git a/fs/xfs/scrub/quotacheck.h b/fs/xfs/scrub/quotacheck.h
index 3615fec3e409e..4726fc63c8fe4 100644
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
index 0000000000000..dd8554c755b5b
--- /dev/null
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
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
+#include "scrub/quota.h"
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
+	struct xqcheck		*xqc,
+	xfs_dqtype_t		dqtype,
+	struct xfs_dquot	*dq)
+{
+	struct xqcheck_dquot	xcdq;
+	struct xfarray		*counts = xqcheck_counters_for(xqc, dqtype);
+	int64_t			delta;
+	bool			dirty = false;
+	int			error = 0;
+
+	/* Unlock the dquot just long enough to allocate a transaction. */
+	xfs_dqunlock(dq);
+	error = xchk_trans_alloc(xqc->sc, 0);
+	xfs_dqlock(dq);
+	if (error)
+		return error;
+
+	xfs_trans_dqjoin(xqc->sc->tp, dq);
+
+	if (xchk_iscan_aborted(&xqc->iscan)) {
+		error = -ECANCELED;
+		goto out_cancel;
+	}
+
+	mutex_lock(&xqc->lock);
+	error = xfarray_load_sparse(counts, dq->q_id, &xcdq);
+	if (error)
+		goto out_unlock;
+
+	/* Adjust counters as needed. */
+	delta = (int64_t)xcdq.icount - dq->q_ino.count;
+	if (delta) {
+		dq->q_ino.reserved += delta;
+		dq->q_ino.count += delta;
+		dirty = true;
+	}
+
+	delta = (int64_t)xcdq.bcount - dq->q_blk.count;
+	if (delta) {
+		dq->q_blk.reserved += delta;
+		dq->q_blk.count += delta;
+		dirty = true;
+	}
+
+	delta = (int64_t)xcdq.rtbcount - dq->q_rtb.count;
+	if (delta) {
+		dq->q_rtb.reserved += delta;
+		dq->q_rtb.count += delta;
+		dirty = true;
+	}
+
+	xcdq.flags |= (XQCHECK_DQUOT_REPAIR_SCANNED | XQCHECK_DQUOT_WRITTEN);
+	error = xfarray_store(counts, dq->q_id, &xcdq);
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
+	trace_xrep_quotacheck_dquot(xqc->sc->mp, dq->q_type, dq->q_id);
+
+	/* Commit the dirty dquot to disk. */
+	dq->q_flags |= XFS_DQFLAG_DIRTY;
+	if (dq->q_id)
+		xfs_qm_adjust_dqtimers(dq);
+	xfs_trans_log_dquot(xqc->sc->tp, dq);
+
+	/*
+	 * Transaction commit unlocks the dquot, so we must re-lock it so that
+	 * the caller can put the reference (which apparently requires a locked
+	 * dquot).
+	 */
+	error = xrep_trans_commit(xqc->sc);
+	xfs_dqlock(dq);
+	return error;
+
+out_unlock:
+	mutex_unlock(&xqc->lock);
+out_cancel:
+	xchk_trans_cancel(xqc->sc);
+
+	/* Re-lock the dquot so the caller can put the reference. */
+	xfs_dqlock(dq);
+	return error;
+}
+
+/* Commit new quota counters for a particular quota type. */
+STATIC int
+xqcheck_commit_dqtype(
+	struct xqcheck		*xqc,
+	unsigned int		dqtype)
+{
+	struct xchk_dqiter	cursor = { };
+	struct xqcheck_dquot	xcdq;
+	struct xfs_scrub	*sc = xqc->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfarray		*counts = xqcheck_counters_for(xqc, dqtype);
+	struct xfs_dquot	*dq;
+	xfarray_idx_t		cur = XFARRAY_CURSOR_INIT;
+	int			error;
+
+	/*
+	 * Update the counters of every dquot that the quota file knows about.
+	 */
+	xchk_dqiter_init(&cursor, sc, dqtype);
+	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		error = xqcheck_commit_dquot(xqc, dqtype, dq);
+		xfs_qm_dqput(dq);
+		if (error)
+			break;
+	}
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
+		error = xfs_qm_dqget(mp, id, dqtype, true, &dq);
+		if (error)
+			return error;
+
+		error = xqcheck_commit_dquot(xqc, dqtype, dq);
+		xfs_qm_dqput(dq);
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
+	return xrep_trans_commit(sc);
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3d2c4dbb6909e..7141b17789028 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -688,21 +688,26 @@ xrep_find_ag_btree_roots(
 
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
@@ -732,7 +737,7 @@ xrep_force_quotacheck(
 	if (!(flag & sc->mp->m_qflags))
 		return;
 
-	xrep_update_qflags(sc, flag);
+	xrep_update_qflags(sc, flag, 0);
 }
 
 /*
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 17114327e6fa7..fdfa066999218 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -72,6 +72,8 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
 
 #ifdef CONFIG_XFS_QUOTA
+void xrep_update_qflags(struct xfs_scrub *sc, unsigned int clear_flags,
+		unsigned int set_flags);
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 #else
@@ -123,8 +125,10 @@ int xrep_rtbitmap(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_QUOTA
 int xrep_quota(struct xfs_scrub *sc);
+int xrep_quotacheck(struct xfs_scrub *sc);
 #else
 # define xrep_quota			xrep_notsupported
+# define xrep_quotacheck		xrep_notsupported
 #endif /* CONFIG_XFS_QUOTA */
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
@@ -191,6 +195,7 @@ xrep_setup_nothing(
 #define xrep_bmap_cow			xrep_notsupported
 #define xrep_rtbitmap			xrep_notsupported
 #define xrep_quota			xrep_notsupported
+#define xrep_quotacheck			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 71a9eb48e1de7..9112c0985c62b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -367,7 +367,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_quotacheck,
 		.scrub	= xchk_quotacheck,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_quotacheck,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 6c90bc7a316b8..fedcebf90a420 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2004,6 +2004,7 @@ DEFINE_EVENT(xrep_dquot_class, name, \
 DEFINE_XREP_DQUOT_EVENT(xrep_dquot_item);
 DEFINE_XREP_DQUOT_EVENT(xrep_disk_dquot);
 DEFINE_XREP_DQUOT_EVENT(xrep_dquot_item_fill_bmap_hole);
+DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 #endif /* CONFIG_XFS_QUOTA */
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */

