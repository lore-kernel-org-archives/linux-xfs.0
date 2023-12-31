Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715A5BA31
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSeXO7dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C62C433C8;
	Sun, 31 Dec 2023 20:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053286;
	bh=0N4qwDN1wIDmutqEB8YySI0USh881gAYlMJLF9Vmnh0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nSeXO7dt5M/wzm+NOLqIGLvclBbTxFklkBwWilhOrIUKUXityKB4jVafLNy82lKvj
	 L1T29rHc2MtdokB8/zDFvnBOmyvXrRUZyh8S6sd8FQZnDORaTKClg9NVJjg82oI/rH
	 Pu0NYjl6IjHQmtm3BqQwGpSq7xeQHGZVtysHngv0UNr8gF3mrLf3AgH5e5NuCChLWG
	 vLCzhWaFFPBzOAcADxadhb8+tppCG2hdgxB633lmEkh6cUpdOQv+RN4Nj3vIK2qwlV
	 Bywip89tJ5sSbJ196yFRmbRzc7HNzryJ0LSHPLL56NNoaiz23JcmtUyTNdMrhV1CUf
	 NmK1ucNvHThVg==
Date: Sun, 31 Dec 2023 12:08:05 -0800
Subject: [PATCH 3/5] xfs: track quota updates during live quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827443.1748002.15261136808573289859.stgit@frogsfrogsfrogs>
In-Reply-To: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
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

Create a shadow dqtrx system in the quotacheck code that hooks the
regular dquot counter update code.  This will be the means to keep our
copy of the dquot counters up to date while the scan runs in real time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c     |    4 +
 fs/xfs/scrub/quotacheck.c |  358 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/quotacheck.h |    6 +
 fs/xfs/scrub/scrub.c      |    3 
 fs/xfs/scrub/scrub.h      |    4 -
 fs/xfs/scrub/trace.h      |    1 
 fs/xfs/xfs_qm.c           |   16 +-
 fs/xfs/xfs_qm.h           |   16 ++
 fs/xfs/xfs_qm_bhv.c       |    1 
 fs/xfs/xfs_quota.h        |   45 ++++++
 fs/xfs/xfs_trans_dquot.c  |  156 +++++++++++++++++++-
 11 files changed, 594 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index fc23bd9d38195..6e193aee12666 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -30,6 +30,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_error.h"
+#include "xfs_quota.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1298,6 +1299,9 @@ xchk_fsgates_enable(
 	if (scrub_fsgates & XCHK_FSGATES_DRAIN)
 		xfs_drain_wait_enable();
 
+	if (scrub_fsgates & XCHK_FSGATES_QUOTA)
+		xfs_dqtrx_hook_enable();
+
 	sc->flags |= scrub_fsgates;
 }
 
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index 79a6ac25419d7..d1597838cdac4 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -38,17 +38,54 @@
  * creating a shadow quota counter structure and walking every inode.
  */
 
