Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181F318026
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xg7UDKso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEEAC433C8;
	Sun,  3 Dec 2023 19:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630193;
	bh=k4TpbHGG31u/B46ONBBWDbYzpbjknTlM1huxxegyhdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xg7UDKsoLq1Z6Ywk6RGn/2Bup7keIPEDxaV32ES5spUH3RbvbJh2R/WTIkd6XAMa+
	 QIX+SxvyZFd6uGHey4Yu2h7w3NVpV8Z+lqiYoC9msnqebiEtNXXHo0bCh9HYoWxgbq
	 dM8C4dkwg3NyT/Vvj27EuA1XhFih4zpfSF6/tERrnrvekvCRqLpLpK3+YchqGLYVms
	 EUFzSJgqd4pTal2AG96bbDS6VOHGQ89/CsQv4n8fue2G2Xl1aiLAKfhMymu7HdFOSN
	 RAeRT/Q93LRr6ojY2eweQgIE4I+64uUSds9YLRWxyDw0VvUQQYjJpDIIkpZ69uungb
	 JgIReaESE/a1Q==
Date: Sun, 03 Dec 2023 11:03:13 -0800
Subject: [PATCH 2/9] xfs: hoist intent done flag setting to ->finish_item
 callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990199.3037772.1720511950494662143.stgit@frogsfrogsfrogs>
In-Reply-To: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
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

Each log intent item's ->finish_item call chain inevitably includes some
code to set the dirty flag of the transaction.  If there's an associated
log intent done item, it also sets the item's dirty flag and the
transaction's INTENT_DONE flag.  This is repeated throughout the
codebase.

Reduce the LOC by moving all that to xfs_defer_finish_one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |   28 +++++++++++++++++++++++++++-
 fs/xfs/xfs_attr_item.c     |   30 ++++--------------------------
 fs/xfs/xfs_bmap_item.c     |   16 +---------------
 fs/xfs/xfs_extfree_item.c  |   20 --------------------
 fs/xfs/xfs_refcount_item.c |   16 +---------------
 fs/xfs/xfs_rmap_item.c     |   16 +---------------
 6 files changed, 34 insertions(+), 92 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index dd565e4e3daf..e2cdefa42059 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -218,6 +218,32 @@ xfs_defer_create_intent(
 	return 1;
 }
 
+/* Create a log intent done item for a log intent item. */
+static inline void
+xfs_defer_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct xfs_log_item		*lip;
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the log intent item and frees the log done item
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	lip = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	if (!lip)
+		return;
+
+	tp->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
+	dfp->dfp_done = lip;
+}
+
 /*
  * For each pending item in the intake list, log its intent item and the
  * associated extents, then add the entire intake list to the end of
@@ -496,7 +522,7 @@ xfs_defer_finish_one(
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 
-	dfp->dfp_done = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	xfs_defer_create_done(tp, dfp);
 	list_for_each_safe(li, n, &dfp->dfp_work) {
 		list_del(li);
 		dfp->dfp_count--;
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 1b7f1313f51e..237e5e61d173 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -324,39 +324,17 @@ xfs_xattri_finish_update(
 	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error;
 
-	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
-		error = -EIO;
-		goto out;
-	}
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP))
+		return -EIO;
 
 	/* If an attr removal is trivially complete, we're done. */
 	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
-	    !xfs_inode_hasattr(args->dp)) {
-		error = 0;
-		goto out;
-	}
+	    !xfs_inode_hasattr(args->dp))
+		return 0;
 
 	error = xfs_attr_set_iter(attr);
 	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
 		error = -EAGAIN;
-out:
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the ATTRI and frees the ATTRD
-	 * 2.) shuts down the filesystem
-	 */
-	args->trans->t_flags |= XFS_TRANS_DIRTY;
-
-	/*
-	 * attr intent/done items are null when logged attributes are disabled
-	 */
-	if (attrdp) {
-		args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
-		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
-	}
-
 	return error;
 }
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index fa305d242f24..c62d029ad723 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -249,21 +249,7 @@ xfs_trans_log_finish_bmap_update(
 	struct xfs_bud_log_item		*budp,
 	struct xfs_bmap_intent		*bi)
 {
-	int				error;
-
-	error = xfs_bmap_finish_one(tp, bi);
-
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the BUI and frees the BUD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
-	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
-
-	return error;
+	return xfs_bmap_finish_one(tp, bi);
 }
 
 /* Sort bmap intents by inode. */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 49e96ffd64e0..e8e02f816cbe 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -396,16 +396,6 @@ xfs_trans_free_extent(
 			xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
 
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the EFI and frees the EFD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
-	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
-
 	/*
 	 * If we need a new transaction to make progress, the caller will log a
 	 * new EFI with the current contents. It will also log an EFD to cancel
@@ -601,16 +591,6 @@ xfs_agfl_free_finish_item(
 		error = xfs_free_agfl_block(tp, xefi->xefi_pag->pag_agno,
 				agbno, agbp, &oinfo);
 
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the EFI and frees the EFD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
-
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 48f1a38b272e..2628b1e3969c 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -256,21 +256,7 @@ xfs_trans_log_finish_refcount_update(
 	struct xfs_refcount_intent	*ri,
 	struct xfs_btree_cur		**pcur)
 {
-	int				error;
-
-	error = xfs_refcount_finish_one(tp, ri, pcur);
-
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the CUI and frees the CUD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
-	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
-
-	return error;
+	return xfs_refcount_finish_one(tp, ri, pcur);
 }
 
 /* Sort refcount intents by AG. */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 23684bc2ab85..8f216a13a7f2 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -297,21 +297,7 @@ xfs_trans_log_finish_rmap_update(
 	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
-	int				error;
-
-	error = xfs_rmap_finish_one(tp, ri, pcur);
-
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the RUI and frees the RUD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
-	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
-
-	return error;
+	return xfs_rmap_finish_one(tp, ri, pcur);
 }
 
 /* Sort rmap intents by AG. */

