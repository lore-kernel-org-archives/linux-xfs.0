Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26536 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdHaW25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 18:28:57 -0400
Date: Thu, 31 Aug 2017 15:28:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix compiler warnings
Message-ID: <20170831222824.GQ3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

Fix up all the compiler warnings about unused variables that have crept in.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |    9 +++------
 fs/xfs/xfs_buf_item.c          |    4 ++++
 fs/xfs/xfs_log_recover.c       |    4 ++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index fb310d0..31840ca 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -1499,14 +1499,11 @@ xfs_iext_realloc_indirect(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
 	int		new_size)	/* new indirection array size */
 {
-	int		nlists;		/* number of irec's (ex lists) */
-	int		size;		/* current indirection array size */
-
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
-	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-	size = nlists * sizeof(xfs_ext_irec_t);
 	ASSERT(ifp->if_real_bytes);
-	ASSERT((new_size >= 0) && (new_size != size));
+	ASSERT((new_size >= 0) &&
+	       (new_size != ((ifp->if_real_bytes / XFS_IEXT_BUFSZ) *
+			     sizeof(xfs_ext_irec_t))));
 	if (new_size == 0) {
 		xfs_iext_destroy(ifp);
 	} else {
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f5d25f5..806b17e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -570,12 +570,16 @@ xfs_buf_item_unlock(
 	bool			aborted;
 	bool			hold;
 	bool			dirty;
+#ifdef DEBUG
 	bool			ordered;
+#endif
 
 	aborted = !!(lip->li_flags & XFS_LI_ABORTED);
 	hold = !!(bip->bli_flags & XFS_BLI_HOLD);
 	dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
+#ifdef DEBUG
 	ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
+#endif
 
 	/* Clear the buffer's association with this transaction. */
 	bp->b_transp = NULL;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a362399..04a131c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4827,12 +4827,16 @@ xlog_recover_process_intents(
 	int			error = 0;
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp;
+#ifdef DEBUG
 	xfs_lsn_t		last_lsn;
+#endif
 
 	ailp = log->l_ailp;
 	spin_lock(&ailp->xa_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+#ifdef DEBUG
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
+#endif
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an intent.
