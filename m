Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55553 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751722AbdCAA6c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 19:58:32 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 7/8] nowait aio: xfs
Date: Tue, 28 Feb 2017 17:36:09 -0600
Message-Id: <20170228233610.25456-8-rgoldwyn@suse.de>
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If IOCB_NOWAIT is set, bail if the i_rwsem is not lockable
immediately.

IF IOMAP_NOWAIT is set, return EAGAIN in xfs_file_iomap_begin
if it needs allocation either due to file extending, writing to a hole,
or COW.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/xfs/xfs_file.c  | 9 +++++++--
 fs/xfs/xfs_iomap.c | 9 +++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index bbb9eb6..7e16a83 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -528,12 +528,17 @@ xfs_file_dio_aio_write(
 	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
 		unaligned_io = 1;
 		iolock = XFS_IOLOCK_EXCL;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
 	} else {
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
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1aa3abd..84f981a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1020,6 +1020,11 @@ xfs_file_iomap_begin(
 	if ((flags & IOMAP_REPORT) ||
 	    (xfs_is_reflink_inode(ip) &&
 	     (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT))) {
+		/* Allocations due to reflinks */
+		if ((flags & IOMAP_NOWAIT) && !(flags & IOMAP_REPORT)) {
+			error = -EAGAIN;
+			goto out_unlock;
+		}
 		/* Trim the mapping to the nearest shared extent boundary. */
 		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
 				&trimmed);
@@ -1049,6 +1054,10 @@ xfs_file_iomap_begin(
 	}
 
 	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
+		if (flags & IOMAP_NOWAIT) {
+			error = -EAGAIN;
+			goto out_unlock;
+		}
 		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
-- 
2.10.2

