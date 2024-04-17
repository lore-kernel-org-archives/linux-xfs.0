Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F2A4AEDB
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388924; cv=none; b=XBmzTPKpN0eixr8ljmkkEvKLTOoaayS3Dr8n1K40EImAzLnaKRzCLSdTRJOCU95CIfBbi+K4OxncD9nT+S964PKpB4oU8IdHOcryQWJgpUT2lSiyyfge4kpjoOzFSiJMZo0oYkt0kBizMj+bQFLOpu6fHMV6fTeNaAPAMrAGfgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388924; c=relaxed/simple;
	bh=NMiX1rcO8ZHcZGvIRfuV2V6S1YzRuUJcwERCz047Pak=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UvspDovKf/BYAmtar9ylRCL8ineLSugR16VIoNI4Smrbq0ivRX3DWN5v4lnHC0/jyD5gHmyDjLFyY98oxxAN0MiHOrCS6RkpyknGTWhoLs0CcfZ447Mws5QKR6gCYv3mgAPTNtKsB3XrQi2b3aJUncS2c+mw+dVhdKWnw5Qtfk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FafmfZFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FafmfZFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF40C072AA;
	Wed, 17 Apr 2024 21:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388922;
	bh=NMiX1rcO8ZHcZGvIRfuV2V6S1YzRuUJcwERCz047Pak=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FafmfZFeI7awxDpMInasqoSOlwvmEIxESdF3VKMztklM5kltwHR47gzeeAykMdluH
	 DdlQNR2R8dyVyxIQAsrlV8JwbH5EGB+hv49WpZMwlzS8CVPs97oLGjuj6h+UwjSgD9
	 EsZfu12PVRfCkRRgLgqyRakM+r32to7We+gklqao2KbTNRQuqEbipEoqbl0z2aXQip
	 zlzl5GC2C9ORcB77W2f8AvH+XazHXyryfa9xigFx42tRo1cvhBmRVpxgvlBw4H4zS/
	 vcJwIp7nGTPW1s77A6On7IvsprAsn+uNwwYRqV9gO6bxNBTE1RKJMWRI2uYCTuF5oA
	 q3NOCagCx28hg==
Date: Wed, 17 Apr 2024 14:22:01 -0700
Subject: [PATCH 01/67] xfs: use xfs_defer_pending objects to recover intent
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842355.1853449.12796796465320512222.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 03f7767c9f6120ac933378fdec3bfd78bf07bc11

One thing I never quite got around to doing is porting the log intent
item recovery code to reconstruct the deferred pending work state.  As a
result, each intent item open codes xfs_defer_finish_one in its recovery
method, because that's what the EFI code did before xfs_defer.c even
existed.

This is a gross thing to have left unfixed -- if an EFI cannot proceed
due to busy extents, we end up creating separate new EFIs for each
unfinished work item, which is a change in behavior from what runtime
would have done.

Worse yet, Long Li pointed out that there's a UAF in the recovery code.
The ->commit_pass2 function adds the intent item to the AIL and drops
the refcount.  The one remaining refcount is now owned by the recovery
mechanism (aka the log intent items in the AIL) with the intent of
giving the refcount to the intent done item in the ->iop_recover
function.

However, if something fails later in recovery, xlog_recover_finish will
walk the recovered intent items in the AIL and release them.  If the CIL
hasn't been pushed before that point (which is possible since we don't
force the log until later) then the intent done release will try to free
its associated intent, which has already been freed.

This patch starts to address this mess by having the ->commit_pass2
functions recreate the xfs_defer_pending state.  The next few patches
will fix the recovery functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |  105 ++++++++++++++++++++++++++++++++++++++--------------
 libxfs/xfs_defer.h |    5 ++
 2 files changed, 82 insertions(+), 28 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 7ff125c5f..bd6f14a2c 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -240,23 +240,53 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-STATIC void
+static inline void
 xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+
+	trace_xfs_defer_pending_abort(mp, dfp);
+
+	if (dfp->dfp_intent && !dfp->dfp_done) {
+		ops->abort_intent(dfp->dfp_intent);
+		dfp->dfp_intent = NULL;
+	}
+}
+
+static inline void
+xfs_defer_pending_cancel_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*pwi;
+	struct list_head		*n;
+
+	trace_xfs_defer_cancel_list(mp, dfp);
+
+	list_del(&dfp->dfp_list);
+	list_for_each_safe(pwi, n, &dfp->dfp_work) {
+		list_del(pwi);
+		dfp->dfp_count--;
+		trace_xfs_defer_cancel_item(mp, dfp, pwi);
+		ops->cancel_item(pwi);
+	}
+	ASSERT(dfp->dfp_count == 0);
+	kmem_cache_free(xfs_defer_pending_cache, dfp);
+}
+
+STATIC void
+xfs_defer_pending_abort_list(
 	struct xfs_mount		*mp,
 	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(mp, dfp);
-		if (dfp->dfp_intent && !dfp->dfp_done) {
-			ops->abort_intent(dfp->dfp_intent);
-			dfp->dfp_intent = NULL;
-		}
-	}
+	list_for_each_entry(dfp, dop_list, dfp_list)
+		xfs_defer_pending_abort(mp, dfp);
 }
 
 /* Abort all the intents that were committed. */
@@ -266,7 +296,7 @@ xfs_defer_trans_abort(
 	struct list_head		*dop_pending)
 {
 	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+	xfs_defer_pending_abort_list(tp->t_mountp, dop_pending);
 }
 
 /*
@@ -384,27 +414,13 @@ xfs_defer_cancel_list(
 {
 	struct xfs_defer_pending	*dfp;
 	struct xfs_defer_pending	*pli;
-	struct list_head		*pwi;
-	struct list_head		*n;
-	const struct xfs_defer_op_type	*ops;
 
 	/*
 	 * Free the pending items.  Caller should already have arranged
 	 * for the intent items to be released.
 	 */
-	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_cancel_list(mp, dfp);
-		list_del(&dfp->dfp_list);
-		list_for_each_safe(pwi, n, &dfp->dfp_work) {
-			list_del(pwi);
-			dfp->dfp_count--;
-			trace_xfs_defer_cancel_item(mp, dfp, pwi);
-			ops->cancel_item(pwi);
-		}
-		ASSERT(dfp->dfp_count == 0);
-		kmem_cache_free(xfs_defer_pending_cache, dfp);
-	}
+	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list)
+		xfs_defer_pending_cancel_work(mp, dfp);
 }
 
 /*
@@ -660,6 +676,39 @@ xfs_defer_add(
 	dfp->dfp_count++;
 }
 
+/*
+ * Create a pending deferred work item to replay the recovered intent item
+ * and add it to the list.
+ */
+void
+xfs_defer_start_recovery(
+	struct xfs_log_item		*lip,
+	enum xfs_defer_ops_type		dfp_type,
+	struct list_head		*r_dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = dfp_type;
+	dfp->dfp_intent = lip;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, r_dfops);
+}
+
+/*
+ * Cancel a deferred work item created to recover a log intent item.  @dfp
+ * will be freed after this function returns.
+ */
+void
+xfs_defer_cancel_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	xfs_defer_pending_abort(mp, dfp);
+	xfs_defer_pending_cancel_work(mp, dfp);
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
@@ -764,7 +813,7 @@ xfs_defer_ops_capture_abort(
 {
 	unsigned short			i;
 
-	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
+	xfs_defer_pending_abort_list(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 8788ad5f6..5dce938ba 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -125,6 +125,11 @@ void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
+void xfs_defer_start_recovery(struct xfs_log_item *lip,
+		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
+void xfs_defer_cancel_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp);
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 

