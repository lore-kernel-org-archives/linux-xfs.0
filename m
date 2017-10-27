Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752190AbdJ0Mxi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 08:53:38 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D4630C034E16
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2017 12:53:37 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs: flush the range before zero partial block range on truncate down
Date: Fri, 27 Oct 2017 20:53:28 +0800
Message-Id: <20171027125328.25001-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>

On truncate down, if new size is not block size aligned, we zero the
rest of block via iomap_truncate_page() to avoid exposing stale data
to user, and iomap_truncate_page() skips zeroing if the range is
already in unwritten status or a hole.

But it's possible that a buffer write overwrites the unwritten
extent, which won't be converted to a normal extent until I/O
completion, and iomap_truncate_page() skips zeroing wrongly because
of the not-converted unwritten extent. This would cause a subsequent
mmap read sees non-zeros beyond EOF.

I occasionally see this in fsx runs in fstests generic/112, a
simplified fsx operation sequence is like (assuming 4k block size
xfs):

  fallocate 0x0 0x1000 0x0 keep_size
  write 0x0 0x1000 0x0
  truncate 0x0 0x800 0x1000
  punch_hole 0x0 0x800 0x800
  mapread 0x0 0x800 0x800

This is introduced along with the switch to iomap based buffer write
support, commit 68a9f5e7007c ("xfs: implement iomap based buffered
write path"), because previously, block_truncate_page() did fs block
based check and only skipped holes.

Fix it by flushing the range we're going to zero to ensure
iomap_truncate_page() sees the final extent state and zeros the
range correctly.

Also fixed the wrong 'end' param of filemap_write_and_wait_range()
call while we're at it, the 'end' is inclusive and should be
'newsize - 1'.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

An fstests test case followed, I've verified it could reproduce the
bug reliably and quickly.

 fs/xfs/xfs_iops.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 17081c77ef86..cd4c612cc23c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -824,6 +824,7 @@ xfs_setattr_size(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	struct address_space	*mapping = inode->i_mapping;
 	xfs_off_t		oldsize, newsize;
 	struct xfs_trans	*tp;
 	int			error;
@@ -878,8 +879,22 @@ xfs_setattr_size(
 	if (newsize > oldsize) {
 		error = xfs_zero_eof(ip, newsize, oldsize, &did_zeroing);
 	} else {
-		error = iomap_truncate_page(inode, newsize, &did_zeroing,
-				&xfs_iomap_ops);
+		/*
+		 * Firstly write out the range that will be zeroed, otherwise
+		 * iomap_truncate_page() may skip zeroing this range wrongly.
+		 * Because the range could still be dirty after buffer writes
+		 * over unwritten extents, and the extent still stays in
+		 * UNWRITTEN state, because the conversion only happens at I/O
+		 * completion.
+		 */
+		unsigned int blocksize = i_blocksize(inode);
+		unsigned int off = newsize & (blocksize - 1);
+		if (off && mapping->nrpages)
+			error = filemap_write_and_wait_range(mapping, newsize,
+					newsize + (blocksize - off) - 1);
+		if (!error)
+			error = iomap_truncate_page(inode, newsize,
+					&did_zeroing, &xfs_iomap_ops);
 	}
 
 	if (error)
@@ -895,8 +910,8 @@ xfs_setattr_size(
 	 */
 	if (did_zeroing ||
 	    (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
-		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-						      ip->i_d.di_size, newsize);
+		error = filemap_write_and_wait_range(mapping, ip->i_d.di_size,
+							newsize - 1);
 		if (error)
 			return error;
 	}
-- 
2.13.6

