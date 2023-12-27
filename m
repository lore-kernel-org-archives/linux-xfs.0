Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8377EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THXKdEJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27285C433C8;
	Mon,  1 Jan 2024 00:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068863;
	bh=0r5FQvmIWf80pRqQPfIl1LR611YEAXl9r9KY0FB9lTQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=THXKdEJi7tSY0ckhWrwDf+gpuyZhJnn9Z5X6kGBXKcLtKENvGYfkn3q6GMU+nG2dQ
	 eO0OtmkYU8+hOtmM4rOcYCEYOvXKRgWGVu/dyOP54jtotfTH4p48Q1ZyXHcZNDLb4j
	 bVZ1B+OAilqMFgLfiYb3+Mv1nUGmOC5wvl5AhdujIRqCF37lUL5+X/axGjcIIccEWG
	 5Pb26/kElc2r5nh9JtEEGz/NQaQdO/SiMdTRqObU98DGF0wcnlThi5/cyXS0C6nnDX
	 aRIz/iBSEamNP6iyE/WQIxBGUCjZTIx+2tPZ0jqdYe/f3ygdOYeLSjzvL9ZC/j9FR4
	 7nhIlZZxjhJyg==
Date: Sun, 31 Dec 2023 16:27:42 +9900
Subject: [PATCH 06/42] xfs: prepare refcount functions to deal with
 rtrefcountbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017205.1817107.16017049002658007547.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Prepare the high-level refcount functions to deal with the new realtime
refcountbt and its slightly different conventions.  Provide the ability
to talk to either refcountbt or rtrefcountbt formats from the same high
level code.

Note that we leave the _recover_cow_leftovers functions for a separate
patch so that we can convert it all at once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |   93 ++++++++++++++++++++++++++++++++++++++++---------
 libxfs/xfs_refcount.h |    3 ++
 2 files changed, 78 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index e98d5ea6ca2..2202d9cfb37 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -24,6 +24,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "defer_item.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -40,6 +41,16 @@ STATIC int __xfs_refcount_cow_alloc(struct xfs_btree_cur *rcur,
 STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 		xfs_agblock_t agbno, xfs_extlen_t aglen);
 
+/* Return the maximum startblock number of the refcountbt. */
+static inline xfs_agblock_t
+xrefc_max_startblock(
+	struct xfs_btree_cur	*cur)
+{
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC)
+		return cur->bc_mp->m_sb.sb_rgblocks;
+	return cur->bc_mp->m_sb.sb_agblocks;
+}
+
 /*
  * Look up the first record less than or equal to [bno, len] in the btree
  * given by cur.
@@ -143,6 +154,37 @@ xfs_refcount_check_irec(
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
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC)
+		return xfs_rtrefcount_check_irec(cur->bc_ino.rtg, irec);
+	return xfs_refcount_check_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_refcount_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
@@ -151,9 +193,15 @@ xfs_refcount_complain_bad_rec(
 {
 	struct xfs_mount		*mp = cur->bc_mp;
 
-	xfs_warn(mp,
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC) {
+		xfs_warn(mp,
+ "RT Refcount BTree record corruption in rtgroup %u detected at %pS!",
+				cur->bc_ino.rtg->rtg_rgno, fa);
+	} else {
+		xfs_warn(mp,
  "Refcount BTree record corruption in AG %d detected at %pS!",
 				cur->bc_ag.pag->pag_agno, fa);
+	}
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
@@ -179,7 +227,7 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, irec);
+	fa = xfs_refcount_check_btrec(cur, irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
@@ -1046,6 +1094,15 @@ xfs_refcount_merge_extents(
 	return 0;
 }
 
+static inline struct xbtree_refc *
+xrefc_btree_state(
+	struct xfs_btree_cur	*cur)
+{
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC)
+		return &cur->bc_ino.refc;
+	return &cur->bc_ag.refc;
+}
+
 /*
  * XXX: This is a pretty hand-wavy estimate.  The penalty for guessing
  * true incorrectly is a shutdown FS; the penalty for guessing false
@@ -1063,25 +1120,25 @@ xfs_refcount_still_have_space(
 	 * to handle each of the shape changes to the refcount btree.
 	 */
 	overhead = xfs_allocfree_block_count(cur->bc_mp,
-				cur->bc_ag.refc.shape_changes);
-	overhead += cur->bc_mp->m_refc_maxlevels;
+				xrefc_btree_state(cur)->shape_changes);
+	overhead += cur->bc_maxlevels;
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
 	/*
 	 * Only allow 2 refcount extent updates per transaction if the
 	 * refcount continue update "error" has been injected.
 	 */
