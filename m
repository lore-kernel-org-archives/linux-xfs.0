Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC57C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEADD2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lbYIJ2S1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgAABJY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgAABJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119L0i109821
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oSh7ikZNiQic93hR6H8BKaeUM6QI73D1LiC0+Lzd47w=;
 b=lbYIJ2S1dnIoVOOxLZ8x4K2yrL5F58z6b4xzJ5maFbbvOBZrkLbOGvZR53bH9+gG47om
 YH1LsT8sehqRSjkjj5XiU3D4OSXqlT3OBcOdSyH1bvXkGbvtxxacnCNpOe+EegHKlQwi
 vns/QU3ES7CoiJmwEqjNrqnajsnkZ5CXbGcXYVW87lZXCuKf/JW//zjqHZ+8op0Psq97
 ZhEEKBWAvCRCm3IWzhpVo/6D6ix3GzTJPMQBPBT3U7ux+8x8YmutT33FFIL9g7m407xt
 o8PHBPTqbBVHgcIQbqHKNQqaVSDUEBaP06sG/B1GVLck01MDde/d/Q8XXbAKm4cyiudN BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk2dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v8a190299
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrfynj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:20 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00119J3T031507
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:20 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:19 -0800
Subject: [PATCH 06/10] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:17 -0800
Message-ID: <157784095718.1362752.13211509487069295216.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
defer the inactivation phase to a separate workqueue.  With this we
avoid blocking memory reclaim on filesystem metadata updates that are
necessary to free an in-core inode, such as post-eof block freeing, COW
staging extent freeing, and truncating and freeing unlinked inodes.  Now
that work is deferred to a workqueue where we can do the freeing in
batches.

We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
The first flag helps our worker find inodes needing inactivation, and
the second flag marks inodes that are in the process of being
inactivated.  A concurrent xfs_iget on the inode can still resurrect the
inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).

Unfortunately, deferring the inactivation has one huge downside --
eventual consistency.  Since all the freeing is deferred to a worker
thread, one can rm a file but the space doesn't come back immediately.
This can cause some odd side effects with quota accounting and statfs,
so we also force inactivation scans in order to maintain the existing
behaviors, at least outwardly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c      |  430 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h      |    8 +
 fs/xfs/xfs_inode.c       |   76 ++++++++
 fs/xfs/xfs_inode.h       |   15 +-
 fs/xfs/xfs_iomap.c       |    1 
 fs/xfs/xfs_log_recover.c |    7 +
 fs/xfs/xfs_mount.c       |   20 ++
 fs/xfs/xfs_mount.h       |    5 -
 fs/xfs/xfs_qm_syscalls.c |    6 +
 fs/xfs/xfs_super.c       |   56 +++++-
 fs/xfs/xfs_trace.h       |   15 +-
 11 files changed, 612 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 01f5502d984a..13b318dc2e89 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -30,6 +30,8 @@ STATIC int xfs_inode_free_eofblocks(struct xfs_inode *ip, struct xfs_perag *pag,
 		void *args);
 STATIC int xfs_inode_free_cowblocks(struct xfs_inode *ip, struct xfs_perag *pag,
 		void *args);
+static void xfs_perag_set_inactive_tag(struct xfs_perag *pag);
+static void xfs_perag_clear_inactive_tag(struct xfs_perag *pag);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -222,6 +224,18 @@ xfs_perag_clear_reclaim_tag(
 	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
 }
 
