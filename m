Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652D6C433E8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D4620759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgEVDum (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:42 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33025 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728255AbgEVDum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:42 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EBADF3A34C4
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002Vn-TN
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgIX-L3
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/24] xfs: remove SYNC_TRYLOCK from inode reclaim
Date:   Fri, 22 May 2020 13:50:22 +1000
Message-Id: <20200522035029.3022405-18-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=wwBL6EluFSDcluHKyHoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All background reclaim is SYNC_TRYLOCK already, and even blocking
reclaim (SYNC_WAIT) can use trylock mechanisms as
xfs_reclaim_inodes_ag() will keep cycling until there are no more
reclaimable inodes. Hence we can kill SYNC_TRYLOCK from inode
reclaim and make everything unconditionally non-blocking.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c020d2379e12e..8b366bc7b53c9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1049,10 +1049,9 @@ xfs_inode_ag_iterator_tag(
  * Grab the inode for reclaim exclusively.
  * Return 0 if we grabbed it, non-zero otherwise.
  */
-STATIC int
+static int
 xfs_reclaim_inode_grab(
-	struct xfs_inode	*ip,
-	int			flags)
+	struct xfs_inode	*ip)
 {
 	ASSERT(rcu_read_lock_held());
 
@@ -1061,12 +1060,10 @@ xfs_reclaim_inode_grab(
 		return 1;
 
 	/*
-	 * If we are asked for non-blocking operation, do unlocked checks to
-	 * see if the inode already is being flushed or in reclaim to avoid
-	 * lock traffic.
+	 * Do unlocked checks to see if the inode already is being flushed or in
+	 * reclaim to avoid lock traffic.
 	 */
-	if ((flags & SYNC_TRYLOCK) &&
-	    __xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
 		return 1;
 
 	/*
@@ -1133,8 +1130,7 @@ xfs_reclaim_inode_grab(
 static bool
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			sync_mode)
+	struct xfs_perag	*pag)
 {
 	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
 
@@ -1224,7 +1220,6 @@ xfs_reclaim_inode(
 static int
 xfs_reclaim_inodes_ag(
 	struct xfs_mount	*mp,
-	int			flags,
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
@@ -1262,7 +1257,7 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				struct xfs_inode *ip = batch[i];
 
-				if (done || xfs_reclaim_inode_grab(ip, flags))
+				if (done || xfs_reclaim_inode_grab(ip))
 					batch[i] = NULL;
 
 				/*
@@ -1293,7 +1288,7 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				if (!batch[i])
 					continue;
-				if (!xfs_reclaim_inode(batch[i], pag, flags))
+				if (!xfs_reclaim_inode(batch[i], pag))
 					skipped++;
 			}
 
@@ -1319,13 +1314,13 @@ xfs_reclaim_inodes(
 	int		nr_to_scan = INT_MAX;
 	int		skipped;
 
-	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	if (!(mode & SYNC_WAIT))
 		return 0;
 
 	do {
 		xfs_ail_push_all_sync(mp->m_ail);
-		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	} while (skipped > 0);
 
 	return 0;
@@ -1349,7 +1344,7 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	return 0;
 }
 
-- 
2.26.2.761.g0e0b3e54be

