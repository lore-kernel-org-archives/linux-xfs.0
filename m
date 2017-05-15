Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:52027 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933582AbdEONrF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 09:47:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] fs: xfs: add DAX dependency
Date: Mon, 15 May 2017 15:44:01 +0200
Message-Id: <20170515134508.2713243-2-arnd@arndb.de>
In-Reply-To: <20170515134508.2713243-1-arnd@arndb.de>
References: <20170515134508.2713243-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org

We can now build xfs while CONFIG_DAX is set to 'm', resulting in a
link error when xfs is built-in:

fs/xfs/xfs_iomap.o: In function `xfs_file_iomap_end':
fs/xfs/xfs_iomap.c:1152: undefined reference to `put_dax'
fs/xfs/xfs_iomap.o: In function `xfs_file_iomap_begin':
fs/xfs/xfs_iomap.c:1071: undefined reference to `dax_get_by_host'

Previously, XFS could only be built with CONFIG_DAX=y because of
the CONFIG_BLOCK dependency. The other users of dax handle this
differently:

- In ext2 and ext4, there are checks for CONFIG_FS_DAX around every
  API usage, and CONFIG_FS_DAX is only enabled when CONFIG_DAX is
  built-in.

- CONFIG_BLK_DEV_MD implies 'select DAX', so it's always enabled
  there as well.

This changes XFS to do the same as ext2/4 and only call into the
API conditionally.

Fixes: ef51042472f5 ("block, dax: move "select DAX" from BLOCK to FS_DAX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_iomap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a63f61c256bd..b732ba6f892c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1067,7 +1067,7 @@ xfs_file_iomap_begin(
 
 	/* optionally associate a dax device with the iomap bdev */
 	bdev = iomap->bdev;
-	if (blk_queue_dax(bdev->bd_queue))
+	if (IS_ENABLED(CONFIG_FS_DAX) && blk_queue_dax(bdev->bd_queue))
 		iomap->dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	else
 		iomap->dax_dev = NULL;
@@ -1149,7 +1149,9 @@ xfs_file_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	put_dax(iomap->dax_dev);
+	if (IS_ENABLED(CONFIG_FS_DAX))
+		put_dax(iomap->dax_dev);
+
 	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
 		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
 				length, written, iomap);
-- 
2.9.0

