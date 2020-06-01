Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A7DC433E8
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1C9B2076B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgFAVnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:43:01 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:32779 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728795AbgFAVm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:59 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8B536D78CA4
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000X5-MG
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU6F-DG
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/30] xfs: don't block inode reclaim on the ILOCK
Date:   Tue,  2 Jun 2020 07:42:41 +1000
Message-Id: <20200601214251.4167140-21-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=tOYOrV8LyEHl0yQJZvYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we attempt to reclaim an inode, the first thing we do is take
the inode lock. This is blocking right now, so if the inode being
accessed by something else (e.g. being flushed to the cluster
buffer) we will block here.

Change this to a trylock so that we do not block inode reclaim
unnecessarily here.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c4ba8d7bc45bc..d1c47a0e0b0ec 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1119,9 +1119,10 @@ xfs_reclaim_inode(
 {
 	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (!xfs_iflock_nowait(ip))
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 		goto out;
+	if (!xfs_iflock_nowait(ip))
+		goto out_iunlock;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
@@ -1188,8 +1189,9 @@ xfs_reclaim_inode(
 
 out_ifunlock:
 	xfs_ifunlock(ip);
-out:
+out_iunlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out:
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
 	return false;
 }
-- 
2.26.2.761.g0e0b3e54be

