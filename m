Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37882 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727648AbfFYAsN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 20:48:13 -0400
Subject: [PATCH 2/2] xfs: convert extents in place for ZERO_RANGE
References: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <25a2ebbc-0ec9-f5dd-eba0-4101c80837dd@sandeen.net>
Date: Mon, 24 Jun 2019 19:48:11 -0500
MIME-Version: 1.0
In-Reply-To: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Rather than completely removing and re-allocating a range
during ZERO_RANGE fallocate calls, convert whole blocks in the
range using xfs_alloc_file_space(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)
and then zero the edges with xfs_zero_range()

(Note that this changes the rounding direction of the
xfs_alloc_file_space range, because we only want to hit whole
blocks within the range.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

<currently running fsx ad infinitum, so far so good>

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0a96c4d1718e..eae202bfe134 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1164,23 +1164,25 @@ xfs_zero_file_space(
 
 	blksize = 1 << mp->m_sb.sb_blocklog;
 
+	error = xfs_flush_unmap_range(ip, offset, len);
+	if (error)
+		return error;
 	/*
-	 * Punch a hole and prealloc the range. We use hole punch rather than
-	 * unwritten extent conversion for two reasons:
-	 *
-	 * 1.) Hole punch handles partial block zeroing for us.
-	 *
-	 * 2.) If prealloc returns ENOSPC, the file range is still zero-valued
-	 * by virtue of the hole punch.
+	 * Convert whole blocks in the range to unwritten, then call iomap
+	 * via xfs_zero_range to zero the range.  iomap will skip holes and
+	 * unwritten extents, and just zero the edges if needed.  If conversion
+	 * fails, iomap will simply write zeros to the whole range.
+	 * nb: always_cow doesn't support unwritten extents.
 	 */
-	error = xfs_free_file_space(ip, offset, len);
-	if (error || xfs_is_always_cow_inode(ip))
-		return error;
+	if (!xfs_is_always_cow_inode(ip))
+		xfs_alloc_file_space(ip, round_up(offset, blksize),
+				     round_down(offset + len, blksize) -
+				     round_up(offset, blksize),
+				     XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT);
 
-	return xfs_alloc_file_space(ip, round_down(offset, blksize),
-				     round_up(offset + len, blksize) -
-				     round_down(offset, blksize),
-				     XFS_BMAPI_PREALLOC);
+	error = xfs_zero_range(ip, offset, len);
+
+	return error;
 }
 
 static int
