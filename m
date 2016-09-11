Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34804 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754576AbcIKKvN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2016 06:51:13 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v1] ovl: use copy_file_clone for copy up if possible
Date: Sun, 11 Sep 2016 13:50:21 +0300
Message-Id: <1473591021-26915-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

When copying up within the same fs, try to use f_op->clone_file_range().
This becomes very efficient when lower and upper are on the same fs
with file reflink support.

Tested correct behavior when lower and upper are on:
1. same ext4 (copy)
2. same xfs + reflink patches + mkfs.xfs (copy)
3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (clone)
4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)

Verified that all the overlay xfstests pass in the 'same fs'
setups.

For comparison, on my laptop, xfstest overlay/001 (copy up of large
sparse files) takes less than 1 second in the xfs reflink setup vs.
25 seconds on the rest of the setups.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Notes:
    V1:
    - Replace iteravite call to copy_file_range() with
      a single atomic call to clone_file_range()
    - Add a TODO comment to consider calling vfs_copy_file_range()
      instead of do_splice_direct() (*)
    
    (*) Changes suggested by Dave Chinner:
    1. Move the cross-fs check from vfs_copy_file_range()
       helper up to the copy_file_range syscall
    2. Allow vfs_copy_file_range() to handle cross-fs copy
       by falling back directly to do_splice_direct(),
       without attempting copy_file_range()
    3. Replace copy_up call to do_splice_direct()
       with call to vfs_copy_file_range()
    
    The benefits of these extra changes to real world use case
    have not been demonstrated. In theory, these changes should benefit
    a setup of lower and upper dirs both on the same nfs/cifs mount.

 fs/overlayfs/copy_up.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 43fdc27..a3fd658 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -136,6 +136,21 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		goto out_fput;
 	}
 
+	/*
+	 * When copying up within the same fs, try to use clone_file_range
+	 */
+	if (file_inode(old_file)->i_sb == file_inode(new_file)->i_sb &&
+			new_file->f_op->clone_file_range) {
+		error = new_file->f_op->clone_file_range(old_file, 0,
+							 new_file, 0,
+							 len);
+		/* on failure to clone entire len, fallback to splice loop */
+		if (error)
+			error = 0;
+		else
+			len = 0;
+	}
+
 	/* FIXME: copy up sparse files efficiently */
 	while (len) {
 		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
@@ -149,6 +164,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 			break;
 		}
 
+		/* TODO: consider calling vfs_copy_file_range() instead */
 		bytes = do_splice_direct(old_file, &old_pos,
 					 new_file, &new_pos,
 					 this_len, SPLICE_F_MOVE);
-- 
2.7.4