+static void
+__xfs_inode_set_reclaim_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			   XFS_ICI_RECLAIM_TAG);
+	xfs_perag_set_reclaim_tag(pag);
+	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+}
 
 /*
  * We set the inode flag atomically with the radix tree tag.
@@ -239,10 +253,7 @@ xfs_inode_set_reclaim_tag(
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 
-	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			   XFS_ICI_RECLAIM_TAG);
-	xfs_perag_set_reclaim_tag(pag);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	__xfs_inode_set_reclaim_tag(pag, ip);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -260,6 +271,40 @@ xfs_inode_clear_reclaim_tag(
 	xfs_perag_clear_reclaim_tag(pag);
 }
 
+/* Set this inode's inactive tag and set the per-AG tag. */
+void
+xfs_inode_set_inactive_tag(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
+				   XFS_ICI_INACTIVE_TAG);
+	xfs_perag_set_inactive_tag(pag);
+	__xfs_iflags_set(ip, XFS_NEED_INACTIVE);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
+
+/* Clear this inode's inactive tag and try to clear the AG's. */
+STATIC void
+xfs_inode_clear_inactive_tag(
+	struct xfs_perag	*pag,
+	xfs_ino_t		ino)
+{
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
+			     XFS_ICI_INACTIVE_TAG);
+	xfs_perag_clear_inactive_tag(pag);
+}
+
 static void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
