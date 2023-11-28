Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0525A3D0DC
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 20:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmwbEiZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F329C433C7;
	Tue, 28 Nov 2023 20:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701203206;
	bh=gQcZcsb2MfvhzJ7iRllQP6xrioLqHMHoKYmx2OXJAjE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=UmwbEiZZ0UN9FBeMEjvQA8JbVjkv6F3g87RQ8y5jN0QvDwU6me2cXfBui1MKgaSOz
	 +7O4gaPVSi7HLF8rwFe3/foY+c60AgKz1Bc6V1svM3RS16sDK37NLNwafzBVmgv3wv
	 b7CjQYktCcsmRNHH+bv+eTCdy6noKxfj8JuFoQbzBJn6sZtzo08y2BcDX+G92CKI9q
	 gFzfqMpIOUH5UQbzZikLbUv4d9z4jq733Am556AytC18cPwEyBoWDmhgyAFWGPFD48
	 BIw+zWhpl9iicBJWyghTyEaSFlevLWuL0HJJXoF+AigI8momdgz7ckwu4h7FEyuX+c
	 bwdY+eNaw6lDw==
Subject: [PATCH 3/7] xfs: pass the xfs_defer_pending object to iop_recover
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, leo.lilong@huawei.com, chandanbabu@kernel.org,
 hch@lst.de
Cc: linux-xfs@vger.kernel.org
Date: Tue, 28 Nov 2023 12:26:45 -0800
Message-ID: <170120320584.13206.4218262549563803966.stgit@frogsfrogsfrogs>
In-Reply-To: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
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

Now that log intent item recovery recreates the xfs_defer_pending state,
we should pass that into the ->iop_recover routines so that the intent
item can finish the recreation work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c     |    3 ++-
 fs/xfs/xfs_bmap_item.c     |    3 ++-
 fs/xfs/xfs_extfree_item.c  |    3 ++-
 fs/xfs/xfs_log_recover.c   |    2 +-
 fs/xfs/xfs_refcount_item.c |    3 ++-
 fs/xfs/xfs_rmap_item.c     |    3 ++-
 fs/xfs/xfs_trans.h         |    4 +++-
 7 files changed, 14 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a32716b8cbbd..6119a7a480a0 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -545,9 +545,10 @@ xfs_attri_validate(
  */
 STATIC int
 xfs_attri_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6cbae4fdf43f..3ef55de370b5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -486,11 +486,12 @@ xfs_bui_validate(
  */
 STATIC int
 xfs_bui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_bmap_intent		fake = { };
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index cf0ddeb70580..a8245c5ffe49 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -657,10 +657,11 @@ xfs_efi_validate_ext(
  */
 STATIC int
 xfs_efi_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 49481d9c1ced..c0a75ec1173a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2588,7 +2588,7 @@ xlog_recover_process_intents(
 		 * The recovery function can free the log item, so we must not
 		 * access lip after it returns.
 		 */
-		error = ops->iop_recover(lip, &capture_list);
+		error = ops->iop_recover(dfp, &capture_list);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
 					ops->iop_recover);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b88cb2e98227..3456201aa3e6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -474,10 +474,11 @@ xfs_cui_validate_phys(
  */
 STATIC int
 xfs_cui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c30d4a4a14b2..dfd5a3e4b1fb 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -504,10 +504,11 @@ xfs_rui_validate_map(
  */
 STATIC int
 xfs_rui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6e3646d524ce..4e38357237c3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -66,6 +66,8 @@ struct xfs_log_item {
 	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
 	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
 
+struct xfs_defer_pending;
+
 struct xfs_item_ops {
 	unsigned flags;
 	void (*iop_size)(struct xfs_log_item *, int *, int *);
@@ -78,7 +80,7 @@ struct xfs_item_ops {
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_release)(struct xfs_log_item *);
-	int (*iop_recover)(struct xfs_log_item *lip,
+	int (*iop_recover)(struct xfs_defer_pending *dfp,
 			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,

