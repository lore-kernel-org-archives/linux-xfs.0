Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3A607F50
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 22:27:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06E6FAC003
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 20:27:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	c3uXxJyzWMrHU0tZ for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2015 20:27:38 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Date: Mon, 19 Oct 2015 14:27:15 +1100
Message-Id: <1445225238-30413-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1445225238-30413-1-git-send-email-david@fromorbit.com>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: ross.zwisler@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

DAX has a page fault serialisation problem with block allocation.
Because it allows concurrent page faults and does not have a page
lock to serialise faults to the same page, it can get two concurrent
faults to the page that race.

When two read faults race, this isn't a huge problem as the data
underlying the page is not changing and so "detect and drop" works
just fine. The issues are to do with write faults.

When two write faults occur, we serialise block allocation in
get_blocks() so only one faul will allocate the extent. It will,
however, be marked as an unwritten extent, and that is where the
problem lies - the DAX fault code cannot differentiate between a
block that was just allocated and a block that was preallocated and
needs zeroing. The result is that both write faults end up zeroing
the block and attempting to convert it back to written.

The problem is that the first fault can zero and convert before the
second fault starts zeroing, resulting in the zeroing for the second
fault overwriting the data that the first fault wrote with zeros.
The second fault then attempts to convert the unwritten extent,
which is then a no-op because it's already written. Data loss occurs
as a result of this race.

Because there is no sane locking construct in the page fault code
that we can use for serialisation across the page faults, we need to
ensure block allocation and zeroing occurs atomically in the
filesystem. This means we can still take concurrent page faults and
the only time they will serialise is in the filesystem
mapping/allocation callback. The page fault code will always see
written, initialised extents, so we will be able to remove the
unwritten extent handling from the DAX code when all filesystems are
converted.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/dax.c           |  5 +++++
 fs/xfs/xfs_aops.c  | 13 +++++++++----
 fs/xfs/xfs_iomap.c | 21 ++++++++++++++++++++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index bcfb14b..571c631 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -29,6 +29,11 @@
 #include <linux/uio.h>
 #include <linux/vmstat.h>
 
+/*
+ * dax_clear_blocks() is called from within transaction context from XFS,
+ * and hence this means the stack from this point must follow GFP_NOFS
+ * semantics for all operations.
+ */
 int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 {
 	struct block_device *bdev = inode->i_sb->s_bdev;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 366e41eb..7b4f849 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1293,15 +1293,12 @@ xfs_map_direct(
 
 	trace_xfs_gbmap_direct(XFS_I(inode), offset, size, type, imap);
 
-	/* XXX: preparation for removing unwritten extents in DAX */
-#if 0
 	if (dax_fault) {
 		ASSERT(type == XFS_IO_OVERWRITE);
 		trace_xfs_gbmap_direct_none(XFS_I(inode), offset, size, type,
 					    imap);
 		return;
 	}
-#endif
 
 	if (bh_result->b_private) {
 		ioend = bh_result->b_private;
@@ -1429,10 +1426,12 @@ __xfs_get_blocks(
 	if (error)
 		goto out_unlock;
 
+	/* for DAX, we convert unwritten extents directly */
 	if (create &&
 	    (!nimaps ||
 	     (imap.br_startblock == HOLESTARTBLOCK ||
-	      imap.br_startblock == DELAYSTARTBLOCK))) {
+	      imap.br_startblock == DELAYSTARTBLOCK) ||
+	     (IS_DAX(inode) && ISUNWRITTEN(&imap)))) {
 		if (direct || xfs_get_extsz_hint(ip)) {
 			/*
 			 * xfs_iomap_write_direct() expects the shared lock. It
@@ -1477,6 +1476,12 @@ __xfs_get_blocks(
 		goto out_unlock;
 	}
 
+	if (IS_DAX(inode) && create) {
+		ASSERT(!ISUNWRITTEN(&imap));
+		/* zeroing is not needed at a higher layer */
+		new = 0;
+	}
+
 	/* trim mapping down to size requested */
 	if (direct || size > (1 << inode->i_blkbits))
 		xfs_map_trim_size(inode, iblock, bh_result,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3cb5a5..f4f5b43 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -132,6 +132,7 @@ xfs_iomap_write_direct(
 	int		committed;
 	int		error;
 	int		lockmode;
+	int		bmapi_flags = XFS_BMAPI_PREALLOC;
 
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
@@ -195,6 +196,23 @@ xfs_iomap_write_direct(
 	 * Allocate and setup the transaction
 	 */
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+
+	/*
+	 * For DAX, we do not allocate unwritten extents, but instead we zero
+	 * the block before we commit the transaction.  Ideally we'd like to do
+	 * this outside the transaction context, but if we commit and then crash
+	 * we may not have zeroed the blocks and this will be exposed on
+	 * recovery of the allocation. Hence we must zero before commit.
+	 * Further, if we are mapping unwritten extents here, we need to zero
+	 * and convert them to written so that we don't need an unwritten extent
+	 * callback for DAX. This also means that we need to be able to dip into
+	 * the reserve block pool if there is no space left but we need to do
+	 * unwritten extent conversion.
+	 */
+	if (IS_DAX(VFS_I(ip))) {
+		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
+		tp->t_flags |= XFS_TRANS_RESERVE;
+	}
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 				  resblks, resrtextents);
 	/*
@@ -221,7 +239,7 @@ xfs_iomap_write_direct(
 	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-				XFS_BMAPI_PREALLOC, &firstfsb, resblks, imap,
+				bmapi_flags, &firstfsb, resblks, imap,
 				&nimaps, &free_list);
 	if (error)
 		goto out_bmap_cancel;
@@ -232,6 +250,7 @@ xfs_iomap_write_direct(
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
 		goto out_bmap_cancel;
+
 	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_unlock;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
