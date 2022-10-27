Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D32ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbiJ0ROy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiJ0ROw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439B314D02
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 015F5B82722
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F51DC4347C;
        Thu, 27 Oct 2022 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890888;
        bh=Qx9LL7nv7G4OfFq7cLbzQFtS2SjB3HcK4bJm2eW5eVA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Eb0UgeRjbqPjaQUdwJhinEnVLLi0e5BRE2VWMflL/ghPzZ3CJ+lDlgMbqoc01iVG2
         /rkQG+lVzLv458aI9bGkfx64B6hLZqOMfoT0pgC3xZDMI+DCqvoBIe/A5/VeoUdPox
         B6sl5WEmWypKPG5LJWFOvPx2iLS98OWf83zbu7kzTP0UqOQZGI1IIrt6hMUjtaWU11
         IoQ1wDiQMl72qTvSNzSAsiu9oTyLFAlZBhZNSHxcFmsAEfebjxuqmF3jUG+gf3quqE
         q9Q+x3QuNyoV3CgQJPouUlxQ3XbMGjTQ6B/0SGjNhGeCW+8haCO9FppDXtRxPBf0mo
         lKMXWW9qskr7Q==
Subject: [PATCH 08/12] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:48 -0700
Message-ID: <166689088821.3788582.17326076878286020666.stgit@magnolia>
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

Now that we have an explicit enum for shared and CoW staging extents, we
can get rid of the old FIND_RCEXT flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   48 +++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 586c58b5a557..3b1cb0578770 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -622,8 +622,6 @@ xfs_refcount_merge_right_extent(
 	return error;
 }
 
-#define XFS_FIND_RCEXT_SHARED	1
-#define XFS_FIND_RCEXT_COW	2
 /*
  * Find the left extent and the one after it (cleft).  This function assumes
  * that we've already split any extent crossing agbno.
@@ -633,20 +631,14 @@ xfs_refcount_find_left_extents(
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
@@ -664,9 +656,9 @@ xfs_refcount_find_left_extents(
 
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
@@ -730,20 +722,14 @@ xfs_refcount_find_right_extents(
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
@@ -761,9 +747,9 @@ xfs_refcount_find_right_extents(
 
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
@@ -832,10 +818,10 @@ xfs_refc_valid(
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
@@ -850,12 +836,12 @@ xfs_refcount_merge_extents(
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
 
@@ -1144,8 +1130,8 @@ xfs_refcount_adjust(
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
@@ -1665,8 +1651,8 @@ xfs_refcount_adjust_cow(
 	/*
 	 * Try to merge with the left or right extents of the range.
 	 */
-	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
-			XFS_FIND_RCEXT_COW, &shape_changed);
+	error = xfs_refcount_merge_extents(cur, XFS_REFC_DOMAIN_COW, &agbno,
+			&aglen, adj, &shape_changed);
 	if (error)
 		goto out_error;
 

