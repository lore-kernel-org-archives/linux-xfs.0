Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3ECC433FB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE439206E2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgFAVnH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:43:07 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40000 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728777AbgFAVnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:43:02 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id E45EE5AAD65
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCp-0000WD-Ti
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:51 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCp-00HU4s-KK
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/30] xfs: add an inode item lock
Date:   Tue,  2 Jun 2020 07:42:24 +1000
Message-Id: <20200601214251.4167140-4-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=JeUEpQy9zLAlQ1B7pzYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The inode log item is kind of special in that it can be aggregating
new changes in memory at the same time time existing changes are
being written back to disk. This means there are fields in the log
item that are accessed concurrently from contexts that don't share
any locking at all.

e.g. updating ili_last_fields occurs at flush time under the
ILOCK_EXCL and flush lock at flush time, under the flush lock at IO
completion time, and is read under the ILOCK_EXCL when the inode is
logged.  Hence there is no actual serialisation between reading the
field during logging of the inode in transactions vs clearing the
field in IO completion.

We currently get away with this by the fact that we are only
clearing fields in IO completion, and nothing bad happens if we
accidentally log more of the inode than we actually modify. Worst
case is we consume a tiny bit more memory and log bandwidth.

However, if we want to do more complex state manipulations on the
log item that requires updates at all three of these potential
locations, we need to have some mechanism of serialising those
operations. To do this, introduce a spinlock into the log item to
serialise internal state.

This could be done via the xfs_inode i_flags_lock, but this then
leads to potential lock inversion issues where inode flag updates
need to occur inside locks that best nest inside the inode log item
locks (e.g. marking inodes stale during inode cluster freeing).
Using a separate spinlock avoids these sorts of problems and
simplifies future code.

