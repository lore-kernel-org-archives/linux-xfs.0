Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1FDC0015E
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 09:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjHCJos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 05:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbjHCJoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 05:44:24 -0400
X-Greylist: delayed 428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Aug 2023 02:44:17 PDT
Received: from out-95.mta1.migadu.com (out-95.mta1.migadu.com [95.215.58.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74C13AB1
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 02:44:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691055429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2iC4kHZtl2KxpN6LCutpvqkvurFcswDzNr+remBB/Fc=;
        b=j2Rt256z6BBL/6D11QtxEab84syJ4Mo1JUUw2F7pHZ5g/YxGw63lNiK1lv3RoVtK84Nswy
        m2FZaYBqvdQdwTV/vEuch26IkdibObJkxOhhQqIMMmTyXS0A2+CdPPAszp/BrrjWJM14Tk
        YviWHAAnpT3CgP39foBtNmZGrsHovUU=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     amir73il@gmail.com, djwong@kernel.org, dchinner@redhat.com,
        yangx.jy@fujitsu.com
Cc:     linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 2/2] xfs: estimate post-merge refcounts correctly
Date:   Thu,  3 Aug 2023 17:36:52 +0800
Message-Id: <20230803093652.7119-3-guoqing.jiang@linux.dev>
In-Reply-To: <20230803093652.7119-1-guoqing.jiang@linux.dev>
References: <20230803093652.7119-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit b25d1984aa884fc91a73a5a407b9ac976d441e9b upstream.

Upon enabling fsdax + reflink for XFS, xfs/179 began to report refcount
metadata corruptions after being run.  Specifically, xfs_repair noticed
single-block refcount records that could be combined but had not been.

The root cause of this is improper MAXREFCOUNT edge case handling in
xfs_refcount_merge_extents.  When we're trying to find candidates for a
refcount btree record merge, we compute the refcount attribute of the
merged record, but we fail to account for the fact that once a record
hits rc_refcount == MAXREFCOUNT, it is pinned that way forever.  Hence
the computed refcount is wrong, and we fail to merge the extents.

Fix this by adjusting the merge predicates to compute the adjusted
refcount correctly.

Fixes: 3172725814f9 ("xfs: adjust refcount of an extent of blocks in refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 fs/xfs/libxfs/xfs_refcount.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 9806942a13ea..ba6ce17af405 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -786,6 +786,17 @@ xfs_refc_valid(
 	return rc->rc_startblock != NULLAGBLOCK;
 }
 
+static inline xfs_nlink_t
+xfs_refc_merge_refcount(
+	const struct xfs_refcount_irec	*irec,
+	enum xfs_refc_adjust_op		adjust)
+{
+	/* Once a record hits MAXREFCOUNT, it is pinned there forever */
+	if (irec->rc_refcount == MAXREFCOUNT)
+		return MAXREFCOUNT;
+	return irec->rc_refcount + adjust;
+}
+
 static inline bool
 xfs_refc_want_merge_center(
 	const struct xfs_refcount_irec	*left,
@@ -797,6 +808,7 @@ xfs_refc_want_merge_center(
 	unsigned long long		*ulenp)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * To merge with a center record, both shoulder records must be
@@ -812,9 +824,10 @@ xfs_refc_want_merge_center(
 		return false;
 
 	/* The shoulder record refcounts must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
-	if (right->rc_refcount != cleft->rc_refcount + adjust)
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -837,6 +850,7 @@ xfs_refc_want_merge_left(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a left merge, the left shoulder record must be adjacent to the
@@ -847,7 +861,8 @@ xfs_refc_want_merge_left(
 		return false;
 
 	/* Left shoulder record refcount must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -869,6 +884,7 @@ xfs_refc_want_merge_right(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = right->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a right merge, the right shoulder record must be adjacent to the
@@ -879,7 +895,8 @@ xfs_refc_want_merge_right(
 		return false;
 
 	/* Right shoulder record refcount must match the new refcount. */
-	if (right->rc_refcount != cright->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cright, adjust);
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*
-- 
2.33.0

