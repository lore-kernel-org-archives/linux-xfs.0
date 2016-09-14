Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35856 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761871AbcINMn4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 08:43:56 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/4] ovl: use vfs_clone_file_range() for copy up if possible
Date: Wed, 14 Sep 2016 15:43:12 +0300
Message-Id: <1473856994-27463-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

When copying up within the same fs, try to use vfs_clone_file_range().
This is very efficient when lower and upper are on the same fs
with file reflink support. If vfs_clone_file_range() fails because
lower and upper are not on the same fs or if fs has no reflink support,
copy up falls back to the regular data copy code.

Tested correct behavior when lower and upper are on:
1. same ext4 (copy)
2. same xfs + reflink patches + mkfs.xfs (copy)
3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink)
4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)

For comparison, on my laptop, xfstest overlay/001 (copy up of large
sparse files) takes less than 1 second in the xfs reflink setup vs.
25 seconds on the rest of the setups.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 43fdc27..ba039f8 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -136,6 +136,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		goto out_fput;
 	}
 
+	/* Try to use clone_file_range to clone up within the same fs */
+	error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
+	if (!error)
+		goto out;
+	/* If we can clone but clone failed - abort */
+	if (error != -EXDEV && error != -EOPNOTSUPP)
+		goto out;
+	/* Can't clone, so now we try to copy the data */
+	error = 0;
+
 	/* FIXME: copy up sparse files efficiently */
 	while (len) {
 		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
@@ -160,7 +170,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 
 		len -= bytes;
 	}
-
+out:
 	fput(new_file);
 out_fput:
 	fput(old_file);
-- 
2.7.4

