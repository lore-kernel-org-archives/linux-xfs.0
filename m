Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCB8C001DF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjHDRMk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjHDRMj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:12:39 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760033C25
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:12:38 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HCRwT019433
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169149; bh=+f/LX58IuAVurznaqJY19ZmHsfMLTE/0Aex02nzk49Q=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=qNwxU+M7hLNJfc1l92jgI83b5X32keVENDWIsEGGrKqPdrwn4mu6Jp0SGpJ3A/cQs
         Lz6vSE5K56AvRsMFnxDWdCq7l22qrhdryCsPF6C22dVi/KUAFKgf6P7OCzKgUZ6czD
         FHFiUN4tXk3g5Q1Sm0SRaCB75RMMlHo0OQXLvhq+aQrmQIvR0SVNhH8cCk/HfJ2GCw
         ZZDjCzT3ZE2cDMfsoQLPaLmkIiCbKc7VTH1a80DgPzgTcMl0LF/nivNJNSPaccwgfj
         cV4xBUdGU77+yPREJ3kEwX6nI9GTbg7RYv1/c/r6MvTl+lGHkp8tl8CyFasuwPySFp
         Bxc/4oFfLZeKA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id F056F15C04F1; Fri,  4 Aug 2023 13:12:26 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Dave Chinner <dchinner@redhat.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
Subject: [PATCH CANDIDATE v6.1 1/5] xfs: hoist refcount record merge predicates
Date:   Fri,  4 Aug 2023 13:12:19 -0400
Message-Id: <20230804171223.1393045-1-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
 fs/xfs/libxfs/xfs_refcount.c | 129 ++++++++++++++++++++++++++++++-----
 1 file changed, 113 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 3f34bafe18dd..4408893333a6 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -815,11 +815,119 @@ xfs_refcount_find_right_extents(
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
@@ -861,23 +969,15 @@ xfs_refcount_merge_extents(
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
@@ -893,10 +993,7 @@ xfs_refcount_merge_extents(
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
2.31.0

