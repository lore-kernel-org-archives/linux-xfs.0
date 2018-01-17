Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53974 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeAQB2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 20:28:14 -0500
Date: Tue, 16 Jan 2018 17:18:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs: recheck reflink / dirty page status before freeing
 CoW reservations
Message-ID: <20180117011842.GB25805@magnolia>
References: <20180110220336.GU5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180110220336.GU5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eryu Guan <eguan@redhat.com>, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Eryu Guan reported seeing occasional hangs when running generic/269 with
a new fsstress that supports clonerange/deduperange.  The cause of this
hang is an infinite loop when we convert the CoW fork extents from
unwritten to real just prior to writing the pages out; the infinite
loop happens because there's nothing in the CoW fork to convert, and so
it spins forever.

The fundamental issue here is that when we go to perform these CoW fork
conversions, we're supposed to have an extent waiting for us, but the
low space CoW reaper has snuck in and blown them away!  There are four
conditions that can dissuade the reaper from touching our file -- no
reflink iflag; dirty page cache; writeback in progress; or directio in
progress.  We check the four conditions prior to taking the locks, but
we neglect to recheck them once we have the locks, which is how we end
up whacking the writeback that's in progress.

Therefore, refactor the four checks into a helper function and call it
once again once we have the locks to make sure we really want to reap
the inode.  While we're at it, add an ASSERT for this weird condition so
that we'll fail noisily if we ever screw this up again.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Tested-by: Eryu Guan <eguan@redhat.com>
---
v2: improve comments, minor refactors suggested by Brian Foster
---
 fs/xfs/libxfs/xfs_bmap.c |   10 +++++++
 fs/xfs/xfs_icache.c      |   63 +++++++++++++++++++++++++++++++---------------
 2 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a01cef4..3567db6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4311,8 +4311,16 @@ xfs_bmapi_write(
 	while (bno < end && n < *nmap) {
 		bool			need_alloc = false, wasdelay = false;
 
-		/* in hole or beyoned EOF? */
+		/* in hole or beyond EOF? */
 		if (eof || bma.got.br_startoff > bno) {
+			/*
+			 * CoW fork conversions should /never/ hit EOF or
+			 * holes.  There should always be something for us
+			 * to work on.
+			 */
+			ASSERT(!((flags & XFS_BMAPI_CONVERT) &&
+			         (flags & XFS_BMAPI_COWFORK)));
+
 			if (flags & XFS_BMAPI_DELALLOC) {
 				/*
 				 * For the COW fork we can reasonably get a
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1f84562..76df647 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1655,28 +1655,15 @@ xfs_inode_clear_eofblocks_tag(
 }
 
 /*
- * Automatic CoW Reservation Freeing
- *
- * These functions automatically garbage collect leftover CoW reservations
- * that were made on behalf of a cowextsize hint when we start to run out
- * of quota or when the reservations sit around for too long.  If the file
- * has dirty pages or is undergoing writeback, its CoW reservations will
- * be retained.
- *
- * The actual garbage collection piggybacks off the same code that runs
- * the speculative EOF preallocation garbage collector.
+ * Set ourselves up to free CoW blocks from this file.  If it's already clean
+ * then we can bail out quickly, but otherwise we must back off if the file
+ * is undergoing some kind of write.
  */
-STATIC int
-xfs_inode_free_cowblocks(
+static bool
+xfs_prep_free_cowblocks(
 	struct xfs_inode	*ip,
-	int			flags,
-	void			*args)
+	struct xfs_ifork	*ifp)
 {
-	int ret;
-	struct xfs_eofblocks *eofb = args;
-	int match;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-
 	/*
 	 * Just clear the tag if we have an empty cow fork or none at all. It's
 	 * possible the inode was fully unshared since it was originally tagged.
@@ -1684,7 +1671,7 @@ xfs_inode_free_cowblocks(
 	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
 		trace_xfs_inode_free_cowblocks_invalid(ip);
 		xfs_inode_clear_cowblocks_tag(ip);
-		return 0;
+		return false;
 	}
 
 	/*
@@ -1695,6 +1682,35 @@ xfs_inode_free_cowblocks(
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
 	    atomic_read(&VFS_I(ip)->i_dio_count))
+		return false;
+
+	return true;
+}
+
+/*
+ * Automatic CoW Reservation Freeing
+ *
+ * These functions automatically garbage collect leftover CoW reservations
+ * that were made on behalf of a cowextsize hint when we start to run out
+ * of quota or when the reservations sit around for too long.  If the file
+ * has dirty pages or is undergoing writeback, its CoW reservations will
+ * be retained.
+ *
+ * The actual garbage collection piggybacks off the same code that runs
+ * the speculative EOF preallocation garbage collector.
+ */
+STATIC int
+xfs_inode_free_cowblocks(
+	struct xfs_inode	*ip,
+	int			flags,
+	void			*args)
+{
+	struct xfs_eofblocks	*eofb = args;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	int			match;
+	int			ret = 0;
+
+	if (!xfs_prep_free_cowblocks(ip, ifp))
 		return 0;
 
 	if (eofb) {
@@ -1715,7 +1731,12 @@ xfs_inode_free_cowblocks(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 
-	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
+	/*
+	 * Check again, nobody else should be able to dirty blocks or change
+	 * the reflink iflag now that we have the first two locks held.
+	 */
+	if (xfs_prep_free_cowblocks(ip, ifp))
+		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 
 	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
