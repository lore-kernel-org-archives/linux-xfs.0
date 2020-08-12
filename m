Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44697C433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C55F206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgHLJ0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:03 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44225 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727854AbgHLJ0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:02 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DE17E1AA1EB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003Qc-A7
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-00Alt5-03
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/13] xfs: mapping unlinked inodes is now redundant
Date:   Wed, 12 Aug 2020 19:25:50 +1000
Message-Id: <20200812092556.2567285-8-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=v-_P0oXuMfu8EUwjdI0A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We now have a direct pointer to the xfs_inodes in the unlinked
lists, so we can use the imap built into the inode to read the
underlying cluster buffer. Hence we can remove all the "lookup by
agino" code that currently exists in the iunlink list processing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 88 ++++++----------------------------------------
 1 file changed, 10 insertions(+), 78 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2c930de99561..bacd5ae9f5a7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2139,74 +2139,6 @@ xfs_iunlink(
 	return error;
 }
 
-/* Return the imap, dinode pointer, and buffer for an inode. */
-STATIC int
-xfs_iunlink_map_ino(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		agino,
-	struct xfs_imap		*imap,
-	struct xfs_dinode	**dipp,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	int			error;
-
-	imap->im_blkno = 0;
-	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
-	if (error) {
-		xfs_warn(mp, "%s: xfs_imap returned error %d.",
-				__func__, error);
-		return error;
-	}
-
-	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0);
-	if (error) {
-		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
-				__func__, error);
-		return error;
-	}
-
-	return 0;
-}
-
-/*
- * Walk the unlinked chain from @head_agino until we find the inode that
- * points to @target_agino.  Return the inode number, map, dinode pointer,
- * and inode cluster buffer of that inode as @agino, @imap, @dipp, and @bpp.
- *
- * @tp, @pag, @head_agino, and @target_agino are input parameters.
- * @agino, @imap, @dipp, and @bpp are all output parameters.
- *
- * Do not call this function if @target_agino is the head of the list.
- */
-STATIC int
-xfs_iunlink_map_prev(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		head_agino,
-	xfs_agino_t		target_agino,
-	xfs_agino_t		agino,
-	struct xfs_imap		*imap,
-	struct xfs_dinode	**dipp,
-	struct xfs_buf		**bpp,
-	struct xfs_perag	*pag)
-{
-	int			error;
-
-	ASSERT(head_agino != target_agino);
-	*bpp = NULL;
-
-	ASSERT(agino != NULLAGINO);
-	error = xfs_iunlink_map_ino(tp, agno, agino, imap, dipp, bpp);
-	if (error)
-		return error;
-
-	if (be32_to_cpu((*dipp)->di_next_unlinked) != target_agino)
-		return -EFSCORRUPTED;
-	return 0;
-}
-
 static int
 xfs_iunlink_remove_inode(
 	struct xfs_trans	*tp,
@@ -2215,8 +2147,6 @@ xfs_iunlink_remove_inode(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi;
-	struct xfs_buf		*last_ibp;
-	struct xfs_dinode	*last_dip = NULL;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
@@ -2260,25 +2190,27 @@ xfs_iunlink_remove_inode(
 	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
 					struct xfs_inode, i_unlink)) {
 
-		struct xfs_inode *pip;
-		struct xfs_imap	imap;
-		xfs_agino_t	prev_agino;
+		struct xfs_inode	*pip;
+		xfs_agino_t		prev_agino;
+		struct xfs_buf		*last_ibp;
+		struct xfs_dinode	*last_dip = NULL;
 
 		ASSERT(head_agino != agino);
 
 		pip = list_prev_entry(ip, i_unlink);
 		prev_agino = XFS_INO_TO_AGINO(mp, pip->i_ino);
 
-		/* We need to search the list for the inode being freed. */
-		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
-				prev_agino, &imap, &last_dip, &last_ibp,
-				agibp->b_pag);
+		error = xfs_imap_to_bp(mp, tp, &pip->i_imap, &last_dip, 
+						&last_ibp, 0);
 		if (error)
 			return error;
 
+		if (be32_to_cpu(last_dip->di_next_unlinked) != agino)
+			return -EFSCORRUPTED;
+
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
-				last_dip, &imap, next_agino);
+				last_dip, &pip->i_imap, next_agino);
 
 		return 0;
 	}
-- 
2.26.2.761.g0e0b3e54be

