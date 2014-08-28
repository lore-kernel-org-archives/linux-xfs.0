Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 101B07F47
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 06:49:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9A57304053
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 04:49:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bQpyg5kRWlP8nNKa for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 04:49:19 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XMyCX-0000FO-Gl
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XMyCX-0004Kq-Ft
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfs: use ranged writeback and invalidation for direct IO
Date: Thu, 28 Aug 2014 21:49:08 +1000
Message-Id: <1409226551-16570-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1409226551-16570-1-git-send-email-david@fromorbit.com>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
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

Now we are not doing silly things with dirtying buffers beyond EOF
and using invalidation correctly, we can finally reduce the ranges of
writeback and invalidation used by direct IO to match that of the IO
being issued.

Bring the writeback and invalidation ranges back to match the
generic direct IO code - this will greatly reduce the perturbation
of cached data when direct IO and buffered IO are mixed, but still
provide the same buffered vs direct IO coherency behaviour we
currently have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 19917fa..de5368c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -291,7 +291,7 @@ xfs_file_read_iter(
 		if (inode->i_mapping->nrpages) {
 			ret = filemap_write_and_wait_range(
 							VFS_I(ip)->i_mapping,
-							pos, -1);
+							pos, pos + size - 1);
 			if (ret) {
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
@@ -303,7 +303,8 @@ xfs_file_read_iter(
 			 * happen on XFS. Warn if it does fail.
 			 */
 			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
-						pos >> PAGE_CACHE_SHIFT, -1);
+					pos >> PAGE_CACHE_SHIFT,
+					(pos + size - 1) >> PAGE_CACHE_SHIFT);
 			WARN_ON_ONCE(ret);
 			ret = 0;
 		}
@@ -641,7 +642,7 @@ xfs_file_dio_aio_write(
 
 	if (mapping->nrpages) {
 		ret = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-						    pos, -1);
+						    pos, pos + count - 1);
 		if (ret)
 			goto out;
 		/*
@@ -650,7 +651,8 @@ xfs_file_dio_aio_write(
 		 * happen on XFS. Warn if it does fail.
 		 */
 		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
-						pos >> PAGE_CACHE_SHIFT, -1);
+					pos >> PAGE_CACHE_SHIFT,
+					(pos + count - 1) >> PAGE_CACHE_SHIFT);
 		WARN_ON_ONCE(ret);
 		ret = 0;
 	}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
