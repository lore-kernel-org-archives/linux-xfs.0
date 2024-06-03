Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F379513B59B
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441772; cv=none; b=VSbjSKSZhYb3XI64EOUbaueVS2XuCluJyQHqOgVAoXORQpjdU1vjlgcLaopG5sbiYhDo0ZAuXHkZmldfagsdPbO/lq/MHB9LURUBzavhJOSSQWsoSX9KRcsdyKBOhmvP3ciM/JeJOHXS1xkBW3tP0fPfVBCeXZMPoMS7+M46IEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441772; c=relaxed/simple;
	bh=p6mu0GMB1G9uYBGQ5Lbc78+2mu068Bh0Ek57TpXaDyk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRtqroHYH6UFeYeH3FCx9Vgz/d3vfgiXMN5a7zDHHJTmZs7gCmfwvsuMkK7c0n9u+V2hUS0ipQdUS/65RNhyNLel4cGzr/RQLVMno96nN3eBwoEstCp++oaaTOaLXPJIlQhiIOxwqvnx+PA80L25nYRS8hoDdbbNC2SLJyZuwSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iz1Jyklz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iz1Jyklz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4899C2BD10;
	Mon,  3 Jun 2024 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441771;
	bh=p6mu0GMB1G9uYBGQ5Lbc78+2mu068Bh0Ek57TpXaDyk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iz1JyklzvTbpJp2QHx9lEC0+eiSylGM+78xoHz7T+QH7oGI6H//2GqfF8SNLayQyv
	 JpWsoQR6LwbvghVh2dOhHuuSrUbrT6eexSw01TJ+TyAObN7iXgvE99h+p07G2PSi1E
	 0LGq8M2OTYlPwHr3/KyQlMW9svIVtyI/1EtF/Rz1rZvIOehS2ZOYWUOO4H8bZtUQwP
	 msTa37igGJccgCrs4Tvxvi4muS9Xi4c2jHbaQlyfzK4hK/+0E9J4EY44bGdy8PIVVu
	 bRjQ/5Ahh17dATKBmaUMGULmBLxMmvzaLfe05Tu2OEGRYJUvHSHQT02wehlk/zeLtL
	 2x3APitsGbLrA==
Date: Mon, 03 Jun 2024 12:09:31 -0700
Subject: [PATCH 067/111] xfs: add a sick_mask to struct xfs_btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040380.1443973.15898930705602622111.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

