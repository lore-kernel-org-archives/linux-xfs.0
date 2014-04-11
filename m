Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFBD329DFE
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 13:57:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67873AC002
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 11:57:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n2BbAqBq2xN1l3wa for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 11:57:54 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Date: Fri, 11 Apr 2014 20:57:44 +0200
Message-Id: <1397242665-2183-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Currently in do_fallocate in collapse range case we're checking whether
offset + len is not bigger than i_size. However there is nothing which
would prevent i_size from changing so the check is pointless. It should
be done in the file system itself and the file system needs to make sure
that i_size is not going to change.

As it is now we can easily crash kernel by having two processes doing
truncate and fallocate collapse range at the same time. This can be
reproduced on ext4 and it is theoretically possible on xfs even though I
was not able to trigger it with this simple test.

This commit removes the check from do_fallocate and adds it to the file
system.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 11 +++++++++--
 fs/open.c         |  8 --------
 fs/xfs/xfs_file.c | 10 +++++++++-
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0177150..ff823b7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5364,8 +5364,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	loff_t new_size;
 	int ret;
 
-	BUG_ON(offset + len > i_size_read(inode));
-
 	/* Collapse range works only on fs block size aligned offsets. */
 	if (offset & (EXT4_BLOCK_SIZE(sb) - 1) ||
 	    len & (EXT4_BLOCK_SIZE(sb) - 1))
@@ -5387,6 +5385,15 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
 
+	/*
+	 * There is no need to overlap collapse range with EOF, in which case
+	 * it is effectively a truncate operation
+	 */
+	if (offset + len >= i_size_read(inode)) {
+		ret = -EINVAL;
+		goto out_mutex;
+	}
+
 	if (IS_SWAPFILE(inode)) {
 		ret = -ETXTBSY;
 		goto out_mutex;
diff --git a/fs/open.c b/fs/open.c
index 7882ff5..14af6be 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -287,14 +287,6 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
 		return -EFBIG;
 
-	/*
-	 * There is no need to overlap collapse range with EOF, in which case
-	 * it is effectively a truncate operation
-	 */
-	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
-	    (offset + len >= i_size_read(inode)))
-		return -EINVAL;
-
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 003c005..4ba0ae9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -840,7 +840,15 @@ xfs_file_fallocate(
 			goto out_unlock;
 		}
 
-		ASSERT(offset + len < i_size_read(inode));
+		/*
+		 * There is no need to overlap collapse range with EOF,
+		 * in which case it is effectively a truncate operation
+		 */
+		if (offset + len >= i_size_read(inode)) {
+			error = -EINVAL;
+			goto out_unlock;
+		}
+
 		new_size = i_size_read(inode) - len;
 
 		error = xfs_collapse_file_space(ip, offset, len);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
