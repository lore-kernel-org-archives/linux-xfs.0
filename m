Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37644 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfFYApd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 20:45:33 -0400
Subject: [PATCH 1/2] xfs: factor range zeroing out of xfs_free_file_space
References: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <23867a36-6f3b-81fb-e463-dc941617e9de@sandeen.net>
Date: Mon, 24 Jun 2019 19:45:32 -0500
MIME-Version: 1.0
In-Reply-To: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Factor out the range zeroing part of xfs_free_file_space into
a new function, xfs_zero_range, which is a wrapper around
iomap_zero_range + EOF handling.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2a7e10f26bb0..0a96c4d1718e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1061,6 +1061,37 @@ xfs_flush_unmap_range(
 	return 0;
 }
 
+/*
+ * Ensure that the specified range is all zeros.
+ * Unmapped or unwritten blocks are left alone by the iomap mechanism,
+ * as they already return zero on read.
+ * This will happily extend i_size if asked to do so.
+ */
+static int
+xfs_zero_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	int			error;
+
+	error = iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
+	if (error)
+		return error;
+	/*
+	 * If we zeroed right up to EOF and EOF straddles a page boundary we
+	 * must make sure that the post-EOF area is also zeroed because the
+	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
+	 * Writeback of the eof page will do this, albeit clumsily.
+	 */
+	if (offset + len >= XFS_ISIZE(ip) && offset_in_page(offset + len) > 0) {
+		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+				round_down(offset + len, PAGE_SIZE), LLONG_MAX);
+	}
+
+	return error;
+}
+
 int
 xfs_free_file_space(
 	struct xfs_inode	*ip,
@@ -1101,28 +1132,15 @@ xfs_free_file_space(
 	}
 
 	/*
-	 * Now that we've unmap all full blocks we'll have to zero out any
-	 * partial block at the beginning and/or end.  iomap_zero_range is smart
-	 * enough to skip any holes, including those we just created, but we
-	 * must take care not to zero beyond EOF and enlarge i_size.
-	 */
-	if (offset >= XFS_ISIZE(ip))
-		return 0;
-	if (offset + len > XFS_ISIZE(ip))
-		len = XFS_ISIZE(ip) - offset;
-	error = iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
-	if (error)
-		return error;
-
-	/*
-	 * If we zeroed right up to EOF and EOF straddles a page boundary we
-	 * must make sure that the post-EOF area is also zeroed because the
-	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
-	 * Writeback of the eof page will do this, albeit clumsily.
+	 * Now that we've unmapped all full blocks we'll have to zero out any
+	 * partial block at the beginning and/or end.  xfs_zero_range is smart
+	 * enough to skip any holes, including those we just created.  We don't
+	 * want to zero beyond EOF and enlarge i_size.
 	 */
-	if (offset + len >= XFS_ISIZE(ip) && offset_in_page(offset + len) > 0) {
-		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-				round_down(offset + len, PAGE_SIZE), LLONG_MAX);
+	if (offset < XFS_ISIZE(ip)) {
+		if (offset + len > XFS_ISIZE(ip))
+			len = XFS_ISIZE(ip) - offset;
+		error = xfs_zero_range(ip, offset, len);
 	}
 
 	return error;
