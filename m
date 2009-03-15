Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBWftQ006958 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:33:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B4391C43846
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail02.adl2.internode.on.net
	[203.16.214.66]) by cuda.sgi.com with ESMTP id oaFFkqvEey9Glfou
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:18 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] [XFS] Remove xfs_flush_space
Date: Sun, 15 Mar 2009 22:31:47 +1100
Message-Id: <1237116707-25793-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1237116707-25793-1-git-send-email-david@fromorbit.com>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
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
Cc: mpatocka@redhat.com

The only thing we need to do now when we get an ENOSPC condition during delayed
allocation reservation is flush all the other inodes with delalloc blocks on
them and retry without EOF preallocation. Remove the unneeded mess that is
xfs_flush_space() and just call xfs_flush_inodes() directly from
xfs_iomap_write_delay().

Also, change the location of the retry label to avoid trying to do EOF
preallocation because we don't want to do that at ENOSPC. This enables us to
remove the BMAPI_SYNC flag as it is no longer used.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iomap.c |   61 ++++++++++++---------------------------------------
 fs/xfs/xfs_iomap.h |    3 +-
 2 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7b8b170..5aaa2d7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -338,38 +338,6 @@ xfs_iomap_eof_align_last_fsb(
 }
 
 STATIC int
-xfs_flush_space(
-	xfs_inode_t	*ip,
-	int		*fsynced,
-	int		*ioflags)
-{
-	switch (*fsynced) {
-	case 0:
-		if (ip->i_delayed_blks) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			delay(1);
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			*fsynced = 1;
-		} else {
-			*ioflags |= BMAPI_SYNC;
-			*fsynced = 2;
-		}
-		return 0;
-	case 1:
-		*fsynced = 2;
-		*ioflags |= BMAPI_SYNC;
-		return 0;
-	case 2:
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_flush_inodes(ip);
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		*fsynced = 3;
-		return 0;
-	}
-	return 1;
-}
-
-STATIC int
 xfs_cmn_err_fsblock_zero(
 	xfs_inode_t	*ip,
 	xfs_bmbt_irec_t	*imap)
@@ -538,15 +506,9 @@ error_out:
 }
 
 /*
- * If the caller is doing a write at the end of the file,
- * then extend the allocation out to the file system's write
- * iosize.  We clean up any extra space left over when the
- * file is closed in xfs_inactive().
- *
- * For sync writes, we are flushing delayed allocate space to
- * try to make additional space available for allocation near
- * the filesystem full boundary - preallocation hurts in that
- * situation, of course.
+ * If the caller is doing a write at the end of the file, then extend the
+ * allocation out to the file system's write iosize.  We clean up any extra
+ * space left over when the file is closed in xfs_inactive().
  */
 STATIC int
 xfs_iomap_eof_want_preallocate(
@@ -565,7 +527,7 @@ xfs_iomap_eof_want_preallocate(
 	int		n, error, imaps;
 
 	*prealloc = 0;
-	if ((ioflag & BMAPI_SYNC) || (offset + count) <= ip->i_size)
+	if ((offset + count) <= ip->i_size)
 		return 0;
 
 	/*
@@ -611,7 +573,7 @@ xfs_iomap_write_delay(
 	xfs_extlen_t	extsz;
 	int		nimaps;
 	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
-	int		prealloc, fsynced = 0;
+	int		prealloc, flushed = 0;
 	int		error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -627,12 +589,12 @@ xfs_iomap_write_delay(
 	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-retry:
 	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
 				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
 	if (error)
 		return error;
 
+retry:
 	if (prealloc) {
 		aligned_offset = XFS_WRITEIO_ALIGN(mp, (offset + count - 1));
 		ioalign = XFS_B_TO_FSBT(mp, aligned_offset);
@@ -659,15 +621,22 @@ retry:
 
 	/*
 	 * If bmapi returned us nothing, and if we didn't get back EDQUOT,
-	 * then we must have run out of space - flush delalloc, and retry..
+	 * then we must have run out of space - flush all other inodes with
+	 * delalloc blocks and retry without EOF preallocation.
 	 */
 	if (nimaps == 0) {
 		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_NOSPACE,
 					ip, offset, count);
-		if (xfs_flush_space(ip, &fsynced, &ioflag))
+		if (flushed)
 			return XFS_ERROR(ENOSPC);
 
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_flush_inodes(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+		flushed = 1;
 		error = 0;
+		prealloc = 0;
 		goto retry;
 	}
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ee1a0c1..87fb9d1 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -40,8 +40,7 @@ typedef enum {
 	BMAPI_IGNSTATE = (1 << 4),	/* ignore unwritten state on read */
 	BMAPI_DIRECT = (1 << 5),	/* direct instead of buffered write */
 	BMAPI_MMAP = (1 << 6),		/* allocate for mmap write */
-	BMAPI_SYNC = (1 << 7),		/* sync write to flush delalloc space */
-	BMAPI_TRYLOCK = (1 << 8),	/* non-blocking request */
+	BMAPI_TRYLOCK = (1 << 7),	/* non-blocking request */
 } bmapi_flags_t;
 
 
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
