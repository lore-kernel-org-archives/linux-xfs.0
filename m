Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o736MEv6228118 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 01:22:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58D591D6B5B1
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 23:22:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	3OisF2kIhVnSSEwk for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 23:22:32 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	33614927-1927428
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:52:31 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OgAtN-00079G-Vi
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:22:26 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OgAtH-0007q9-UL
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 16:22:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: use range primitives for xfs page cache operations
Date: Tue,  3 Aug 2010 16:22:05 +1000
Message-Id: <1280816526-30100-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1280816526-30100-1-git-send-email-david@fromorbit.com>
References: <1280816526-30100-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/linux-2.6/xfs_fs_subr.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index 1f279b0..24f0b0a 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -32,10 +32,9 @@ xfs_tosspages(
 	xfs_off_t	last,
 	int		fiopt)
 {
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-
-	if (mapping->nrpages)
-		truncate_inode_pages(mapping, first);
+	/* can't toss partial tail pages, so mask them out */
+	last &= ~(PAGE_SIZE - 1);
+	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last);
 }
 
 int
@@ -50,12 +49,11 @@ xfs_flushinval_pages(
 
 	trace_xfs_pagecache_inval(ip, first, last);
 
-	if (mapping->nrpages) {
-		xfs_iflags_clear(ip, XFS_ITRUNCATED);
-		ret = filemap_write_and_wait(mapping);
-		if (!ret)
-			truncate_inode_pages(mapping, first);
-	}
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	ret = filemap_write_and_wait_range(mapping, first,
+				last == -1 ? LLONG_MAX : last);
+	if (!ret)
+		truncate_inode_pages_range(mapping, first, last);
 	return -ret;
 }
 
@@ -71,10 +69,9 @@ xfs_flush_pages(
 	int		ret = 0;
 	int		ret2;
 
-	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		xfs_iflags_clear(ip, XFS_ITRUNCATED);
-		ret = -filemap_fdatawrite(mapping);
-	}
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	ret = -filemap_fdatawrite_range(mapping, first,
+				last == -1 ? LLONG_MAX : last);
 	if (flags & XBF_ASYNC)
 		return ret;
 	ret2 = xfs_wait_on_pages(ip, first, last);
@@ -91,7 +88,9 @@ xfs_wait_on_pages(
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
