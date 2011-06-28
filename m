Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SFXPOT236237 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:33:26 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E1B31770BDE
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id s33a6EwQhV4Lk8yO for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:25 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/4] Btrfs: implement our own ->llseek
Date: Tue, 28 Jun 2011 11:33:16 -0400
Message-Id: <1309275199-10801-2-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk

In order to handle SEEK_HOLE/SEEK_DATA we need to implement our own llseek.
Basically for the normal SEEK_*'s we will just defer to the generic helper, and
for SEEK_HOLE/SEEK_DATA we will use our fiemap helper to figure out the nearest
hole or data.  Currently this helper doesn't check for delalloc bytes for
prealloc space, so for now treat prealloc as data until that is fixed.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h |    3 +
 fs/btrfs/file.c  |  148 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 150 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f30ac05..32be5e0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2505,6 +2505,9 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
 /* inode.c */
+struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
+					   size_t pg_offset, u64 start, u64 len,
+					   int create);
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
 #if defined(ClearPageFsMisc) && !defined(ClearPageChecked)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fa4ef18..bd4d061 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1664,8 +1664,154 @@ out:
 	return ret;
 }
 
+static int find_desired_extent(struct inode *inode, loff_t *offset, int origin)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_map *em;
+	struct extent_state *cached_state = NULL;
+	u64 lockstart = *offset;
+	u64 lockend = i_size_read(inode);
+	u64 start = *offset;
+	u64 orig_start = *offset;
+	u64 len = i_size_read(inode);
+	u64 last_end = 0;
+	int ret = 0;
+
+	lockend = max_t(u64, root->sectorsize, lockend);
+	if (lockend <= lockstart)
+		lockend = lockstart + root->sectorsize;
+
+	len = lockend - lockstart + 1;
+
+	len = max_t(u64, len, root->sectorsize);
+	if (inode->i_size == 0)
+		return -ENXIO;
+
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, 0,
+			 &cached_state, GFP_NOFS);
+
+	/*
+	 * Delalloc is such a pain.  If we have a hole and we have pending
+	 * delalloc for a portion of the hole we will get back a hole that
+	 * exists for the entire range since it hasn't been actually written
+	 * yet.  So to take care of this case we need to look for an extent just
+	 * before the position we want in case there is outstanding delalloc
+	 * going on here.
+	 */
+	if (origin == SEEK_HOLE && start != 0) {
+		if (start <= root->sectorsize)
+			em = btrfs_get_extent_fiemap(inode, NULL, 0, 0,
+						     root->sectorsize, 0);
+		else
+			em = btrfs_get_extent_fiemap(inode, NULL, 0,
+						     start - root->sectorsize,
+						     root->sectorsize, 0);
+		if (IS_ERR(em)) {
+			ret = -ENXIO;
+			goto out;
+		}
+		last_end = em->start + em->len;
+		if (em->block_start == EXTENT_MAP_DELALLOC)
+			last_end = min_t(u64, last_end, inode->i_size);
+		free_extent_map(em);
+	}
+
+	while (1) {
+		em = btrfs_get_extent_fiemap(inode, NULL, 0, start, len, 0);
+		if (IS_ERR(em)) {
+			ret = -ENXIO;
+			break;
+		}
+
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+				if (last_end <= orig_start) {
+					free_extent_map(em);
+					ret = -ENXIO;
+					break;
+				}
+			}
+
+			if (origin == SEEK_HOLE) {
+				*offset = start;
+				free_extent_map(em);
+				break;
+			}
+		} else {
+			if (origin == SEEK_DATA) {
+				if (em->block_start == EXTENT_MAP_DELALLOC) {
+					if (start >= inode->i_size) {
+						free_extent_map(em);
+						ret = -ENXIO;
+						break;
+					}
+				}
+
+				*offset = start;
+				free_extent_map(em);
+				break;
+			}
+		}
+
+		start = em->start + em->len;
+		last_end = em->start + em->len;
+
+		if (em->block_start == EXTENT_MAP_DELALLOC)
+			last_end = min_t(u64, last_end, inode->i_size);
+
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+			free_extent_map(em);
+			ret = -ENXIO;
+			break;
+		}
+		free_extent_map(em);
+		cond_resched();
+	}
+	if (!ret)
+		*offset = min(*offset, inode->i_size);
+out:
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+			     &cached_state, GFP_NOFS);
+	return ret;
+}
+
+static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	int ret;
+
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+	case SEEK_CUR:
+		offset = generic_file_llseek_unlocked(file, offset, origin);
+		goto out;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		ret = find_desired_extent(inode, &offset, origin);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
+	}
+
+	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
+		return -EINVAL;
+	if (offset > inode->i_sb->s_maxbytes)
+		return -EINVAL;
+
+	/* Special lock needed here? */
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+out:
+	mutex_unlock(&inode->i_mutex);
+	return offset;
+}
+
 const struct file_operations btrfs_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= btrfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read       = generic_file_aio_read,
-- 
1.7.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
