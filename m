Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA56C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 04:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE92064E5C
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 04:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhBWErX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 23:47:23 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33277 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230268AbhBWErV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 23:47:21 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5D6381040FD4
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 15:46:39 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEPao-0006TC-Rw
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 15:46:38 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEPao-00Dlc7-KL
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 15:46:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: xfs_buf_item_size_segment() needs to pass segment offset
Date:   Tue, 23 Feb 2021 15:46:35 +1100
Message-Id: <20210223044636.3280862-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210223044636.3280862-1-david@fromorbit.com>
References: <20210223044636.3280862-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=kme4I8nbBunu55xL2I8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Otherwise it doesn't correctly calculate the number of vectors
in a logged buffer that has a contiguous map that gets split into
multiple regions because the range spans discontigous memory.

Probably never been hit in practice - we don't log contiguous ranges
on unmapped buffers (inode clusters).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0628a65d9c55..91dc7d8c9739 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -55,6 +55,18 @@ xfs_buf_log_format_size(
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
 }
 
+static inline bool
+xfs_buf_item_straddle(
+	struct xfs_buf		*bp,
+	uint			offset,
+	int			next_bit,
+	int			last_bit)
+{
+	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
+		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
+		 XFS_BLF_CHUNK);
+}
+
 /*
  * Return the number of log iovecs and space needed to log the given buf log
  * item segment.
@@ -67,6 +79,7 @@ STATIC void
 xfs_buf_item_size_segment(
 	struct xfs_buf_log_item		*bip,
 	struct xfs_buf_log_format	*blfp,
+	uint				offset,
 	int				*nvecs,
 	int				*nbytes)
 {
@@ -101,12 +114,8 @@ xfs_buf_item_size_segment(
 		 */
 		if (next_bit == -1) {
 			break;
-		} else if (next_bit != last_bit + 1) {
-			last_bit = next_bit;
-			(*nvecs)++;
-		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
-			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
-			    XFS_BLF_CHUNK)) {
+		} else if (next_bit != last_bit + 1 ||
+		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
 			last_bit = next_bit;
 			(*nvecs)++;
 		} else {
@@ -141,8 +150,10 @@ xfs_buf_item_size(
 	int			*nbytes)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
 	int			i;
 	int			bytes;
+	uint			offset = 0;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -184,8 +195,9 @@ xfs_buf_item_size(
 	 */
 	bytes = 0;
 	for (i = 0; i < bip->bli_format_count; i++) {
-		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
+		xfs_buf_item_size_segment(bip, &bip->bli_formats[i], offset,
 					  nvecs, &bytes);
+		offset += BBTOB(bp->b_maps[i].bm_len);
 	}
 
 	/*
@@ -212,18 +224,6 @@ xfs_buf_item_copy_iovec(
 			nbits * XFS_BLF_CHUNK);
 }
 
-static inline bool
-xfs_buf_item_straddle(
-	struct xfs_buf		*bp,
-	uint			offset,
-	int			next_bit,
-	int			last_bit)
-{
-	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
-		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
-		 XFS_BLF_CHUNK);
-}
-
 static void
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
-- 
2.28.0

