Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938682AbdAIPkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:22 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 26/32] xfs: don't cap maximum dedupe request length
Date: Mon,  9 Jan 2017 16:38:57 +0100
Message-Id: <1483976343-661-27-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1bb33a98702d8360947f18a44349df75ba555d5d upstream.

After various discussions on linux-fsdevel, it has been decided that it
is not necessary to cap the length of a dedupe request, and that
correctly-written userspace client programs will be able to absorb the
change.  Therefore, remove the length clamping behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_file.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6e4f7f9..9a5d64b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -939,7 +939,6 @@ xfs_file_clone_range(
 				     len, false);
 }
 
-#define XFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
 STATIC ssize_t
 xfs_file_dedupe_range(
 	struct file	*src_file,
@@ -950,14 +949,6 @@ xfs_file_dedupe_range(
 {
 	int		error;
 
-	/*
-	 * Limit the total length we will dedupe for each operation.
-	 * This is intended to bound the total time spent in this
-	 * ioctl to something sane.
-	 */
-	if (len > XFS_MAX_DEDUPE_LEN)
-		len = XFS_MAX_DEDUPE_LEN;
-
 	error = xfs_reflink_remap_range(src_file, loff, dst_file, dst_loff,
 				     len, true);
 	if (error)
-- 
2.1.4

