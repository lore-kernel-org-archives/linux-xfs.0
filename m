Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2942ECCA481
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiF0Anp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiF0Ano (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:43:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFDC22DE4
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:43:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B61245ECD02
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:43:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-00BTzw-Hc
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:43:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cqo-000uaV-G2
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:43:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: clean up xfs_iunlink_update_inode()
Date:   Mon, 27 Jun 2022 10:43:33 +1000
Message-Id: <20220627004336.217366-7-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627004336.217366-1-david@fromorbit.com>
References: <20220627004336.217366-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b8fd3c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=PAVX-bgUedU8PVVPF6AA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We no longer need to have this function return the previous next
agino value from the on-disk inode as we have it in the in-core
inode now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f390a91243bf..8d4edb8129b5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1953,13 +1953,12 @@ xfs_iunlink_update_dinode(
 }
 
 /* Set an in-core inode's unlinked pointer and return the old value. */
-STATIC int
+static int
 xfs_iunlink_update_inode(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	xfs_agino_t		next_agino,
-	xfs_agino_t		*old_next_agino)
+	xfs_agino_t		next_agino)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_dinode	*dip;
@@ -1989,8 +1988,6 @@ xfs_iunlink_update_inode(
 	 * current pointer is the same as the new value, unless we're
 	 * terminating the list.
 	 */
-	if (old_next_agino)
-		*old_next_agino = old_value;
 	if (old_value == next_agino) {
 		if (next_agino != NULLAGINO) {
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
@@ -2044,17 +2041,13 @@ xfs_iunlink_insert_inode(
 		return error;
 
 	if (next_agino != NULLAGINO) {
-		xfs_agino_t		old_agino;
-
 		/*
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
 		 */
-		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino,
-				&old_agino);
+		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino);
 		if (error)
 			return error;
-		ASSERT(old_agino == NULLAGINO);
 		ip->i_next_unlinked = next_agino;
 	}
 
@@ -2106,7 +2099,6 @@ xfs_iunlink_remove_inode(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	xfs_agino_t		next_agino;
 	xfs_agino_t		head_agino;
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
@@ -2127,7 +2119,7 @@ xfs_iunlink_remove_inode(
 	 * the old pointer value so that we can update whatever was previous
 	 * to us in the list to point to whatever was next in the list.
 	 */
-	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO, &next_agino);
+	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO);
 	if (error)
 		return error;
 
@@ -2148,7 +2140,7 @@ xfs_iunlink_remove_inode(
 			return -EFSCORRUPTED;
 
 		error = xfs_iunlink_update_inode(tp, prev_ip, pag,
-				ip->i_next_unlinked, NULL);
+				ip->i_next_unlinked);
 		prev_ip->i_next_unlinked = ip->i_next_unlinked;
 	} else {
 		/* Point the head of the list to the next unlinked inode. */
-- 
2.36.1