This does not touch the use of ili_fields in the item formatting
code - that is entirely protected by the ILOCK_EXCL at this point in
time, so it remains untouched.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_inode.c | 54 +++++++++++++++++----------------
 fs/xfs/xfs_file.c               |  9 ++++--
 fs/xfs/xfs_inode.c              | 20 +++++++-----
 fs/xfs/xfs_inode_item.c         |  7 +++++
 fs/xfs/xfs_inode_item.h         | 18 +++++++++--
 5 files changed, 68 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 4504d215cd590..fe6c2e39be85d 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -82,16 +82,20 @@ xfs_trans_ichgtime(
  */
 void
 xfs_trans_log_inode(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	uint		flags)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	uint			flags)
 {
-	struct inode	*inode = VFS_I(ip);
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct inode		*inode = VFS_I(ip);
+	uint			iversion_flags = 0;
 
-	ASSERT(ip->i_itemp != NULL);
+	ASSERT(iip);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
 
+	tp->t_flags |= XFS_TRANS_DIRTY;
+
 	/*
 	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
 	 * don't matter - we either will need an extra transaction in 24 hours
@@ -104,15 +108,6 @@ xfs_trans_log_inode(
 		spin_unlock(&inode->i_lock);
 	}
 
-	/*
-	 * Record the specific change for fdatasync optimisation. This
-	 * allows fdatasync to skip log forces for inodes that are only
-	 * timestamp dirty. We do this before the change count so that
-	 * the core being logged in this case does not impact on fdatasync
-	 * behaviour.
-	 */
-	ip->i_itemp->ili_fsync_fields |= flags;
-
 	/*
 	 * First time we log the inode in a transaction, bump the inode change
 	 * counter if it is configured for this to occur. While we have the
@@ -122,23 +117,30 @@ xfs_trans_log_inode(
 	 * set however, then go ahead and bump the i_version counter
 	 * unconditionally.
 	 */
-	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
-	    IS_I_VERSION(VFS_I(ip))) {
-		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
-			flags |= XFS_ILOG_CORE;
+	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
+		if (IS_I_VERSION(inode) &&
+		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
+			iversion_flags = XFS_ILOG_CORE;
 	}
 
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	/*
+	 * Record the specific change for fdatasync optimisation. This allows
+	 * fdatasync to skip log forces for inodes that are only timestamp
+	 * dirty. We do this before the change count so that the core being
+	 * logged in this case does not impact on fdatasync behaviour.
+	 */
+	spin_lock(&iip->ili_lock);
+	iip->ili_fsync_fields |= flags;
 
 	/*
-	 * Always OR in the bits from the ili_last_fields field.
-	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
-	 * routines in the eventual clearing of the ili_fields bits.
-	 * See the big comment in xfs_iflush() for an explanation of
-	 * this coordination mechanism.
+	 * Always OR in the bits from the ili_last_fields field.  This is to
+	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
+	 * the eventual clearing of the ili_fields bits.  See the big comment in
+	 * xfs_iflush() for an explanation of this coordination mechanism.
 	 */
-	flags |= ip->i_itemp->ili_last_fields;
-	ip->i_itemp->ili_fields |= flags;
+	iip->ili_fields |= (flags | iip->ili_last_fields |
+			    iversion_flags);
+	spin_unlock(&iip->ili_lock);
 }
 
 int
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 403c90309a8ff..0abf770b77498 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -94,6 +94,7 @@ xfs_file_fsync(
 {
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = 0;
 	int			log_flushed = 0;
@@ -137,13 +138,15 @@ xfs_file_fsync(
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_ipincount(ip)) {
 		if (!datasync ||
-		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
-			lsn = ip->i_itemp->ili_last_lsn;
+		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+			lsn = iip->ili_last_lsn;
 	}
 
 	if (lsn) {
 		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
-		ip->i_itemp->ili_fsync_fields = 0;
+		spin_lock(&iip->ili_lock);
+		iip->ili_fsync_fields = 0;
+		spin_unlock(&iip->ili_lock);
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4fa12775ac146..ac3c8af8c9a14 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2702,9 +2702,11 @@ xfs_ifree_cluster(
 				continue;
 
 			iip = ip->i_itemp;
+			spin_lock(&iip->ili_lock);
 			iip->ili_last_fields = iip->ili_fields;
 			iip->ili_fields = 0;
 			iip->ili_fsync_fields = 0;
+			spin_unlock(&iip->ili_lock);
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
 
@@ -2740,6 +2742,7 @@ xfs_ifree(
 {
 	int			error;
 	struct xfs_icluster	xic = { 0 };
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(VFS_I(ip)->i_nlink == 0);
@@ -2777,7 +2780,9 @@ xfs_ifree(
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 
 	/* Don't attempt to replay owner changes for a deleted inode */
-	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
+	spin_lock(&iip->ili_lock);
+	iip->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
+	spin_unlock(&iip->ili_lock);
 
 	/*
 	 * Bump the generation count so no one will be confused
@@ -3833,20 +3838,19 @@ xfs_iflush_int(
 	 * know that the information those bits represent is permanently on
 	 * disk.  As long as the flush completes before the inode is logged
 	 * again, then both ili_fields and ili_last_fields will be cleared.
-	 *
-	 * We can play with the ili_fields bits here, because the inode lock
-	 * must be held exclusively in order to set bits there and the flush
-	 * lock protects the ili_last_fields bits.  Store the current LSN of the
-	 * inode so that we can tell whether the item has moved in the AIL from
-	 * xfs_iflush_done().  In order to read the lsn we need the AIL lock,
-	 * because it is a 64 bit value that cannot be read atomically.
 	 */
 	error = 0;
 flush_out:
+	spin_lock(&iip->ili_lock);
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
 	iip->ili_fsync_fields = 0;
+	spin_unlock(&iip->ili_lock);
 
+	/*
+	 * Store the current LSN of the inode so that we can tell whether the
+	 * item has moved in the AIL from xfs_iflush_done().
+	 */
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 				&iip->ili_item.li_lsn);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b17384aa8df40..6ef9cbcfc94a7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -637,6 +637,7 @@ xfs_inode_item_init(
 	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, 0);
 
 	iip->ili_inode = ip;
+	spin_lock_init(&iip->ili_lock);
 	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE,
 						&xfs_inode_item_ops);
 }
@@ -738,7 +739,11 @@ xfs_iflush_done(
 	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
 		list_del_init(&blip->li_bio_list);
 		iip = INODE_ITEM(blip);
+
+		spin_lock(&iip->ili_lock);
 		iip->ili_last_fields = 0;
+		spin_unlock(&iip->ili_lock);
+
 		xfs_ifunlock(iip->ili_inode);
 	}
 	list_del(&tmp);
@@ -762,9 +767,11 @@ xfs_iflush_abort(
 		 * Clear the inode logging fields so no more flushes are
 		 * attempted.
 		 */
+		spin_lock(&iip->ili_lock);
 		iip->ili_last_fields = 0;
 		iip->ili_fields = 0;
 		iip->ili_fsync_fields = 0;
+		spin_unlock(&iip->ili_lock);
 	}
 	/*
 	 * Release the inode's flush lock since we're done with it.
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 4de5070e07655..44c47c08b0b59 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -16,12 +16,24 @@ struct xfs_mount;
 struct xfs_inode_log_item {
 	struct xfs_log_item	ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
-	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
-	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
-	unsigned short		ili_lock_flags;	   /* lock flags */
+	unsigned short		ili_lock_flags;	   /* inode lock flags */
+	/*
+	 * The ili_lock protects the interactions between the dirty state and
+	 * the flush state of the inode log item. This allows us to do atomic
+	 * modifications of multiple state fields without having to hold a
+	 * specific inode lock to serialise them.
+	 *
+	 * We need atomic changes between indoe dirtying, inode flushing and
+	 * inode completion, but these all hold different combinations of
+	 * ILOCK and iflock and hence we need some other method of serialising
+	 * updates to the flush state.
+	 */
+	spinlock_t		ili_lock;	   /* flush state lock */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
+	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
+	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
 };
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
-- 
2.26.2.761.g0e0b3e54be

