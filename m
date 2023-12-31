Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B60FC147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lx/6Avp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17872C433C8;
	Sun, 31 Dec 2023 21:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059184;
	bh=pRFGtQGLibC8wfaokqTD/GXOcQqskZY77SX2EwFMbsI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lx/6Avp3yK4YDBTt23m2YFnN8NyKHurS/QP0kcFZHlOiZw0jqnP3em2D+2vvPt9R5
	 eBd1ropSZqrlr0cmDvCWddBSKX411p5FByppYvlqreBRqX9OXAqwDk6JG455aIqPXu
	 /OxqqTUkvuJ1onza/Yv9Fdw+xyhRzJEUgPu2BEKm3qcQgqgha1CsyCAImj/V68sbiO
	 tPwzk4bpc9xm6NVojS8RtjKB/uHSeEQ0E0sbQnTwt/sHwShazaR5NUpzwhq76ZqFwM
	 ffqsw0l4AJYobhv0fGEerBfsDuzV5mOM+MhlB4yE/yvktAz8HHFmMIzr7mTU0rfi1y
	 BnriEjAg0PGyg==
Date: Sun, 31 Dec 2023 13:46:23 -0800
Subject: [PATCH 07/44] xfs: prepare refcount functions to deal with
 rtrefcountbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851694.1766284.12214907704820439385.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_refcount.c |   93 ++++++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_refcount.h |    3 +
 2 files changed, 78 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b29a718737c59..269b950399071 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_refcount_item.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -41,6 +42,16 @@ STATIC int __xfs_refcount_cow_alloc(struct xfs_btree_cur *rcur,
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
@@ -144,6 +155,37 @@ xfs_refcount_check_irec(
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
@@ -152,9 +194,15 @@ xfs_refcount_complain_bad_rec(
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
@@ -180,7 +228,7 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, irec);
+	fa = xfs_refcount_check_btrec(cur, irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
@@ -1047,6 +1095,15 @@ xfs_refcount_merge_extents(
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
@@ -1064,25 +1121,25 @@ xfs_refcount_still_have_space(
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
@@ -1117,7 +1174,7 @@ xfs_refcount_adjust_extents(
 		if (error)
 			goto out_error;
 		if (!found_rec || ext.rc_domain != XFS_REFC_DOMAIN_SHARED) {
-			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+			ext.rc_startblock = xrefc_max_startblock(cur);
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
 			ext.rc_domain = XFS_REFC_DOMAIN_SHARED;
@@ -1141,7 +1198,7 @@ xfs_refcount_adjust_extents(
 			 * Either cover the hole (increment) or
 			 * delete the range (decrement).
 			 */
-			cur->bc_ag.refc.nr_ops++;
+			xrefc_btree_state(cur)->nr_ops++;
 			if (tmp.rc_refcount) {
 				error = xfs_refcount_insert(cur, &tmp,
 						&found_tmp);
@@ -1201,7 +1258,7 @@ xfs_refcount_adjust_extents(
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
-		cur->bc_ag.refc.nr_ops++;
+		xrefc_btree_state(cur)->nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
@@ -1287,7 +1344,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.refc.shape_changes++;
+		xrefc_btree_state(cur)->shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adj);
@@ -1361,8 +1418,8 @@ xfs_refcount_finish_one(
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
@@ -1375,8 +1432,8 @@ xfs_refcount_finish_one(
 
 		*pcur = rcur = xfs_refcountbt_init_cursor(mp, tp, agbp,
 							  ri->ri_pag);
-		rcur->bc_ag.refc.nr_ops = nr_ops;
-		rcur->bc_ag.refc.shape_changes = shape_changes;
+		xrefc_btree_state(rcur)->nr_ops = nr_ops;
+		xrefc_btree_state(rcur)->shape_changes = shape_changes;
 	}
 
 	switch (ri->ri_type) {
@@ -1667,7 +1724,7 @@ xfs_refcount_adjust_cow_extents(
 		goto out_error;
 	}
 	if (!found_rec) {
-		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+		ext.rc_startblock = xrefc_max_startblock(cur);
 		ext.rc_blockcount = 0;
 		ext.rc_refcount = 0;
 		ext.rc_domain = XFS_REFC_DOMAIN_COW;
@@ -1878,7 +1935,7 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
+	if (xfs_refcount_check_btrec(cur, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		xfs_btree_mark_sick(cur);
@@ -2027,7 +2084,7 @@ xfs_refcount_query_range_helper(
 	xfs_failaddr_t			fa;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_refcount_check_btrec(cur, &irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, &irec);
 
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 68acb0b1b4a87..13344b402a72c 100644
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
 

