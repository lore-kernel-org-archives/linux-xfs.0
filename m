Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752614AbdF2NUG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 09:20:06 -0400
From: jlayton@kernel.org
Subject: [PATCH v8 03/18] fs: check for writeback errors after syncing out buffers in generic_file_fsync
Date: Thu, 29 Jun 2017 09:19:39 -0400
Message-Id: <20170629131954.28733-4-jlayton@kernel.org>
In-Reply-To: <20170629131954.28733-1-jlayton@kernel.org>
References: <20170629131954.28733-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

ext2 currently does a test+clear of the AS_EIO flag, which is
is problematic for some coming changes.

What we really need to do instead is call filemap_check_errors
in __generic_file_fsync after syncing out the buffers. That
will be sufficient for this case, and help other callers detect
these errors properly as well.

With that, we don't need to twiddle it in ext2.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/ext2/file.c | 5 +----
 fs/libfs.c     | 3 ++-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index b21891a6bfca..d34d32bdc944 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -174,15 +174,12 @@ int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	int ret;
 	struct super_block *sb = file->f_mapping->host->i_sb;
-	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 
 	ret = generic_file_fsync(file, start, end, datasync);
-	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
+	if (ret == -EIO)
 		/* We don't really know where the IO error happened... */
 		ext2_error(sb, __func__,
 			   "detected IO error when writing metadata buffers");
-		ret = -EIO;
-	}
 	return ret;
 }
 
diff --git a/fs/libfs.c b/fs/libfs.c
index a04395334bb1..1dec90819366 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -991,7 +991,8 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 
 out:
 	inode_unlock(inode);
-	return ret;
+	err = filemap_check_errors(inode->i_mapping);
+	return ret ? ret : err;
 }
 EXPORT_SYMBOL(__generic_file_fsync);
 
-- 
2.13.0

