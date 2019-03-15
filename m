Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbfCOOjE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Mar 2019 10:39:04 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E9FD6A8BE2
        for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2019 14:39:03 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8AC85C223
        for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2019 14:39:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: don't trip over uninitialized buffer on extent read of corrupted inode
Date: Fri, 15 Mar 2019 10:39:03 -0400
Message-Id: <20190315143903.6567-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We've had rather rare reports of bmap btree block corruption where
the bmap root block has a level count of zero. The root cause of the
corruption is so far unknown. We do have verifier checks to detect
this form of on-disk corruption, but this doesn't cover a memory
corruption variant of the problem. The latter is a reasonable
possibility because the root block is part of the inode fork and can
reside in-core for some time before inode extents are read.

If this occurs, it leads to a system crash such as the following:

 BUG: unable to handle kernel paging request at ffffffff00000221
 PF error: [normal kernel read fault]
 ...
 RIP: 0010:xfs_trans_brelse+0xf/0x200 [xfs]
 ...
 Call Trace:
  xfs_iread_extents+0x379/0x540 [xfs]
  xfs_file_iomap_begin_delay+0x11a/0xb40 [xfs]
  ? xfs_attr_get+0xd1/0x120 [xfs]
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  xfs_file_iomap_begin+0x4c4/0x6d0 [xfs]
  ? __vfs_getxattr+0x53/0x70
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  iomap_apply+0x63/0x130
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  iomap_file_buffered_write+0x62/0x90
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  xfs_file_buffered_aio_write+0xe4/0x3b0 [xfs]
  __vfs_write+0x150/0x1b0
  vfs_write+0xba/0x1c0
  ksys_pwrite64+0x64/0xa0
  do_syscall_64+0x5a/0x1d0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The crash occurs because xfs_iread_extents() attempts to release an
uninitialized buffer pointer as the level == 0 value prevented the
buffer from ever being allocated or read. Change the level > 0
assert to an explicit error check in xfs_iread_extents() to avoid
crashing the kernel in the event of localized, in-core inode
corruption.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 48502cb9990f..ae4c3b0d84db 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1191,7 +1191,10 @@ xfs_iread_extents(
 	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	ASSERT(level > 0);
+	if (unlikely(level == 0)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 
-- 
2.17.2
