Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF9517993
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8NBOJZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F231C433C8;
	Sun,  3 Dec 2023 19:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630225;
	bh=clEuZ8KYsLdCVnz3mknkWBP0aWor0n2RrMPhijIO3Fw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g8NBOJZPkD21GuahPfKD9an9nT6HM8ehj92LVk0Sov2po+XZc2oXeTxYWGmxf6X1o
	 h+4CH8sHJJeEdrVOpUx41VSvtYOaraJ3wiTdchxgMYteSFzHk72ZMDJmbDeBKO+Xg+
	 9CaYwOGv5HnJ4GaYNYZu/KG+XbvhDjiXnL9LA4LRyAjRF48CAqGkpOJGhv5k1MGNMc
	 rkFIPEp2T6/AwHK+/mK+Uk4XO/DlGW3SYe1kBNxilSVjyUEyGBeIeXM1pwwBr3iHxR
	 IOLXC22oXJUosOwzi9Q7mK+mHGwYnxjvyTldslI3mV5mofIsNDDXTYpFwyTL9xilqP
	 HouVPR45JuxhQ==
Date: Sun, 03 Dec 2023 11:03:44 -0800
Subject: [PATCH 4/9] xfs: hoist ->create_intent boilerplate to its callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990231.3037772.4009995462926348210.stgit@frogsfrogsfrogs>
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

Hoist the dirty flag setting code out of each ->create_intent
implementation up to the callsite to reduce boilerplate further.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |    2 ++
 fs/xfs/xfs_attr_item.c     |    3 ---
 fs/xfs/xfs_bmap_item.c     |    3 ---
 fs/xfs/xfs_extfree_item.c  |    3 ---
 fs/xfs/xfs_refcount_item.c |    3 ---
 fs/xfs/xfs_rmap_item.c     |    3 ---
 6 files changed, 2 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e2cdefa42059..381bfd46564d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -214,6 +214,8 @@ xfs_defer_create_intent(
 	if (IS_ERR(lip))
 		return PTR_ERR(lip);
 
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
 }
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5589438d5ea1..5376bac383f3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -319,9 +319,6 @@ xfs_attr_log_item(
 {
 	struct xfs_attri_log_format	*attrp;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
-
 	/*
 	 * At this point the xfs_attr_intent has been constructed, and we've
 	 * created the log intent. Fill in the attri log item and log format
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index da5c91cc00cc..ce03e5c37ba3 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -286,9 +286,6 @@ xfs_bmap_update_log_item(
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
-
 	/*
 	 * atomic_inc_return gives us the value after the increment;
 	 * we want to use it as an array index so we need to subtract 1 from
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 581a70acd1ac..d07cdc3eb809 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -390,9 +390,6 @@ xfs_extent_free_log_item(
 	uint				next_extent;
 	struct xfs_extent		*extp;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
-
 	/*
 	 * atomic_inc_return gives us the value after the increment;
 	 * we want to use it as an array index so we need to subtract 1 from
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7273f538db2e..f604b7e3b77e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -289,9 +289,6 @@ xfs_refcount_update_log_item(
 	uint				next_extent;
 	struct xfs_phys_extent		*pmap;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
-
 	/*
 	 * atomic_inc_return gives us the value after the increment;
 	 * we want to use it as an array index so we need to subtract 1 from
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index d54fd925b746..05841548691d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -311,9 +311,6 @@ xfs_rmap_update_log_item(
 	uint				next_extent;
 	struct xfs_map_extent		*map;
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
-
 	/*
 	 * atomic_inc_return gives us the value after the increment;
 	 * we want to use it as an array index so we need to subtract 1 from

