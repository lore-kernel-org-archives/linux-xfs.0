Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752190AbdGGV2L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 17:28:11 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 3/3] ext4: Add IOMAP_REPORT support for inline data
Date: Fri,  7 Jul 2017 23:28:01 +0200
Message-Id: <1499462881-4238-4-git-send-email-agruenba@redhat.com>
In-Reply-To: <1499462881-4238-1-git-send-email-agruenba@redhat.com>
References: <1499462881-4238-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

Fixes iomap_seek_{hole,data} for files with inline data (on filesystems
with the inline_data feature).  In addition, this will make converting
ext4 to use iomap_fiemap easier.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ext4/ext4.h   |  4 ++++
 fs/ext4/inline.c | 33 +++++++++++++++++++++++++++++++++
 fs/ext4/inode.c  |  9 +++++++--
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index eb0a1f2..3eae6ae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3017,6 +3017,10 @@ extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
 extern int ext4_inline_data_fiemap(struct inode *inode,
 				   struct fiemap_extent_info *fieinfo,
 				   int *has_inline, __u64 start, __u64 len);
+
+struct iomap;
+extern int ext4_inline_data_iomap(struct inode *inode, struct iomap *iomap);
+
 extern int ext4_try_to_evict_inline_data(handle_t *handle,
 					 struct inode *inode,
 					 int needed);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8d141c0..e9d0ab1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -12,6 +12,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/iomap.h>
 #include <linux/fiemap.h>
 
 #include "ext4_jbd2.h"
@@ -1827,6 +1828,38 @@ int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 	return ret;
 }
 
+int ext4_inline_data_iomap(struct inode *inode, struct iomap *iomap)
+{
+	__u64 physical;
+	int error = -ENOENT;
+	struct ext4_iloc iloc;
+
+	down_read(&EXT4_I(inode)->xattr_sem);
+	if (!ext4_has_inline_data(inode))
+		goto out;
+
+	error = ext4_get_inode_loc(inode, &iloc);
+	if (error)
+		goto out;
+
+	physical = (__u64)iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
+	physical += (char *)ext4_raw_inode(&iloc) - iloc.bh->b_data;
+	physical += offsetof(struct ext4_inode, i_block);
+
+	brelse(iloc.bh);
+
+	iomap->physical = physical;
+	iomap->offset = 0;
+	iomap->length = min_t(loff_t, ext4_get_inline_size(inode),
+			      i_size_read(inode));
+	iomap->type = IOMAP_MAPPED;
+	iomap->flags = IOMAP_F_INLINE;
+
+out:
+	up_read(&EXT4_I(inode)->xattr_sem);
+	return error;
+}
+
 int ext4_inline_data_fiemap(struct inode *inode,
 			    struct fiemap_extent_info *fieinfo,
 			    int *has_inline, __u64 start, __u64 len)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 82f3f7d..e2b0a8a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3361,8 +3361,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	bool delalloc = false;
 	int ret;
 
-	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
-		return -ERANGE;
+	if (ext4_has_inline_data(inode)) {
+		if (WARN_ON_ONCE(!(flags & IOMAP_REPORT)))
+			return -ERANGE;
+		if (!ext4_inline_data_iomap(inode, iomap) &&
+		    offset < iomap->length)
+			return 0;
+	}
 
 	map.m_lblk = first_block;
 	map.m_len = last_block - first_block + 1;
-- 
2.7.5

