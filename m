Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2EE17748
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0va6qJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC850C433C8;
	Sun,  3 Dec 2023 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630241;
	bh=w1pXRUy8AhIjrCTlTAhuk6ZXmwBKKKamnLbNAhVvxI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I0va6qJ33+4kTPuZw6UteFWXC4YuYIeL1tIQVvp+PMESUOzBkICTcIAHRcBdEYqYJ
	 sbiQRjOvFmDyJcG8D4ob+nbk1kJWGEDAjb2rIJ3vcPLaj4hTubhhOZOHWOuK8zZhF4
	 YVCtd7BtFpkf3O6fe7S7ITM9esEqKFRgSDBiOumfjN6hSZFgkjYj6yWbc33R3SmXX8
	 a4rrWIKBNlcnFGT85G/0Vm+g3q8cIAr3d9EeqbJKJXZzIlld1fg1E7rJ+3FiVVRmWS
	 YbLhH23nNNvqkQUy23WugCMi/7uETaR0zE5QIJ1HkWuJaSeBlInfKgcPyeJQlKvvvr
	 pnc1jUD9IXGUg==
Date: Sun, 03 Dec 2023 11:04:00 -0800
Subject: [PATCH 5/9] xfs: use xfs_defer_create_done for the relogging
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990246.3037772.12936129938729072380.stgit@frogsfrogsfrogs>
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

Now that we have a helper to handle creating a log intent done item and
updating all the necessary state flags, use it to reduce boilerplate in
the ->iop_relog implementations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |    6 +++++-
 fs/xfs/xfs_attr_item.c     |    6 +-----
 fs/xfs/xfs_bmap_item.c     |    6 +-----
 fs/xfs/xfs_extfree_item.c  |    6 ++----
 fs/xfs/xfs_refcount_item.c |    6 +-----
 fs/xfs/xfs_rmap_item.c     |    6 +-----
 fs/xfs/xfs_trans.h         |    4 +++-
 7 files changed, 14 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 381bfd46564d..5c477a3a6a6c 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -500,7 +500,11 @@ xfs_defer_relog(
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
-		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+
+		xfs_defer_create_done(*tpp, dfp);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent,
+				dfp->dfp_done, *tpp);
+		dfp->dfp_done = NULL;
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5376bac383f3..e12d97da1f1f 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -627,9 +627,9 @@ xfs_attr_recover_work(
 static struct xfs_log_item *
 xfs_attri_item_relog(
 	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item,
 	struct xfs_trans		*tp)
 {
-	struct xfs_attrd_log_item	*attrdp;
 	struct xfs_attri_log_item	*old_attrip;
 	struct xfs_attri_log_item	*new_attrip;
 	struct xfs_attri_log_format	*new_attrp;
@@ -638,10 +638,6 @@ xfs_attri_item_relog(
 	old_attrip = ATTRI_ITEM(intent);
 	old_attrp = &old_attrip->attri_format;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	attrdp = xfs_trans_get_attrd(tp, old_attrip);
-	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
-
 	/*
 	 * Create a new log item that shares the same name/value buffer as the
 	 * old log item.
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ce03e5c37ba3..653aa4769ab5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -569,9 +569,9 @@ xfs_bui_item_match(
 static struct xfs_log_item *
 xfs_bui_item_relog(
 	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item,
 	struct xfs_trans		*tp)
 {
-	struct xfs_bud_log_item		*budp;
 	struct xfs_bui_log_item		*buip;
 	struct xfs_map_extent		*map;
 	unsigned int			count;
@@ -579,10 +579,6 @@ xfs_bui_item_relog(
 	count = BUI_ITEM(intent)->bui_format.bui_nextents;
 	map = BUI_ITEM(intent)->bui_format.bui_extents;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
-	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
-
 	buip = xfs_bui_init(tp->t_mountp);
 	memcpy(buip->bui_format.bui_extents, map, count * sizeof(*map));
 	atomic_set(&buip->bui_next_extent, count);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d07cdc3eb809..807398479187 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -691,9 +691,10 @@ xfs_efi_item_match(
 static struct xfs_log_item *
 xfs_efi_item_relog(
 	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item,
 	struct xfs_trans		*tp)
 {
-	struct xfs_efd_log_item		*efdp;
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done_item);
 	struct xfs_efi_log_item		*efip;
 	struct xfs_extent		*extp;
 	unsigned int			count;
@@ -701,11 +702,8 @@ xfs_efi_item_relog(
 	count = EFI_ITEM(intent)->efi_format.efi_nextents;
 	extp = EFI_ITEM(intent)->efi_format.efi_extents;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
 	efdp->efd_next_extent = count;
 	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
-	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
 
 	efip = xfs_efi_init(tp->t_mountp, count);
 	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index f604b7e3b77e..142839a8e7b1 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -533,9 +533,9 @@ xfs_cui_item_match(
 static struct xfs_log_item *
 xfs_cui_item_relog(
 	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item,
 	struct xfs_trans		*tp)
 {
-	struct xfs_cud_log_item		*cudp;
 	struct xfs_cui_log_item		*cuip;
 	struct xfs_phys_extent		*pmap;
 	unsigned int			count;
@@ -543,10 +543,6 @@ xfs_cui_item_relog(
 	count = CUI_ITEM(intent)->cui_format.cui_nextents;
 	pmap = CUI_ITEM(intent)->cui_format.cui_extents;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
-	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
-
 	cuip = xfs_cui_init(tp->t_mountp, count);
 	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
 	atomic_set(&cuip->cui_next_extent, count);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 05841548691d..e2730b3e0d96 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -586,9 +586,9 @@ xfs_rui_item_match(
 static struct xfs_log_item *
 xfs_rui_item_relog(
 	struct xfs_log_item		*intent,
+	struct xfs_log_item		*done_item,
 	struct xfs_trans		*tp)
 {
-	struct xfs_rud_log_item		*rudp;
 	struct xfs_rui_log_item		*ruip;
 	struct xfs_map_extent		*map;
 	unsigned int			count;
@@ -596,10 +596,6 @@ xfs_rui_item_relog(
 	count = RUI_ITEM(intent)->rui_format.rui_nextents;
 	map = RUI_ITEM(intent)->rui_format.rui_extents;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
-	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
-
 	ruip = xfs_rui_init(tp->t_mountp, count);
 	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
 	atomic_set(&ruip->rui_next_extent, count);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 5fb018ad9fc0..25646e2b12f4 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -80,6 +80,7 @@ struct xfs_item_ops {
 	void (*iop_release)(struct xfs_log_item *);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
+			struct xfs_log_item *done_item,
 			struct xfs_trans *tp);
 	struct xfs_log_item *(*iop_intent)(struct xfs_log_item *intent_done);
 };
@@ -248,9 +249,10 @@ extern struct kmem_cache	*xfs_trans_cache;
 static inline struct xfs_log_item *
 xfs_trans_item_relog(
 	struct xfs_log_item	*lip,
+	struct xfs_log_item	*done_lip,
 	struct xfs_trans	*tp)
 {
-	return lip->li_ops->iop_relog(lip, tp);
+	return lip->li_ops->iop_relog(lip, done_lip, tp);
 }
 
 struct xfs_dquot;

