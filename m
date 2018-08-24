Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50759 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbeHXMen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 08:34:43 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] xfs: fix GPF in swapfile_activate of file from overlayfs
Date: Fri, 24 Aug 2018 12:02:51 +0300
Message-Id: <1535101371-26461-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Since overlayfs implements stacked file operations, f_inode
is no longer euqivalent to f_mapping->host and xfs should use
the latter, same as generic_swapfile_activate().

Using f_inode results in an attempt to dereference an xfs_inode
struct from an ovl_inode pointer:

 CPU: 0 PID: 2462 Comm: swapon Not tainted
 4.18.0-xfstests-12721-g33e17876ea4e #3402
 RIP: 0010:xfs_find_bdev_for_inode+0x23/0x2f
 Call Trace:
  xfs_iomap_swapfile_activate+0x1f/0x43
  __se_sys_swapon+0xb1a/0xee9

Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Darrick/Dave,

Running "./check -overlay" on master crashes kernel on swap tests.
Please send this fix for rc1/rc2 or ack it so Miklos could apply it.

Thanks,
Amir.

 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 49f5f5896a43..09f093f89b19 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1012,7 +1012,7 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_find_bdev_for_inode(file_inode(swap_file));
+	sis->bdev = xfs_find_bdev_for_inode(swap_file->f_mapping->host);
 	return iomap_swapfile_activate(sis, swap_file, span, &xfs_iomap_ops);
 }
 
-- 
2.7.4
