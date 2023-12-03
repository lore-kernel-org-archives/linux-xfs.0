Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42471799C
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpN0nhKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92214C433C8;
	Sun,  3 Dec 2023 19:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630256;
	bh=H/3EYsFG+pGBEgLvIctK7Q12+/XnIQ9ge8FKCOshaXM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lpN0nhKMBWeygf7WmuZozfVqjH+Icji7mFsj0Qx3twuICNB7jg4Fht13kCGfDyU77
	 98IFgeGDe39/LZXbDE56ndCLIKPMnlCvgXB2EzLxOOU5ee7xHnuj6ZWQUb0HPN0RK0
	 RH8XpfAHta3L+xZoS+GF1EH3QG3Hap//AiXPHtw1hp4Y5o1lrGHSj/Th2nNF/8W1z6
	 L+TBQpam0qX37SfwJVmmrwwHK9lHeBAcEm3anboEihnKp9AMo+jJGUzZt6uzpBVz7C
	 3ZA3ofCWRiVQCjTCIVruykthSBFkbTrKffRgt7ngCaL4Mf6q+RnRVGFXC8rxamJquS
	 cHul8YS8o90og==
Date: Sun, 03 Dec 2023 11:04:16 -0800
Subject: [PATCH 6/9] xfs: clean out XFS_LI_DIRTY setting boilerplate from
 ->iop_relog
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990262.3037772.8800837131290023030.stgit@frogsfrogsfrogs>
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

Hoist this dirty flag setting to the ->iop_relog callsite to reduce
boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |    9 +++++++--
 fs/xfs/xfs_attr_item.c     |    1 -
 fs/xfs/xfs_bmap_item.c     |    2 +-
 fs/xfs/xfs_extfree_item.c  |    2 +-
 fs/xfs/xfs_refcount_item.c |    2 +-
 fs/xfs/xfs_rmap_item.c     |    2 +-
 6 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5c477a3a6a6c..0e2ceec97978 100644
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
index e12d97da1f1f..c2a9f1cb7ff6 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -652,7 +652,6 @@ xfs_attri_item_relog(
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
-	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
 
 	return &new_attrip->attri_item;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 653aa4769ab5..949d2b24025e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -583,7 +583,7 @@ xfs_bui_item_relog(
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
 

