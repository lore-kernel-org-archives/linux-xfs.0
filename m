Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36471 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932765AbcILPH3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2016 11:07:29 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/4] ovl: use vfs_copy_file_range() to copy up file data
Date: Mon, 12 Sep 2016 18:06:43 +0300
Message-Id: <1473692803-11964-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1473692803-11964-1-git-send-email-amir73il@gmail.com>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <1473692803-11964-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

Use vfs_copy_file_range() helper instead of calling do_splice_direct()
when copying up file data.
When copying up within the same fs, which supports copy_file_range(),
fs implementation can be more efficient then do_splice_direct().
vfs_copy_file_range() helper falls back to do_splice_direct() if
it cannot use the file system's copy_file_range() implementation.

Tested correct behavior when lower and upper are on:
1. same ext4 (copy)
2. same xfs + reflink patches + mkfs.xfs (copy)
3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (clone)
4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)

For comparison, on my laptop, xfstest overlay/001 (copy up of large
sparse files) takes less than 1 second in the xfs reflink setup vs.
25 seconds on the rest of the setups.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e432d7e..32ea54f 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -159,15 +159,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 			break;
 		}
 
-		bytes = do_splice_direct(old_file, &old_pos,
-					 new_file, &new_pos,
-					 this_len, SPLICE_F_MOVE);
+		bytes = vfs_copy_file_range(old_file, old_pos,
+					    new_file, new_pos,
+					    this_len, 0);
 		if (bytes <= 0) {
 			error = bytes;
 			break;
 		}
-		WARN_ON(old_pos != new_pos);
 
+		old_pos += bytes;
+		new_pos += bytes;
 		len -= bytes;
 	}
 
-- 
2.7.4

