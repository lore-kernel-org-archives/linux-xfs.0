Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56374 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbfEUDrN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:13 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 7/7] libxfs: share kernel's xfs_trans_inode.c
Date: Mon, 20 May 2019 22:47:07 -0500
Message-Id: <1558410427-1837-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that the majority of cosmetic changes and compat shims
are in place, we can directly share kernelspace's
xfs_trans_inode.c with just a couple more small tweaks.
In addition to the file move,

* ili_fsync_fields is added to xfs_inode_log_item (but not used)
* test_and_set_bit() helper is created

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 include/xfs_trans.h  |  3 ++-
 libxfs/Makefile      |  1 +
 libxfs/libxfs_priv.h |  9 ++++++++
 libxfs/trans.c       | 65 ----------------------------------------------------
 libxfs/util.c        | 27 ----------------------
 5 files changed, 12 insertions(+), 93 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 118fa0b..60e1dbd 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -30,8 +30,9 @@ typedef struct xfs_inode_log_item {
 	xfs_log_item_t		ili_item;		/* common portion */
 	struct xfs_inode	*ili_inode;		/* inode pointer */
 	unsigned short		ili_lock_flags;		/* lock flags */
-	unsigned int		ili_fields;		/* fields to be logged */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
+	unsigned int		ili_fields;		/* fields to be logged */
+	unsigned int		ili_fsync_fields;	/* ignored by userspace */
 } xfs_inode_log_item_t;
 
 typedef struct xfs_buf_log_item {
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 160498d..8c681e0 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -93,6 +93,7 @@ CFILES = cache.c \
 	xfs_rtbitmap.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
+	xfs_trans_inode.c \
 	xfs_trans_resv.c \
 	xfs_types.c
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a8c0f0b..c75b92d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -608,6 +608,15 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
 	return *p & mask;
 }
 
+/* Sets and returns original value of the bit */
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+{
+	if (test_bit(nr, addr))
+		return 1;
+	set_bit(nr, addr);
+	return 0;
+}
+
 /* Keep static checkers quiet about nonstatic functions by exporting */
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index c7a1d52..5c56b4f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -331,25 +331,6 @@ libxfs_trans_cancel(
 }
 
 void
-libxfs_trans_ijoin(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	xfs_inode_log_item_t	*iip;
-
-	if (ip->i_itemp == NULL)
-		xfs_inode_item_init(ip, ip->i_mount);
-	iip = ip->i_itemp;
-	ASSERT(iip->ili_inode != NULL);
-
-	ASSERT(iip->ili_lock_flags == 0);
-	iip->ili_lock_flags = lock_flags;
-
-	xfs_trans_add_item(tp, &iip->ili_item);
-}
-
-void
 libxfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
@@ -363,52 +344,6 @@ libxfs_trans_inode_alloc_buf(
 }
 
 /*
- * This is called to mark the fields indicated in fieldmask as needing
- * to be logged when the transaction is committed.  The inode must
- * already be associated with the given transaction.
- *
- * The values for fieldmask are defined in xfs_log_format.h.  We always
- * log all of the core inode if any of it has changed, and we always log
- * all of the inline data/extents/b-tree root if any of them has changed.
- */
-void
-xfs_trans_log_inode(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	uint			flags)
-{
-	ASSERT(ip->i_itemp != NULL);
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags);
-
-	/*
-	 * Always OR in the bits from the ili_last_fields field.
-	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
-	 * routines in the eventual clearing of the ilf_fields bits.
-	 * See the big comment in xfs_iflush() for an explanation of
-	 * this coordination mechanism.
-	 */
-	flags |= ip->i_itemp->ili_last_fields;
-	ip->i_itemp->ili_fields |= flags;
-}
-
-int
-libxfs_trans_roll_inode(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip)
-{
-	int			error;
-
-	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_roll(tpp);
-	if (!error)
-		xfs_trans_ijoin(*tpp, ip, 0);
-	return error;
-}
-
-
-/*
  * Mark a buffer dirty in the transaction.
  */
 void
diff --git a/libxfs/util.c b/libxfs/util.c
index 2ba9dc2..171a172 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -149,33 +149,6 @@ current_time(struct inode *inode)
 	return tv;
 }
 
-/*
- * Change the requested timestamp in the given inode.
- */
-void
-libxfs_trans_ichgtime(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	int			flags)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct timespec64	tv;
-
-	ASSERT(tp);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	tv = current_time(inode);
-
-	if (flags & XFS_ICHGTIME_MOD)
-		VFS_I(ip)->i_mtime = tv;
-	if (flags & XFS_ICHGTIME_CHG)
-		VFS_I(ip)->i_ctime = tv;
-	if (flags & XFS_ICHGTIME_CREATE) {
-		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
-	}
-}
-
 STATIC uint16_t
 xfs_flags2diflags(
 	struct xfs_inode	*ip,
-- 
1.8.3.1
