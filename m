Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA85C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69217207DE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgHLJ0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:02 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44143 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727850AbgHLJ0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:01 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 8836A1AA0B1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003QN-15
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1A-00Alsk-MR
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/13] xfs: factor the xfs_iunlink functions
Date:   Wed, 12 Aug 2020 19:25:46 +1000
Message-Id: <20200812092556.2567285-4-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=F3PrVUevTDCuoXpni7UA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Prep work that separates the locking that protects the unlinked list
from the actual operations being performed. This also helps document
the fact they are performing list insert  and remove operations. No
functional code change.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 92 ++++++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2072bd25989a..f2f502b65691 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2205,35 +2205,20 @@ xfs_iunlink_update_inode(
 	return error;
 }
 
-/*
- * This is called when the inode's link count has gone to 0 or we are creating
- * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
- *
- * We place the on-disk inode on a list in the AGI.  It will be pulled from this
- * list when the inode is freed.
- */
-STATIC int
-xfs_iunlink(
+static int
+xfs_iunlink_insert_inode(
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi;
-	struct xfs_buf		*agibp;
 	xfs_agino_t		next_agino;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
-	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(VFS_I(ip)->i_mode != 0);
-	trace_xfs_iunlink(ip);
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
 	agi = agibp->b_addr;
 
 	/*
@@ -2274,6 +2259,35 @@ xfs_iunlink(
 	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
 }
 
+/*
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
+ */
+STATIC int
+xfs_iunlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agibp;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
+		return error;
+
+	return xfs_iunlink_insert_inode(tp, agibp, ip);
+}
+
 /* Return the imap, dinode pointer, and buffer for an inode. */
 STATIC int
 xfs_iunlink_map_ino(
@@ -2388,32 +2402,23 @@ xfs_iunlink_map_prev(
 	return 0;
 }
 
-/*
- * Pull the on-disk inode from the AGI unlinked list.
- */
-STATIC int
-xfs_iunlink_remove(
+static int
+xfs_iunlink_remove_inode(
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agibp,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi;
-	struct xfs_buf		*agibp;
 	struct xfs_buf		*last_ibp;
 	struct xfs_dinode	*last_dip = NULL;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
 	xfs_agino_t		head_agino;
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
-	trace_xfs_iunlink_remove(ip);
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
 	agi = agibp->b_addr;
 
 	/*
@@ -2482,6 +2487,29 @@ xfs_iunlink_remove(
 			next_agino);
 }
 
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+STATIC int
+xfs_iunlink_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agibp;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
+		return error;
+
+	return xfs_iunlink_remove_inode(tp, agibp, ip);
+}
+
 /*
  * Look up the inode number specified and if it is not already marked XFS_ISTALE
  * mark it stale. We should only find clean inodes in this lookup that aren't
-- 
2.26.2.761.g0e0b3e54be

