Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1035645AbdEXQmU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 12:42:20 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 09/10] xfs: nowait aio support
Date: Wed, 24 May 2017 11:41:49 -0500
Message-Id: <20170524164150.9492-10-rgoldwyn@suse.de>
In-Reply-To: <20170524164150.9492-1-rgoldwyn@suse.de>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If IOCB_NOWAIT is set, bail if the i_rwsem is not lockable
immediately.

IF IOMAP_NOWAIT is set, return EAGAIN in xfs_file_iomap_begin
if it needs allocation either due to file extension, writing to a hole,
or COW or waiting for other DIOs to finish.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 19 ++++++++++++++-----
 fs/xfs/xfs_iomap.c | 17 +++++++++++++++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 35703a801372..b307940e7d56 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -541,8 +541,11 @@ xfs_file_dio_aio_write(
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
-	xfs_ilock(ip, iolock);
-
+	if (!xfs_ilock_nowait(ip, iolock)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		xfs_ilock(ip, iolock);
+	}
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
@@ -553,9 +556,15 @@ xfs_file_dio_aio_write(
 	 * otherwise demote the lock if we had to take the exclusive lock
 	 * for other reasons in xfs_file_aio_write_checks.
 	 */
-	if (unaligned_io)
-		inode_dio_wait(inode);
-	else if (iolock == XFS_IOLOCK_EXCL) {
+	if (unaligned_io) {
+		/* If we are going to wait for other DIO to finish, bail */
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (atomic_read(&inode->i_dio_count))
+				return -EAGAIN;
+		} else {
+			inode_dio_wait(inode);
+		}
+	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 94e5bdf7304c..8b0e3c1e086d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1016,6 +1016,15 @@ xfs_file_iomap_begin(
 
 	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
 		if (flags & IOMAP_DIRECT) {
+			/*
+			 * A reflinked inode will result in CoW alloc.
+			 * FIXME: It could still overwrite on unshared extents
+			 * and not need allocation.
+			 */
+			if (flags & IOMAP_NOWAIT) {
+				error = -EAGAIN;
+				goto out_unlock;
+			}
 			/* may drop and re-acquire the ilock */
 			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
 					&lockmode);
@@ -1033,6 +1042,14 @@ xfs_file_iomap_begin(
 
 	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
 		/*
+		 * If nowait is set bail since we are going to make
+		 * allocations.
+		 */
+		if (flags & IOMAP_NOWAIT) {
+			error = -EAGAIN;
+			goto out_unlock;
+		}
+		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
 		 * with the work writeback does. This is a completely arbitrary
-- 
2.12.0

