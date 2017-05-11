Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:60666 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932212AbdEKMtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 08:49:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs: avoid harmless gcc-7 warnings
Date: Thu, 11 May 2017 14:49:21 +0200
Message-Id: <20170511124932.226016-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Calvin Owens <calvinowens@fb.com>, linux-kernel@vger.kernel.org

gcc-7 flags the use of integer math inside of a condition
as a potential bug:

fs/xfs/xfs_bmap_util.c: In function 'xfs_swap_extents_check_format':
fs/xfs/xfs_bmap_util.c:1619:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
fs/xfs/xfs_bmap_util.c:1629:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]

This one is clearly fine, and we can add a comparison to zero
to shut up the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_bmap_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2b954308a1d6..cbd3ffe42f39 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1613,7 +1613,7 @@ xfs_swap_extents_check_format(
 	 * extent format...
 	 */
 	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		if (XFS_IFORK_BOFF(ip) &&
+		if ((XFS_IFORK_BOFF(ip) != 0) &&
 		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
 			return -EINVAL;
 		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
@@ -1623,7 +1623,7 @@ xfs_swap_extents_check_format(
 
 	/* Reciprocal target->temp btree format checks */
 	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
-		if (XFS_IFORK_BOFF(tip) &&
+		if ((XFS_IFORK_BOFF(tip) != 0) &&
 		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
 			return -EINVAL;
 		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
-- 
2.9.0

