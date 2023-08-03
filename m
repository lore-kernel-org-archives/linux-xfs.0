Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B39C00528
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 09:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbjHCJor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 05:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjHCJoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 05:44:23 -0400
X-Greylist: delayed 429 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Aug 2023 02:44:17 PDT
Received: from out-90.mta1.migadu.com (out-90.mta1.migadu.com [IPv6:2001:41d0:203:375::5a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8675B30FD
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 02:44:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691055427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5atMtDdprR48uIPmh8rR5i0blTIGJGdOUuWf1374V5I=;
        b=fGQI+yex66ImD5DchW4L2GEz/fxBXliMEekRKdVidAtlsCtBwLP/e2uRcF1VpSU+OoV9nP
        3o2MtOEauSxfgTygImIeiZXDRwj6HZGnWSpL1buXbWY1XU5rNjncUmiOc4aKM/3vTlK/du
        xq44f1YgY4hX5z13d4kQAbT92RvNE7U=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     amir73il@gmail.com, djwong@kernel.org, dchinner@redhat.com,
        yangx.jy@fujitsu.com
Cc:     linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 1/2] xfs: hoist refcount record merge predicates
Date:   Thu,  3 Aug 2023 17:36:51 +0800
Message-Id: <20230803093652.7119-2-guoqing.jiang@linux.dev>
In-Reply-To: <20230803093652.7119-1-guoqing.jiang@linux.dev>
References: <20230803093652.7119-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 9d720a5a658f5135861773f26e927449bef93d61 upstream.

Hoist these multiline conditionals into separate static inline helpers
to improve readability and set the stage for corruption fixes that will
be introduced in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 fs/xfs/libxfs/xfs_refcount.c | 129 ++++++++++++++++++++++++++++++-----
 1 file changed, 113 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2076627243b0..9806942a13ea 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -781,11 +781,119 @@ xfs_refcount_find_right_extents(
 /* Is this extent valid? */
 static inline bool
 xfs_refc_valid(
-	struct xfs_refcount_irec	*rc)
+	const struct xfs_refcount_irec	*rc)
 {
 	return rc->rc_startblock != NULLAGBLOCK;
 }
 
+static inline bool
+xfs_refc_want_merge_center(
+	const struct xfs_refcount_irec	*left,
+	const struct xfs_refcount_irec	*cleft,
+	const struct xfs_refcount_irec	*cright,
+	const struct xfs_refcount_irec	*right,
+	bool				cleft_is_cright,
+	enum xfs_refc_adjust_op		adjust,
+	unsigned long long		*ulenp)
+{
+	unsigned long long		ulen = left->rc_blockcount;
+
+	/*
+	 * To merge with a center record, both shoulder records must be
+	 * adjacent to the record we want to adjust.  This is only true if
+	 * find_left and find_right made all four records valid.
+	 */
+	if (!xfs_refc_valid(left)  || !xfs_refc_valid(right) ||
+	    !xfs_refc_valid(cleft) || !xfs_refc_valid(cright))
+		return false;
+
+	/* There must only be one record for the entire range. */
+	if (!cleft_is_cright)
+		return false;
+
+	/* The shoulder record refcounts must match the new refcount. */
+	if (left->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+	if (right->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cleft->rc_blockcount + right->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	*ulenp = ulen;
+	return true;
+}
+
+static inline bool
+xfs_refc_want_merge_left(
+	const struct xfs_refcount_irec	*left,
+	const struct xfs_refcount_irec	*cleft,
+	enum xfs_refc_adjust_op		adjust)
+{
+	unsigned long long		ulen = left->rc_blockcount;
+
+	/*
+	 * For a left merge, the left shoulder record must be adjacent to the
+	 * start of the range.  If this is true, find_left made left and cleft
+	 * contain valid contents.
+	 */
+	if (!xfs_refc_valid(left) || !xfs_refc_valid(cleft))
+		return false;
+
+	/* Left shoulder record refcount must match the new refcount. */
+	if (left->rc_refcount != cleft->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cleft->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	return true;
+}
+
+static inline bool
+xfs_refc_want_merge_right(
+	const struct xfs_refcount_irec	*cright,
+	const struct xfs_refcount_irec	*right,
+	enum xfs_refc_adjust_op		adjust)
+{
+	unsigned long long		ulen = right->rc_blockcount;
+
+	/*
+	 * For a right merge, the right shoulder record must be adjacent to the
+	 * end of the range.  If this is true, find_right made cright and right
+	 * contain valid contents.
+	 */
+	if (!xfs_refc_valid(right) || !xfs_refc_valid(cright))
+		return false;
+
+	/* Right shoulder record refcount must match the new refcount. */
+	if (right->rc_refcount != cright->rc_refcount + adjust)
+		return false;
+
+	/*
+	 * The new record cannot exceed the max length.  ulen is a ULL as the
+	 * individual record block counts can be up to (u32 - 1) in length
+	 * hence we need to catch u32 addition overflows here.
+	 */
+	ulen += cright->rc_blockcount;
+	if (ulen >= MAXREFCEXTLEN)
+		return false;
+
+	return true;
+}
+
 /*
  * Try to merge with any extents on the boundaries of the adjustment range.
  */
@@ -827,23 +935,15 @@ xfs_refcount_merge_extents(
 		 (cleft.rc_blockcount == cright.rc_blockcount);
 
 	/* Try to merge left, cleft, and right.  cleft must == cright. */
-	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
-			right.rc_blockcount;
-	if (xfs_refc_valid(&left) && xfs_refc_valid(&right) &&
-	    xfs_refc_valid(&cleft) && xfs_refc_valid(&cright) && cequal &&
-	    left.rc_refcount == cleft.rc_refcount + adjust &&
-	    right.rc_refcount == cleft.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_center(&left, &cleft, &cright, &right, cequal,
+				adjust, &ulen)) {
 		*shape_changed = true;
 		return xfs_refcount_merge_center_extents(cur, &left, &cleft,
 				&right, ulen, aglen);
 	}
 
 	/* Try to merge left and cleft. */
-	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
-	if (xfs_refc_valid(&left) && xfs_refc_valid(&cleft) &&
-	    left.rc_refcount == cleft.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_left(&left, &cleft, adjust)) {
 		*shape_changed = true;
 		error = xfs_refcount_merge_left_extent(cur, &left, &cleft,
 				agbno, aglen);
@@ -859,10 +959,7 @@ xfs_refcount_merge_extents(
 	}
 
 	/* Try to merge cright and right. */
-	ulen = (unsigned long long)right.rc_blockcount + cright.rc_blockcount;
-	if (xfs_refc_valid(&right) && xfs_refc_valid(&cright) &&
-	    right.rc_refcount == cright.rc_refcount + adjust &&
-	    ulen < MAXREFCEXTLEN) {
+	if (xfs_refc_want_merge_right(&cright, &right, adjust)) {
 		*shape_changed = true;
 		return xfs_refcount_merge_right_extent(cur, &right, &cright,
 				aglen);
-- 
2.33.0

