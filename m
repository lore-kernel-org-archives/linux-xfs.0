Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B8F1845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twiiWCzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE92C433C7;
	Thu,  7 Dec 2023 02:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916004;
	bh=QN4b4U8BrkCNcxKaxCCt81T5iJOe2DShBASkdJp6a7w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=twiiWCzk3izRd/LqmF+TylR/6hCANKLUZQgYEwTzFGkEc2CLVsLMDFJPqYiBXDp+2
	 RCV/g/pqioMXltnnzlaqouROwJnd6emj/E6anVgvIaYNANwePBZ3/W6FNV0aDj8aDA
	 0J6U+rvfZRz64KWTYVXmJcKZD+p6yokKhOQr1W2wAe+U+5KjE9JcQptPHH5iSynGxo
	 QEagFxGV209o6OqN36hrnm/KeyXE48l3oLfaGkIoJ+NSce3AxzkbcgzHaX0O+tG0SV
	 +MrJEPRP9for24HEVGSUxmAN+gHE1icAlH7qoDK5M2M14kBb9AUNrjjwwVkJmLWOni
	 WuaLX1Hkbly2w==
Date: Wed, 06 Dec 2023 18:26:43 -0800
Subject: [PATCH 6/9] xfs: clean out XFS_LI_DIRTY setting boilerplate from
 ->iop_relog
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562482.1133395.1238338039381278263.stgit@frogsfrogsfrogs>
In-Reply-To: <170191562370.1133395.5436656395520338293.stgit@frogsfrogsfrogs>
References: <170191562370.1133395.5436656395520338293.stgit@frogsfrogsfrogs>
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

Hoist this dirty flag setting to the ->iop_relog callsite to reduce
boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c  |    9 +++++++--
 fs/xfs/xfs_attr_item.c     |    1 -
 fs/xfs/xfs_bmap_item.c     |    2 +-
 fs/xfs/xfs_extfree_item.c  |    2 +-
 fs/xfs/xfs_refcount_item.c |    2 +-
 fs/xfs/xfs_rmap_item.c     |    2 +-
 6 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 63b9960a96e1..aa19ede91a57 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -474,6 +474,8 @@ xfs_defer_relog(
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	list_for_each_entry(dfp, dfops, dfp_list) {
+		struct xfs_log_item	*lip;
+
 		/*
 		 * If the log intent item for this deferred op is not a part of
 		 * the current log checkpoint, relog the intent item to keep
@@ -502,9 +504,12 @@ xfs_defer_relog(
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 
 		xfs_defer_create_done(*tpp, dfp);
-		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent,
-				dfp->dfp_done, *tpp);
+		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
+				*tpp);
+		if (lip)
+			set_bit(XFS_LI_DIRTY, &lip->li_flags);
 		dfp->dfp_done = NULL;
+		dfp->dfp_intent = lip;
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e9813fa64461..5d86a4b8b457 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -655,7 +655,6 @@ xfs_attri_item_relog(
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
-	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
 
 	return &new_attrip->attri_item;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ba385c06de5d..ef72061d7cec 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -586,7 +586,7 @@ xfs_bui_item_relog(
 	memcpy(buip->bui_format.bui_extents, map, count * sizeof(*map));
 	atomic_set(&buip->bui_next_extent, count);
 	xfs_trans_add_item(tp, &buip->bui_item);
-	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
+
 	return &buip->bui_item;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 807398479187..e2e86f2edb3c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -709,7 +709,7 @@ xfs_efi_item_relog(
 	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
 	atomic_set(&efip->efi_next_extent, count);
 	xfs_trans_add_item(tp, &efip->efi_item);
-	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
+
 	return &efip->efi_item;
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 142839a8e7b1..01d16e795068 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -547,7 +547,7 @@ xfs_cui_item_relog(
 	memcpy(cuip->cui_format.cui_extents, pmap, count * sizeof(*pmap));
 	atomic_set(&cuip->cui_next_extent, count);
 	xfs_trans_add_item(tp, &cuip->cui_item);
-	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
+
 	return &cuip->cui_item;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e2730b3e0d96..96b2dc832d62 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -600,7 +600,7 @@ xfs_rui_item_relog(
 	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
 	atomic_set(&ruip->rui_next_extent, count);
 	xfs_trans_add_item(tp, &ruip->rui_item);
-	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
+
 	return &ruip->rui_item;
 }
 

