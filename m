Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15953 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730913AbeKTHbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:31:04 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj7-0000Xb-5W
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gOqj7-0002G8-48
        for linux-xfs@vger.kernel.org; Tue, 20 Nov 2018 08:05:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: flush removing page cache in xfs_reflink_remap_prep
Date: Tue, 20 Nov 2018 08:04:59 +1100
Message-Id: <20181119210459.8506-8-david@fromorbit.com>
In-Reply-To: <20181119210459.8506-1-david@fromorbit.com>
References: <20181119210459.8506-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

On a sub-page block size filesystem, fsx is failing with a data
corruption after a series of operations involving copying a file
with the destination offset beyond EOF of the destination of the file:

8093(157 mod 256): TRUNCATE DOWN        from 0x7a120 to 0x50000 ******WWWW
8094(158 mod 256): INSERT 0x25000 thru 0x25fff  (0x1000 bytes)
8095(159 mod 256): COPY 0x18000 thru 0x1afff    (0x3000 bytes) to 0x2f400
8096(160 mod 256): WRITE    0x5da00 thru 0x651ff        (0x7800 bytes) HOLE
8097(161 mod 256): COPY 0x2000 thru 0x5fff      (0x4000 bytes) to 0x6fc00

The second copy here is beyond EOF, and it is to sub-page (4k) but
block aligned (1k) offset. The clone runs the EOF zeroing, landing
in a pre-existing post-eof delalloc extent. This zeroes the post-eof
extents in the page cache just fine, dirtying the pages correctly.

The problem is that xfs_reflink_remap_prep() now truncates the page
cache over the range that it is copying it to, and rounds that down
to cover the entire start page. This removes the dirty page over the
delalloc extent from the page cache without having written it back.
Hence later, when the page cache is flushed, the page at offset
0x6f000 has not been written back and hence exposes stale data,
which fsx trips over less than 10 operations later.

Fix this by changing xfs_reflink_remap_prep() to use
xfs_flush_unmap_range().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |  2 +-
 fs/xfs/xfs_bmap_util.h |  3 +++
 fs/xfs/xfs_reflink.c   | 17 +++++++++++++----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cc7a0d47c529..3e66cf0520a9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1042,7 +1042,7 @@ xfs_unmap_extent(
 	goto out_unlock;
 }
 
-static int
+int
 xfs_flush_unmap_range(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 87363d136bb6..7a78229cf1a7 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -80,4 +80,7 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 			  int whichfork, xfs_extnum_t *nextents,
 			  xfs_filblks_t *count);
 
+int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
+			      xfs_off_t len);
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ecdb086bc23e..a41590b7c229 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1351,10 +1351,19 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
-	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data,
-			round_down(pos_out, PAGE_SIZE),
-			round_up(pos_out + *len, PAGE_SIZE) - 1);
+	/*
+	 * If pos_out > EOF, we make have dirtied blocks between EOF and
+	 * pos_out. In that case, we need to extend the flush and unmap to cover
+	 * from EOF to the end of the copy length.
+	 */
+	if (pos_out > XFS_ISIZE(dest)) {
+		loff_t	flen = *len + (pos_out - XFS_ISIZE(dest));
+		ret = xfs_flush_unmap_range(dest, XFS_ISIZE(dest), flen);
+	} else {
+		ret = xfs_flush_unmap_range(dest, pos_out, *len);
+	}
+	if (ret)
+		goto out_unlock;
 
 	return 1;
 out_unlock:
-- 
2.19.1