-	if (cur->bc_ag.refc.nr_ops > 2 &&
+	if (xrefc_btree_state(cur)->nr_ops > 2 &&
 	    XFS_TEST_ERROR(false, cur->bc_mp,
 			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
-	if (cur->bc_ag.refc.nr_ops == 0)
+	if (xrefc_btree_state(cur)->nr_ops == 0)
 		return true;
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
 	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_ag.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
+		xrefc_btree_state(cur)->nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
@@ -1116,7 +1173,7 @@ xfs_refcount_adjust_extents(
 		if (error)
 			goto out_error;
 		if (!found_rec || ext.rc_domain != XFS_REFC_DOMAIN_SHARED) {
-			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+			ext.rc_startblock = xrefc_max_startblock(cur);
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
 			ext.rc_domain = XFS_REFC_DOMAIN_SHARED;
@@ -1140,7 +1197,7 @@ xfs_refcount_adjust_extents(
 			 * Either cover the hole (increment) or
 			 * delete the range (decrement).
 			 */
-			cur->bc_ag.refc.nr_ops++;
+			xrefc_btree_state(cur)->nr_ops++;
 			if (tmp.rc_refcount) {
 				error = xfs_refcount_insert(cur, &tmp,
 						&found_tmp);
@@ -1200,7 +1257,7 @@ xfs_refcount_adjust_extents(
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
-		cur->bc_ag.refc.nr_ops++;
+		xrefc_btree_state(cur)->nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
@@ -1286,7 +1343,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.refc.shape_changes++;
+		xrefc_btree_state(cur)->shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adj);
@@ -1360,8 +1417,8 @@ xfs_refcount_finish_one(
 	 * the startblock, get one now.
 	 */
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		nr_ops = rcur->bc_ag.refc.nr_ops;
-		shape_changes = rcur->bc_ag.refc.shape_changes;
+		nr_ops = xrefc_btree_state(rcur)->nr_ops;
+		shape_changes = xrefc_btree_state(rcur)->shape_changes;
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1374,8 +1431,8 @@ xfs_refcount_finish_one(
 
 		*pcur = rcur = xfs_refcountbt_init_cursor(mp, tp, agbp,
 							  ri->ri_pag);
-		rcur->bc_ag.refc.nr_ops = nr_ops;
-		rcur->bc_ag.refc.shape_changes = shape_changes;
+		xrefc_btree_state(rcur)->nr_ops = nr_ops;
+		xrefc_btree_state(rcur)->shape_changes = shape_changes;
 	}
 
 	switch (ri->ri_type) {
@@ -1666,7 +1723,7 @@ xfs_refcount_adjust_cow_extents(
 		goto out_error;
 	}
 	if (!found_rec) {
-		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+		ext.rc_startblock = xrefc_max_startblock(cur);
 		ext.rc_blockcount = 0;
 		ext.rc_refcount = 0;
 		ext.rc_domain = XFS_REFC_DOMAIN_COW;
@@ -1877,7 +1934,7 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
+	if (xfs_refcount_check_btrec(cur, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		xfs_btree_mark_sick(cur);
@@ -2026,7 +2083,7 @@ xfs_refcount_query_range_helper(
 	xfs_failaddr_t			fa;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_refcount_check_btrec(cur, &irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 68acb0b1b4a..13344b402a7 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
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
 

