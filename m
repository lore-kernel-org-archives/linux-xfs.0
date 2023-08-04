Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C54C41513
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjHDRLS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjHDRLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:11:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3221949C1
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:10:49 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HAULJ018436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169032; bh=jxBnhPXcLYD4J0TVYjeN7tPYclKJvxcCMWA3Ednkrbc=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=fBGgAM/X3jtpMfzfk1DKsJRyLHFyyE8fKTYzSE6rDTfoEC6Q9veaGSjSdVWs9rDAO
         7RtOYKH9n3a04SarqG2CmKiecUo65CbNeHu3zwc7b14RmSOEIYC5PIpB32GdxqMjBG
         Jr9KtOEqrNmhiz2ZwRSelXTPePdVzFTKp8H7kLg2tREFX1ZMsziAXGeHyrFdzjL4nZ
         303bnXShkBdPR26acXFgdhtz5atqM4nzYYcoyejdIQ5XTocI1Iz6TMY1RU6kqsBhOi
         SY1g95ElHGdM6y55+6PacjJdhNW5N102ZlK5P4XOaDkD04DGrIA0EKK8BZy5K13T3/
         nShKLVPUBlKTw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 03A6B15C04F2; Fri,  4 Aug 2023 13:10:30 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com, Dave Chinner <dchinner@redhat.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
Subject: [PATCH CANDIDATE v5.15 2/9] xfs: estimate post-merge refcounts correctly
Date:   Fri,  4 Aug 2023 13:10:12 -0400
Message-Id: <20230804171019.1392900-2-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171019.1392900-1-tytso@mit.edu>
References: <20230802205747.GE358316@mit.edu>
 <20230804171019.1392900-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
 fs/xfs/libxfs/xfs_refcount.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index fee4010b88bc..e2dbd30b416a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -787,6 +787,17 @@ xfs_refc_valid(
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
@@ -798,6 +809,7 @@ xfs_refc_want_merge_center(
 	unsigned long long		*ulenp)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * To merge with a center record, both shoulder records must be
@@ -813,9 +825,10 @@ xfs_refc_want_merge_center(
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
@@ -838,6 +851,7 @@ xfs_refc_want_merge_left(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a left merge, the left shoulder record must be adjacent to the
@@ -848,7 +862,8 @@ xfs_refc_want_merge_left(
 		return false;
 
 	/* Left shoulder record refcount must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -870,6 +885,7 @@ xfs_refc_want_merge_right(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = right->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a right merge, the right shoulder record must be adjacent to the
@@ -880,7 +896,8 @@ xfs_refc_want_merge_right(
 		return false;
 
 	/* Right shoulder record refcount must match the new refcount. */
-	if (right->rc_refcount != cright->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cright, adjust);
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*
-- 
2.31.0

