Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB5EC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D64220825
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgEVDul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:41 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:49442 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728222AbgEVDuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:40 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 96AE1D58C46
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002Vp-UZ
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgIc-MG
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/24] xfs: clean up inode reclaim comments
Date:   Fri, 22 May 2020 13:50:23 +1000
Message-Id: <20200522035029.3022405-19-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=hsgbSS1IDo3W-jZ95UsA:9
        a=Iodl7Kk6mRjg2xHS:21 a=8wRG_svW4Cty618-:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Inode reclaim is quite different now to the way described in various
comments, so update all the comments explaining what it does and how
it works.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 128 ++++++++++++--------------------------------
 1 file changed, 35 insertions(+), 93 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8b366bc7b53c9..81c23384d3310 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -141,11 +141,8 @@ xfs_inode_free(
 }
 
 /*
- * Queue a new inode reclaim pass if there are reclaimable inodes and there
- * isn't a reclaim pass already in progress. By default it runs every 5s based
- * on the xfs periodic sync default of 30s. Perhaps this should have it's own
- * tunable, but that can be done if this method proves to be ineffective or too
- * aggressive.
+ * Queue background inode reclaim work if there are reclaimable inodes and there
+ * isn't reclaim work already scheduled or in progress.
  */
 static void
 xfs_reclaim_work_queue(
@@ -164,8 +161,7 @@ xfs_reclaim_work_queue(
  * This is a fast pass over the inode cache to try to get reclaim moving on as
  * many inodes as possible in a short period of time. It kicks itself every few
  * seconds, as well as being kicked by the inode cache shrinker when memory
- * goes low. It scans as quickly as possible avoiding locked inodes or those
- * already being flushed, and once done schedules a future pass.
+ * goes low.
  */
 void
 xfs_reclaim_worker(
@@ -618,48 +614,31 @@ xfs_iget_cache_miss(
 }
 
 /*
- * Look up an inode by number in the given file system.
- * The inode is looked up in the cache held in each AG.
- * If the inode is found in the cache, initialise the vfs inode
- * if necessary.
+ * Look up an inode by number in the given file system.  The inode is looked up
+ * in the cache held in each AG.  If the inode is found in the cache, initialise
+ * the vfs inode if necessary.
  *
- * If it is not in core, read it in from the file system's device,
- * add it to the cache and initialise the vfs inode.
+ * If it is not in core, read it in from the file system's device, add it to the
+ * cache and initialise the vfs inode.
  *
  * The inode is locked according to the value of the lock_flags parameter.
- * This flag parameter indicates how and if the inode's IO lock and inode lock
- * should be taken.
- *
- * mp -- the mount point structure for the current file system.  It points
- *       to the inode hash table.
- * tp -- a pointer to the current transaction if there is one.  This is
- *       simply passed through to the xfs_iread() call.
- * ino -- the number of the inode desired.  This is the unique identifier
- *        within the file system for the inode being requested.
- * lock_flags -- flags indicating how to lock the inode.  See the comment
- *		 for xfs_ilock() for a list of valid values.
+ * Inode lookup is only done during metadata operations and not as part of the
+ * data IO path. Hence we only allow locking of the XFS_ILOCK during lookup.
  */
 int
 xfs_iget(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	uint		flags,
-	uint		lock_flags,
-	xfs_inode_t	**ipp)
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	uint			flags,
+	uint			lock_flags,
+	struct xfs_inode	**ipp)
 {
-	xfs_inode_t	*ip;
-	int		error;
-	xfs_perag_t	*pag;
-	xfs_agino_t	agino;
+	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
+	xfs_agino_t		agino;
+	int			error;
 
-	/*
-	 * xfs_reclaim_inode() uses the ILOCK to ensure an inode
-	 * doesn't get freed while it's being referenced during a
-	 * radix tree traversal here.  It assumes this function
-	 * aqcuires only the ILOCK (and therefore it has no need to
-	 * involve the IOLOCK in this synchronization).
-	 */
 	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
 
 	/* reject inode numbers outside existing AGs */
@@ -771,15 +750,7 @@ xfs_inode_ag_walk_grab(
 
 	ASSERT(rcu_read_lock_held());
 
-	/*
-	 * check for stale RCU freed inode
-	 *
-	 * If the inode has been reallocated, it doesn't matter if it's not in
-	 * the AG we are walking - we are walking for writeback, so if it
-	 * passes all the "valid inode" checks and is dirty, then we'll write
-	 * it back anyway.  If it has been reallocated and still being
-	 * initialised, the XFS_INEW check below will catch it.
-	 */
+	/* Check for stale RCU freed inode */
 	spin_lock(&ip->i_flags_lock);
 	if (!ip->i_ino)
 		goto out_unlock_noent;
@@ -1089,43 +1060,16 @@ xfs_reclaim_inode_grab(
 }
 
 /*
- * Inodes in different states need to be treated differently. The following
- * table lists the inode states and the reclaim actions necessary:
- *
- *	inode state	     iflush ret		required action
- *      ---------------      ----------         ---------------
- *	bad			-		reclaim
- *	shutdown		EIO		unpin and reclaim
- *	clean, unpinned		0		reclaim
- *	stale, unpinned		0		reclaim
- *	clean, pinned(*)	0		requeue
- *	stale, pinned		EAGAIN		requeue
- *	dirty, async		-		requeue
- *	dirty, sync		0		reclaim
+ * Inode reclaim is non-blocking, so the default action if progress cannot be
+ * made is to "requeue" the inode for reclaim by unlocking it and clearing the
+ * XFS_IRECLAIM flag.  If we are in a shutdown state, we don't care about
+ * blocking anymore and hence we can wait for the inode to be able to reclaim
+ * it.
  *
- * (*) dgc: I don't think the clean, pinned state is possible but it gets
- * handled anyway given the order of checks implemented.
- *
- * Also, because we get the flush lock first, we know that any inode that has
- * been flushed delwri has had the flush completed by the time we check that
- * the inode is clean.
- *
- * Note that because the inode is flushed delayed write by AIL pushing, the
- * flush lock may already be held here and waiting on it can result in very
- * long latencies.  Hence for sync reclaims, where we wait on the flush lock,
- * the caller should push the AIL first before trying to reclaim inodes to
- * minimise the amount of time spent waiting.  For background relaim, we only
- * bother to reclaim clean inodes anyway.
- *
- * Hence the order of actions after gaining the locks should be:
- *	bad		=> reclaim
- *	shutdown	=> unpin and reclaim
- *	pinned, async	=> requeue
- *	pinned, sync	=> unpin
- *	stale		=> reclaim
- *	clean		=> reclaim
- *	dirty, async	=> requeue
- *	dirty, sync	=> flush, wait and reclaim
+ * We do no IO here - if callers require indoes to be cleaned they must push the
+ * AIL first to trigger writeback of dirty inodes. The enbales both the
+ * writeback to be done in the background in a non-blocking manner, as well as
+ * allowing reclaim to make progress without blocking.
  */
 static bool
 xfs_reclaim_inode(
@@ -1327,13 +1271,11 @@ xfs_reclaim_inodes(
 }
 
 /*
- * Scan a certain number of inodes for reclaim.
- *
- * When called we make sure that there is a background (fast) inode reclaim in
- * progress, while we will throttle the speed of reclaim via doing synchronous
- * reclaim of inodes. That means if we come across dirty inodes, we wait for
- * them to be cleaned, which we hope will not be very long due to the
- * background walker having already kicked the IO off on those dirty inodes.
+ * The shrinker infrastructure determines how many inodes we should scan for
+ * reclaim. We want as many clean inodes ready to reclaim as possible, so we
+ * push the AIL here. We also want to proactively free up memory if we can to
+ * minimise the amount of work memory reclaim has to do so we kick the
+ * background reclaim if it isn't already scheduled.
  */
 long
 xfs_reclaim_inodes_nr(
-- 
2.26.2.761.g0e0b3e54be

