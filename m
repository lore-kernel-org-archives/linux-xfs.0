Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41315 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbeAYPL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 10:11:58 -0500
Date: Thu, 25 Jan 2018 07:11:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: aio/dio write vs. file_update_time
Message-ID: <20180125151157.GA2839@infradead.org>
References: <52c2b3db-26cb-df95-2a77-866d27ce146c@scylladb.com>
 <20180123163133.GD32478@bfoster.bfoster>
 <f87e6ece-e98c-e39f-378a-c9c78f48be30@scylladb.com>
 <1ec0f082-c6cf-0dc9-8f6f-5735292b2468@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ec0f082-c6cf-0dc9-8f6f-5735292b2468@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 07:52:13PM +0200, Avi Kivity wrote:
> Actually I was wrong, we fsync() in parallel with writes to the application
> level commit log (for our data files, fsync is mutually exclusive with
> writes). So it looks like fsync is incompatible with aio writes to the same
> file.

This patch from my work todo queue should fix it:

---
>From cb690da66b33e76fd4bf782ab568d42006c3aa31 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 7 Dec 2017 13:22:29 -0700
Subject: xfs: rewrite the fdatasync optimization

Currently we need to the ilock over the log force in xfs_fsync so that we
can protect ili_fsync_fields against incorrect manipulation.

But if instead we add new XFS_ILOG_VERSION pseudo log area similar to the
timestamp one we can use that to just record the last dirty / fdatasync
dirty lsn as long as the inode is pinned, and clear it when unpinning to
avoid holding the ilock over I/O.

This should reduce latency when under fsync heavy loads a bit, but most
importantly prepares for proper aio fsync support.

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
index eb5c2f645905..d4fa72e34c8d 100644
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
index 6f95bdb408ce..4f0aea431827 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2371,7 +2371,6 @@ xfs_ifree_cluster(
 
 			iip->ili_last_fields = iip->ili_fields;
 			iip->ili_fields = 0;
-			iip->ili_fsync_fields = 0;
 			iip->ili_logged = 1;
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
@@ -3606,7 +3605,6 @@ xfs_iflush_int(
 	 */
 	iip->ili_last_fields = iip->ili_fields;
 	iip->ili_fields = 0;
-	iip->ili_fsync_fields = 0;
 	iip->ili_logged = 1;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1545bbcf9ca2..ae1325a5e971 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -441,7 +441,8 @@ xfs_inode_item_format(
 	}
 
 	/* update the format with the exact fields we actually logged */
-	ilf->ilf_fields |= (iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
+	ilf->ilf_fields |=
+		(iip->ili_fields & ~(XFS_ILOG_TIMESTAMP | XFS_ILOG_VERSION));
 }
 
 /*
@@ -626,6 +627,9 @@ xfs_inode_item_committed(
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 
+	iip->ili_last_lsn = 0;
+	iip->ili_datasync_lsn = 0;
+
 	if (xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_inode_item_unpin(lip, 0);
 		return -1;
@@ -638,7 +642,11 @@ xfs_inode_item_committing(
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
@@ -835,7 +843,6 @@ xfs_iflush_abort(
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
index 7ab52a8bc0a9..8043a249b741 100644
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
index daa7615497f9..8d623599eb79 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -99,15 +99,6 @@ xfs_trans_log_inode(
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
 	 * counter if it is configured for this to occur. We don't use
@@ -118,7 +109,7 @@ xfs_trans_log_inode(
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
 		VFS_I(ip)->i_version++;
-		flags |= XFS_ILOG_CORE;
+		flags |= XFS_ILOG_VERSION;
 	}
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
-- 
2.14.2

