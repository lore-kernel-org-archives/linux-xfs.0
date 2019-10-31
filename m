Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE24CA9ECF
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 23:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17672173E
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 23:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfJaXrI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 19:47:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55491 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728774AbfJaXqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 19:46:34 -0400
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 283A53A2815;
        Fri,  1 Nov 2019 10:46:26 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iQK8x-0007CW-Kq; Fri, 01 Nov 2019 10:46:19 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iQK8x-000424-Iy; Fri, 01 Nov 2019 10:46:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/28] xfs: reduce kswapd blocking on inode locking.
Date:   Fri,  1 Nov 2019 10:46:09 +1100
Message-Id: <20191031234618.15403-20-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20191031234618.15403-1-david@fromorbit.com>
References: <20191031234618.15403-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=MeAgGD-zjQ4A:10 a=20KFwNOVAAAA:8
        a=KE6An8oM74Ymw0apzXAA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When doing async node reclaiming, we grab a batch of inodes that we
are likely able to reclaim and ignore those that are already
flushing. However, when we actually go to reclaim them, the first
thing we do is lock the inode. If we are racing with something
else reclaiming the inode or flushing it because it is dirty,
we block on the inode lock. Hence we can still block kswapd here.

Further, if we flush an inode, we also cluster all the other dirty
inodes in that cluster into the same IO, flush locking them all.
However, if the workload is operating on sequential inodes (e.g.
created by a tarball extraction) most of these inodes will be
sequntial in the cache and so in the same batch
we've already grabbed for reclaim scanning.

As a result, it is common for all the inodes in the batch to be
dirty and it is common for the first inode flushed to also flush all
the inodes in the reclaim batch. In which case, they are now all
going to be flush locked and we do not want to block on them.

Hence, for async reclaim (SYNC_TRYLOCK) make sure we always use
trylock semantics and abort reclaim of an inode as quickly as we can
without blocking kswapd. This will be necessary for the upcoming
conversion to LRU lists for inode reclaim tracking.

Found via tracing and finding big batches of repeated lock/unlock
runs on inodes that we just flushed by write clustering during
reclaim.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index edcc3f6bb3bf..189cf423fe8f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1104,11 +1104,23 @@ xfs_reclaim_inode(
 
 restart:
 	error = 0;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (!xfs_iflock_nowait(ip)) {
-		if (!(sync_mode & SYNC_WAIT))
+	/*
+	 * Don't try to flush the inode if another inode in this cluster has
+	 * already flushed it after we did the initial checks in
+	 * xfs_reclaim_inode_grab().
+	 */
+	if (sync_mode & SYNC_TRYLOCK) {
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 			goto out;
-		xfs_iflock(ip);
+		if (!xfs_iflock_nowait(ip))
+			goto out_unlock;
+	} else {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		if (!xfs_iflock_nowait(ip)) {
+			if (!(sync_mode & SYNC_WAIT))
+				goto out_unlock;
+			xfs_iflock(ip);
+		}
 	}
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
@@ -1215,9 +1227,10 @@ xfs_reclaim_inode(
 
 out_ifunlock:
 	xfs_ifunlock(ip);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	/*
 	 * We could return -EAGAIN here to make reclaim rescan the inode tree in
 	 * a short while. However, this just burns CPU time scanning the tree
-- 
2.24.0.rc0

