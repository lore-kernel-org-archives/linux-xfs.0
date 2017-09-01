Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32289 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbdIARN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 13:13:58 -0400
Date: Fri, 1 Sep 2017 10:13:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3] xfs: fix compiler warnings
Message-ID: <20170901171327.GG3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

Fix up all the compiler warnings that have crept in.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix everything that comes up with a W=1 build
v2: get more aggressive with the refactoring variables out
---
 fs/xfs/libxfs/xfs_bmap.c       |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |    9 +++------
 fs/xfs/xfs_buf_item.c          |    2 ++
 fs/xfs/xfs_iops.c              |    2 +-
 fs/xfs/xfs_log_recover.c       |    4 ++++
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9558f5e..459f4b4f0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -579,7 +579,7 @@ xfs_bmap_validate_ret(
 
 #else
 #define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
-#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
+#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	do { } while (0)
 #endif /* DEBUG */
 
 /*
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
index ef2c137..e0a0af0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -570,7 +570,9 @@ xfs_buf_item_unlock(
 	bool			aborted = !!(lip->li_flags & XFS_LI_ABORTED);
 	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
 	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
+#if defined(DEBUG) || defined(XFS_WARN)
 	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
+#endif
 
 	/* Clear the buffer's association with this transaction. */
 	bp->b_transp = NULL;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 469c9fa..17081c7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -817,7 +817,7 @@ xfs_vn_setattr_nonsize(
  * Caution: The caller of this function is responsible for calling
  * setattr_prepare() or otherwise verifying the change is fine.
  */
-int
+STATIC int
 xfs_setattr_size(
 	struct xfs_inode	*ip,
 	struct iattr		*iattr)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a362399..ee34899 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4827,12 +4827,16 @@ xlog_recover_process_intents(
 	int			error = 0;
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp;
+#if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
+#endif
 
 	ailp = log->l_ailp;
 	spin_lock(&ailp->xa_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+#if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
+#endif
 	while (lip != NULL) {
 		/*
 		 * We're done when we see something other than an intent.