@@ -321,6 +366,13 @@ xfs_iget_check_free_state(
 	struct xfs_inode	*ip,
 	int			flags)
 {
+	/*
+	 * Unlinked inodes awaiting inactivation must not be reused until we
+	 * have a chance to clear the on-disk metadata.
+	 */
+	if (VFS_I(ip)->i_nlink == 0 && (ip->i_flags & XFS_NEED_INACTIVE))
+		return -ENOENT;
+
 	if (flags & XFS_IGET_CREATE) {
 		/* should be a free inode */
 		if (VFS_I(ip)->i_mode != 0) {
@@ -348,6 +400,77 @@ xfs_iget_check_free_state(
 	return 0;
 }
 
+/*
+ * We've torn down the VFS part of this NEED_INACTIVE inode, so we need to get
+ * it back into working state.  This function unlocks the i_flags_lock and RCU.
+ */
+static int
+xfs_iget_inactive(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+	__releases(&ip->i_flags_lock) __releases(RCU)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	/*
+	 * We need to set XFS_INACTIVATING to prevent xfs_inactive_inode from
+	 * stomping over us while we recycle the inode.  We can't clear the
+	 * radix tree inactive tag yet as it requires pag_ici_lock to be held
+	 * exclusive.
+	 */
+	ip->i_flags |= XFS_INACTIVATING;
+
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
+
+	/* Undo our inactivation preparation and drop the tags. */
+	xfs_inode_inactivation_cleanup(ip);
+
+	error = xfs_reinit_inode(mp, inode);
+	if (error) {
+		bool wake;
+		/*
+		 * Re-initializing the inode failed, and we are in deep
+		 * trouble.  Try to re-add it to the inactive list.
+		 */
+		rcu_read_lock();
+		spin_lock(&ip->i_flags_lock);
+		wake = !!__xfs_iflags_test(ip, XFS_INEW);
+		ip->i_flags &= ~(XFS_INEW | XFS_INACTIVATING);
+		if (wake)
+			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
+		ASSERT(ip->i_flags & XFS_NEED_INACTIVE);
+		trace_xfs_iget_inactive_fail(ip);
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+		return error;
+	}
+
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	/*
+	 * Clear the per-lifetime state in the inode as we are now effectively
+	 * a new inode and need to return to the initial state before reuse
+	 * occurs.
+	 */
+	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
+	ip->i_flags |= XFS_INEW;
+	xfs_inode_clear_inactive_tag(pag, ip->i_ino);
+	inode->i_state = I_NEW;
+	ip->i_sick = 0;
+	ip->i_checked = 0;
+
+	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
+	init_rwsem(&inode->i_rwsem);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+	return 0;
+}
+
 /*
  * Check the validity of the inode we just found it the cache
  */
@@ -382,14 +505,14 @@ xfs_iget_cache_hit(
 	/*
 	 * If we are racing with another cache hit that is currently
 	 * instantiating this inode or currently recycling it out of
-	 * reclaimabe state, wait for the initialisation to complete
+	 * reclaimable state, wait for the initialisation to complete
 	 * before continuing.
 	 *
 	 * XXX(hch): eventually we should do something equivalent to
 	 *	     wait_on_inode to wait for these flags to be cleared
 	 *	     instead of polling for it.
 	 */
-	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
+	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING)) {
 		trace_xfs_iget_skip(ip);
 		XFS_STATS_INC(mp, xs_ig_frecycle);
 		error = -EAGAIN;
@@ -465,6 +588,21 @@ xfs_iget_cache_hit(
 
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
+	} else if (ip->i_flags & XFS_NEED_INACTIVE) {
+		/*
+		 * If NEED_INACTIVE is set, we've torn down the VFS inode and
+		 * need to carefully get it back into useable state.
+		 */
+		trace_xfs_iget_inactive(ip);
+
+		if (flags & XFS_IGET_INCORE) {
+			error = -EAGAIN;
+			goto out_error;
+		}
+
+		error = xfs_iget_inactive(pag, ip);
+		if (error)
+			return error;
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -772,7 +910,8 @@ xfs_inode_ag_walk_grab(
 
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
 	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM |
+				  XFS_NEED_INACTIVE | XFS_INACTIVATING))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -1052,6 +1191,10 @@ xfs_blockgc_scan(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
+	if (eofb->eof_flags & XFS_EOF_FLAGS_SYNC)
+		xfs_inactive_inodes(mp, eofb);
+	else
+		xfs_inactive_force(mp);
 	return xfs_ici_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
 			XFS_ICI_BLOCK_GC_TAG);
 }
@@ -1199,6 +1342,8 @@ xfs_reclaim_inode(
 	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
 	int			error;
 
+	trace_xfs_inode_reclaiming(ip);
+
 restart:
 	error = 0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1926,3 +2071,274 @@ xfs_inode_clear_cowblocks_tag(
 	trace_xfs_inode_clear_cowblocks_tag(ip);
 	return __xfs_inode_clear_blocks_tag(ip, XFS_ICOWBLOCKS);
 }
+
+/*
+ * Deferred Inode Inactivation
+ * ===========================
+ *
+ * Sometimes, inodes need to have work done on them once the last program has
+ * closed the file.  Typically this means cleaning out any leftover post-eof or
+ * CoW staging blocks for linked files.  For inodes that have been totally
+ * unlinked, this means unmapping data/attr/cow blocks, removing the inode
+ * from the unlinked buckets, and marking it free in the inobt and inode table.
+ *
+ * This process can generate many metadata updates, which shows up as close()
+ * and unlink() calls that take a long time.  We defer all that work to a
+ * per-AG workqueue which means that we can batch a lot of work and do it in
+ * inode order for better performance.  Furthermore, we can control the
+ * workqueue, which means that we can avoid doing inactivation work at a bad
+ * time, such as when the fs is frozen.
+ *
+ * Deferred inactivation introduces new inode flag states (NEED_INACTIVE and
+ * INACTIVATING) and adds a new INACTIVE radix tree tag for fast access.  We
+ * maintain separate perag counters for both types, and move counts as inodes
+ * wander the state machine, which now works as follows:
+ *
+ * If the inode needs inactivation, we:
+ *   - Set the NEED_INACTIVE inode flag
+ *   - Increment the per-AG inactive count
+ *   - Set the INACTIVE tag in the per-AG inode tree
+ *   - Set the INACTIVE tag in the per-fs AG tree
+ *   - Schedule background inode inactivation
+ *
+ * If the inode does not need inactivation, we:
+ *   - Set the RECLAIMABLE inode flag
+ *   - Increment the per-AG reclaim count
+ *   - Set the RECLAIM tag in the per-AG inode tree
+ *   - Set the RECLAIM tag in the per-fs AG tree
+ *   - Schedule background inode reclamation
+ *
+ * When it is time for background inode inactivation, we:
+ *   - Set the INACTIVATING inode flag
+ *   - Make all the on-disk updates
+ *   - Clear both INACTIVATING and NEED_INACTIVE inode flags
+ *   - Decrement the per-AG inactive count
+ *   - Clear the INACTIVE tag in the per-AG inode tree
+ *   - Clear the INACTIVE tag in the per-fs AG tree if that was the last one
+ *   - Kick the inode into reclamation per the previous paragraph.
+ *
+ * When it is time for background inode reclamation, we:
+ *   - Set the IRECLAIM inode flag
+ *   - Detach all the resources and remove the inode from the per-AG inode tree
+ *   - Clear both IRECLAIM and RECLAIMABLE inode flags
+ *   - Decrement the per-AG reclaim count
+ *   - Clear the RECLAIM tag from the per-AG inode tree
+ *   - Clear the RECLAIM tag from the per-fs AG tree if there are no more
+ *     inodes waiting for reclamation or inactivation
+ */
+
+/* Queue a new inode inactivation pass if there are reclaimable inodes. */
+static void
+xfs_inactive_work_queue(
+	struct xfs_mount        *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INACTIVE_TAG))
+		queue_delayed_work(mp->m_inactive_workqueue,
+				&mp->m_inactive_work,
+				msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
+	rcu_read_unlock();
+}
+
+/* Remember that an AG has one more inode to inactivate. */
+static void
+xfs_perag_set_inactive_tag(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	lockdep_assert_held(&pag->pag_ici_lock);
+	if (pag->pag_ici_inactive++)
+		return;
+
+	/* propagate the inactive tag up into the perag radix tree */
+	spin_lock(&mp->m_perag_lock);
+	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
+			   XFS_ICI_INACTIVE_TAG);
+	spin_unlock(&mp->m_perag_lock);
+
+	/* schedule periodic background inode inactivation */
+	xfs_inactive_work_queue(mp);
+
+	trace_xfs_perag_set_inactive(mp, pag->pag_agno, -1, _RET_IP_);
+}
+
+/* Remember that an AG has one less inode to inactivate. */
+static void
+xfs_perag_clear_inactive_tag(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	lockdep_assert_held(&pag->pag_ici_lock);
+	if (--pag->pag_ici_inactive)
+		return;
+
+	/* clear the inactive tag from the perag radix tree */
+	spin_lock(&mp->m_perag_lock);
+	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
+			     XFS_ICI_INACTIVE_TAG);
+	spin_unlock(&mp->m_perag_lock);
+	trace_xfs_perag_clear_inactive(mp, pag->pag_agno, -1, _RET_IP_);
+}
+
+/*
+ * Grab the inode for inactivation exclusively.
+ * Return true if we grabbed it.
+ */
+STATIC bool
+xfs_inactive_grab(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	ASSERT(rcu_read_lock_held());
+
+	/* quick check for stale RCU freed inode */
+	if (!ip->i_ino)
+		return false;
+
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.
+	 *
+	 * Due to RCU lookup, we may find inodes that have been freed and only
+	 * have XFS_IRECLAIM set.  Indeed, we may see reallocated inodes that
+	 * aren't candidates for reclaim at all, so we must check the
+	 * XFS_IRECLAIMABLE is set first before proceeding to reclaim.
+	 * Obviously if XFS_NEED_INACTIVE isn't set then we ignore this inode.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!(ip->i_flags & XFS_NEED_INACTIVE) ||
+	    (ip->i_flags & XFS_INACTIVATING)) {
+		/* not a inactivation candidate. */
+		spin_unlock(&ip->i_flags_lock);
+		return false;
+	}
+
+	ip->i_flags |= XFS_INACTIVATING;
+	spin_unlock(&ip->i_flags_lock);
+	return true;
+}
+
+/* Inactivate this inode. */
+STATIC int
+xfs_inactive_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	void			*args)
+{
+	struct xfs_eofblocks	*eofb = args;
+
+	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);
+
+	/*
+	 * Not a match for our passed in scan filter?  Put it back on the shelf
+	 * and move on.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!xfs_inode_matches_eofb(ip, eofb)) {
+		ip->i_flags &= ~XFS_INACTIVATING;
+		spin_unlock(&ip->i_flags_lock);
+		return 0;
+	}
+	spin_unlock(&ip->i_flags_lock);
+
+	trace_xfs_inode_inactivating(ip);
+
+	/* Update metadata prior to freeing inode. */
+	xfs_inode_inactivation_cleanup(ip);
+	xfs_inactive(ip);
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+
+	/*
+	 * Clear the inactive state flags and schedule a reclaim run once
+	 * we're done with the inactivations.  We must ensure that the inode
+	 * smoothly transitions from inactivating to reclaimable so that iget
+	 * cannot see either data structure midway through the transition.
+	 */
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
+	xfs_inode_clear_inactive_tag(pag, ip->i_ino);
+
+	__xfs_inode_set_reclaim_tag(pag, ip);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+
+	return 0;
+}
+
+static const struct xfs_ici_walk_ops	xfs_inactive_iwalk_ops = {
+	.igrab		= xfs_inactive_grab,
+	.iwalk		= xfs_inactive_inode,
+};
+
+/*
+ * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
+ * corrupted, we still need to clear the INACTIVE iflag so that we can move
+ * on to reclaiming the inode.
+ */
+int
+xfs_inactive_inodes(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	return xfs_ici_walk_fns(mp, &xfs_inactive_iwalk_ops, 0, eofb,
+			XFS_ICI_INACTIVE_TAG);
+}
+
+/* Try to get inode inactivation moving. */
+void
+xfs_inactive_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_inactive_work);
+	int			error;
+
+	/*
+	 * We want to skip inode inactivation while the filesystem is frozen
+	 * because we don't want the inactivation thread to block while taking
+	 * sb_intwrite.  Therefore, we try to take sb_write for the duration
+	 * of the inactive scan -- a freeze attempt will block until we're
+	 * done here, and if the fs is past stage 1 freeze we'll bounce out
+	 * until things unfreeze.  If the fs goes down while frozen we'll
+	 * still have log recovery to clean up after us.
+	 */
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
+
+	error = xfs_inactive_inodes(mp, NULL);
+	if (error && error != -EAGAIN)
+		xfs_err(mp, "inode inactivation failed, error %d", error);
+
+	sb_end_write(mp->m_super);
+	xfs_inactive_work_queue(mp);
+}
+
+/* Flush all inode inactivation work that might be queued. */
+void
+xfs_inactive_force(
+	struct xfs_mount	*mp)
+{
+	queue_delayed_work(mp->m_inactive_workqueue, &mp->m_inactive_work, 0);
+	flush_delayed_work(&mp->m_inactive_work);
+}
+
+/*
+ * Flush all inode inactivation work that might be queued, make sure the
+ * delayed work item is not queued, and then make sure there aren't any more
+ * inodes waiting to be inactivated.
+ */
+void
+xfs_inactive_shutdown(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_inactive_work);
+	flush_workqueue(mp->m_inactive_workqueue);
+	xfs_inactive_inodes(mp, NULL);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 3c34c0e2e266..d6e79e7b5d94 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -28,6 +28,8 @@ struct xfs_eofblocks {
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCK_GC_TAG	1
+/* Inode can be inactivated. */
+#define XFS_ICI_INACTIVE_TAG	2
 
 /*
  * Flags for xfs_iget()
@@ -56,6 +58,7 @@ int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
+void xfs_inode_set_inactive_tag(struct xfs_inode *ip);
 
 bool xfs_inode_free_quota_blocks(struct xfs_inode *ip, bool sync);
 int xfs_inode_free_blocks(struct xfs_mount *mp, bool sync);
@@ -79,4 +82,9 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
+void xfs_inactive_worker(struct work_struct *work);
+int xfs_inactive_inodes(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
+void xfs_inactive_force(struct xfs_mount *mp);
+void xfs_inactive_shutdown(struct xfs_mount *mp);
+
 #endif
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aa019e49e512..2977086e7374 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1864,6 +1864,68 @@ xfs_inode_iadjust(
 	xfs_qm_iadjust(ip, direction, inodes, dblocks, rblocks);
 }
 
+/* Clean up inode inactivation. */
+void
+xfs_inode_inactivation_cleanup(
+	struct xfs_inode	*ip)
+{
+	int			ret;
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return;
+
+	/*
+	 * Undo the pending-inactivation counter updates since we're bringing
+	 * this inode back to life.
+	 */
+	ret = xfs_qm_dqattach(ip);
+	if (ret)
+		xfs_err(ip->i_mount, "error %d reactivating inode quota", ret);
+
+	xfs_inode_iadjust(ip, -1);
+}
+
+/* Prepare inode for inactivation. */
+void
+xfs_inode_inactivation_prep(
+	struct xfs_inode	*ip)
+{
+	int			ret;
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return;
+
+	/*
+	 * If this inode is unlinked (and now unreferenced) we need to dispose
+	 * of it in the on disk metadata.
+	 *
+	 * Bump generation so that the inode can't be opened by handle now that
+	 * the last external references has dropped.  Bulkstat won't return
+	 * inodes with zero nlink so nobody will ever find this inode again.
+	 * Then add this inode & blocks to the counts of things that will be
+	 * freed during the next inactivation run.
+	 */
+	if (VFS_I(ip)->i_nlink == 0)
+		VFS_I(ip)->i_generation++;
+
+	/*
+	 * Increase the pending-inactivation counters so that the fs looks like
+	 * it's free.
+	 */
+	ret = xfs_qm_dqattach(ip);
+	if (ret)
+		xfs_err(ip->i_mount, "error %d inactivating inode quota", ret);
+
+	xfs_inode_iadjust(ip, 1);
+
+	/*
+	 * Detach dquots just in case someone tries a quotaoff while
+	 * the inode is waiting on the inactive list.  We'll reattach
+	 * them (if needed) when inactivating the inode.
+	 */
+	xfs_qm_dqdetach(ip);
+}
+
 /*
  * Returns true if we need to update the on-disk metadata before we can free
  * the memory used by this inode.  Updates include freeing post-eof
@@ -1955,6 +2017,16 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return;
 
+	/*
+	 * Re-attach dquots prior to freeing EOF blocks or CoW staging extents.
+	 * We dropped the dquot prior to inactivation (because quotaoff can't
+	 * resurrect inactive inodes to force-drop the dquot) so we /must/
+	 * do this before touching any block mappings.
+	 */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return;
+
 	/* Try to clean out the cow blocks if there are any. */
 	if (xfs_inode_has_cow_data(ip))
 		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
@@ -1980,10 +2052,6 @@ xfs_inactive(
 	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		return;
-
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0a46548e51a8..4a3e472d7078 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -212,6 +212,7 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
 #define __XFS_INEW_BIT		3	 /* inode has just been allocated */
 #define XFS_INEW		(1 << __XFS_INEW_BIT)
+#define XFS_NEED_INACTIVE	(1 << 4) /* see XFS_INACTIVATING below */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
 #define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
@@ -228,6 +229,15 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 #define XFS_IRECOVERY		(1 << 11)
 #define XFS_ICOWBLOCKS		(1 << 12)/* has the cowblocks tag set */
 
+/*
+ * If we need to update on-disk metadata before this IRECLAIMABLE inode can be
+ * freed, then NEED_INACTIVE will be set.  Once we start the updates, the
+ * INACTIVATING bit will be set to keep iget away from this inode.  After the
+ * inactivation completes, both flags will be cleared and the inode is a
+ * plain old IRECLAIMABLE inode.
+ */
+#define XFS_INACTIVATING	(1 << 13)
+
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
  * inode lookup. This prevents unintended behaviour on the new inode from
@@ -235,7 +245,8 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
+	 XFS_INACTIVATING)
 
 /*
  * Synchronize processes attempting to flush the in-core inode back to disk.
@@ -499,6 +510,8 @@ extern struct kmem_zone	*xfs_inode_zone;
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
 int xfs_has_eofblocks(struct xfs_inode *ip, bool *has);
 bool xfs_inode_needs_inactivation(struct xfs_inode *ip);
+void xfs_inode_inactivation_prep(struct xfs_inode *ip);
+void xfs_inode_inactivation_cleanup(struct xfs_inode *ip);
 
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e45bee3c8faf..b398f197d748 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -475,6 +475,7 @@ xfs_iomap_prealloc_size(
 				       alloc_blocks);
 
 	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
+	freesp += percpu_counter_read_positive(&mp->m_dinactive);
 	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
 		shift = 2;
 		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 99ec3fba4548..730a36675b55 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5102,6 +5102,13 @@ xlog_recover_process_iunlinks(
 		}
 		xfs_buf_rele(agibp);
 	}
+
+	/*
+	 * Now that we've put all the iunlink inodes on the lru, let's make
+	 * sure that we perform all the on-disk metadata updates to actually
+	 * free those inodes.
+	 */
+	xfs_inactive_force(mp);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ea74bd3be0bf..27729a8c8c12 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1009,7 +1009,8 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Shut down all pending inode inactivation work, which will also
+	 * cancel all delayed reclaim work and reclaim the inodes directly.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1019,8 +1020,7 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	xfs_inactive_shutdown(mp);
 	xfs_health_unmount(mp);
  out_log_dealloc:
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
@@ -1058,6 +1058,13 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes.
+	 * Since this can involve finobt updates, do it now before we lose the
+	 * per-AG space reservations.
+	 */
+	xfs_inactive_force(mp);
+
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
@@ -1108,6 +1115,13 @@ xfs_unmountfs(
 
 	xfs_qm_unmount(mp);
 
+	/*
+	 * Kick off inode inactivation again to push the metadata inodes into
+	 * reclamation, then flush out all the work because we're going away
+	 * soon.
+	 */
+	xfs_inactive_shutdown(mp);
+
 	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d203c922dc51..51f88b56bbbe 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -162,6 +162,7 @@ typedef struct xfs_mount {
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct delayed_work	m_inactive_work; /* background inode inactive */
 	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
@@ -176,6 +177,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct *m_blockgc_workqueue;
+	struct workqueue_struct	*m_inactive_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 
 	/*
@@ -343,7 +345,8 @@ typedef struct xfs_perag {
 
 	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
-	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned int	pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned int	pag_ici_inactive;	/* inactive inodes */
 	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index fa0db72f8d0d..43ba4e6b5e22 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -105,6 +105,12 @@ xfs_qm_scall_quotaoff(
 	uint			inactivate_flags;
 	struct xfs_qoff_logitem	*qoffstart;
 
+	/*
+	 * Clean up the inactive list before we turn quota off, to reduce the
+	 * amount of quotaoff work we have to do with the mutex held.
+	 */
+	xfs_inactive_force(mp);
+
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
 	 * Note that quota utilities (like quotaoff) _expect_
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ed10ba2cd087..14c5d002c358 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -520,8 +520,15 @@ xfs_init_mount_workqueues(
 	if (!mp->m_sync_workqueue)
 		goto out_destroy_eofb;
 
+	mp->m_inactive_workqueue = alloc_workqueue("xfs-inactive/%s",
+			WQ_MEM_RECLAIM | WQ_FREEZABLE, 0, mp->m_super->s_id);
+	if (!mp->m_inactive_workqueue)
+		goto out_destroy_sync;
+
 	return 0;
 
+out_destroy_sync:
+	destroy_workqueue(mp->m_inactive_workqueue);
 out_destroy_eofb:
 	destroy_workqueue(mp->m_blockgc_workqueue);
 out_destroy_reclaim:
@@ -540,6 +547,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_inactive_workqueue);
 	destroy_workqueue(mp->m_sync_workqueue);
 	destroy_workqueue(mp->m_blockgc_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
@@ -627,28 +635,34 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			need_inactive;
 
 	trace_xfs_destroy_inode(ip);
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
-	XFS_STATS_INC(ip->i_mount, vn_rele);
-	XFS_STATS_INC(ip->i_mount, vn_remove);
-
-	xfs_inactive(ip);
-
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
+	XFS_STATS_INC(mp, vn_rele);
+	XFS_STATS_INC(mp, vn_remove);
+
+	need_inactive = xfs_inode_needs_inactivation(ip);
+	if (need_inactive) {
+		trace_xfs_inode_set_need_inactive(ip);
+		xfs_inode_inactivation_prep(ip);
+	} else if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
 		xfs_check_delalloc(ip, XFS_COW_FORK);
 		ASSERT(0);
 	}
-
-	XFS_STATS_INC(ip->i_mount, vn_reclaim);
+	XFS_STATS_INC(mp, vn_reclaim);
+	trace_xfs_inode_set_reclaimable(ip);
 
 	/*
 	 * We should never get here with one of the reclaim flags already set.
 	 */
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_NEED_INACTIVE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_INACTIVATING));
 
 	/*
 	 * We always use background reclaim here because even if the
@@ -657,7 +671,10 @@ xfs_fs_destroy_inode(
 	 * this more efficiently than we can here, so simply let background
 	 * reclaim tear down all inodes.
 	 */
-	xfs_inode_set_reclaim_tag(ip);
+	if (need_inactive)
+		xfs_inode_set_inactive_tag(ip);
+	else
+		xfs_inode_set_reclaim_tag(ip);
 }
 
 static void
@@ -942,6 +959,18 @@ xfs_fs_unfreeze(
 	return 0;
 }
 
+/*
+ * Before we get to stage 1 of a freeze, force all the inactivation work so
+ * that there's less work to do if we crash during the freeze.
+ */
+STATIC int
+xfs_fs_freeze_super(
+	struct super_block	*sb)
+{
+	xfs_inactive_force(XFS_M(sb));
+	return freeze_super(sb);
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock _has_ now been read in.
@@ -1141,6 +1170,7 @@ static const struct super_operations xfs_super_operations = {
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.freeze_super		= xfs_fs_freeze_super,
 };
 
 static int
@@ -1699,6 +1729,13 @@ xfs_remount_ro(
 		return error;
 	}
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes.
+	 * Since this can involve finobt updates, do it now before we lose the
+	 * per-AG space reservations.
+	 */
+	xfs_inactive_force(mp);
+
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
@@ -1819,6 +1856,7 @@ static int xfs_init_fs_context(
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_inactive_work, xfs_inactive_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0064f4491d66..9233f51020af 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -133,6 +133,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_blockgc);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_blockgc);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_inactive);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inactive);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
@@ -593,14 +595,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
+		__field(unsigned long, iflags)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
+		__entry->iflags = ip->i_flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx",
+	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino)
+		  __entry->ino,
+		  __entry->iflags)
 )
 
 #define DEFINE_INODE_EVENT(name) \
@@ -610,6 +615,8 @@ DEFINE_EVENT(xfs_inode_class, name, \
 DEFINE_INODE_EVENT(xfs_iget_skip);
 DEFINE_INODE_EVENT(xfs_iget_reclaim);
 DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
+DEFINE_INODE_EVENT(xfs_iget_inactive);
+DEFINE_INODE_EVENT(xfs_iget_inactive_fail);
 DEFINE_INODE_EVENT(xfs_iget_hit);
 DEFINE_INODE_EVENT(xfs_iget_miss);
 
@@ -644,6 +651,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
+DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
+DEFINE_INODE_EVENT(xfs_inode_reclaiming);
+DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
+DEFINE_INODE_EVENT(xfs_inode_inactivating);
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the

