Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36331 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757539AbcIHPbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 11:31:05 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: use copy_file_range for copy up if possible
Date: Thu,  8 Sep 2016 18:29:54 +0300
Message-Id: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

When copying up within the same fs, try to use f_op->copy_file_range().
This becomes very efficient when lower and upper are on the same fs
with file reflink support.

Tested correct behavior when lower and upper are on:
1. same ext4 (copy)
2. same xfs + reflink patches + mkfs.xfs (copy)
3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (clone)
4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)

Verified that all the overlay xfstests pass in the 'same xfs+reflink'
setup.

For comparison, on my laptop, xfstest overlay/001 (copy up of large
sparse files) takes less than 1 second in the xfs reflink setup vs.
25 seconds on the rest of the setups.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 43fdc27..400567b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -121,6 +121,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	struct file *new_file;
 	loff_t old_pos = 0;
 	loff_t new_pos = 0;
+	int try_copy_file = 0;
 	int error = 0;
 
 	if (len == 0)
@@ -136,6 +137,13 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		goto out_fput;
 	}
 
+	/*
+	 * When copying up within the same fs, try to use fs's copy_file_range
+	 */
+	if (file_inode(old_file)->i_sb == file_inode(new_file)->i_sb) {
+		try_copy_file = (new_file->f_op->copy_file_range != NULL);
+	}
+
 	/* FIXME: copy up sparse files efficiently */
 	while (len) {
 		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
@@ -149,9 +157,23 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 			break;
 		}
 
-		bytes = do_splice_direct(old_file, &old_pos,
-					 new_file, &new_pos,
-					 this_len, SPLICE_F_MOVE);
+		if (try_copy_file) {
+			bytes = new_file->f_op->copy_file_range(
+					old_file, old_pos,
+					new_file, new_pos,
+					len, 0);
+			if (bytes == -EOPNOTSUPP) {
+				try_copy_file = 0;
+				continue;
+			} else if (bytes > 0) {
+				old_pos += bytes;
+				new_pos += bytes;
+			}
+		} else {
+			bytes = do_splice_direct(old_file, &old_pos,
+					new_file, &new_pos,
+					this_len, SPLICE_F_MOVE);
+		}
 		if (bytes <= 0) {
 			error = bytes;
 			break;
-- 
2.7.4

