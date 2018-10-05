Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50678 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbeJEHlI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:08 -0400
Subject: [PATCH 03/15] xfs: zero posteof blocks when cloning above eof
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:44:54 -0700
Message-ID: <153870029414.29072.6572683664719818617.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're reflinking between two files and the destination file range
is well beyond the destination file's EOF marker, zero any posteof
speculative preallocations in the destination file so that we don't
expose stale disk contents.  The previous strategy of trying to clear
the preallocations does not work if the destination file has the
PREALLOC flag set.

Uncovered by shared/010.

Reported-by: Zorro Lang <zlang@redhat.com>
Bugzilla-id: https://bugzilla.kernel.org/show_bug.cgi?id=201259
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 80ca9b6793cd..55da7e1154f4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1215,6 +1215,26 @@ xfs_reflink_remap_unlock(
 		inode_unlock_shared(inode_in);
 }
 
+/*
+ * If we're reflinking to a point past the destination file's EOF, we must
+ * zero any speculative post-EOF preallocations that sit between the old EOF
+ * and the destination file offset.
+ */
+static int
+xfs_reflink_zero_posteof(
+	struct xfs_inode	*ip,
+	loff_t			pos)
+{
+	loff_t			isize = i_size_read(VFS_I(ip));
+
+	if (pos <= isize)
+		return 0;
+
+	trace_xfs_zero_eof(ip, isize, pos - isize);
+	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
+			&xfs_iomap_ops);
+}
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file
@@ -1267,15 +1287,12 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	/*
-	 * Clear out post-eof preallocations because we don't have page cache
-	 * backing the delayed allocations and they'll never get freed on
-	 * their own.
+	 * Zero existing post-eof speculative preallocations in the destination
+	 * file.
 	 */
-	if (xfs_can_free_eofblocks(dest, true)) {
-		ret = xfs_free_eofblocks(dest);
-		if (ret)
-			goto out_unlock;
-	}
+	ret = xfs_reflink_zero_posteof(dest, pos_out);
+	if (ret)
+		goto out_unlock;
 
 	/* Set flags and remap blocks. */
 	ret = xfs_reflink_set_inode_flag(src, dest);
