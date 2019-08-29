Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892B4C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69DD32339E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 10:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfH2KrU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 06:47:20 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34827 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726973AbfH2KrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 06:47:19 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 26B3C361CB4
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 20:47:14 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HxQ-00032e-Ki
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 20:47:12 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HxQ-0007OE-J9
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 20:47:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: reverse search directory freespace indexes
Date:   Thu, 29 Aug 2019 20:47:10 +1000
Message-Id: <20190829104710.28239-6-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190829104710.28239-1-david@fromorbit.com>
References: <20190829104710.28239-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=SUicX0odFCYvpFH38aAA:9 a=p-Z9SOsmXBCEoUSk:21 a=tddZAhjlFDH3ISzV:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When a directory is growing rapidly, new blocks tend to get added at
the end of the directory. These end up at the end of the freespace
index, and when the directory gets large finding these new
freespaces gets expensive. The code does a linear search across the
frespace index from the first block in the directory to the last,
hence meaning the newly added space is the last index searched.

Instead, do a reverse order index search, starting from the last
block and index in the freespace index. This makes most lookups for
free space on rapidly growing directories O(1) instead of O(N), but
should not have any impact on random insert workloads because the
average search length is the same regardless of which end of the
array we start at.

The result is a major improvement in large directory grow rates:

		create time(sec) / rate (files/s)
 File count     vanilla             Prev commit		Patched
  10k	      0.41 / 24.3k	   0.42 / 23.8k       0.41 / 24.3k
  20k	      0.74 / 27.0k	   0.76 / 26.3k       0.75 / 26.7k
 100k	      3.81 / 26.4k	   3.47 / 28.8k       3.27 / 30.6k
 200k	      8.58 / 23.3k	   7.19 / 27.8k       6.71 / 29.8k
   1M	     85.69 / 11.7k	  48.53 / 20.6k      37.67 / 26.5k
   2M	    280.31 /  7.1k	 130.14 / 15.3k      79.55 / 25.2k
  10M	   3913.26 /  2.5k                          552.89 / 18.1k

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index a81f56d9e538..705c4f562758 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1745,10 +1745,11 @@ xfs_dir2_node_find_freeblk(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_buf		*fbp = NULL;
+	xfs_dir2_db_t		firstfbno;
 	xfs_dir2_db_t		lastfbno;
 	xfs_dir2_db_t		ifbno = -1;
 	xfs_dir2_db_t		dbno = -1;
-	xfs_dir2_db_t		fbno = -1;
+	xfs_dir2_db_t		fbno;
 	xfs_fileoff_t		fo;
 	__be16			*bests = NULL;
 	int			findex = 0;
@@ -1780,7 +1781,6 @@ xfs_dir2_node_find_freeblk(
 		 * We'll start at the beginning of the freespace entries.
 		 */
 		ifbno = fblk->blkno;
-		fbno = ifbno;
 		xfs_trans_brelse(tp, fbp);
 		fbp = NULL;
 		fblk->bp = NULL;
@@ -1794,12 +1794,9 @@ xfs_dir2_node_find_freeblk(
 	if (error)
 		return error;
 	lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
+	firstfbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
 
-	/* If we haven't get a search start block, set it now */
-	if (fbno == -1)
-		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
-
-	for ( ; fbno < lastfbno; fbno++) {
+	for (fbno = lastfbno - 1; fbno >= firstfbno; fbno--) {
 		/* If it's ifbno we already looked at it. */
 		if (fbno == ifbno)
 			continue;
@@ -1822,7 +1819,7 @@ xfs_dir2_node_find_freeblk(
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
 
 		/* Scan the free entry array for a large enough free space. */
-		for (findex = 0; findex < freehdr.nvalid; findex++) {
+		for (findex = freehdr.nvalid - 1; findex >= 0; findex--) {
 			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
 			    be16_to_cpu(bests[findex]) >= length) {
 				dbno = freehdr.firstdb + findex;
-- 
2.23.0.rc1

