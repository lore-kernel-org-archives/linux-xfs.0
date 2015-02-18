Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B01A47FA7
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 16:48:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E2FD8F804C
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 14:48:50 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4nHlFVas8aAFAq8m for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 14:48:47 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YODQD-0000Kq-Ny
	for xfs@oss.sgi.com; Thu, 19 Feb 2015 09:48:45 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YODQD-0006n2-Mf
	for xfs@oss.sgi.com; Thu, 19 Feb 2015 09:48:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: ensure truncate forces zeroed blocks to disk
Date: Thu, 19 Feb 2015 09:48:45 +1100
Message-Id: <1424299725-26067-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

A new fsync vs power fail test in xfstests indicated that XFS can
have unreliable data consistency when doing extending truncates that
require block zeroing. The blocks beyond EOF get zeroed in memory,
but we never force those changes to disk before we run the
transaction that extends the file size and exposes those blocks to
userspace. This can result in the blocks not being correctly zeroed
after a crash.

Because in-memory behaviour is correct, tools like fsx don't pick up
any coherency problems - it's not until the filesystem is shutdown
or the system crashes after writing the truncate transaction to the
journal but before the zeroed data in the page cache is flushed that
the issue is exposed.

Fix this by also flushing the dirty data in memory region between
the old size and new size when we've found blocks that need zeroing
in the truncate process.

Reported-by: Liu Bo <bo.li.liu@oracle.com>
cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 14 ++++++++++----
 fs/xfs/xfs_inode.h |  9 +++++----
 fs/xfs/xfs_iops.c  | 36 ++++++++++++++----------------------
 3 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ce615d1..a2e1cb8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -397,7 +397,8 @@ STATIC int				/* error (positive) */
 xfs_zero_last_block(
 	struct xfs_inode	*ip,
 	xfs_fsize_t		offset,
-	xfs_fsize_t		isize)
+	xfs_fsize_t		isize,
+	bool			*did_zeroing)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		last_fsb = XFS_B_TO_FSBT(mp, isize);
@@ -425,6 +426,7 @@ xfs_zero_last_block(
 	zero_len = mp->m_sb.sb_blocksize - zero_offset;
 	if (isize + zero_len > offset)
 		zero_len = offset - isize;
+	*did_zeroing = true;
 	return xfs_iozero(ip, isize, zero_len);
 }
 
@@ -443,7 +445,8 @@ int					/* error (positive) */
 xfs_zero_eof(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,		/* starting I/O offset */
-	xfs_fsize_t		isize)		/* current inode size */
+	xfs_fsize_t		isize,		/* current inode size */
+	bool			*did_zeroing)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		start_zero_fsb;
@@ -465,7 +468,7 @@ xfs_zero_eof(
 	 * We only zero a part of that block so it is handled specially.
 	 */
 	if (XFS_B_FSB_OFFSET(mp, isize) != 0) {
-		error = xfs_zero_last_block(ip, offset, isize);
+		error = xfs_zero_last_block(ip, offset, isize, did_zeroing);
 		if (error)
 			return error;
 	}
@@ -525,6 +528,7 @@ xfs_zero_eof(
 		if (error)
 			return error;
 
+		*did_zeroing = true;
 		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
 		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
 	}
@@ -567,13 +571,15 @@ restart:
 	 * having to redo all checks before.
 	 */
 	if (*pos > i_size_read(inode)) {
+		bool	zero = false;
+
 		if (*iolock == XFS_IOLOCK_SHARED) {
 			xfs_rw_iunlock(ip, *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
 			xfs_rw_ilock(ip, *iolock);
 			goto restart;
 		}
-		error = xfs_zero_eof(ip, *pos, i_size_read(inode));
+		error = xfs_zero_eof(ip, *pos, i_size_read(inode), &zero);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8e82b41..c73b63d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -384,10 +384,11 @@ enum xfs_prealloc_flags {
 	XFS_PREALLOC_INVISIBLE	= (1 << 4),
 };
 
-int		xfs_update_prealloc_flags(struct xfs_inode *,
-			enum xfs_prealloc_flags);
-int		xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
-int		xfs_iozero(struct xfs_inode *, loff_t, size_t);
+int	xfs_update_prealloc_flags(struct xfs_inode *ip,
+				  enum xfs_prealloc_flags flags);
+int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
+		     xfs_fsize_t isize, bool *did_zeroing);
+int	xfs_iozero(struct xfs_inode *ip, loff_t pos, size_t count);
 
 
 /* from xfs_iops.c */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d7782ae..3ccc28e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -756,6 +756,7 @@ xfs_setattr_size(
 	int			error;
 	uint			lock_flags = 0;
 	uint			commit_flags = 0;
+	bool			did_zeroing = false;
 
 	trace_xfs_setattr(ip);
 
@@ -799,20 +800,16 @@ xfs_setattr_size(
 		return error;
 
 	/*
-	 * Now we can make the changes.  Before we join the inode to the
-	 * transaction, take care of the part of the truncation that must be
-	 * done without the inode lock.  This needs to be done before joining
-	 * the inode to the transaction, because the inode cannot be unlocked
-	 * once it is a part of the transaction.
+	 * File data changes must be complete before we start the transaction to
+	 * modify the inode.  This needs to be done before joining the inode to
+	 * the transaction because the inode cannot be unlocked once it is a
+	 * part of the transaction.
+	 *
+	 * Start with zeroing any data block beyond EOF that we may expose on
+	 * file extension.
 	 */
 	if (newsize > oldsize) {
-		/*
-		 * Do the first part of growing a file: zero any data in the
-		 * last block that is beyond the old EOF.  We need to do this
-		 * before the inode is joined to the transaction to modify
-		 * i_size.
-		 */
-		error = xfs_zero_eof(ip, newsize, oldsize);
+		error = xfs_zero_eof(ip, newsize, oldsize, &did_zeroing);
 		if (error)
 			return error;
 	}
@@ -822,23 +819,18 @@ xfs_setattr_size(
 	 * any previous writes that are beyond the on disk EOF and the new
 	 * EOF that have not been written out need to be written here.  If we
 	 * do not write the data out, we expose ourselves to the null files
-	 * problem.
-	 *
-	 * Only flush from the on disk size to the smaller of the in memory
-	 * file size or the new size as that's the range we really care about
-	 * here and prevents waiting for other data not within the range we
-	 * care about here.
+	 * problem. Note that this includes any block zeroing we did above;
+	 * otherwise those blocks may not be zeroed after a crash.
 	 */
-	if (oldsize != ip->i_d.di_size && newsize > ip->i_d.di_size) {
+	if (newsize > ip->i_d.di_size &&
+	    (oldsize != ip->i_d.di_size || did_zeroing)) {
 		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 						      ip->i_d.di_size, newsize);
 		if (error)
 			return error;
 	}
 
-	/*
-	 * Wait for all direct I/O to complete.
-	 */
+	/* Now wait for all direct I/O to complete. */
 	inode_dio_wait(inode);
 
 	/*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
