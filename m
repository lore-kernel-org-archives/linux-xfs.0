Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBqoE7217623 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:52:50 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Pr1e1jjT9IWUFUoU for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:54:51 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsb8-00053N-5e
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:38 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsax-00011n-V1
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/32] xfs: remove xfs_wait_on_pages()
Date: Mon, 12 Nov 2012 22:53:55 +1100
Message-Id: <1352721264-3700-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-1-git-send-email-david@fromorbit.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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

It's just a simple wrapper around a VFS function that is only called
by another function in xfs_fs_subr.c. Remove it and call the VFS
function directly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fs_subr.c  |   18 ++----------------
 fs/xfs/xfs_vnodeops.h |    1 -
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
index d49de3d..3365823 100644
--- a/fs/xfs/xfs_fs_subr.c
+++ b/fs/xfs/xfs_fs_subr.c
@@ -62,23 +62,9 @@ xfs_flush_pages(
 				last == -1 ? LLONG_MAX : last);
 	if (flags & XBF_ASYNC)
 		return ret;
-	ret2 = xfs_wait_on_pages(ip, first, last);
+	ret2 = -filemap_fdatawait_range(mapping, first,
+				last == -1 ? XFS_ISIZE(ip) - 1 : last);
 	if (!ret)
 		ret = ret2;
 	return ret;
 }
-
-int
-xfs_wait_on_pages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last)
-{
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-
-	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
-		return -filemap_fdatawait_range(mapping, first,
-					last == -1 ? XFS_ISIZE(ip) - 1 : last);
-	}
-	return 0;
-}
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index d48141d..c8ad48b 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -52,7 +52,6 @@ int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, int fiopt);
 int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, uint64_t flags, int fiopt);
-int xfs_wait_on_pages(struct xfs_inode *ip, xfs_off_t first, xfs_off_t last);
 
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
