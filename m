Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63760 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbeKGQBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:09 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/16] xfs: extent shifting doesn't fully invalidate page cache
Date: Wed,  7 Nov 2018 17:31:15 +1100
Message-Id: <20181107063127.3902-5-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The extent shifting code uses a flush and invalidate mechainsm prior
to shifting extents around. This is similar to what
xfs_free_file_space() does, but it doesn't take into account things
like page cache vs block size differences, and it will fail if there
is a page that it currently busy.

xfs_flush_unmap_range() handles all of these cases, so just convert
xfs_prepare_shift() to us that mechanism rather than having it's own
special sauce.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5d263dfdb3bc..167ff4297e5c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1195,13 +1195,7 @@ xfs_prepare_shift(
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
 	 */
-	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping, offset, -1);
-	if (error)
-		return error;
-	error = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
-					offset >> PAGE_SHIFT, -1);
-	if (error)
-		return error;
+	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
 
 	/*
 	 * Clean out anything hanging around in the cow fork now that
-- 
2.19.1
