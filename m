Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752317AbdFLMXk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:23:40 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v6 12/13] xfs: minimal conversion to errseq_t writeback error reporting
Date: Mon, 12 Jun 2017 08:23:07 -0400
Message-Id: <20170612122316.13244-16-jlayton@redhat.com>
In-Reply-To: <20170612122316.13244-1-jlayton@redhat.com>
References: <20170612122316.13244-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

Just check and advance the data errseq_t in struct file before
before returning from fsync on normal files. Internal filemap_*
callers are left as-is.

We also set the FS_WB_ERRSEQ flag just for completeness sake.
Not much is really using it at this point.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xfs/xfs_file.c  | 15 +++++++++++----
 fs/xfs/xfs_super.c |  2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5fb5a0958a14..bc3b1575e8db 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -134,7 +134,7 @@ xfs_file_fsync(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
+	int			error = 0, err2;
 	int			log_flushed = 0;
 	xfs_lsn_t		lsn = 0;
 
@@ -142,10 +142,12 @@ xfs_file_fsync(
 
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (error)
-		return error;
+		goto out;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = -EIO;
+		goto out;
+	}
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
@@ -197,6 +199,11 @@ xfs_file_fsync(
 	    mp->m_logdev_targp == mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
+out:
+	err2 = filemap_report_wb_err(file);
+	if (!error)
+		error = err2;
+
 	return error;
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 455a575f101d..28d3be187025 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1758,7 +1758,7 @@ static struct file_system_type xfs_fs_type = {
 	.name			= "xfs",
 	.mount			= xfs_fs_mount,
 	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_WB_ERRSEQ,
 };
 MODULE_ALIAS_FS("xfs");
 
-- 
2.13.0