+/* Track the quota deltas for a dquot in a transaction. */
+struct xqcheck_dqtrx {
+	xfs_dqtype_t		q_type;
+	xfs_dqid_t		q_id;
+
+	int64_t			icount_delta;
+
+	int64_t			bcount_delta;
+	int64_t			delbcnt_delta;
+
+	int64_t			rtbcount_delta;
+	int64_t			delrtb_delta;
+};
+
+#define XQCHECK_MAX_NR_DQTRXS	(XFS_QM_TRANS_DQTYPES * XFS_QM_TRANS_MAXDQS)
+
+/*
+ * Track the quota deltas for all dquots attached to a transaction if the
+ * quota deltas are being applied to an inode that we already scanned.
+ */
+struct xqcheck_dqacct {
+	struct rhash_head	hash;
+	uintptr_t		tx_id;
+	struct xqcheck_dqtrx	dqtrx[XQCHECK_MAX_NR_DQTRXS];
+	unsigned int		refcount;
+};
+
+/* Free a shadow dquot accounting structure. */
+static void
+xqcheck_dqacct_free(
+	void			*ptr,
+	void			*arg)
+{
+	struct xqcheck_dqacct	*dqa = ptr;
+
+	kfree(dqa);
+}
+
 /* Set us up to scrub quota counters. */
 int
 xchk_setup_quotacheck(
 	struct xfs_scrub	*sc)
 {
-	/* Not ready for general consumption yet. */
-	return -EOPNOTSUPP;
-
 	if (!XFS_IS_QUOTA_ON(sc->mp))
 		return -ENOENT;
 
+	xchk_fsgates_enable(sc, XCHK_FSGATES_QUOTA);
+
 	sc->buf = kzalloc(sizeof(struct xqcheck), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
@@ -66,6 +103,22 @@ xchk_setup_quotacheck(
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
  * xchk_*_process_error.
+ *
+ * Because we are scanning a live filesystem, it's possible that another thread
+ * will try to update the quota counters for an inode that we've already
+ * scanned.  This will cause our counts to be incorrect.  Therefore, we hook
+ * the live transaction code in two places: (1) when the callers update the
+ * per-transaction dqtrx structure to log quota counter updates; and (2) when
+ * transaction commit actually logs those updates to the incore dquot.  By
+ * shadowing transaction updates in this manner, live quotacheck can ensure
+ * by locking the dquot and the shadow structure that its own copies are not
+ * out of date.  Because the hook code runs in a different process context from
+ * the scrub code and the scrub state flags are not accessed atomically,
+ * failures in the hook code must abort the iscan and the scrubber must notice
+ * the aborted scan and set the incomplete flag.
+ *
+ * Note that we use srcu notifier hooks to minimize the overhead when live
+ * quotacheck is /not/ running.
  */
 
 /* Update an incore dquot counter information from a live update. */
@@ -102,6 +155,234 @@ xqcheck_update_incore_counts(
 	return error;
 }
 
+/* Decide if this is the shadow dquot accounting structure for a transaction. */
+static int
+xqcheck_dqacct_obj_cmpfn(
+	struct rhashtable_compare_arg	*arg,
+	const void			*obj)
+{
+	const uintptr_t			*tx_idp = arg->key;
+	const struct xqcheck_dqacct	*dqa = obj;
+
+	if (dqa->tx_id != *tx_idp)
+		return 1;
+	return 0;
+}
+
+static const struct rhashtable_params xqcheck_dqacct_hash_params = {
+	.min_size		= 32,
+	.key_len		= sizeof(uintptr_t),
+	.key_offset		= offsetof(struct xqcheck_dqacct, tx_id),
+	.head_offset		= offsetof(struct xqcheck_dqacct, hash),
+	.automatic_shrinking	= true,
+	.obj_cmpfn		= xqcheck_dqacct_obj_cmpfn,
+};
+
+/* Find a shadow dqtrx slot for the given dquot. */
+STATIC struct xqcheck_dqtrx *
+xqcheck_get_dqtrx(
+	struct xqcheck_dqacct	*dqa,
+	xfs_dqtype_t		q_type,
+	xfs_dqid_t		q_id)
+{
+	int			i;
+
+	for (i = 0; i < XQCHECK_MAX_NR_DQTRXS; i++) {
+		if (dqa->dqtrx[i].q_type == 0 ||
+		    (dqa->dqtrx[i].q_type == q_type &&
+		     dqa->dqtrx[i].q_id == q_id))
+			return &dqa->dqtrx[i];
+	}
+
+	return NULL;
+}
+
+/*
+ * Create and fill out a quota delta tracking structure to shadow the updates
+ * going on in the regular quota code.
+ */
+static int
+xqcheck_mod_live_ino_dqtrx(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_mod_ino_dqtrx_params *p = data;
+	struct xqcheck			*xqc;
+	struct xqcheck_dqacct		*dqa;
+	struct xqcheck_dqtrx		*dqtrx;
+	int				error;
+
+	xqc = container_of(nb, struct xqcheck, hooks.mod_hook.nb);
+
+	/* Skip quota reservation fields. */
+	switch (action) {
+	case XFS_TRANS_DQ_BCOUNT:
+	case XFS_TRANS_DQ_DELBCOUNT:
+	case XFS_TRANS_DQ_ICOUNT:
+	case XFS_TRANS_DQ_RTBCOUNT:
+	case XFS_TRANS_DQ_DELRTBCOUNT:
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	/* Ignore dqtrx updates for quota types we don't care about. */
+	switch (p->q_type) {
+	case XFS_DQTYPE_USER:
+		if (!xqc->ucounts)
+			return NOTIFY_DONE;
+		break;
+	case XFS_DQTYPE_GROUP:
+		if (!xqc->gcounts)
+			return NOTIFY_DONE;
+		break;
+	case XFS_DQTYPE_PROJ:
+		if (!xqc->pcounts)
+			return NOTIFY_DONE;
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	/* Skip inodes that haven't been scanned yet. */
+	if (!xchk_iscan_want_live_update(&xqc->iscan, p->ino))
+		return NOTIFY_DONE;
+
+	/* Make a shadow quota accounting tracker for this transaction. */
+	mutex_lock(&xqc->lock);
+	dqa = rhashtable_lookup_fast(&xqc->shadow_dquot_acct, &p->tx_id,
+			xqcheck_dqacct_hash_params);
+	if (!dqa) {
+		dqa = kzalloc(sizeof(struct xqcheck_dqacct), XCHK_GFP_FLAGS);
+		if (!dqa)
+			goto out_abort;
+
+		dqa->tx_id = p->tx_id;
+		error = rhashtable_insert_fast(&xqc->shadow_dquot_acct,
+				&dqa->hash, xqcheck_dqacct_hash_params);
+		if (error)
+			goto out_abort;
+	}
+
+	/* Find the shadow dqtrx (or an empty slot) here. */
+	dqtrx = xqcheck_get_dqtrx(dqa, p->q_type, p->q_id);
+	if (!dqtrx)
+		goto out_abort;
+	if (dqtrx->q_type == 0) {
+		dqtrx->q_type = p->q_type;
+		dqtrx->q_id = p->q_id;
+		dqa->refcount++;
+	}
+
+	/* Update counter */
+	switch (action) {
+	case XFS_TRANS_DQ_BCOUNT:
+		dqtrx->bcount_delta += p->delta;
+		break;
+	case XFS_TRANS_DQ_DELBCOUNT:
+		dqtrx->delbcnt_delta += p->delta;
+		break;
+	case XFS_TRANS_DQ_ICOUNT:
+		dqtrx->icount_delta += p->delta;
+		break;
+	case XFS_TRANS_DQ_RTBCOUNT:
+		dqtrx->rtbcount_delta += p->delta;
+		break;
+	case XFS_TRANS_DQ_DELRTBCOUNT:
+		dqtrx->delrtb_delta += p->delta;
+		break;
+	}
+
+	mutex_unlock(&xqc->lock);
+	return NOTIFY_DONE;
+
+out_abort:
+	xchk_iscan_abort(&xqc->iscan);
+	mutex_unlock(&xqc->lock);
+	return NOTIFY_DONE;
+}
+
+/*
+ * Apply the transaction quota deltas to our shadow quota accounting info when
+ * the regular quota code are doing the same.
+ */
+static int
+xqcheck_apply_live_dqtrx(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_apply_dqtrx_params	*p = data;
+	struct xqcheck			*xqc;
+	struct xqcheck_dqacct		*dqa;
+	struct xqcheck_dqtrx		*dqtrx;
+	struct xfarray			*counts;
+	int				error;
+
+	xqc = container_of(nb, struct xqcheck, hooks.apply_hook.nb);
+
+	/* Map the dquot type to an incore counter object. */
+	switch (p->q_type) {
+	case XFS_DQTYPE_USER:
+		counts = xqc->ucounts;
+		break;
+	case XFS_DQTYPE_GROUP:
+		counts = xqc->gcounts;
+		break;
+	case XFS_DQTYPE_PROJ:
+		counts = xqc->pcounts;
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	if (xchk_iscan_aborted(&xqc->iscan) || counts == NULL)
+		return NOTIFY_DONE;
+
+	/*
+	 * Find the shadow dqtrx for this transaction and dquot, if any deltas
+	 * need to be applied here.  If not, we're finished early.
+	 */
+	mutex_lock(&xqc->lock);
+	dqa = rhashtable_lookup_fast(&xqc->shadow_dquot_acct, &p->tx_id,
+			xqcheck_dqacct_hash_params);
+	if (!dqa)
+		goto out_unlock;
+	dqtrx = xqcheck_get_dqtrx(dqa, p->q_type, p->q_id);
+	if (!dqtrx || dqtrx->q_type == 0)
+		goto out_unlock;
+
+	/* Update our shadow dquot if we're committing. */
+	if (action == XFS_APPLY_DQTRX_COMMIT) {
+		error = xqcheck_update_incore_counts(xqc, counts, p->q_id,
+				dqtrx->icount_delta,
+				dqtrx->bcount_delta + dqtrx->delbcnt_delta,
+				dqtrx->rtbcount_delta + dqtrx->delrtb_delta);
+		if (error)
+			goto out_abort;
+	}
+
+	/* Free the shadow accounting structure if that was the last user. */
+	dqa->refcount--;
+	if (dqa->refcount == 0) {
+		error = rhashtable_remove_fast(&xqc->shadow_dquot_acct,
+				&dqa->hash, xqcheck_dqacct_hash_params);
+		if (error)
+			goto out_abort;
+		xqcheck_dqacct_free(dqa, NULL);
+	}
+
+	mutex_unlock(&xqc->lock);
+	return NOTIFY_DONE;
+
+out_abort:
+	xchk_iscan_abort(&xqc->iscan);
+out_unlock:
+	mutex_unlock(&xqc->lock);
+	return NOTIFY_DONE;
+}
+
 /* Record this inode's quota usage in our shadow quota counter data. */
 STATIC int
 xqcheck_collect_inode(
@@ -132,13 +413,18 @@ xqcheck_collect_inode(
 		ilock_flags = xfs_ilock_data_map_shared(ip);
 		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 		if (error)
-			goto out_incomplete;
+			goto out_abort;
 	} else {
 		ilock_flags = XFS_ILOCK_SHARED;
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
 	}
 	xfs_inode_count_blocks(tp, ip, &nblks, &rtblks);
 
+	if (xchk_iscan_aborted(&xqc->iscan)) {
+		error = -ECANCELED;
+		goto out_incomplete;
+	}
+
 	/* Update the shadow dquot counters. */
 	mutex_lock(&xqc->lock);
 	if (xqc->ucounts) {
@@ -171,6 +457,8 @@ xqcheck_collect_inode(
 
 out_mutex:
 	mutex_unlock(&xqc->lock);
+out_abort:
+	xchk_iscan_abort(&xqc->iscan);
 out_incomplete:
 	xchk_set_incomplete(xqc->sc);
 out_ilock:
@@ -262,6 +550,11 @@ xqcheck_compare_dquot(
 	struct xfarray		*counts = xqcheck_counters_for(xqc, dqtype);
 	int			error;
 
+	if (xchk_iscan_aborted(&xqc->iscan)) {
+		xchk_set_incomplete(xqc->sc);
+		return -ECANCELED;
+	}
+
 	mutex_lock(&xqc->lock);
 	error = xfarray_load_sparse(counts, dq->q_id, &xcdq);
 	if (error)
@@ -283,7 +576,7 @@ xqcheck_compare_dquot(
 		 * EFBIG means we tried to store data at too high a byte offset
 		 * in the sparse array.  IOWs, we cannot complete the check and
 		 * must notify userspace that the check was incomplete.  This
-		 * should never happen, since we just read the record.
+		 * should never happen outside of the collection phase.
 		 */
 		xchk_set_incomplete(xqc->sc);
 		error = -ECANCELED;
@@ -390,6 +683,26 @@ xqcheck_teardown_scan(
 	void			*priv)
 {
 	struct xqcheck		*xqc = priv;
+	struct xfs_quotainfo	*qi = xqc->sc->mp->m_quotainfo;
+
+	/* Discourage any hook functions that might be running. */
+	xchk_iscan_abort(&xqc->iscan);
+
+	/*
+	 * As noted above, the apply hook is responsible for cleaning up the
+	 * shadow dquot accounting data when a transaction completes.  The mod
+	 * hook must be removed before the apply hook so that we don't
+	 * mistakenly leave an active shadow account for the mod hook to get
+	 * its hands on.  No hooks should be running after these functions
+	 * return.
+	 */
+	xfs_dqtrx_hook_del(qi, &xqc->hooks);
+
+	if (xqc->shadow_dquot_acct.key_len) {
+		rhashtable_free_and_destroy(&xqc->shadow_dquot_acct,
+				xqcheck_dqacct_free, NULL);
+		xqc->shadow_dquot_acct.key_len = 0;
+	}
 
 	if (xqc->pcounts) {
 		xfarray_destroy(xqc->pcounts);
@@ -422,6 +735,7 @@ xqcheck_setup_scan(
 	struct xqcheck		*xqc)
 {
 	char			*descr;
+	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	unsigned long long	max_dquots = XFS_DQ_ID_MAX + 1ULL;
 	int			error;
 
@@ -461,6 +775,33 @@ xqcheck_setup_scan(
 			goto out_teardown;
 	}
 
+	/*
+	 * Set up hash table to map transactions to our internal shadow dqtrx
+	 * structures.
+	 */
+	error = rhashtable_init(&xqc->shadow_dquot_acct,
+			&xqcheck_dqacct_hash_params);
+	if (error)
+		goto out_teardown;
+
+	/*
+	 * Hook into the quota code.  The hook only triggers for inodes that
+	 * were already scanned, and the scanner thread takes each inode's
+	 * ILOCK, which means that any in-progress inode updates will finish
+	 * before we can scan the inode.
+	 *
+	 * The apply hook (which removes the shadow dquot accounting struct)
+	 * must be installed before the mod hook so that we never fail to catch
+	 * the end of a quota update sequence and leave stale shadow data.
+	 */
+	ASSERT(sc->flags & XCHK_FSGATES_QUOTA);
+	xfs_hook_setup(&xqc->hooks.mod_hook, xqcheck_mod_live_ino_dqtrx);
+	xfs_hook_setup(&xqc->hooks.apply_hook, xqcheck_apply_live_dqtrx);
+
+	error = xfs_dqtrx_hook_add(qi, &xqc->hooks);
+	if (error)
+		goto out_teardown;
+
 	/* Use deferred cleanup to pass the quota count data to repair. */
 	sc->buf_cleanup = xqcheck_teardown_scan;
 	return 0;
@@ -488,6 +829,9 @@ xchk_quotacheck(
 	if (!xchk_xref_process_error(sc, 0, 0, &error))
 		return error;
 
+	/* Fail fast if we're not playing with a full dataset. */
+	if (xchk_iscan_aborted(&xqc->iscan))
+		xchk_set_incomplete(sc);
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
 		return 0;
 
@@ -508,5 +852,9 @@ xchk_quotacheck(
 			return error;
 	}
 
+	/* Check one last time for an incomplete dataset. */
+	if (xchk_iscan_aborted(&xqc->iscan))
+		xchk_set_incomplete(sc);
+
 	return 0;
 }
diff --git a/fs/xfs/scrub/quotacheck.h b/fs/xfs/scrub/quotacheck.h
index 99eae596dd410..3615fec3e409e 100644
--- a/fs/xfs/scrub/quotacheck.h
+++ b/fs/xfs/scrub/quotacheck.h
@@ -43,6 +43,12 @@ struct xqcheck {
 	struct mutex		lock;
 
 	struct xchk_iscan	iscan;
+
+	/* Hooks into the quota code. */
+	struct xfs_dqtrx_hook	hooks;
+
+	/* Shadow quota delta tracking structure. */
+	struct rhashtable	shadow_dquot_acct;
 };
 
 /* Return the incore counter array for a given quota type. */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d9fcf992d5899..71a9eb48e1de7 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -157,6 +157,9 @@ xchk_fsgates_disable(
 	if (sc->flags & XCHK_FSGATES_DRAIN)
 		xfs_drain_wait_disable();
 
+	if (sc->flags & XCHK_FSGATES_QUOTA)
+		xfs_dqtrx_hook_disable();
+
 	sc->flags &= ~XCHK_FSGATES_ALL;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 779f37b1cb1a6..5cd4550155f23 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -121,6 +121,7 @@ struct xfs_scrub {
 #define XCHK_HAVE_FREEZE_PROT	(1U << 1)  /* do we have freeze protection? */
 #define XCHK_FSGATES_DRAIN	(1U << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1U << 3)  /* scrub needs to drain defer ops */
+#define XCHK_FSGATES_QUOTA	(1U << 4)  /* quota live update enabled */
 #define XREP_RESET_PERAG_RESV	(1U << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
 
@@ -130,7 +131,8 @@ struct xfs_scrub {
  * features are gated off via dynamic code patching, which is why the state
  * must be enabled during scrub setup and can only be torn down afterwards.
  */
-#define XCHK_FSGATES_ALL	(XCHK_FSGATES_DRAIN)
+#define XCHK_FSGATES_ALL	(XCHK_FSGATES_DRAIN | \
+				 XCHK_FSGATES_QUOTA)
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 499ba68d1fb2a..afe2c92233f1b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -112,6 +112,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 	{ XCHK_HAVE_FREEZE_PROT,		"nofreeze" }, \
 	{ XCHK_FSGATES_DRAIN,			"fsgates_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
+	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 826aa5790cdeb..3cc1be30a9f74 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -692,6 +692,9 @@ xfs_qm_init_quotainfo(
 
 	shrinker_register(qinf->qi_shrinker);
 
+	xfs_hooks_init(&qinf->qi_mod_ino_dqtrx_hooks);
+	xfs_hooks_init(&qinf->qi_apply_dqtrx_hooks);
+
 	return 0;
 
 out_free_inos:
@@ -1822,12 +1825,12 @@ xfs_qm_vop_chown(
 	ASSERT(prevdq);
 	ASSERT(prevdq != newdq);
 
-	xfs_trans_mod_dquot(tp, prevdq, bfield, -(ip->i_nblocks));
-	xfs_trans_mod_dquot(tp, prevdq, XFS_TRANS_DQ_ICOUNT, -1);
+	xfs_trans_mod_ino_dquot(tp, ip, prevdq, bfield, -(ip->i_nblocks));
+	xfs_trans_mod_ino_dquot(tp, ip, prevdq, XFS_TRANS_DQ_ICOUNT, -1);
 
 	/* the sparkling new dquot */
-	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_nblocks);
-	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
+	xfs_trans_mod_ino_dquot(tp, ip, newdq, bfield, ip->i_nblocks);
+	xfs_trans_mod_ino_dquot(tp, ip, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
 	/*
 	 * Back when we made quota reservations for the chown, we reserved the
@@ -1909,22 +1912,21 @@ xfs_qm_vop_create_dqattach(
 		ASSERT(i_uid_read(VFS_I(ip)) == udqp->q_id);
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
-		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
 		ASSERT(i_gid_read(VFS_I(ip)) == gdqp->q_id);
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
-		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
 		ASSERT(ip->i_projid == pdqp->q_id);
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
-		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
+
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, 1);
 }
 
 /* Decide if this inode's dquot is near an enforcement boundary. */
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index d5c9fc4ba591e..f5993012bf98f 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -68,6 +68,10 @@ struct xfs_quotainfo {
 	/* Minimum and maximum quota expiration timestamp values. */
 	time64_t		qi_expiry_min;
 	time64_t		qi_expiry_max;
+
+	/* Hook to feed quota counter updates to an active online repair. */
+	struct xfs_hooks	qi_mod_ino_dqtrx_hooks;
+	struct xfs_hooks	qi_apply_dqtrx_hooks;
 };
 
 static inline struct radix_tree_root *
@@ -104,6 +108,18 @@ xfs_quota_inode(struct xfs_mount *mp, xfs_dqtype_t type)
 	return NULL;
 }
 
+/*
+ * Parameters for tracking dqtrx changes on behalf of an inode.  The hook
+ * function arg parameter is the field being updated.
+ */
+struct xfs_mod_ino_dqtrx_params {
+	uintptr_t		tx_id;
+	xfs_ino_t		ino;
+	xfs_dqtype_t		q_type;
+	xfs_dqid_t		q_id;
+	int64_t			delta;
+};
+
 extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
 				    uint field, int64_t delta);
 extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index b77673dd05581..271c1021c7335 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -9,6 +9,7 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_quota.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index dcc785fdd3453..fe63489d91b2f 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -74,6 +74,22 @@ struct xfs_dqtrx {
 	int64_t		qt_icount_delta;  /* dquot inode count changes */
 };
 
+enum xfs_apply_dqtrx_type {
+	XFS_APPLY_DQTRX_COMMIT = 0,
+	XFS_APPLY_DQTRX_UNRESERVE,
+};
+
+/*
+ * Parameters for applying dqtrx changes to a dquot.  The hook function arg
+ * parameter is enum xfs_apply_dqtrx_type.
+ */
+struct xfs_apply_dqtrx_params {
+	uintptr_t		tx_id;
+	xfs_ino_t		ino;
+	xfs_dqtype_t		q_type;
+	xfs_dqid_t		q_id;
+};
+
 #ifdef CONFIG_XFS_QUOTA
 extern void xfs_trans_dup_dqinfo(struct xfs_trans *, struct xfs_trans *);
 extern void xfs_trans_free_dqinfo(struct xfs_trans *);
@@ -114,6 +130,29 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
 }
 bool xfs_inode_near_dquot_enforcement(struct xfs_inode *ip, xfs_dqtype_t type);
+
+# ifdef CONFIG_XFS_LIVE_HOOKS
+void xfs_trans_mod_ino_dquot(struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xfs_dquot *dqp, unsigned int field, int64_t delta);
+
+struct xfs_quotainfo;
+
+struct xfs_dqtrx_hook {
+	struct xfs_hook		mod_hook;
+	struct xfs_hook		apply_hook;
+};
+
+void xfs_dqtrx_hook_disable(void);
+void xfs_dqtrx_hook_enable(void);
+
+int xfs_dqtrx_hook_add(struct xfs_quotainfo *qi, struct xfs_dqtrx_hook *hook);
+void xfs_dqtrx_hook_del(struct xfs_quotainfo *qi, struct xfs_dqtrx_hook *hook);
+
+# else
+#  define xfs_trans_mod_ino_dquot(tp, ip, dqp, field, delta) \
+		xfs_trans_mod_dquot((tp), (dqp), (field), (delta))
+# endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -170,6 +209,12 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
 #define xfs_inode_near_dquot_enforcement(ip, type)			(false)
+
+# ifdef CONFIG_XFS_LIVE_HOOKS
+#  define xfs_dqtrx_hook_enable()		((void)0)
+#  define xfs_dqtrx_hook_disable()		((void)0)
+# endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif /* CONFIG_XFS_QUOTA */
 
 static inline int
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 968dc7af4fc7d..f5e9d76fb9a2f 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -121,6 +121,105 @@ xfs_trans_dup_dqinfo(
 	}
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Use a static key here to reduce the overhead of quota live updates.  If the
+ * compiler supports jump labels, the static branch will be replaced by a nop
+ * sled when there are no hook users.  Online fsck is currently the only
+ * caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_dqtrx_hooks_switch);
+
+void
+xfs_dqtrx_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_dqtrx_hooks_switch);
+}
+
+void
+xfs_dqtrx_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_dqtrx_hooks_switch);
+}
+
+/* Schedule a transactional dquot update on behalf of an inode. */
+void
+xfs_trans_mod_ino_dquot(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	struct xfs_dquot		*dqp,
+	unsigned int			field,
+	int64_t				delta)
+{
+	xfs_trans_mod_dquot(tp, dqp, field, delta);
+
+	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
+		struct xfs_mod_ino_dqtrx_params	p = {
+			.tx_id		= (uintptr_t)tp,
+			.ino		= ip->i_ino,
+			.q_type		= xfs_dquot_type(dqp),
+			.q_id		= dqp->q_id,
+			.delta		= delta
+		};
+		struct xfs_quotainfo	*qi = tp->t_mountp->m_quotainfo;
+
+		xfs_hooks_call(&qi->qi_mod_ino_dqtrx_hooks, field, &p);
+	}
+}
+
+/* Call the specified functions during a dquot counter update. */
+int
+xfs_dqtrx_hook_add(
+	struct xfs_quotainfo	*qi,
+	struct xfs_dqtrx_hook	*hook)
+{
+	int			error;
+
+	/*
+	 * Transactional dquot updates first call the mod hook when changes
+	 * are attached to the transaction and then call the apply hook when
+	 * those changes are committed (or canceled).
+	 *
+	 * The apply hook must be installed before the mod hook so that we
+	 * never fail to catch the end of a quota update sequence.
+	 */
+	error = xfs_hooks_add(&qi->qi_apply_dqtrx_hooks, &hook->apply_hook);
+	if (error)
+		goto out;
+
+	error = xfs_hooks_add(&qi->qi_mod_ino_dqtrx_hooks, &hook->mod_hook);
+	if (error)
+		goto out_apply;
+
+	return 0;
+
+out_apply:
+	xfs_hooks_del(&qi->qi_apply_dqtrx_hooks, &hook->apply_hook);
+out:
+	return error;
+}
+
+/* Stop calling the specified function during a dquot counter update. */
+void
+xfs_dqtrx_hook_del(
+	struct xfs_quotainfo	*qi,
+	struct xfs_dqtrx_hook	*hook)
+{
+	/*
+	 * The mod hook must be removed before apply hook to avoid giving the
+	 * hook consumer with an incomplete update.  No hooks should be running
+	 * after these functions return.
+	 */
+	xfs_hooks_del(&qi->qi_mod_ino_dqtrx_hooks, &hook->mod_hook);
+	xfs_hooks_del(&qi->qi_apply_dqtrx_hooks, &hook->apply_hook);
+}
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Wrap around mod_dquot to account for both user and group quotas.
  */
@@ -138,11 +237,11 @@ xfs_trans_mod_dquot_byino(
 		return;
 
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
-		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
+		xfs_trans_mod_ino_dquot(tp, ip, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
-		(void) xfs_trans_mod_dquot(tp, ip->i_gdquot, field, delta);
+		xfs_trans_mod_ino_dquot(tp, ip, ip->i_gdquot, field, delta);
 	if (XFS_IS_PQUOTA_ON(mp) && ip->i_pdquot)
-		(void) xfs_trans_mod_dquot(tp, ip->i_pdquot, field, delta);
+		xfs_trans_mod_ino_dquot(tp, ip, ip->i_pdquot, field, delta);
 }
 
 STATIC struct xfs_dqtrx *
@@ -322,6 +421,29 @@ xfs_apply_quota_reservation_deltas(
 	}
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/* Call downstream hooks now that it's time to apply dquot deltas. */
+static inline void
+xfs_trans_apply_dquot_deltas_hook(
+	struct xfs_trans		*tp,
+	struct xfs_dquot		*dqp)
+{
+	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
+		struct xfs_apply_dqtrx_params	p = {
+			.tx_id		= (uintptr_t)tp,
+			.q_type		= xfs_dquot_type(dqp),
+			.q_id		= dqp->q_id,
+		};
+		struct xfs_quotainfo	*qi = tp->t_mountp->m_quotainfo;
+
+		xfs_hooks_call(&qi->qi_apply_dqtrx_hooks,
+				XFS_APPLY_DQTRX_COMMIT, &p);
+	}
+}
+#else
+# define xfs_trans_apply_dquot_deltas_hook(tp, dqp)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Called by xfs_trans_commit() and similar in spirit to
  * xfs_trans_apply_sb_deltas().
@@ -367,6 +489,8 @@ xfs_trans_apply_dquot_deltas(
 
 			ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
+			xfs_trans_apply_dquot_deltas_hook(tp, dqp);
+
 			/*
 			 * adjust the actual number of blocks used
 			 */
@@ -466,6 +590,29 @@ xfs_trans_apply_dquot_deltas(
 	}
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/* Call downstream hooks now that it's time to cancel dquot deltas. */
+static inline void
+xfs_trans_unreserve_and_mod_dquots_hook(
+	struct xfs_trans		*tp,
+	struct xfs_dquot		*dqp)
+{
+	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
+		struct xfs_apply_dqtrx_params	p = {
+			.tx_id		= (uintptr_t)tp,
+			.q_type		= xfs_dquot_type(dqp),
+			.q_id		= dqp->q_id,
+		};
+		struct xfs_quotainfo	*qi = tp->t_mountp->m_quotainfo;
+
+		xfs_hooks_call(&qi->qi_apply_dqtrx_hooks,
+				XFS_APPLY_DQTRX_UNRESERVE, &p);
+	}
+}
+#else
+# define xfs_trans_unreserve_and_mod_dquots_hook(tp, dqp)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Release the reservations, and adjust the dquots accordingly.
  * This is called only when the transaction is being aborted. If by
@@ -496,6 +643,9 @@ xfs_trans_unreserve_and_mod_dquots(
 			 */
 			if ((dqp = qtrx->qt_dquot) == NULL)
 				break;
+
+			xfs_trans_unreserve_and_mod_dquots_hook(tp, dqp);
+
 			/*
 			 * Unreserve the original reservation. We don't care
 			 * about the number of blocks used field, or deltas.

