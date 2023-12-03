Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701B2171CE
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aG7FE01+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDF8C433C8;
	Sun,  3 Dec 2023 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630272;
	bh=loGJ88gaUMwVW++RaWfllm7Jv8jweaX1GRGBuN0+tXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aG7FE01+DEIa9nOuBBemhqrDE8sTsM0m68JHXgkGAMWraqOIgICW4ONG72E9Rd/EI
	 Vr8UidyTunfxaiZOot5L5OKMzUVCTgp+NzHPZTvpmQ142H4RIYF78SwmRbOpeU18fN
	 xp9oZ+Dd6EcJm25obMvBgSMaQR/pggJXM/PRlot5Ua0fayo8Lh3dkGWpGvA8tVyXph
	 12U6rchEq70++p5yMMAQdQ4a1c72dTDnNlVbeb9iVX8KUBcCzS245IuzshRKbBC0kE
	 JWD3qSCCsSVrPCZvhALQufn8RoUAJj4s/Wd03RtLbecMZBzVHsjAJbtcrGfYZ19oNt
	 lMknVRo0uuDzQ==
Date: Sun, 03 Dec 2023 11:04:31 -0800
Subject: [PATCH 7/9] xfs: hoist xfs_trans_add_item calls to defer ops
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990278.3037772.17096469186540217626.stgit@frogsfrogsfrogs>
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

Remove even more repeated boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |    7 ++++++-
 fs/xfs/xfs_attr_item.c     |    4 ----
 fs/xfs/xfs_bmap_item.c     |    3 ---
 fs/xfs/xfs_extfree_item.c  |    3 ---
 fs/xfs/xfs_refcount_item.c |    3 ---
 fs/xfs/xfs_rmap_item.c     |    3 ---
 6 files changed, 6 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0e2ceec97978..4beaff83f149 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -26,6 +26,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
+#include "xfs_trans_priv.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -215,6 +216,7 @@ xfs_defer_create_intent(
 		return PTR_ERR(lip);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
@@ -242,6 +244,7 @@ xfs_defer_create_done(
 		return;
 
 	tp->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	xfs_trans_add_item(tp, lip);
 	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_done = lip;
 }
@@ -506,8 +509,10 @@ xfs_defer_relog(
 		xfs_defer_create_done(*tpp, dfp);
 		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
 				*tpp);
-		if (lip)
+		if (lip) {
+			xfs_trans_add_item(*tpp, lip);
 			set_bit(XFS_LI_DIRTY, &lip->li_flags);
+		}
 		dfp->dfp_done = NULL;
 		dfp->dfp_intent = lip;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c2a9f1cb7ff6..59d4174bbd1b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -375,7 +375,6 @@ xfs_attr_create_intent(
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
-	xfs_trans_add_item(tp, &attrip->attri_item);
 	xfs_attr_log_item(tp, attrip, attr);
 
 	return &attrip->attri_item;
@@ -651,8 +650,6 @@ xfs_attri_item_relog(
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
-	xfs_trans_add_item(tp, &new_attrip->attri_item);
-
 	return &new_attrip->attri_item;
 }
 
@@ -750,7 +747,6 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
 	attrdp->attrd_attrip = attrip;
 	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
 
-	xfs_trans_add_item(tp, &attrdp->attrd_item);
 	return attrdp;
 }
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 949d2b24025e..586cfccf945c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -234,7 +234,6 @@ xfs_trans_get_bud(
 	budp->bud_buip = buip;
 	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
 
-	xfs_trans_add_item(tp, &budp->bud_item);
 	return budp;
 }
 
@@ -315,7 +314,6 @@ xfs_bmap_update_create_intent(
 
 	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
 
-	xfs_trans_add_item(tp, &buip->bui_item);
 	if (sort)
 		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bi, items, bi_list)
@@ -582,7 +580,6 @@ xfs_bui_item_relog(
 	buip = xfs_bui_init(tp->t_mountp);
 	memcpy(buip->bui_format.bui_extents, map, count * sizeof(*map));
 	atomic_set(&buip->bui_next_extent, count);
-	xfs_trans_add_item(tp, &buip->bui_item);
 
 	return &buip->bui_item;
 }
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e2e86f2edb3c..44bbf620e0cf 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -332,7 +332,6 @@ xfs_trans_get_efd(
 	efdp->efd_format.efd_nextents = nextents;
 	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
 
-	xfs_trans_add_item(tp, &efdp->efd_item);
 	return efdp;
 }
 
@@ -415,7 +414,6 @@ xfs_extent_free_create_intent(
 
 	ASSERT(count > 0);
 
-	xfs_trans_add_item(tp, &efip->efi_item);
 	if (sort)
 		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(xefi, items, xefi_list)
@@ -708,7 +706,6 @@ xfs_efi_item_relog(
 	efip = xfs_efi_init(tp->t_mountp, count);
 	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
 	atomic_set(&efip->efi_next_extent, count);
-	xfs_trans_add_item(tp, &efip->efi_item);
 
 	return &efip->efi_item;
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 01d16e795068..a66bb6aa2e5d 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -240,7 +240,6 @@ xfs_trans_get_cud(
 	cudp->cud_cuip = cuip;
 	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
 
-	xfs_trans_add_item(tp, &cudp->cud_item);
 	return cudp;
 }
 
@@ -315,7 +314,6 @@ xfs_refcount_update_create_intent(
 
 	ASSERT(count > 0);
 
-	xfs_trans_add_item(tp, &cuip->cui_item);
 	if (sort)
 		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(ri, items, ri_list)
@@ -546,7 +544,6 @@ xfs_cui_item_relog(
 	cuip = xfs_cui_init(tp->t_mountp, count);
 	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
 	atomic_set(&cuip->cui_next_extent, count);
-	xfs_trans_add_item(tp, &cuip->cui_item);
 
 	return &cuip->cui_item;
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 96b2dc832d62..d668eb4d099e 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -238,7 +238,6 @@ xfs_trans_get_rud(
 	rudp->rud_ruip = ruip;
 	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
 
-	xfs_trans_add_item(tp, &rudp->rud_item);
 	return rudp;
 }
 
@@ -340,7 +339,6 @@ xfs_rmap_update_create_intent(
 
 	ASSERT(count > 0);
 
-	xfs_trans_add_item(tp, &ruip->rui_item);
 	if (sort)
 		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(ri, items, ri_list)
@@ -599,7 +597,6 @@ xfs_rui_item_relog(
 	ruip = xfs_rui_init(tp->t_mountp, count);
 	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
 	atomic_set(&ruip->rui_next_extent, count);
-	xfs_trans_add_item(tp, &ruip->rui_item);
 
 	return &ruip->rui_item;
 }

