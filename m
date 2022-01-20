Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30BCC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiATA1Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357781AbiATA1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40780C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:27:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF768B81A7C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9538AC004E1;
        Thu, 20 Jan 2022 00:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638440;
        bh=CvGyY4kYHQ2QgG/aQ1XqG749GiCdgekr2C81md+pAXY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XiFT6rpi/lAOV1hxNkfPyd9nCr5L0vXVTAc4d3LH9gZ2wwtHcNjF+6ZiU7jN3MjWm
         RGYscBw+amoImS3lCAP0gYF6cs0G+AsLRGkbDEgGNaNuS0/VezD/V2TW6grKj6LtnB
         YigywOw/lnBUzSLd9MF2Hqnum3ZWzzIBtnhgqp1eINQWkJlEvT+x5fl+0sZEIN2BsA
         RFcC3h2qipGCO6j+Zu4EBj57iqjs+9d+h9HnOqlvzqevTEePXQLDbQxjN6K25Iqxbp
         23VQO9i2x2apyVZhpRVLJ6EMEsPmqXSA72JnLTe+S6HfSlaqzqHU0diaeJ8Vbqx734
         gcGOIV+PzRUTw==
Subject: [PATCH 45/48] xfs: remove unused parameter from refcount code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:20 -0800
Message-ID: <164263844028.865554.10944114276804321111.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c04c51c524697cd68d668d595f8ebc381ffe426b

The owner info parameter is always NULL, so get rid of the parameter.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 6bc43f44..076752ce 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -917,8 +917,7 @@ xfs_refcount_adjust_extents(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		*agbno,
 	xfs_extlen_t		*aglen,
-	enum xfs_refc_adjust_op	adj,
-	struct xfs_owner_info	*oinfo)
+	enum xfs_refc_adjust_op	adj)
 {
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
@@ -976,7 +975,7 @@ xfs_refcount_adjust_extents(
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
 				xfs_free_extent_later(cur->bc_tp, fsbno,
-						  tmp.rc_blockcount, oinfo);
+						  tmp.rc_blockcount, NULL);
 			}
 
 			(*agbno) += tmp.rc_blockcount;
@@ -1020,8 +1019,8 @@ xfs_refcount_adjust_extents(
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
-			xfs_free_extent_later(cur->bc_tp, fsbno, ext.rc_blockcount,
-					  oinfo);
+			xfs_free_extent_later(cur->bc_tp, fsbno,
+					ext.rc_blockcount, NULL);
 		}
 
 skip:
@@ -1049,8 +1048,7 @@ xfs_refcount_adjust(
 	xfs_extlen_t		aglen,
 	xfs_agblock_t		*new_agbno,
 	xfs_extlen_t		*new_aglen,
-	enum xfs_refc_adjust_op	adj,
-	struct xfs_owner_info	*oinfo)
+	enum xfs_refc_adjust_op	adj)
 {
 	bool			shape_changed;
 	int			shape_changes = 0;
@@ -1093,8 +1091,7 @@ xfs_refcount_adjust(
 		cur->bc_ag.refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
-	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
-			adj, oinfo);
+	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen, adj);
 	if (error)
 		goto out_error;
 
@@ -1189,12 +1186,12 @@ xfs_refcount_finish_one(
 	switch (type) {
 	case XFS_REFCOUNT_INCREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
-			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
+				new_len, XFS_REFCOUNT_ADJUST_INCREASE);
 		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_DECREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
-			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
+				new_len, XFS_REFCOUNT_ADJUST_DECREASE);
 		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:

