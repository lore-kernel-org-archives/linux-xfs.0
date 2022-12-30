Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AAEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbiLaCzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:55:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A34FFB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF46DB81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EA3C433D2;
        Sat, 31 Dec 2022 02:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455343;
        bh=M3ciPI+ve2BlLfnqSC/SMLEh+SJYywmaDU+Mz7Z9g+s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G8BmVBk/cPblMvsgS73L/YpgHYaKma3Mj7Xi+3Lrv21ilVPFTIuzGoEql1cm0gbSD
         dv3spFuz9bbp1atA6nfLvNBHgHxCc1aUwW+1TA4XZ9vsuzJiLV4C+flWVYE2iiWjOT
         90ux7nKnf0JSgVsbYhNJM0vYdDxUGdauvWyXazLzrwbdEnc0uJqw/BoOvEz0AX8TCN
         DnQ3MelyEGmuI12HNo91s7tq9BP4AeXXb9JfRr7lRTwBHXFtQes6jdCFGefJ5jYgCz
         ELnHAGwDRtDdfPZwzCi6Fjbayao+1fRybHviEYIVGqh7G5B1SIkoTo+ZXNVP3jnWQj
         6TpHvIQ6lcVTg==
Subject: [PATCH 06/41] xfs: prepare refcount functions to deal with
 rtrefcountbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:08 -0800
Message-ID: <167243880848.734096.12429395700455110306.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prepare the high-level refcount functions to deal with the new realtime
refcountbt and its slightly different conventions.  Provide the ability
to talk to either refcountbt or rtrefcountbt formats from the same high
level code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |   79 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index e1d8b3c07bd..248761ca1dd 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -23,6 +23,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -39,6 +40,16 @@ STATIC int __xfs_refcount_cow_alloc(struct xfs_btree_cur *rcur,
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
@@ -141,12 +152,35 @@ xfs_refcount_check_perag_irec(
 	return NULL;
 }
 
+static inline xfs_failaddr_t
+xfs_refcount_check_rtgroup_irec(
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
 /* Simple checks for refcount records. */
 xfs_failaddr_t
 xfs_refcount_check_irec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_refcount_irec	*irec)
 {
+	if (cur->bc_btnum == XFS_BTNUM_RTREFC)
+		return xfs_refcount_check_rtgroup_irec(cur->bc_ino.rtg, irec);
 	return xfs_refcount_check_perag_irec(cur->bc_ag.pag, irec);
 }
 
@@ -158,9 +192,15 @@ xfs_refcount_complain_bad_rec(
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
@@ -1053,6 +1093,15 @@ xfs_refcount_merge_extents(
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
@@ -1070,25 +1119,25 @@ xfs_refcount_still_have_space(
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
@@ -1123,7 +1172,7 @@ xfs_refcount_adjust_extents(
 		if (error)
 			goto out_error;
 		if (!found_rec || ext.rc_domain != XFS_REFC_DOMAIN_SHARED) {
-			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+			ext.rc_startblock = xrefc_max_startblock(cur);
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
 			ext.rc_domain = XFS_REFC_DOMAIN_SHARED;
@@ -1147,7 +1196,7 @@ xfs_refcount_adjust_extents(
 			 * Either cover the hole (increment) or
 			 * delete the range (decrement).
 			 */
-			cur->bc_ag.refc.nr_ops++;
+			xrefc_btree_state(cur)->nr_ops++;
 			if (tmp.rc_refcount) {
 				error = xfs_refcount_insert(cur, &tmp,
 						&found_tmp);
@@ -1204,7 +1253,7 @@ xfs_refcount_adjust_extents(
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
-		cur->bc_ag.refc.nr_ops++;
+		xrefc_btree_state(cur)->nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
@@ -1287,7 +1336,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.refc.shape_changes++;
+		xrefc_btree_state(cur)->shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adj);
@@ -1379,8 +1428,8 @@ xfs_refcount_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		nr_ops = rcur->bc_ag.refc.nr_ops;
-		shape_changes = rcur->bc_ag.refc.shape_changes;
+		nr_ops = xrefc_btree_state(rcur)->nr_ops;
+		shape_changes = xrefc_btree_state(rcur)->shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1392,8 +1441,8 @@ xfs_refcount_finish_one(
 			return error;
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, ri->ri_pag);
-		rcur->bc_ag.refc.nr_ops = nr_ops;
-		rcur->bc_ag.refc.shape_changes = shape_changes;
+		xrefc_btree_state(rcur)->nr_ops = nr_ops;
+		xrefc_btree_state(rcur)->shape_changes = shape_changes;
 	}
 	*pcur = rcur;
 
@@ -1688,7 +1737,7 @@ xfs_refcount_adjust_cow_extents(
 		goto out_error;
 	}
 	if (!found_rec) {
-		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+		ext.rc_startblock = xrefc_max_startblock(cur);
 		ext.rc_blockcount = 0;
 		ext.rc_refcount = 0;
 		ext.rc_domain = XFS_REFC_DOMAIN_COW;

