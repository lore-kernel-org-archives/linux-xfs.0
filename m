Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:36689
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbeLCIee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:34 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/11] vfs: allow generic_copy_file_range to copy across devices
Date: Mon,  3 Dec 2018 19:34:15 +1100
Message-Id: <20181203083416.28978-11-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-1-david@fromorbit.com>
References: <20181203083416.28978-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

do_splice_direct() can copy across superblocks without problems.
Remove the same superblock restriction on this fallback code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/read_write.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4e0666de0d69..b0f231b10836 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1565,10 +1565,6 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    size_t len, unsigned int flags)
 {
-	/* Temporary, do_splice_direct supports cross-sb copies */
-	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
-		return -EXDEV;
-
 	return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
 			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
 }
-- 
2.19.1
