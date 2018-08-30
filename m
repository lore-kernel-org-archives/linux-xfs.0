Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbeH3UNA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 16:13:00 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
Date: Thu, 30 Aug 2018 11:10:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>

We disabled FIBMAP/bmap calls for reflinked files because swap will then
writes directly to the blocks, bypassing COW mechanisms, and breaking
copy on write.  As noted in commit db1327b, this restriction also breaks
bootloaders that want to use the FIBMAP ioctl.

Rather than disabling the entire mapping interface for everyone just
because swapon may abuse the info, teach xfs_iomap_swapfile_activate()
to reject activation for reflinked files, and re-enable the FIBMAP
interface.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

yes, other FIBMAP users could also abuse this information, but
disallowing mapping because somebody might do something dumb with
it seems very heavy handed... thoughts? 

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8eb3ba3d4d00..b75a7f37bdd9 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1382,15 +1382,10 @@ xfs_vm_bmap(
 	trace_xfs_vm_bmap(ip);
 
 	/*
-	 * The swap code (ab-)uses ->bmap to get a block mapping and then
-	 * bypasses the file system for actual I/O.  We really can't allow
-	 * that on reflinks inodes, so we have to skip out here.  And yes,
-	 * 0 is the magic code for a bmap error.
-	 *
 	 * Since we don't pass back blockdev info, we can't return bmap
-	 * information for rt files either.
+	 * information for rt files.
 	 */
-	if (xfs_is_reflink_inode(ip) || XFS_IS_REALTIME_INODE(ip))
+	if (XFS_IS_REALTIME_INODE(ip))
 		return 0;
 	return iomap_bmap(mapping, block, &xfs_iomap_ops);
 }
@@ -1477,7 +1472,13 @@ xfs_iomap_swapfile_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_find_bdev_for_inode(file_inode(swap_file));
+	struct inode			*inode = file_inode(swap_file);
+
+	/* Cannot allow swap to write directly to reflinked files/blocks */
+	if (xfs_is_reflink_inode(XFS_I(inode)))
+		return -EOPNOTSUPP;
+
+	sis->bdev = xfs_find_bdev_for_inode(inode);
 	return iomap_swapfile_activate(sis, swap_file, span, &xfs_iomap_ops);
 }
 
