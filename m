Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbeAJWDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 17:03:55 -0500
Date: Wed, 10 Jan 2018 14:03:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: recheck reflink / dirty page status before freeing CoW
 reservations
Message-ID: <20180110220336.GU5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eryu Guan <eguan@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Eryu Guan reported seeing occasional hangs when running generic/269 with
a new fsstress that supports clonerange/deduperange.  The cause of this
hang is an infinite loop when we convert the CoW fork extents from
unwritten to real just prior to writing the pages out; the infinite
loop happens because there's nothing in the CoW fork to convert, and so
it spins forever.

The underlying issue here is that when we go to perform these CoW fork
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
---
 fs/xfs/libxfs/xfs_bmap.c |    7 +++++
 fs/xfs/xfs_icache.c      |   61 +++++++++++++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a01cef4..7bd933f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4311,6 +4311,13 @@ xfs_bmapi_write(
 	while (bno < end && n < *nmap) {
 		bool			need_alloc = false, wasdelay = false;
 
+		/*
+		 * CoW fork conversions should /never/ hit EOF.  There should
+		 * always be something for us to work on.
+		 */
+		ASSERT(!eof || !(flags & XFS_BMAPI_CONVERT) ||
+			       !(flags & XFS_BMAPI_COWFORK));
+
 		/* in hole or beyoned EOF? */
 		if (eof || bma.got.br_startoff > bno) {
 			if (flags & XFS_BMAPI_DELALLOC) {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1f84562..3fbcc03 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1654,6 +1654,35 @@ xfs_inode_clear_eofblocks_tag(
 			trace_xfs_perag_clear_eofblocks, XFS_ICI_EOFBLOCKS_TAG);
 }
 
+/* Is this a good time to reap the CoW reservations for this file? */
+static bool
+xfs_can_free_cowblocks(
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp)
+{
+	/*
+	 * Just clear the tag if we have an empty cow fork or none at all. It's
+	 * possible the inode was fully unshared since it was originally tagged.
+	 */
+	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
+		trace_xfs_inode_free_cowblocks_invalid(ip);
+		xfs_inode_clear_cowblocks_tag(ip);
+		return false;
+	}
+
+	/*
+	 * If the mapping is dirty or under writeback we cannot touch the
+	 * CoW fork.  Leave it alone if we're in the midst of a directio.
+	 */
+	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
+	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
+	    atomic_read(&VFS_I(ip)->i_dio_count))
+		return false;
+
+	return true;
+}
+
 /*
  * Automatic CoW Reservation Freeing
  *
@@ -1672,29 +1701,12 @@ xfs_inode_free_cowblocks(
 	int			flags,
 	void			*args)
 {
-	int ret;
-	struct xfs_eofblocks *eofb = args;
-	int match;
+	struct xfs_eofblocks	*eofb = args;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	int			match;
+	int			ret = 0;
 
-	/*
-	 * Just clear the tag if we have an empty cow fork or none at all. It's
-	 * possible the inode was fully unshared since it was originally tagged.
-	 */
-	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
-		trace_xfs_inode_free_cowblocks_invalid(ip);
-		xfs_inode_clear_cowblocks_tag(ip);
-		return 0;
-	}
-
-	/*
-	 * If the mapping is dirty or under writeback we cannot touch the
-	 * CoW fork.  Leave it alone if we're in the midst of a directio.
-	 */
-	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
-	    atomic_read(&VFS_I(ip)->i_dio_count))
+	if (!xfs_can_free_cowblocks(ip, ifp))
 		return 0;
 
 	if (eofb) {
@@ -1715,7 +1727,12 @@ xfs_inode_free_cowblocks(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 
-	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
+	/*
+	 * Check again, nobody else should be able to dirty blocks or change
+	 * the reflink iflag now that we have the first two locks held.
+	 */
+	if (xfs_can_free_cowblocks(ip, ifp))
+		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 
 	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
