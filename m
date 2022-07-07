Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB27BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 23:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbiGGXny (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbiGGXnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:43:53 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3736A6D54E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:43:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DA94710E7CD7
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 09:43:49 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9b9w-00FoQW-Kh
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 09:43:48 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9b9w-004bQX-Jb
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 09:43:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: combine iunlink inode update functions
Date:   Fri,  8 Jul 2022 09:43:43 +1000
Message-Id: <20220707234345.1097095-8-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707234345.1097095-1-david@fromorbit.com>
References: <20220707234345.1097095-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62c76fb6
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=0fqpcPgYxoWGbWmxxZ0A:9 a=AjGcO6oz07-iQ99wixmX:22
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 52 ++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 208f71240173..8a8266f1c32b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1905,38 +1905,9 @@ xfs_iunlink_update_bucket(
 	return 0;
 }
 
-/* Set an on-disk inode's next_unlinked pointer. */
-STATIC void
-xfs_iunlink_update_dinode(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	xfs_agino_t		agino,
-	struct xfs_buf		*ibp,
-	struct xfs_dinode	*dip,
-	struct xfs_imap		*imap,
-	xfs_agino_t		next_agino)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	int			offset;
-
-	ASSERT(xfs_verify_agino_or_null(pag, next_agino));
-
-	trace_xfs_iunlink_update_dinode(mp, pag->pag_agno, agino,
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
 /* Set an in-core inode's unlinked pointer and return the old value. */
 static int
-xfs_iunlink_update_inode(
+xfs_iunlink_log_inode(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
@@ -1946,6 +1917,7 @@ xfs_iunlink_update_inode(
 	struct xfs_dinode	*dip;
 	struct xfs_buf		*ibp;
 	xfs_agino_t		old_value;
+	int			offset;
 	int			error;
 
 	ASSERT(xfs_verify_agino_or_null(pag, next_agino));
@@ -1979,9 +1951,17 @@ xfs_iunlink_update_inode(
 		goto out;
 	}
 
-	/* Ok, update the new pointer. */
-	xfs_iunlink_update_dinode(tp, pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			ibp, dip, &ip->i_imap, next_agino);
+	trace_xfs_iunlink_update_dinode(mp, pag->pag_agno,
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
 out:
 	xfs_trans_brelse(tp, ibp);
@@ -2027,7 +2007,7 @@ xfs_iunlink_insert_inode(
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
 		 */
-		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino);
+		error = xfs_iunlink_log_inode(tp, ip, pag, next_agino);
 		if (error)
 			return error;
 		ip->i_next_unlinked = next_agino;
@@ -2103,7 +2083,7 @@ xfs_iunlink_remove_inode(
 	 * the old pointer value so that we can update whatever was previous
 	 * to us in the list to point to whatever was next in the list.
 	 */
-	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO);
+	error = xfs_iunlink_log_inode(tp, ip, pag, NULLAGINO);
 	if (error)
 		return error;
 
@@ -2123,7 +2103,7 @@ xfs_iunlink_remove_inode(
 		if (!prev_ip)
 			return -EFSCORRUPTED;
 
-		error = xfs_iunlink_update_inode(tp, prev_ip, pag,
+		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
 				ip->i_next_unlinked);
 		prev_ip->i_next_unlinked = ip->i_next_unlinked;
 	} else {
-- 
2.36.1

