Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDD9ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJ3XmS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3XmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:42:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222D59FEA
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB282B810A3
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53850C433C1;
        Sun, 30 Oct 2022 23:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173333;
        bh=dqFA4JN9nNdOL3BnTObFozk93VjzIBh9CgaBFhPdPyA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=grAPDpzOUy+r0h230dfctf9N28GS+l/ziVodUyNyK6gqaAbCBLV8k+faTT/l1W8Y0
         bVwOYfHm+o5U6bpOCjPSXBXZBp9+ur9iZLuJMAPfLv2q4QHkyYBlMGytdJLewCaAip
         lDfarJmCPJYmm/iP1qC5nfc2uUZnIcqAFufsumAK3EXMjbeN9yb1vCujL3EyQEaiVz
         amu3P6O2L2zMgCH9MITNOxN0reHrEsg62AP1A0fkr3y22tpXHdaTspTxL5hYJIyRNy
         d8oKh7/JRRHtMiw+quK4sAUXQ25Mglb1pGTT1r18+hzqUbTx1RwP7aqUOQBs6UukgX
         N2MHdmUIPhvUA==
Subject: [PATCH 09/13] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:42:12 -0700
Message-ID: <166717333285.417886.4285666653639506394.stgit@magnolia>
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

Now that we have an explicit enum for shared and CoW staging extents, we
can get rid of the old FIND_RCEXT flags.  Omit a couple of conversions
that disappear in the next patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   48 +++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 8eaa11470f46..ba2ddf177a49 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -617,8 +617,6 @@ xfs_refcount_merge_right_extent(
 	return error;
 }
 
-#define XFS_FIND_RCEXT_SHARED	1
-#define XFS_FIND_RCEXT_COW	2
 /*
  * Find the left extent and the one after it (cleft).  This function assumes
  * that we've already split any extent crossing agbno.
@@ -628,20 +626,14 @@ xfs_refcount_find_left_extents(
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
@@ -659,9 +651,9 @@ xfs_refcount_find_left_extents(
 
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
@@ -725,20 +717,14 @@ xfs_refcount_find_right_extents(
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
@@ -756,9 +742,9 @@ xfs_refcount_find_right_extents(
 
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
@@ -827,10 +813,10 @@ xfs_refc_valid(
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
@@ -845,12 +831,12 @@ xfs_refcount_merge_extents(
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
 
@@ -1139,8 +1125,8 @@ xfs_refcount_adjust(
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
@@ -1650,8 +1636,8 @@ xfs_refcount_adjust_cow(
 	/*
 	 * Try to merge with the left or right extents of the range.
 	 */
-	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
-			XFS_FIND_RCEXT_COW, &shape_changed);
+	error = xfs_refcount_merge_extents(cur, XFS_REFC_DOMAIN_COW, &agbno,
+			&aglen, adj, &shape_changed);
 	if (error)
 		goto out_error;
 

