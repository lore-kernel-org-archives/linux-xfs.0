Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B952DC433EB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A28D3206D4
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgFVIQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:16:16 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46338 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbgFVIQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 04:16:15 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 672183A405E
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 18:16:12 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-000462-Gv
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-007d5t-8r
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/30] xfs: don't block inode reclaim on the ILOCK
Date:   Mon, 22 Jun 2020 18:15:55 +1000
Message-Id: <20200622081605.1818434-21-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200622081605.1818434-1-david@fromorbit.com>
References: <20200622081605.1818434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 592eab23c6e7..f387ec21dd35 100644
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

