Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35414 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934979AbcIWIiy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 04:38:54 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 3/3] ovl: use vfs_clone_file_range() for copy up if possible
Date: Fri, 23 Sep 2016 11:38:12 +0300
Message-Id: <1474619892-5113-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1474619892-5113-1-git-send-email-amir73il@gmail.com>
References: <1474619892-5113-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

When copying up within the same fs, try to use vfs_clone_file_range().
This is very efficient when lower and upper are on the same fs
with file reflink support. If vfs_clone_file_range() fails for any
reason, copy up falls back to the regular data copy code.

Tested correct behavior when lower and upper are on:
1. same ext4 (copy)
2. same xfs + reflink patches + mkfs.xfs (copy)
3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink)
4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)

For comparison, on my laptop, xfstest overlay/001 (copy up of large
sparse files) takes less than 1 second in the xfs reflink setup vs.
25 seconds on the rest of the setups.

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 43fdc27..93f0a34 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -136,6 +136,13 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		goto out_fput;
 	}
 
+	/* Try to use clone_file_range to clone up within the same fs */
+	error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
+	if (!error)
+		goto out;
+	/* Couldn't clone, so now we try to copy the data */
+	error = 0;
+
 	/* FIXME: copy up sparse files efficiently */
 	while (len) {
 		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
@@ -161,6 +168,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		len -= bytes;
 	}
 
+out:
 	fput(new_file);
 out_fput:
 	fput(old_file);
-- 
2.7.4

