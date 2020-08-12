Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBE2C433E8
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1914F207DE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgHLJ0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:09 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60385 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727864AbgHLJ0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:07 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 2BA72761095
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003Qi-DS
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-00AltE-3G
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] xfs: validate the unlinked list pointer on update
Date:   Wed, 12 Aug 2020 19:25:52 +1000
Message-Id: <20200812092556.2567285-10-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=jt6SPhbrO-Stp9irc_EA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Factor this check into xfs_iunlink_update_inode() when are updating
the code. This replaces the checks that were removed in previous
patches as bits of functionality were removed from the update
process.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4dde1970f7cd..b098e5df07e7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1998,6 +1998,7 @@ xfs_iunlink_update_inode(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_agnumber_t		agno,
+	xfs_agino_t		old_agino,
 	xfs_agino_t		next_agino)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
@@ -2011,6 +2012,13 @@ xfs_iunlink_update_inode(
 	if (error)
 		return error;
 
+	if (be32_to_cpu(dip->di_next_unlinked) != old_agino) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+					sizeof(*dip), __this_address);
+		xfs_trans_brelse(tp, ibp);
+		return -EFSCORRUPTED;
+	}
+
 	/* Ok, update the new pointer. */
 	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
 			ibp, dip, &ip->i_imap, next_agino);
@@ -2056,7 +2064,8 @@ xfs_iunlink_insert_inode(
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
 		 */
-		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino);
+		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
+						 next_agino);
 		if (error)
 			return error;
 	} else {
@@ -2147,37 +2156,18 @@ xfs_iunlink_remove_inode(
 	}
 
 	/* Clear the on disk next unlinked pointer for this inode. */
-	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO);
+	error = xfs_iunlink_update_inode(tp, ip, agno, next_agino, NULLAGINO);
 	if (error)
 		return error;
 
 
 	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
 					struct xfs_inode, i_unlink)) {
-
-		struct xfs_inode	*pip;
-		xfs_agino_t		prev_agino;
-		struct xfs_buf		*last_ibp;
-		struct xfs_dinode	*last_dip = NULL;
+		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
 
 		ASSERT(head_agino != agino);
-
-		pip = list_prev_entry(ip, i_unlink);
-		prev_agino = XFS_INO_TO_AGINO(mp, pip->i_ino);
-
-		error = xfs_imap_to_bp(mp, tp, &pip->i_imap, &last_dip, 
-						&last_ibp, 0);
-		if (error)
-			return error;
-
-		if (be32_to_cpu(last_dip->di_next_unlinked) != agino)
-			return -EFSCORRUPTED;
-
-		/* Point the previous inode on the list to the next inode. */
-		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
-				last_dip, &pip->i_imap, next_agino);
-
-		return 0;
+		return xfs_iunlink_update_inode(tp, pip, agno, agino,
+						next_agino);
 	}
 
 	/* Point the head of the list to the next unlinked inode. */
-- 
2.26.2.761.g0e0b3e54be

