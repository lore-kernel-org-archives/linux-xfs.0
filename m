Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9A8Ka0096659 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 04:08:20 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	B7HRFD1py8B5w5VI for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 02:10:18 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWlXV-0006US-3O
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 21:10:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWlXL-0004SO-0S
	for xfs@oss.sgi.com; Fri, 09 Nov 2012 21:10:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: remove xfs_flush_pages
Date: Fri,  9 Nov 2012 21:10:03 +1100
Message-Id: <1352455804-17045-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1352455804-17045-1-git-send-email-david@fromorbit.com>
References: <1352455804-17045-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

It is a complex wrapper around VFS functions, but there are VFS
functions that provide exactly the same functionality. Call the VFS
functions directly and remove the unnecessary indirection and
complexity.

We don't need to care about clearing the XFS_ITRUNCATED flag, as
that is done during .writepages. Hence is cleared by the VFS
writeback path if there is anything to write back during the flush.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c     |    2 +-
 fs/xfs/xfs_bmap.c     |    2 +-
 fs/xfs/xfs_fs_subr.c  |   24 ------------------------
 fs/xfs/xfs_iops.c     |    4 ++--
 fs/xfs/xfs_vnodeops.c |    7 +++++--
 fs/xfs/xfs_vnodeops.h |    2 --
 6 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e562dd4..42ef842 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1617,7 +1617,7 @@ xfs_vm_bmap(
 
 	trace_xfs_vm_bmap(XFS_I(inode));
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
+	filemap_write_and_wait(mapping);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
 }
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 83d0cf3..a60f3d1 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5599,7 +5599,7 @@ xfs_getbmap(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
 		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
-			error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
+			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
 			if (error)
 				goto out_unlock_iolock;
 		}
diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
index 3365823..b538089 100644
--- a/fs/xfs/xfs_fs_subr.c
+++ b/fs/xfs/xfs_fs_subr.c
@@ -44,27 +44,3 @@ xfs_flushinval_pages(
 		truncate_inode_pages_range(mapping, first, last);
 	return -ret;
 }
-
-int
-xfs_flush_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	uint64_t	flags,
-	int		fiopt)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-	int		ret2;
-
-	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	ret = -filemap_fdatawrite_range(mapping, first,
-				last == -1 ? LLONG_MAX : last);
-	if (flags & XBF_ASYNC)
-		return ret;
-	ret2 = -filemap_fdatawait_range(mapping, first,
-				last == -1 ? XFS_ISIZE(ip) - 1 : last);
-	if (!ret)
-		ret = ret2;
-	return ret;
-}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 81f5c49..d82efaa 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -780,8 +780,8 @@ xfs_setattr_size(
 	 * care about here.
 	 */
 	if (oldsize != ip->i_d.di_size && newsize > ip->i_d.di_size) {
-		error = xfs_flush_pages(ip, ip->i_d.di_size, newsize, 0,
-					FI_NONE);
+		error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+						      ip->i_d.di_size, newsize);
 		if (error)
 			goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index f7de578..31de73e 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -428,8 +428,11 @@ xfs_release(
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
 		if (truncated) {
 			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-			if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
-				xfs_flush_pages(ip, 0, -1, XBF_ASYNC, FI_NONE);
+			if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0) {
+				error = -filemap_flush(VFS_I(ip)->i_mapping);
+				if (error)
+					return error;
+			}
 		}
 	}
 
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index c8ad48b..73cb3cb 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -50,8 +50,6 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		int flags, struct attrlist_cursor_kern *cursor);
 int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, int fiopt);
-int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
-		xfs_off_t last, uint64_t flags, int fiopt);
 
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
