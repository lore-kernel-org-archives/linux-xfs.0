Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3794718A6D7
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995272; cv=none; b=W4ORrBP+tjto9iCjc+qDSwsbbaaZpDS59JssiNQDtKgemVOTSqAnXXu25rx0vWItX3u5gYZWMtdwJ3/7XSXTByZxrzRpfEDoyJY9yigskBpMXPPqvbZUoWai6qTSkdAM1HO6TpJJPa8t0pq94fhVI2ExMwKdecpgnyIWTcIDyi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995272; c=relaxed/simple;
	bh=3Uxl+3GCJUguFPnIGcNEmiUh52/7Q6XB6vpQRA2QlwE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrFRG9sczUaEJoN56UyCCcWEvJU4fGnzUuQXM1HhxtCO53KKL+8Lq2Q/Lwa9ox9oSkuhKZVU2uJ9xEGEIkQbhBahsYu/byiSSbdeNA4YxFCVfQBuWoooncPnHqBj4yIJP/KS4hf8P1K6LuYRQqtbJkyNCTI9AQ0jPCTXFi1b/PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivLGmB6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivLGmB6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5588C4CED3;
	Mon, 23 Dec 2024 23:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995271;
	bh=3Uxl+3GCJUguFPnIGcNEmiUh52/7Q6XB6vpQRA2QlwE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ivLGmB6dwzeSJKfJjM9AOhJWqQNfhQPTSaI9J6BOf65HwtDoGuH50ANPDjQ+jZf5u
	 Am7lsG3RuRRk3b7Wgx57Uw5yKsmdEyohKnOUhJST4FtdU+F3oO6bOyWVykDHRxHzMR
	 iuFWWmdEjF+xwqtXwe8g4m23l8l8g0NgQGmDUGmEBDQ+zmyn+Z5yv+/2xpFGOebmSF
	 zr8DDnY1O3QsevNaEkTZu/ORFaiQnEi8JGuFoAmfUNauREjDxfQntr2WjK6kT7lh/d
	 XKNnlkUgzy3Oi2zDp9e13AYtRtra3LFC+LZ3WKbTOLkLZ4nWgfpKzdp12W6603/fU3
	 jtqBwlr5pbRtA==
Date: Mon, 23 Dec 2024 15:07:51 -0800
Subject: [PATCH 06/43] xfs: prepare refcount functions to deal with
 rtrefcountbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420041.2381378.12271945309564784026.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Prepare the high-level refcount functions to deal with the new realtime
refcountbt and its slightly different conventions.  Provide the ability
to talk to either refcountbt or rtrefcountbt formats from the same high
level code.

Note that we leave the _recover_cow_leftovers functions for a separate
patch so that we can convert it all at once.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_refcount.c |   53 ++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_refcount.h |    3 ++
 2 files changed, 48 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index faace12fe2e383..9be40ac16c7d56 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_refcount_item.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -144,6 +145,37 @@ xfs_refcount_check_irec(
 	return NULL;
 }
 
+xfs_failaddr_t
+xfs_rtrefcount_check_irec(
+	struct xfs_rtgroup		*rtg,
+	const struct xfs_refcount_irec	*irec)
+{
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > XFS_REFC_LEN_MAX)
+		return __this_address;
+
+	if (!xfs_refcount_check_domain(irec))
+		return __this_address;
+
+	/* check for valid extent range, including overflow */
+	if (!xfs_verify_rgbext(rtg, irec->rc_startblock, irec->rc_blockcount))
+		return __this_address;
+
+	if (irec->rc_refcount == 0 || irec->rc_refcount > XFS_REFC_REFCOUNT_MAX)
+		return __this_address;
+
+	return NULL;
+}
+
+static inline xfs_failaddr_t
+xfs_refcount_check_btrec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*irec)
+{
+	if (xfs_btree_is_rtrefcount(cur->bc_ops))
+		return xfs_rtrefcount_check_irec(to_rtg(cur->bc_group), irec);
+	return xfs_refcount_check_irec(to_perag(cur->bc_group), irec);
+}
+
 static inline int
 xfs_refcount_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
@@ -152,9 +184,15 @@ xfs_refcount_complain_bad_rec(
 {
 	struct xfs_mount		*mp = cur->bc_mp;
 
-	xfs_warn(mp,
+	if (xfs_btree_is_rtrefcount(cur->bc_ops)) {
+		xfs_warn(mp,
+ "RT Refcount BTree record corruption in rtgroup %u detected at %pS!",
+				cur->bc_group->xg_gno, fa);
+	} else {
+		xfs_warn(mp,
  "Refcount BTree record corruption in AG %d detected at %pS!",
 				cur->bc_group->xg_gno, fa);
+	}
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
@@ -180,7 +218,7 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	fa = xfs_refcount_check_irec(to_perag(cur->bc_group), irec);
+	fa = xfs_refcount_check_btrec(cur, irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
@@ -1065,7 +1103,7 @@ xfs_refcount_still_have_space(
 	 */
 	overhead = xfs_allocfree_block_count(cur->bc_mp,
 				cur->bc_refc.shape_changes);
-	overhead += cur->bc_mp->m_refc_maxlevels;
+	overhead += cur->bc_maxlevels;
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
 	/*
@@ -1117,7 +1155,7 @@ xfs_refcount_adjust_extents(
 		if (error)
 			goto out_error;
 		if (!found_rec || ext.rc_domain != XFS_REFC_DOMAIN_SHARED) {
-			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+			ext.rc_startblock = xfs_group_max_blocks(cur->bc_group);
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
 			ext.rc_domain = XFS_REFC_DOMAIN_SHARED;
@@ -1666,7 +1704,7 @@ xfs_refcount_adjust_cow_extents(
 		goto out_error;
 	}
 	if (!found_rec) {
-		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+		ext.rc_startblock = xfs_group_max_blocks(cur->bc_group);
 		ext.rc_blockcount = 0;
 		ext.rc_refcount = 0;
 		ext.rc_domain = XFS_REFC_DOMAIN_COW;
@@ -1877,8 +1915,7 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (xfs_refcount_check_irec(to_perag(cur->bc_group), &rr->rr_rrec) !=
-			NULL ||
+	if (xfs_refcount_check_btrec(cur, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		xfs_btree_mark_sick(cur);
@@ -2026,7 +2063,7 @@ xfs_refcount_query_range_helper(
 	xfs_failaddr_t			fa;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
-	fa = xfs_refcount_check_irec(to_perag(cur->bc_group), &irec);
+	fa = xfs_refcount_check_btrec(cur, &irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, &irec);
 
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 62d78afcf1f3ff..9cd58d48716f83 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -12,6 +12,7 @@ struct xfs_perag;
 struct xfs_btree_cur;
 struct xfs_bmbt_irec;
 struct xfs_refcount_irec;
+struct xfs_rtgroup;
 
 extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
 		enum xfs_refc_domain domain, xfs_agblock_t bno, int *stat);
@@ -120,6 +121,8 @@ extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
 xfs_failaddr_t xfs_refcount_check_irec(struct xfs_perag *pag,
 		const struct xfs_refcount_irec *irec);
+xfs_failaddr_t xfs_rtrefcount_check_irec(struct xfs_rtgroup *rtg,
+		const struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 

