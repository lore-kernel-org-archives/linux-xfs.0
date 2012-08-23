Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53dMj135207 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:39 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NpATqfmvwf3Id0CR for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:24 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Paf-0003H0-Bf
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaV-0003fG-AU
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 050/102] xfs: do not require an ioend for new EOF calculation
Date: Thu, 23 Aug 2012 15:02:08 +1000
Message-Id: <1345698180-13612-51-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 6923e686f19cb7017fc9777a10e06c2e2b2a2936

Replace xfs_ioend_new_eof with a new inline xfs_new_eof helper that
doesn't require and ioend, and is available also outside of xfs_aops.c.

Also make the code a bit more clear by using a normal if statement
instead of a slightly misleading MIN().

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   24 ++++--------------------
 fs/xfs/xfs_inode.h          |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 6a3cafc..5297866 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -133,23 +133,6 @@ xfs_destroy_ioend(
 }
 
 /*
- * If the end of the current ioend is beyond the current EOF,
- * return the new EOF value, otherwise zero.
- */
-STATIC xfs_fsize_t
-xfs_ioend_new_eof(
-	xfs_ioend_t		*ioend)
-{
-	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
-	xfs_fsize_t		isize;
-	xfs_fsize_t		bsize;
-
-	bsize = ioend->io_offset + ioend->io_size;
-	isize = MIN(i_size_read(VFS_I(ip)), bsize);
-	return isize > ip->i_d.di_size ? isize : 0;
-}
-
-/*
  * Fast and loose check if this write could update the on-disk inode size.
  */
 static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
@@ -169,7 +152,7 @@ xfs_setfilesize(
 	xfs_fsize_t		isize;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	isize = xfs_ioend_new_eof(ioend);
+	isize = xfs_new_eof(ip, ioend->io_offset + ioend->io_size);
 	if (isize) {
 		ip->i_d.di_size = isize;
 		xfs_mark_inode_dirty(ip);
@@ -391,6 +374,7 @@ xfs_submit_ioend_bio(
 	xfs_ioend_t		*ioend,
 	struct bio		*bio)
 {
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
@@ -399,8 +383,8 @@ xfs_submit_ioend_bio(
 	 * If the I/O is beyond EOF we mark the inode dirty immediately
 	 * but don't update the inode size until I/O completion.
 	 */
-	if (xfs_ioend_new_eof(ioend))
-		xfs_mark_inode_dirty(XFS_I(ioend->io_inode));
+	if (xfs_new_eof(ip, ioend->io_offset + ioend->io_size))
+		xfs_mark_inode_dirty(ip);
 
 	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d3bbc93..ec81926 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -287,6 +287,20 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
 }
 
 /*
+ * If this I/O goes past the on-disk inode size update it unless it would
+ * be past the current in-core inode size.
+ */
+static inline xfs_fsize_t
+xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
+{
+	xfs_fsize_t i_size = i_size_read(VFS_I(ip));
+
+	if (new_size > i_size)
+		new_size = i_size;
+	return new_size > ip->i_d.di_size ? new_size : 0;
+}
+
+/*
  * i_flags helper functions
  */
 static inline void
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
