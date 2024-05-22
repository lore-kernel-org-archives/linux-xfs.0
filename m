Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E94C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347175; cv=none; b=f2SiCKSVpwN964330pFd0sO7Top6RjlOUD2+MW/k/Hhv2eGINzaLqbBg3xClE/WdREz5nwVzvTyq45qkdsR9Z89NInwvjf8uLcr8oglRPKe/9RUvqtWvROkbPTO1IpksNp6FtSMoZd1UpD04c0hlwOWCOzoNgCmhfuYjMHHGWug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347175; c=relaxed/simple;
	bh=TBDdEcXpCFtI9gTbdLTudKSORT334gPw4eeZT0sGfZQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iLhW+yxnytuiHzMYynuXIxHgXiKVapuxDO1HQ+06vqTg+FKmZhkVqC5wysIAd74N50TdiJgcNb9vNczBXEU+L0pIxmdXsXmS2Eq7LyE8UWGmBmVB7Kkx9iS33ozezyk+tFnGl88O6ZEm+g3F6/yrGCEJ6ENHRUTtkVLvcONG5zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBimjwTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBimjwTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C277C2BD11;
	Wed, 22 May 2024 03:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347175;
	bh=TBDdEcXpCFtI9gTbdLTudKSORT334gPw4eeZT0sGfZQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LBimjwTbkjnRtCv1C92mxaiuitCtp2t+gWBY2VGTfxkdZdJRPVjdZQOVhVll90Ris
	 71BqjxjMlEn6lhuykhl9aQ2nslEuc46OWuFMuGLm4UbpAodsg+KiGv3S++Ke24/Ddk
	 alUFBz73bdmduzZSl1lkHXJQ8ZBaSyqlzGUR1a2PCK5DFOw649LEFVpc3FQUSbjhLy
	 rVfKQSkVkBbVzp/6ycSkmq2bwvn4if1bIMIEqGt7BqCc27cTCOFUGnnOOxtOygwiMT
	 HrLf1k9PpdRJDrlsNsVxndn47JI9VUSo0PpdGjJPUE/GcQFmCBOVjKsNtKehGHgRcU
	 Ccyzc1ypKmFAg==
Date: Tue, 21 May 2024 20:06:14 -0700
Subject: [PATCH 067/111] xfs: add a sick_mask to struct xfs_btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532703.2478931.352013640253812569.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7f47734ad61af77a001b1e24691dcbfcb008c938

Clean up xfs_btree_mark_sick by adding a sick_mask to the btree-ops
for all AG-root btrees.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    3 +++
 libxfs/xfs_btree.h          |    3 +++
 libxfs/xfs_ialloc_btree.c   |    3 +++
 libxfs/xfs_refcount_btree.c |    2 ++
 libxfs/xfs_rmap_btree.c     |    2 ++
 5 files changed, 13 insertions(+)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index d9e9ba53a..6ad44c146 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -17,6 +17,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_allocbt_cur_cache;
 
@@ -475,6 +476,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
+	.sick_mask		= XFS_SICK_AG_BNOBT,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -506,6 +508,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
+	.sick_mask		= XFS_SICK_AG_CNTBT,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 6bc609620..6e5fd0c06 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -142,6 +142,9 @@ struct xfs_btree_ops {
 	/* offset of btree stats array */
 	unsigned int		statoff;
 
+	/* sick mask for health reporting (only for XFS_BTREE_TYPE_AG) */
+	unsigned int		sick_mask;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5e8a47563..08076ef12 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_inobt_cur_cache;
 
@@ -407,6 +408,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_ibt_2),
+	.sick_mask		= XFS_SICK_AG_INOBT,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
@@ -436,6 +438,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 
 	.lru_refs		= XFS_INO_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
+	.sick_mask		= XFS_SICK_AG_FINOBT,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 397ce2131..31ef879ba 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -20,6 +20,7 @@
 #include "xfs_bit.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_refcountbt_cur_cache;
 
@@ -326,6 +327,7 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_refcbt_2),
+	.sick_mask		= XFS_SICK_AG_REFCNTBT,
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 5bf5340c8..c7ca20043 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rmapbt_cur_cache;
 
@@ -481,6 +482,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_2),
+	.sick_mask		= XFS_SICK_AG_RMAPBT,
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,

