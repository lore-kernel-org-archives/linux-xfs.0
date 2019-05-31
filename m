Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34960 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfEaQr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 May 2019 12:47:28 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 9/9] fuse: copy_file_range needs to strip setuid bits and update timestamps
Date: Fri, 31 May 2019 19:47:01 +0300
Message-Id: <20190531164701.15112-10-amir73il@gmail.com>
In-Reply-To: <20190531164701.15112-1-amir73il@gmail.com>
References: <20190531164701.15112-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

Like ->write_iter(), we update mtime and strip setuid of dst file before
copy and like ->read_iter(), we update atime of src file after copy.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Miklos Szeredi <miklos@szeredi.hu>
---
 fs/fuse/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 569baf286835..eab00cd089e8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3131,6 +3131,10 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 
 	inode_lock(inode_out);
 
+	err = file_modified(file_out);
+	if (err)
+		goto out;
+
 	if (fc->writeback_cache) {
 		err = filemap_write_and_wait_range(inode_out->i_mapping,
 						   pos_out, pos_out + len);
@@ -3172,6 +3176,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 		clear_bit(FUSE_I_SIZE_UNSTABLE, &fi_out->state);
 
 	inode_unlock(inode_out);
+	file_accessed(file_in);
 
 	return err;
 }
-- 
2.17.1
