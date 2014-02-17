Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCD657F88
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 09:08:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CDAEAC002
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 07:08:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EOXsx2Q8ZlqyM7uM for
	<xfs@oss.sgi.com>; Mon, 17 Feb 2014 07:08:35 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/6] ext4: refactor ext4_fallocate code
Date: Mon, 17 Feb 2014 16:08:19 +0100
Message-Id: <1392649703-10772-3-git-send-email-lczerner@redhat.com>
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

Move block allocation out of the ext4_fallocate into separate function
called ext4_alloc_file_blocks(). This will allow us to use the same
allocation code for other allocation operations such as zero range which
is commit in the next patch.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 127 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 73 insertions(+), 54 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6a52851..2d68a46 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4513,6 +4513,64 @@ retry:
 	ext4_std_error(inode->i_sb, err);
 }
 
+int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
+			   ext4_lblk_t len, int flags, int mode)
+{
+	struct inode *inode = file_inode(file);
+	handle_t *handle;
+	int ret = 0;
+	int ret2 = 0;
+	int retries = 0;
+	struct ext4_map_blocks map;
+	unsigned int credits;
+
+	map.m_lblk = offset;
+	/*
+	 * Don't normalize the request if it can fit in one extent so
+	 * that it doesn't get unnecessarily split into multiple
+	 * extents.
+	 */
+	if (len <= EXT_UNINIT_MAX_LEN)
+		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
+
+	/*
+	 * credits to insert 1 extent into extent tree
+	 */
+	credits = ext4_chunk_trans_blocks(inode, len);
+
+retry:
+	while (ret >= 0 && ret < len) {
+		map.m_lblk = map.m_lblk + ret;
+		map.m_len = len = len - ret;
+		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+					    credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			break;
+		}
+		ret = ext4_map_blocks(handle, inode, &map, flags);
+		if (ret <= 0) {
+			ext4_debug("inode #%lu: block %u: len %u: "
+				   "ext4_ext_map_blocks returned %d",
+				   inode->i_ino, map.m_lblk,
+				   map.m_len, ret);
+			ext4_mark_inode_dirty(handle, inode);
+			ret2 = ext4_journal_stop(handle);
+			break;
+		}
+		ret2 = ext4_journal_stop(handle);
+		if (ret2)
+			break;
+	}
+	if (ret == -ENOSPC &&
+			ext4_should_retry_alloc(inode->i_sb, &retries)) {
+		ret = 0;
+		goto retry;
+	}
+
+	return ret > 0 ? ret2 : ret;
+}
+
 /*
  * preallocate space for a file. This implements ext4's fallocate file
  * operation, which gets called from sys_fallocate system call.
@@ -4527,11 +4585,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	loff_t new_size = 0;
 	unsigned int max_blocks;
 	int ret = 0;
-	int ret2 = 0;
-	int retries = 0;
 	int flags;
-	struct ext4_map_blocks map;
-	unsigned int credits, blkbits = inode->i_blkbits;
+	ext4_lblk_t lblk;
+	unsigned int blkbits = inode->i_blkbits;
 
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -4552,17 +4608,18 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	trace_ext4_fallocate_enter(inode, offset, len, mode);
-	map.m_lblk = offset >> blkbits;
+	lblk = offset >> blkbits;
 	/*
 	 * We can't just convert len to max_blocks because
 	 * If blocksize = 4096 offset = 3072 and len = 2048
 	 */
 	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
-		- map.m_lblk;
-	/*
-	 * credits to insert 1 extent into extent tree
-	 */
-	credits = ext4_chunk_trans_blocks(inode, max_blocks);
+		- lblk;
+
+	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
+	if (mode & FALLOC_FL_KEEP_SIZE)
+		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
+
 	mutex_lock(&inode->i_mutex);
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
@@ -4573,46 +4630,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 			goto out;
 	}
 
-	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
-	if (mode & FALLOC_FL_KEEP_SIZE)
-		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
-	/*
-	 * Don't normalize the request if it can fit in one extent so
-	 * that it doesn't get unnecessarily split into multiple
-	 * extents.
-	 */
-	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
-		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
-
-retry:
-	while (ret >= 0 && ret < max_blocks) {
-		map.m_lblk = map.m_lblk + ret;
-		map.m_len = max_blocks = max_blocks - ret;
-		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
-					    credits);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			break;
-		}
-		ret = ext4_map_blocks(handle, inode, &map, flags);
-		if (ret <= 0) {
-			ext4_debug("inode #%lu: block %u: len %u: "
-				   "ext4_ext_map_blocks returned %d",
-				   inode->i_ino, map.m_lblk,
-				   map.m_len, ret);
-			ext4_mark_inode_dirty(handle, inode);
-			ret2 = ext4_journal_stop(handle);
-			break;
-		}
-		ret2 = ext4_journal_stop(handle);
-		if (ret2)
-			break;
-	}
-	if (ret == -ENOSPC &&
-			ext4_should_retry_alloc(inode->i_sb, &retries)) {
-		ret = 0;
-		goto retry;
-	}
+	ret = ext4_alloc_file_blocks(file, lblk, max_blocks, flags, mode);
+	if (ret)
+		goto out;
 
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
 	if (IS_ERR(handle))
@@ -4620,7 +4640,7 @@ retry:
 
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 
-	if (ret > 0 && new_size) {
+	if (!ret && new_size) {
 		if (new_size > i_size_read(inode))
 			i_size_write(inode, new_size);
 		if (new_size > EXT4_I(inode)->i_disksize)
@@ -4633,9 +4653,8 @@ retry:
 	ext4_journal_stop(handle);
 out:
 	mutex_unlock(&inode->i_mutex);
-	trace_ext4_fallocate_exit(inode, offset, max_blocks,
-				ret > 0 ? ret2 : ret);
-	return ret > 0 ? ret2 : ret;
+	trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
+	return ret;
 }
 
 /*
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
