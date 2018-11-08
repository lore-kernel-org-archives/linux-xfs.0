Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:35615 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728311AbeKIH4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 02:56:50 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] vfs: vfs_dedupe_file_range() doesn't return EOPNOTSUPP
Date: Fri,  9 Nov 2018 09:19:08 +1100
Message-Id: <20181108221909.27602-2-david@fromorbit.com>
In-Reply-To: <20181108221909.27602-1-david@fromorbit.com>
References: <20181108221909.27602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It returns EINVAL when the operation is not supported by the
filesystem. Fix it to return EOPNOTSUPP to be consistent with
the man page and clone_file_range().

Clean up the inconsistent error return handling while I'm there.
(I know, lipstick on a pig, but every little bit helps...)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/read_write.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index bfcb4ced5664..aa43224bcec6 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2094,17 +2094,18 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	off = same->src_offset;
 	len = same->src_length;
 
-	ret = -EISDIR;
+	if (!file->f_op->remap_file_range)
+		return -EOPNOTSUPP;
+
 	if (S_ISDIR(src->i_mode))
-		goto out;
+		return -EISDIR;
 
-	ret = -EINVAL;
 	if (!S_ISREG(src->i_mode))
-		goto out;
+		return -EINVAL;
 
 	ret = remap_verify_area(file, off, len, false);
 	if (ret < 0)
-		goto out;
+		return ret;
 	ret = 0;
 
 	if (off + len > i_size_read(src))
@@ -2147,10 +2148,8 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 		fdput(dst_fd);
 next_loop:
 		if (fatal_signal_pending(current))
-			goto out;
+			break;
 	}
-
-out:
 	return ret;
 }
 EXPORT_SYMBOL(vfs_dedupe_file_range);
-- 
2.19.1
