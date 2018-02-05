Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50623 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbeBEHji (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 02:39:38 -0500
Received: from 178.114.220.110.wireless.dyn.drei.com ([178.114.220.110] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eibNJ-0004Ui-Qq
        for linux-xfs@vger.kernel.org; Mon, 05 Feb 2018 07:39:38 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: rewrite the fdatasync optimization
Date: Mon,  5 Feb 2018 08:39:33 +0100
Message-Id: <20180205073933.17065-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Currently we need to the ilock over the log force in xfs_fsync so that we
can protect ili_fsync_fields against incorrect manipulation.

But if instead we add new XFS_ILOG_VERSION pseudo log area similar to the
timestamp one we can use that to just record the last dirty / fdatasync
dirty lsn as long as the inode is pinned, and clear it when unpinning to
avoid holding the ilock over I/O.

This will drastically reduce latency on multithreaded workloads that
mix writes with fsync calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 11 +++++++++--
 fs/xfs/xfs_file.c              | 20 ++++++--------------
 fs/xfs/xfs_inode.c             |  2 --
 fs/xfs/xfs_inode_item.c        | 13 ++++++++++---
 fs/xfs/xfs_inode_item.h        |  2 +-
 fs/xfs/xfs_iomap.c             |  3 +--
 fs/xfs/xfs_trans_inode.c       | 11 +----------
 7 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 349d9f8edb89..0cb4875b29ec 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -327,6 +327,13 @@ struct xfs_inode_log_format_32 {
  */
 #define XFS_ILOG_TIMESTAMP	0x4000
 
+/*
+ * Similar for this one:  it means we increased the inode version, which
+ * when combined with just XFS_ILOG_TIMESTAMP does not require blocking
+ * in fdatasync.
+ */
+#define XFS_ILOG_VERSION	0x8000
+
 #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
 				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
@@ -343,8 +350,8 @@ struct xfs_inode_log_format_32 {
 				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
 				 XFS_ILOG_DEV | XFS_ILOG_ADATA | \
 				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT | \
-				 XFS_ILOG_TIMESTAMP | XFS_ILOG_DOWNER | \
-				 XFS_ILOG_AOWNER)
+				 XFS_ILOG_DOWNER | XFS_ILOG_AOWNER | \
+				 XFS_ILOG_TIMESTAMP | XFS_ILOG_VERSION)
 
 static inline int xfs_ilog_fbroot(int w)
 {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8601275cc5e6..eeb72f2b10c4 100644
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
index d5037f060d6f..3e33a4f421ed 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -442,7 +442,8 @@ xfs_inode_item_format(
 	}
 
 	/* update the format with the exact fields we actually logged */
-	ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
+	ilf->ilf_fields |=
+		(iip->ili_fields & ~(XFS_ILOG_TIMESTAMP | XFS_ILOG_VERSION));
 }
 
 /*
@@ -630,6 +631,9 @@ xfs_inode_item_committed(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 
+	iip->ili_last_lsn = 0;
+	iip->ili_datasync_lsn = 0;
+
 	if (xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_inode_item_unpin(lip, 0);
 		return -1;
@@ -646,7 +650,11 @@ xfs_inode_item_committing(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn)
 {
-	INODE_ITEM(lip)->ili_last_lsn = lsn;
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+
+	iip->ili_last_lsn = lsn;
+	if (iip->ili_fields & ~(XFS_ILOG_TIMESTAMP | XFS_ILOG_VERSION))
+		iip->ili_datasync_lsn = lsn;
 }
 
 /*
@@ -826,7 +834,6 @@ xfs_iflush_abort(
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
index 4a89da4b6fe7..0f9fbdea86ba 100644
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
@@ -122,7 +113,7 @@ xfs_trans_log_inode(
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
 		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
-			flags |= XFS_ILOG_CORE;
+			flags |= XFS_ILOG_VERSION;
 	}
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
-- 
2.14.2

