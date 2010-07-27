Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R5qXqX168298 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 00:52:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1690B474D38
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 22:55:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	2g4dHgNMXsBAKI1j for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 22:55:36 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32815517-1927428
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 15:25:35 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Odd8Y-0004Hw-DL
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:55:34 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Odd8V-0002rG-ET
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:55:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: use range primitives for xfs page cache operations
Date: Tue, 27 Jul 2010 15:55:28 +1000
Message-Id: <1280210129-10925-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1280210129-10925-1-git-send-email-david@fromorbit.com>
References: <1280210129-10925-1-git-send-email-david@fromorbit.com>
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

While XFS passes ranges to operate on from the core code, the
functions being called ignore the either the entire range or the end
of the range. This is historical because when the function were
written linux didn't have the necessary range operations. Update the
functions to use the correct operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_fs_subr.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index 1f279b0..e76d31d 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -32,10 +32,7 @@ xfs_tosspages(
 	xfs_off_t	last,
 	int		fiopt)
 {
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-
-	if (mapping->nrpages)
-		truncate_inode_pages(mapping, first);
+	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last);
 }
 
 int
@@ -52,9 +49,10 @@ xfs_flushinval_pages(
 
 	if (mapping->nrpages) {
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
-		ret = filemap_write_and_wait(mapping);
+		ret = filemap_write_and_wait_range(mapping, first,
+					last == -1 ? LLONG_MAX : last);
 		if (!ret)
-			truncate_inode_pages(mapping, first);
+			truncate_inode_pages_range(mapping, first, last);
 	}
 	return -ret;
 }
@@ -73,7 +71,8 @@ xfs_flush_pages(
 
 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
-		ret = -filemap_fdatawrite(mapping);
+		ret = -filemap_fdatawrite_range(mapping, first,
+					last == -1 ? LLONG_MAX : last);
 	}
 	if (flags & XBF_ASYNC)
 		return ret;
@@ -91,7 +90,9 @@ xfs_wait_on_pages(
 {
 	struct address_space *mapping = VFS_I(ip)->i_mapping;
 
-	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
-		return -filemap_fdatawait(mapping);
+	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
+		return -filemap_fdatawait_range(mapping, first,
+					last == -1 ? ip->i_size - 1 : last);
+	}
 	return 0;
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
