Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B78DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 834D8206C3
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 09:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgHLJ0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:26:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42509 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727846AbgHLJ0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 05:26:02 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 037A73A6473
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 19:25:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-0003Qo-HC
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1k5n1B-00AltP-7l
        for linux-xfs@vger.kernel.org; Wed, 12 Aug 2020 19:25:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/13] xfs: combine iunlink inode update functions
Date:   Wed, 12 Aug 2020 19:25:54 +1000
Message-Id: <20200812092556.2567285-12-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=0fqpcPgYxoWGbWmxxZ0A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Combine the logging of the inode unlink list update into the
calling function that looks up the buffer we end up logging. These
do not need to be separate functions as they are both short, simple
operations and there's only a single call path through them. This
new function will end up being the core of the iunlink log item
processing...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 58 ++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4f616e1b64dc..82242d15b1d7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1972,38 +1972,12 @@ xfs_iunlink_update_bucket(
 	return 0;
 }
 
-/* Set an on-disk inode's next_unlinked pointer. */
-STATIC void
-xfs_iunlink_update_dinode(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		agino,
-	struct xfs_buf		*ibp,
-	struct xfs_dinode	*dip,
-	struct xfs_imap		*imap,
-	xfs_agino_t		next_agino)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	int			offset;
-
-	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
-
-	trace_xfs_iunlink_update_dinode(mp, agno, agino,
-			be32_to_cpu(dip->di_next_unlinked), next_agino);
-
-	dip->di_next_unlinked = cpu_to_be32(next_agino);
-	offset = imap->im_boffset +
-			offsetof(struct xfs_dinode, di_next_unlinked);
-
-	/* need to recalc the inode CRC if appropriate */
-	xfs_dinode_calc_crc(mp, dip);
-	xfs_trans_inode_buf(tp, ibp);
-	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
-}
-
-/* Set an in-core inode's unlinked pointer and return the old value. */
+/*
+ * Look up the inode cluster buffer and log the on-disk unlinked inode change
+ * we need to make.
+ */
 STATIC int
-xfs_iunlink_update_inode(
+xfs_iunlink_log_inode(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_agnumber_t		agno,
@@ -2013,6 +1987,7 @@ xfs_iunlink_update_inode(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_dinode	*dip;
 	struct xfs_buf		*ibp;
+	int			offset;
 	int			error;
 
 	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
@@ -2028,9 +2003,17 @@ xfs_iunlink_update_inode(
 		return -EFSCORRUPTED;
 	}
 
-	/* Ok, update the new pointer. */
-	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			ibp, dip, &ip->i_imap, next_agino);
+	trace_xfs_iunlink_update_dinode(mp, agno,
+			XFS_INO_TO_AGINO(mp, ip->i_ino),
+			be32_to_cpu(dip->di_next_unlinked), next_agino);
+
+	dip->di_next_unlinked = cpu_to_be32(next_agino);
+	offset = ip->i_imap.im_boffset +
+			offsetof(struct xfs_dinode, di_next_unlinked);
+
+	xfs_dinode_calc_crc(mp, dip);
+	xfs_trans_inode_buf(tp, ibp);
+	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
 	return 0;
 }
 
@@ -2056,7 +2039,7 @@ xfs_iunlink_insert_inode(
 		 * inode to the current head of the list.
 		 */
 		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
-		error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO,
+		error = xfs_iunlink_log_inode(tp, ip, agno, NULLAGINO,
 						 next_agino);
 		if (error)
 			return error;
@@ -2129,7 +2112,7 @@ xfs_iunlink_remove_inode(
 	}
 
 	/* Clear the on disk next unlinked pointer for this inode. */
-	error = xfs_iunlink_update_inode(tp, ip, agno, next_agino, NULLAGINO);
+	error = xfs_iunlink_log_inode(tp, ip, agno, next_agino, NULLAGINO);
 	if (error)
 		return error;
 
@@ -2138,8 +2121,7 @@ xfs_iunlink_remove_inode(
 					struct xfs_inode, i_unlink)) {
 		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
 
-		return xfs_iunlink_update_inode(tp, pip, agno, agino,
-						next_agino);
+		return xfs_iunlink_log_inode(tp, pip, agno, agino, next_agino);
 	}
 
 	/* Point the head of the list to the next unlinked inode. */
-- 
2.26.2.761.g0e0b3e54be

