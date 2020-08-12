Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53A2C433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF9D206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgHLJ0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:03 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44455 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgHLJ0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:01 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 05B0FD7CF95
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003Ql-Fv
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-00AltK-5O
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/13] xfs: re-order AGI updates in unlink list updates
Date:   Wed, 12 Aug 2020 19:25:53 +1000
Message-Id: <20200812092556.2567285-11-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=nhtNILuVBLXkEHnFDBAA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We always access and check the AGI bucket entry for the unlinked
list even if we are not going to need it either for lookup or remove
purposes. Move the code that accesses the AGI to the code that
modifes the AGI, hence keeping the AGI accesses local to the code
that needs to modify it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 84 ++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b098e5df07e7..4f616e1b64dc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1918,44 +1918,53 @@ xfs_inactive(
  */
 
 /*
- * Point the AGI unlinked bucket at an inode and log the results.  The caller
- * is responsible for validating the old value.
+ * Point the AGI unlinked bucket at an inode and log the results. The caller
+ * passes in the expected current agino the bucket points at via @cur_agino so
+ * we can validate that we are about to remove the inode we expect to be
+ * removing from the AGI bucket.
  */
-STATIC int
+static int
 xfs_iunlink_update_bucket(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	struct xfs_buf		*agibp,
-	xfs_agino_t		old_agino,
+	xfs_agino_t		cur_agino,
 	xfs_agino_t		new_agino)
 {
-	struct xlog		*log = tp->t_mountp->m_log;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xlog		*log = mp->m_log;
 	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		old_value;
+	xfs_agino_t		old_agino;
 	unsigned int		bucket_index;
 	int                     offset;
 
-	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
+	ASSERT(xfs_verify_agino_or_null(mp, agno, new_agino));
 
+	/*
+	 * We don't need to traverse the on disk unlinked list to find the
+	 * previous inode in the list when removing inodes anymore, so we don't
+	 * use multiple on-disk lists anymore. Hence we always use bucket 0
+	 * unless we are in log recovery in which case we might be recovering an
+	 * old filesystem that has multiple buckets.
+	 */
 	bucket_index = 0;
-	/* During recovery, the old multiple bucket index can be applied */
 	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
-		ASSERT(old_agino != NULLAGINO);
+		ASSERT(cur_agino != NULLAGINO);
 
-		if (be32_to_cpu(agi->agi_unlinked[0]) != old_agino)
-			bucket_index = old_agino % XFS_AGI_UNLINKED_BUCKETS;
+		if (be32_to_cpu(agi->agi_unlinked[0]) != cur_agino)
+			bucket_index = cur_agino % XFS_AGI_UNLINKED_BUCKETS;
 	}
 
-	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
-			old_value, new_agino);
-
-	/* check if the old agi_unlinked head is as expected */
-	if (old_value != old_agino) {
+	old_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (new_agino == old_agino || cur_agino != old_agino ||
+	    !xfs_verify_agino_or_null(mp, agno, old_agino)) {
 		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 
+	trace_xfs_iunlink_update_bucket(mp, agno, bucket_index,
+			old_agino, new_agino);
+
 	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
 	offset = offsetof(struct xfs_agi, agi_unlinked) +
 			(sizeof(xfs_agino_t) * bucket_index);
@@ -2032,44 +2041,25 @@ xfs_iunlink_insert_inode(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi;
 	struct xfs_inode	*nip;
-	xfs_agino_t		next_agino;
+	xfs_agino_t		next_agino = NULLAGINO;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	int			error;
 
-	agi = agibp->b_addr;
-
-	/*
-	 * We don't need to traverse the on disk unlinked list to find the
-	 * previous inode in the list when removing inodes anymore, so we don't
-	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
-	 * Make sure the pointer isn't garbage and that this inode isn't already
-	 * on the list.
-	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[0]);
-	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
-		xfs_buf_mark_corrupt(agibp);
-		return -EFSCORRUPTED;
-	}
-
 	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
 					struct xfs_inode, i_unlink);
 	if (nip) {
-		ASSERT(next_agino == XFS_INO_TO_AGINO(mp, nip->i_ino));
 
 		/*
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
 		 */
+		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
 		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
 						 next_agino);
 		if (error)
 			return error;
-	} else {
-		ASSERT(next_agino == NULLAGINO);
 	}
 
 	/* Point the head of the list to point to this inode. */
@@ -2122,28 +2112,11 @@ xfs_iunlink_remove_inode(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		next_agino = NULLAGINO;
-	xfs_agino_t		head_agino;
 	int			error;
 
-	agi = agibp->b_addr;
-
-	/*
-	 * We don't need to traverse the on disk unlinked list to find the
-	 * previous inode in the list when removing inodes anymore, so we don't
-	 * need multiple on-disk lists anymore. Hence we always use bucket 0.
-	 * Make sure the head pointer isn't garbage.
-	 */
-	head_agino = be32_to_cpu(agi->agi_unlinked[0]);
-	if (!xfs_verify_agino(mp, agno, head_agino)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				agi, sizeof(*agi));
-		return -EFSCORRUPTED;
-	}
-
 	/*
 	 * Get the next agino in the list. If we are at the end of the list,
 	 * then the previous inode's i_next_unlinked filed will get cleared.
@@ -2165,7 +2138,6 @@ xfs_iunlink_remove_inode(
 					struct xfs_inode, i_unlink)) {
 		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
 
-		ASSERT(head_agino != agino);
 		return xfs_iunlink_update_inode(tp, pip, agno, agino,
 						next_agino);
 	}
-- 
2.26.2.761.g0e0b3e54be

