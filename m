Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbeJEHlT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:19 -0400
Subject: [PATCH 04/15] xfs: update ctime and remove suid before cloning files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:45:00 -0700
Message-ID: <153870030069.29072.11055871953561649172.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Before cloning into a file, update the ctime and remove sensitive
attributes like suid, just like we'd do for a regular file write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 55da7e1154f4..d8f209bc8937 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1239,6 +1239,7 @@ xfs_reflink_zero_posteof(
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file
  * will be truncated, and any leases on the out file will have been broken.
+ * This function borrows heavily from xfs_file_aio_write_checks.
  */
 STATIC int
 xfs_reflink_remap_prep(
@@ -1302,6 +1303,30 @@ xfs_reflink_remap_prep(
 	/* Zap any page cache for the destination file's range. */
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
 				   PAGE_ALIGN(pos_out + len) - 1);
+
+	/* If we're altering the file contents... */
+	if (!is_dedupe) {
+		/*
+		 * ...update the timestamps (which will grab the ilock again
+		 * from xfs_fs_dirty_inode, so we have to call it before we
+		 * take the ilock).
+		 */
+		if (!(file_out->f_mode & FMODE_NOCMTIME)) {
+			ret = file_update_time(file_out);
+			if (ret)
+				goto out_unlock;
+		}
+
+		/*
+		 * ...clear the security bits if the process is not being run
+		 * by root.  This keeps people from modifying setuid and setgid
+		 * binaries.
+		 */
+		ret = file_remove_privs(file_out);
+		if (ret)
+			goto out_unlock;
+	}
+
 	return 0;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
