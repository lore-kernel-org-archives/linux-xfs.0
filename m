Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF33ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiJ0RO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiJ0RO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7619F27CC2
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D76DE623EB
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB05C433C1;
        Thu, 27 Oct 2022 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890894;
        bh=PEchyDohFbv0UB6fVSJaT0+lb5k1WEW0jClTZXZSBeo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KZDhligpSxndBkZE73ucC5YcCOEWXw7KFKYKC75adjvo1T1NmNk0ySNJsnj7hkVOh
         2gs6ecGLtFx2+y/WNmsEcXq2/nyk1v21FOylOQEdNl2xEBWTJrmB694P7/dl3CEK1H
         YCd/tKpr35AvDvEqmmxh/hNt6iNK62FnMHIbUAIlUaLWcMMwCtRpt1T8fGacIz8ff1
         zInliQvY7kDhlvTT5nnHBPG9kAJRUMMA0IrNHlEK4o5iaYMJDznjyBIZoo6OUlWiGD
         89wZSAMA448Iy/zP/56cTs26ZvuAtnYv5BMJ+mKXIara7zX6QcFNtwaP14xqjbxTv8
         jTMi60BY50lzg==
Subject: [PATCH 09/12] xfs: check record domain when accessing refcount
 records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:53 -0700
Message-ID: <166689089384.3788582.15595498616742667720.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've separated the startblock and CoW/shared extent domain in
the incore refcount record structure, check the domain whenever we
retrieve a record to ensure that it's still in the domain that we want.
Depending on the circumstances, a change in domain either means we're
done processing or that we've found a corruption and need to fail out.

The refcount check in xchk_xref_is_cow_staging is redundant since
_get_rec has done that for a long time now, so we can get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   53 ++++++++++++++++++++++++++++++++----------
 fs/xfs/scrub/refcount.c      |    4 ++-
 2 files changed, 43 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 3b1cb0578770..608a122eef16 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -386,6 +386,8 @@ xfs_refcount_split_extent(
 		goto out_error;
 	}
 
+	if (rcext.rc_domain != domain)
+		return 0;
 	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
 		return 0;
 
@@ -434,6 +436,9 @@ xfs_refcount_merge_center_extents(
 	int				error;
 	int				found_rec;
 
+	ASSERT(left->rc_domain == center->rc_domain);
+	ASSERT(right->rc_domain == center->rc_domain);
+
 	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, center, right);
 
@@ -510,6 +515,8 @@ xfs_refcount_merge_left_extent(
 	int				error;
 	int				found_rec;
 
+	ASSERT(left->rc_domain == cleft->rc_domain);
+
 	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, cleft);
 
@@ -571,6 +578,8 @@ xfs_refcount_merge_right_extent(
 	int				error;
 	int				found_rec;
 
+	ASSERT(right->rc_domain == cright->rc_domain);
+
 	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, cright, right);
 
@@ -654,12 +663,10 @@ xfs_refcount_find_left_extents(
 		goto out_error;
 	}
 
+	if (tmp.rc_domain != domain)
+		return 0;
 	if (xfs_refc_next(&tmp) != agbno)
 		return 0;
-	if (domain == XFS_REFC_DOMAIN_SHARED && tmp.rc_refcount < 2)
-		return 0;
-	if (domain == XFS_REFC_DOMAIN_COW && tmp.rc_refcount > 1)
-		return 0;
 	/* We have a left extent; retrieve (or invent) the next right one */
 	*left = tmp;
 
@@ -675,6 +682,9 @@ xfs_refcount_find_left_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp starts at the end of our range, just use that */
 		if (tmp.rc_startblock == agbno)
 			*cleft = tmp;
@@ -694,6 +704,7 @@ xfs_refcount_find_left_extents(
 			cleft->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -745,12 +756,10 @@ xfs_refcount_find_right_extents(
 		goto out_error;
 	}
 
+	if (tmp.rc_domain != domain)
+		return 0;
 	if (tmp.rc_startblock != agbno + aglen)
 		return 0;
-	if (domain == XFS_REFC_DOMAIN_SHARED && tmp.rc_refcount < 2)
-		return 0;
-	if (domain == XFS_REFC_DOMAIN_COW && tmp.rc_refcount > 1)
-		return 0;
 	/* We have a right extent; retrieve (or invent) the next left one */
 	*right = tmp;
 
@@ -766,6 +775,9 @@ xfs_refcount_find_right_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp ends at the end of our range, just use that */
 		if (xfs_refc_next(&tmp) == agbno + aglen)
 			*cright = tmp;
@@ -785,6 +797,7 @@ xfs_refcount_find_right_extents(
 			cright->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -894,7 +907,7 @@ xfs_refcount_merge_extents(
 				aglen);
 	}
 
-	return error;
+	return 0;
 }
 
 /*
@@ -966,7 +979,7 @@ xfs_refcount_adjust_extents(
 		error = xfs_refcount_get_rec(cur, &ext, &found_rec);
 		if (error)
 			goto out_error;
-		if (!found_rec) {
+		if (!found_rec || ext.rc_domain != XFS_REFC_DOMAIN_SHARED) {
 			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
@@ -1415,6 +1428,8 @@ xfs_refcount_find_shared(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+	if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED)
+		goto done;
 
 	/* If the extent ends before the start, look at the next one */
 	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
@@ -1430,6 +1445,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
+		if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED)
+			goto done;
 	}
 
 	/* If the extent starts after the range we want, bail out */
@@ -1461,7 +1478,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		if (tmp.rc_startblock >= agbno + aglen ||
+		if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED ||
+		    tmp.rc_startblock >= agbno + aglen ||
 		    tmp.rc_startblock != *fbno + *flen)
 			break;
 		*flen = min(*flen + tmp.rc_blockcount, agbno + aglen - *fbno);
@@ -1552,6 +1570,11 @@ xfs_refcount_adjust_cow_extents(
 	error = xfs_refcount_get_rec(cur, &ext, &found_rec);
 	if (error)
 		goto out_error;
+	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec &&
+				ext.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	if (!found_rec) {
 		ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 		ext.rc_blockcount = 0;
@@ -1761,8 +1784,14 @@ xfs_refcount_recover_extent(
 
 	rr = kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
+
+	if (XFS_IS_CORRUPT(cur->bc_mp,
+			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
+		kmem_free(rr);
+		return -EFSCORRUPTED;
+	}
+
 	list_add_tail(&rr->rr_list, debris);
-
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 98c033072120..8b06dd0bc955 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -441,8 +441,8 @@ xchk_xref_is_cow_staging(
 		return;
 	}
 
-	/* CoW flag must be set, refcount must be 1. */
-	if (rc.rc_domain != XFS_REFC_DOMAIN_COW || rc.rc_refcount != 1)
+	/* CoW lookup returned a shared extent record? */
+	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
 	/* Must be at least as long as what was passed in */

