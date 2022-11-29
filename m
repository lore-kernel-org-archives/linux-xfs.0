Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC59C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 22:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiK2WBk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiK2WBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 17:01:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330A070DCC
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C45A561953
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 22:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335D5C433D6;
        Tue, 29 Nov 2022 22:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669759297;
        bh=FCJYrY0xoCcOXdEy1CI2bECukDRB7seYcQQr0oWQKE4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j8pyyeDQrc+OwUScGOhb4/vFvtcvS5HsXdk3IsEsaAaGzJfyJrQcq9yVjeZWQWbN+
         AvUABQrJgGTZJkZHjg32vo1s/fZwInjukd9quCyhUK/7jDZeC04iRJuK+GPKxfRAHx
         Y6QfY202An8u0bj9hVS3h4r0ptEZkcu9JSrx/s1XKVuOU4gwj9mfxo2R5ElCbHp3lQ
         yA7vfMNj44fajQVWYdS1wpPmGuZnwI9KnEgCxGfw1WZQUZ1MYERvJf+EMfCOj4yHEI
         7qdLG+3Rs7Tqo3XhQaaLmAfpohwZqq32gMDW53/F3/hPaLkZWfHqvzaKk8BiS1phik
         Fwf/ghJyxSPjQ==
Subject: [PATCH 2/2] xfs: estimate post-merge refcounts correctly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 29 Nov 2022 14:01:36 -0800
Message-ID: <166975929675.3768925.10238207487640742011.stgit@magnolia>
In-Reply-To: <166975928548.3768925.15141817742859398250.stgit@magnolia>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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
---
 fs/xfs/libxfs/xfs_refcount.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 8c68994d09f3..0d68a9230386 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -820,6 +820,17 @@ xfs_refc_valid(
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
@@ -831,6 +842,7 @@ xfs_refc_want_merge_center(
 	unsigned long long		*ulenp)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * To merge with a center record, both shoulder records must be
@@ -846,9 +858,10 @@ xfs_refc_want_merge_center(
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
@@ -870,6 +883,7 @@ xfs_refc_want_merge_left(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = left->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a left merge, the left shoulder record must be adjacent to the
@@ -880,7 +894,8 @@ xfs_refc_want_merge_left(
 		return false;
 
 	/* Left shoulder record refcount must match the new refcount. */
-	if (left->rc_refcount != cleft->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cleft, adjust);
+	if (left->rc_refcount != new_refcount)
 		return false;
 
 	/*
@@ -901,6 +916,7 @@ xfs_refc_want_merge_right(
 	enum xfs_refc_adjust_op		adjust)
 {
 	unsigned long long		ulen = right->rc_blockcount;
+	xfs_nlink_t			new_refcount;
 
 	/*
 	 * For a right merge, the right shoulder record must be adjacent to the
@@ -911,7 +927,8 @@ xfs_refc_want_merge_right(
 		return false;
 
 	/* Right shoulder record refcount must match the new refcount. */
-	if (right->rc_refcount != cright->rc_refcount + adjust)
+	new_refcount = xfs_refc_merge_refcount(cright, adjust);
+	if (right->rc_refcount != new_refcount)
 		return false;
 
 	/*

