Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD30FC38A02
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJ3XmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3XmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:42:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF84C9FED
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CDD060F95
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7297C433D6;
        Sun, 30 Oct 2022 23:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173339;
        bh=pckgYuHi1y/GAEsZ2xBg6ZGAhNyW+aF1WcEMHx1FKJI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q4Th0v6QQhZj8hc8KNFZepDbdmibjRLnzux8AgdwJD2okwL5mLDGelgSNW9tpaofS
         nD86IomhJYBTpYyE5hKHrLfR27WnB5JaF9id51oeHvy7tGB2x3FLQiYLWns5QIgPfV
         5jDBzKWN96atzRmHszj8EmTDpVW8owe1gdYz+bXbor47Fx55EYutqKdSH2cJOM1D8e
         FV+/wfFzVPeYf96+yXyy6zgRkHPnZQnkZPty4Rtf6YrMUvArbfx81tmvn0K00O7BO1
         LTo3IOa/20+eTQMTJA9TvMRVLNj1YE36fesxHipJPIKydU4M/0beREVbXKtWMvc9PK
         638o2TcIBEdVA==
Subject: [PATCH 10/13] xfs: check record domain when accessing refcount
 records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:42:18 -0700
Message-ID: <166717333855.417886.7908015754662882074.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   53 ++++++++++++++++++++++++++++++++----------
 fs/xfs/scrub/refcount.c      |    4 ++-
 2 files changed, 43 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ba2ddf177a49..27ed4c10d0d0 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -381,6 +381,8 @@ xfs_refcount_split_extent(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+	if (rcext.rc_domain != domain)
+		return 0;
 	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
 		return 0;
 
@@ -432,6 +434,9 @@ xfs_refcount_merge_center_extents(
 	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, center, right);
 
+	ASSERT(left->rc_domain == center->rc_domain);
+	ASSERT(right->rc_domain == center->rc_domain);
+
 	/*
 	 * Make sure the center and right extents are not in the btree.
 	 * If the center extent was synthesized, the first delete call
@@ -508,6 +513,8 @@ xfs_refcount_merge_left_extent(
 	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, left, cleft);
 
+	ASSERT(left->rc_domain == cleft->rc_domain);
+
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
 		error = xfs_refcount_lookup_le(cur, cleft->rc_domain,
@@ -569,6 +576,8 @@ xfs_refcount_merge_right_extent(
 	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, cright, right);
 
+	ASSERT(right->rc_domain == cright->rc_domain);
+
 	/*
 	 * If the extent ending at agbno+aglen (cright) wasn't synthesized,
 	 * remove it.
@@ -649,12 +658,10 @@ xfs_refcount_find_left_extents(
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
 
@@ -670,6 +677,9 @@ xfs_refcount_find_left_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp starts at the end of our range, just use that */
 		if (tmp.rc_startblock == agbno)
 			*cleft = tmp;
@@ -689,6 +699,7 @@ xfs_refcount_find_left_extents(
 			cleft->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -740,12 +751,10 @@ xfs_refcount_find_right_extents(
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
 
@@ -761,6 +770,9 @@ xfs_refcount_find_right_extents(
 			goto out_error;
 		}
 
+		if (tmp.rc_domain != domain)
+			goto not_found;
+
 		/* if tmp ends at the end of our range, just use that */
 		if (xfs_refc_next(&tmp) == agbno + aglen)
 			*cright = tmp;
@@ -780,6 +792,7 @@ xfs_refcount_find_right_extents(
 			cright->rc_domain = domain;
 		}
 	} else {
+not_found:
 		/*
 		 * No extents, so pretend that there's one covering the whole
 		 * range.
@@ -889,7 +902,7 @@ xfs_refcount_merge_extents(
 				aglen);
 	}
 
-	return error;
+	return 0;
 }
 
 /*
@@ -961,7 +974,7 @@ xfs_refcount_adjust_extents(
 		error = xfs_refcount_get_rec(cur, &ext, &found_rec);
 		if (error)
 			goto out_error;
-		if (!found_rec) {
+		if (!found_rec || ext.rc_domain != XFS_REFC_DOMAIN_SHARED) {
 			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
 			ext.rc_blockcount = 0;
 			ext.rc_refcount = 0;
@@ -1400,6 +1413,8 @@ xfs_refcount_find_shared(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
+	if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED)
+		goto done;
 
 	/* If the extent ends before the start, look at the next one */
 	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
@@ -1415,6 +1430,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
+		if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED)
+			goto done;
 	}
 
 	/* If the extent starts after the range we want, bail out */
@@ -1446,7 +1463,8 @@ xfs_refcount_find_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		if (tmp.rc_startblock >= agbno + aglen ||
+		if (tmp.rc_domain != XFS_REFC_DOMAIN_SHARED ||
+		    tmp.rc_startblock >= agbno + aglen ||
 		    tmp.rc_startblock != *fbno + *flen)
 			break;
 		*flen = min(*flen + tmp.rc_blockcount, agbno + aglen - *fbno);
@@ -1537,6 +1555,11 @@ xfs_refcount_adjust_cow_extents(
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
@@ -1746,8 +1769,14 @@ xfs_refcount_recover_extent(
 
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
index fe5ffe4f478d..a26ee0f24ef2 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -439,8 +439,8 @@ xchk_xref_is_cow_staging(
 		return;
 	}
 
-	/* CoW flag must be set, refcount must be 1. */
-	if (rc.rc_domain != XFS_REFC_DOMAIN_COW || rc.rc_refcount != 1)
+	/* CoW lookup returned a shared extent record? */
+	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
 	/* Must be at least as long as what was passed in */

