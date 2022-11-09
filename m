Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2BAC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiKICHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKICHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30D3686A5
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D765B81CE7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F61C433C1;
        Wed,  9 Nov 2022 02:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959649;
        bh=NHUKUfRvJL30Jn4i3f/WcvaDPqB4ZVNyKpwwQ+Mm5gA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZVRhH0k876V9z9Ad8wS7lkEo3ep8z91RbSnbL4TtGuuQSdoOgSVrlcQPcABC7/PnX
         ta4sTpIy1T7zCMVd+Xah/MoqlDs5dd873NB+kr6bcOP/Omap3OVI6Uw2PYX0r584oj
         k25U3klDCViv7MOue9ga0mX2BH//t2fjCwqLNbP7zCRf72/ORXkD9+qBU6AjsrODRV
         YQ7034yHUhKkjVrNDpogLUyMMiwdhHmzh71ZP4d8cSUenGmMPtPGkwJIXooqZxYAAr
         rQEMPpQeW3CelInHswZ4vQAPUqE9O/B4aysfV/b0iRafAKsZDHA9xKel3covfLEHs4
         Q8pq120iKVY9A==
Subject: [PATCH 19/24] xfs: check record domain when accessing refcount
 records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:28 -0800
Message-ID: <166795964870.3761583.7630465137549563227.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 607646ffbb04dd01e73c53f6ae22cfa63f44dfbd

Now that we've separated the startblock and CoW/shared extent domain in
the incore refcount record structure, check the domain whenever we
retrieve a record to ensure that it's still in the domain that we want.
Depending on the circumstances, a change in domain either means we're
done processing or that we've found a corruption and need to fail out.

The refcount check in xchk_xref_is_cow_staging is redundant since
_get_rec has done that for a long time now, so we can get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_refcount.c |   53 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 192014d00c..179b686792 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -380,6 +380,8 @@ xfs_refcount_split_extent(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+	if (rcext.rc_domain != domain)
+		return 0;
 	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
 		return 0;
 
@@ -431,6 +433,9 @@ xfs_refcount_merge_center_extents(
 	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, center, right);
 
+	ASSERT(left->rc_domain == center->rc_domain);
+	ASSERT(right->rc_domain == center->rc_domain);
+
 	/*
 	 * Make sure the center and right extents are not in the btree.
 	 * If the center extent was synthesized, the first delete call
@@ -507,6 +512,8 @@ xfs_refcount_merge_left_extent(
 	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, cleft);
 
+	ASSERT(left->rc_domain == cleft->rc_domain);
+
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
 		error = xfs_refcount_lookup_le(cur, cleft->rc_domain,
@@ -568,6 +575,8 @@ xfs_refcount_merge_right_extent(
 	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, cright, right);
 
+	ASSERT(right->rc_domain == cright->rc_domain);
+
 	/*
 	 * If the extent ending at agbno+aglen (cright) wasn't synthesized,
 	 * remove it.
@@ -648,12 +657,10 @@ xfs_refcount_find_left_extents(
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
 
@@ -669,6 +676,9 @@ xfs_refcount_find_left_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp starts at the end of our range, just use that */
 		if (tmp.rc_startblock == agbno)
 			*cleft = tmp;
@@ -688,6 +698,7 @@ xfs_refcount_find_left_extents(
 			cleft->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -739,12 +750,10 @@ xfs_refcount_find_right_extents(
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
 
@@ -760,6 +769,9 @@ xfs_refcount_find_right_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp ends at the end of our range, just use that */
 		if (xfs_refc_next(&tmp) == agbno + aglen)
 			*cright = tmp;
@@ -779,6 +791,7 @@ xfs_refcount_find_right_extents(
 			cright->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -888,7 +901,7 @@ xfs_refcount_merge_extents(
 				aglen);
 	}
 
-	return error;
+	return 0;
 }
 
 /*
@@ -960,7 +973,7 @@ xfs_refcount_adjust_extents(
 		error = xfs_refcount_get_rec(cur, &ext, &found_rec);
 		if (error)
 			goto out_error;
-		if (!found_rec) {
+		if (!found_rec || ext.rc_domain != XFS_REFC_DOMAIN_SHARED) {
 			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
@@ -1399,6 +1412,8 @@ xfs_refcount_find_shared(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+	if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED)
+		goto done;
 
 	/* If the extent ends before the start, look at the next one */
 	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
@@ -1414,6 +1429,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
+		if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED)
+			goto done;
 	}
 
 	/* If the extent starts after the range we want, bail out */
@@ -1445,7 +1462,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		if (tmp.rc_startblock >= agbno + aglen ||
+		if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED ||
+		    tmp.rc_startblock >= agbno + aglen ||
 		    tmp.rc_startblock != *fbno + *flen)
 			break;
 		*flen = min(*flen + tmp.rc_blockcount, agbno + aglen - *fbno);
@@ -1536,6 +1554,11 @@ xfs_refcount_adjust_cow_extents(
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
@@ -1745,8 +1768,14 @@ xfs_refcount_recover_extent(
 
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
 

