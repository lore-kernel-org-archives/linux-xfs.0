Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753805AbeBVPEY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 10:04:24 -0500
Received: from [107.17.164.176] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eosQ3-0005R7-Mt
        for linux-xfs@vger.kernel.org; Thu, 22 Feb 2018 15:04:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] xfs: rewrite the fdatasync optimization
Date: Thu, 22 Feb 2018 07:04:21 -0800
Message-Id: <20180222150421.18138-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Currently we need to the ilock over the log force in xfs_fsync so that we
can protect ili_fsync_fields against incorrect manipulation.
Unfortunately that can cause huge latency spikes for workloads that mix
fsync with writes from other thread or through aio on the same file.

Instead record the last dirty lsn that was not just a timestamp update in
the inode log item as long as the inode is pinned, and clear it when
unpinning the inode.  This removes the need for ili_fsync_fields and thus
holding the ilock over the log force, and drastically reduces latency on
multithreaded workloads that mix writes with fsync calls on the same file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since V1:
 - reomve the XFS_ILOG_VERSION optimization

 fs/xfs/xfs_file.c        | 20 ++++++--------------
 fs/xfs/xfs_inode.c       |  2 --
 fs/xfs/xfs_inode_item.c  | 10 ++++++++--
 fs/xfs/xfs_inode_item.h  |  2 +-
 fs/xfs/xfs_iomap.c       |  3 +--
 fs/xfs/xfs_trans_inode.c |  9 ---------
 6 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9ea08326f876..ccb331f96a6d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -165,27 +165,19 @@ xfs_file_fsync(
 	 * All metadata updates are logged, which means that we just have to
 	 * flush the log up to the latest LSN that touched the inode. If we have
 	 * concurrent fsync/fdatasync() calls, we need them to all block on the
-	 * log force before we clear the ili_fsync_fields field. This ensures
-	 * that we don't get a racing sync operation that does not wait for the
-	 * metadata to hit the journal before returning. If we race with
-	 * clearing the ili_fsync_fields, then all that will happen is the log
-	 * force will do nothing as the lsn will already be on disk. We can't
-	 * race with setting ili_fsync_fields because that is done under
-	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
-	 * until after the ili_fsync_fields is cleared.
+	 * log force before returning.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_ipincount(ip)) {
-		if (!datasync ||
-		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		if (datasync)
+			lsn = ip->i_itemp->ili_datasync_lsn;
+		else
 			lsn = ip->i_itemp->ili_last_lsn;
 	}
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	if (lsn) {
+	if (lsn)
 		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
-		ip->i_itemp->ili_fsync_fields = 0;
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	/*
 	 * If we only have a single device, and the log force about was
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 604ee384a00a..a57772553a2a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2385,7 +2385,6 @@ xfs_ifree_cluster(
 
 			iip->ili_last_fields = iip->ili_fields;
 			iip->ili_fields = 0;
-			iip->ili_fsync_fields = 0;
 			iip->ili_logged = 1;
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
@@ -3649,7 +3648,6 @@ xfs_iflush_int(
 	 */
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	iip->ili_logged = 1;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d5037f060d6f..b60592e82833 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -630,6 +630,9 @@ xfs_inode_item_committed(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 
+	iip->ili_last_lsn = 0;
+	iip->ili_datasync_lsn = 0;
+
 	if (xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_inode_item_unpin(lip, 0);
 		return -1;
@@ -646,7 +649,11 @@ xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
-	INODE_ITEM(lip)->ili_last_lsn = lsn;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+
+	iip->ili_last_lsn = lsn;
+	if (iip->ili_fields & ~XFS_ILOG_TIMESTAMP)
+		iip->ili_datasync_lsn = lsn;
 }
 
 /*
@@ -826,7 +833,6 @@ xfs_iflush_abort(
 		 * attempted.
 		 */
 		iip->ili_fields = 0;
-		iip->ili_fsync_fields = 0;
 	}
 	/*
 	 * Release the inode's flush lock since we're done with it.
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index b72373a33cd9..9377ff41322f 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -30,11 +30,11 @@ typedef struct xfs_inode_log_item {
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
+	xfs_lsn_t		ili_datasync_lsn;
 	unsigned short		ili_lock_flags;	   /* lock flags */
 	unsigned short		ili_logged;	   /* flushed logged data */
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
-	unsigned int		ili_fsync_fields;  /* logged since last fsync */
 } xfs_inode_log_item_t;
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 66e1edbfb2b2..221d218f08a9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1090,8 +1090,7 @@ xfs_file_iomap_begin(
 		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
 	}
 
-	if (xfs_ipincount(ip) && (ip->i_itemp->ili_fsync_fields
-				& ~XFS_ILOG_TIMESTAMP))
+	if (xfs_ipincount(ip) && ip->i_itemp->ili_datasync_lsn)
 		iomap->flags |= IOMAP_F_DIRTY;
 
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 4a89da4b6fe7..fddacf9575df 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -101,15 +101,6 @@ xfs_trans_log_inode(
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
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
-- 
2.14.2

