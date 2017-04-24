Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1171055AbdDXNYF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:24:05 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v3 05/20] orangefs: don't call filemap_write_and_wait from fsync
Date: Mon, 24 Apr 2017 09:22:44 -0400
Message-Id: <20170424132259.8680-6-jlayton@redhat.com>
In-Reply-To: <20170424132259.8680-1-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

Orangefs doesn't do buffered writes yet, so there's no point in
initiating and waiting for writeback.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/orangefs/file.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/orangefs/file.c b/fs/orangefs/file.c
index e6bbc8083d77..17ab42c4db52 100644
--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -646,14 +646,11 @@ static int orangefs_fsync(struct file *file,
 		       loff_t end,
 		       int datasync)
 {
-	int ret = -EINVAL;
+	int ret;
 	struct orangefs_inode_s *orangefs_inode =
 		ORANGEFS_I(file_inode(file));
 	struct orangefs_kernel_op_s *new_op = NULL;
 
-	/* required call */
-	filemap_write_and_wait_range(file->f_mapping, start, end);
-
 	new_op = op_alloc(ORANGEFS_VFS_OP_FSYNC);
 	if (!new_op)
 		return -ENOMEM;
-- 
2.9.3

