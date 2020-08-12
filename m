Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B06C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B628206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHLJ0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:02 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34473 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727845AbgHLJ0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:01 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CF513822D85
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003Qe-BK
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-00AltA-1q
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/13] xfs: updating i_next_unlinked doesn't need to return old value
Date:   Wed, 12 Aug 2020 19:25:51 +1000
Message-Id: <20200812092556.2567285-9-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=6daM4uCB-z7HDM2YcMwA:9
        a=qC-bKFu-Zar0IfaK:21 a=oJanMg7FDDYBrPXT:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We already know what the next inode in the unlinked list is supposed
to be from the in-memory list, so we do not need to look it up first
from the current inode to be able to update in memory list
pointers...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 63 +++++++++++-----------------------------------
 1 file changed, 14 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bacd5ae9f5a7..4dde1970f7cd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1998,13 +1998,11 @@ xfs_iunlink_update_inode(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_agnumber_t		agno,
-	xfs_agino_t		next_agino,
-	xfs_agino_t		*old_next_agino)
+	xfs_agino_t		next_agino)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_dinode	*dip;
 	struct xfs_buf		*ibp;
-	xfs_agino_t		old_value;
 	int			error;
 
 	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
@@ -2013,37 +2011,10 @@ xfs_iunlink_update_inode(
 	if (error)
 		return error;
 
-	/* Make sure the old pointer isn't garbage. */
-	old_value = be32_to_cpu(dip->di_next_unlinked);
-	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
-				sizeof(*dip), __this_address);
-		error = -EFSCORRUPTED;
-		goto out;
-	}
-
-	/*
-	 * Since we're updating a linked list, we should never find that the
-	 * current pointer is the same as the new value, unless we're
-	 * terminating the list.
-	 */
-	*old_next_agino = old_value;
-	if (old_value == next_agino) {
-		if (next_agino != NULLAGINO) {
-			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
-					dip, sizeof(*dip), __this_address);
-			error = -EFSCORRUPTED;
-		}
-		goto out;
-	}
-
 	/* Ok, update the new pointer. */
 	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
 			ibp, dip, &ip->i_imap, next_agino);
 	return 0;
-out:
-	xfs_trans_brelse(tp, ibp);
-	return error;
 }
 
 static int
@@ -2079,19 +2050,15 @@ xfs_iunlink_insert_inode(
 	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
 					struct xfs_inode, i_unlink);
 	if (nip) {
-		xfs_agino_t		old_agino;
-
 		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
 
 		/*
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
 		 */
-		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino,
-				&old_agino);
+		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino);
 		if (error)
 			return error;
-		ASSERT(old_agino == NULLAGINO);
 	} else {
 		ASSERT(next_agino == NULLAGINO);
 	}
@@ -2149,7 +2116,7 @@ xfs_iunlink_remove_inode(
 	struct xfs_agi		*agi;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	xfs_agino_t		next_agino;
+	xfs_agino_t		next_agino = NULLAGINO;
 	xfs_agino_t		head_agino;
 	int			error;
 
@@ -2169,23 +2136,21 @@ xfs_iunlink_remove_inode(
 	}
 
 	/*
-	 * Set our inode's next_unlinked pointer to NULL and then return
-	 * the old pointer value so that we can update whatever was previous
-	 * to us in the list to point to whatever was next in the list.
+	 * Get the next agino in the list. If we are at the end of the list,
+	 * then the previous inode's i_next_unlinked filed will get cleared.
 	 */
-	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
+	if (ip != list_last_entry(&agibp->b_pag->pag_ici_unlink_list,
+					struct xfs_inode, i_unlink)) {
+		struct xfs_inode *nip = list_next_entry(ip, i_unlink);
+
+		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
+	}
+
+	/* Clear the on disk next unlinked pointer for this inode. */
+	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO);
 	if (error)
 		return error;
 
-#ifdef DEBUG
-	{
-	struct xfs_inode *nip = list_next_entry(ip, i_unlink);
-	if (nip)
-		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
-	else
-		ASSERT(next_agino == NULLAGINO);
-	}
-#endif
 
 	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
 					struct xfs_inode, i_unlink)) {
-- 
2.26.2.761.g0e0b3e54be

