Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA1985648
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817022; cv=none; b=L+btqpML1kNRY00x9hHIXUs0Oal2P6gu7rKtjH8ZxxVw0XVyCBF2ENjPKestytLgha9rkm6K15CSYIXcNgpisU5b8v3eH1XV44Ukha7Pk150WXVkwvMUSGoaSS+ecZx8XSCCJAj1lZlVK0ttz10b7KsfxWxPnOFWk5R6FB07Nmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817022; c=relaxed/simple;
	bh=q76PfXTYKf4anNiS08Gsx58JwxVAG6LqHPbnwKBijUg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uAE4CjJS1//yXvtYTRHkkC7vh8uHcl0c0j9HT6v2uqfH9CHMo/jvHTJJpyKR6I3kMKGIt7ddpEoeOXviypigEidy4Yr8M6YZYXuQ1rVxfOsO3vqq9O+VsGYznjMDOFweH1uIKOkVMLP2U0+LbOzO2ZBI5+xjo0V0yQj9hDE+VQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5iijJB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5iijJB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D43C433F1;
	Thu,  1 Feb 2024 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817021;
	bh=q76PfXTYKf4anNiS08Gsx58JwxVAG6LqHPbnwKBijUg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p5iijJB80iHb57S4aPi2CYAV1al91r3aip+oZXLELZ83nVGnC/p9m42w8qzhN9W13
	 tVLsC3IYp7aTGXg9upauNt2nLCVnZ/Tt93vJeAtHqBg27JSQ1BhDDvSO3tqR9fPWmF
	 54ELTQm1NAdAt8UpYqhJoortswkM9T7bteA//LcYQFN/v2kd295cqy/4RtMugS+3iW
	 q0712GmYbX9Pxu8S1aSh3qqySFcM/P+Cmdqtc0PqmP63R5r1ztV1Nf2tCUdpR0QCdq
	 d41yzMhki8xvpBl/kFRgH8VsUYfYou9/y8ID+ciaCo9XjvD9zyTTT1sVd/MET5LUhF
	 mKiKso+bTsP7w==
Date: Thu, 01 Feb 2024 11:50:21 -0800
Subject: [PATCH 18/27] xfs: add a sick_mask to struct xfs_btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335080.1605438.5328573408750314240.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Clean up xfs_btree_mark_sick by adding a sick_mask to the btree-ops
for all AG-root btrees.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    3 +++
 fs/xfs/libxfs/xfs_btree.h          |    3 +++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 +++
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 ++
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 ++
 fs/xfs/xfs_health.c                |   36 +++++++++++-------------------------
 6 files changed, 24 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 262f5dc3a483e..e0b0cdd8f344c 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -16,6 +16,7 @@
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
@@ -477,6 +478,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
+	.sick_mask		= XFS_SICK_AG_BNOBT,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -508,6 +510,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
+	.sick_mask		= XFS_SICK_AG_CNTBT,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 1b27649905bbb..01d6eac267655 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -142,6 +142,9 @@ struct xfs_btree_ops {
 	/* offset of btree stats array */
 	unsigned int		statoff;
 
+	/* sick mask for health reporting (only for XFS_BTREE_TYPE_AG) */
+	unsigned int		sick_mask;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ddb9a226914a8..1fe9d83c575ea 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -17,6 +17,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
@@ -408,6 +409,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_ibt_2),
+	.sick_mask		= XFS_SICK_AG_INOBT,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
@@ -437,6 +439,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
+	.sick_mask		= XFS_SICK_AG_FINOBT,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 16677cbbddfcc..6388a0c9b6915 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -16,6 +16,7 @@
 #include "xfs_refcount.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
@@ -327,6 +328,7 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_refcbt_2),
+	.sick_mask		= XFS_SICK_AG_REFCNTBT,
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index e1ddf814492c5..abaf5e190e998 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -16,6 +16,7 @@
 #include "xfs_btree_staging.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
@@ -483,6 +484,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_2),
+	.sick_mask		= XFS_SICK_AG_RMAPBT,
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 2be1ac83f4c41..c5ed6ff08a616 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -510,36 +510,22 @@ void
 xfs_btree_mark_sick(
 	struct xfs_btree_cur		*cur)
 {
-	unsigned int			mask;
-
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BMAP:
-		xfs_bmap_mark_sick(cur->bc_ino.ip, cur->bc_ino.whichfork);
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_AG:
+		ASSERT(cur->bc_ops->sick_mask);
+		xfs_ag_mark_sick(cur->bc_ag.pag, cur->bc_ops->sick_mask);
 		return;
-	case XFS_BTNUM_BNO:
-		mask = XFS_SICK_AG_BNOBT;
-		break;
-	case XFS_BTNUM_CNT:
-		mask = XFS_SICK_AG_CNTBT;
-		break;
-	case XFS_BTNUM_INO:
-		mask = XFS_SICK_AG_INOBT;
-		break;
-	case XFS_BTNUM_FINO:
-		mask = XFS_SICK_AG_FINOBT;
-		break;
-	case XFS_BTNUM_RMAP:
-		mask = XFS_SICK_AG_RMAPBT;
-		break;
-	case XFS_BTNUM_REFC:
-		mask = XFS_SICK_AG_REFCNTBT;
-		break;
+	case XFS_BTREE_TYPE_INODE:
+		if (cur->bc_btnum == XFS_BTNUM_BMAP) {
+			xfs_bmap_mark_sick(cur->bc_ino.ip,
+					   cur->bc_ino.whichfork);
+			return;
+		}
+		fallthrough;
 	default:
 		ASSERT(0);
 		return;
 	}
-
-	xfs_ag_mark_sick(cur->bc_ag.pag, mask);
 }
 
 /*

