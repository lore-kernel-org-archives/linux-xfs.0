Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2F9C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKICH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKICH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADBF682BD
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA157B81CF2
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D87C433D7;
        Wed,  9 Nov 2022 02:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959643;
        bh=AmPjuulyoQn8D295TRVgE6OlKVtBC6LTvaJxMpkhW8c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n7hl2BxQRHZTBWlb/Ye5JLFwkvNqa8bjn0RH1P8C8OauPWOZLg379Vmp2rxvBEqZl
         nT54onPELNiu7ndKI3lT0JPoT4h+KDgB+Q0ripG/7dXqp5l9fhfFzA984UEHCrPnop
         XH8QFdFffXHdMlypOZtMVHMYflhLg7hFOd9NEcHhmBi9lB1RoKvN63qBrQj1pnxJaA
         3QVi3HLB9Hj3t/1Z43ZJYA1zDg+5q+KUJdOlYKTsNPVHd7tmcr1CrLY/oONcQjITFD
         tTazFdQHrJwK9c31HGIKI4l9UV3jQQoQRFsDEe5ivqOr711VRQx6h4GuM4nkSPHb1K
         eEHapO57y1e5A==
Subject: [PATCH 18/24] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:23 -0800
Message-ID: <166795964302.3761583.6759285188672122147.stgit@magnolia>
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

Source kernel commit: 912fb9d3e44628aca3f3b29793ed5942c194ed44

Now that we have an explicit enum for shared and CoW staging extents, we
can get rid of the old FIND_RCEXT flags.  Omit a couple of conversions
that disappear in the next patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_refcount.c |   48 +++++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index f0fc96da6a..192014d00c 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -616,8 +616,6 @@ xfs_refcount_merge_right_extent(
 	return error;
 }
 
-#define XFS_FIND_RCEXT_SHARED	1
-#define XFS_FIND_RCEXT_COW	2
 /*
  * Find the left extent and the one after it (cleft).  This function assumes
  * that we've already split any extent crossing agbno.
@@ -627,20 +625,14 @@ xfs_refcount_find_left_extents(
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*left,
 	struct xfs_refcount_irec	*cleft,
+	enum xfs_refc_domain		domain,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen,
-	int				flags)
+	xfs_extlen_t			aglen)
 {
 	struct xfs_refcount_irec	tmp;
-	enum xfs_refc_domain		domain;
 	int				error;
 	int				found_rec;
 
-	if (flags & XFS_FIND_RCEXT_SHARED)
-		domain = XFS_REFC_DOMAIN_SHARED;
-	else
-		domain = XFS_REFC_DOMAIN_COW;
-
 	left->rc_startblock = cleft->rc_startblock = NULLAGBLOCK;
 	error = xfs_refcount_lookup_le(cur, domain, agbno - 1, &found_rec);
 	if (error)
@@ -658,9 +650,9 @@ xfs_refcount_find_left_extents(
 
 	if (xfs_refc_next(&tmp) != agbno)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+	if (domain == XFS_REFC_DOMAIN_SHARED && tmp.rc_refcount < 2)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+	if (domain == XFS_REFC_DOMAIN_COW && tmp.rc_refcount > 1)
 		return 0;
 	/* We have a left extent; retrieve (or invent) the next right one */
 	*left = tmp;
@@ -724,20 +716,14 @@ xfs_refcount_find_right_extents(
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*right,
 	struct xfs_refcount_irec	*cright,
+	enum xfs_refc_domain		domain,
 	xfs_agblock_t			agbno,
-	xfs_extlen_t			aglen,
-	int				flags)
+	xfs_extlen_t			aglen)
 {
 	struct xfs_refcount_irec	tmp;
-	enum xfs_refc_domain		domain;
 	int				error;
 	int				found_rec;
 
-	if (flags & XFS_FIND_RCEXT_SHARED)
-		domain = XFS_REFC_DOMAIN_SHARED;
-	else
-		domain = XFS_REFC_DOMAIN_COW;
-
 	right->rc_startblock = cright->rc_startblock = NULLAGBLOCK;
 	error = xfs_refcount_lookup_ge(cur, domain, agbno + aglen, &found_rec);
 	if (error)
@@ -755,9 +741,9 @@ xfs_refcount_find_right_extents(
 
 	if (tmp.rc_startblock != agbno + aglen)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
+	if (domain == XFS_REFC_DOMAIN_SHARED && tmp.rc_refcount < 2)
 		return 0;
-	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
+	if (domain == XFS_REFC_DOMAIN_COW && tmp.rc_refcount > 1)
 		return 0;
 	/* We have a right extent; retrieve (or invent) the next left one */
 	*right = tmp;
@@ -826,10 +812,10 @@ xfs_refc_valid(
 STATIC int
 xfs_refcount_merge_extents(
 	struct xfs_btree_cur	*cur,
+	enum xfs_refc_domain	domain,
 	xfs_agblock_t		*agbno,
 	xfs_extlen_t		*aglen,
 	enum xfs_refc_adjust_op adjust,
-	int			flags,
 	bool			*shape_changed)
 {
 	struct xfs_refcount_irec	left = {0}, cleft = {0};
@@ -844,12 +830,12 @@ xfs_refcount_merge_extents(
 	 * just below (agbno + aglen) [cright], and just above (agbno + aglen)
 	 * [right].
 	 */
-	error = xfs_refcount_find_left_extents(cur, &left, &cleft, *agbno,
-			*aglen, flags);
+	error = xfs_refcount_find_left_extents(cur, &left, &cleft, domain,
+			*agbno, *aglen);
 	if (error)
 		return error;
-	error = xfs_refcount_find_right_extents(cur, &right, &cright, *agbno,
-			*aglen, flags);
+	error = xfs_refcount_find_right_extents(cur, &right, &cright, domain,
+			*agbno, *aglen);
 	if (error)
 		return error;
 
@@ -1138,8 +1124,8 @@ xfs_refcount_adjust(
 	/*
 	 * Try to merge with the left or right extents of the range.
 	 */
-	error = xfs_refcount_merge_extents(cur, new_agbno, new_aglen, adj,
-			XFS_FIND_RCEXT_SHARED, &shape_changed);
+	error = xfs_refcount_merge_extents(cur, XFS_REFC_DOMAIN_SHARED,
+			new_agbno, new_aglen, adj, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1649,8 +1635,8 @@ xfs_refcount_adjust_cow(
 	/*
 	 * Try to merge with the left or right extents of the range.
 	 */
-	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
-			XFS_FIND_RCEXT_COW, &shape_changed);
+	error = xfs_refcount_merge_extents(cur, XFS_REFC_DOMAIN_COW, &agbno,
+			&aglen, adj, &shape_changed);
 	if (error)
 		goto out_error;
 

