Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B8D67F8E
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 09:08:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BA1530408C
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 07:08:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8zvxFZE6sCfT67TT for
	<xfs@oss.sgi.com>; Mon, 17 Feb 2014 07:08:34 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/6] ext4: Update inode i_size after the preallocation
Date: Mon, 17 Feb 2014 16:08:18 +0100
Message-Id: <1392649703-10772-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, xfs@oss.sgi.com

Currently in ext4_fallocate we would update inode size, c_time and sync
the file with every partial allocation which is entirely unnecessary. It
is true that if the crash happens in the middle of truncate we might end
up with unchanged i size, or c_time which I do not think is really a
problem - it does not mean file system corruption in any way. Note that
xfs is doing things the same way e.g. update all of the mentioned after
the allocation is done.

This commit moves all the updates after the allocation is done. In
addition we also need to change m_time as not only inode has been change
bot also data regions might have changed (unwritten extents). Also we do
not need to be paranoid about changing the c_time and m_time only if the
actual allocation have happened, we can change it even if we try to
allocate only to find out that there are already block allocated. It's
not really a big deal and it will save us some additional complexity.

Also use ext4_debug, instead of ext4_warning in #ifdef EXT4FS_DEBUG
section.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 86 +++++++++++++++++++++----------------------------------
 1 file changed, 32 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10cff47..6a52851 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4513,36 +4513,6 @@ retry:
 	ext4_std_error(inode->i_sb, err);
 }
 
-static void ext4_falloc_update_inode(struct inode *inode,
-				int mode, loff_t new_size, int update_ctime)
-{
-	struct timespec now;
-
-	if (update_ctime) {
-		now = current_fs_time(inode->i_sb);
-		if (!timespec_equal(&inode->i_ctime, &now))
-			inode->i_ctime = now;
-	}
-	/*
-	 * Update only when preallocation was requested beyond
-	 * the file size.
-	 */
-	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
-		if (new_size > i_size_read(inode))
-			i_size_write(inode, new_size);
-		if (new_size > EXT4_I(inode)->i_disksize)
-			ext4_update_i_disksize(inode, new_size);
-	} else {
-		/*
-		 * Mark that we allocate beyond EOF so the subsequent truncate
-		 * can proceed even if the new size is the same as i_size.
-		 */
-		if (new_size > i_size_read(inode))
-			ext4_set_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
-	}
-
-}
-
 /*
  * preallocate space for a file. This implements ext4's fallocate file
  * operation, which gets called from sys_fallocate system call.
@@ -4554,7 +4524,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
 	handle_t *handle;
-	loff_t new_size;
+	loff_t new_size = 0;
 	unsigned int max_blocks;
 	int ret = 0;
 	int ret2 = 0;
@@ -4594,12 +4564,15 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
-	ret = inode_newsize_ok(inode, (len + offset));
-	if (ret) {
-		mutex_unlock(&inode->i_mutex);
-		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
-		return ret;
+
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	     offset + len > i_size_read(inode)) {
+		new_size = offset + len;
+		ret = inode_newsize_ok(inode, new_size);
+		if (ret)
+			goto out;
 	}
+
 	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
@@ -4623,28 +4596,14 @@ retry:
 		}
 		ret = ext4_map_blocks(handle, inode, &map, flags);
 		if (ret <= 0) {
-#ifdef EXT4FS_DEBUG
-			ext4_warning(inode->i_sb,
-				     "inode #%lu: block %u: len %u: "
-				     "ext4_ext_map_blocks returned %d",
-				     inode->i_ino, map.m_lblk,
-				     map.m_len, ret);
-#endif
+			ext4_debug("inode #%lu: block %u: len %u: "
+				   "ext4_ext_map_blocks returned %d",
+				   inode->i_ino, map.m_lblk,
+				   map.m_len, ret);
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
 			break;
 		}
-		if ((map.m_lblk + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
-						blkbits) >> blkbits))
-			new_size = offset + len;
-		else
-			new_size = ((loff_t) map.m_lblk + ret) << blkbits;
-
-		ext4_falloc_update_inode(inode, mode, new_size,
-					 (map.m_flags & EXT4_MAP_NEW));
-		ext4_mark_inode_dirty(handle, inode);
-		if ((file->f_flags & O_SYNC) && ret >= max_blocks)
-			ext4_handle_sync(handle);
 		ret2 = ext4_journal_stop(handle);
 		if (ret2)
 			break;
@@ -4654,6 +4613,25 @@ retry:
 		ret = 0;
 		goto retry;
 	}
+
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
+	if (IS_ERR(handle))
+		goto out;
+
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+
+	if (ret > 0 && new_size) {
+		if (new_size > i_size_read(inode))
+			i_size_write(inode, new_size);
+		if (new_size > EXT4_I(inode)->i_disksize)
+			ext4_update_i_disksize(inode, new_size);
+	}
+	ext4_mark_inode_dirty(handle, inode);
+	if (file->f_flags & O_SYNC)
+		ext4_handle_sync(handle);
+
+	ext4_journal_stop(handle);
+out:
 	mutex_unlock(&inode->i_mutex);
 	trace_ext4_fallocate_exit(inode, offset, max_blocks,
 				ret > 0 ? ret2 : ret);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
